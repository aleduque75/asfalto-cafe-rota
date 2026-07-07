import { createFileRoute, useNavigate, Link } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { ArrowLeft, Loader2, Image as ImageIcon } from "lucide-react";
import { toast } from "sonner";
import { generateUploadUrl } from "@/lib/upload";

export const Route = createFileRoute("/_authenticated/garagem_/$id/edit")({
  head: () => ({ meta: [{ title: "Editar Moto — Café Moto e Asfalto" }] }),
  component: EditMotoPage,
});

type Moto = {
  id: string; brand: string; model: string; year: number | null;
  plate: string | null; color: string | null; nickname: string | null;
  current_km: number; photo_url: string | null;
};

function EditMotoPage() {
  const { id } = Route.useParams();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [file, setFile] = useState<File | null>(null);
  const [moto, setMoto] = useState<Moto | null>(null);
  const [form, setForm] = useState({
    brand: "", model: "", year: "", plate: "", color: "", nickname: "", photo_url: "",
  });

  useEffect(() => {
    async function load() {
      const { data, error } = await supabase.from("motorcycles").select("*").eq("id", id).maybeSingle();
      if (error || !data) {
        toast.error("Moto não encontrada");
        navigate({ to: "/garagem" });
        return;
      }
      
      const m = data as Moto;
      setMoto(m);
      setForm({
        brand: m.brand || "", model: m.model || "", year: m.year ? String(m.year) : "",
        plate: m.plate || "", color: m.color || "", nickname: m.nickname || "",
        photo_url: m.photo_url || "",
      });
      setLoading(false);
    }
    load();
  }, [id, navigate]);

  function setField<K extends keyof typeof form>(k: K, v: string) {
    setForm((f) => ({ ...f, [k]: v }));
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    
    try {
      let finalPhotoUrl = form.photo_url.trim() || null;

      if (file) {
        toast.loading("Enviando foto...", { id: "upload" });
        const { presignedUrl, publicUrl } = await generateUploadUrl({ data: { filename: file.name, contentType: file.type } });
        const uploadRes = await fetch(presignedUrl, {
          method: "PUT",
          body: file,
          headers: { "Content-Type": file.type },
        });

        if (!uploadRes.ok) {
          throw new Error("Falha ao fazer upload da foto.");
        }
        finalPhotoUrl = publicUrl;
        toast.dismiss("upload");
      }

      const { error } = await supabase.from("motorcycles").update({
        brand: form.brand.trim(),
        model: form.model.trim(),
        year: form.year ? parseInt(form.year) : null,
        plate: form.plate.trim() || null,
        color: form.color.trim() || null,
        nickname: form.nickname.trim() || null,
        photo_url: finalPhotoUrl,
      }).eq("id", id);
      
      if (error) throw new Error(error.message);
      
      toast.success("Moto atualizada com sucesso!");
      navigate({ to: "/garagem/$id", params: { id } });
    } catch (err: any) {
      toast.dismiss("upload");
      toast.error(err.message || "Erro inesperado.");
    } finally {
      setSaving(false);
    }
  }

  if (loading) {
    return <div className="p-12 text-center text-leather flex items-center justify-center"><Loader2 className="animate-spin mr-2 h-5 w-5" /> Carregando...</div>;
  }

  return (
    <div className="max-w-2xl mx-auto pb-12 space-y-6">
      <Link to="/garagem/$id" params={{ id }} className="inline-flex items-center gap-1 text-sm text-leather hover:text-copper mb-2">
        <ArrowLeft className="h-4 w-4" /> Voltar para a moto
      </Link>
      
      <div>
        <h1 className="font-display text-3xl md:text-4xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>
          Editar {moto?.nickname || moto?.model}
        </h1>
        <p className="text-sm text-leather mt-2">Atualize os dados da sua moto.</p>
      </div>

      <div className="bg-cream border border-leather/30 rounded-xl p-6 shadow-sm">
        <form onSubmit={submit} className="space-y-6">
          <div className="grid md:grid-cols-2 gap-5">
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Marca *</Label>
              <Input className="bg-white text-coffee" required value={form.brand} onChange={(e) => setField("brand", e.target.value)} />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Modelo *</Label>
              <Input className="bg-white text-coffee" required value={form.model} onChange={(e) => setField("model", e.target.value)} />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Ano</Label>
              <Input className="bg-white text-coffee" type="number" value={form.year} onChange={(e) => setField("year", e.target.value)} />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Cor</Label>
              <Input className="bg-white text-coffee" value={form.color} onChange={(e) => setField("color", e.target.value)} />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Placa</Label>
              <Input className="bg-white text-coffee uppercase" value={form.plate} onChange={(e) => setField("plate", e.target.value)} />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Apelido (Opcional)</Label>
              <Input className="bg-white text-coffee" value={form.nickname} onChange={(e) => setField("nickname", e.target.value)} />
            </div>
          </div>
          
          <div className="space-y-2 pt-2 border-t border-leather/10">
            <Label className="text-coffee font-semibold block mb-3">Foto da Moto</Label>
            <div className="flex flex-col gap-3">
              {file ? (
                <div className="p-3 border rounded-md bg-white border-copper flex items-center justify-between">
                  <span className="text-sm text-coffee font-medium truncate max-w-[200px]">{file.name}</span>
                  <Button type="button" variant="ghost" size="sm" onClick={() => setFile(null)} className="text-red-500 hover:text-red-600 h-8 px-2">Remover</Button>
                </div>
              ) : (
                <div className="relative">
                  <Input id="photo-upload" type="file" accept="image/*" className="hidden" onChange={(e) => setFile(e.target.files?.[0] || null)} />
                  <label htmlFor="photo-upload" className="flex flex-col items-center justify-center p-6 border-2 border-dashed border-leather/30 rounded-xl bg-white/50 cursor-pointer hover:bg-white hover:border-copper transition">
                    <ImageIcon className="h-8 w-8 text-leather/40 mb-2" />
                    <span className="text-sm font-medium text-copper">Clique para alterar a foto</span>
                    <span className="text-xs text-leather mt-1">PNG, JPG até 5MB</span>
                  </label>
                </div>
              )}
              
              <div className="flex items-center gap-2 mt-2">
                <span className="text-xs text-leather font-medium">Ou URL externa:</span>
                <Input className="bg-white text-coffee h-9 text-sm" value={form.photo_url} onChange={(e) => setField("photo_url", e.target.value)} disabled={!!file} />
              </div>
            </div>
          </div>

          <div className="pt-6 border-t border-leather/20 flex justify-end gap-3">
            <Button type="button" variant="outline" className="bg-white border-leather/30 text-leather hover:text-coffee" onClick={() => navigate({ to: "/garagem/$id", params: { id } })}>
              Cancelar
            </Button>
            <Button type="submit" className="bg-copper text-white hover:bg-copper/90 min-w-[140px]" disabled={saving}>
              {saving ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
              {saving ? "Salvando..." : "Salvar alterações"}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}
