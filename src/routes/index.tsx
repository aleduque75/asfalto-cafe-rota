import { Capacitor } from '@capacitor/core';
import { createFileRoute, Navigate } from "@tanstack/react-router";
import { Toaster } from "@/components/ui/sonner";
import { Navbar } from "@/components/site/Navbar";
import { Hero } from "@/components/site/Hero";
import { MotoClube } from "@/components/site/MotoClube";
import { Galeria } from "@/components/site/Galeria";
import { Noticias } from "@/components/site/Noticias"; // Removed
import { Blog } from "@/components/site/Blog";
import { Contato } from "@/components/site/Contato";
import { Footer } from "@/components/site/Footer";
import { supabase } from "@/integrations/supabase/client";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "Café Moto e Asfalto — Moto Clube de Atibaia/SP" },
      {
        name: "description",
        content:
          "Moto clube Café Moto e Asfalto de Atibaia/SP. Passeios, paisagens do interior, café quente e estrada. Respeito · Liberdade · Estrada. Desde 2024.",
      },
      { property: "og:title", content: "Café Moto e Asfalto — Moto Clube Atibaia" },
      {
        property: "og:description",
        content: "Café quente, asfalto de manhã cedo e as paisagens do interior de SP. Bora pegar a estrada com a gente.",
      },
    ],
  }),
  loader: async () => {
    const { data } = await supabase.from("site_content").select("key, value");
    const contentMap: Record<string, any> = {};
    if (data) {
      for (const row of data) {
        contentMap[row.key] = row.value;
      }
    }
    return { contentMap };
  },
  component: Index,
});

function Index() {
  const { contentMap } = Route.useLoaderData();
  
  if (Capacitor.isNativePlatform()) {
    return (
      <div className="min-h-screen scroll-smooth">
        <Hero content={contentMap.hero} logoUrl={contentMap.general?.logo_url} isAppWelcomeScreen />
        <Toaster />
      </div>
    );
  }

  return (
    <div className="min-h-screen scroll-smooth">
      <Navbar logoUrl={contentMap.general?.logo_url} />
      <main>
        <Hero content={contentMap.hero} logoUrl={contentMap.general?.logo_url} />
        <MotoClube content={contentMap.club_story} />
        <Galeria />
        <Blog />
        <Contato content={contentMap.contact} />
      </main>
      <Footer />
      <Toaster />
    </div>
  );
}
