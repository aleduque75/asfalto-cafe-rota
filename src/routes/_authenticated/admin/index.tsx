import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Newspaper, Image as ImageIcon, FileText } from "lucide-react";

export const Route = createFileRoute("/_authenticated/admin/")({
  component: AdminHome,
});

function AdminHome() {
  const [counts, setCounts] = useState({ news: 0, newsDraft: 0, gallery: 0, galleryDraft: 0 });

  useEffect(() => {
    (async () => {
      const [n, nd, g, gd] = await Promise.all([
        supabase.from("news").select("*", { count: "exact", head: true }).eq("status", "published"),
        supabase.from("news").select("*", { count: "exact", head: true }).eq("status", "draft"),
        supabase.from("gallery_items").select("*", { count: "exact", head: true }).eq("status", "published"),
        supabase.from("gallery_items").select("*", { count: "exact", head: true }).eq("status", "draft"),
      ]);
      setCounts({ news: n.count ?? 0, newsDraft: nd.count ?? 0, gallery: g.count ?? 0, galleryDraft: gd.count ?? 0 });
    })();
  }, []);

  return (
    <div className="space-y-6">
      <div>
        <p className="text-xs uppercase tracking-[0.25em] text-copper mb-2">Painel administrativo</p>
        <h1 className="text-3xl md:text-4xl font-display text-coffee" style={{ fontFamily: "var(--font-display)" }}>
          Visão geral
        </h1>
        <p className="text-leather/80 mt-2">Gerencie o conteúdo público do site.</p>
      </div>
      <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
        <Stat icon={<Newspaper className="h-5 w-5" />} label="Notícias publicadas" value={counts.news} sub={`${counts.newsDraft} rascunho(s)`} to="/admin/noticias" />
        <Stat icon={<ImageIcon className="h-5 w-5" />} label="Galeria publicada" value={counts.gallery} sub={`${counts.galleryDraft} rascunho(s)`} to="/admin/galeria" />
        <Stat icon={<FileText className="h-5 w-5" />} label="Conteúdo do site" value="—" sub="Hero, história, etc." to="/admin/conteudo" />
      </div>
    </div>
  );
}

function Stat({ icon, label, value, sub, to }: { icon: React.ReactNode; label: string; value: number | string; sub: string; to: string }) {
  return (
    <Link to={to} className="block">
      <Card className="border-leather/30 bg-cream hover:border-copper hover:shadow-lg transition">
        <CardHeader className="pb-2 flex flex-row items-center justify-between space-y-0">
          <CardTitle className="text-sm font-medium text-leather">{label}</CardTitle>
          <span className="text-copper">{icon}</span>
        </CardHeader>
        <CardContent>
          <div className="text-3xl font-display text-coffee" style={{ fontFamily: "var(--font-display)" }}>{value}</div>
          <p className="text-xs text-leather/70 mt-1">{sub}</p>
        </CardContent>
      </Card>
    </Link>
  );
}