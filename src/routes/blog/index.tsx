import { createFileRoute, Link } from "@tanstack/react-router";
import { Navbar } from "@/components/site/Navbar";
import { Footer } from "@/components/site/Footer";
import { supabase } from "@/integrations/supabase/client";
import { Calendar, ArrowRight, ArrowLeft } from "lucide-react";
import n1 from "@/assets/news-1.jpg";

export const Route = createFileRoute("/blog/")({
  loader: async () => {
    const [newsRes, contentRes] = await Promise.all([
      supabase
        .from("news")
        .select("title, slug, excerpt, cover_url, tag, published_at, created_at")
        .eq("status", "published")
        .order("published_at", { ascending: false, nullsFirst: false }),
      supabase.from("site_content").select("key, value").eq("key", "general").single()
    ]);

    return {
      news: newsRes.data ?? [],
      logoUrl: (contentRes.data?.value as any)?.logo_url,
    };
  },
  component: NoticiasList,
});

function NoticiasList() {
  const { news, logoUrl } = Route.useLoaderData();

  return (
    <div className="min-h-screen bg-cream scroll-smooth flex flex-col">
      <Navbar logoUrl={logoUrl} />
      
      <main className="flex-1 pt-32 pb-24">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="mb-12">
            <Link
              to="/"
              className="inline-flex items-center gap-2 text-leather hover:text-copper transition-colors uppercase tracking-[0.2em] text-xs font-semibold mb-6"
              style={{ fontFamily: "var(--font-display)" }}
            >
              <ArrowLeft className="h-4 w-4" /> Voltar ao Início
            </Link>
            <h1 className="text-5xl md:text-6xl lg:text-7xl text-coffee font-bold uppercase leading-tight mb-4" style={{ fontFamily: "var(--font-display)" }}>
              Blog do Clube
            </h1>
            <p className="text-leather text-lg max-w-2xl font-serif italic">
              Histórias da estrada, diário de bordo e novidades sobre os próximos rolês do Café Moto e Asfalto.
            </p>
          </div>

          {news.length === 0 ? (
            <div className="py-24 text-center border border-dashed border-leather/30 rounded-xl bg-white/50">
              <p className="text-leather font-serif italic">Nenhum post publicado ainda.</p>
            </div>
          ) : (
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
              {news.map((p) => {
                const dateStr = new Date(p.published_at ?? p.created_at).toLocaleDateString("pt-BR", { 
                  day: "2-digit", month: "short", year: "numeric" 
                });
                
                return (
                  <article
                    key={p.slug}
                    className="bg-white/60 border border-leather/20 rounded-xl overflow-hidden flex flex-col group hover:border-copper/60 transition shadow-sm hover:shadow-md"
                  >
                    <div className="aspect-[4/3] overflow-hidden bg-leather/10">
                      <img
                        src={p.cover_url || n1}
                        alt={p.title}
                        className="h-full w-full object-cover transition duration-500 group-hover:scale-105"
                      />
                    </div>
                    <div className="p-6 flex flex-col flex-1">
                      <div className="flex items-center gap-3 text-[10px] uppercase tracking-[0.28em] text-copper mb-4" style={{ fontFamily: "var(--font-display)" }}>
                        <span className="inline-flex items-center gap-1.5">
                          <Calendar className="h-3 w-3" /> {dateStr}
                        </span>
                        {p.tag && (
                          <>
                            <span className="text-leather/40">·</span>
                            <span>{p.tag}</span>
                          </>
                        )}
                      </div>
                      <h3 className="text-coffee text-2xl leading-snug mb-3 uppercase" style={{ fontFamily: "var(--font-display)" }}>
                        {p.title}
                      </h3>
                      <p className="text-leather text-sm leading-relaxed mb-6 flex-1 line-clamp-3">
                        {p.excerpt || p.title}
                      </p>
                      <Link
                        to="/blog/$slug"
                        params={{ slug: p.slug }}
                        className="inline-flex items-center gap-2 text-copper text-sm uppercase tracking-[0.2em] font-semibold group-hover:gap-3 transition-all mt-auto w-fit"
                        style={{ fontFamily: "var(--font-display)" }}
                      >
                        Ler relato <ArrowRight className="h-4 w-4" />
                      </Link>
                    </div>
                  </article>
                );
              })}
            </div>
          )}
        </div>
      </main>

      <Footer />
    </div>
  );
}
