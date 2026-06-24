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

export const Route = createFileRoute("/_authenticated/admin/conteudo")({
  component: AdminConteudo,
});

type Section = {
  key: string;
  label: string;
  fields: { name: string; label: string; type: "text" | "textarea" }[];
};

const SECTIONS: Section[] = [
  {
    key: "hero",
    label: "Hero (topo)",
    fields: [
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

function AdminConteudo() {
  const [values, setValues] = useState<Record<string, Record<string, string>>>({});
  const [loading, setLoading] = useState(true);
  const [savingKey, setSavingKey] = useState<string | null>(null);

  async function load() {
    setLoading(true);
    const { data, error } = await supabase.from("site_content").select("key, value");
    setLoading(false);
    if (error) return toast.error(error.message);
    const map: Record<string, Record<string, string>> = {};
    for (const row of data ?? []) {
      map[row.key] = (row.value as Record<string, string>) ?? {};
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
            <Card key={s.key} className="border-leather/30">
              <CardHeader><CardTitle className="text-lg">{s.label}</CardTitle></CardHeader>
              <CardContent className="space-y-3">
                {s.fields.map((f) => (
                  <div key={f.name}>
                    <Label>{f.label}</Label>
                    {f.type === "textarea" ? (
                      <Textarea rows={3} value={values[s.key]?.[f.name] ?? ""} onChange={(e) => setField(s.key, f.name, e.target.value)} />
                    ) : (
                      <Input value={values[s.key]?.[f.name] ?? ""} onChange={(e) => setField(s.key, f.name, e.target.value)} />
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