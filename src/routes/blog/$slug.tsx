import { createFileRoute, Link, notFound } from "@tanstack/react-router";
import { Navbar } from "@/components/site/Navbar";
import { Footer } from "@/components/site/Footer";
import { supabase } from "@/integrations/supabase/client";
import { Calendar, ArrowLeft } from "lucide-react";
import n1 from "@/assets/news-1.jpg";

export const Route = createFileRoute("/blog/$slug")({
  loader: async ({ params }) => {
    const [newsRes, contentRes] = await Promise.all([
      supabase.from("news").select("*").eq("slug", params.slug).eq("status", "published").single(),
      supabase.from("site_content").select("key, value").eq("key", "general").single()
    ]);

    if (!newsRes.data) {
      throw notFound();
    }

    return {
      article: newsRes.data,
      logoUrl: (contentRes.data?.value as any)?.logo_url,
    };
  },
  component: NewsArticle,
});

function NewsArticle() {
  const { article, logoUrl } = Route.useLoaderData();

  const dateStr = new Date(article.published_at ?? article.created_at).toLocaleDateString("pt-BR", {
    day: "2-digit", month: "long", year: "numeric"
  });

  return (
    <div className="min-h-screen bg-cream scroll-smooth flex flex-col">
      <Navbar logoUrl={logoUrl} />

      <main className="flex-1 pt-24">
        {/* Hero Section of the Article */}
        <div className="relative h-[40vh] md:h-[50vh] min-h-[300px] w-full">
          <img
            src={article.cover_url || n1}
            alt={article.title}
            className="absolute inset-0 h-full w-full object-cover"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-cream via-cream/80 to-transparent" />
          
          <div className="absolute inset-0 flex flex-col justify-end pb-12">
            <div className="mx-auto w-full max-w-4xl px-4 sm:px-6 lg:px-8">
              <Link
                to="/blog"
                className="inline-flex items-center gap-2 text-leather hover:text-copper transition-colors uppercase tracking-[0.2em] text-xs font-semibold mb-6"
                style={{ fontFamily: "var(--font-display)" }}
              >
                <ArrowLeft className="h-4 w-4" /> Voltar ao Blog
              </Link>

              <div className="flex items-center gap-3 text-[10px] md:text-xs uppercase tracking-[0.28em] text-copper mb-4 drop-shadow-sm" style={{ fontFamily: "var(--font-display)" }}>
                <span className="inline-flex items-center gap-1.5 bg-cream/50 px-2 py-1 rounded backdrop-blur-sm">
                  <Calendar className="h-4 w-4" /> {dateStr}
                </span>
                {article.tag && (
                  <>
                    <span className="text-leather">·</span>
                    <span className="bg-cream/50 px-2 py-1 rounded backdrop-blur-sm text-leather">{article.tag}</span>
                  </>
                )}
              </div>

              <h1 className="text-4xl md:text-5xl lg:text-6xl text-coffee font-bold uppercase leading-tight drop-shadow-md" style={{ fontFamily: "var(--font-display)" }}>
                {article.title}
              </h1>
            </div>
          </div>
        </div>

        {/* Article Body */}
        <div className="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8 py-16">
          <article className="prose prose-lg prose-copper mx-auto max-w-none">
            {article.excerpt && (
              <p className="text-xl md:text-2xl text-coffee/90 font-serif italic mb-10 leading-relaxed border-l-4 border-copper pl-6">
                {article.excerpt}
              </p>
            )}
            
            {(() => {
              let parsedBlocks: { id: string, type: string, value: string }[] | null = null;
              try {
                const parsed = JSON.parse(article.content || "[]");
                if (Array.isArray(parsed) && parsed.length > 0 && parsed[0].type) {
                  parsedBlocks = parsed;
                }
              } catch {}

              if (parsedBlocks) {
                return (
                  <div className="text-coffee/80 leading-relaxed font-serif text-lg">
                    {parsedBlocks.map(block => {
                      if (block.type === "paragraph") {
                        return (
                          <div key={block.id} className="space-y-4 mb-8">
                            {block.value.split('\n').map((paragraph, index) => (
                              paragraph.trim() ? <p key={index}>{paragraph}</p> : <br key={index} />
                            ))}
                          </div>
                        );
                      }
                      if (block.type === "subtitle" && block.value) {
                        return (
                          <h2 key={block.id} className="text-3xl md:text-4xl text-coffee font-bold mt-16 mb-8" style={{ fontFamily: "var(--font-display)" }}>
                            {block.value}
                          </h2>
                        );
                      }
                      if (block.type === "image" && block.value) {
                        return (
                          <figure key={block.id} className="my-12">
                            <img src={block.value} alt="" className="w-full rounded-xl shadow-lg border border-copper/20" />
                          </figure>
                        );
                      }
                      return null;
                    })}
                  </div>
                );
              }

              return (
                <div className="text-coffee/80 leading-relaxed space-y-6 font-serif text-lg">
                  {article.content?.split('\n').map((paragraph, index) => (
                    paragraph.trim() ? (
                      <p key={index} className="min-h-[1.5em]">{paragraph}</p>
                    ) : (
                      <br key={index} />
                    )
                  ))}
                </div>
              );
            })()}
          </article>
        </div>
      </main>

      <Footer />
    </div>
  );
}
