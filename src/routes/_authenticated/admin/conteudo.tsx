import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { toast } from "sonner";
import { Loader2, Save } from "lucide-react";
import { uploadMedia } from "@/lib/upload";

export const Route = createFileRoute("/_authenticated/admin/conteudo")({
  component: AdminConteudo,
});

type Section = {
  key: string;
  label: string;
  fields: { name: string; label: string; type: "text" | "textarea" | "image" }[];
};

const SECTIONS: Section[] = [
  {
    key: "general",
    label: "Geral",
    fields: [
      { name: "logo_url", label: "Logotipo (Imagem)", type: "image" },
    ],
  },
  {
    key: "hero",
    label: "Hero (topo)",
    fields: [
      { name: "bg_image_url", label: "Imagem de Fundo (Recomendado: 1920x1080px)", type: "image" },
      { name: "eyebrow", label: "Selo (eyebrow)", type: "text" },
      { name: "title", label: "Título", type: "text" },
      { name: "subtitle", label: "Subtítulo", type: "textarea" },
      { name: "cta_label", label: "Texto do botão", type: "text" },
    ],
  },
  {
    key: "club_story",
    label: "Moto Clube — História",
    fields: [
      { name: "title", label: "Título", type: "text" },
      { name: "paragraph", label: "Parágrafo principal", type: "textarea" },
    ],
  },
  {
    key: "contact",
    label: "Contato",
    fields: [
      { name: "address", label: "Endereço", type: "text" },
      { name: "whatsapp", label: "WhatsApp", type: "text" },
      { name: "email", label: "E-mail", type: "text" },
      { name: "instagram", label: "Instagram (@)", type: "text" },
    ],
  },
];

const DEFAULT_CONTENT: Record<string, Record<string, string>> = {
  hero: {
    eyebrow: "Atibaia · SP · Desde 2024",
    title: "Café quente.\nAsfalto livre.",
    subtitle: "\"O primeiro de muitos quilômetros juntos.\" Um grupo de amigos, algumas motos e uma vontade enorme de pegar a estrada.",
    cta_label: "Conheça o clube",
  },
  club_story: {
    title: "Café Moto e Asfalto",
    paragraph: "Tudo começou com um grupo de amigos, algumas motos e uma vontade enorme de pegar a estrada.\n\nCriamos esse espaço pra dividir o que move a nossa turma: o cheiro do asfalto de manhã cedo, o café quente numa parada no meio do caminho e as paisagens do interior de SP — e além — que só quem anda de moto conhece de verdade.\n\nDe Pedra Bela, Monte Verde, Joanópolis, Salesópolis e muitos outros que estão por vir, cada rolê vira história e a amizade se fortalece. Aqui a gente compartilha nossos passeios, viagens, paradas e os melhores momentos da estrada.",
  },
  contact: {
    address: "Atibaia — São Paulo — Brasil",
    whatsapp: "Solicite o contato pela mensagem ao lado",
    email: "contato@cafemotoasfalto.com.br",
    instagram: "@cafe_moto_asfalto",
  },
};

function AdminConteudo() {
  const [values, setValues] = useState<Record<string, Record<string, string>>>(DEFAULT_CONTENT);
  const [loading, setLoading] = useState(true);
  const [savingKey, setSavingKey] = useState<string | null>(null);

  async function load() {
    setLoading(true);
    const { data, error } = await supabase.from("site_content").select("key, value");
    setLoading(false);
    if (error) return toast.error(error.message);
    
    // Merge DB data over defaults
    const map = { ...DEFAULT_CONTENT };
    for (const row of data ?? []) {
      map[row.key] = { ...(map[row.key] || {}), ...(row.value as Record<string, string>) };
    }
    setValues(map);
  }
  useEffect(() => { load(); }, []);

  async function save(sectionKey: string) {
    setSavingKey(sectionKey);
    const { error } = await supabase
      .from("site_content")
      .upsert({ key: sectionKey, value: values[sectionKey] ?? {}, status: "published" });
    setSavingKey(null);
    if (error) return toast.error(error.message);
    toast.success("Conteúdo salvo");
  }

  function setField(sectionKey: string, field: string, value: string) {
    setValues((p) => ({ ...p, [sectionKey]: { ...(p[sectionKey] ?? {}), [field]: value } }));
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl md:text-4xl font-display" style={{ fontFamily: "var(--font-display)" }}>Conteúdo do site</h1>
        <p className="text-leather/70 mt-1">Textos editáveis da landing page.</p>
      </div>

      {loading ? (
        <div className="p-8 text-center text-leather/70"><Loader2 className="h-5 w-5 animate-spin inline" /></div>
      ) : (
        <div className="grid gap-6">
          {SECTIONS.map((s) => (
            <Card key={s.key} className="border-leather/30 bg-cream text-coffee shadow-sm">
              <CardHeader><CardTitle className="text-lg text-coffee font-display" style={{ fontFamily: "var(--font-display)" }}>{s.label}</CardTitle></CardHeader>
              <CardContent className="space-y-4">
                {s.fields.map((f) => (
                  <div key={f.name}>
                    <Label className="text-leather mb-1 block">{f.label}</Label>
                    {f.type === "textarea" ? (
                      <Textarea rows={4} className="bg-transparent" value={values[s.key]?.[f.name] ?? ""} onChange={(e) => setField(s.key, f.name, e.target.value)} />
                    ) : f.type === "image" ? (
                      <div className="space-y-2">
                        <Input type="file" accept="image/*" className="bg-transparent" onChange={async (e) => {
                          const file = e.target.files?.[0];
                          if (!file) return;
                          const loadingToast = toast.loading("Enviando imagem...");
                          try {
                            const url = await uploadMedia(file, "logo");
                            setField(s.key, f.name, url);
                            toast.success("Upload concluído! Salve a seção para aplicar.", { id: loadingToast });
                          } catch (err) {
                            toast.error("Erro ao enviar imagem", { id: loadingToast });
                          }
                        }} />
                        {values[s.key]?.[f.name] && <img src={values[s.key][f.name]} alt="Preview" className="h-16 w-auto object-contain bg-leather/10 rounded p-1" />}
                      </div>
                    ) : (
                      <Input className="bg-transparent" value={values[s.key]?.[f.name] ?? ""} onChange={(e) => setField(s.key, f.name, e.target.value)} />
                    )}
                  </div>
                ))}
                <div className="flex justify-end">
                  <Button onClick={() => save(s.key)} disabled={savingKey === s.key}>
                    <Save className="h-4 w-4 mr-1" /> {savingKey === s.key ? "Salvando..." : "Salvar seção"}
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}