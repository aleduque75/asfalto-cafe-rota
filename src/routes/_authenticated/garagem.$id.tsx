import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import {
  Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger,
} from "@/components/ui/dialog";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { ArrowLeft, Bike, Plus, Wrench, Trash2, Gauge, AlertTriangle, CheckCircle2, Clock } from "lucide-react";
import { toast } from "sonner";
import { generateUploadUrl } from "@/server/upload";

export const Route = createFileRoute("/_authenticated/garagem/$id")({
  head: () => ({ meta: [{ title: "Detalhes da moto — Café Moto e Asfalto" }] }),
  component: MotoDetail,
});

type Moto = {
  id: string; brand: string; model: string; year: number | null;
  plate: string | null; color: string | null; nickname: string | null;
  current_km: number; photo_url: string | null;
};

type Item = {
  id: string; motorcycle_id: string; name: string;
  interval_km: number | null; interval_months: number | null;
  last_change_km: number | null; last_change_date: string | null;
  notes: string | null;
};

type Record_ = {
  id: string; service_date: string; item_name: string;
  km_at_service: number | null; cost: number | null;
  workshop: string | null; notes: string | null;
};

function statusFor(item: Item, currentKm: number) {
  const kmDue = item.interval_km && item.last_change_km != null
    ? item.last_change_km + item.interval_km
    : null;
  const kmRemaining = kmDue != null ? kmDue - currentKm : null;

  const dateDue = item.interval_months && item.last_change_date
    ? new Date(new Date(item.last_change_date).setMonth(new Date(item.last_change_date).getMonth() + item.interval_months))
    : null;
  const daysRemaining = dateDue ? Math.ceil((dateDue.getTime() - Date.now()) / 86400000) : null;

  const kmPct = item.interval_km && item.last_change_km != null
    ? Math.min(100, Math.max(0, ((currentKm - item.last_change_km) / item.interval_km) * 100))
    : null;

  const overdue = (kmRemaining != null && kmRemaining <= 0) || (daysRemaining != null && daysRemaining <= 0);
  const soon = !overdue && (
    (kmRemaining != null && kmRemaining <= (item.interval_km! * 0.15)) ||
    (daysRemaining != null && daysRemaining <= 14)
  );

  return { kmDue, kmRemaining, dateDue, daysRemaining, kmPct, overdue, soon };
}

