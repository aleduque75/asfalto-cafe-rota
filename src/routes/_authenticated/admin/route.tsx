import { createFileRoute, Outlet, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Newspaper, Image as ImageIcon, FileText, ShieldCheck, Loader2 } from "lucide-react";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/admin")({
  component: AdminLayout,
});

function AdminLayout() {
  const navigate = useNavigate();
  const [state, setState] = useState<"loading" | "ok" | "denied">("loading");
  const [claiming, setClaiming] = useState(false);

  async function check() {
    const { data: u } = await supabase.auth.getUser();
    if (!u.user) return navigate({ to: "/auth" });
    const { data, error } = await supabase
      .from("user_roles")
      .select("role")
      .eq("user_id", u.user.id)
      .eq("role", "admin")
      .maybeSingle();
    if (error) {
      toast.error(error.message);
      setState("denied");
      return;
    }
    setState(data ? "ok" : "denied");
  }

  useEffect(() => {
    check();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function claim() {
    setClaiming(true);
    const { data, error } = await supabase.rpc("claim_admin_if_first");
    setClaiming(false);
    if (error) return toast.error(error.message);
    if (data === true) {
      toast.success("Você agora é administrador!");
      check();
    } else {
      toast.error("Já existe um administrador. Peça acesso a ele.");
    }
  }

  if (state === "loading") {
    return (
      <div className="flex items-center justify-center py-24 text-leather">
        <Loader2 className="h-6 w-6 animate-spin" />
      </div>
    );
  }

  if (state === "denied") {
    return (
      <div className="max-w-md mx-auto py-16 text-center">
        <ShieldCheck className="h-12 w-12 mx-auto text-copper mb-4" />
        <h2 className="text-2xl font-display mb-2" style={{ fontFamily: "var(--font-display)" }}>
          Acesso restrito
        </h2>
        <p className="text-leather/80 mb-6">
          Este painel é para administradores do clube. Se você é o fundador e ninguém ainda foi cadastrado,
          assuma o painel agora.
        </p>
        <Button onClick={claim} disabled={claiming}>
          {claiming ? "Verificando..." : "Tornar-me administrador"}
        </Button>
      </div>
    );
  }

  return (
    <div className="grid lg:grid-cols-[220px_1fr] gap-8">
      <aside className="lg:sticky lg:top-24 self-start">
        <p className="text-[10px] uppercase tracking-[0.3em] text-copper mb-3" style={{ fontFamily: "var(--font-display)" }}>
          Painel admin
        </p>
        <nav className="flex lg:flex-col gap-1 overflow-x-auto">
          <AdminLink to="/admin" icon={<ShieldCheck className="h-4 w-4" />}>Visão geral</AdminLink>
          <AdminLink to="/admin/noticias" icon={<Newspaper className="h-4 w-4" />}>Notícias</AdminLink>
          <AdminLink to="/admin/galeria" icon={<ImageIcon className="h-4 w-4" />}>Galeria</AdminLink>
          <AdminLink to="/admin/conteudo" icon={<FileText className="h-4 w-4" />}>Conteúdo do site</AdminLink>
        </nav>
      </aside>
      <section className="min-w-0">
        <Outlet />
      </section>
    </div>
  );
}

function AdminLink({ to, icon, children }: { to: string; icon: React.ReactNode; children: React.ReactNode }) {
  return (
    <Link
      to={to}
      activeOptions={{ exact: to === "/admin" }}
      className="inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm text-leather hover:bg-coffee/5 transition whitespace-nowrap"
      activeProps={{ className: "bg-coffee text-cream hover:bg-coffee" }}
    >
      {icon}
      {children}
    </Link>
  );
}