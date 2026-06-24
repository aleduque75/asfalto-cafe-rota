import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { MapPin, Navigation, Calendar, Clock, Map, Play, Image as ImageIcon } from "lucide-react";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/rotas")({
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
};

function RotasPage() {
  const [routes, setRoutes] = useState<RouteData[]>([]);
  const [loading, setLoading] = useState(true);

  async function loadRoutes() {
    const { data, error } = await supabase
      .from("routes")
      .select("*")
      .order("start_date", { ascending: false });

    if (error) {
      toast.error(error.message);
    } else {
      setRoutes(data || []);
    }
    setLoading(false);
  }

  useEffect(() => {
    loadRoutes();
  }, []);

  const openWaze = (url: string | null) => {
    if (!url) {
      toast.error("Link do Waze não disponível para esta rota.");
      return;
    }
    window.open(url, "_blank");
  };

  return (
    <div className="space-y-8">
      <div>
        <p className="text-xs uppercase tracking-[0.25em] text-copper mb-2">GPS e Viagens</p>
        <h1 className="font-display text-3xl md:text-4xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>
          Rotas e Passeios
        </h1>
        <p className="text-sm text-leather mt-2">
          Acompanhe nossos roteiros planejados, trace o caminho direto pro Waze no dia da viagem e veja as fotos dos rolês passados.
        </p>
      </div>

      {loading ? (
        <p className="text-leather">Carregando rotas…</p>
      ) : routes.length === 0 ? (
        <Card className="border-dashed border-leather/40 bg-cream">
          <CardContent className="py-16 text-center">
            <Map className="h-12 w-12 mx-auto mb-4 text-copper" />
            <h3 className="font-display text-xl text-coffee mb-2" style={{ fontFamily: "var(--font-display)" }}>
              Nenhuma rota programada
            </h3>
            <p className="text-sm text-leather mb-4">A turma ainda não planejou o próximo café.</p>
          </CardContent>
        </Card>
      ) : (
        <div className="grid lg:grid-cols-2 gap-6">
          {routes.map((route) => {
            const date = new Date(route.start_date);
            const isPast = date < new Date();

            return (
              <Card key={route.id} className="overflow-hidden border-leather/30 hover:border-copper transition h-full flex flex-col bg-cream">
                <CardHeader className="bg-gradient-to-br from-coffee to-leather p-5 pb-8 relative">
                  <Badge variant={isPast ? "secondary" : "default"} className="absolute top-4 right-4 bg-copper text-cream border-none">
                    {isPast ? "Realizado" : "Próximo"}
                  </Badge>
                  <CardTitle className="text-cream text-2xl" style={{ fontFamily: "var(--font-display)" }}>
                    {route.title}
                  </CardTitle>
                  <p className="text-cream/80 text-sm flex items-center gap-1.5 mt-2">
                    <MapPin className="h-4 w-4" /> {route.destination}
                  </p>
                </CardHeader>
                
                <CardContent className="p-5 flex-1 flex flex-col pt-0">
                  <div className="bg-cream shadow-sm border border-leather/20 rounded-lg p-4 -mt-6 relative z-10 space-y-3 mb-4">
                    <div className="flex items-center gap-3 text-sm text-coffee">
                      <Calendar className="h-4 w-4 text-copper" />
                      <span>{date.toLocaleDateString("pt-BR")}</span>
                    </div>
                    <div className="flex items-center gap-3 text-sm text-coffee">
                      <Clock className="h-4 w-4 text-copper" />
                      <span>Saída: {route.meeting_time}</span>
                    </div>
                    <div className="flex items-center gap-3 text-sm text-coffee">
                      <MapPin className="h-4 w-4 text-copper" />
                      <span>Ponto de Encontro: {route.meeting_point}</span>
                    </div>
                    {route.estimated_distance_km && (
                      <div className="flex items-center gap-3 text-sm text-coffee">
                        <Navigation className="h-4 w-4 text-copper" />
                        <span>Distância: {route.estimated_distance_km} km (aprox.)</span>
                      </div>
                    )}
                  </div>

                  <p className="text-sm text-leather mb-6 flex-1">
                    {route.description}
                  </p>

                  <div className="flex items-center gap-3 mt-auto">
                    {!isPast && (
                      <Button onClick={() => openWaze(route.waze_url)} className="flex-1 btn-copper flex gap-2">
                        <Navigation className="h-4 w-4" />
                        Iniciar Waze
                      </Button>
                    )}
                    
                    {route.media_url && (
                      <Button variant="outline" onClick={() => window.open(route.media_url, "_blank")} className="flex-1 border-copper text-copper hover:bg-copper/10">
                        {route.media_url.includes("instagram") ? (
                          <><ImageIcon className="h-4 w-4 mr-2" /> Ver no Insta</>
                        ) : (
                          <><Play className="h-4 w-4 mr-2" /> Ver Mídia</>
                        )}
                      </Button>
                    )}
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
