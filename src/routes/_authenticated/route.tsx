import { createFileRoute, Outlet, redirect, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Toaster } from "@/components/ui/sonner";
import logo from "@/assets/logo-badge.png";
import { LogOut, Bike, ShieldCheck, LayoutDashboard } from "lucide-react";
import { Button } from "@/components/ui/button";

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
            <Link to="/" className="text-xs text-cream/70 hover:text-copper px-3">
              Site
            </Link>
            <Button variant="outline" size="sm" onClick={signOut} className="border-copper/50 text-cream hover:bg-leather/40 hover:text-cream bg-transparent">
              <LogOut className="h-4 w-4 mr-1" /> Sair
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