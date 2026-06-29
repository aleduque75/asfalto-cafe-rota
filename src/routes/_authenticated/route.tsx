import { createFileRoute, Outlet, redirect, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Toaster, toast } from "sonner";
import logo from "@/assets/logo-badge.png";
import { LogOut, Settings, Bike, LayoutDashboard, ShieldCheck, Menu, Map, Users, Newspaper, Image as ImageIcon, FileText, Vote } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet";

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
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [logoUrl, setLogoUrl] = useState<string | null>(null);

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

      const { data: contentData } = await supabase
        .from("site_content")
        .select("value")
        .eq("key", "general")
        .maybeSingle();
      
      if (contentData?.value && typeof contentData.value === 'object' && 'logo_url' in contentData.value) {
        setLogoUrl((contentData.value as any).logo_url);
      }
    })();
  }, []);

  async function signOut() {
    await supabase.auth.signOut();
    navigate({ to: "/auth", replace: true });
  }

  return (
    <div className="min-h-screen" style={{ background: "var(--cream)" }}>
      <header className="border-b border-leather/20 bg-coffee">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <Link to="/dashboard" className="flex items-center gap-3 group">
            <img src={logoUrl || logo} alt="" className="h-10 w-10 object-contain transition-transform group-hover:scale-105" />
            <div className="flex flex-col leading-none">
              <span className="text-[10px] uppercase tracking-[0.25em] text-copper">Área do membro</span>
              <span className="font-display text-cream text-base" style={{ fontFamily: "var(--font-display)" }}>
                Minha Garagem
              </span>
            </div>
          </Link>
          <nav className="flex items-center gap-2">
            {/* Menu */}
            <div className="flex items-center">
              <Sheet open={mobileMenuOpen} onOpenChange={setMobileMenuOpen}>
                <SheetTrigger asChild>
                  <Button variant="ghost" size="icon" className="text-cream hover:text-copper hover:bg-transparent">
                    <Menu className="h-6 w-6" />
                  </Button>
                </SheetTrigger>
                <SheetContent side="right" className="bg-coffee border-leather/20 text-cream p-6 w-[280px] flex flex-col">
                  <SheetHeader className="text-left mb-8 mt-4 shrink-0">
                    <SheetTitle className="text-copper font-display uppercase tracking-widest text-lg" style={{ fontFamily: "var(--font-display)" }}>
                      Menu
                    </SheetTitle>
                  </SheetHeader>
                  <div className="flex flex-col gap-6 overflow-y-auto flex-1 pb-12 [&::-webkit-scrollbar]:hidden [-ms-overflow-style:none] [scrollbar-width:none]">
                    <Link to="/dashboard" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                      <LayoutDashboard className="h-5 w-5" /> Painel Principal
                    </Link>
                    <Link to="/garagem" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                      <Bike className="h-5 w-5" /> Minha Garagem
                    </Link>
                    <Link to="/rotas" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                      <Map className="h-5 w-5" /> Rotas e Passeios
                    </Link>
                    <Link to="/rotas" search={{ tab: "completed" }} onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                      <ImageIcon className="h-5 w-5" /> Galeria de Fotos
                    </Link>
                    <Link to="/enquetes" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                      <Vote className="h-5 w-5" /> Enquetes
                    </Link>
                    {isAdmin && (
                      <div className="flex flex-col gap-3 pt-2 pb-2">
                        <p className="text-xs uppercase tracking-[0.2em] text-copper/80 font-bold mb-1" style={{ fontFamily: "var(--font-display)" }}>
                          Administração
                        </p>
                        <Link to="/admin" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                          <ShieldCheck className="h-5 w-5" /> Visão Geral
                        </Link>
                        <Link to="/admin/usuarios" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                          <Users className="h-5 w-5" /> Usuários
                        </Link>
                        <Link to="/admin/rotas" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                          <Map className="h-5 w-5" /> Rotas
                        </Link>
                        <Link to="/admin/blog" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                          <Newspaper className="h-5 w-5" /> Blog
                        </Link>
                        <Link to="/admin/galeria" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                          <ImageIcon className="h-5 w-5" /> Galeria
                        </Link>
                        <Link to="/admin/enquetes" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                          <Vote className="h-5 w-5" /> Enquetes
                        </Link>
                        <Link to="/admin/conteudo" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                          <FileText className="h-5 w-5" /> Conteúdo do site
                        </Link>
                        <div className="h-px bg-border/30 my-2" />
                      </div>
                    )}
                    <Link to="/perfil" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                      <Settings className="h-5 w-5" /> Meu Perfil
                    </Link>
                    <div className="h-px w-full bg-leather/20 my-2"></div>
                    <Link to="/" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/70 hover:text-copper">
                      Ver Site
                    </Link>
                    <button onClick={() => { setMobileMenuOpen(false); signOut(); }} className="flex items-center gap-3 text-base text-destructive hover:text-destructive/80 mt-2">
                      <LogOut className="h-5 w-5" /> Sair da conta
                    </button>
                  </div>
                </SheetContent>
              </Sheet>
            </div>
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