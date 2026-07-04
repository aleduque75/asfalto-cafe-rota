import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Bike, Gauge, Wrench, AlertTriangle, Clock, CheckCircle2, Plus, Route as RouteIcon, MapPin, Navigation, Calendar, Vote, ChevronRight, Gift, Calculator } from "lucide-react";

export const Route = createFileRoute("/_authenticated/dashboard")({
  head: () => ({ meta: [{ title: "Dashboard — Café Moto e Asfalto" }] }),
  component: DashboardPage,
});

type Moto = {
  id: string; brand: string; model: string; year: number | null;
  nickname: string | null; current_km: number; photo_url: string | null;
};

type Item = {
  id: string; motorcycle_id: string; name: string;
  interval_km: number | null; interval_months: number | null;
  last_change_km: number | null; last_change_date: string | null;
};

type Record_ = {
  id: string; motorcycle_id: string; service_date: string; item_name: string;
  km_at_service: number | null; cost: number | null;
};

type RouteData = {
  id: string; title: string; destination: string; start_date: string;
  waze_url: string | null; route_type: string;
};

type Alert = {
  item: Item;
  moto: Moto;
  status: "overdue" | "soon" | "ok";
  reason: string;
  progress: number;
};

function computeStatus(item: Item, currentKm: number): { status: "overdue" | "soon" | "ok"; reason: string; progress: number } {
  const kmDue = item.interval_km && item.last_change_km != null ? item.last_change_km + item.interval_km : null;
  const kmRemaining = kmDue != null ? kmDue - currentKm : null;
  const dateDue = item.interval_months && item.last_change_date
    ? new Date(new Date(item.last_change_date).setMonth(new Date(item.last_change_date).getMonth() + item.interval_months))
    : null;
  const daysRemaining = dateDue ? Math.ceil((dateDue.getTime() - Date.now()) / 86400000) : null;

  const overdueKm = kmRemaining != null && kmRemaining <= 0;
  const overdueDate = daysRemaining != null && daysRemaining <= 0;
  
  let progress = 0;
  if (item.interval_km && item.last_change_km != null) {
    progress = ((currentKm - item.last_change_km) / item.interval_km) * 100;
  }
  if (item.interval_months && item.last_change_date) {
    const start = new Date(item.last_change_date).getTime();
    const end = new Date(start).setMonth(new Date(start).getMonth() + item.interval_months);
    const current = Date.now();
    const dateProgress = ((current - start) / (end - start)) * 100;
    progress = Math.max(progress, dateProgress);
  }
  progress = Math.min(Math.max(progress, 0), 100);

  if (overdueKm || overdueDate) {
    const parts: string[] = [];
    if (overdueKm) parts.push(`${Math.abs(kmRemaining!).toLocaleString("pt-BR")} km vencidos`);
    if (overdueDate) parts.push(`${Math.abs(daysRemaining!)} dias vencidos`);
    return { status: "overdue", reason: parts.join(" · "), progress: 100 };
  }

  const soonKm = kmRemaining != null && item.interval_km != null && kmRemaining <= item.interval_km * 0.15;
  const soonDate = daysRemaining != null && daysRemaining <= 14;
  if (soonKm || soonDate) {
    const parts: string[] = [];
    if (soonKm) parts.push(`faltam ${kmRemaining!.toLocaleString("pt-BR")} km`);
    if (soonDate) parts.push(`faltam ${daysRemaining} dias`);
    return { status: "soon", reason: parts.join(" · "), progress };
  }
  
  const okParts: string[] = [];
  if (kmRemaining != null) okParts.push(`faltam ${kmRemaining.toLocaleString("pt-BR")} km`);
  if (daysRemaining != null) okParts.push(`faltam ${daysRemaining} dias`);
  return { status: "ok", reason: okParts.length > 0 ? okParts.join(" · ") : "monitorando", progress };
}

