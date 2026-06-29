import { createFileRoute, useNavigate, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { toast } from "sonner";
import { Loader2, Trash2, ArrowLeft, Image as ImageIcon } from "lucide-react";
import { uploadMedia, slugify } from "@/lib/upload";
import type { Tables, TablesInsert } from "@/integrations/supabase/types";

type News = Tables<"news">;

export type ContentBlock = {
  id: string;
  type: "paragraph" | "subtitle" | "image";
  value: string;
};

export const Route = createFileRoute("/_authenticated/admin/blog/$id")({
  component: AdminBlogEdit,
});

const EMPTY: Partial<News> = {
  title: "", slug: "", excerpt: "", content: "", cover_url: "", tag: "", status: "draft",
};

function AdminBlogEdit() {
  const { id } = Route.useParams();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(id !== "new");
  const [editing, setEditing] = useState<Partial<News>>({ ...EMPTY, published_at: new Date().toISOString() });
  const [blocks, setBlocks] = useState<ContentBlock[]>([]);
  const [saving, setSaving] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [uploadingBlockId, setUploadingBlockId] = useState<string | null>(null);

  useEffect(() => {
    if (id === "new") return;
    
    (async () => {
      setLoading(true);
      const { data, error } = await supabase.from("news").select("*").eq("id", id).single();
      setLoading(false);
      
      if (error) {
        toast.error("Erro ao carregar post");
        navigate({ to: "/admin/blog" });
        return;
      }
      
      if (data) {
        setEditing(data);
        let initialBlocks: ContentBlock[] = [];
        try {
          const parsed = JSON.parse(data.content || "[]");
          if (Array.isArray(parsed) && parsed.length > 0 && parsed[0].type) {
            initialBlocks = parsed.map(b => ({ ...b, id: b.id || crypto.randomUUID() }));
          } else if (data.content) {
            initialBlocks = [{ id: crypto.randomUUID(), type: "paragraph", value: data.content }];
          }
        } catch {
          if (data.content) initialBlocks = [{ id: crypto.randomUUID(), type: "paragraph", value: data.content }];
        }
        setBlocks(initialBlocks);
      }
    })();
  }, [id, navigate]);

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

  async function handleBlockFile(e: React.ChangeEvent<HTMLInputElement>, blockId: string) {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploadingBlockId(blockId);
    try {
      const url = await uploadMedia(file, "news-blocks");
      setBlocks(prev => prev.map(b => b.id === blockId ? { ...b, value: url } : b));
      toast.success("Imagem do bloco enviada");
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : String(err);
      toast.error(msg);
    } finally { setUploadingBlockId(null); }
  }

  function addBlock(type: ContentBlock["type"]) {
    setBlocks(prev => [...prev, { id: crypto.randomUUID(), type, value: "" }]);
  }

  function updateBlock(id: string, value: string) {
    setBlocks(prev => prev.map(b => b.id === id ? { ...b, value } : b));
  }

  function removeBlock(id: string) {
    setBlocks(prev => prev.filter(b => b.id !== id));
  }

  function moveBlock(index: number, direction: -1 | 1) {
    setBlocks(prev => {
      const newBlocks = [...prev];
      if (index + direction < 0 || index + direction >= newBlocks.length) return prev;
      const temp = newBlocks[index];
      newBlocks[index] = newBlocks[index + direction];
      newBlocks[index + direction] = temp;
      return newBlocks;
    });
  }

  async function save() {
    if (!editing.title?.trim()) return toast.error("Informe um título");
    const slug = editing.slug?.trim() || slugify(editing.title);
    setSaving(true);
    
    const payload: TablesInsert<"news"> = {
      title: editing.title.trim(),
      slug,
      excerpt: editing.excerpt?.trim() || null,
      content: blocks.length > 0 ? JSON.stringify(blocks) : null,
      cover_url: editing.cover_url || null,
      tag: editing.tag?.trim() || null,
      status: editing.status ?? "draft",
      published_at: editing.published_at || new Date().toISOString(),
    };
    
    const res = id !== "new"
      ? await supabase.from("news").update(payload).eq("id", id)
      : await supabase.from("news").insert(payload);
      
    setSaving(false);
    
    if (res.error) return toast.error(res.error.message);
    
    toast.success(id !== "new" ? "Post atualizado" : "Post criado");
    navigate({ to: "/admin/blog" });
  }

  if (loading) {
    return <div className="p-12 text-center text-leather/70"><Loader2 className="h-6 w-6 animate-spin mx-auto" /></div>;
  }

  return (
    <div className="space-y-6 max-w-4xl mx-auto pb-12">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => navigate({ to: "/admin/blog" })} className="shrink-0 text-leather">
          <ArrowLeft className="h-5 w-5" />
        </Button>
        <div>
          <h1 className="text-3xl md:text-4xl font-display text-coffee" style={{ fontFamily: "var(--font-display)" }}>
            {id === "new" ? "Novo Post" : "Editar Post"}
          </h1>
        </div>
      </div>

      <div className="bg-cream border border-leather/30 rounded-xl p-6 shadow-sm space-y-6">
        <div className="grid md:grid-cols-2 gap-6">
          <div className="space-y-4">
            <div>
              <Label className="text-coffee font-semibold">Título</Label>
              <Input 
                className="mt-1 bg-white"
                value={editing.title ?? ""} 
                onChange={(e) => setEditing((p) => ({ ...p, title: e.target.value, slug: p.slug || slugify(e.target.value) }))} 
                placeholder="Ex: Viagem para Cunha"
              />
            </div>
            
            <div className="grid grid-cols-2 gap-4">
              <div>
                <Label className="text-coffee font-semibold">Slug (URL)</Label>
                <Input 
                  className="mt-1 bg-white"
                  value={editing.slug ?? ""} 
                  onChange={(e) => setEditing((p) => ({ ...p, slug: slugify(e.target.value) }))} 
                />
              </div>
              <div>
                <Label className="text-coffee font-semibold">Tag/Categoria</Label>
                <Input 
                  className="mt-1 bg-white"
                  value={editing.tag ?? ""} 
                  onChange={(e) => setEditing((p) => ({ ...p, tag: e.target.value }))} 
                  placeholder="Passeio, Oficina..." 
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <Label className="text-coffee font-semibold">Status</Label>
                <Select value={editing.status ?? "draft"} onValueChange={(v) => setEditing((p) => ({ ...p, status: v as "draft" | "published" }))}>
                  <SelectTrigger className="mt-1 bg-white"><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="draft">Rascunho</SelectItem>
                    <SelectItem value="published">Publicado</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div>
                <Label className="text-coffee font-semibold">Data da Publicação</Label>
                <Input 
                  className="mt-1 bg-white"
                  type="date" 
                  value={editing.published_at ? editing.published_at.split('T')[0] : ''} 
                  onChange={(e) => {
                    const dateObj = new Date(e.target.value);
                    if (!isNaN(dateObj.getTime())) {
                      setEditing(p => ({ ...p, published_at: dateObj.toISOString() }));
                    }
                  }} 
                />
              </div>
            </div>
            
            <div>
              <Label className="text-coffee font-semibold">Resumo (opcional)</Label>
              <Textarea 
                className="mt-1 bg-white resize-none"
                rows={3} 
                value={editing.excerpt ?? ""} 
                onChange={(e) => setEditing((p) => ({ ...p, excerpt: e.target.value }))} 
                placeholder="Um pequeno texto instigante..."
              />
            </div>
          </div>
          
          <div className="space-y-4">
            <Label className="text-coffee font-semibold">Imagem de Capa</Label>
            
            {editing.cover_url ? (
              <div className="relative rounded-xl overflow-hidden border border-leather/30 aspect-video group">
                <img src={editing.cover_url} alt="Capa" className="w-full h-full object-cover" />
                <div className="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
                  <Label htmlFor="cover-upload" className="cursor-pointer bg-white text-coffee px-4 py-2 rounded-md font-medium shadow-lg hover:scale-105 transition">
                    Trocar Imagem
                  </Label>
                </div>
                <Input id="cover-upload" type="file" accept="image/*" className="hidden" onChange={handleFile} disabled={uploading} />
              </div>
            ) : (
              <div className="border-2 border-dashed border-leather/30 rounded-xl aspect-video flex flex-col items-center justify-center bg-white/50">
                {uploading ? (
                  <Loader2 className="h-8 w-8 animate-spin text-copper" />
                ) : (
                  <>
                    <ImageIcon className="h-10 w-10 text-leather/40 mb-3" />
                    <Label htmlFor="cover-upload" className="cursor-pointer bg-copper text-white px-4 py-2 rounded-md font-medium hover:bg-copper/90 transition shadow-sm">
                      Selecionar Imagem
                    </Label>
                    <Input id="cover-upload" type="file" accept="image/*" className="hidden" onChange={handleFile} />
                  </>
                )}
              </div>
            )}
          </div>
        </div>

        {/* Builder */}
        <div className="pt-6 border-t border-leather/20">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
            <div>
              <h3 className="text-xl font-display text-coffee" style={{ fontFamily: "var(--font-display)" }}>Construtor de Relato</h3>
              <p className="text-sm text-leather/80">Monte o texto intercalando parágrafos e fotos.</p>
            </div>
            <div className="flex gap-2 shrink-0">
              <Button type="button" size="sm" variant="outline" className="bg-white border-leather/30 text-coffee hover:text-copper" onClick={() => addBlock("paragraph")}>+ Texto</Button>
              <Button type="button" size="sm" variant="outline" className="bg-white border-leather/30 text-coffee hover:text-copper" onClick={() => addBlock("subtitle")}>+ Subtítulo</Button>
              <Button type="button" size="sm" variant="outline" className="bg-white border-leather/30 text-coffee hover:text-copper" onClick={() => addBlock("image")}>+ Foto</Button>
            </div>
          </div>
          
          <div className="space-y-4">
            {blocks.length === 0 && (
              <div className="text-center py-12 border border-dashed border-leather/30 bg-white/50 rounded-xl">
                <p className="text-leather font-serif italic mb-4">Seu post está vazio.</p>
                <Button type="button" onClick={() => addBlock("paragraph")} className="bg-copper text-white hover:bg-copper/90">
                  Começar a escrever
                </Button>
              </div>
            )}
            
            {blocks.map((block, index) => (
              <div key={block.id} className="relative group border border-leather/20 rounded-xl p-4 bg-white shadow-sm flex flex-col sm:flex-row gap-4 transition hover:border-copper/40">
                <div className="flex sm:flex-col gap-2 justify-center sm:justify-start opacity-100 sm:opacity-0 group-hover:opacity-100 transition bg-cream/50 sm:bg-transparent p-2 sm:p-0 rounded-lg sm:rounded-none order-2 sm:order-1">
                  <button type="button" onClick={() => moveBlock(index, -1)} disabled={index === 0} className="hover:text-copper disabled:opacity-30 text-leather p-1">▲</button>
                  <button type="button" onClick={() => removeBlock(block.id)} className="text-destructive/50 hover:text-destructive p-1"><Trash2 className="h-4 w-4" /></button>
                  <button type="button" onClick={() => moveBlock(index, 1)} disabled={index === blocks.length - 1} className="hover:text-copper disabled:opacity-30 text-leather p-1">▼</button>
                </div>
                
                <div className="flex-1 min-w-0 order-1 sm:order-2">
                  {block.type === "paragraph" && (
                    <>
                      <Label className="text-[10px] uppercase font-bold tracking-wider text-copper mb-2 block">Parágrafo</Label>
                      <Textarea 
                        rows={4} 
                        value={block.value} 
                        onChange={(e) => updateBlock(block.id, e.target.value)} 
                        placeholder="Escreva o texto aqui..." 
                        className="border-none shadow-none focus-visible:ring-0 p-0 text-base leading-relaxed bg-transparent resize-none"
                      />
                    </>
                  )}
                  {block.type === "subtitle" && (
                    <>
                      <Label className="text-[10px] uppercase font-bold tracking-wider text-copper mb-2 block">Subtítulo</Label>
                      <Input 
                        value={block.value} 
                        onChange={(e) => updateBlock(block.id, e.target.value)} 
                        placeholder="Ex: A chegada em Monte Verde" 
                        className="border-none shadow-none focus-visible:ring-0 p-0 text-2xl font-bold font-display text-coffee bg-transparent" 
                        style={{ fontFamily: "var(--font-display)" }}
                      />
                    </>
                  )}
                  {block.type === "image" && (
                    <div className="pt-1">
                      <Label className="text-[10px] uppercase font-bold tracking-wider text-copper mb-2 block">Foto do Relato</Label>
                      {block.value ? (
                        <div className="relative group/img rounded-lg overflow-hidden border border-leather/20 mt-2 bg-cream">
                          <img src={block.value} alt="" className="w-full max-h-[400px] object-contain" />
                          <div className="absolute inset-0 bg-black/50 opacity-0 group-hover/img:opacity-100 transition flex items-center justify-center">
                            <Label htmlFor={`file-${block.id}`} className="cursor-pointer bg-white text-coffee px-4 py-2 rounded-md font-medium shadow-lg hover:scale-105 transition">
                              Trocar Foto
                            </Label>
                            <Input id={`file-${block.id}`} type="file" accept="image/*" className="hidden" onChange={(e) => handleBlockFile(e, block.id)} disabled={uploadingBlockId === block.id} />
                          </div>
                        </div>
                      ) : (
                        <div className="mt-2 border-2 border-dashed border-leather/30 rounded-lg py-8 flex flex-col items-center justify-center bg-cream/30">
                          {uploadingBlockId === block.id ? (
                            <Loader2 className="h-6 w-6 animate-spin text-copper" />
                          ) : (
                            <>
                              <ImageIcon className="h-8 w-8 text-leather/40 mb-2" />
                              <Label htmlFor={`file-${block.id}`} className="cursor-pointer text-sm font-medium text-copper hover:underline">
                                Selecionar foto para o artigo
                              </Label>
                              <Input id={`file-${block.id}`} type="file" accept="image/*" className="hidden" onChange={(e) => handleBlockFile(e, block.id)} />
                            </>
                          )}
                        </div>
                      )}
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="pt-6 border-t border-leather/20 flex justify-end gap-3">
          <Button variant="outline" className="bg-white border-leather/30 text-leather hover:text-coffee" onClick={() => navigate({ to: "/admin/blog" })}>
            Cancelar
          </Button>
          <Button onClick={save} disabled={saving || uploading} className="bg-copper text-white hover:bg-copper/90 min-w-[120px]">
            {saving ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
            {saving ? "Salvando..." : "Salvar Post"}
          </Button>
        </div>
      </div>
    </div>
  );
}