function MotoDetail() {
  const { id } = Route.useParams();
  const navigate = useNavigate();
  const [moto, setMoto] = useState<Moto | null>(null);
  const [items, setItems] = useState<Item[]>([]);
  const [records, setRecords] = useState<Record_[]>([]);
  const [loading, setLoading] = useState(true);
  const [kmEdit, setKmEdit] = useState<string>("");
  const [editOpen, setEditOpen] = useState(false);
  const [itemOpen, setItemOpen] = useState(false);
  const [recordOpen, setRecordOpen] = useState(false);

  async function loadAll() {
    const [{ data: m }, { data: it }, { data: rc }] = await Promise.all([
      supabase.from("motorcycles").select("*").eq("id", id).maybeSingle(),
      supabase.from("maintenance_items").select("*").eq("motorcycle_id", id).order("name"),
      supabase.from("maintenance_records").select("*").eq("motorcycle_id", id).order("service_date", { ascending: false }),
    ]);
    if (!m) { toast.error("Moto não encontrada"); navigate({ to: "/garagem" }); return; }
    setMoto(m as Moto);
    setKmEdit(String((m as Moto).current_km));
    setItems((it ?? []) as Item[]);
    setRecords((rc ?? []) as Record_[]);
    setLoading(false);
  }

  useEffect(() => { loadAll(); /* eslint-disable-next-line */ }, [id]);

  async function updateKm() {
    const km = parseInt(kmEdit);
    if (isNaN(km) || km < 0) return toast.error("KM inválido");
    if (moto && km < moto.current_km) return toast.error("Quilometragem não pode diminuir");
    const { error } = await supabase.from("motorcycles").update({ current_km: km }).eq("id", id);
    if (error) return toast.error(error.message);
    toast.success("KM atualizado");
    loadAll();
  }

  async function deleteItem(itemId: string) {
    if (!confirm("Excluir este item de manutenção?")) return;
    const { error } = await supabase.from("maintenance_items").delete().eq("id", itemId);
    if (error) return toast.error(error.message);
    toast.success("Item removido");
    loadAll();
  }

  async function deleteMoto() {
    if (!confirm("Excluir esta moto e todo o histórico de manutenções?")) return;
    const { error } = await supabase.from("motorcycles").delete().eq("id", id);
    if (error) return toast.error(error.message);
    toast.success("Moto removida");
    navigate({ to: "/garagem" });
  }

  if (loading || !moto) return <p className="text-leather">Carregando…</p>;

  const alertCount = items.filter((i) => {
    const s = statusFor(i, moto.current_km);
    return s.overdue || s.soon;
  }).length;

  return (
    <div>
      <Link to="/garagem" className="inline-flex items-center gap-1 text-sm text-leather hover:text-copper mb-4">
        <ArrowLeft className="h-4 w-4" /> Voltar para a garagem
      </Link>

      <div className="grid lg:grid-cols-3 gap-6 mb-8">
        <Card className="lg:col-span-2 overflow-hidden border-leather/30">
          <div className="grid sm:grid-cols-2">
            <div className="aspect-[4/3] bg-gradient-to-br from-coffee to-leather flex items-center justify-center">
              {moto.photo_url ? (
                <img src={moto.photo_url} alt="" className="w-full h-full object-cover" />
              ) : (
                <Bike className="h-24 w-24 text-copper/60" />
              )}
            </div>
            <CardContent className="p-6">
              <p className="text-[10px] uppercase tracking-[0.25em] text-copper">{moto.brand}</p>
              <h1 className="font-display text-3xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>
                {moto.nickname || moto.model}
              </h1>
              <p className="text-sm text-leather mb-4">
                {moto.model}{moto.year ? ` · ${moto.year}` : ""}{moto.color ? ` · ${moto.color}` : ""}
              </p>
              {moto.plate && (
                <p className="text-sm text-coffee"><span className="text-leather">Placa:</span> {moto.plate}</p>
              )}
              <div className="mt-6 flex flex-wrap gap-2">
                <Dialog open={editOpen} onOpenChange={setEditOpen}>
                  <DialogTrigger asChild>
                    <Button variant="outline" size="sm" className="text-coffee border-leather/40 hover:bg-leather/10">
                      <Wrench className="h-4 w-4 mr-1.5" /> Editar moto
                    </Button>
                  </DialogTrigger>
                  <EditMotoDialog moto={moto} onUpdated={() => { setEditOpen(false); loadAll(); }} />
                </Dialog>
                <Button variant="outline" size="sm" className="text-destructive border-destructive/40 hover:bg-destructive/10" onClick={deleteMoto}>
                  <Trash2 className="h-4 w-4 mr-1.5" /> Excluir moto
                </Button>
              </div>
            </CardContent>
          </div>
        </Card>

        <Card className="border-leather/30">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-coffee">
              <Gauge className="h-5 w-5 text-copper" /> Quilometragem
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="font-display text-4xl text-coffee mb-1" style={{ fontFamily: "var(--font-display)" }}>
              {moto.current_km.toLocaleString("pt-BR")} <span className="text-base text-leather">km</span>
            </p>
            <Label className="mt-4 block">Atualizar KM</Label>
            <div className="flex gap-2 mt-1">
              <Input type="number" value={kmEdit} onChange={(e) => setKmEdit(e.target.value)} />
              <Button onClick={updateKm} className="btn-copper">Salvar</Button>
            </div>
            {alertCount > 0 && (
              <div className="mt-4 flex items-center gap-2 text-sm text-destructive">
                <AlertTriangle className="h-4 w-4" /> {alertCount} alerta{alertCount > 1 ? "s" : ""} de manutenção
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      <Tabs defaultValue="items">
        <TabsList>
          <TabsTrigger value="items">Itens de manutenção</TabsTrigger>
          <TabsTrigger value="history">Histórico</TabsTrigger>
        </TabsList>

        <TabsContent value="items" className="space-y-4">
          <div className="flex justify-between items-center mt-4">
            <p className="text-sm text-leather">Cadastre cada item e seu intervalo de troca por KM e/ou por tempo.</p>
            <div className="flex gap-2">
              <Dialog open={recordOpen} onOpenChange={setRecordOpen}>
                <DialogTrigger asChild>
                  <Button variant="outline">
                    <Wrench className="h-4 w-4" /> Registrar manutenção
                  </Button>
                </DialogTrigger>
                <NewRecordDialog motorcycleId={id} currentKm={moto.current_km} items={items} onCreated={() => { setRecordOpen(false); loadAll(); }} />
              </Dialog>
              <Dialog open={itemOpen} onOpenChange={setItemOpen}>
                <DialogTrigger asChild>
                  <Button className="btn-copper">
                    <Plus className="h-4 w-4" /> Novo item
                  </Button>
                </DialogTrigger>
                <NewItemDialog motorcycleId={id} currentKm={moto.current_km} onCreated={() => { setItemOpen(false); loadAll(); }} />
              </Dialog>
            </div>
          </div>

          {items.length === 0 ? (
            <Card className="border-dashed border-leather/40 bg-cream">
              <CardContent className="py-12 text-center">
                <Wrench className="h-10 w-10 mx-auto mb-3 text-copper" />
                <p className="text-leather">Nenhum item cadastrado. Comece adicionando, por exemplo, "Óleo do motor".</p>
              </CardContent>
            </Card>
          ) : (
            <div className="grid md:grid-cols-2 gap-4">
              {items.map((it) => {
                const s = statusFor(it, moto.current_km);
                return (
                  <Card key={it.id} className="border-leather/30">
                    <CardContent className="p-5">
                      <div className="flex items-start justify-between gap-3 mb-2">
                        <div>
                          <h3 className="font-display text-lg text-coffee" style={{ fontFamily: "var(--font-display)" }}>
                            {it.name}
                          </h3>
                          <p className="text-xs text-leather">
                            {it.interval_km ? `${it.interval_km.toLocaleString("pt-BR")} km` : ""}
                            {it.interval_km && it.interval_months ? " · " : ""}
                            {it.interval_months ? `${it.interval_months} meses` : ""}
                          </p>
                        </div>
                        {s.overdue ? (
                          <Badge className="bg-destructive text-destructive-foreground"><AlertTriangle className="h-3 w-3 mr-1" /> Atrasado</Badge>
                        ) : s.soon ? (
                          <Badge className="bg-amber-500 text-white"><Clock className="h-3 w-3 mr-1" /> Em breve</Badge>
                        ) : (
                          <Badge variant="outline" className="border-emerald-600 text-emerald-700"><CheckCircle2 className="h-3 w-3 mr-1" /> Em dia</Badge>
                        )}
                      </div>

                      {s.kmPct != null && (
                        <div className="mt-3">
                          <Progress value={s.kmPct} />
                          <p className="text-xs text-leather mt-1">
                            {s.kmRemaining != null && s.kmRemaining > 0
                              ? `Faltam ${s.kmRemaining.toLocaleString("pt-BR")} km (próxima troca aos ${s.kmDue!.toLocaleString("pt-BR")} km)`
                              : `Atrasado em ${Math.abs(s.kmRemaining!).toLocaleString("pt-BR")} km`}
                          </p>
                        </div>
                      )}
                      {s.daysRemaining != null && (
                        <p className="text-xs text-leather mt-2">
                          {s.daysRemaining > 0
                            ? `Faltam ${s.daysRemaining} dia${s.daysRemaining !== 1 ? "s" : ""} (vence em ${s.dateDue!.toLocaleDateString("pt-BR")})`
                            : `Vencido há ${Math.abs(s.daysRemaining)} dia${Math.abs(s.daysRemaining) !== 1 ? "s" : ""}`}
                        </p>
                      )}
                      {(it.last_change_km != null || it.last_change_date) && (
                        <p className="text-xs text-leather mt-2">
                          Última troca: {it.last_change_km != null ? `${it.last_change_km.toLocaleString("pt-BR")} km` : ""}
                          {it.last_change_km != null && it.last_change_date ? " · " : ""}
                          {it.last_change_date ? new Date(it.last_change_date).toLocaleDateString("pt-BR") : ""}
                        </p>
                      )}
                      {it.notes && <p className="text-xs text-coffee/80 mt-2 italic">{it.notes}</p>}
                      <div className="flex justify-end mt-3">
                        <Button variant="ghost" size="sm" onClick={() => deleteItem(it.id)} className="text-destructive hover:bg-destructive/10">
                          <Trash2 className="h-3.5 w-3.5" />
                        </Button>
                      </div>
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          )}
        </TabsContent>

        <TabsContent value="history">
          {records.length === 0 ? (
            <Card className="border-dashed border-leather/40 bg-cream mt-4">
              <CardContent className="py-12 text-center text-leather">
                Nenhum registro de manutenção ainda.
              </CardContent>
            </Card>
          ) : (
            <Card className="border-leather/30 mt-4">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Data</TableHead>
                    <TableHead>Item</TableHead>
                    <TableHead>KM</TableHead>
                    <TableHead>Oficina</TableHead>
                    <TableHead className="text-right">Custo</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {records.map((r) => (
                    <TableRow key={r.id}>
                      <TableCell>{new Date(r.service_date).toLocaleDateString("pt-BR")}</TableCell>
                      <TableCell className="font-medium">{r.item_name}</TableCell>
                      <TableCell>{r.km_at_service?.toLocaleString("pt-BR") ?? "—"}</TableCell>
                      <TableCell>{r.workshop ?? "—"}</TableCell>
                      <TableCell className="text-right">
                        {r.cost != null ? `R$ ${Number(r.cost).toFixed(2).replace(".", ",")}` : "—"}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </Card>
          )}
        </TabsContent>
      </Tabs>
    </div>
  );
}

function NewItemDialog({ motorcycleId, currentKm, onCreated }: { motorcycleId: string; currentKm: number; onCreated: () => void }) {
  const [saving, setSaving] = useState(false);
  const [form, setForm] = useState({
    name: "", interval_km: "", interval_months: "",
    last_change_km: String(currentKm),
    last_change_date: new Date().toISOString().slice(0, 10),
    notes: "",
  });

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const { data: u } = await supabase.auth.getUser();
    if (!u.user) { setSaving(false); return toast.error("Sessão expirou"); }
    const { error } = await supabase.from("maintenance_items").insert({
      motorcycle_id: motorcycleId,
      user_id: u.user.id,
      name: form.name.trim(),
      interval_km: form.interval_km ? parseInt(form.interval_km) : null,
      interval_months: form.interval_months ? parseInt(form.interval_months) : null,
      last_change_km: form.last_change_km ? parseInt(form.last_change_km) : null,
      last_change_date: form.last_change_date || null,
      notes: form.notes.trim() || null,
    });
    setSaving(false);
    if (error) return toast.error(error.message);
    toast.success("Item cadastrado");
    onCreated();
  }

  return (
    <DialogContent className="max-w-lg">
      <DialogHeader>
        <DialogTitle>Novo item de manutenção</DialogTitle>
        <DialogDescription>Defina intervalo por KM, por tempo, ou ambos.</DialogDescription>
      </DialogHeader>
      <form onSubmit={submit} className="space-y-3">
        <div>
          <Label>Item *</Label>
          <Input required value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} placeholder="Óleo do motor, pneu, corrente…" />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Intervalo (km)</Label>
            <Input type="number" value={form.interval_km} onChange={(e) => setForm({ ...form, interval_km: e.target.value })} placeholder="3000" />
          </div>
          <div>
            <Label>Intervalo (meses)</Label>
            <Input type="number" value={form.interval_months} onChange={(e) => setForm({ ...form, interval_months: e.target.value })} placeholder="6" />
          </div>
          <div>
            <Label>Última troca (km)</Label>
            <Input type="number" value={form.last_change_km} onChange={(e) => setForm({ ...form, last_change_km: e.target.value })} />
          </div>
          <div>
            <Label>Última troca (data)</Label>
            <Input type="date" value={form.last_change_date} onChange={(e) => setForm({ ...form, last_change_date: e.target.value })} />
          </div>
        </div>
        <div>
          <Label>Observações</Label>
          <Textarea rows={2} value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} />
        </div>
        <DialogFooter>
          <Button type="submit" className="btn-copper" disabled={saving}>{saving ? "Salvando…" : "Salvar"}</Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}

function NewRecordDialog({ motorcycleId, currentKm, items, onCreated }: { motorcycleId: string; currentKm: number; items: Item[]; onCreated: () => void }) {
  const [saving, setSaving] = useState(false);
  const [form, setForm] = useState({
    maintenance_item_id: "",
    item_name: "",
    service_date: new Date().toISOString().slice(0, 10),
    km_at_service: String(currentKm),
    cost: "", workshop: "", notes: "",
  });

  function pickItem(id: string) {
    const item = items.find((i) => i.id === id);
    setForm((f) => ({ ...f, maintenance_item_id: id, item_name: item?.name ?? f.item_name }));
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const { data: u } = await supabase.auth.getUser();
    if (!u.user) { setSaving(false); return toast.error("Sessão expirou"); }
    const km = form.km_at_service ? parseInt(form.km_at_service) : null;

    const { error } = await supabase.from("maintenance_records").insert({
      motorcycle_id: motorcycleId,
      maintenance_item_id: form.maintenance_item_id || null,
      user_id: u.user.id,
      item_name: form.item_name.trim(),
      service_date: form.service_date,
      km_at_service: km,
      cost: form.cost ? parseFloat(form.cost) : null,
      workshop: form.workshop.trim() || null,
      notes: form.notes.trim() || null,
    });
    if (error) { setSaving(false); return toast.error(error.message); }

    // Update the maintenance item with the new last_change values
    if (form.maintenance_item_id) {
      await supabase.from("maintenance_items").update({
        last_change_km: km,
        last_change_date: form.service_date,
      }).eq("id", form.maintenance_item_id);
    }
    // Bump moto KM if greater
    if (km && km > currentKm) {
      await supabase.from("motorcycles").update({ current_km: km }).eq("id", motorcycleId);
    }

    setSaving(false);
    toast.success("Manutenção registrada");
    onCreated();
  }

  return (
    <DialogContent className="max-w-lg">
      <DialogHeader>
        <DialogTitle>Registrar manutenção</DialogTitle>
        <DialogDescription>O item será marcado como recém-trocado.</DialogDescription>
      </DialogHeader>
      <form onSubmit={submit} className="space-y-3">
        <div>
          <Label>Item cadastrado</Label>
          <select
            className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm"
            value={form.maintenance_item_id}
            onChange={(e) => pickItem(e.target.value)}
          >
            <option value="">— Avulso —</option>
            {items.map((i) => <option key={i.id} value={i.id}>{i.name}</option>)}
          </select>
        </div>
        <div>
          <Label>Descrição *</Label>
          <Input required value={form.item_name} onChange={(e) => setForm({ ...form, item_name: e.target.value })} placeholder="Óleo + filtro" />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Data *</Label>
            <Input type="date" required value={form.service_date} onChange={(e) => setForm({ ...form, service_date: e.target.value })} />
          </div>
          <div>
            <Label>KM no serviço</Label>
            <Input type="number" value={form.km_at_service} onChange={(e) => setForm({ ...form, km_at_service: e.target.value })} />
          </div>
          <div>
            <Label>Custo (R$)</Label>
            <Input type="number" step="0.01" value={form.cost} onChange={(e) => setForm({ ...form, cost: e.target.value })} />
          </div>
          <div>
            <Label>Oficina</Label>
            <Input value={form.workshop} onChange={(e) => setForm({ ...form, workshop: e.target.value })} />
          </div>
        </div>
        <div>
          <Label>Observações</Label>
          <Textarea rows={2} value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} />
        </div>
        <DialogFooter>
          <Button type="submit" className="btn-copper" disabled={saving}>{saving ? "Salvando…" : "Salvar"}</Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}

function EditMotoDialog({ moto, onUpdated }: { moto: Moto; onUpdated: () => void }) {
  const [saving, setSaving] = useState(false);
  const [file, setFile] = useState<File | null>(null);
  const [form, setForm] = useState({
    brand: moto.brand || "", model: moto.model || "", year: moto.year ? String(moto.year) : "",
    plate: moto.plate || "", color: moto.color || "", nickname: moto.nickname || "",
    photo_url: moto.photo_url || "",
  });

  useEffect(() => {
    setFile(null);
    setForm({
      brand: moto.brand || "", model: moto.model || "", year: moto.year ? String(moto.year) : "",
      plate: moto.plate || "", color: moto.color || "", nickname: moto.nickname || "",
      photo_url: moto.photo_url || "",
    });
  }, [moto]);

  function setField<K extends keyof typeof form>(k: K, v: string) {
    setForm((f) => ({ ...f, [k]: v }));
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    
    try {
      let finalPhotoUrl = form.photo_url.trim() || null;

      if (file) {
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
      }

      const { error } = await supabase.from("motorcycles").update({
        brand: form.brand.trim(),
        model: form.model.trim(),
        year: form.year ? parseInt(form.year) : null,
        plate: form.plate.trim() || null,
        color: form.color.trim() || null,
        nickname: form.nickname.trim() || null,
        photo_url: finalPhotoUrl,
      }).eq("id", moto.id);
      
      if (error) throw new Error(error.message);
      
      toast.success("Moto atualizada!");
      onUpdated();
    } catch (err: any) {
      toast.error(err.message || "Erro inesperado.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <DialogContent className="max-w-lg">
      <DialogHeader>
        <DialogTitle>Editar moto</DialogTitle>
        <DialogDescription>Atualize os dados da sua moto.</DialogDescription>
      </DialogHeader>
      <form onSubmit={submit} className="space-y-3">
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Marca *</Label>
            <Input required value={form.brand} onChange={(e) => setField("brand", e.target.value)} />
          </div>
          <div>
            <Label>Modelo *</Label>
            <Input required value={form.model} onChange={(e) => setField("model", e.target.value)} />
          </div>
          <div>
            <Label>Ano</Label>
            <Input type="number" value={form.year} onChange={(e) => setField("year", e.target.value)} />
          </div>
          <div>
            <Label>Cor</Label>
            <Input value={form.color} onChange={(e) => setField("color", e.target.value)} />
          </div>
          <div>
            <Label>Placa</Label>
            <Input value={form.plate} onChange={(e) => setField("plate", e.target.value)} />
          </div>
          <div>
            <Label>Apelido</Label>
            <Input value={form.nickname} onChange={(e) => setField("nickname", e.target.value)} />
          </div>
          <div className="col-span-2">
            <Label>Foto da Moto</Label>
            <div className="flex flex-col gap-2">
              <Input type="file" accept="image/*" onChange={(e) => setFile(e.target.files?.[0] || null)} />
              <div className="flex items-center text-xs text-leather gap-2">
                <span className="shrink-0">Ou URL:</span>
                <Input value={form.photo_url} onChange={(e) => setField("photo_url", e.target.value)} placeholder="https://…" className="h-8 text-xs" disabled={!!file} />
              </div>
            </div>
          </div>
        </div>
        <DialogFooter>
          <Button type="submit" className="btn-copper" disabled={saving}>
            {saving ? "Salvando…" : "Salvar alterações"}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}