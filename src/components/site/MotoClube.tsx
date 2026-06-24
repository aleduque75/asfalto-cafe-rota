import { Coffee, MapPin, Mountain, Heart } from "lucide-react";

const pilares = [
  { icon: Coffee, title: "Café quente", text: "A parada no meio do caminho é sagrada." },
  { icon: Mountain, title: "Paisagens", text: "Interior de SP e além — só quem anda de moto conhece." },
  { icon: MapPin, title: "Atibaia", text: "Saímos daqui pra qualquer canto que tenha estrada boa." },
  { icon: Heart, title: "Amizade", text: "Cada rolê vira história. A turma se fortalece a cada km." },
];

const destinos = ["Pedra Bela", "Monte Verde", "Joanópolis", "Salesópolis"];

export function MotoClube({ content }: { content?: Record<string, string> }) {
  return (
    <section id="moto-clube" className="relative py-24 md:py-32">
      <div className="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto">
          <p className="eyebrow mb-3">Nossa história</p>
          <h2 className="section-title text-4xl md:text-6xl mb-6">
            {content?.title || "Café Moto e Asfalto"}
          </h2>
          <p className="text-cream/70 text-lg md:text-xl font-serif italic" style={{ fontFamily: "var(--font-serif)" }}>
            O primeiro de muitos quilômetros juntos.
          </p>
        </div>

        <div className="mt-16 grid md:grid-cols-2 gap-10 items-start">
          <div className="card-leather rounded-lg p-8 md:p-10">
            {content?.paragraph ? (
              <p className="text-cream/85 leading-relaxed mb-6 whitespace-pre-wrap">
                {content.paragraph}
              </p>
            ) : (
              <>
                <p className="text-cream/85 leading-relaxed mb-4">
                  Tudo começou com um grupo de amigos, algumas motos e uma vontade enorme de
                  pegar a estrada.
                </p>
                <p className="text-cream/85 leading-relaxed mb-4">
                  Criamos esse espaço pra dividir o que move a nossa turma: o cheiro do
                  asfalto de manhã cedo, o café quente numa parada no meio do caminho e as
                  paisagens do interior de SP — e além — que só quem anda de moto conhece de
                  verdade.
                </p>
                <p className="text-cream/85 leading-relaxed mb-6">
                  De Pedra Bela, Monte Verde, Joanópolis, Salesópolis e muitos outros que estão
                  por vir, cada rolê vira história e a amizade se fortalece. Aqui a gente
                  compartilha nossos passeios, viagens, paradas e os melhores momentos da
                  estrada.
                </p>
              </>
            )}

            <div className="flex flex-wrap gap-2 mb-8">
              {destinos.map((d) => (
                <span
                  key={d}
                  className="inline-flex items-center gap-1.5 rounded-full border border-copper/40 bg-copper/10 px-3 py-1 text-xs uppercase tracking-[0.18em] text-copper"
                  style={{ fontFamily: "var(--font-display)" }}
                >
                  <MapPin className="h-3 w-3" /> {d}
                </span>
              ))}
            </div>

            <div className="border-t border-border pt-6 flex items-center justify-between text-sm">
              <div className="flex items-center gap-3 text-cream/70 text-xs uppercase tracking-[0.28em]" style={{ fontFamily: "var(--font-display)" }}>
                <span>Respeito</span>
                <span className="text-copper">·</span>
                <span>Liberdade</span>
                <span className="text-copper">·</span>
                <span>Estrada</span>
              </div>
              <span className="text-copper text-xs uppercase tracking-[0.28em]" style={{ fontFamily: "var(--font-display)" }}>
                Desde 2024
              </span>
            </div>
          </div>

          <div className="grid sm:grid-cols-2 gap-4">
            {pilares.map(({ icon: Icon, title, text }) => (
              <div
                key={title}
                className="card-leather rounded-lg p-6 hover:border-copper/60 transition"
              >
                <div className="inline-flex items-center justify-center h-11 w-11 rounded-full bg-copper/15 text-copper mb-4">
                  <Icon className="h-5 w-5" />
                </div>
                <h3 className="text-cream text-lg uppercase tracking-wide mb-2" style={{ fontFamily: "var(--font-display)" }}>
                  {title}
                </h3>
                <p className="text-cream/70 text-sm leading-relaxed">{text}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}