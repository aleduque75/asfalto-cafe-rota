import { ArrowRight, Calendar } from "lucide-react";
import { Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import n1 from "@/assets/news-1.jpg";
import n2 from "@/assets/news-2.jpg";
import n3 from "@/assets/news-3.jpg";

type NewsCard = { img: string; date: string; tag: string; title: string; excerpt: string; slug?: string };

export function Noticias() {
  const [noticias, setNoticias] = useState<NewsCard[]>([]);

  useEffect(() => {
    (async () => {
      const { data } = await supabase
        .from("news")
        .select("title, slug, excerpt, cover_url, tag, published_at, created_at")
        .eq("status", "published")
        .order("published_at", { ascending: false, nullsFirst: false })
        .limit(6);
      if (data && data.length > 0) {
        setNoticias(
          data.map((d, index) => {
            const fallbacks = [n1, n2, n3];
            const fallbackImg = fallbacks[index % 3];
            return {
              img: d.cover_url || fallbackImg,
              date: new Date(d.published_at ?? d.created_at).toLocaleDateString("pt-BR", { day: "2-digit", month: "short", year: "numeric" }),
              tag: d.tag ?? "Notícia",
              title: d.title,
              excerpt: d.excerpt ?? "",
              slug: d.slug,
            };
          })
        );
      }
    })();
  }, []);

  if (noticias.length === 0) return null;

  return (
    <section id="noticias" className="relative py-24 md:py-32">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-2xl mx-auto mb-14">
          <p className="eyebrow mb-3">Diário de bordo</p>
          <h2 className="section-title text-4xl md:text-6xl">Notícias</h2>
          <p className="mt-3 text-cream/70">
            Histórias da estrada, próximos rolês e tudo que rola no clube.
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-6 lg:gap-8">
          {noticias.map((p) => (
            <article
              key={p.title}
              className="card-leather rounded-lg overflow-hidden flex flex-col group hover:border-copper/60 transition"
            >
              <div className="aspect-[4/3] overflow-hidden">
                <img
                  src={p.img}
                  alt={p.title}
                  width={1024}
                  height={768}
                  loading="lazy"
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
                <Link
                  to="/noticias/$slug"
                  params={{ slug: p.slug ?? "noticia" }}
                  className="inline-flex items-center gap-2 text-copper text-sm uppercase tracking-[0.2em] font-semibold group-hover:gap-3 transition-all mt-auto"
                  style={{ fontFamily: "var(--font-display)" }}
                >
                  Saiba mais <ArrowRight className="h-4 w-4" />
                </Link>
              </div>
            </article>
          ))}
        </div>

        <div className="mt-14 text-center">
          <Link
            to="/noticias"
            className="inline-flex items-center justify-center rounded-md border border-copper/50 px-7 py-3.5 text-sm uppercase tracking-[0.18em] font-semibold text-cream hover:bg-copper/10 transition"
            style={{ fontFamily: "var(--font-display)" }}
          >
            Ver todas as notícias
          </Link>
        </div>
      </div>
    </section>
  );
}