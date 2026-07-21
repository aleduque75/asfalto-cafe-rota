import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { MapPin, Navigation, Calendar, Clock, Map, Play, Image as ImageIcon, Flag, Route as RouteIcon, CheckCircle2, ArrowLeft, Calculator } from "lucide-react";
import { toast } from "sonner";
import { useNavigate } from "@tanstack/react-router";

export const Route = createFileRoute("/_authenticated/rotas")({
  validateSearch: (search: Record<string, unknown>): { tab?: string } => {
    return {
      tab: search.tab as string | undefined,
    }
  },
  head: () => ({ meta: [{ title: "Nossas Rotas — Café Moto e Asfalto" }] }),
  component: RotasPage,
});

type RouteData = {
  id: string;
  title: string;
  description: string | null;
  destination: string;
  start_date: string;
  meeting_point: string;
  meeting_time: string;
  estimated_distance_km: number | null;
  waze_url: string | null;
  media_url: string | null;
  status: 'open' | 'completed' | 'planning';
  route_type: string;
  estimated_duration_mins: number | null;
  visited_places: string | null;
  has_financial_plan?: boolean | null;
  cover_url?: string | null;
  itinerary?: string | null;
};

function RotasPage() {
  const [routes, setRoutes] = useState<RouteData[]>([]);
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const { tab } = Route.useSearch();
  const navigate = useNavigate({ from: Route.fullPath });
  const activeTab = tab === "completed" ? "completed" : "open";
  const [filterType, setFilterType] = useState<'all' | 'open' | 'planning'>('all');

  async function loadRoutes() {
    setLoading(true);
    const { data: u } = await supabase.auth.getUser();
    if (u.user) {
      const { data: roles } = await supabase
        .from("user_roles")
        .select("role")
        .eq("user_id", u.user.id)
        .eq("role", "admin");
      setIsAdmin(roles && roles.length > 0 ? true : false);
    }

    const { data, error } = await supabase
      .from("routes")
      .select("*");

    if (error) {
      toast.error(error.message);
    } else {
      let sortedData = (data as RouteData[]) || [];
      sortedData.sort((a, b) => {
        const dateA = new Date(a.start_date).getTime();
        const dateB = new Date(b.start_date).getTime();
        
        if (a.status === 'open' || a.status === 'planning') {
           return dateA - dateB; // Mais próxima primeiro
        } else {
           return dateB - dateA; // Mais recente primeiro
        }
      });
      setRoutes(sortedData);
    }
    setLoading(false);
  }

  useEffect(() => {
    loadRoutes();
  }, []);

  const openWaze = (route: RouteData) => {
    const wazeLink = route.waze_url?.trim() || `https://waze.com/ul?q=${encodeURIComponent(route.destination)}&navigate=yes`;
    window.open(wazeLink, "_blank");
  };

  const handleFinalize = async (id: string) => {
    const { error } = await supabase
      .from("routes")
      .update({ status: 'completed' })
      .eq("id", id);
      
    if (error) {
      toast.error(error.message);
    } else {
      toast.success("Rota finalizada com sucesso!");
      loadRoutes();
    }
  };

  const formatDuration = (mins: number | null) => {
    if (!mins) return null;
    const hours = Math.floor(mins / 60);
    const m = mins % 60;
    if (hours > 0) {
      return `${hours}h ${m > 0 ? `${m}m` : ''}`;
    }
    return `${m} min`;
  };

  const openRoutes = routes.filter(r => r.status === 'open' || r.status === 'planning');
  const filteredOpenRoutes = openRoutes.filter(r => {
    if (filterType === 'all') return true;
    return r.status === filterType;
  });
  const completedRoutes = routes.filter(r => r.status === 'completed');

  const renderRouteCard = (route: RouteData, isPastMode: boolean = false) => {
    const date = new Date(route.start_date);
    
    return (
      <Card key={route.id} className="overflow-hidden border-leather/20 hover:border-copper hover:shadow-lg transition-all h-full flex flex-col bg-cream group">
        <div className="relative h-48 sm:h-56 w-full bg-coffee">
          <img 
            src={route.cover_url || `https://image.pollinations.ai/prompt/${encodeURIComponent(route.destination + ' beautiful landscape motorcycle road trip cinematic realistic')}?width=1200&height=800&nologo=true`}
            alt="Route cover"
            className="w-full h-full object-cover opacity-50 group-hover:opacity-70 transition-opacity duration-500"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-coffee via-coffee/40 to-transparent opacity-90" />
          
          <Badge variant={isPastMode ? "secondary" : "default"} className="absolute top-4 right-4 bg-copper text-cream border-none z-10 shadow-sm">
            {isPastMode ? "Finalizado" : (route.status === 'planning' ? "Em Planejamento" : "Próximo Passeio")}
          </Badge>
          
          <div className="absolute bottom-4 left-5 right-5 z-10">
            {route.route_type === 'viagem' && (
              <span className="inline-block px-2 py-0.5 rounded text-[10px] uppercase tracking-wider text-cream bg-copper/90 font-bold mb-2">Viagem Completa</span>
            )}
            <h3 className="font-display text-2xl text-cream leading-tight drop-shadow-md" style={{ fontFamily: "var(--font-display)" }}>
              {route.title}
            </h3>
            <p className="text-cream/90 text-sm flex items-center gap-1.5 mt-1.5 font-medium">
              <Flag className="h-4 w-4 text-copper" /> Destino: {route.destination}
            </p>
          </div>
        </div>
        
        <CardContent className="p-5 flex-1 flex flex-col bg-cream">
          <div className="grid grid-cols-2 gap-y-4 gap-x-3 text-sm text-coffee mb-5 mt-2">
            <div className="flex flex-col">
              <span className="text-[10px] uppercase tracking-wider text-leather mb-1 flex items-center gap-1"><Calendar className="h-3 w-3" /> Data</span>
              <span className="font-medium text-[15px]">{date.toLocaleDateString("pt-BR")}</span>
            </div>
            <div className="flex flex-col">
              <span className="text-[10px] uppercase tracking-wider text-leather mb-1 flex items-center gap-1"><Clock className="h-3 w-3" /> Saída</span>
              <span className="font-medium text-[15px]">{route.meeting_time} <span className="text-leather font-normal text-xs">({route.meeting_point})</span></span>
            </div>
            {route.estimated_distance_km && (
              <div className="flex flex-col">
                <span className="text-[10px] uppercase tracking-wider text-leather mb-1 flex items-center gap-1"><Navigation className="h-3 w-3" /> Distância</span>
                <span className="font-medium text-[15px]">{route.estimated_distance_km} km</span>
              </div>
            )}
            {route.estimated_duration_mins && (
              <div className="flex flex-col">
                <span className="text-[10px] uppercase tracking-wider text-leather mb-1 flex items-center gap-1"><RouteIcon className="h-3 w-3" /> Duração</span>
                <span className="font-medium text-[15px]">{formatDuration(route.estimated_duration_mins)}</span>
              </div>
            )}
          </div>

          {route.visited_places && (
            <div className="mb-4 bg-leather/5 border border-leather/10 rounded-md p-3 text-sm">
              <span className="text-[10px] uppercase tracking-wider text-leather mb-1 block flex items-center gap-1"><MapPin className="h-3 w-3" /> Locais e Cidades</span>
              <span className="text-coffee font-medium">{route.visited_places}</span>
            </div>
          )}

          <p className="text-sm text-leather mb-6 flex-1 border-t border-leather/10 pt-4">
            {route.description}
          </p>

          <div className="flex flex-col sm:flex-row items-center gap-3 mt-auto">
            {!isPastMode && (
              <Button onClick={() => openWaze(route)} className="flex-1 w-full btn-copper flex gap-2">
                <Navigation className="h-4 w-4" />
                Ir com Waze
              </Button>
            )}
            
            {route.media_url && (
              <Button variant="outline" onClick={() => route.media_url && window.open(route.media_url, "_blank")} className={`flex-1 w-full border-copper text-copper hover:bg-copper/10 ${!isPastMode && 'sm:max-w-[140px]'}`}>
                {route.media_url.includes("instagram") ? (
                  <><ImageIcon className="h-4 w-4 mr-2" /> Insta</>
                ) : (
                  <><Play className="h-4 w-4 mr-2" /> Mídia</>
                )}
              </Button>
            )}

            {isPastMode && (
              <Button asChild className="flex-1 w-full btn-copper flex gap-2">
                <Link to="/rotas/$id/galeria" params={{ id: route.id }}>
                  <ImageIcon className="h-4 w-4" />
                  Galeria de Fotos
                </Link>
              </Button>
            )}
          </div>
          {route.has_financial_plan && (
            <div className="mt-3">
               <Button asChild variant="outline" className="w-full border-copper text-copper hover:bg-copper hover:text-white flex gap-2">
                  <Link to="/rotas/$id/financeiro" params={{ id: route.id }}>
                    <Calculator className="h-4 w-4" />
                    Planejamento Financeiro
                  </Link>
               </Button>
            </div>
          )}
          {route.itinerary && route.itinerary.trim() !== '' && (
            <div className="mt-3">
               <Button asChild variant="outline" className="w-full bg-cream border-coffee text-coffee hover:bg-coffee hover:text-cream flex gap-2">
                  <Link to="/rotas/$id/roteiro" params={{ id: route.id }}>
                    <Map className="h-4 w-4" />
                    Ver Roteiro Completo
                  </Link>
               </Button>
            </div>
          )}
        </CardContent>
      </Card>
    );
  };

  return (
    <div className="space-y-8">
      <div className="flex flex-col gap-4">
        <Link to="/dashboard" className="self-start">
          <Button variant="ghost" size="sm" className="pl-0 text-leather hover:text-copper hover:bg-transparent -ml-2">
            <ArrowLeft className="h-4 w-4 mr-1.5" /> Voltar para a garagem
          </Button>
        </Link>
        <div>
          <p className="text-xs uppercase tracking-[0.25em] text-copper mb-2">GPS e Viagens</p>
          <h1 className="font-display text-3xl md:text-4xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>
            Rotas e Passeios
          </h1>
          <p className="text-sm text-leather mt-2">
            Acompanhe nossos roteiros planejados, trace o caminho direto pro Waze no dia da viagem e veja o registro dos rolês passados.
          </p>
        </div>
      </div>

      {loading ? (
        <p className="text-leather">Carregando rotas…</p>
      ) : (
        <Tabs value={activeTab} onValueChange={(val) => navigate({ search: { tab: val } })} className="w-full">
          <TabsList className="grid w-full grid-cols-2 max-w-[400px] mb-8 bg-cream border border-leather/20">
            <TabsTrigger value="open" className="data-[state=active]:bg-copper data-[state=active]:text-cream text-coffee">
              Em Aberto ({openRoutes.length})
            </TabsTrigger>
            <TabsTrigger value="completed" className="data-[state=active]:bg-coffee data-[state=active]:text-cream text-coffee">
              Finalizadas ({completedRoutes.length})
            </TabsTrigger>
          </TabsList>
          
          <TabsContent value="open">
            <div className="flex gap-2 mb-6 overflow-x-auto pb-2 scrollbar-hide">
              <Button 
                variant="outline" 
                onClick={() => setFilterType('all')}
                className={`rounded-full h-8 px-4 text-xs ${filterType === 'all' ? 'bg-coffee border-coffee hover:bg-coffee/90 text-cream hover:text-cream' : 'bg-transparent border-leather/30 text-coffee hover:bg-leather/10 hover:text-coffee'}`}
              >
                Todos
              </Button>
              <Button 
                variant="outline" 
                onClick={() => setFilterType('open')}
                className={`rounded-full h-8 px-4 text-xs ${filterType === 'open' ? 'bg-copper border-copper hover:bg-copper/90 text-white hover:text-white' : 'bg-transparent border-leather/30 text-coffee hover:bg-leather/10 hover:text-coffee'}`}
              >
                Próximos Passeios
              </Button>
              <Button 
                variant="outline" 
                onClick={() => setFilterType('planning')}
                className={`rounded-full h-8 px-4 text-xs ${filterType === 'planning' ? 'bg-copper border-copper hover:bg-copper/90 text-white hover:text-white' : 'bg-transparent border-leather/30 text-coffee hover:bg-leather/10 hover:text-coffee'}`}
              >
                Em Planejamento
              </Button>
            </div>

            {filteredOpenRoutes.length === 0 ? (
              <Card className="border-dashed border-leather/40 bg-cream">
                <CardContent className="py-16 text-center">
                  <Map className="h-12 w-12 mx-auto mb-4 text-copper" />
                  <h3 className="font-display text-xl text-coffee mb-2" style={{ fontFamily: "var(--font-display)" }}>
                    Nenhuma rota encontrada
                  </h3>
                  <p className="text-sm text-leather">Tente alterar os filtros acima.</p>
                </CardContent>
              </Card>
            ) : (
              <div className="grid lg:grid-cols-2 gap-6">
                {filteredOpenRoutes.map((route) => renderRouteCard(route, false))}
              </div>
            )}
          </TabsContent>
          
          <TabsContent value="completed">
            {completedRoutes.length === 0 ? (
               <Card className="border-dashed border-leather/40 bg-cream">
               <CardContent className="py-16 text-center">
                 <Flag className="h-12 w-12 mx-auto mb-4 text-copper/60" />
                 <h3 className="font-display text-xl text-coffee mb-2" style={{ fontFamily: "var(--font-display)" }}>
                   Nenhuma rota finalizada
                 </h3>
                 <p className="text-sm text-leather">O histórico de viagens está vazio.</p>
               </CardContent>
             </Card>
            ) : (
              <div className="grid lg:grid-cols-2 gap-6">
                {completedRoutes.map((route) => renderRouteCard(route, true))}
              </div>
            )}
          </TabsContent>
        </Tabs>
      )}
    </div>
  );
}
