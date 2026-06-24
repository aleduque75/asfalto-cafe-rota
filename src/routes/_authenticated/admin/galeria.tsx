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
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import { Plus, Pencil, Trash2, Loader2 } from "lucide-react";
import { uploadMedia } from "@/lib/upload";
import type { Tables, TablesInsert } from "@/integrations/supabase/types";

type Item = Tables<"gallery_items">;

export const Route = createFileRoute("/_authenticated/admin/galeria")({
  component: AdminGaleria,
});

const EMPTY: Partial<Item> = {
  title: "", caption: "", image_url: "", instagram_url: "", sort_order: 0, status: "draft",
};

function AdminGaleria() {
  const [items, setItems] = useState<Item[]>([]);
  const [loading, setLoading] = useState(true);
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Partial<Item>>(EMPTY);
  const [saving, setSaving] = useState(false);
  const [uploading, setUploading] = useState(false);

  async function load() {
    setLoading(true);
    const { data, error } = await supabase
      .from("gallery_items")
      .select("*")
      .order("sort_order", { ascending: true })
      .order("created_at", { ascending: false });
    setLoading(false);
    if (error) return toast.error(error.message);
    setItems(data ?? []);
  }
  useEffect(() => { load(); }, []);

  function startNew() { setEditing(EMPTY); setOpen(true); }
  function startEdit(i: Item) { setEditing(i); setOpen(true); }

  async function handleFile(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploading(true);
    try {
      const url = await uploadMedia(file, "gallery");
      setEditing((p) => ({ ...p, image_url: url }));
      toast.success("Imagem enviada");
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : String(err);
      toast.error(msg);
    } finally { setUploading(false); }
  }

  async function save() {
    if (!editing.image_url) return toast.error("Envie uma imagem");
    setSaving(true);
    const payload: TablesInsert<"gallery_items"> = {
      title: editing.title?.trim() || null,
      caption: editing.caption?.trim() || null,
      image_url: editing.image_url,
      instagram_url: editing.instagram_url?.trim() || null,
      sort_order: editing.sort_order ?? 0,
      status: editing.status ?? "draft",
    };
    const res = editing.id
      ? await supabase.from("gallery_items").update(payload).eq("id", editing.id)
      : await supabase.from("gallery_items").insert(payload);
    setSaving(false);
    if (res.error) return toast.error(res.error.message);
    toast.success("Salvo");
    setOpen(false);
    load();
  }

  async function remove(id: string) {
    if (!confirm("Excluir esta imagem?")) return;
    const { error } = await supabase.from("gallery_items").delete().eq("id", id);
    if (error) return toast.error(error.message);
    toast.success("Excluído");
    load();
  }

  async function togglePublish(i: Item) {
    const next = i.status === "published" ? "draft" : "published";
    const { error } = await supabase.from("gallery_items").update({ status: next }).eq("id", i.id);
    if (error) return toast.error(error.message);
    load();
  }

  return (
    <div className="space-y-6">
      <div className="flex items-end justify-between gap-4 flex-wrap">
        <div>
          <h1 className="text-3xl md:text-4xl font-display" style={{ fontFamily: "var(--font-display)" }}>Galeria</h1>
          <p className="text-leather/70 mt-1">Fotos exibidas na seção Galeria da landing.</p>
        </div>
        <Dialog open={open} onOpenChange={setOpen}>
          <DialogTrigger asChild><Button onClick={startNew}><Plus className="h-4 w-4 mr-1" /> Nova foto</Button></DialogTrigger>
          <DialogContent className="max-w-xl max-h-[90vh] overflow-y-auto">
            <DialogHeader><DialogTitle>{editing.id ? "Editar foto" : "Nova foto"}</DialogTitle></DialogHeader>
            <div className="space-y-4">
              <div>
                <Label>Imagem</Label>
                <div className="flex items-center gap-3">
                  <Input type="file" accept="image/*" onChange={handleFile} disabled={uploading} />
                  {uploading && <Loader2 className="h-4 w-4 animate-spin" />}
                </div>
                {editing.image_url && (
                  <img src={editing.image_url} alt="" className="mt-2 h-40 rounded border border-leather/30 object-cover" />
                )}
              </div>
              <div>
                <Label>Título</Label>
                <Input value={editing.title ?? ""} onChange={(e) => setEditing((p) => ({ ...p, title: e.target.value }))} />
              </div>
              <div>
                <Label>Legenda</Label>
                <Textarea rows={2} value={editing.caption ?? ""} onChange={(e) => setEditing((p) => ({ ...p, caption: e.target.value }))} />
              </div>
              <div className="grid sm:grid-cols-2 gap-4">
                <div>
                  <Label>Link do Instagram</Label>
                  <Input value={editing.instagram_url ?? ""} onChange={(e) => setEditing((p) => ({ ...p, instagram_url: e.target.value }))} placeholder="https://instagram.com/p/..." />
                </div>
                <div>
                  <Label>Ordem</Label>
                  <Input type="number" value={editing.sort_order ?? 0} onChange={(e) => setEditing((p) => ({ ...p, sort_order: Number(e.target.value) }))} />
                </div>
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
              <Button onClick={save} disabled={saving || uploading}>{saving ? "Salvando..." : "Salvar"}</Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>

      {loading ? (
        <div className="p-8 text-center text-leather/70"><Loader2 className="h-5 w-5 animate-spin inline" /></div>
      ) : items.length === 0 ? (
        <div className="p-8 text-center text-leather/70 border border-dashed border-leather/30 rounded-lg">Nenhuma foto ainda.</div>
      ) : (
        <div className="grid sm:grid-cols-2 md:grid-cols-3 gap-4">
          {items.map((i) => (
            <div key={i.id} className="border border-leather/30 rounded-lg overflow-hidden bg-cream shadow-sm">
              <div className="aspect-square overflow-hidden bg-leather/10">
                <img src={i.image_url} alt={i.title ?? ""} className="h-full w-full object-cover" />
              </div>
              <div className="p-3 space-y-2">
                <div className="flex items-center justify-between gap-2">
                  <div className="text-sm font-medium truncate">{i.title || "Sem título"}</div>
                  <Badge variant={i.status === "published" ? "default" : "secondary"} className="cursor-pointer shrink-0" onClick={() => togglePublish(i)}>
                    {i.status === "published" ? "Publicado" : "Rascunho"}
                  </Badge>
                </div>
                {i.caption && <p className="text-xs text-leather/70 line-clamp-2">{i.caption}</p>}
                <div className="flex justify-end gap-1">
                  <Button size="icon" variant="ghost" onClick={() => startEdit(i)}><Pencil className="h-4 w-4" /></Button>
                  <Button size="icon" variant="ghost" onClick={() => remove(i.id)}><Trash2 className="h-4 w-4 text-destructive" /></Button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}