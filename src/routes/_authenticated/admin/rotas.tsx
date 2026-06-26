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
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from "@/components/ui/table";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import { Pencil, Plus, Trash2, Loader2, Navigation, MapPin } from "lucide-react";
import type { Tables, TablesInsert } from "@/integrations/supabase/types";

type RouteData = Tables<"routes">;

export const Route = createFileRoute("/_authenticated/admin/rotas")({
  component: AdminRotas,
});

const EMPTY: Partial<RouteData> = {
  title: "", destination: "", start_date: "", meeting_point: "", meeting_time: "",
  description: "", estimated_distance_km: null, estimated_duration_mins: null,
  visited_places: "", waze_url: "", media_url: "", status: "open",
};

function AdminRotas() {
  const [items, setItems] = useState<RouteData[]>([]);
  const [loading, setLoading] = useState(true);
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Partial<RouteData>>(EMPTY);
  const [saving, setSaving] = useState(false);

  async function load() {
    setLoading(true);
    const { data, error } = await supabase
      .from("routes")
      .select("*")
      .order("start_date", { ascending: false });
    setLoading(false);
    if (error) return toast.error(error.message);
    setItems(data ?? []);
  }

  useEffect(() => { load(); }, []);

  function startNew() {
    const today = new Date();
    // Default to tomorrow 09:00 for convenience
    today.setDate(today.getDate() + 1);
    const start_date = today.toISOString().slice(0, 16); 
    
    setEditing({ ...EMPTY, start_date, meeting_time: "09:00:00" });
    setOpen(true);
  }

  function startEdit(r: RouteData) {
    // Format start_date for datetime-local input
    const dateObj = new Date(r.start_date);
    const localDate = new Date(dateObj.getTime() - dateObj.getTimezoneOffset() * 60000)
                        .toISOString()
                        .slice(0, 16);
    setEditing({ ...r, start_date: localDate });
    setOpen(true);
  }

  async function save() {
    if (!editing.title?.trim()) return toast.error("Informe um título");
    if (!editing.destination?.trim()) return toast.error("Informe um destino");
    if (!editing.start_date) return toast.error("Informe a data do passeio");
    if (!editing.meeting_point?.trim()) return toast.error("Informe o ponto de encontro");
    if (!editing.meeting_time?.trim()) return toast.error("Informe o horário de encontro");

    // Fix start_date timezone offset
    let isoDate;
    try {
      isoDate = new Date(editing.start_date).toISOString();
    } catch {
      return toast.error("Data inválida");
    }

    setSaving(true);
    
    // Auto format time if user types only HH:mm instead of HH:mm:ss
    let meeting_time = editing.meeting_time.trim();
    if (meeting_time.length === 5) meeting_time += ":00";

    const payload: TablesInsert<"routes"> = {
      title: editing.title.trim(),
      destination: editing.destination.trim(),
      start_date: isoDate,
      meeting_point: editing.meeting_point.trim(),
      meeting_time: meeting_time,
      description: editing.description?.trim() || null,
      estimated_distance_km: editing.estimated_distance_km || null,
      estimated_duration_mins: editing.estimated_duration_mins || null,
      visited_places: editing.visited_places?.trim() || null,
      waze_url: editing.waze_url?.trim() || null,
      media_url: editing.media_url?.trim() || null,
      status: editing.status || "open",
    };

    const res = editing.id
      ? await supabase.from("routes").update(payload).eq("id", editing.id)
      : await supabase.from("routes").insert(payload);

    setSaving(false);
    if (res.error) return toast.error(res.error.message);
    
    toast.success(editing.id ? "Rota atualizada com sucesso!" : "Rota cadastrada com sucesso!");
    setOpen(false);
    load();
  }

  async function remove(id: string) {
    if (!confirm("Tem certeza que deseja excluir esta rota permanentemente?")) return;
    const { error } = await supabase.from("routes").delete().eq("id", id);
    if (error) return toast.error(error.message);
    toast.success("Rota excluída");
    load();
  }

  async function toggleStatus(r: RouteData) {
    const next = r.status === "completed" ? "open" : "completed";
    const { error } = await supabase
      .from("routes")
      .update({ status: next })
      .eq("id", r.id);
    if (error) return toast.error(error.message);
    toast.success(`Rota marcada como ${next === "completed" ? "Finalizada" : "Em Aberto"}`);
    load();
  }

  return (
    <div className="space-y-6">
      <div className="flex items-end justify-between gap-4 flex-wrap">
        <div>
          <h1 className="text-3xl md:text-4xl font-display" style={{ fontFamily: "var(--font-display)" }}>Rotas e Passeios</h1>
          <p className="text-leather/70 mt-1">Gerencie os próximos destinos do motoclube.</p>
        </div>
        <Dialog open={open} onOpenChange={setOpen}>
          <DialogTrigger asChild>
            <Button onClick={startNew}><Plus className="h-4 w-4 mr-1" /> Criar nova rota</Button>
          </DialogTrigger>
          <DialogContent className="max-w-3xl max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>{editing.id ? "Editar Rota" : "Nova Rota"}</DialogTitle>
            </DialogHeader>
            <div className="space-y-4 pt-2">
              <div className="grid sm:grid-cols-2 gap-4">
                <div>
                  <Label>Título do Passeio *</Label>
                  <Input value={editing.title ?? ""} onChange={(e) => setEditing((p) => ({ ...p, title: e.target.value }))} placeholder="Ex: Bate e volta no fim de semana" />
                </div>
                <div>
                  <Label>Destino Final *</Label>
                  <Input value={editing.destination ?? ""} onChange={(e) => setEditing((p) => ({ ...p, destination: e.target.value }))} placeholder="Ex: Monte Verde - MG" />
                </div>
              </div>
              
              <div className="grid sm:grid-cols-3 gap-4 border border-leather/20 bg-black/5 p-4 rounded-lg">
                <div>
                  <Label>Data da Saída *</Label>
                  <Input 
                    type="datetime-local" 
                    value={editing.start_date ?? ""} 
                    onChange={(e) => setEditing((p) => ({ ...p, start_date: e.target.value }))} 
                  />
                </div>
                <div>
                  <Label>Horário de Encontro *</Label>
                  <Input 
                    type="time" 
                    value={editing.meeting_time ? editing.meeting_time.slice(0,5) : ""} 
                    onChange={(e) => setEditing((p) => ({ ...p, meeting_time: e.target.value }))} 
                  />
                </div>
                <div>
                  <Label>Ponto de Encontro *</Label>
                  <Input value={editing.meeting_point ?? ""} onChange={(e) => setEditing((p) => ({ ...p, meeting_point: e.target.value }))} placeholder="Ex: Posto Ipiranga X" />
                </div>
              </div>

              <div className="grid sm:grid-cols-2 gap-4">
                <div>
                  <Label>Distância (KM)</Label>
                  <Input 
                    type="number" 
                    value={editing.estimated_distance_km || ""} 
                    onChange={(e) => setEditing((p) => ({ ...p, estimated_distance_km: e.target.value ? Number(e.target.value) : null }))} 
                    placeholder="250"
                  />
                </div>
                <div>
                  <Label>Duração Estimada (minutos)</Label>
                  <Input 
                    type="number" 
                    value={editing.estimated_duration_mins || ""} 
                    onChange={(e) => setEditing((p) => ({ ...p, estimated_duration_mins: e.target.value ? Number(e.target.value) : null }))} 
                    placeholder="120"
                  />
                </div>
              </div>

              <div>
                <Label>Cidades/Locais visitados</Label>
                <Input value={editing.visited_places ?? ""} onChange={(e) => setEditing((p) => ({ ...p, visited_places: e.target.value }))} placeholder="Ex: Serra Negra, Águas de Lindoia" />
              </div>

              <div>
                <Label>Descrição completa</Label>
                <Textarea rows={3} value={editing.description ?? ""} onChange={(e) => setEditing((p) => ({ ...p, description: e.target.value }))} placeholder="Orientações e cronograma..." />
              </div>

              <div className="grid sm:grid-cols-2 gap-4">
                <div>
                  <Label>Link do Waze</Label>
                  <Input type="url" value={editing.waze_url ?? ""} onChange={(e) => setEditing((p) => ({ ...p, waze_url: e.target.value }))} placeholder="https://waze.com/ul..." />
                </div>
                <div>
                  <Label>Mídia (Youtube/Insta)</Label>
                  <Input type="url" value={editing.media_url ?? ""} onChange={(e) => setEditing((p) => ({ ...p, media_url: e.target.value }))} placeholder="Link do relato pós-passeio" />
                </div>
              </div>

              <div>
                <Label>Status</Label>
                <Select value={editing.status ?? "open"} onValueChange={(v) => setEditing((p) => ({ ...p, status: v as "open" | "completed" }))}>
                  <SelectTrigger className="w-[200px]"><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="open">Em Aberto</SelectItem>
                    <SelectItem value="completed">Finalizada (Concluída)</SelectItem>
                  </SelectContent>
                </Select>
              </div>

            </div>
            <DialogFooter>
              <Button variant="outline" onClick={() => setOpen(false)}>Cancelar</Button>
              <Button onClick={save} disabled={saving} className="btn-copper">
                {saving ? "Salvando..." : "Salvar Rota"}
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>

      <div className="border border-leather/30 rounded-lg bg-cream shadow-sm">
        {loading ? (
          <div className="p-8 text-center text-leather/70"><Loader2 className="h-5 w-5 animate-spin inline" /></div>
        ) : items.length === 0 ? (
          <div className="p-8 text-center text-leather/70">Nenhuma rota programada. Clique em "Criar nova rota".</div>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Passeio</TableHead>
                <TableHead>Data</TableHead>
                <TableHead className="hidden md:table-cell">Distância/Tempo</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Ações</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {items.map((r) => {
                const isPast = new Date(r.start_date) < new Date();
                return (
                  <TableRow key={r.id}>
                    <TableCell className="font-medium min-w-[200px]">
                      <div className="flex flex-col gap-0.5">
                        <span className="truncate flex items-center gap-1.5"><MapPin className="h-3.5 w-3.5 text-copper shrink-0" /> {r.title}</span>
                        <span className="text-xs text-leather truncate opacity-80">{r.destination}</span>
                      </div>
                    </TableCell>
                    <TableCell>
                      {new Date(r.start_date).toLocaleDateString("pt-BR")}
                    </TableCell>
                    <TableCell className="hidden md:table-cell text-sm text-leather">
                      {r.estimated_distance_km ? `${r.estimated_distance_km} km` : '—'}
                      {r.estimated_duration_mins ? ` / ${Math.floor(r.estimated_duration_mins/60)}h${r.estimated_duration_mins%60}m` : ''}
                    </TableCell>
                    <TableCell>
                      <Badge
                        variant={r.status === "completed" ? "default" : isPast ? "destructive" : "secondary"}
                        className="cursor-pointer whitespace-nowrap"
                        onClick={() => toggleStatus(r)}
                      >
                        {r.status === "completed" ? "Finalizada" : "Em Aberto"}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-right space-x-1 whitespace-nowrap">
                      {r.waze_url && (
                        <Button size="icon" variant="ghost" onClick={() => window.open(r.waze_url!, "_blank")} title="Testar Waze"><Navigation className="h-4 w-4" /></Button>
                      )}
                      <Button size="icon" variant="ghost" onClick={() => startEdit(r)} title="Editar"><Pencil className="h-4 w-4" /></Button>
                      <Button size="icon" variant="ghost" onClick={() => remove(r.id)} title="Excluir"><Trash2 className="h-4 w-4 text-destructive" /></Button>
                    </TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
          </Table>
        )}
      </div>
    </div>
  );
}
