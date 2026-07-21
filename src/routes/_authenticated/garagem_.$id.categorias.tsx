import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import {
  Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger,
} from "@/components/ui/dialog";
import { ArrowLeft, Plus, Trash2, Pencil, Clock, CheckCircle2, AlertTriangle, List as ListIcon, Wrench } from "lucide-react";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/garagem/$id/categorias")({
  head: () => ({ meta: [{ title: "Categorias de Manutenção — Café Moto e Asfalto" }] }),
  component: MotoCategorias,
});

type Moto = {
  id: string; brand: string; model: string; nickname: string | null; current_km: number;
};

type Item = {
  id: string; motorcycle_id: string; name: string;
  interval_km: number | null; interval_months: number | null;
  last_change_km: number | null; last_change_date: string | null;
  notes: string | null;
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

function MotoCategorias() {
  const { id } = Route.useParams();
  const navigate = useNavigate();
  const [moto, setMoto] = useState<Moto | null>(null);
  const [items, setItems] = useState<Item[]>([]);
  const [recordsCount, setRecordsCount] = useState<Record<string, number>>({});
  const [loading, setLoading] = useState(true);
  const [itemOpen, setItemOpen] = useState(false);

  async function loadAll() {
    const [{ data: m }, { data: it }, { data: rc }] = await Promise.all([
      supabase.from("motorcycles").select("id, brand, model, nickname, current_km").eq("id", id).maybeSingle(),
      supabase.from("maintenance_items").select("*").eq("motorcycle_id", id).order("name"),
      supabase.from("maintenance_records").select("maintenance_item_id").eq("motorcycle_id", id),
    ]);
    
    if (!m) { toast.error("Moto não encontrada"); navigate({ to: "/garagem" }); return; }
    
    setMoto(m as Moto);
    setItems((it ?? []) as Item[]);
    
    // Contar quantas vezes cada categoria foi usada no histórico
    const counts: Record<string, number> = {};
    (rc ?? []).forEach(record => {
      if (record.maintenance_item_id) {
        counts[record.maintenance_item_id] = (counts[record.maintenance_item_id] || 0) + 1;
      }
    });
    setRecordsCount(counts);
    setLoading(false);
  }

  useEffect(() => { loadAll(); }, [id]);

  async function deleteItem(itemId: string) {
    const isUsed = recordsCount[itemId] > 0;
    
    if (isUsed) {
      if (!confirm(`⚠️ ATENÇÃO: Esta categoria foi usada em ${recordsCount[itemId]} registro(s) no histórico!\n\nSe você excluí-la, esses registros antigos perderão a categoria e ficarão apenas com o nome gravado (como 'Avulso').\n\nDeseja excluir a categoria mesmo assim?`)) return;
    } else {
      if (!confirm("Excluir esta categoria?")) return;
    }
    
    const { error } = await supabase.from("maintenance_items").delete().eq("id", itemId);
    if (error) return toast.error(error.message);
    toast.success("Categoria removida com sucesso");
    loadAll();
  }

  if (loading || !moto) return <p className="text-leather">Carregando…</p>;

  const lembretes = items.filter(it => it.interval_km || it.interval_months);
  const categoriasSimples = items.filter(it => !it.interval_km && !it.interval_months);

  return (
    <div className="max-w-5xl mx-auto pb-16">
      <div className="flex items-center justify-between mb-6">
        <div>
          <button 
            onClick={() => navigate({ to: "/garagem/$id", params: { id } })} 
            className="inline-flex items-center gap-1 text-sm text-leather hover:text-copper mb-2 cursor-pointer bg-transparent border-0 p-0"
          >
            <ArrowLeft className="h-4 w-4" /> Voltar para a Moto
          </button>
          <h1 className="font-display text-3xl text-coffee">Categorias de Manutenção</h1>
          <p className="text-sm text-leather mt-1">{moto.nickname || moto.model} • {moto.current_km.toLocaleString("pt-BR")} km</p>
        </div>
        <Dialog open={itemOpen} onOpenChange={setItemOpen}>
          <DialogTrigger asChild>
            <Button className="btn-copper">
              <Plus className="h-4 w-4 mr-2" /> Nova Categoria
            </Button>
          </DialogTrigger>
          <NewItemDialog motorcycleId={id} currentKm={moto.current_km} onCreated={() => { setItemOpen(false); loadAll(); }} />
        </Dialog>
      </div>

      <div className="space-y-8">
        <section>
          <h2 className="text-xl font-display text-coffee mb-4 flex items-center gap-2">
            <Clock className="w-5 h-5 text-copper" />
            Com Alerta (Lembretes)
          </h2>
          {lembretes.length === 0 ? (
            <Card className="border-dashed border-leather/40 bg-cream">
              <CardContent className="py-8 text-center text-leather">
                Nenhum lembrete cadastrado.
              </CardContent>
            </Card>
          ) : (
            <div className="grid md:grid-cols-2 gap-4">
              {lembretes.map((it) => {
                const s = statusFor(it, moto.current_km);
                return (
                  <Card key={it.id} className="border-leather/30 bg-cream">
                    <CardContent className="p-5">
                      <div className="flex items-start justify-between gap-3 mb-2">
                        <div>
                          <h3 className="font-display text-lg text-coffee">
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
                        {s.daysRemaining != null && (
                          <p className="text-xs text-leather mt-1">
                            {s.daysRemaining > 0
                              ? `Faltam ${s.daysRemaining} dia${s.daysRemaining !== 1 ? "s" : ""} (vence em ${s.dateDue!.toLocaleDateString("pt-BR")})`
                              : `Vencido há ${Math.abs(s.daysRemaining)} dia${Math.abs(s.daysRemaining) !== 1 ? "s" : ""}`}
                          </p>
                        )}
                      </div>

                      <div className="flex justify-between items-center mt-4 pt-4 border-t border-leather/15">
                        <span className="text-xs text-leather flex items-center gap-1" title="Registros no histórico">
                          <ListIcon className="w-3.5 h-3.5" />
                          {recordsCount[it.id] || 0} registro(s)
                        </span>
                        <div className="flex gap-1">
                          <Dialog>
                            <DialogTrigger asChild>
                              <Button variant="ghost" size="sm" className="text-coffee hover:bg-leather/10 h-8 px-2">
                                <Pencil className="h-3.5 w-3.5 mr-1.5" /> Editar
                              </Button>
                            </DialogTrigger>
                            <EditItemDialog item={it} currentKm={moto.current_km} onUpdated={loadAll} />
                          </Dialog>
                          <Button variant="ghost" size="sm" onClick={() => deleteItem(it.id)} className="text-destructive hover:bg-destructive/10 h-8 px-2">
                            <Trash2 className="h-3.5 w-3.5" />
                          </Button>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          )}
        </section>

        <section>
          <h2 className="text-xl font-display text-coffee mb-4 flex items-center gap-2">
            <ListIcon className="w-5 h-5 text-copper" />
            Categorias Simples (Sem alerta)
          </h2>
          {categoriasSimples.length === 0 ? (
             <Card className="border-dashed border-leather/40 bg-cream">
             <CardContent className="py-8 text-center text-leather">
               Nenhuma categoria simples.
             </CardContent>
           </Card>
          ) : (
            <div className="grid sm:grid-cols-2 md:grid-cols-3 gap-3">
              {categoriasSimples.map(c => (
                <Card key={c.id} className="border-leather/30 bg-cream">
                  <CardContent className="p-4 flex flex-col justify-between h-full">
                    <div className="mb-3">
                      <h3 className="font-medium text-coffee text-base mb-1">{c.name}</h3>
                      <p className="text-xs text-leather flex items-center gap-1">
                        <Wrench className="w-3 h-3" />
                        {recordsCount[c.id] || 0} registro(s)
                      </p>
                    </div>
                    <div className="flex justify-end gap-1">
                      <Dialog>
                        <DialogTrigger asChild>
                          <Button variant="ghost" size="sm" className="text-coffee hover:bg-leather/10 h-7 px-2">
                            <Pencil className="h-3 w-3" />
                          </Button>
                        </DialogTrigger>
                        <EditItemDialog item={c} currentKm={moto.current_km} onUpdated={loadAll} />
                      </Dialog>
                      <Button variant="ghost" size="sm" onClick={() => deleteItem(c.id)} className="text-destructive hover:bg-destructive/10 h-7 px-2">
                        <Trash2 className="h-3 w-3" />
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </section>
      </div>
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
    toast.success("Categoria cadastrada");
    onCreated();
  }

  return (
    <DialogContent className="max-w-lg">
      <DialogHeader>
        <DialogTitle>Criar Categoria</DialogTitle>
        <DialogDescription>Deixe os intervalos vazios se for apenas para organizar o histórico, ou preencha para gerar alertas.</DialogDescription>
      </DialogHeader>
      <form onSubmit={submit} className="space-y-3">
        <div>
          <Label>O que monitorar? *</Label>
          <Input required value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} placeholder="Ex: Óleo do motor, pneu, lavagem..." />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Intervalo (km)</Label>
            <Input type="number" value={form.interval_km} onChange={(e) => setForm({ ...form, interval_km: e.target.value })} placeholder="Ex: 3000 (opcional)" />
          </div>
          <div>
            <Label>Intervalo (meses)</Label>
            <Input type="number" value={form.interval_months} onChange={(e) => setForm({ ...form, interval_months: e.target.value })} placeholder="Ex: 6 (opcional)" />
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

function EditItemDialog({ item, currentKm, onUpdated }: { item: Item; currentKm: number; onUpdated: () => void }) {
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
    toast.success("Categoria atualizada");
    setOpen(false);
    onUpdated();
  }

  return (
    <DialogContent className="max-w-lg">
      <DialogHeader>
        <DialogTitle>Editar Categoria</DialogTitle>
        <DialogDescription>Altere o nome, configurações de alerta ou registros da última troca.</DialogDescription>
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
