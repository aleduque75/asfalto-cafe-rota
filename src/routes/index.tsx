import { createFileRoute } from "@tanstack/react-router";
import { Toaster } from "@/components/ui/sonner";
import { Navbar } from "@/components/site/Navbar";
import { Hero } from "@/components/site/Hero";
import { MotoClube } from "@/components/site/MotoClube";
import { Galeria } from "@/components/site/Galeria";
import { Noticias } from "@/components/site/Noticias";
import { Contato } from "@/components/site/Contato";
import { Footer } from "@/components/site/Footer";

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
  component: Index,
});

function Index() {
  return (
    <div className="min-h-screen scroll-smooth">
      <Navbar />
      <main>
        <Hero />
        <MotoClube />
        <Galeria />
        <Noticias />
        <Contato />
      </main>
      <Footer />
      <Toaster />
    </div>
  );
}
