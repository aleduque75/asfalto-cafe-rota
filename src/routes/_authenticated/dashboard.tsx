import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Bike, Gauge, Wrench, AlertTriangle, Clock, CheckCircle2, Plus } from "lucide-react";

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

type Alert = {
  item: Item;
  moto: Moto;
  status: "overdue" | "soon";
  reason: string;
};

function computeStatus(item: Item, currentKm: number): { status: "overdue" | "soon" | "ok"; reason: string } {
  const kmDue = item.interval_km && item.last_change_km != null ? item.last_change_km + item.interval_km : null;
  const kmRemaining = kmDue != null ? kmDue - currentKm : null;
  const dateDue = item.interval_months && item.last_change_date
    ? new Date(new Date(item.last_change_date).setMonth(new Date(item.last_change_date).getMonth() + item.interval_months))
    : null;
  const daysRemaining = dateDue ? Math.ceil((dateDue.getTime() - Date.now()) / 86400000) : null;

  const overdueKm = kmRemaining != null && kmRemaining <= 0;
  const overdueDate = daysRemaining != null && daysRemaining <= 0;
  if (overdueKm || overdueDate) {
    const parts: string[] = [];
    if (overdueKm) parts.push(`${Math.abs(kmRemaining!).toLocaleString("pt-BR")} km vencidos`);
    if (overdueDate) parts.push(`${Math.abs(daysRemaining!)} dias vencidos`);
    return { status: "overdue", reason: parts.join(" · ") };
  }

  const soonKm = kmRemaining != null && item.interval_km != null && kmRemaining <= item.interval_km * 0.15;
  const soonDate = daysRemaining != null && daysRemaining <= 14;
  if (soonKm || soonDate) {
    const parts: string[] = [];
    if (soonKm) parts.push(`faltam ${kmRemaining!.toLocaleString("pt-BR")} km`);
    if (soonDate) parts.push(`faltam ${daysRemaining} dias`);
    return { status: "soon", reason: parts.join(" · ") };
  }
  return { status: "ok", reason: "" };
}

function DashboardPage() {
  const [loading, setLoading] = useState(true);
  const [motos, setMotos] = useState<Moto[]>([]);
  const [items, setItems] = useState<Item[]>([]);
  const [records, setRecords] = useState<Record_[]>([]);
  const [fullName, setFullName] = useState<string>("");

  useEffect(() => {
    (async () => {
      const { data: u } = await supabase.auth.getUser();
      if (!u.user) return;
      const [{ data: p }, { data: m }, { data: it }, { data: rc }] = await Promise.all([
        supabase.from("profiles").select("full_name").eq("id", u.user.id).maybeSingle(),
        supabase.from("motorcycles").select("*").order("created_at", { ascending: false }),
        supabase.from("maintenance_items").select("*"),
        supabase.from("maintenance_records").select("*").order("service_date", { ascending: false }).limit(8),
      ]);
      setFullName((p?.full_name as string) || u.user.email || "");
      setMotos((m ?? []) as Moto[]);
      setItems((it ?? []) as Item[]);
      setRecords((rc ?? []) as Record_[]);
      setLoading(false);
    })();
  }, []);

  const motoById = new Map(motos.map((m) => [m.id, m]));

  const alerts: Alert[] = items
    .map((item) => {
      const moto = motoById.get(item.motorcycle_id);
      if (!moto) return null;
      const s = computeStatus(item, moto.current_km);
      if (s.status === "ok") return null;
      return { item, moto, status: s.status, reason: s.reason } as Alert;
    })
    .filter((a): a is Alert => a !== null)
    .sort((a, b) => (a.status === "overdue" ? -1 : 1) - (b.status === "overdue" ? -1 : 1));

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

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4">
        <StatCard icon={<Bike className="h-5 w-5" />} label="Motos cadastradas" value={String(motos.length)} />
        <StatCard icon={<Gauge className="h-5 w-5" />} label="KM total da frota" value={totalKm.toLocaleString("pt-BR")} />
        <StatCard icon={<AlertTriangle className="h-5 w-5" />} label="Itens vencidos" value={String(overdueCount)} tone={overdueCount > 0 ? "danger" : undefined} />
        <StatCard icon={<Clock className="h-5 w-5" />} label="Vencendo em breve" value={String(soonCount)} tone={soonCount > 0 ? "warn" : undefined} />
      </div>

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
                    <Link to="/garagem/$id" params={{ id: a.moto.id }} className="block rounded-md border border-leather/20 p-3 hover:border-copper transition">
                      <div className="flex items-start justify-between gap-3">
                        <div>
                          <p className="text-sm font-medium text-coffee">{a.item.name}</p>
                          <p className="text-xs text-leather">{a.moto.nickname || `${a.moto.brand} ${a.moto.model}`} · {a.reason}</p>
                        </div>
                        <Badge variant={a.status === "overdue" ? "destructive" : "secondary"} className="text-[10px] shrink-0">
                          {a.status === "overdue" ? "Vencido" : "Em breve"}
                        </Badge>
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