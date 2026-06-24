import { createFileRoute, Link, useParams } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Navbar } from "@/components/site/Navbar";
import { Footer } from "@/components/site/Footer";
import { ArrowLeft, Calendar, Loader2 } from "lucide-react";
import n1 from "@/assets/news-1.jpg";

export const Route = createFileRoute("/noticias/$slug")({
  loader: async () => {
    const { data } = await supabase.from("site_content").select("key, value").eq("key", "general").maybeSingle();
    return { logoUrl: data?.value && typeof data.value === 'object' && 'logo_url' in data.value ? (data.value as any).logo_url : undefined };
  },
  component: NoticiaView,
});

type NewsArticle = {
  title: string;
  content: string;
  cover_url: string | null;
  tag: string;
  published_at: string;
};

function NoticiaView() {
  const { slug } = Route.useParams();
  const { logoUrl } = Route.useLoaderData();
  const [article, setArticle] = useState<NewsArticle | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    (async () => {
      const { data } = await supabase
        .from("news")
        .select("title, content, cover_url, tag, published_at, created_at")
        .eq("slug", slug)
        .eq("status", "published")
        .maybeSingle();
      
      if (data) {
        setArticle({
          title: data.title,
          content: data.content ?? "",
          cover_url: data.cover_url,
          tag: data.tag ?? "Notícia",
          published_at: new Date(data.published_at ?? data.created_at).toLocaleDateString("pt-BR", { day: "2-digit", month: "long", year: "numeric" }),
        });
      }
      setLoading(false);
    })();
  }, [slug]);

  return (
    <div className="min-h-screen bg-cream text-leather flex flex-col">
      {/* We need a dark navbar background for light pages if we reuse it, but Navbar adapts to scroll. */}
      {/* For this page, we'll just render it with a dark bg header by default using global styles or adapting Navbar */}
      <div className="bg-coffee border-b border-leather/20">
        <Navbar logoUrl={logoUrl} />
      </div>
      
      <main className="flex-1 pt-32 pb-24">
        <div className="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8">
          <Link to="/noticias" className="inline-flex items-center gap-2 text-copper text-sm uppercase tracking-widest font-semibold hover:text-coffee transition mb-8">
            <ArrowLeft className="h-4 w-4" /> Voltar para notícias
          </Link>

          {loading ? (
            <div className="flex justify-center py-20 text-copper">
              <Loader2 className="h-8 w-8 animate-spin" />
            </div>
          ) : !article ? (
            <div className="text-center py-20 border border-leather/30 rounded-lg text-leather/70">
              Notícia não encontrada.
            </div>
          ) : (
            <article>
              <header className="mb-10">
                <div className="flex items-center gap-3 text-[10px] uppercase tracking-[0.28em] text-copper mb-4" style={{ fontFamily: "var(--font-display)" }}>
                  <span className="inline-flex items-center gap-1.5">
                    <Calendar className="h-3 w-3" /> {article.published_at}
                  </span>
                  <span className="text-leather/40">·</span>
                  <span>{article.tag}</span>
                </div>
                <h1 className="text-4xl md:text-5xl lg:text-6xl font-display text-coffee leading-[1.1] mb-8" style={{ fontFamily: "var(--font-display)" }}>
                  {article.title}
                </h1>
                
                <img
                  src={article.cover_url || n1}
                  alt={article.title}
                  className="w-full aspect-[16/9] md:aspect-[21/9] object-cover rounded-xl shadow-lg"
                />
              </header>

              <div 
                className="prose prose-stone prose-lg max-w-none"
                dangerouslySetInnerHTML={{ __html: article.content }}
              />
            </article>
          )}
        </div>
      </main>

      <Footer />
    </div>
  );
}
