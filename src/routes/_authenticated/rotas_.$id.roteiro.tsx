import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Loader2, Calendar, MapPin, Navigation, Map, Printer } from "lucide-react";
import { toast } from "sonner";
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

export const Route = createFileRoute("/_authenticated/rotas_/$id/roteiro")({
  component: RoteiroPage,
});

function RoteiroPage() {
  const { id } = Route.useParams();
  const [route, setRoute] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setLoading(true);
      const { data, error } = await supabase
        .from("routes")
        .select("*")
        .eq("id", id)
        .single();
        
      if (error) {
        toast.error("Erro ao carregar roteiro");
      } else {
        setRoute(data);
      }
      setLoading(false);
    }
    load();
  }, [id]);

  if (loading) {
    return (
      <div className="flex items-center justify-center p-12">
        <Loader2 className="h-8 w-8 animate-spin text-copper" />
      </div>
    );
  }

  if (!route) {
    return <div className="p-8 text-center text-leather">Rota não encontrada.</div>;
  }

  const date = new Date(route.start_date);

  return (
    <div className="max-w-4xl mx-auto space-y-6 pb-12 bg-white print:bg-white print:p-0 print:m-0 print:pb-0">
      <Link to="/rotas" className="self-start print:hidden">
        <Button variant="ghost" size="sm" className="pl-0 text-leather hover:text-copper hover:bg-transparent -ml-2 mb-2">
          <ArrowLeft className="h-4 w-4 mr-1.5" /> Voltar para Rotas
        </Button>
      </Link>

      <div className="bg-cream border border-leather/20 rounded-xl overflow-hidden shadow-sm print:border-none print:shadow-none print:bg-white">
        <div className="relative h-48 md:h-64 w-full bg-coffee print:hidden">
          <img 
            src={route.cover_url || `https://image.pollinations.ai/prompt/${encodeURIComponent(route.destination + ' beautiful landscape motorcycle road trip cinematic')}?width=1200&height=400&nologo=true`}
            alt="Capa da Rota"
            className="w-full h-full object-cover opacity-60"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-coffee via-coffee/40 to-transparent" />
          <div className="absolute bottom-6 left-6 right-6">
            <h1 className="text-3xl md:text-5xl font-display text-white mb-2" style={{ fontFamily: "var(--font-display)" }}>
              {route.title}
            </h1>
            <div className="flex flex-wrap items-center gap-4 text-cream/90 text-sm font-medium">
              <span className="flex items-center gap-1.5"><MapPin className="h-4 w-4 text-copper" /> {route.destination}</span>
              <span className="flex items-center gap-1.5"><Calendar className="h-4 w-4 text-copper" /> {date.toLocaleDateString("pt-BR")} às {route.meeting_time}</span>
            </div>
          </div>
        </div>
        
        <CardContent className="p-6 md:p-10 print:p-0">
          <div className="hidden print:block mb-8 border-b-2 border-copper pb-4">
            <h1 className="text-3xl font-display text-coffee">{route.title}</h1>
            <div className="flex gap-4 text-leather mt-2">
              <span>{route.destination}</span>
              <span>{date.toLocaleDateString("pt-BR")} às {route.meeting_time}</span>
            </div>
          </div>

          <div className="flex items-center justify-between border-b border-leather/20 pb-6 mb-8 print:hidden">
            <div>
              <h2 className="text-2xl font-display text-coffee" style={{ fontFamily: "var(--font-display)" }}>Planejamento e Roteiro</h2>
              <p className="text-leather text-sm mt-1">Detalhes completos da expedição</p>
            </div>
            <div className="flex gap-2">
              <Button variant="outline" onClick={() => window.print()} className="border-coffee text-coffee hidden sm:flex">
                <Printer className="h-4 w-4 mr-2" /> Imprimir (PDF)
              </Button>
              {route.waze_url && (
                <Button onClick={() => window.open(route.waze_url, "_blank")} className="btn-copper hidden sm:flex">
                  <Navigation className="h-4 w-4 mr-2" /> Ir pro Waze
                </Button>
              )}
            </div>
          </div>

          <div className="prose prose-stone max-w-none 
            prose-headings:font-display prose-headings:text-coffee prose-headings:font-normal
            prose-h1:text-3xl prose-h2:text-2xl prose-h3:text-xl
            prose-p:text-coffee/90 prose-p:leading-relaxed
            prose-a:text-copper hover:prose-a:text-copper/80
            prose-strong:text-coffee prose-strong:font-bold
            prose-ul:text-coffee/90 prose-li:my-1
            prose-hr:border-leather/20
            prose-blockquote:border-l-copper prose-blockquote:bg-leather/5 prose-blockquote:px-4 prose-blockquote:py-1 prose-blockquote:rounded-r-md prose-blockquote:not-italic prose-blockquote:text-coffee/80
          ">
            {route.itinerary ? (
              <ReactMarkdown remarkPlugins={[remarkGfm]}>
                {route.itinerary}
              </ReactMarkdown>
            ) : (
              <div className="text-center py-12 text-leather/70 bg-black/5 rounded-lg border border-dashed border-leather/20">
                <Map className="h-12 w-12 mx-auto mb-3 opacity-50" />
                <p>Nenhum roteiro detalhado foi adicionado a esta rota.</p>
              </div>
            )}
          </div>
          
          <div className="mt-8 sm:hidden flex flex-col gap-3 print:hidden">
            <Button variant="outline" onClick={() => window.print()} className="border-coffee text-coffee w-full">
              <Printer className="h-4 w-4 mr-2" /> Imprimir / Salvar PDF
            </Button>
            {route.waze_url && (
              <Button onClick={() => window.open(route.waze_url, "_blank")} className="btn-copper w-full">
                <Navigation className="h-4 w-4 mr-2" /> Ir pro Waze
              </Button>
            )}
          </div>
        </CardContent>
      </div>
    </div>
  );
}
