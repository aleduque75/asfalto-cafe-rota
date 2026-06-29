import { createFileRoute, useNavigate, Link } from "@tanstack/react-router";
import { useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { ArrowLeft, Loader2, Image as ImageIcon } from "lucide-react";
import { toast } from "sonner";
import { generateUploadUrl } from "@/lib/upload";

export const Route = createFileRoute("/_authenticated/garagem/new")({
  head: () => ({ meta: [{ title: "Nova Moto — Café Moto e Asfalto" }] }),
  component: NovaMotoPage,
});

function NovaMotoPage() {
  const navigate = useNavigate();
  const [saving, setSaving] = useState(false);
  const [file, setFile] = useState<File | null>(null);
  const [form, setForm] = useState({
    brand: "", model: "", year: "", plate: "", color: "", nickname: "", current_km: "0", photo_url: "",
  });

  function setField<K extends keyof typeof form>(k: K, v: string) {
    setForm((f) => ({ ...f, [k]: v }));
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    
    try {
      const { data: userData } = await supabase.auth.getUser();
      if (!userData.user) { 
        setSaving(false); 
        return toast.error("Sessão expirou"); 
      }

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

      const { error } = await supabase.from("motorcycles").insert({
        user_id: userData.user.id,
        brand: form.brand.trim(),
        model: form.model.trim(),
        year: form.year ? parseInt(form.year) : null,
        plate: form.plate.trim() || null,
        color: form.color.trim() || null,
        nickname: form.nickname.trim() || null,
        current_km: parseInt(form.current_km) || 0,
        photo_url: finalPhotoUrl,
      });

      if (error) throw new Error(error.message);
      
      toast.success("Moto cadastrada com sucesso!");
      navigate({ to: "/garagem" });
    } catch (err: any) {
      toast.dismiss("upload");
      toast.error(err.message || "Erro inesperado.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="max-w-2xl mx-auto pb-12 space-y-6">
      <Link to="/garagem" className="inline-flex items-center gap-1 text-sm text-leather hover:text-copper mb-2">
        <ArrowLeft className="h-4 w-4" /> Voltar para a garagem
      </Link>
      
      <div>
        <h1 className="font-display text-3xl md:text-4xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>
          Nova Moto
        </h1>
        <p className="text-sm text-leather mt-2">Cadastre os dados da sua nova moto para controlar o histórico.</p>
      </div>

      <div className="bg-cream border border-leather/30 rounded-xl p-6 shadow-sm">
        <form onSubmit={submit} className="space-y-6">
          <div className="grid md:grid-cols-2 gap-5">
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Marca *</Label>
              <Input className="bg-white text-coffee" required value={form.brand} onChange={(e) => setField("brand", e.target.value)} placeholder="Ex: Honda, BMW" />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Modelo *</Label>
              <Input className="bg-white text-coffee" required value={form.model} onChange={(e) => setField("model", e.target.value)} placeholder="Ex: CB 500X, R1250GS" />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Ano</Label>
              <Input className="bg-white text-coffee" type="number" value={form.year} onChange={(e) => setField("year", e.target.value)} placeholder="Ex: 2023" />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Cor</Label>
              <Input className="bg-white text-coffee" value={form.color} onChange={(e) => setField("color", e.target.value)} placeholder="Ex: Vermelha" />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Placa</Label>
              <Input className="bg-white text-coffee uppercase" value={form.plate} onChange={(e) => setField("plate", e.target.value)} placeholder="ABC-1D23" />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Apelido (Opcional)</Label>
              <Input className="bg-white text-coffee" value={form.nickname} onChange={(e) => setField("nickname", e.target.value)} placeholder="Ex: Trovão" />
            </div>
            
            <div className="space-y-2">
              <Label className="text-coffee font-semibold">Quilometragem atual *</Label>
              <Input className="bg-white text-coffee" type="number" required value={form.current_km} onChange={(e) => setField("current_km", e.target.value)} />
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
                    <span className="text-sm font-medium text-copper">Clique para enviar uma foto</span>
                    <span className="text-xs text-leather mt-1">PNG, JPG até 5MB</span>
                  </label>
                </div>
              )}
              
              <div className="flex items-center gap-2 mt-2">
                <span className="text-xs text-leather font-medium">Ou URL externa:</span>
                <Input className="bg-white text-coffee h-9 text-sm" value={form.photo_url} onChange={(e) => setField("photo_url", e.target.value)} placeholder="https://..." disabled={!!file} />
              </div>
            </div>
          </div>

          <div className="pt-6 border-t border-leather/20 flex justify-end gap-3">
            <Button type="button" variant="outline" className="bg-white border-leather/30 text-leather hover:text-coffee" onClick={() => navigate({ to: "/garagem" })}>
              Cancelar
            </Button>
            <Button type="submit" className="bg-copper text-white hover:bg-copper/90 min-w-[140px]" disabled={saving}>
              {saving ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
              {saving ? "Salvando..." : "Salvar moto"}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}
