import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Navbar } from "@/components/site/Navbar";
import { Footer } from "@/components/site/Footer";
import { ArrowRight, Calendar, Loader2 } from "lucide-react";
import n1 from "@/assets/news-1.jpg";

export const Route = createFileRoute("/noticias/")({
  loader: async () => {
    const { data } = await supabase.from("site_content").select("key, value").eq("key", "general").maybeSingle();
    return { logoUrl: data?.value && typeof data.value === 'object' && 'logo_url' in data.value ? (data.value as any).logo_url : undefined };
  },
  component: NoticiasList,
});

type NewsCard = { img: string; date: string; tag: string; title: string; excerpt: string; slug: string };

function NoticiasList() {
  const { logoUrl } = Route.useLoaderData();
  const [noticias, setNoticias] = useState<NewsCard[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    (async () => {
      const { data } = await supabase
        .from("news")
        .select("title, slug, excerpt, cover_url, tag, published_at, created_at")
        .eq("status", "published")
        .order("published_at", { ascending: false, nullsFirst: false });
      
      if (data) {
        setNoticias(
          data.map((d) => ({
            img: d.cover_url || n1,
            date: new Date(d.published_at ?? d.created_at).toLocaleDateString("pt-BR", { day: "2-digit", month: "short", year: "numeric" }),
            tag: d.tag ?? "Notícia",
            title: d.title,
            excerpt: d.excerpt ?? "",
            slug: d.slug ?? d.title.toLowerCase().replace(/\\s+/g, "-"),
          }))
        );
      }
      setLoading(false);
    })();
  }, []);

  return (
    <div className="min-h-screen bg-coffee text-cream flex flex-col">
      <Navbar logoUrl={logoUrl} />
      
      <main className="flex-1 pt-32 pb-24">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-2xl mx-auto mb-14">
            <p className="eyebrow mb-3">Blog e Novidades</p>
            <h1 className="section-title text-4xl md:text-6xl text-cream">Notícias</h1>
            <p className="mt-3 text-cream/70">
              Fique por dentro de tudo que acontece no Moto Clube Café Moto e Asfalto.
            </p>
          </div>

          {loading ? (
            <div className="flex justify-center py-20 text-copper">
              <Loader2 className="h-8 w-8 animate-spin" />
            </div>
          ) : noticias.length === 0 ? (
            <div className="text-center py-20 border border-leather/30 rounded-lg text-cream/70">
              Nenhuma notícia publicada ainda.
            </div>
          ) : (
            <div className="grid md:grid-cols-3 gap-6 lg:gap-8">
              {noticias.map((p) => (
                <article
                  key={p.slug}
                  className="card-leather rounded-lg overflow-hidden flex flex-col group hover:border-copper/60 transition"
                >
                  <Link to={`/noticias/$slug`} params={{ slug: p.slug }} className="flex flex-col flex-1">
                    <div className="aspect-[4/3] overflow-hidden">
                      <img
                        src={p.img}
                        alt={p.title}
                        className="h-full w-full object-cover transition duration-500 group-hover:scale-105"
                      />
                    </div>
                    <div className="p-6 flex flex-col flex-1">
                      <div className="flex items-center gap-3 text-[10px] uppercase tracking-[0.28em] text-copper mb-3" style={{ fontFamily: "var(--font-display)" }}>
                        <span className="inline-flex items-center gap-1.5">
                          <Calendar className="h-3 w-3" /> {p.date}
                        </span>
                        <span className="text-cream/40">·</span>
                        <span>{p.tag}</span>
                      </div>
                      <h3 className="text-cream text-xl leading-snug mb-3 uppercase" style={{ fontFamily: "var(--font-display)" }}>
                        {p.title}
                      </h3>
                      <p className="text-cream/70 text-sm leading-relaxed mb-6 flex-1">{p.excerpt}</p>
                      <div
                        className="inline-flex items-center gap-2 text-copper text-sm uppercase tracking-[0.2em] font-semibold group-hover:gap-3 transition-all"
                        style={{ fontFamily: "var(--font-display)" }}
                      >
                        Ler matéria <ArrowRight className="h-4 w-4" />
                      </div>
                    </div>
                  </Link>
                </article>
              ))}
            </div>
          )}
        </div>
      </main>

      <Footer />
    </div>
  );
}