function DashboardPage() {
  const [loading, setLoading] = useState(true);
  const [motos, setMotos] = useState<Moto[]>([]);
  const [items, setItems] = useState<Item[]>([]);
  const [records, setRecords] = useState<Record_[]>([]);
  const [nextRoute, setNextRoute] = useState<RouteData | null>(null);
  const [activePolls, setActivePolls] = useState<any[]>([]);
  const [birthdays, setBirthdays] = useState<any[]>([]);
  const [fullName, setFullName] = useState<string>("");
  const [activePlan, setActivePlan] = useState<{ id: string, routeId: string, routeTitle: string, total: number } | null>(null);

  useEffect(() => {
    (async () => {
      const { data: u } = await supabase.auth.getUser();
      if (!u.user) return;
      const { data: m } = await supabase.from("motorcycles").select("*").eq("user_id", u.user.id).order("created_at", { ascending: false });
      const motoIds = (m || []).map(moto => moto.id);
      
      const [{ data: p }, { data: it }, { data: rc }, { data: rt }, { data: polls }, { data: bdays }, { data: plansData }] = await Promise.all([
        supabase.from("profiles").select("full_name, partner_id").eq("id", u.user.id).maybeSingle(),
        motoIds.length > 0 ? supabase.from("maintenance_items").select("*").in("motorcycle_id", motoIds) : Promise.resolve({ data: [] }),
        motoIds.length > 0 ? supabase.from("maintenance_records").select("*").in("motorcycle_id", motoIds).order("service_date", { ascending: false }).limit(8) : Promise.resolve({ data: [] }),
        supabase.from("routes").select("id, title, destination, start_date, waze_url, route_type").in("status", ["open", "planning"]).order("start_date", { ascending: true }).limit(1).maybeSingle(),
        (supabase as any).from("polls").select("*").eq("status", "active"),
        supabase.rpc("get_todays_birthdays"),
        supabase.from("trip_financial_plans").select(`id, costs, profile_id, route:routes(id, title, status)`)
      ]);
      setFullName((p?.full_name as string) || u.user.email || "");
      setMotos((m ?? []) as Moto[]);
      setItems((it ?? []) as Item[]);
      setRecords((rc ?? []) as Record_[]);
      setNextRoute(rt as RouteData | null);
      setActivePolls(polls || []);
      setBirthdays(bdays || []);
      
      const partnerId = p?.partner_id || null;
      const myPlan = (plansData as any[])?.find(plan => 
        (plan.profile_id === u.user.id || plan.profile_id === partnerId) &&
        (plan.route?.status === 'open' || plan.route?.status === 'planning')
      );
      if (myPlan && myPlan.route && myPlan.costs && typeof myPlan.costs === 'object') {
        const total = Object.values(myPlan.costs).reduce((sum: number, val: any) => sum + (Number(val) || 0), 0);
        setActivePlan({ id: myPlan.id, routeId: myPlan.route.id, routeTitle: myPlan.route.title, total });
      }
      
      setLoading(false);
    })();
  }, []);

  const motoById = new Map(motos.map((m) => [m.id, m]));

  const alerts: Alert[] = items
    .map((item) => {
      const moto = motoById.get(item.motorcycle_id);
      if (!moto) return null;
      const s = computeStatus(item, moto.current_km);
      return { item, moto, status: s.status, reason: s.reason, progress: s.progress } as Alert;
    })
    .filter((a): a is Alert => a !== null)
    .sort((a, b) => b.progress - a.progress);

  const overdueCount = alerts.filter((a) => a.status === "overdue").length;
  const soonCount = alerts.filter((a) => a.status === "soon").length;
  const totalKm = motos.reduce((acc, m) => acc + (m.current_km || 0), 0);

  if (loading) return <p className="text-leather">Carregando…</p>;

  return (
    <div className="space-y-10">
      <div>
        <p className="text-xs uppercase tracking-[0.25em] text-copper mb-2">Painel do membro</p>
        <h1 className="font-display text-3xl md:text-4xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>
          Bem-vindo, {fullName.split(" ")[0] || "piloto"}
        </h1>
        <p className="text-sm text-leather mt-2">Resumo da sua garagem, alertas de manutenção e atividades recentes.</p>
      </div>

      {(overdueCount > 0 || soonCount > 0) && (
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 sm:gap-4">
          {overdueCount > 0 && (
            <StatCard icon={<AlertTriangle className="h-5 w-5" />} label="Itens vencidos" value={String(overdueCount)} tone="danger" />
          )}
          {soonCount > 0 && (
            <StatCard icon={<Clock className="h-5 w-5" />} label="Vencendo em breve" value={String(soonCount)} tone="warn" />
          )}
        </div>
      )}

      {birthdays.length > 0 && (
        <section className="mb-10">
          <Card className="bg-gradient-to-r from-copper to-copper-glow text-coffee border-none shadow-warm overflow-hidden relative">
            <div className="absolute top-0 right-0 p-4 opacity-20 pointer-events-none">
              <Gift className="w-32 h-32" />
            </div>
            <CardContent className="p-6">
              <div className="flex items-center gap-4 relative z-10">
                <div className="bg-coffee/10 p-3 rounded-full shrink-0">
                  <Gift className="w-8 h-8 text-coffee" />
                </div>
                <div>
                  <h2 className="font-display text-2xl mb-1" style={{ fontFamily: "var(--font-display)" }}>
                    Feliz Aniversário! 🎉
                  </h2>
                  <p className="text-coffee/80 font-medium">
                    Hoje é o dia de comemorar com:{" "}
                    {birthdays.map(b => b.nickname || b.full_name?.split(" ")[0]).join(", ")}. Deixe seus parabéns!
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        </section>
      )}

      {activePolls && activePolls.length > 0 && (
        <section className="mb-10">
          <Link to="/enquetes">
            <Card className="bg-copper text-cream border-none shadow-lg overflow-hidden relative cursor-pointer hover:bg-copper/90 transition-colors">
              <div className="absolute top-0 right-0 p-4 opacity-10 pointer-events-none">
                <Vote className="w-32 h-32" />
              </div>
              <CardContent className="p-6">
                <div className="flex items-center justify-between relative z-10">
                  <div className="flex items-center gap-4">
                    <div className="bg-cream/20 p-3 rounded-full">
                      <Vote className="w-6 h-6" />
                    </div>
                    <div>
                      <h2 className="font-display text-2xl mb-1" style={{ fontFamily: "var(--font-display)" }}>
                        Enquete Aberta!
                      </h2>
                      <p className="text-cream/80 text-sm">
                        Há {activePolls.length} votação(ões) em andamento. Sua opinião é importante.
                      </p>
                    </div>
                  </div>
                  <ChevronRight className="w-6 h-6" />
                </div>
              </CardContent>
            </Card>
          </Link>
        </section>
      )}

      <section>
        {activePlan && (
          <Card className="bg-copper/5 border-copper/30 shadow-md overflow-hidden relative mb-10">
            <div className="absolute top-0 right-0 p-4 opacity-5 pointer-events-none">
              <Calculator className="w-32 h-32 text-copper" />
            </div>
            <CardContent className="p-6">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 relative z-10">
                <div className="flex-1">
                  <Badge className="bg-copper text-cream border-none mb-3">Meu Planejamento</Badge>
                  <h2 className="font-display text-2xl text-coffee mb-1" style={{ fontFamily: "var(--font-display)" }}>
                    {activePlan.routeTitle}
                  </h2>
                  <p className="text-sm text-leather mb-2">Custo total planejado para a viagem</p>
                  <p className="text-3xl font-bold text-coffee">
                    {activePlan.total.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })}
                  </p>
                </div>
                <div className="flex flex-col sm:flex-row gap-3 min-w-[200px]">
                  <Link to="/rotas/$id/financeiro" params={{ id: activePlan.routeId }} className="flex-1">
                    <Button className="w-full btn-copper flex gap-2">
                      <Calculator className="h-4 w-4" /> Abrir Planilha
                    </Button>
                  </Link>
                </div>
              </div>
            </CardContent>
          </Card>
        )}

        {nextRoute ? (
          <Card className="bg-cream border-copper/30 shadow-md overflow-hidden relative mb-10">
            <div className="absolute top-0 right-0 p-4 opacity-5 pointer-events-none">
              <RouteIcon className="w-32 h-32 text-copper" />
            </div>
            <CardContent className="p-6">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 relative z-10">
                <div className="flex-1">
                  <Badge className="bg-copper text-cream border-none mb-3">Próximo Passeio</Badge>
                  <h2 className="font-display text-2xl text-coffee mb-2" style={{ fontFamily: "var(--font-display)" }}>
                    {nextRoute.title}
                  </h2>
                  <div className="flex flex-wrap items-center gap-4 text-sm text-leather">
                    <span className="flex items-center gap-1.5"><Calendar className="w-4 h-4 text-copper" /> {new Date(nextRoute.start_date).toLocaleDateString("pt-BR")}</span>
                    <span className="flex items-center gap-1.5"><MapPin className="w-4 h-4 text-copper" /> {nextRoute.destination}</span>
                    <span className="flex items-center gap-1.5 font-medium text-copper">
                      <Clock className="w-4 h-4" /> 
                      {(() => {
                        const days = Math.ceil((new Date(nextRoute.start_date).getTime() - Date.now()) / 86400000);
                        return days > 0 ? `Faltam ${days} dias` : days === 0 ? "É Hoje!" : "Atrasado";
                      })()}
                    </span>
                  </div>
                </div>
                <div className="flex flex-col sm:flex-row gap-3 min-w-[200px]">
                  <Link to="/rotas" className="flex-1">
                    <Button variant="outline" className="w-full border-copper text-copper hover:bg-copper/10">Ver Detalhes</Button>
                  </Link>
                  {nextRoute.route_type === 'viagem' && (
                    <Link to="/rotas/$id/financeiro" params={{ id: nextRoute.id }} className="flex-1">
                      <Button variant="outline" className="w-full border-copper text-copper hover:bg-copper hover:text-white flex gap-2">
                        <Calculator className="h-4 w-4" /> Planejamento
                      </Button>
                    </Link>
                  )}
                  <Button className="flex-1 btn-copper flex gap-2" onClick={() => {
                    const wazeLink = nextRoute.waze_url?.trim() || `https://waze.com/ul?q=${encodeURIComponent(nextRoute.destination)}&navigate=yes`;
                    window.open(wazeLink, "_blank");
                  }}>
                    <Navigation className="h-4 w-4" /> Waze
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>
        ) : (
          <Card className="bg-cream border-dashed border-leather/30 shadow-none overflow-hidden mb-10">
            <CardContent className="p-8 text-center flex flex-col items-center">
              <RouteIcon className="w-10 h-10 text-copper/40 mb-3" />
              <h2 className="font-display text-xl text-coffee mb-1" style={{ fontFamily: "var(--font-display)" }}>
                Sem passeios programados
              </h2>
              <p className="text-sm text-leather mb-4">
                Acompanhe o histórico de rolês passados na área de rotas.
              </p>
              <Link to="/rotas">
                <Button variant="outline" className="border-copper text-copper hover:bg-copper/10 px-8">
                  Ver Histórico
                </Button>
              </Link>
            </CardContent>
          </Card>
        )}
      </section>

      <section>
        <div className="flex items-end justify-between mb-4">
          <div>
            <h2 className="font-display text-2xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>Minhas motos</h2>
            <p className="text-sm text-leather">Acesso rápido à sua garagem.</p>
          </div>
          <Link to="/garagem"><Button variant="outline" size="sm" className="border-leather/40 text-coffee bg-transparent hover:bg-leather/10">Ver todas</Button></Link>
        </div>
        {motos.length === 0 ? (
          <Card className="border-dashed border-leather/40 bg-cream">
            <CardContent className="py-12 text-center">
              <Bike className="h-10 w-10 mx-auto mb-3 text-copper" />
              <p className="text-leather mb-4">Nenhuma moto cadastrada ainda.</p>
              <Link to="/garagem"><Button className="btn-copper"><Plus className="h-4 w-4" /> Cadastrar moto</Button></Link>
            </CardContent>
          </Card>
        ) : (
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {motos.slice(0, 6).map((m) => {
              const motoAlerts = alerts.filter((a) => a.moto.id === m.id);
              return (
                <Link key={m.id} to="/garagem/$id" params={{ id: m.id }}>
                  <Card className="overflow-hidden border-leather/30 hover:border-copper hover:shadow-lg transition h-full bg-cream">
                    <div className="aspect-[16/9] bg-gradient-to-br from-coffee to-leather flex items-center justify-center">
                      {m.photo_url ? (
                        <img src={m.photo_url} alt={`${m.brand} ${m.model}`} className="w-full h-full object-cover" />
                      ) : (
                        <Bike className="h-12 w-12 text-copper/60" />
                      )}
                    </div>
                    <CardContent className="p-4">
                      <p className="text-[10px] uppercase tracking-[0.25em] text-copper">{m.brand}</p>
                      <h3 className="font-display text-lg text-coffee" style={{ fontFamily: "var(--font-display)" }}>
                        {m.nickname || m.model}
                      </h3>
                      <div className="flex items-center justify-between mt-2 text-sm">
                        <span className="flex items-center gap-1 text-coffee"><Gauge className="h-3.5 w-3.5 text-copper" /> {m.current_km.toLocaleString("pt-BR")} km</span>
                        {motoAlerts.length > 0 ? (
                          <Badge variant="destructive" className="text-[10px]">{motoAlerts.length} alerta{motoAlerts.length > 1 ? "s" : ""}</Badge>
                        ) : (
                          <span className="flex items-center gap-1 text-xs text-emerald-700"><CheckCircle2 className="h-3.5 w-3.5" /> em dia</span>
                        )}
                      </div>
                    </CardContent>
                  </Card>
                </Link>
              );
            })}
          </div>
        )}
      </section>

      <section className="grid lg:grid-cols-2 gap-6">
        <Card className="bg-cream border-leather/30">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-display text-xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>Alertas de manutenção</h2>
              <AlertTriangle className="h-5 w-5 text-copper" />
            </div>
            {alerts.length === 0 ? (
              <p className="text-sm text-leather flex items-center gap-2"><CheckCircle2 className="h-4 w-4 text-emerald-700" /> Tudo em dia. Boa pilotagem!</p>
            ) : (
              <ul className="space-y-3">
                {alerts.slice(0, 6).map((a) => (
                  <li key={a.item.id}>
                    <Link to="/garagem/$id" params={{ id: a.moto.id }} className="block rounded-md border border-leather/20 p-3 hover:border-copper transition bg-white/50">
                      <div className="flex items-start justify-between gap-3 mb-2">
                        <div>
                          <p className="text-sm font-medium text-coffee">{a.item.name}</p>
                          <p className="text-xs text-leather">{a.moto.nickname || `${a.moto.brand} ${a.moto.model}`} · {a.reason}</p>
                        </div>
                        <Badge variant={a.status === "overdue" ? "destructive" : a.status === "soon" ? "secondary" : "outline"} className={`text-[10px] shrink-0 ${a.status === 'ok' ? 'border-emerald-600 text-emerald-700' : ''}`}>
                          {a.status === "overdue" ? "Vencido" : a.status === "soon" ? "Em breve" : "Em dia"}
                        </Badge>
                      </div>
                      <div className="w-full bg-leather/20 rounded-full h-1.5 overflow-hidden">
                        <div 
                          className={`h-full rounded-full transition-all ${a.status === 'overdue' ? 'bg-red-600' : a.progress > 85 ? 'bg-amber-500' : 'bg-emerald-500'}`} 
                          style={{ width: `${a.progress}%` }} 
                        />
                      </div>
                    </Link>
                  </li>
                ))}
              </ul>
            )}
          </CardContent>
        </Card>

        <Card className="bg-cream border-leather/30">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-display text-xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>Últimos lançamentos</h2>
              <Wrench className="h-5 w-5 text-copper" />
            </div>
            {records.length === 0 ? (
              <p className="text-sm text-leather">Nenhuma manutenção registrada ainda.</p>
            ) : (
              <ul className="space-y-3">
                {records.map((r) => {
                  const m = motoById.get(r.motorcycle_id);
                  return (
                    <li key={r.id} className="flex items-start justify-between gap-3 border-b border-leather/15 pb-2 last:border-0">
                      <div>
                        <p className="text-sm font-medium text-coffee">{r.item_name}</p>
                        <p className="text-xs text-leather">
                          {m ? (m.nickname || `${m.brand} ${m.model}`) : "—"} · {new Date(r.service_date).toLocaleDateString("pt-BR")}
                          {r.km_at_service != null ? ` · ${r.km_at_service.toLocaleString("pt-BR")} km` : ""}
                        </p>
                      </div>
                      {r.cost != null && (
                        <span className="text-xs text-coffee font-medium">R$ {r.cost.toLocaleString("pt-BR", { minimumFractionDigits: 2 })}</span>
                      )}
                    </li>
                  );
                })}
              </ul>
            )}
          </CardContent>
        </Card>
      </section>
    </div>
  );
}

function StatCard({ icon, label, value, tone }: { icon: React.ReactNode; label: string; value: string; tone?: "danger" | "warn" }) {
  const toneCls = tone === "danger" ? "text-red-700" : tone === "warn" ? "text-amber-700" : "text-coffee";
  return (
    <Card className="bg-cream border-leather/30">
      <CardContent className="p-5">
        <div className="flex items-center justify-between text-copper mb-2">
          <span className="text-[10px] uppercase tracking-[0.25em]">{label}</span>
          {icon}
        </div>
        <p className={`font-display text-3xl ${toneCls}`} style={{ fontFamily: "var(--font-display)" }}>{value}</p>
      </CardContent>
    </Card>
  );
}