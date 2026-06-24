import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import {
  Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger,
} from "@/components/ui/dialog";
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from "@/components/ui/table";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import { Pencil, Plus, Trash2, Loader2, Upload } from "lucide-react";
import { uploadMedia, slugify } from "@/lib/upload";
import type { Tables, TablesInsert } from "@/integrations/supabase/types";

type News = Tables<"news">;

export const Route = createFileRoute("/_authenticated/admin/noticias")({
  component: AdminNoticias,
});

const EMPTY: Partial<News> = {
  title: "", slug: "", excerpt: "", content: "", cover_url: "", tag: "", status: "draft",
};

function AdminNoticias() {
  const [items, setItems] = useState<News[]>([]);
  const [loading, setLoading] = useState(true);
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Partial<News>>(EMPTY);
  const [saving, setSaving] = useState(false);
  const [uploading, setUploading] = useState(false);

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

  function startNew() { setEditing(EMPTY); setOpen(true); }
  function startEdit(n: News) { setEditing(n); setOpen(true); }

  async function handleFile(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploading(true);
    try {
      const url = await uploadMedia(file, "news");
      setEditing((p) => ({ ...p, cover_url: url }));
      toast.success("Imagem enviada");
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : String(err);
      toast.error(msg);
    } finally { setUploading(false); }
  }

  async function save() {
    if (!editing.title?.trim()) return toast.error("Informe um título");
    const slug = editing.slug?.trim() || slugify(editing.title);
    setSaving(true);
    const payload: TablesInsert<"news"> = {
      title: editing.title.trim(),
      slug,
      excerpt: editing.excerpt?.trim() || null,
      content: editing.content?.trim() || null,
      cover_url: editing.cover_url || null,
      tag: editing.tag?.trim() || null,
      status: editing.status ?? "draft",
      published_at: editing.status === "published" ? (editing.published_at ?? new Date().toISOString()) : null,
    };
    const res = editing.id
      ? await supabase.from("news").update(payload).eq("id", editing.id)
      : await supabase.from("news").insert(payload);
    setSaving(false);
    if (res.error) return toast.error(res.error.message);
    toast.success(editing.id ? "Notícia atualizada" : "Notícia criada");
    setOpen(false);
    load();
  }

  async function remove(id: string) {
    if (!confirm("Excluir esta notícia?")) return;
    const { error } = await supabase.from("news").delete().eq("id", id);
    if (error) return toast.error(error.message);
    toast.success("Notícia excluída");
    load();
  }

  async function togglePublish(n: News) {
    const next = n.status === "published" ? "draft" : "published";
    const { error } = await supabase
      .from("news")
      .update({ status: next, published_at: next === "published" ? new Date().toISOString() : null })
      .eq("id", n.id);
    if (error) return toast.error(error.message);
    toast.success(next === "published" ? "Publicada" : "Despublicada");
    load();
  }

  return (
    <div className="space-y-6">
      <div className="flex items-end justify-between gap-4 flex-wrap">
        <div>
          <h1 className="text-3xl md:text-4xl font-display" style={{ fontFamily: "var(--font-display)" }}>Notícias</h1>
          <p className="text-leather/70 mt-1">Postagens do blog e diário de bordo.</p>
        </div>
        <Dialog open={open} onOpenChange={setOpen}>
          <DialogTrigger asChild>
            <Button onClick={startNew}><Plus className="h-4 w-4 mr-1" /> Nova notícia</Button>
          </DialogTrigger>
          <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>{editing.id ? "Editar notícia" : "Nova notícia"}</DialogTitle>
            </DialogHeader>
            <div className="space-y-4">
              <div>
                <Label>Título</Label>
                <Input value={editing.title ?? ""} onChange={(e) => setEditing((p) => ({ ...p, title: e.target.value, slug: p.slug || slugify(e.target.value) }))} />
              </div>
              <div className="grid sm:grid-cols-2 gap-4">
                <div>
                  <Label>Slug</Label>
                  <Input value={editing.slug ?? ""} onChange={(e) => setEditing((p) => ({ ...p, slug: slugify(e.target.value) }))} />
                </div>
                <div>
                  <Label>Categoria/Tag</Label>
                  <Input value={editing.tag ?? ""} onChange={(e) => setEditing((p) => ({ ...p, tag: e.target.value }))} placeholder="Passeio, Cultura..." />
                </div>
              </div>
              <div>
                <Label>Resumo</Label>
                <Textarea rows={2} value={editing.excerpt ?? ""} onChange={(e) => setEditing((p) => ({ ...p, excerpt: e.target.value }))} />
              </div>
              <div>
                <Label>Conteúdo</Label>
                <Textarea rows={6} value={editing.content ?? ""} onChange={(e) => setEditing((p) => ({ ...p, content: e.target.value }))} />
              </div>
              <div>
                <Label>Imagem de capa</Label>
                <div className="flex items-center gap-3">
                  <Input type="file" accept="image/*" onChange={handleFile} disabled={uploading} />
                  {uploading && <Loader2 className="h-4 w-4 animate-spin" />}
                </div>
                {editing.cover_url && (
                  <img src={editing.cover_url} alt="" className="mt-2 h-32 rounded border border-leather/30 object-cover" />
                )}
              </div>
              <div>
                <Label>Status</Label>
                <Select value={editing.status ?? "draft"} onValueChange={(v) => setEditing((p) => ({ ...p, status: v as "draft" | "published" }))}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="draft">Rascunho</SelectItem>
                    <SelectItem value="published">Publicado</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
            <DialogFooter>
              <Button variant="outline" onClick={() => setOpen(false)}>Cancelar</Button>
              <Button onClick={save} disabled={saving || uploading}>
                {saving ? "Salvando..." : "Salvar"}
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>

      <div className="border border-leather/30 rounded-lg bg-cream shadow-sm">
        {loading ? (
          <div className="p-8 text-center text-leather/70"><Loader2 className="h-5 w-5 animate-spin inline" /></div>
        ) : items.length === 0 ? (
          <div className="p-8 text-center text-leather/70">Nenhuma notícia ainda. Clique em "Nova notícia".</div>
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
                        <div className="truncate">{n.title}</div>
                        <div className="text-xs text-leather/60 truncate">/{n.slug}</div>
                      </div>
                    </div>
                  </TableCell>
                  <TableCell className="hidden md:table-cell">{n.tag ?? "—"}</TableCell>
                  <TableCell>
                    <Badge
                      variant={n.status === "published" ? "default" : "secondary"}
                      className="cursor-pointer"
                      onClick={() => togglePublish(n)}
                    >
                      {n.status === "published" ? "Publicado" : "Rascunho"}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right space-x-2">
                    <Button size="icon" variant="ghost" onClick={() => startEdit(n)}><Pencil className="h-4 w-4" /></Button>
                    <Button size="icon" variant="ghost" onClick={() => remove(n.id)}><Trash2 className="h-4 w-4 text-destructive" /></Button>
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