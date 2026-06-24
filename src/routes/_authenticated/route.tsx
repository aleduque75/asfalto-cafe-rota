import { createFileRoute, Outlet, redirect, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Toaster, toast } from "sonner";
import logo from "@/assets/logo-badge.png";
import { LogOut, Bike, ShieldCheck, LayoutDashboard, Settings } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";

export const Route = createFileRoute("/_authenticated")({
  ssr: false,
  beforeLoad: async () => {
    const { data, error } = await supabase.auth.getUser();
    if (error || !data.user) throw redirect({ to: "/auth" });
    return { user: data.user };
  },
  component: AuthenticatedLayout,
});

function AuthenticatedLayout() {
  const navigate = useNavigate();
  const [isAdmin, setIsAdmin] = useState(false);
  const [settingsOpen, setSettingsOpen] = useState(false);
  const [whatsapp, setWhatsapp] = useState("");
  const [savingSettings, setSavingSettings] = useState(false);

  useEffect(() => {
    (async () => {
      const { data: u } = await supabase.auth.getUser();
      if (!u.user) return;
      const { data } = await supabase
        .from("user_roles")
        .select("role")
        .eq("user_id", u.user.id)
        .eq("role", "admin")
        .maybeSingle();
      setIsAdmin(!!data);

      const { data: profile } = await supabase
        .from("profiles")
        .select("phone")
        .eq("id", u.user.id)
        .maybeSingle();
      if (profile && profile.phone) {
        setWhatsapp(profile.phone);
      }
    })();
  }, []);

  async function signOut() {
    await supabase.auth.signOut();
    navigate({ to: "/auth", replace: true });
  }

  async function saveSettings(e: React.FormEvent) {
    e.preventDefault();
    setSavingSettings(true);
    const { data: u } = await supabase.auth.getUser();
    if (u.user) {
      // Clean phone number (remove non-digits)
      let cleanPhone = whatsapp.replace(/\D/g, "");
      // Auto-prepend 55 for Brazil if user only typed DDD + number (10 or 11 digits)
      if (cleanPhone.length === 10 || cleanPhone.length === 11) {
        cleanPhone = "55" + cleanPhone;
      }
      
      const { error } = await supabase
        .from("profiles")
        .update({ phone: cleanPhone })
        .eq("id", u.user.id);
      
      if (error) {
        toast.error("Erro ao salvar número. Certifique-se de que criou a coluna no banco.");
      } else {
        toast.success("Configurações salvas!");
        setSettingsOpen(false);
      }
    }
    setSavingSettings(false);
  }

  return (
    <div className="min-h-screen" style={{ background: "var(--cream)" }}>
      <header className="border-b border-leather/20 bg-coffee">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <Link to="/dashboard" className="flex items-center gap-3">
            <img src={logo} alt="" className="h-10 w-10 rounded-full ring-2 ring-copper/40" />
            <div className="hidden sm:flex flex-col leading-none">
              <span className="text-[10px] uppercase tracking-[0.25em] text-copper">Área do membro</span>
              <span className="font-display text-cream text-base" style={{ fontFamily: "var(--font-display)" }}>
                Minha Garagem
              </span>
            </div>
          </Link>
          <nav className="flex items-center gap-2">
            <Link
              to="/dashboard"
              className="hidden sm:inline-flex items-center gap-2 px-3 py-2 text-sm uppercase tracking-[0.18em] text-cream/80 hover:text-copper"
              style={{ fontFamily: "var(--font-display)" }}
            >
              <LayoutDashboard className="h-4 w-4" /> Painel
            </Link>
            <Link
              to="/garagem"
              className="hidden sm:inline-flex items-center gap-2 px-3 py-2 text-sm uppercase tracking-[0.18em] text-cream/80 hover:text-copper"
              style={{ fontFamily: "var(--font-display)" }}
            >
              <Bike className="h-4 w-4" /> Motos
            </Link>
            {isAdmin && (
              <Link
                to="/admin"
                className="hidden sm:inline-flex items-center gap-2 px-3 py-2 text-sm uppercase tracking-[0.18em] text-cream/80 hover:text-copper"
                style={{ fontFamily: "var(--font-display)" }}
              >
                <ShieldCheck className="h-4 w-4" /> Admin
              </Link>
            )}
            <Link to="/" className="hidden sm:inline-block text-xs text-cream/70 hover:text-copper px-3">
              Site
            </Link>
            <Dialog open={settingsOpen} onOpenChange={setSettingsOpen}>
              <DialogTrigger asChild>
                <Button variant="ghost" size="icon" className="text-cream/80 hover:text-copper hover:bg-transparent">
                  <Settings className="h-5 w-5" />
                </Button>
              </DialogTrigger>
              <DialogContent className="max-w-md">
                <DialogHeader>
                  <DialogTitle>Configurações da Conta</DialogTitle>
                  <DialogDescription>Configure alertas e notificações.</DialogDescription>
                </DialogHeader>
                <form onSubmit={saveSettings} className="space-y-4">
                  <div>
                    <Label>WhatsApp para Alertas (com DDD)</Label>
                    <Input 
                      type="tel" 
                      placeholder="Ex: 11999999999" 
                      value={whatsapp} 
                      onChange={(e) => setWhatsapp(e.target.value)} 
                    />
                    <p className="text-xs text-leather mt-1">O robô enviará avisos automáticos de manutenção para este número.</p>
                  </div>
                  <DialogFooter>
                    <Button type="submit" className="btn-copper" disabled={savingSettings}>
                      {savingSettings ? "Salvando..." : "Salvar"}
                    </Button>
                  </DialogFooter>
                </form>
              </DialogContent>
            </Dialog>
            <Button variant="outline" size="sm" onClick={signOut} className="border-copper/50 text-cream hover:bg-leather/40 hover:text-cream bg-transparent ml-2">
              <LogOut className="h-4 w-4 sm:mr-1" /> <span className="hidden sm:inline">Sair</span>
            </Button>
          </nav>
        </div>
      </header>
      <main className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-8">
        <Outlet />
      </main>
      <Toaster />
    </div>
  );
}