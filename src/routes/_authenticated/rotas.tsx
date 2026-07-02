import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { MapPin, Navigation, Calendar, Clock, Map, Play, Image as ImageIcon, Flag, Route as RouteIcon, CheckCircle2, ArrowLeft } from "lucide-react";
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
  status: 'open' | 'completed';
  estimated_duration_mins: number | null;
  visited_places: string | null;
};

function RotasPage() {
  const [routes, setRoutes] = useState<RouteData[]>([]);
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const { tab } = Route.useSearch();
  const navigate = useNavigate({ from: Route.fullPath });
  const activeTab = tab === "completed" ? "completed" : "open";

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
      .select("*")
      .order("start_date", { ascending: false });

    if (error) {
      toast.error(error.message);
    } else {
      setRoutes((data as RouteData[]) || []);
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

  const openRoutes = routes.filter(r => r.status === 'open');
  const completedRoutes = routes.filter(r => r.status === 'completed');

  const renderRouteCard = (route: RouteData, isPastMode: boolean = false) => {
    const date = new Date(route.start_date);
    
    return (
      <Card key={route.id} className="overflow-hidden border-leather/30 hover:border-copper transition h-full flex flex-col bg-cream">
        <CardHeader className="bg-gradient-to-br from-coffee to-leather p-5 pb-8 relative">
          <Badge variant={isPastMode ? "secondary" : "default"} className="absolute top-4 right-4 bg-copper text-cream border-none">
            {isPastMode ? "Finalizado" : "Em Aberto"}
          </Badge>
          <CardTitle className="text-cream text-2xl" style={{ fontFamily: "var(--font-display)" }}>
            {route.title}
          </CardTitle>
          <p className="text-cream/80 text-sm flex items-center gap-1.5 mt-2">
            <Flag className="h-4 w-4" /> Destino: {route.destination}
          </p>
        </CardHeader>
        
        <CardContent className="p-5 flex-1 flex flex-col pt-0">
          <div className="bg-cream shadow-sm border border-leather/20 rounded-lg p-4 -mt-6 relative z-10 space-y-3 mb-4">
            <div className="flex items-center gap-3 text-sm text-coffee">
              <Calendar className="h-4 w-4 text-copper shrink-0" />
              <span>Data: {date.toLocaleDateString("pt-BR")}</span>
            </div>
            <div className="flex items-center gap-3 text-sm text-coffee">
              <Clock className="h-4 w-4 text-copper shrink-0" />
              <span>Saída: {route.meeting_time} | Ponto: {route.meeting_point}</span>
            </div>
            {route.estimated_distance_km && (
              <div className="flex items-center gap-3 text-sm text-coffee">
                <Navigation className="h-4 w-4 text-copper shrink-0" />
                <span>Distância: {route.estimated_distance_km} km (aprox.)</span>
              </div>
            )}
            {route.estimated_duration_mins && (
              <div className="flex items-center gap-3 text-sm text-coffee">
                <RouteIcon className="h-4 w-4 text-copper shrink-0" />
                <span>Tempo estimado: {formatDuration(route.estimated_duration_mins)}</span>
              </div>
            )}
            {route.visited_places && (
              <div className="flex items-start gap-3 text-sm text-coffee mt-2 border-t border-leather/10 pt-2">
                <MapPin className="h-4 w-4 text-copper shrink-0 mt-0.5" />
                <span>Locais: {route.visited_places}</span>
              </div>
            )}
          </div>

          <p className="text-sm text-leather mb-6 flex-1">
            {route.description}
          </p>

          <div className="flex flex-col sm:flex-row items-center gap-3 mt-auto">
            {!isPastMode && (
              <Button onClick={() => openWaze(route)} className="flex-1 w-full btn-copper flex gap-2">
                <Navigation className="h-4 w-4" />
                Iniciar Passeio (Waze)
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
        </CardContent>
      </Card>
    );
  };

  return (
    <div className="space-y-8">
      <div className="flex flex-col gap-4">
        <Link to="/dashboard" className="sm:hidden self-start">
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
            {openRoutes.length === 0 ? (
              <Card className="border-dashed border-leather/40 bg-cream">
                <CardContent className="py-16 text-center">
                  <Map className="h-12 w-12 mx-auto mb-4 text-copper" />
                  <h3 className="font-display text-xl text-coffee mb-2" style={{ fontFamily: "var(--font-display)" }}>
                    Nenhuma rota em aberto
                  </h3>
                  <p className="text-sm text-leather">A turma ainda não planejou o próximo passeio.</p>
                </CardContent>
              </Card>
            ) : (
              <div className="grid lg:grid-cols-2 gap-6">
                {openRoutes.map((route) => renderRouteCard(route, false))}
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
