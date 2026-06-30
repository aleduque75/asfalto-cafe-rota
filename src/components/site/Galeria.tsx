import { Instagram } from "lucide-react";
import { Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
  type CarouselApi,
} from "@/components/ui/carousel";
import Autoplay from "embla-carousel-autoplay";
import { cn } from "@/lib/utils";
import g1 from "@/assets/gallery-1.jpg";
import g2 from "@/assets/gallery-2.jpg";
import g3 from "@/assets/gallery-3.jpg";
import g4 from "@/assets/gallery-4.jpg";
import g5 from "@/assets/gallery-5.jpg";
import g6 from "@/assets/gallery-6.jpg";
import g7 from "@/assets/gallery-7.jpg";
import g8 from "@/assets/gallery-8.jpg";

type GalleryPost = { src: string; caption: string; date: string; href?: string };

const defaultPosts: GalleryPost[] = [
  { src: g1, caption: "Estrada da serra ao amanhecer", date: "Mar 2025" },
  { src: g2, caption: "Mirante em Joanópolis", date: "Fev 2025" },
  { src: g3, caption: "Parada do café — Pedra Bela", date: "Fev 2025" },
  { src: g4, caption: "Farol aceso, neblina baixa", date: "Jan 2025" },
  { src: g5, caption: "Saída em grupo, rumo a Monte Verde", date: "Jan 2025" },
  { src: g6, caption: "Vista do vale — Joanópolis", date: "Dez 2024" },
  { src: g7, caption: "Detalhe do tanque cromado", date: "Dez 2024" },
  { src: g8, caption: "A turma toda na estrada", date: "Nov 2024" },
];

export function Galeria() {
  const [posts, setPosts] = useState<GalleryPost[]>(defaultPosts);

  useEffect(() => {
    (async () => {
      const { data } = await supabase
        .from("gallery_items")
        .select("title, caption, image_url, instagram_url, created_at")
        .eq("status", "published")
        .order("sort_order", { ascending: true })
        .order("created_at", { ascending: false });
      if (data && data.length > 0) {
        setPosts(
          data.map((d) => ({
            src: d.image_url,
            caption: d.caption ?? d.title ?? "",
            date: new Date(d.created_at).toLocaleDateString("pt-BR", { month: "short", year: "numeric" }),
            href: d.instagram_url ?? undefined,
          })),
        );
      }
    })();
  }, []);

  const [api, setApi] = useState<CarouselApi>();
  const [current, setCurrent] = useState(0);
  const [count, setCount] = useState(0);

  useEffect(() => {
    if (!api) return;
    setCount(api.scrollSnapList().length);
    setCurrent(api.selectedScrollSnap() + 1);

    api.on("select", () => {
      setCurrent(api.selectedScrollSnap() + 1);
    });
  }, [api]);

  return (
    <section id="galeria" className="relative py-24 md:py-32 border-t border-border/60" style={{ background: "var(--gradient-leather)" }}>
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row md:items-end md:justify-between gap-6 mb-12">
          <div>
            <p className="eyebrow mb-3">@cafe_moto_asfalto</p>
            <h2 className="section-title text-4xl md:text-6xl">Galeria de Posts</h2>
            <p className="mt-3 text-cream/70 max-w-xl">
              Os melhores posts e momentos da estrada, registrados pela turma.
            </p>
          </div>
          <a
            href="https://www.instagram.com/cafe_moto_asfalto"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 rounded-md border border-copper/50 px-5 py-3 text-sm uppercase tracking-[0.18em] font-semibold text-cream hover:bg-copper/10 transition self-start"
            style={{ fontFamily: "var(--font-display)" }}
          >
            <Instagram className="h-4 w-4" /> Seguir no Instagram
          </a>
        </div>

        <Carousel 
          opts={{ align: "start", loop: true }} 
          plugins={[Autoplay({ delay: 3500, stopOnInteraction: true })]}
          setApi={setApi}
          className="w-full"
        >
          <CarouselContent className="-ml-4">
            {posts.map((p, i) => (
              <CarouselItem key={i} className="pl-4 basis-full md:basis-1/2 lg:basis-1/4">
                <a
                  href={p.href ?? "https://www.instagram.com/cafe_moto_asfalto"}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="group block relative overflow-hidden rounded-lg card-leather"
                >
                  <div className="aspect-square overflow-hidden">
                    <img
                      src={p.src}
                      alt={p.caption}
                      width={800}
                      height={800}
                      loading="lazy"
                      className="h-full w-full object-cover transition duration-500 group-hover:scale-105 bg-leather/20"
                      onError={(e) => {
                        e.currentTarget.onerror = null;
                        e.currentTarget.src = defaultPosts[i % defaultPosts.length].src;
                      }}
                    />
                  </div>
                  <div className="absolute inset-0 bg-gradient-to-t from-coffee via-coffee/20 to-transparent opacity-90" style={{ background: "linear-gradient(to top, var(--coffee), transparent 60%)" }} />
                  <div className="absolute inset-x-0 bottom-0 p-4">
                    <div className="flex items-center gap-2 text-copper text-[10px] uppercase tracking-[0.28em] mb-1.5" style={{ fontFamily: "var(--font-display)" }}>
                      <Instagram className="h-3 w-3" /> {p.date}
                    </div>
                    <p className="text-cream text-sm font-medium leading-snug line-clamp-2">{p.caption}</p>
                  </div>
                </a>
              </CarouselItem>
            ))}
          </CarouselContent>
          <CarouselPrevious className="hidden sm:flex -left-4 bg-coffee border-copper/40 text-copper hover:bg-copper hover:text-coffee" />
          <CarouselNext className="hidden sm:flex -right-4 bg-coffee border-copper/40 text-copper hover:bg-copper hover:text-coffee" />
          
          <div className="pt-6 pb-2 flex items-center justify-center gap-1.5 md:hidden">
            {Array.from({ length: count }).map((_, i) => (
              <div 
                key={i} 
                className={cn(
                  "h-1 rounded-full transition-all duration-500", 
                  current === i + 1 ? "w-6 bg-copper" : "w-3 bg-copper/30"
                )}
              />
            ))}
          </div>
        </Carousel>

        <div className="mt-14 text-center">
          <Link
            to="/galeria"
            className="inline-flex items-center justify-center rounded-md border border-copper/50 px-7 py-3.5 text-sm uppercase tracking-[0.18em] font-semibold text-cream hover:bg-copper/10 transition"
            style={{ fontFamily: "var(--font-display)" }}
          >
            Ver todas as fotos
          </Link>
        </div>
      </div>
    </section>
  );
}