import { createFileRoute, Outlet, redirect, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Toaster, toast } from "sonner";
import logo from "@/assets/logo-badge.png";
import { LogOut, Bike, ShieldCheck, LayoutDashboard, Settings, Menu } from "lucide-react";
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
            <Link to="/perfil" className="hidden sm:flex text-cream/80 hover:text-copper items-center justify-center p-2">
              <Settings className="h-5 w-5" />
            </Link>
            <Button variant="outline" size="sm" onClick={signOut} className="hidden sm:inline-flex border-copper/50 text-cream hover:bg-leather/40 hover:text-cream bg-transparent ml-2">
              <LogOut className="h-4 w-4 mr-1" /> Sair
            </Button>

            {/* Mobile Menu */}
            <div className="sm:hidden flex items-center">
              <Sheet open={mobileMenuOpen} onOpenChange={setMobileMenuOpen}>
                <SheetTrigger asChild>
                  <Button variant="ghost" size="icon" className="text-cream hover:text-copper hover:bg-transparent">
                    <Menu className="h-6 w-6" />
                  </Button>
                </SheetTrigger>
                <SheetContent side="right" className="bg-coffee border-leather/20 text-cream p-6 w-[280px]">
                  <SheetHeader className="text-left mb-8 mt-4">
                    <SheetTitle className="text-copper font-display uppercase tracking-widest text-lg" style={{ fontFamily: "var(--font-display)" }}>
                      Menu
                    </SheetTitle>
                  </SheetHeader>
                  <div className="flex flex-col gap-6">
                    <Link to="/dashboard" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                      <LayoutDashboard className="h-5 w-5" /> Painel Principal
                    </Link>
                    <Link to="/garagem" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                      <Bike className="h-5 w-5" /> Minha Garagem
                    </Link>
                    {isAdmin && (
                      <Link to="/admin" onClick={() => setMobileMenuOpen(false)} className="flex items-center gap-3 text-base text-cream/90 hover:text-copper">
                        <ShieldCheck className="h-5 w-5" /> Painel Admin
                      </Link>
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