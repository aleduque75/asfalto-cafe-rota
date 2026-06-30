import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Navbar } from "@/components/site/Navbar";
import { Footer } from "@/components/site/Footer";
import { Loader2, Instagram, ArrowLeft } from "lucide-react";
import fallbackImg from "@/assets/gallery-1.jpg";
import { Link } from "@tanstack/react-router";

export const Route = createFileRoute("/galeria/")({
  loader: async () => {
    const { data } = await supabase.from("site_content").select("key, value").eq("key", "general").maybeSingle();
    return { logoUrl: data?.value && typeof data.value === 'object' && 'logo_url' in data.value ? (data.value as any).logo_url : undefined };
  },
  component: GaleriaPage,
});

type GalleryItem = { id: string; img: string; title: string; caption: string; instagram_url: string | null };

function GaleriaPage() {
  const { logoUrl } = Route.useLoaderData();
  const [items, setItems] = useState<GalleryItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    (async () => {
      const { data } = await supabase
        .from("gallery_items")
        .select("id, image_url, title, caption, instagram_url")
        .eq("status", "published")
        .order("sort_order", { ascending: true })
        .order("created_at", { ascending: false });
      
      if (data) {
        setItems(
          data.map((d) => ({
            id: d.id,
            img: d.image_url,
            title: d.title ?? "",
            caption: d.caption ?? "",
            instagram_url: d.instagram_url,
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
          <div className="mb-6 max-w-4xl mx-auto flex justify-start">
            <Link to="/" className="inline-flex items-center gap-2 text-sm text-copper hover:text-cream transition-colors uppercase tracking-widest font-medium" style={{ fontFamily: "var(--font-display)" }}>
              <ArrowLeft className="h-4 w-4" /> Voltar ao Início
            </Link>
          </div>
          
          <div className="text-center max-w-2xl mx-auto mb-10">
            <p className="eyebrow mb-3">No Instagram</p>
            <h1 className="section-title text-4xl md:text-6xl text-cream">Galeria de Posts</h1>
            <p className="mt-3 text-cream/70">
              Registros das nossas viagens, paradas e momentos na estrada.
            </p>
          </div>

          {loading ? (
            <div className="flex justify-center py-20 text-copper">
              <Loader2 className="h-8 w-8 animate-spin" />
            </div>
          ) : items.length === 0 ? (
            <div className="text-center py-20 border border-leather/30 rounded-lg text-cream/70">
              Nenhuma foto publicada ainda.
            </div>
          ) : (
            <div className="max-w-4xl mx-auto">
              <div className="grid grid-cols-3 gap-1 md:gap-2">
                {items.map((item) => (
                  <div key={item.id} className="group relative aspect-square overflow-hidden bg-leather/20">
                    <img
                      src={item.img}
                      alt={item.title}
                      loading="lazy"
                      className="h-full w-full object-cover"
                      onError={(e) => {
                        e.currentTarget.onerror = null;
                        e.currentTarget.src = fallbackImg;
                      }}
                    />
                    <a
                      href={item.instagram_url || "#"}
                      target={item.instagram_url ? "_blank" : "_self"}
                      rel="noopener noreferrer"
                      className="absolute inset-0 bg-coffee/80 opacity-0 transition-opacity duration-200 group-hover:opacity-100 flex flex-col justify-center items-center p-4 text-center cursor-pointer"
                    >
                      <Instagram className="h-8 w-8 text-cream mb-3 opacity-90" />
                      {item.title && <h3 className="font-display text-cream text-sm md:text-lg leading-tight mb-2" style={{ fontFamily: "var(--font-display)" }}>{item.title}</h3>}
                    </a>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </main>

      <Footer />
    </div>
  );
}
