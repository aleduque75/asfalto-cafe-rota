import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { toast } from "sonner";
import { Pencil, Plus, Trash2, Loader2, Upload } from "lucide-react";
import type { Tables } from "@/integrations/supabase/types";

type News = Tables<"news">;

export const Route = createFileRoute("/_authenticated/admin/blog/")({
  component: AdminBlogList,
});

function AdminBlogList() {
  const [items, setItems] = useState<News[]>([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  async function load() {
    setLoading(true);
    const { data, error } = await supabase
      .from("news")
      .select("*")
      .order("created_at", { ascending: false });
    setLoading(false);
    if (error) return toast.error(error.message);
    setItems(data ?? []);
  }

  useEffect(() => { load(); }, []);

  async function remove(id: string) {
    if (!confirm("Excluir este post?")) return;
    const { error } = await supabase.from("news").delete().eq("id", id);
    if (error) return toast.error(error.message);
    toast.success("Post excluído");
    load();
  }

  async function togglePublish(n: News) {
    const next = n.status === "published" ? "draft" : "published";
    const { error } = await supabase
      .from("news")
      .update({ status: next, published_at: next === "published" ? new Date().toISOString() : null })
      .eq("id", n.id);
    if (error) return toast.error(error.message);
    toast.success(next === "published" ? "Publicado" : "Despublicado");
    load();
  }

  return (
    <div className="space-y-6">
      <div className="flex items-end justify-between gap-4 flex-wrap">
        <div>
          <h1 className="text-3xl md:text-4xl font-display text-coffee" style={{ fontFamily: "var(--font-display)" }}>Blog</h1>
          <p className="text-leather/70 mt-1">Gerencie as postagens e relatos do clube.</p>
        </div>
        <Button asChild>
          <Link to="/admin/blog/$id" params={{ id: "new" }}>
            <Plus className="h-4 w-4 mr-1" /> Novo post
          </Link>
        </Button>
      </div>

      <div className="border border-leather/30 rounded-lg bg-cream shadow-sm">
        {loading ? (
          <div className="p-8 text-center text-leather/70"><Loader2 className="h-5 w-5 animate-spin inline" /></div>
        ) : items.length === 0 ? (
          <div className="p-8 text-center text-leather/70">Nenhum post ainda. Clique em "Novo post".</div>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Título</TableHead>
                <TableHead className="hidden md:table-cell">Tag</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Ações</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {items.map((n) => (
                <TableRow key={n.id}>
                  <TableCell className="font-medium">
                    <div className="flex items-center gap-3">
                      {n.cover_url && <img src={n.cover_url} alt="" className="h-10 w-10 rounded object-cover" />}
                      <div className="min-w-0">
                        <div className="truncate text-coffee">{n.title}</div>
                        <div className="text-xs text-leather/60 truncate">/{n.slug}</div>
                      </div>
                    </div>
                  </TableCell>
                  <TableCell className="hidden md:table-cell text-leather/80">{n.tag ?? "—"}</TableCell>
                  <TableCell>
                    <Badge
                      variant={n.status === "published" ? "default" : "secondary"}
                      className="cursor-pointer"
                      onClick={() => togglePublish(n)}
                    >
                      {n.status === "published" ? "Publicado" : "Rascunho"}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right space-x-1 sm:space-x-2 whitespace-nowrap">
                    <Button size="icon" variant="default" className="shrink-0" onClick={() => navigate({ to: "/admin/blog/$id", params: { id: n.id } })}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button size="icon" variant="ghost" className="shrink-0" onClick={() => remove(n.id)}>
                      <Trash2 className="h-4 w-4 text-destructive" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </div>
      <p className="text-xs text-leather/50 flex items-center gap-1"><Upload className="h-3 w-3" /> Clique no status na tabela para publicar/despublicar rapidamente.</p>
    </div>
  );
}
