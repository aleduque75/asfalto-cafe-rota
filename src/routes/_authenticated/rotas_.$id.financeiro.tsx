import { createFileRoute, Link } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { ArrowLeft, Save, Calculator, Users, Info, Plus, CheckCircle2, Circle, AlertCircle, Edit, Trash2, MoreVertical } from "lucide-react";
import { toast } from "sonner";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogFooter } from "@/components/ui/dialog";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";

export const Route = createFileRoute("/_authenticated/rotas_/financeiro")({
  head: () => ({ meta: [{ title: "Planejamento Financeiro — Café Moto e Asfalto" }] }),
  component: RouteFinanceiroPage,
});

type Costs = {
  revisao: number; hospedagem: number; alimentacao: number; reserva: number;
  combustivel: number; pedagio: number; passeios: number; outros: number;
};

type FuelCalc = {
  distance: number; autonomy: number; price: number;
};

type PlanData = {
  id: string; profile_id: string; has_passenger: boolean;
  costs: Costs; fuel_calc: FuelCalc;
  profile?: { full_name: string | null; nickname: string | null; partner_id: string | null; };
  partner?: { full_name: string | null; nickname: string | null; } | null;
};

type Payment = {
  id: string; installment_id: string; plan_id: string; is_paid: boolean; paid_at: string | null;
};

type Installment = {
  id: string; expense_id: string; installment_number: number;
  amount: number; due_date: string; payments: Payment[];
};

type SharedExpense = {
  id: string; route_id: string; title: string; total_amount: number; description: string | null; link: string | null; paid_by: string | null; participating_plans: string[];
  created_at: string; installments: Installment[];
};

