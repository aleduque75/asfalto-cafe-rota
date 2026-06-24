import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger,
} from "@/components/ui/dialog";
import { Plus, Bike, Gauge } from "lucide-react";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/garagem")({
  head: () => ({ meta: [{ title: "Minha Garagem — Café Moto e Asfalto" }] }),
  component: GaragemPage,
});

type Moto = {
  id: string; brand: string; model: string; year: number | null;
  plate: string | null; color: string | null; nickname: string | null;
  current_km: number; photo_url: string | null;
};

function GaragemPage() {
  const [motos, setMotos] = useState<Moto[]>([]);
  const [loading, setLoading] = useState(true);
  const [open, setOpen] = useState(false);

  async function load() {
    const { data, error } = await supabase
      .from("motorcycles").select("*").order("created_at", { ascending: false });
    if (error) toast.error(error.message);
    else setMotos((data ?? []) as Moto[]);
    setLoading(false);
  }

  useEffect(() => { load(); }, []);

  return (
    <div>
      <div className="flex items-end justify-between mb-8 gap-4 flex-wrap">
        <div>
          <p className="text-xs uppercase tracking-[0.25em] text-copper mb-2">Minha garagem</p>
          <h1 className="font-display text-3xl md:text-4xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>
            Suas motos
          </h1>
          <p className="text-sm text-leather mt-2">Cadastre cada moto, controle a quilometragem e acompanhe as manutenções.</p>
        </div>
        <Dialog open={open} onOpenChange={setOpen}>
          <DialogTrigger asChild>
            <Button className="btn-copper">
              <Plus className="h-4 w-4" /> Nova moto
            </Button>
          </DialogTrigger>
          <NewMotoDialog onCreated={() => { setOpen(false); load(); }} />
        </Dialog>
      </div>

      {loading ? (
        <p className="text-leather">Carregando…</p>
      ) : motos.length === 0 ? (
        <Card className="border-dashed border-leather/40 bg-cream">
          <CardContent className="py-16 text-center">
            <Bike className="h-12 w-12 mx-auto mb-4 text-copper" />
            <h3 className="font-display text-xl text-coffee mb-2" style={{ fontFamily: "var(--font-display)" }}>
              Nenhuma moto cadastrada
            </h3>
            <p className="text-sm text-leather mb-4">Cadastre sua primeira moto para começar a controlar manutenções.</p>
            <Button className="btn-copper" onClick={() => setOpen(true)}>
              <Plus className="h-4 w-4" /> Cadastrar moto
            </Button>
          </CardContent>
        </Card>
      ) : (
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {motos.map((m) => (
            <Link key={m.id} to="/garagem/$id" params={{ id: m.id }} className="group">
              <Card className="overflow-hidden border-leather/30 hover:border-copper hover:shadow-lg transition h-full bg-cream">
                <div className="aspect-[16/10] bg-gradient-to-br from-coffee to-leather flex items-center justify-center">
                  {m.photo_url ? (
                    <img src={m.photo_url} alt={`${m.brand} ${m.model}`} className="w-full h-full object-cover" />
                  ) : (
                    <Bike className="h-16 w-16 text-copper/60" />
                  )}
                </div>
                <CardContent className="p-5">
                  <p className="text-[10px] uppercase tracking-[0.25em] text-copper">{m.brand}</p>
                  <h3 className="font-display text-xl text-coffee mt-1" style={{ fontFamily: "var(--font-display)" }}>
                    {m.nickname || m.model}
                  </h3>
                  <p className="text-sm text-leather">{m.model}{m.year ? ` · ${m.year}` : ""}</p>
                  <div className="flex items-center gap-2 mt-3 text-sm text-coffee">
                    <Gauge className="h-4 w-4 text-copper" />
                    {m.current_km.toLocaleString("pt-BR")} km
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}

function NewMotoDialog({ onCreated }: { onCreated: () => void }) {
  const [saving, setSaving] = useState(false);
  const [form, setForm] = useState({
    brand: "", model: "", year: "", plate: "", color: "", nickname: "", current_km: "0", photo_url: "",
  });

  function setField<K extends keyof typeof form>(k: K, v: string) {
    setForm((f) => ({ ...f, [k]: v }));
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const { data: userData } = await supabase.auth.getUser();
    if (!userData.user) { setSaving(false); return toast.error("Sessão expirou"); }
    const { error } = await supabase.from("motorcycles").insert({
      user_id: userData.user.id,
      brand: form.brand.trim(),
      model: form.model.trim(),
      year: form.year ? parseInt(form.year) : null,
      plate: form.plate.trim() || null,
      color: form.color.trim() || null,
      nickname: form.nickname.trim() || null,
      current_km: parseInt(form.current_km) || 0,
      photo_url: form.photo_url.trim() || null,
    });
    setSaving(false);
    if (error) return toast.error(error.message);
    toast.success("Moto cadastrada!");
    onCreated();
  }

  return (
    <DialogContent className="max-w-lg">
      <DialogHeader>
        <DialogTitle>Nova moto</DialogTitle>
        <DialogDescription>Cadastre os dados da sua moto.</DialogDescription>
      </DialogHeader>
      <form onSubmit={submit} className="space-y-3">
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Marca *</Label>
            <Input required value={form.brand} onChange={(e) => setField("brand", e.target.value)} placeholder="Honda" />
          </div>
          <div>
            <Label>Modelo *</Label>
            <Input required value={form.model} onChange={(e) => setField("model", e.target.value)} placeholder="CB 500X" />
          </div>
          <div>
            <Label>Ano</Label>
            <Input type="number" value={form.year} onChange={(e) => setField("year", e.target.value)} placeholder="2023" />
          </div>
          <div>
            <Label>Cor</Label>
            <Input value={form.color} onChange={(e) => setField("color", e.target.value)} placeholder="Vermelha" />
          </div>
          <div>
            <Label>Placa</Label>
            <Input value={form.plate} onChange={(e) => setField("plate", e.target.value)} placeholder="ABC-1D23" />
          </div>
          <div>
            <Label>Apelido</Label>
            <Input value={form.nickname} onChange={(e) => setField("nickname", e.target.value)} placeholder="Trovão" />
          </div>
          <div>
            <Label>KM atual *</Label>
            <Input type="number" required value={form.current_km} onChange={(e) => setField("current_km", e.target.value)} />
          </div>
          <div>
            <Label>Foto (URL)</Label>
            <Input value={form.photo_url} onChange={(e) => setField("photo_url", e.target.value)} placeholder="https://…" />
          </div>
        </div>
        <DialogFooter>
          <Button type="submit" className="btn-copper" disabled={saving}>
            {saving ? "Salvando…" : "Salvar moto"}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}