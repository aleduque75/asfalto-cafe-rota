import { ArrowRight, Calendar } from "lucide-react";
import n1 from "@/assets/news-1.jpg";
import n2 from "@/assets/news-2.jpg";
import n3 from "@/assets/news-3.jpg";

const noticias = [
  {
    img: n1,
    date: "10 Jun 2026",
    tag: "Passeio",
    title: "Rolê a Monte Verde reúne a turma na serra",
    excerpt:
      "Saída cedo de Atibaia, parada estratégica pra café e um dia inteiro curtindo as curvas da serra. Foi rolê pra entrar pra história do clube.",
  },
  {
    img: n2,
    date: "28 Mai 2026",
    tag: "Cultura",
    title: "Por que a parada do café faz parte do roteiro",
    excerpt:
      "Mais do que combustível, o café é o pretexto pra conversa, pra rever a rota e pra deixar a estrada esperar mais um pouco.",
  },
  {
    img: n3,
    date: "12 Mai 2026",
    tag: "Bastidores",
    title: "Pedra Bela ao nascer do sol: como foi o último rolê",
    excerpt:
      "Acordamos antes do galo cantar pra pegar o nascer do sol no mirante. O frio compensou — e as fotos também.",
  },
];

export function Noticias() {
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
                <a
                  href="#noticias"
                  className="inline-flex items-center gap-2 text-copper text-sm uppercase tracking-[0.2em] font-semibold group-hover:gap-3 transition-all"
                  style={{ fontFamily: "var(--font-display)" }}
                >
                  Saiba mais <ArrowRight className="h-4 w-4" />
                </a>
              </div>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}