function RouteFinanceiroPage() {
  const { id: routeId } = Route.useParams();
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [routeTitle, setRouteTitle] = useState("");
  const [userId, setUserId] = useState("");
  const [partnerId, setPartnerId] = useState<string | null>(null);
  const [myPlanId, setMyPlanId] = useState<string | null>(null);
  const [allPlans, setAllPlans] = useState<PlanData[]>([]);
  const [isAdmin, setIsAdmin] = useState(false);
  const [sharedExpenses, setSharedExpenses] = useState<SharedExpense[]>([]);

  const [costs, setCosts] = useState<Costs>({
    revisao: 0, hospedagem: 0, alimentacao: 0, reserva: 0,
    combustivel: 0, pedagio: 0, passeios: 0, outros: 0
  });

  const [fuelCalc, setFuelCalc] = useState<FuelCalc>({
    distance: 0, autonomy: 0, price: 0
  });

  async function loadData() {
    setLoading(true);
    const { data: u } = await supabase.auth.getUser();
    if (!u.user) return;
    setUserId(u.user.id);

    // Check if user is admin
    const { data: roleData } = await supabase.from("user_roles").select("role").eq("user_id", u.user.id).maybeSingle();
    setIsAdmin(roleData?.role === "admin");

    // Get Route info
    const { data: routeData } = await supabase.from("routes").select("title").eq("id", routeId).maybeSingle();
    if (routeData) setRouteTitle(routeData.title);

    // Get current user profile
    const { data: profile } = await supabase.from("profiles").select("partner_id").eq("id", u.user.id).maybeSingle();
    const myPartnerId = profile?.partner_id || null;
    setPartnerId(myPartnerId);

    // Load all plans
    const { data: plansData, error } = await supabase
      .from("trip_financial_plans")
      .select(`*, profile:profiles(full_name, nickname, partner_id)`)
      .eq("route_id", routeId);

    if (error) { toast.error("Erro ao carregar planos"); setLoading(false); return; }

    const enrichedPlans: PlanData[] = [];
    for (const p of (plansData as any[])) {
      let partnerData = null;
      if (p.profile?.partner_id) {
        const { data: pt } = await supabase.from("profiles").select("full_name, nickname").eq("id", p.profile.partner_id).maybeSingle();
        partnerData = pt;
      }
      enrichedPlans.push({
        id: p.id, profile_id: p.profile_id, has_passenger: p.has_passenger,
        costs: p.costs as Costs, fuel_calc: p.fuel_calc as FuelCalc,
        profile: p.profile, partner: partnerData
      });
    }
    setAllPlans(enrichedPlans);

    const existingPlan = enrichedPlans.find(p => p.profile_id === u.user.id || p.profile_id === myPartnerId);
    if (existingPlan) {
      setMyPlanId(existingPlan.id);
      setCosts(existingPlan.costs);
      setFuelCalc(existingPlan.fuel_calc);
    }

    // Load shared expenses
    const { data: sharedData, error: sharedErr } = await supabase
      .from("trip_shared_expenses")
      .select(`
        *,
        installments:trip_expense_installments(
          *,
          payments:trip_installment_payments(*)
        )
      `)
      .eq("route_id", routeId)
      .order("created_at", { ascending: true });

    if (sharedData) {
      // sort installments by number
      sharedData.forEach(s => {
        if (s.installments) s.installments.sort((a: any, b: any) => a.installment_number - b.installment_number);
      });
      setSharedExpenses(sharedData as SharedExpense[]);
    }

    setLoading(false);
  }

  useEffect(() => { loadData(); }, [routeId]);

  useEffect(() => {
    if (fuelCalc.distance > 0 && fuelCalc.autonomy > 0 && fuelCalc.price > 0) {
      const estimatedCost = (fuelCalc.distance / fuelCalc.autonomy) * fuelCalc.price;
      setCosts(prev => ({ ...prev, combustivel: Number(estimatedCost.toFixed(2)) }));
    } else {
      setCosts(prev => ({ ...prev, combustivel: 0 }));
    }
  }, [fuelCalc]);

  const handleSave = async () => {
    setSaving(true);
    const payload = {
      route_id: routeId,
      profile_id: myPlanId ? allPlans.find(p => p.id === myPlanId)?.profile_id || userId : userId,
      has_passenger: partnerId ? true : false,
      costs, fuel_calc: fuelCalc, observations: {}
    };

    if (myPlanId) {
      const { error } = await supabase.from("trip_financial_plans").update(payload).eq("id", myPlanId);
      if (error) toast.error("Erro ao salvar: " + error.message);
      else toast.success("Planilha atualizada!");
    } else {
      const { data, error } = await supabase.from("trip_financial_plans").insert(payload).select().single();
      if (error) toast.error("Erro ao criar: " + error.message);
      else { toast.success("Planilha criada!"); if (data) setMyPlanId(data.id); }
    }
    setSaving(false);
    loadData();
  };

  const calculateTotal = (c: Costs) => Object.values(c).reduce((a, b) => a + (Number(b) || 0), 0);

  const numMotos = allPlans.length || 1;
  
  // My totals
  const myManualTotal = calculateTotal(costs);
  const mySharedTotal = sharedExpenses.reduce((sum, exp) => {
    if (myPlanId && exp.participating_plans?.includes(myPlanId)) {
      return sum + (exp.total_amount / (exp.participating_plans.length || 1));
    }
    return sum;
  }, 0);
  const myTotal = myManualTotal + mySharedTotal;
  const myPerPerson = partnerId ? myTotal / 2 : myTotal;

  // Group totals
  const totalGroupManual = allPlans.reduce((sum, p) => sum + calculateTotal(p.costs), 0);
  const totalGroupShared = sharedExpenses.reduce((sum, exp) => sum + exp.total_amount, 0);
  const totalGroup = totalGroupManual + totalGroupShared;
  const avgPerMoto = allPlans.length > 0 ? totalGroup / allPlans.length : 0;

  if (loading) return <div className="p-8 text-coffee">Carregando...</div>;

  return (
    <div className="space-y-6 pb-24">
      <div className="flex flex-col gap-4">
        <Link to="/rotas" className="self-start">
          <Button variant="ghost" size="sm" className="pl-0 text-leather hover:text-copper hover:bg-transparent -ml-2">
            <ArrowLeft className="h-4 w-4 mr-1.5" /> Voltar para rotas
          </Button>
        </Link>
        <div>
          <p className="text-xs uppercase tracking-[0.25em] text-copper mb-2">Financeiro</p>
          <h1 className="font-display text-3xl md:text-4xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>
            Planejamento de Custos
          </h1>
          <p className="text-sm text-coffee mt-2 font-semibold">Viagem: {routeTitle}</p>
        </div>
      </div>

      <Tabs defaultValue="geral" className="w-full">
        <TabsList className="grid w-full grid-cols-3 mb-6 bg-cream border border-leather/20 h-auto sm:h-10">
          <TabsTrigger value="geral" className="text-xs sm:text-sm data-[state=active]:bg-coffee data-[state=active]:text-cream text-coffee py-2">
            Resumo Geral
          </TabsTrigger>
          <TabsTrigger value="minha" className="text-xs sm:text-sm data-[state=active]:bg-copper data-[state=active]:text-cream text-coffee py-2">
            Minha Planilha
          </TabsTrigger>
          <TabsTrigger value="grupo" className="text-xs sm:text-sm data-[state=active]:bg-leather data-[state=active]:text-cream text-coffee py-2">
            Despesas em Grupo
          </TabsTrigger>
        </TabsList>

        <TabsContent value="geral">
          {/* ... existing geral content ... */}
          <Card className="border-leather/30 bg-cream mb-6">
            <CardHeader className="bg-coffee text-cream rounded-t-lg pb-4">
              <CardTitle className="text-xl font-display uppercase tracking-widest" style={{ fontFamily: "var(--font-display)" }}>
                Custo Consolidado do Grupo
              </CardTitle>
            </CardHeader>
            <CardContent className="p-0">
              <div className="flex flex-col sm:grid sm:grid-cols-3 divide-y sm:divide-y-0 sm:divide-x divide-leather/30 bg-cream/50 text-coffee border-b border-leather/30">
                <div className="p-4 text-center">
                  <p className="text-xs font-bold uppercase text-coffee/80">Total do Grupo</p>
                  <p className="text-xl sm:text-2xl font-bold mt-1">
                    {totalGroup.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                  </p>
                </div>
                <div className="p-4 text-center">
                  <p className="text-xs font-bold uppercase text-coffee/80">Nº de Motos/Casais</p>
                  <p className="text-xl sm:text-2xl font-bold mt-1">{allPlans.length}</p>
                </div>
                <div className="p-4 text-center">
                  <p className="text-xs font-bold uppercase text-coffee/80">Custo Médio / Moto</p>
                  <p className="text-xl sm:text-2xl font-bold mt-1">
                    {avgPerMoto.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                  </p>
                </div>
              </div>
              <div className="p-4 text-sm text-center text-leather">
                (O total do grupo inclui as despesas compartilhadas: {totalGroupShared.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })})
              </div>

              <div className="overflow-x-auto p-4 border-t border-leather/30">
                <Table>
                  <TableHeader>
                    <TableRow className="border-leather/20 bg-coffee/5 hover:bg-coffee/5">
                      <TableHead className="font-bold text-coffee">Item</TableHead>
                      {allPlans.map(p => {
                        const pilotName = p.profile?.nickname || p.profile?.full_name?.split(" ")[0] || "Moto";
                        const partnerName = p.partner?.nickname || p.partner?.full_name?.split(" ")[0];
                        const displayName = partnerName ? `${pilotName} e ${partnerName}` : pilotName;
                        return <TableHead key={p.id} className="text-center font-bold text-coffee min-w-[120px]">{displayName}</TableHead>
                      })}
                      <TableHead className="text-right font-bold text-coffee min-w-[120px]">TOTAL</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {[
                      { key: 'revisao', label: 'Revisão da Moto' },
                      { key: 'hospedagem', label: 'Hospedagem' },
                      { key: 'alimentacao', label: 'Alimentação' },
                      { key: 'reserva', label: 'Reserva' },
                      { key: 'combustivel', label: 'Combustível' },
                      { key: 'pedagio', label: 'Pedágio' },
                      { key: 'passeios', label: 'Passeios/Atrações' },
                      { key: 'outros', label: 'Outros' }
                    ].map((category) => {
                      const rowTotal = allPlans.reduce((sum, p) => sum + (p.costs[category.key as keyof Costs] || 0), 0);
                      return (
                        <TableRow key={category.key} className="border-leather/20">
                          <TableCell className="font-medium text-coffee">{category.label}</TableCell>
                          {allPlans.map(p => (
                            <TableCell key={p.id} className="text-center">
                              {p.costs[category.key as keyof Costs] > 0 
                                ? p.costs[category.key as keyof Costs].toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })
                                : '-'}
                            </TableCell>
                          ))}
                          <TableCell className="text-right font-bold">
                            {rowTotal.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                          </TableCell>
                        </TableRow>
                      );
                    })}

                    <TableRow className="border-leather/20 bg-coffee/5">
                      <TableCell className="font-medium text-coffee">Despesas Compartilhadas</TableCell>
                      {allPlans.map(p => {
                        const myShared = sharedExpenses.reduce((sum, exp) => {
                          if (exp.participating_plans?.includes(p.id)) {
                            return sum + (exp.total_amount / (exp.participating_plans.length || 1));
                          }
                          return sum;
                        }, 0);
                        return (
                          <TableCell key={p.id} className="text-center text-copper font-bold">
                            {myShared > 0 ? myShared.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }) : '-'}
                          </TableCell>
                        )
                      })}
                      <TableCell className="text-right font-bold text-copper">
                        {totalGroupShared.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                      </TableCell>
                    </TableRow>
                    
                    {/* Row Totals */}
                    <TableRow className="border-leather/40 bg-leather/10 hover:bg-leather/10">
                      <TableCell className="font-bold text-coffee uppercase text-xs">Total Moto</TableCell>
                      {allPlans.map(p => {
                        const pTotalManual = calculateTotal(p.costs);
                        const pTotalShared = sharedExpenses.reduce((sum, exp) => {
                          if (exp.participating_plans?.includes(p.id)) {
                            return sum + (exp.total_amount / (exp.participating_plans.length || 1));
                          }
                          return sum;
                        }, 0);
                        const pTotal = pTotalManual + pTotalShared;
                        return <TableCell key={`total-${p.id}`} className="text-center font-bold text-coffee">{pTotal.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}</TableCell>
                      })}
                      <TableCell className="text-right font-black text-coffee">{totalGroup.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}</TableCell>
                    </TableRow>
                    
                    <TableRow className="border-none bg-cream hover:bg-cream">
                      <TableCell className="font-bold text-copper uppercase text-xs">Por Pessoa</TableCell>
                      {allPlans.map(p => {
                        const pTotalManual = calculateTotal(p.costs);
                        const pTotalShared = sharedExpenses.reduce((sum, exp) => {
                          if (exp.participating_plans?.includes(p.id)) {
                            return sum + (exp.total_amount / (exp.participating_plans.length || 1));
                          }
                          return sum;
                        }, 0);
                        const pTotal = pTotalManual + pTotalShared;
                        const perPerson = p.has_passenger ? pTotal / 2 : pTotal;
                        return <TableCell key={`per-${p.id}`} className="text-center font-bold text-copper">{perPerson.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}</TableCell>
                      })}
                      <TableCell></TableCell>
                    </TableRow>
                  </TableBody>
                </Table>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="minha">
          <Card className="border-leather/30 bg-cream">
            <CardHeader className="bg-coffee text-cream rounded-t-lg flex flex-row items-center justify-between pb-4">
              <div>
                <CardTitle className="text-xl font-display uppercase tracking-widest" style={{ fontFamily: "var(--font-display)" }}>
                  Minha Planilha de Custos
                </CardTitle>
              </div>
              <Button onClick={handleSave} disabled={saving} className="btn-copper hidden sm:flex">
                <Save className="h-4 w-4 mr-2" /> {saving ? "Salvando..." : "Salvar"}
              </Button>
            </CardHeader>
            <CardContent className="p-4 sm:p-6 space-y-8">
              
              {/* Fuel Calculator */}
              <div className="bg-coffee/5 rounded-lg border border-copper/30 p-4 relative overflow-hidden">
                <div className="absolute top-0 right-0 w-24 h-24 bg-copper/10 rounded-bl-full z-0"></div>
                <div className="relative z-10 flex items-center gap-2 mb-4">
                  <Calculator className="h-5 w-5 text-copper" />
                  <h3 className="font-bold text-coffee uppercase text-sm">Calculadora de Combustível</h3>
                </div>
                <div className="relative z-10 grid sm:grid-cols-3 gap-4">
                  <div>
                    <Label className="text-xs font-bold uppercase tracking-wider text-coffee/80">Distância (Ida e Volta)</Label>
                    <div className="relative mt-1">
                      <Input 
                        type="number" 
                        value={fuelCalc.distance || ''} 
                        onChange={(e) => setFuelCalc(prev => ({ ...prev, distance: parseFloat(e.target.value)||0 }))} 
                        placeholder="Ex: 800"
                        className="pr-10 border-copper/60 text-coffee font-medium placeholder:text-coffee/50 bg-white"
                      />
                      <span className="absolute right-3 top-2.5 text-xs text-coffee font-bold">KM</span>
                    </div>
                  </div>
                  <div>
                    <Label className="text-xs font-bold uppercase tracking-wider text-coffee/80">Autonomia Média</Label>
                    <div className="relative mt-1">
                      <Input 
                        type="number" 
                        value={fuelCalc.autonomy || ''} 
                        onChange={(e) => setFuelCalc(prev => ({ ...prev, autonomy: parseFloat(e.target.value)||0 }))} 
                        placeholder="Ex: 25"
                        className="pr-12 border-copper/60 text-coffee font-medium placeholder:text-coffee/50 bg-white"
                      />
                      <span className="absolute right-3 top-2.5 text-xs text-coffee font-bold">KM/L</span>
                    </div>
                  </div>
                  <div>
                    <Label className="text-xs font-bold uppercase tracking-wider text-coffee/80">Preço do Litro</Label>
                    <div className="relative mt-1">
                      <span className="absolute left-3 top-2.5 text-xs text-coffee font-bold">R$</span>
                      <Input 
                        type="number" 
                        step="0.01"
                        value={fuelCalc.price || ''} 
                        onChange={(e) => setFuelCalc(prev => ({ ...prev, price: parseFloat(e.target.value)||0 }))} 
                        placeholder="5,80"
                        className="pl-8 border-copper/60 text-coffee font-medium placeholder:text-coffee/50 bg-white"
                      />
                    </div>
                  </div>
                </div>
                <div className="mt-4 pt-3 border-t border-copper/30 flex justify-between items-center relative z-10">
                   <p className="text-xs text-coffee/80 max-w-[200px] sm:max-w-none">
                     <Info className="h-3 w-3 inline mr-1" />
                     O custo estimado preenche automaticamente o campo abaixo.
                   </p>
                   <p className="text-lg font-black text-copper">
                      {costs.combustivel.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                   </p>
                </div>
              </div>

              {/* Custos Individuais Manuais */}
              <div className="bg-white/50 p-4 rounded-lg border border-leather/20">
                <h3 className="font-bold text-coffee uppercase text-sm mb-4">Custos Individuais Manuais</h3>
                <div className="grid sm:grid-cols-2 gap-x-8 gap-y-4">
                  {[
                    { key: 'revisao', label: 'Revisão da Moto', icon: '🔧' },
                    { key: 'hospedagem', label: 'Hospedagem', icon: '🛌' },
                    { key: 'alimentacao', label: 'Alimentação', icon: '🍔' },
                    { key: 'reserva', label: 'Reserva', icon: '💳' },
                    { key: 'combustivel', label: 'Combustível (Calculado)', icon: '⛽', disabled: true },
                    { key: 'pedagio', label: 'Pedágio', icon: '🛣️' },
                    { key: 'passeios', label: 'Passeios / Atrações', icon: '🎟️' },
                    { key: 'outros', label: 'Outros Custos', icon: '📦' }
                  ].map((item) => (
                    <div key={item.key}>
                      <Label className="flex justify-between items-center mb-1 text-coffee text-xs font-semibold">
                        <span>{item.icon} {item.label}</span>
                      </Label>
                      <div className="relative">
                        <span className={`absolute left-3 top-2.5 text-sm font-bold ${item.disabled ? 'text-copper' : 'text-coffee'}`}>R$</span>
                        <Input 
                          type="number" 
                          className={`pl-10 ${item.disabled ? 'bg-copper/10 border-copper/30 font-bold text-copper' : 'bg-white border-leather/40 text-coffee font-medium placeholder:text-coffee/50 focus-visible:ring-copper'}`}
                          value={costs[item.key as keyof Costs] || ''}
                          onChange={(e) => setCosts(prev => ({ ...prev, [item.key]: parseFloat(e.target.value)||0 }))}
                          disabled={item.disabled}
                          placeholder="0,00"
                        />
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Minha parte nas Despesas Compartilhadas */}
              <div className="bg-coffee/5 p-4 rounded-lg border border-copper/30">
                <h3 className="font-bold text-coffee uppercase text-sm mb-4 flex items-center gap-2">
                  <Users className="w-4 h-4 text-copper" />
                  Minha parte nas Despesas em Grupo
                </h3>
                {sharedExpenses.length === 0 ? (
                  <p className="text-sm text-leather">O grupo não possui despesas compartilhadas nesta viagem.</p>
                ) : (
                  <div className="space-y-4">
                    {sharedExpenses.map(exp => {
                      const myShare = exp.total_amount / numMotos;
                      return (
                        <div key={exp.id} className="border-b border-leather/20 pb-3 last:border-0 last:pb-0">
                          <div className="flex justify-between items-center mb-2">
                            <p className="font-semibold text-coffee text-sm">{exp.title}</p>
                            <p className="font-bold text-copper">{myShare.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}</p>
                          </div>
                          <div className="grid gap-1.5 pl-2">
                            {exp.installments.map(inst => {
                              const pmt = inst.payments.find(p => p.plan_id === myPlanId);
                              const isPaid = pmt?.is_paid;
                              const instShare = inst.amount / numMotos;
                              return (
                                <div key={inst.id} className="flex justify-between items-center text-xs">
                                  <span className="text-leather flex items-center gap-1.5">
                                    {isPaid ? <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" /> : <Circle className="w-3.5 h-3.5 text-leather/50" />}
                                    Parcela {inst.installment_number} (Vence: {new Date(inst.due_date).toLocaleDateString('pt-BR')})
                                  </span>
                                  <span className={isPaid ? "text-emerald-700 font-medium line-through" : "text-coffee font-medium"}>
                                    {instShare.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                                  </span>
                                </div>
                              );
                            })}
                          </div>
                        </div>
                      )
                    })}
                  </div>
                )}
              </div>

              <div className="bg-coffee text-cream p-6 rounded-lg flex flex-col sm:flex-row items-center justify-between gap-4">
                 <div>
                   <p className="text-sm uppercase tracking-wider text-cream/70 mb-1">Custo Total (Indiv. + Grupo)</p>
                   <p className="text-3xl font-black font-display" style={{ fontFamily: "var(--font-display)" }}>
                     {myTotal.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                   </p>
                 </div>
                 <div className="h-px w-full sm:w-px sm:h-12 bg-cream/20"></div>
                 <div className="text-right">
                   <p className="text-sm uppercase tracking-wider text-copper mb-1">Por Pessoa {partnerId ? '(÷2)' : ''}</p>
                   <p className="text-3xl font-black text-copper font-display" style={{ fontFamily: "var(--font-display)" }}>
                     {myPerPerson.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                   </p>
                 </div>
              </div>

              <Button onClick={handleSave} disabled={saving} className="btn-copper w-full sm:hidden py-6 text-lg">
                <Save className="h-5 w-5 mr-2" /> Salvar Planilha
              </Button>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="grupo">
           <GroupExpensesTab 
             sharedExpenses={sharedExpenses} 
             allPlans={allPlans} 
             isAdmin={isAdmin} 
             routeId={routeId}
             onUpdated={loadData}
           />
        </TabsContent>
      </Tabs>
    </div>
  );
}

// -------------------------------------------------------------------------
// COMPONENT FOR GROUP EXPENSES TAB
// -------------------------------------------------------------------------

function GroupExpensesTab({ sharedExpenses, allPlans, isAdmin, routeId, onUpdated }: any) {
  const [openNew, setOpenNew] = useState(false);
  const [editExpense, setEditExpense] = useState<SharedExpense | null>(null);

  async function handleTogglePayment(installmentId: string, planId: string, currentPaid: boolean) {
    if (!isAdmin) return toast.error("Apenas admins podem dar baixa em pagamentos.");
    
    // find payment record
    const exp = sharedExpenses.find((e:any) => e.installments.some((i:any) => i.id === installmentId));
    const inst = exp?.installments.find((i:any) => i.id === installmentId);
    const pmt = inst?.payments.find((p:any) => p.plan_id === planId);

    try {
      if (pmt) {
        await supabase.from("trip_installment_payments").update({
          is_paid: !currentPaid,
          paid_at: !currentPaid ? new Date().toISOString() : null
        }).eq("id", pmt.id);
      } else {
        await supabase.from("trip_installment_payments").insert({
          installment_id: installmentId,
          plan_id: planId,
          is_paid: !currentPaid,
          paid_at: !currentPaid ? new Date().toISOString() : null
        });
      }
      toast.success("Pagamento atualizado!");
      onUpdated();
    } catch (err: any) {
      toast.error(err.message);
    }
  }

  async function handleDeleteExpense(expenseId: string) {
    if (!confirm("Tem certeza que deseja excluir esta despesa e TODAS as suas parcelas permanentemente?")) return;
    const { error } = await supabase.from("trip_shared_expenses").delete().eq("id", expenseId);
    if (error) toast.error("Erro ao excluir: " + error.message);
    else { toast.success("Despesa excluída com sucesso"); onUpdated(); }
  }

  return (
    <Card className="border-leather/30 bg-cream">
      <CardHeader className="bg-leather text-cream rounded-t-lg flex flex-row items-center justify-between pb-4">
        <div>
          <CardTitle className="text-xl font-display uppercase tracking-widest" style={{ fontFamily: "var(--font-display)" }}>
            Despesas em Grupo
          </CardTitle>
          <CardDescription className="text-cream/80">Custos que serão rateados entre todas as motos/planilhas.</CardDescription>
        </div>
        {isAdmin && (
          <Dialog open={openNew} onOpenChange={setOpenNew}>
            <DialogTrigger asChild>
              <Button className="bg-coffee hover:bg-coffee/90 text-cream">
                <Plus className="w-4 h-4 mr-2" /> Nova Despesa
              </Button>
            </DialogTrigger>
            <NewSharedExpenseDialog routeId={routeId} allPlans={allPlans} onCreated={() => { setOpenNew(false); onUpdated(); }} />
          </Dialog>
        )}
        {isAdmin && (
          <Dialog open={!!editExpense} onOpenChange={(open) => !open && setEditExpense(null)}>
            {editExpense && <EditSharedExpenseDialog expense={editExpense} onUpdated={() => { setEditExpense(null); onUpdated(); }} />}
          </Dialog>
        )}
      </CardHeader>
      <CardContent className="p-4 sm:p-6 space-y-8">
        {sharedExpenses.length === 0 ? (
          <div className="text-center py-10 text-leather">
            <AlertCircle className="w-10 h-10 mx-auto mb-3 opacity-50" />
            <p>Nenhuma despesa compartilhada cadastrada.</p>
          </div>
        ) : (
          sharedExpenses.map((exp: SharedExpense) => (
            <div key={exp.id} className="border border-leather/30 rounded-lg overflow-hidden bg-white">
              <div className="bg-coffee/5 p-4 flex flex-col sm:flex-row justify-between items-start sm:items-center border-b border-leather/20 gap-4 sm:gap-0">
                <div className="flex-1 pr-4">
                  <h3 className="font-bold text-coffee text-lg">{exp.title}</h3>
                  {exp.description && <p className="text-sm text-coffee/80 mt-1 mb-2">{exp.description}</p>}
                  {exp.paid_by && <p className="text-sm text-leather mt-1 mb-2 font-bold">💳 Pago por: {exp.paid_by}</p>}
                  {exp.link && (
                    <a href={exp.link} target="_blank" rel="noopener noreferrer" className="inline-flex items-center text-xs text-copper hover:text-copper/80 font-bold mb-2 bg-copper/10 px-2 py-1 rounded">
                      🔗 Acessar Link da Reserva
                    </a>
                  )}
                  <p className="text-sm text-leather">Custo Total: {exp.total_amount.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}</p>
                </div>
                <div className="text-right flex items-center gap-4 w-full sm:w-auto justify-between sm:justify-end">
                  <div className="text-right">
                    <p className="text-xs uppercase text-leather font-bold">Por Moto ({exp.participating_plans?.length || 1})</p>
                    <p className="font-bold text-copper text-lg">
                      {(exp.total_amount / (exp.participating_plans?.length || 1)).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                    </p>
                  </div>
                  {isAdmin && (
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button variant="ghost" size="icon" className="h-8 w-8 text-leather hover:text-coffee shrink-0">
                          <MoreVertical className="h-4 w-4" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem onClick={() => setEditExpense(exp)} className="cursor-pointer">
                          <Edit className="h-4 w-4 mr-2" /> Editar Título/Desc
                        </DropdownMenuItem>
                        <DropdownMenuItem onClick={() => handleDeleteExpense(exp.id)} className="cursor-pointer text-red-600 focus:text-red-700">
                          <Trash2 className="h-4 w-4 mr-2" /> Excluir Despesa
                        </DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  )}
                </div>
              </div>
              <div className="p-4 space-y-6">
                {exp.installments.map(inst => {
                  const expNumMotos = exp.participating_plans?.length || 1;
                  const instShare = inst.amount / expNumMotos;
                  const participatingPlansList = allPlans.filter(p => exp.participating_plans?.includes(p.id));
                  return (
                    <div key={inst.id}>
                      <div className="flex justify-between items-center mb-3">
                        <h4 className="font-bold text-sm text-coffee flex items-center gap-2">
                          Parcela {inst.installment_number}
                          <span className="text-xs font-normal text-leather">Vencimento: {new Date(inst.due_date).toLocaleDateString('pt-BR')}</span>
                        </h4>
                        <span className="text-xs font-bold text-copper bg-copper/10 px-2 py-1 rounded">
                          {instShare.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })} / moto
                        </span>
                      </div>
                      <div className="overflow-x-auto border border-leather/15 rounded-md">
                        <Table>
                          <TableHeader className="bg-coffee/5">
                            <TableRow>
                              <TableHead className="py-2 text-xs">Moto / Casal</TableHead>
                              <TableHead className="py-2 text-xs">Status</TableHead>
                              <TableHead className="py-2 text-xs text-right">Ação</TableHead>
                            </TableRow>
                          </TableHeader>
                          <TableBody>
                            {participatingPlansList.map((plan: any) => {
                               const pilot = plan.profile?.nickname || plan.profile?.full_name?.split(" ")[0] || "Moto";
                               const partner = plan.partner?.nickname || "";
                               const name = partner ? `${pilot} & ${partner}` : pilot;
                               const isPaid = inst.payments.find(p => p.plan_id === plan.id)?.is_paid || false;
                               
                               return (
                                 <TableRow key={plan.id}>
                                   <TableCell className="py-2 font-medium text-sm text-coffee">{name}</TableCell>
                                   <TableCell className="py-2">
                                     {isPaid 
                                       ? <span className="inline-flex items-center gap-1 text-xs text-emerald-700 bg-emerald-100 px-2 py-0.5 rounded-full"><CheckCircle2 className="w-3 h-3"/> Pago</span>
                                       : <span className="inline-flex items-center gap-1 text-xs text-amber-700 bg-amber-100 px-2 py-0.5 rounded-full"><AlertCircle className="w-3 h-3"/> Pendente</span>
                                     }
                                   </TableCell>
                                   <TableCell className="py-2 text-right">
                                     {isAdmin ? (
                                       <Button variant="outline" size="sm" className="h-7 text-xs" onClick={() => handleTogglePayment(inst.id, plan.id, isPaid)}>
                                         {isPaid ? "Desmarcar" : "Dar Baixa"}
                                       </Button>
                                     ) : (
                                       <span className="text-xs text-leather">-</span>
                                     )}
                                   </TableCell>
                                 </TableRow>
                               )
                            })}
                          </TableBody>
                        </Table>
                      </div>
                    </div>
                  )
                })}
              </div>
            </div>
          ))
        )}
      </CardContent>
    </Card>
  )
}

function NewSharedExpenseDialog({ routeId, allPlans, onCreated }: any) {
  const [form, setForm] = useState({ title: "", description: "", link: "", paid_by: "", amount: "", installmentsCount: "1", firstDueDate: new Date().toISOString().slice(0, 10) });
  const [selectedPlans, setSelectedPlans] = useState<string[]>(allPlans?.map((p:any) => p.id) || []);
  const [saving, setSaving] = useState(false);

  function togglePlan(planId: string) {
    if (selectedPlans.includes(planId)) {
      setSelectedPlans(selectedPlans.filter(id => id !== planId));
    } else {
      setSelectedPlans([...selectedPlans, planId]);
    }
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const { data: u } = await supabase.auth.getUser();
    
    // 1. Insert expense
    const { data: exp, error: err1 } = await supabase.from("trip_shared_expenses").insert({
      route_id: routeId,
      title: form.title,
      description: form.description || null,
      link: form.link || null,
      paid_by: form.paid_by || null,
      participating_plans: selectedPlans,
      total_amount: parseFloat(form.amount),
      created_by: u.user?.id
    }).select().single();

    if (err1 || !exp) { 
      toast.error(`Erro ao criar despesa: ${err1?.message || 'Desconhecido'}`); 
      setSaving(false); 
      return; 
    }

    // 2. Insert installments
    const count = parseInt(form.installmentsCount);
    const instAmount = exp.total_amount / count;
    const baseDate = new Date(form.firstDueDate);
    baseDate.setMinutes(baseDate.getMinutes() + baseDate.getTimezoneOffset()); // fix timezone

    const installments = [];
    for (let i = 1; i <= count; i++) {
       const dueDate = new Date(baseDate);
       dueDate.setMonth(dueDate.getMonth() + (i - 1));
       installments.push({
         expense_id: exp.id,
         installment_number: i,
         amount: instAmount,
         due_date: dueDate.toISOString().slice(0, 10)
       });
    }

    const { error: err2 } = await supabase.from("trip_expense_installments").insert(installments);
    if (err2) toast.error(`Erro ao gerar parcelas: ${err2.message}`);
    else toast.success("Despesa e parcelas criadas!");
    
    setSaving(false);
    onCreated();
  }

  return (
    <DialogContent>
      <DialogHeader>
        <DialogTitle>Nova Despesa Compartilhada</DialogTitle>
      </DialogHeader>
      <form onSubmit={submit} className="space-y-4 mt-4">
        <div>
          <Label>Título (ex: Hospedagem Hotel X)</Label>
          <Input required value={form.title} onChange={e => setForm({...form, title: e.target.value})} />
        </div>
        <div>
          <Label>Descrição / Detalhes (Opcional)</Label>
          <Input value={form.description} onChange={e => setForm({...form, description: e.target.value})} placeholder="Mais informações sobre a despesa" />
        </div>
        <div>
          <Label>Quem Pagou? (Cartão de quem? Opcional)</Label>
          <Input value={form.paid_by} onChange={e => setForm({...form, paid_by: e.target.value})} placeholder="Ex: Cartão do João" />
        </div>
        <div>
          <Label>Link da Reserva (Ex: Airbnb, Booking - Opcional)</Label>
          <Input type="url" value={form.link} onChange={e => setForm({...form, link: e.target.value})} placeholder="https://..." />
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
             <Label>Valor Total (R$)</Label>
             <Input required type="number" step="0.01" value={form.amount} onChange={e => setForm({...form, amount: e.target.value})} />
          </div>
          <div>
             <Label>Nº de Parcelas</Label>
             <Input required type="number" min="1" max="24" value={form.installmentsCount} onChange={e => setForm({...form, installmentsCount: e.target.value})} />
          </div>
        </div>
        
        <div className="border border-leather/20 rounded-md p-3 max-h-[160px] overflow-y-auto bg-coffee/5">
           <Label className="mb-2 block text-coffee font-bold">Participantes (Desmarque quem não entra no rateio)</Label>
           <div className="space-y-1.5 mt-2">
             {allPlans.map((p: any) => {
               const pilot = p.profile?.nickname || p.profile?.full_name?.split(" ")[0] || "Moto";
               const partner = p.partner?.nickname || p.partner?.full_name?.split(" ")[0];
               const name = partner ? `${pilot} e ${partner}` : pilot;
               return (
                 <label key={p.id} className="flex items-center gap-2 text-sm cursor-pointer hover:bg-leather/10 p-1.5 rounded transition-colors">
                   <input 
                     type="checkbox" 
                     className="rounded border-leather text-copper focus:ring-copper w-4 h-4"
                     checked={selectedPlans.includes(p.id)}
                     onChange={() => togglePlan(p.id)}
                   />
                   <span className="text-coffee font-medium">{name}</span>
                 </label>
               )
             })}
           </div>
        </div>

        <div>
          <Label>Vencimento da 1ª Parcela</Label>
          <Input required type="date" value={form.firstDueDate} onChange={e => setForm({...form, firstDueDate: e.target.value})} />
        </div>
        <DialogFooter>
           <Button type="submit" className="btn-copper" disabled={saving}>{saving ? "Salvando..." : "Criar Despesa"}</Button>
        </DialogFooter>
      </form>
    </DialogContent>
  )
}

function EditSharedExpenseDialog({ expense, onUpdated }: any) {
  const [form, setForm] = useState({ title: expense.title, description: expense.description || "", link: expense.link || "", paid_by: expense.paid_by || "" });
  const [saving, setSaving] = useState(false);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const { error } = await supabase.from("trip_shared_expenses").update({
      title: form.title,
      description: form.description || null,
      link: form.link || null,
      paid_by: form.paid_by || null
    }).eq("id", expense.id);

    if (error) { 
      toast.error(`Erro ao editar: ${error.message}`); 
    } else {
      toast.success("Despesa atualizada!");
      onUpdated();
    }
    setSaving(false);
  }

  return (
    <DialogContent>
      <DialogHeader>
        <DialogTitle>Editar Despesa</DialogTitle>
      </DialogHeader>
      <form onSubmit={submit} className="space-y-4 mt-4">
        <div>
          <Label>Título</Label>
          <Input required value={form.title} onChange={e => setForm({...form, title: e.target.value})} />
        </div>
        <div>
          <Label>Descrição / Detalhes</Label>
          <Input value={form.description} onChange={e => setForm({...form, description: e.target.value})} />
        </div>
        <div>
          <Label>Quem Pagou?</Label>
          <Input value={form.paid_by} onChange={e => setForm({...form, paid_by: e.target.value})} />
        </div>
        <div>
          <Label>Link da Reserva (Opcional)</Label>
          <Input type="url" value={form.link} onChange={e => setForm({...form, link: e.target.value})} placeholder="https://..." />
        </div>
        <DialogFooter>
           <Button type="submit" className="btn-copper" disabled={saving}>{saving ? "Salvando..." : "Salvar Alterações"}</Button>
        </DialogFooter>
      </form>
    </DialogContent>
  )
}
