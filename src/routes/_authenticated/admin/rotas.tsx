import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";

import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from "@/components/ui/table";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import { Pencil, Plus, Trash2, Loader2, Navigation, MapPin, X, ArrowLeft, Upload } from "lucide-react";
import type { Tables, TablesInsert } from "@/integrations/supabase/types";
import { uploadMedia } from "@/lib/upload";

type RouteData = Tables<"routes">;

export const Route = createFileRoute("/_authenticated/admin/rotas")({
  component: AdminRotas,
});

const EMPTY: Partial<RouteData> = {
  title: "", destination: "", start_date: "", meeting_point: "", meeting_time: "",
  description: "", estimated_distance_km: null, estimated_duration_mins: null,
  visited_places: "", waze_url: "", media_url: "", status: "open", route_type: "passeio", has_financial_plan: false, cover_url: "", itinerary: ""
};

function AdminRotas() {
  const [items, setItems] = useState<RouteData[]>([]);
  const [loading, setLoading] = useState(true);
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Partial<RouteData>>(EMPTY);
  const [saving, setSaving] = useState(false);
  const [isGenerating, setIsGenerating] = useState(false);
  const [isUploading, setIsUploading] = useState(false);

  async function load() {
    setLoading(true);
    const { data, error } = await supabase
      .from("routes")
      .select("*");
    
    setLoading(false);
    if (error) return toast.error(error.message);
    
    let sortedData = data ?? [];
    sortedData.sort((a, b) => {
      if (a.status === 'open' && b.status === 'completed') return -1;
      if (a.status === 'completed' && b.status === 'open') return 1;
      
      const dateA = new Date(a.start_date).getTime();
      const dateB = new Date(b.start_date).getTime();
      
      if (a.status === 'open') {
         return dateA - dateB; // Mais próxima primeiro
      } else {
         return dateB - dateA; // Mais recente primeiro
      }
    });
    
    setItems(sortedData);
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
      route_type: editing.route_type || "passeio",
      has_financial_plan: editing.has_financial_plan || false,
      cover_url: editing.cover_url || null,
      itinerary: editing.itinerary?.trim() || null,
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
      <Link to="/dashboard" className="self-start">
        <Button variant="ghost" size="sm" className="pl-0 text-leather hover:text-copper hover:bg-transparent -ml-2 mb-2">
          <ArrowLeft className="h-4 w-4 mr-1.5" /> Voltar para a garagem
        </Button>
      </Link>
      <div className="flex items-end justify-between gap-4 flex-wrap">
        <div>
          <h1 className="text-3xl md:text-4xl font-display" style={{ fontFamily: "var(--font-display)" }}>Rotas e Passeios</h1>
          <p className="text-leather/70 mt-1">Gerencie os próximos destinos do motoclube.</p>
        </div>
        {!open && (
          <Button onClick={startNew} className="btn-copper"><Plus className="h-4 w-4 mr-1" /> Criar nova rota</Button>
        )}
      </div>

      {open && (
        <div className="bg-[#d9cec1] text-coffee border border-leather/30 rounded-xl p-6 shadow-md mb-8">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-xl font-bold font-display" style={{ fontFamily: "var(--font-display)" }}>
              {editing.id ? "Editar Rota" : "Nova Rota"}
            </h2>
            <Button variant="ghost" size="sm" onClick={() => setOpen(false)} className="text-coffee hover:bg-leather/10">
              <X className="h-5 w-5" />
            </Button>
          </div>
          <div className="space-y-5">
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

              {editing.destination && editing.destination.trim() !== "" && (
                <div className="p-4 border border-leather/20 rounded-lg bg-black/5">
                  <div className="flex justify-between items-center mb-2 flex-wrap gap-2">
                    <Label className="text-coffee/80">Capa do Passeio</Label>
                    <div className="flex gap-2">
                      <div>
                        <input 
                          type="file" 
                          id="cover_upload" 
                          className="hidden" 
                          accept="image/*"
                          onChange={async (e) => {
                            const file = e.target.files?.[0];
                            if (!file) return;
                            try {
                              setIsUploading(true);
                              toast.info("Enviando imagem...", { id: "uploading" });
                              const url = await uploadMedia(file, "rotas");
                              setEditing(p => ({ ...p, cover_url: url }));
                              toast.success("Imagem enviada com sucesso!", { id: "uploading" });
                            } catch (err: any) {
                              toast.error(err.message || "Erro ao enviar imagem", { id: "uploading" });
                            } finally {
                              setIsUploading(false);
                              // Reset the input
                              e.target.value = "";
                            }
                          }}
                        />
                        <Button 
                          type="button"
                          variant="outline" 
                          size="sm" 
                          disabled={isUploading || isGenerating}
                          onClick={() => document.getElementById("cover_upload")?.click()}
                          className="h-7 text-xs border-coffee text-coffee hover:bg-coffee hover:text-white"
                        >
                          {isUploading ? <><Loader2 className="h-3 w-3 mr-1 animate-spin" /> Enviando...</> : <><Upload className="h-3 w-3 mr-1" /> Fazer Upload</>}
                        </Button>
                      </div>
                      <Button 
                        type="button"
                        variant="outline" 
                        size="sm" 
                        disabled={isGenerating || isUploading}
                        onClick={() => {
                          setIsGenerating(true);
                          toast.info("Gerando nova imagem... isso pode levar uns 5 segundos.", { id: "generating" });
                          const newUrl = `https://image.pollinations.ai/prompt/${encodeURIComponent(editing.destination + ' beautiful landscape motorcycle road trip cinematic realistic')}?width=1200&height=800&nologo=true&seed=${Math.floor(Math.random() * 100000)}&cb=${Date.now()}`;
                          
                          // Pre-load the image so the UI updates only when it's ready
                          const img = new Image();
                          img.onload = () => {
                            setEditing(p => ({ ...p, cover_url: newUrl }));
                            setIsGenerating(false);
                            toast.success("Nova imagem gerada com sucesso!", { id: "generating" });
                          };
                          img.onerror = () => {
                            setIsGenerating(false);
                            toast.error("Erro ao gerar imagem, tente novamente.", { id: "generating" });
                          };
                          img.src = newUrl;
                        }}
                        className="h-7 text-xs border-copper text-copper hover:bg-copper hover:text-white"
                      >
                        {isGenerating ? <><Loader2 className="h-3 w-3 mr-1 animate-spin" /> Gerando...</> : "Gerar com IA"}
                      </Button>
                    </div>
                  </div>
                  <div className="relative w-full h-40 bg-coffee/10 rounded-md overflow-hidden shadow-inner mb-3">
                    {isGenerating || isUploading ? (
                      <div className="absolute inset-0 flex items-center justify-center bg-black/10">
                        <Loader2 className="h-6 w-6 animate-spin text-copper" />
                      </div>
                    ) : (
                      <img 
                        src={editing.cover_url || `https://image.pollinations.ai/prompt/${encodeURIComponent(editing.destination + ' beautiful landscape motorcycle road trip cinematic realistic')}?width=1200&height=800&nologo=true`} 
                        alt="Preview Capa" 
                        className="w-full h-full object-cover opacity-80" 
                        loading="lazy"
                      />
                    )}
                  </div>
                  <Input 
                    placeholder="URL da imagem (se quiser colar o link de um site)" 
                    value={editing.cover_url ?? ""} 
                    onChange={(e) => setEditing((p) => ({ ...p, cover_url: e.target.value }))}
                    className="text-xs"
                  />
                  <p className="text-[10px] text-leather mt-2 uppercase tracking-wide">
                    Clique em Gerar para criar imagens diferentes com a IA ou cole a URL de uma foto real.
                  </p>
                </div>
              )}
              
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
                <Label>Descrição Curta</Label>
                <Textarea rows={2} value={editing.description ?? ""} onChange={(e) => setEditing((p) => ({ ...p, description: e.target.value }))} placeholder="Breve resumo sobre a rota..." />
              </div>

              <div>
                <Label>Roteiro Completo e Planejamento (Markdown/Texto Longo)</Label>
                <Textarea rows={10} value={editing.itinerary ?? ""} onChange={(e) => setEditing((p) => ({ ...p, itinerary: e.target.value }))} placeholder="Cole aqui o roteiro detalhado (Cronograma, Logística, Mapa, etc)..." className="font-mono text-sm leading-relaxed" />
                <p className="text-[10px] text-leather mt-1">Este campo aceita formatação Markdown (como **negrito**, # Títulos, - listas).</p>
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

              <div className="grid sm:grid-cols-2 gap-4">
                <div>
                  <Label>Tipo de Rota</Label>
                  <Select value={editing.route_type ?? "passeio"} onValueChange={(v) => setEditing((p) => ({ ...p, route_type: v as "passeio" | "viagem" }))}>
                    <SelectTrigger className="w-full"><SelectValue /></SelectTrigger>
                    <SelectContent>
                      <SelectItem value="passeio">Bate e Volta / Passeio</SelectItem>
                      <SelectItem value="viagem">Viagem Completa</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div>
                  <Label className="text-coffee/90 font-semibold mb-1 block">Status</Label>
                  <Select value={editing.status ?? "open"} onValueChange={(v) => setEditing((p) => ({ ...p, status: v as "open" | "completed" | "planning" }))}>
                    <SelectTrigger className="w-full bg-cream border-leather/30 text-coffee focus:ring-copper"><SelectValue /></SelectTrigger>
                    <SelectContent>
                      <SelectItem value="open">Em Aberto</SelectItem>
                      <SelectItem value="planning">Em Planejamento</SelectItem>
                      <SelectItem value="completed">Finalizada (Concluída)</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="flex items-center space-x-2 mt-4">
                <input 
                  type="checkbox" 
                  id="has_financial_plan"
                  className="w-4 h-4 rounded border-leather/30 text-copper focus:ring-copper"
                  checked={editing.has_financial_plan || false}
                  onChange={(e) => setEditing((p) => ({ ...p, has_financial_plan: e.target.checked }))}
                />
                <label htmlFor="has_financial_plan" className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
                  Habilitar recurso de Planejamento Financeiro para esta rota?
                </label>
              </div>

            </div>
            <div className="flex justify-end gap-3 mt-8 pt-4 border-t border-leather/20">
              <Button variant="outline" onClick={() => setOpen(false)} className="bg-white/50 border-white/50 text-coffee hover:bg-white hover:text-coffee">Cancelar</Button>
              <Button onClick={save} disabled={saving} className="btn-copper px-8">
                {saving ? "Salvando..." : "Salvar Rota"}
              </Button>
            </div>
        </div>
      )}

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
                        <span className="truncate flex items-center gap-1.5 font-semibold">
                          <MapPin className="h-3.5 w-3.5 text-copper shrink-0" /> {r.title}
                          {r.route_type === 'viagem' && (
                            <Badge variant="outline" className="bg-coffee/10 text-coffee border-coffee/20 ml-2 text-[10px] uppercase py-0 px-1.5 h-4">Viagem</Badge>
                          )}
                        </span>
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
                        {r.status === "completed" ? "Finalizada" : (r.status === "planning" ? "Planejamento" : "Em Aberto")}
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
