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

import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from "@/components/ui/table";
import {
  Command, CommandEmpty, CommandGroup, CommandInput, CommandItem, CommandList,
} from "@/components/ui/command";
import {
  Popover, PopoverContent, PopoverTrigger,
} from "@/components/ui/popover";
import { cn } from "@/lib/utils";
import { ArrowLeft, Bike, Plus, Wrench, Trash2, Gauge, AlertTriangle, CheckCircle2, Clock, Pencil, Calendar, Search, LayoutGrid, List as ListIcon, Check, ChevronsUpDown } from "lucide-react";
import { toast } from "sonner";
import { generateUploadUrl } from "@/lib/upload";

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
  id: string; maintenance_item_id: string | null; service_date: string; item_name: string;
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

  const datePct = item.interval_months && item.last_change_date && dateDue
    ? Math.min(100, Math.max(0, ((Date.now() - new Date(item.last_change_date).getTime()) / (dateDue.getTime() - new Date(item.last_change_date).getTime())) * 100))
    : null;

  const progress = Math.max(kmPct || 0, datePct || 0);

  const overdue = (kmRemaining != null && kmRemaining <= 0) || (daysRemaining != null && daysRemaining <= 0);
  const soon = !overdue && (
    (kmRemaining != null && kmRemaining <= (item.interval_km! * 0.15)) ||
    (daysRemaining != null && daysRemaining <= 14)
  );

  return { kmDue, kmRemaining, dateDue, daysRemaining, progress, overdue, soon };
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
  const [kmEditOpen, setKmEditOpen] = useState(false);
  const [viewMode, setViewMode] = useState<"card" | "list">("card");
  const [search, setSearch] = useState("");

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
    setKmEditOpen(false);
    loadAll();
  }

  async function deleteItem(itemId: string) {
    if (!confirm("Excluir este item de manutenção?")) return;
    const { error } = await supabase.from("maintenance_items").delete().eq("id", itemId);
    if (error) return toast.error(error.message);
    toast.success("Item removido");
    loadAll();
  }

  async function deleteRecord(recordId: string) {
    if (!confirm("Excluir este registro de manutenção?")) return;
    const { error } = await supabase.from("maintenance_records").delete().eq("id", recordId);
    if (error) return toast.error(error.message);
    toast.success("Registro removido");
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

  const filteredRecords = records.filter(r => {
    if (!search) return true;
    const q = search.toLowerCase();
    return (
      r.item_name.toLowerCase().includes(q) || 
      (r.workshop && r.workshop.toLowerCase().includes(q)) ||
      (r.notes && r.notes.toLowerCase().includes(q))
    );
  });

  return (
    <div>
      <button 
        onClick={() => {
          if (window.history.length > 2) {
            window.history.back();
          } else {
            navigate({ to: "/dashboard" });
          }
        }} 
        className="inline-flex items-center gap-1 text-sm text-leather hover:text-copper mb-4 cursor-pointer bg-transparent border-0 p-0"
      >
        <ArrowLeft className="h-4 w-4" /> Voltar
      </button>

      <div className="grid lg:grid-cols-3 gap-6 mb-8">
        <Card className="lg:col-span-2 overflow-hidden border-leather/30 bg-cream">
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
                <Button asChild variant="outline" size="sm" className="bg-transparent border-coffee text-coffee hover:bg-coffee hover:text-cream">
                  <Link to="/garagem/$id/edit" params={{ id: moto.id }}>
                    <Pencil className="h-4 w-4 mr-1.5" /> Editar moto
                  </Link>
                </Button>
                <Button variant="outline" size="sm" className="bg-transparent text-destructive border-destructive/40 hover:bg-destructive hover:text-destructive-foreground" onClick={deleteMoto}>
                  <Trash2 className="h-4 w-4 mr-1.5" /> Excluir moto
                </Button>
              </div>
            </CardContent>
          </div>
        </Card>

        <Card className="border-leather/30 bg-cream">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-coffee">
              <Gauge className="h-5 w-5 text-copper" /> Quilometragem
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="font-display text-4xl text-coffee mb-1" style={{ fontFamily: "var(--font-display)" }}>
              {moto.current_km.toLocaleString("pt-BR")} <span className="text-base text-leather">km</span>
            </p>
            
            {!kmEditOpen ? (
              <Button variant="outline" size="sm" onClick={() => setKmEditOpen(true)} className="mt-4 bg-transparent border-coffee text-coffee hover:bg-coffee hover:text-cream">
                <Gauge className="h-4 w-4 mr-2" /> Atualizar KM
              </Button>
            ) : (
              <div className="mt-4 p-4 border border-leather/20 rounded-md bg-[#F0EBE1]">
                <Label className="block mb-2 text-coffee">Novo KM</Label>
                <div className="flex flex-wrap gap-2">
                  <Input type="number" className="max-w-[150px] text-coffee border-coffee/20 bg-white" value={kmEdit} onChange={(e) => setKmEdit(e.target.value)} />
                  <Button onClick={updateKm} className="btn-copper">Salvar</Button>
                  <Button variant="ghost" className="text-coffee hover:bg-coffee/10 hover:text-coffee" onClick={() => { setKmEditOpen(false); setKmEdit(String(moto.current_km)); }}>Cancelar</Button>
                </div>
              </div>
            )}
            {alertCount > 0 && (
              <div className="mt-4 flex items-center gap-2 text-sm text-destructive">
                <AlertTriangle className="h-4 w-4" /> {alertCount} alerta{alertCount > 1 ? "s" : ""} de manutenção
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      <section className="mt-8">
        <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4 mb-6">
          <div>
            <h2 className="font-display text-2xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>Lembretes de Manutenção</h2>
            <p className="text-sm text-leather mt-1">Cadastre cada item e seu intervalo de troca por KM e/ou por tempo.</p>
          </div>
          <div className="flex flex-wrap gap-2">
              <Dialog open={recordOpen} onOpenChange={setRecordOpen}>
                <DialogTrigger asChild>
                  <Button variant="outline" className="bg-transparent border-coffee text-coffee hover:bg-coffee hover:text-cream">
                    <Wrench className="h-4 w-4 mr-2" /> Registrar manutenção
                  </Button>
                </DialogTrigger>
                <NewRecordDialog motorcycleId={id} currentKm={moto.current_km} items={items} onCreated={() => { setRecordOpen(false); loadAll(); }} />
              </Dialog>
              <Dialog open={itemOpen} onOpenChange={setItemOpen}>
                <DialogTrigger asChild>
                  <Button className="btn-copper">
                    <Plus className="h-4 w-4" /> Criar lembrete
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
                  <Card key={it.id} className="border-leather/30 bg-cream">
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

                      {(s.kmDue != null || s.dateDue != null) && (
                        <div className="mt-3">
                          <div className="w-full bg-leather/20 rounded-full h-2 overflow-hidden">
                            <div 
                              className={`h-full rounded-full transition-all ${s.overdue ? 'bg-red-600' : s.progress > 85 ? 'bg-amber-500' : 'bg-emerald-500'}`} 
                              style={{ width: `${s.progress}%` }} 
                            />
                          </div>
                          
                          {s.kmRemaining != null && (
                            <p className="text-xs text-leather mt-1">
                              {s.kmRemaining > 0
                                ? `Faltam ${s.kmRemaining.toLocaleString("pt-BR")} km (próxima troca aos ${s.kmDue!.toLocaleString("pt-BR")} km)`
                                : `Atrasado em ${Math.abs(s.kmRemaining).toLocaleString("pt-BR")} km`}
                            </p>
                          )}
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
                      <div className="flex justify-end gap-1 mt-3">
                        <Dialog>
                          <DialogTrigger asChild>
                            <Button variant="ghost" size="sm" className="text-coffee hover:bg-leather/10 h-8 px-2">
                              <Pencil className="h-3.5 w-3.5" />
                            </Button>
                          </DialogTrigger>
                          <EditItemDialog item={it} motorcycleId={id} currentKm={moto.current_km} onUpdated={loadAll} />
                        </Dialog>
                        <Button variant="ghost" size="sm" onClick={() => deleteItem(it.id)} className="text-destructive hover:bg-destructive/10 h-8 px-2">
                          <Trash2 className="h-3.5 w-3.5" />
                        </Button>
                      </div>
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          )}
      </section>

      <section className="mt-12">
        <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 mb-6">
          <h2 className="font-display text-2xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>Histórico de Manutenções</h2>
          <div className="flex flex-col sm:flex-row gap-3 items-end">
            <div className="relative">
              <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-leather/60" />
              <Input 
                placeholder="Buscar manutenção..." 
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="pl-9 w-full sm:w-[200px] bg-white border-leather/20 h-9 text-coffee placeholder:text-leather/70"
              />
            </div>
            <div className="flex gap-1 bg-cream/50 p-1 rounded-md border border-leather/20 w-fit">
              <button onClick={() => setViewMode("card")} className={`px-3 py-1.5 text-sm rounded flex items-center gap-2 ${viewMode === 'card' ? 'bg-white shadow-sm text-coffee font-medium' : 'text-leather hover:text-coffee hover:bg-white/50'}`}>
                <LayoutGrid className="w-4 h-4" /> Cards
              </button>
              <button onClick={() => setViewMode("list")} className={`px-3 py-1.5 text-sm rounded flex items-center gap-2 ${viewMode === 'list' ? 'bg-white shadow-sm text-coffee font-medium' : 'text-leather hover:text-coffee hover:bg-white/50'}`}>
                <ListIcon className="w-4 h-4" /> Lista
              </button>
            </div>
          </div>
        </div>
        
        {filteredRecords.length === 0 ? (
          <Card className="border-dashed border-leather/40 bg-cream">
            <CardContent className="py-12 text-center text-leather">
              Nenhum registro encontrado.
            </CardContent>
          </Card>
        ) : viewMode === "card" ? (
          <div className="grid sm:grid-cols-2 gap-4">
            {filteredRecords.map((r) => (
              <Card key={r.id} className="border-leather/30 bg-cream hover:border-copper transition-colors">
                <CardContent className="p-5">
                  <div className="flex justify-between items-start mb-3">
                    <div>
                      <h3 className="font-display text-lg text-coffee" style={{ fontFamily: "var(--font-display)" }}>{r.item_name}</h3>
                      <p className="text-sm text-leather flex items-center gap-1.5 mt-1">
                        <Calendar className="w-4 h-4 text-copper" /> {new Date(r.service_date).toLocaleDateString("pt-BR")}
                      </p>
                    </div>
                    <div className="flex items-center gap-2">
                      {r.cost != null && (
                        <Badge variant="outline" className="border-copper/50 text-coffee bg-copper/5 font-medium">
                          R$ {Number(r.cost).toFixed(2).replace(".", ",")}
                        </Badge>
                      )}
                      <EditRecordDialog record={r} items={items} motorcycleId={id} currentKm={moto.current_km} onUpdated={loadAll} />
                      <Button variant="ghost" size="sm" onClick={() => deleteRecord(r.id)} className="text-destructive hover:bg-destructive/10 h-8 px-2" title="Excluir">
                        <Trash2 className="h-3.5 w-3.5" />
                      </Button>
                    </div>
                  </div>
                  <div className="grid grid-cols-2 gap-2 text-sm mt-4 pt-4 border-t border-leather/15">
                    <div>
                      <p className="text-xs text-leather mb-1 uppercase tracking-wider">Quilometragem</p>
                      <p className="font-medium text-coffee flex items-center gap-1.5">
                        <Gauge className="w-4 h-4 text-copper" /> {r.km_at_service?.toLocaleString("pt-BR") ?? "—"} km
                      </p>
                    </div>
                    <div>
                      <p className="text-xs text-leather mb-1 uppercase tracking-wider">Oficina</p>
                      <p className="font-medium text-coffee flex items-center gap-1.5">
                        <Wrench className="w-4 h-4 text-copper" /> {r.workshop || "—"}
                      </p>
                    </div>
                  </div>
                  {r.notes && (
                    <p className="text-xs text-coffee/80 mt-3 pt-3 border-t border-leather/10 italic">
                      {r.notes}
                    </p>
                  )}
                </CardContent>
              </Card>
            ))}
          </div>
        ) : (
          <div className="border border-leather/30 rounded-lg bg-cream shadow-sm overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Serviço / Data</TableHead>
                  <TableHead>Quilometragem</TableHead>
                  <TableHead>Oficina / Obs</TableHead>
                  <TableHead>Custo</TableHead>
                  <TableHead className="text-right">Ações</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredRecords.map((r) => (
                  <TableRow key={r.id}>
                    <TableCell className="font-medium min-w-[200px]">
                      <div className="flex flex-col gap-0.5">
                        <span className="text-coffee">{r.item_name}</span>
                        <span className="text-xs text-leather flex items-center gap-1">
                          <Calendar className="w-3 h-3 text-copper" /> {new Date(r.service_date).toLocaleDateString("pt-BR")}
                        </span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="text-coffee text-sm flex items-center gap-1.5">
                        <Gauge className="w-3.5 h-3.5 text-copper" /> {r.km_at_service?.toLocaleString("pt-BR") ?? "—"} km
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex flex-col gap-1 max-w-[250px]">
                        <span className="text-sm text-coffee flex items-center gap-1.5 truncate">
                          <Wrench className="w-3.5 h-3.5 text-copper flex-shrink-0" /> {r.workshop || "—"}
                        </span>
                        {r.notes && <span className="text-xs text-leather/80 italic truncate">{r.notes}</span>}
                      </div>
                    </TableCell>
                    <TableCell>
                      {r.cost != null ? (
                        <Badge variant="outline" className="border-copper/50 text-coffee bg-copper/5">
                          R$ {Number(r.cost).toFixed(2).replace(".", ",")}
                        </Badge>
                      ) : "—"}
                    </TableCell>
                    <TableCell className="text-right">
                      <div className="flex items-center justify-end gap-1">
                        <EditRecordDialog record={r} items={items} motorcycleId={id} currentKm={moto.current_km} onUpdated={loadAll} />
                        <Button variant="ghost" size="sm" onClick={() => deleteRecord(r.id)} className="text-destructive hover:bg-destructive/10 h-8 px-2" title="Excluir">
                          <Trash2 className="h-3.5 w-3.5" />
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        )}
      </section>
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
        <DialogTitle>Criar lembrete de manutenção</DialogTitle>
        <DialogDescription>Defina de quanto em quanto tempo o sistema deve te alertar.</DialogDescription>
      </DialogHeader>
      <form onSubmit={submit} className="space-y-3">
        <div>
          <Label>O que monitorar? *</Label>
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

function EditItemDialog({ item, motorcycleId, currentKm, onUpdated }: { item: Item; motorcycleId: string; currentKm: number; onUpdated: () => void }) {
  const [saving, setSaving] = useState(false);
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState({
    name: item.name || "",
    interval_km: item.interval_km ? String(item.interval_km) : "",
    interval_months: item.interval_months ? String(item.interval_months) : "",
    last_change_km: item.last_change_km != null ? String(item.last_change_km) : String(currentKm),
    last_change_date: item.last_change_date || new Date().toISOString().slice(0, 10),
    notes: item.notes || "",
  });

  useEffect(() => {
    setForm({
      name: item.name || "",
      interval_km: item.interval_km ? String(item.interval_km) : "",
      interval_months: item.interval_months ? String(item.interval_months) : "",
      last_change_km: item.last_change_km != null ? String(item.last_change_km) : String(currentKm),
      last_change_date: item.last_change_date || new Date().toISOString().slice(0, 10),
      notes: item.notes || "",
    });
  }, [item, currentKm]);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const { error } = await supabase.from("maintenance_items").update({
      name: form.name.trim(),
      interval_km: form.interval_km ? parseInt(form.interval_km) : null,
      interval_months: form.interval_months ? parseInt(form.interval_months) : null,
      last_change_km: form.last_change_km ? parseInt(form.last_change_km) : null,
      last_change_date: form.last_change_date || null,
      notes: form.notes.trim() || null,
    }).eq("id", item.id);
    
    setSaving(false);
    if (error) return toast.error(error.message);
    toast.success("Item atualizado");
    setOpen(false);
    onUpdated();
  }

  return (
    <DialogContent className="max-w-lg">
      <DialogHeader>
        <DialogTitle>Editar lembrete de manutenção</DialogTitle>
        <DialogDescription>Altere os intervalos ou registros da última troca.</DialogDescription>
      </DialogHeader>
      <form onSubmit={submit} className="space-y-3">
        <div>
          <Label>O que monitorar? *</Label>
          <Input required value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Intervalo (km)</Label>
            <Input type="number" value={form.interval_km} onChange={(e) => setForm({ ...form, interval_km: e.target.value })} />
          </div>
          <div>
            <Label>Intervalo (meses)</Label>
            <Input type="number" value={form.interval_months} onChange={(e) => setForm({ ...form, interval_months: e.target.value })} />
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
          <Button type="submit" className="btn-copper" disabled={saving}>{saving ? "Salvando…" : "Salvar alterações"}</Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}

function NewRecordDialog({ motorcycleId, currentKm, items, onCreated }: { motorcycleId: string; currentKm: number; items: Item[]; onCreated: () => void }) {
  const [saving, setSaving] = useState(false);
  const [openCombobox, setOpenCombobox] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [form, setForm] = useState({
    maintenance_item_id: "",
    new_category_name: "",
    item_name: "",
    service_date: new Date().toISOString().slice(0, 10),
    km_at_service: String(currentKm),
    cost: "", workshop: "", notes: "",
  });

  function pickItem(id: string) {
    const item = items.find((i) => i.id === id);
    setForm((f) => ({ ...f, maintenance_item_id: id, item_name: item?.name ?? "" }));
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const { data: u } = await supabase.auth.getUser();
    if (!u.user) { setSaving(false); return toast.error("Sessão expirou"); }
    const km = form.km_at_service ? parseInt(form.km_at_service) : null;

    let finalItemId = form.maintenance_item_id === "NEW" ? null : (form.maintenance_item_id || null);

    // Se o usuário selecionou para criar uma nova categoria
    if (form.maintenance_item_id === "NEW" && form.new_category_name.trim()) {
      const { data: newItem, error: itemError } = await supabase.from("maintenance_items").insert({
        motorcycle_id: motorcycleId,
        user_id: u.user.id,
        name: form.new_category_name.trim(),
        last_change_km: km,
        last_change_date: form.service_date,
      }).select().single();
      
      if (!itemError && newItem) {
        finalItemId = newItem.id;
      }
    } else if (finalItemId) {
      // Atualiza o item existente com os dados da nova troca
      await supabase.from("maintenance_items").update({
        last_change_km: km,
        last_change_date: form.service_date,
      }).eq("id", finalItemId);
    }

    const { error } = await supabase.from("maintenance_records").insert({
      motorcycle_id: motorcycleId,
      maintenance_item_id: finalItemId,
      user_id: u.user.id,
      item_name: form.item_name.trim(),
      service_date: form.service_date,
      km_at_service: km,
      cost: form.cost ? parseFloat(form.cost) : null,
      workshop: form.workshop.trim() || null,
      notes: form.notes.trim() || null,
    });
    if (error) { setSaving(false); return toast.error(error.message); }

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
        <div className="flex flex-col gap-2">
          <Label>Categoria / Item vinculado</Label>
          <Popover open={openCombobox} onOpenChange={setOpenCombobox}>
            <PopoverTrigger asChild>
              <Button
                variant="outline"
                role="combobox"
                aria-expanded={openCombobox}
                className="w-full justify-between font-normal bg-transparent border-input hover:bg-transparent"
              >
                {form.maintenance_item_id === "NEW" 
                  ? `✨ Nova: ${form.new_category_name}`
                  : form.maintenance_item_id === "" 
                    ? "— Sem categoria (Avulso) —"
                    : items.find(i => i.id === form.maintenance_item_id)?.name || "Selecione..."}
                <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
              </Button>
            </PopoverTrigger>
            <PopoverContent className="w-[--radix-popover-trigger-width] p-0" align="start">
              <Command>
                <CommandInput 
                  placeholder="Buscar categoria..." 
                  value={searchQuery}
                  onValueChange={setSearchQuery}
                />
                <CommandList>
                  <CommandEmpty className="py-2 px-4 text-sm flex flex-col items-start gap-2">
                    {searchQuery ? (
                      <button 
                        type="button"
                        className="text-left w-full hover:bg-copper/10 p-2 rounded text-copper transition-colors font-medium flex items-center"
                        onClick={() => {
                          setForm(f => ({ ...f, maintenance_item_id: "NEW", new_category_name: searchQuery, item_name: f.item_name || searchQuery }));
                          setOpenCombobox(false);
                          setSearchQuery("");
                        }}
                      >
                        <Plus className="w-4 h-4 mr-2" />
                        Salvar '{searchQuery}' como nova categoria
                      </button>
                    ) : "Nenhuma encontrada."}
                  </CommandEmpty>
                  <CommandGroup>
                    <CommandItem
                      value="Sem categoria (Avulso)"
                      onSelect={() => {
                        setForm(f => ({ ...f, maintenance_item_id: "", new_category_name: "" }));
                        setOpenCombobox(false);
                        setSearchQuery("");
                      }}
                    >
                      <Check className={cn("mr-2 h-4 w-4", form.maintenance_item_id === "" ? "opacity-100" : "opacity-0")} />
                      — Sem categoria (Avulso) —
                    </CommandItem>
                    {items.map((i) => (
                      <CommandItem
                        key={i.id}
                        value={i.name}
                        onSelect={() => {
                          setForm(f => ({ ...f, maintenance_item_id: i.id, new_category_name: "", item_name: f.item_name || i.name }));
                          setOpenCombobox(false);
                          setSearchQuery("");
                        }}
                      >
                        <Check
                          className={cn(
                            "mr-2 h-4 w-4",
                            form.maintenance_item_id === i.id ? "opacity-100" : "opacity-0"
                          )}
                        />
                        {i.name}
                      </CommandItem>
                    ))}
                  </CommandGroup>
                </CommandList>
              </Command>
            </PopoverContent>
          </Popover>
        </div>

        <div>
          <Label>Descrição do Serviço *</Label>
          <Input required value={form.item_name} onChange={(e) => setForm({ ...form, item_name: e.target.value })} placeholder="Ex: Limpeza e lubrificação da corrente" />
        </div>

        {form.maintenance_item_id === "NEW" && (
          <div className="bg-copper/10 p-3 rounded-md border border-copper/30">
            <Label className="text-copper font-bold text-xs uppercase tracking-wider mb-1 block">Nova Categoria Automática</Label>
            <p className="text-sm text-foreground/90">
              O item <strong>{form.new_category_name}</strong> será salvo como uma nova categoria de lembrete!
            </p>
          </div>
        )}

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

function EditRecordDialog({ record, items, motorcycleId, currentKm, onUpdated }: { record: Record_; items: Item[]; motorcycleId: string; currentKm: number; onUpdated: () => void }) {
  const [saving, setSaving] = useState(false);
  const [open, setOpen] = useState(false);
  const [openCombobox, setOpenCombobox] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [form, setForm] = useState({
    maintenance_item_id: record.maintenance_item_id || "",
    new_category_name: "",
    item_name: record.item_name || "",
    service_date: record.service_date ? record.service_date.slice(0, 10) : new Date().toISOString().slice(0, 10),
    km_at_service: record.km_at_service ? String(record.km_at_service) : "",
    cost: record.cost ? String(record.cost) : "",
    workshop: record.workshop || "",
    notes: record.notes || "",
  });

  useEffect(() => {
    if (open) {
      setForm({
        maintenance_item_id: record.maintenance_item_id || "",
        new_category_name: "",
        item_name: record.item_name || "",
        service_date: record.service_date ? record.service_date.slice(0, 10) : new Date().toISOString().slice(0, 10),
        km_at_service: record.km_at_service ? String(record.km_at_service) : "",
        cost: record.cost ? String(record.cost) : "",
        workshop: record.workshop || "",
        notes: record.notes || "",
      });
      setSearchQuery("");
      setOpenCombobox(false);
    }
  }, [open, record]);

  function pickItem(id: string) {
    const item = items.find((i) => i.id === id);
    setForm((f) => ({ ...f, maintenance_item_id: id, item_name: item?.name ?? f.item_name }));
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const km = form.km_at_service ? parseInt(form.km_at_service) : null;
    let finalItemId = form.maintenance_item_id === "NEW" ? null : (form.maintenance_item_id || null);

    if (form.maintenance_item_id === "NEW" && form.new_category_name.trim()) {
      const { data: u } = await supabase.auth.getUser();
      const { data: newItem } = await supabase.from("maintenance_items").insert({
        motorcycle_id: motorcycleId,
        user_id: u?.user?.id as string,
        name: form.new_category_name.trim(),
        last_change_km: km,
        last_change_date: form.service_date,
      }).select().single();
      if (newItem) finalItemId = newItem.id;
    }

    const { error } = await supabase.from("maintenance_records").update({
      maintenance_item_id: finalItemId,
      item_name: form.item_name.trim(),
      service_date: form.service_date,
      km_at_service: km,
      cost: form.cost ? parseFloat(form.cost) : null,
      workshop: form.workshop.trim() || null,
      notes: form.notes.trim() || null,
    }).eq("id", record.id);

    if (error) { setSaving(false); return toast.error(error.message); }

    if (km && km > currentKm) {
      await supabase.from("motorcycles").update({ current_km: km }).eq("id", motorcycleId);
    }

    setSaving(false);
    toast.success("Registro atualizado");
    setOpen(false);
    onUpdated();
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button variant="ghost" size="sm" className="text-coffee hover:bg-leather/10 h-8 px-2" title="Editar">
          <Pencil className="h-3.5 w-3.5" />
        </Button>
      </DialogTrigger>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <DialogTitle>Editar registro de manutenção</DialogTitle>
          <DialogDescription>Altere as informações desse registro.</DialogDescription>
        </DialogHeader>
        <form onSubmit={submit} className="space-y-3">
          <div className="flex flex-col gap-2">
            <Label>Categoria / Item vinculado</Label>
            <Popover open={openCombobox} onOpenChange={setOpenCombobox}>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  role="combobox"
                  aria-expanded={openCombobox}
                  className="w-full justify-between font-normal bg-transparent border-input hover:bg-transparent"
                >
                  {form.maintenance_item_id === "NEW" 
                    ? `✨ Nova: ${form.new_category_name}`
                    : form.maintenance_item_id === "" 
                      ? "— Sem categoria (Avulso) —"
                      : items.find(i => i.id === form.maintenance_item_id)?.name || "Selecione..."}
                  <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-[--radix-popover-trigger-width] p-0" align="start">
                <Command>
                  <CommandInput 
                    placeholder="Buscar categoria..." 
                    value={searchQuery}
                    onValueChange={setSearchQuery}
                  />
                  <CommandList>
                    <CommandEmpty className="py-2 px-4 text-sm flex flex-col items-start gap-2">
                      {searchQuery ? (
                        <button 
                          type="button"
                          className="text-left w-full hover:bg-copper/10 p-2 rounded text-copper transition-colors font-medium flex items-center"
                          onClick={() => {
                            setForm(f => ({ ...f, maintenance_item_id: "NEW", new_category_name: searchQuery, item_name: f.item_name || searchQuery }));
                            setOpenCombobox(false);
                            setSearchQuery("");
                          }}
                        >
                          <Plus className="w-4 h-4 mr-2" />
                          Salvar '{searchQuery}' como nova categoria
                        </button>
                      ) : "Nenhuma encontrada."}
                    </CommandEmpty>
                    <CommandGroup>
                      <CommandItem
                        value="Sem categoria (Avulso)"
                        onSelect={() => {
                          setForm(f => ({ ...f, maintenance_item_id: "", new_category_name: "" }));
                          setOpenCombobox(false);
                          setSearchQuery("");
                        }}
                      >
                        <Check className={cn("mr-2 h-4 w-4", form.maintenance_item_id === "" ? "opacity-100" : "opacity-0")} />
                        — Sem categoria (Avulso) —
                      </CommandItem>
                      {items.map((i) => (
                        <CommandItem
                          key={i.id}
                          value={i.name}
                          onSelect={() => {
                            setForm(f => ({ ...f, maintenance_item_id: i.id, new_category_name: "", item_name: f.item_name || i.name }));
                            setOpenCombobox(false);
                            setSearchQuery("");
                          }}
                        >
                          <Check
                            className={cn(
                              "mr-2 h-4 w-4",
                              form.maintenance_item_id === i.id ? "opacity-100" : "opacity-0"
                            )}
                          />
                          {i.name}
                        </CommandItem>
                      ))}
                    </CommandGroup>
                  </CommandList>
                </Command>
              </PopoverContent>
            </Popover>
          </div>

          <div>
            <Label>Descrição do Serviço *</Label>
            <Input required value={form.item_name} onChange={(e) => setForm({ ...form, item_name: e.target.value })} />
          </div>

          {form.maintenance_item_id === "NEW" && (
            <div className="bg-copper/10 p-3 rounded-md border border-copper/30">
              <Label className="text-copper font-bold text-xs uppercase tracking-wider mb-1 block">Nova Categoria Automática</Label>
              <p className="text-sm text-foreground/90">
                O item <strong>{form.new_category_name}</strong> será salvo como uma nova categoria de lembrete!
              </p>
            </div>
          )}
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
            <Button type="submit" className="btn-copper" disabled={saving}>{saving ? "Salvando…" : "Salvar alterações"}</Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}