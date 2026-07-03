import { createFileRoute, Link } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { ArrowLeft, Save, Calculator, Users, Info } from "lucide-react";
import { toast } from "sonner";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";

export const Route = createFileRoute("/_authenticated/rotas_/$id/financeiro")({
  head: () => ({ meta: [{ title: "Planejamento Financeiro — Café Moto e Asfalto" }] }),
  component: RouteFinanceiroPage,
});

type Costs = {
  revisao: number;
  hospedagem: number;
  alimentacao: number;
  reserva: number;
  combustivel: number;
  pedagio: number;
  passeios: number;
  outros: number;
};

type FuelCalc = {
  distance: number;
  autonomy: number;
  price: number;
};

type PlanData = {
  id: string;
  profile_id: string;
  has_passenger: boolean;
  costs: Costs;
  fuel_calc: FuelCalc;
  profile?: {
    full_name: string | null;
    nickname: string | null;
    partner_id: string | null;
  };
  partner?: {
    full_name: string | null;
    nickname: string | null;
  } | null;
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

    // Get Route info
    const { data: routeData } = await supabase.from("routes").select("title").eq("id", routeId).maybeSingle();
    if (routeData) setRouteTitle(routeData.title);

    // Get current user profile to check for partner
    const { data: profile } = await supabase.from("profiles").select("partner_id").eq("id", u.user.id).maybeSingle();
    const myPartnerId = profile?.partner_id || null;
    setPartnerId(myPartnerId);

    // Load all plans for this route
    const { data: plansData, error } = await supabase
      .from("trip_financial_plans")
      .select(`
        *,
        profile:profiles (
          full_name, nickname, partner_id
        )
      `)
      .eq("route_id", routeId);

    if (error) {
      console.error(error);
      toast.error("Erro: " + error.message);
      setLoading(false);
      return;
    }

    // Now we need to manually fetch the partner names for display in the summary
    const enrichedPlans: PlanData[] = [];
    for (const p of (plansData as any[])) {
      let partnerData = null;
      if (p.profile?.partner_id) {
        const { data: pt } = await supabase.from("profiles").select("full_name, nickname").eq("id", p.profile.partner_id).maybeSingle();
        partnerData = pt;
      }
      enrichedPlans.push({
        id: p.id,
        profile_id: p.profile_id,
        has_passenger: p.has_passenger,
        costs: p.costs as Costs,
        fuel_calc: p.fuel_calc as FuelCalc,
        profile: p.profile,
        partner: partnerData
      });
    }

    setAllPlans(enrichedPlans);

    // Check if I or my partner already have a plan
    const existingPlan = enrichedPlans.find(p => p.profile_id === u.user.id || p.profile_id === myPartnerId);
    if (existingPlan) {
      setMyPlanId(existingPlan.id);
      setCosts(existingPlan.costs);
      setFuelCalc(existingPlan.fuel_calc);
    }

    setLoading(false);
  }

  useEffect(() => {
    loadData();
  }, [routeId]);

  // Recalculate fuel cost whenever calc inputs change
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
      costs,
      fuel_calc: fuelCalc,
      observations: {}
    };

    if (myPlanId) {
      const { error } = await supabase.from("trip_financial_plans").update(payload).eq("id", myPlanId);
      if (error) toast.error("Erro ao salvar: " + error.message);
      else toast.success("Planilha atualizada!");
    } else {
      const { data, error } = await supabase.from("trip_financial_plans").insert(payload).select().single();
      if (error) toast.error("Erro ao criar: " + error.message);
      else {
        toast.success("Planilha criada!");
        if (data) setMyPlanId(data.id);
      }
    }
    setSaving(false);
    loadData(); // reload summary
  };

  const handleCostChange = (field: keyof Costs, val: string) => {
    const num = parseFloat(val.replace(",", ".")) || 0;
    setCosts(prev => ({ ...prev, [field]: num }));
  };

  const handleFuelChange = (field: keyof FuelCalc, val: string) => {
    const num = parseFloat(val.replace(",", ".")) || 0;
    setFuelCalc(prev => ({ ...prev, [field]: num }));
  };

  const calculateTotal = (c: Costs) => {
    return Object.values(c).reduce((a, b) => a + (Number(b) || 0), 0);
  };

  const myTotal = calculateTotal(costs);
  const myPerPerson = partnerId ? myTotal / 2 : myTotal;

  // Resumo Geral calculations
  const totalGroup = allPlans.reduce((sum, p) => sum + calculateTotal(p.costs), 0);
  const numMotos = allPlans.length;
  const avgPerMoto = numMotos > 0 ? totalGroup / numMotos : 0;

  if (loading) {
    return <div className="p-8 text-coffee">Carregando...</div>;
  }

  return (
    <div className="space-y-6">
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
        <TabsList className="grid w-full grid-cols-2 max-w-[400px] mb-6 bg-cream border border-leather/20">
          <TabsTrigger value="geral" className="data-[state=active]:bg-coffee data-[state=active]:text-cream text-coffee">
            Resumo Geral
          </TabsTrigger>
          <TabsTrigger value="minha" className="data-[state=active]:bg-copper data-[state=active]:text-cream text-coffee">
            Minha Planilha
          </TabsTrigger>
        </TabsList>

        <TabsContent value="geral">
          <Card className="border-leather/30 bg-cream mb-6">
            <CardHeader className="bg-coffee text-cream rounded-t-lg pb-4">
              <CardTitle className="text-xl font-display uppercase tracking-widest" style={{ fontFamily: "var(--font-display)" }}>
                Custo Consolidado do Grupo
              </CardTitle>
            </CardHeader>
            <CardContent className="p-0">
              <div className="flex flex-col sm:grid sm:grid-cols-3 divide-y sm:divide-y-0 sm:divide-x divide-leather/30 bg-cream/50 text-coffee border-b border-leather/30">
                <div className="p-4 sm:p-4 text-center">
                  <p className="text-xs font-bold uppercase text-coffee/80">Total do Grupo</p>
                  <p className="text-xl sm:text-2xl font-bold mt-1">
                    {totalGroup.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                  </p>
                </div>
                <div className="p-4 sm:p-4 text-center">
                  <p className="text-xs font-bold uppercase text-coffee/80">Nº de Motos/Casais</p>
                  <p className="text-xl sm:text-2xl font-bold mt-1">{numMotos}</p>
                </div>
                <div className="p-4 sm:p-4 text-center">
                  <p className="text-xs font-bold uppercase text-coffee/80">Custo Médio / Moto</p>
                  <p className="text-xl sm:text-2xl font-bold mt-1">
                    {avgPerMoto.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                  </p>
                </div>
              </div>

              <div className="overflow-x-auto p-4">
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
                    
                    {/* Row Totals */}
                    <TableRow className="border-leather/40 bg-leather/10 hover:bg-leather/10">
                      <TableCell className="font-bold text-coffee uppercase text-xs">Total Moto</TableCell>
                      {allPlans.map(p => {
                        const pTotal = calculateTotal(p.costs);
                        return <TableCell key={`total-${p.id}`} className="text-center font-bold">{pTotal.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}</TableCell>
                      })}
                      <TableCell className="text-right font-black text-coffee">{totalGroup.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}</TableCell>
                    </TableRow>
                    
                    <TableRow className="border-none bg-cream hover:bg-cream">
                      <TableCell className="font-bold text-copper uppercase text-xs">Por Pessoa</TableCell>
                      {allPlans.map(p => {
                        const pTotal = calculateTotal(p.costs);
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
                <CardDescription className="text-cream/70 mt-1">
                  {partnerId ? "Planilha unificada para você e seu garupa/parceiro(a)." : "Planilha individual da sua moto."}
                </CardDescription>
              </div>
              <Button onClick={handleSave} disabled={saving} className="btn-copper hidden sm:flex">
                <Save className="h-4 w-4 mr-2" /> {saving ? "Salvando..." : "Salvar Planilha"}
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
                        onChange={(e) => handleFuelChange('distance', e.target.value)} 
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
                        onChange={(e) => handleFuelChange('autonomy', e.target.value)} 
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
                        onChange={(e) => handleFuelChange('price', e.target.value)} 
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

              {/* Cost Inputs */}
              <div className="grid sm:grid-cols-2 gap-x-8 gap-y-6">
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
                    <Label className="flex justify-between items-center mb-1 text-coffee font-semibold">
                      <span>{item.icon} {item.label}</span>
                    </Label>
                    <div className="relative">
                      <span className={`absolute left-3 top-2.5 text-sm font-bold ${item.disabled ? 'text-copper' : 'text-coffee'}`}>R$</span>
                      <Input 
                        type="number" 
                        className={`pl-10 ${item.disabled ? 'bg-copper/10 border-copper/30 font-bold text-copper' : 'bg-white border-leather/60 focus-visible:ring-copper text-coffee font-medium placeholder:text-coffee/50'}`}
                        value={costs[item.key as keyof Costs] || ''}
                        onChange={(e) => handleCostChange(item.key as keyof Costs, e.target.value)}
                        disabled={item.disabled}
                        placeholder="0,00"
                      />
                    </div>
                  </div>
                ))}
              </div>

              {/* Totals */}
              <div className="bg-coffee text-cream p-6 rounded-lg shadow-inner flex flex-col sm:flex-row items-center justify-between gap-4">
                 <div>
                   <p className="text-sm uppercase tracking-wider text-cream/70 mb-1">Custo Total da Moto</p>
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
                <Save className="h-5 w-5 mr-2" /> {saving ? "Salvando..." : "Salvar Planilha"}
              </Button>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
