import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { MapPin, Calendar, Image as ImageIcon, ArrowLeft, Loader2, Map } from "lucide-react";
import { toast } from "sonner";
import type { Tables } from "@/integrations/supabase/types";

export const Route = createFileRoute("/_authenticated/galerias")({
  head: () => ({ meta: [{ title: "Galeria de Passeios — Café Moto e Asfalto" }] }),
  component: GaleriasPasseiosPage,
});

type RouteData = Tables<"routes">;

function GaleriasPasseiosPage() {
  const [routes, setRoutes] = useState<RouteData[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchCompletedRoutes() {
      const { data, error } = await supabase
        .from("routes")
        .select("*")
        .eq("status", "completed")
        .order("start_date", { ascending: false });

      if (error) {
        toast.error("Erro ao carregar passeios: " + error.message);
      } else {
        setRoutes(data || []);
      }
      setLoading(false);
    }
    fetchCompletedRoutes();
  }, []);

  const renderRouteCard = (route: RouteData) => {
    const date = new Date(route.start_date);
    
    return (
      <Link key={route.id} to="/rotas/$id/galeria" params={{ id: route.id }} className="group">
        <Card className="overflow-hidden border-leather/30 hover:border-copper transition h-full flex flex-col bg-cream shadow-sm hover:shadow-md">
          <CardHeader className="bg-gradient-to-br from-coffee to-leather p-5 pb-8 relative">
            <Badge variant="secondary" className="absolute top-4 right-4 bg-cream/20 text-cream border-none backdrop-blur-sm group-hover:bg-copper transition">
              <ImageIcon className="w-3 h-3 mr-1" /> Galeria
            </Badge>
            <CardTitle className="text-cream text-2xl group-hover:text-copper transition-colors" style={{ fontFamily: "var(--font-display)" }}>
              {route.title}
            </CardTitle>
            <p className="text-cream/80 text-sm flex items-center gap-1.5 mt-2 line-clamp-1">
              {route.destination}
            </p>
          </CardHeader>
          
          <CardContent className="p-5 flex-1 flex flex-col pt-0">
            <div className="bg-cream shadow-sm border border-leather/20 rounded-lg p-4 -mt-6 relative z-10 space-y-3 mb-4">
              <div className="flex items-center gap-3 text-sm text-coffee">
                <Calendar className="h-4 w-4 text-copper shrink-0" />
                <span>Data: {date.toLocaleDateString("pt-BR")}</span>
              </div>
              {route.visited_places && (
                <div className="flex items-start gap-3 text-sm text-coffee mt-2 border-t border-leather/10 pt-2">
                  <MapPin className="h-4 w-4 text-copper shrink-0 mt-0.5" />
                  <span className="line-clamp-2">Locais: {route.visited_places}</span>
                </div>
              )}
            </div>

            <p className="text-sm text-leather mb-4 line-clamp-3 flex-1">
              {route.description || "Sem descrição."}
            </p>
            
            <div className="flex items-center text-sm font-medium text-copper mt-auto group-hover:translate-x-1 transition-transform">
              Ver fotos deste rolê <ArrowLeft className="w-4 h-4 ml-1 rotate-180" />
            </div>
          </CardContent>
        </Card>
      </Link>
    );
  };

  return (
    <div className="space-y-8 max-w-5xl mx-auto">
      <div className="flex flex-col gap-4">
        <Link to="/dashboard" className="self-start">
          <button className="flex items-center text-sm text-leather hover:text-copper transition-colors">
            <ArrowLeft className="h-4 w-4 mr-1.5" /> Voltar para o painel
          </button>
        </Link>
        <div>
          <p className="text-xs uppercase tracking-[0.25em] text-copper mb-2">Memórias</p>
          <h1 className="font-display text-3xl md:text-4xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>
            Galeria de Passeios
          </h1>
          <p className="text-sm text-leather mt-2 max-w-2xl">
            Acompanhe o histórico de rolês realizados e acesse o álbum de fotos completo de cada destino.
          </p>
        </div>
      </div>

      {loading ? (
        <div className="flex flex-col items-center justify-center py-24 text-copper">
          <Loader2 className="h-8 w-8 animate-spin mb-4" />
          <p className="text-coffee font-medium">Buscando memórias...</p>
        </div>
      ) : routes.length === 0 ? (
        <Card className="border-dashed border-leather/40 bg-cream">
          <CardContent className="py-20 text-center">
            <Map className="h-12 w-12 mx-auto mb-4 text-copper/60" />
            <h3 className="font-display text-xl text-coffee mb-2" style={{ fontFamily: "var(--font-display)" }}>
              Nenhum passeio finalizado
            </h3>
            <p className="text-sm text-leather max-w-sm mx-auto">
              Quando um passeio for marcado como "Finalizado", ele aparecerá aqui com sua galeria de fotos.
            </p>
          </CardContent>
        </Card>
      ) : (
        <div className="grid md:grid-cols-2 gap-6">
          {routes.map((route) => renderRouteCard(route))}
        </div>
      )}
    </div>
  );
}
