import heroRoad from "@/assets/hero-road.jpg";
import logo from "@/assets/logo-badge.png";

export function Hero() {
  return (
    <section id="inicio" className="relative min-h-screen w-full overflow-hidden">
      <img
        src={heroRoad}
        alt="Estrada de montanha ao pôr do sol no interior de SP"
        width={1920}
        height={1280}
        className="absolute inset-0 h-full w-full object-cover"
      />
      {/* Warm overlay */}
      <div
        className="absolute inset-0"
        style={{ background: "var(--gradient-hero)" }}
      />
      {/* Grain */}
      <div
        className="absolute inset-0 opacity-[0.08] mix-blend-overlay pointer-events-none"
        style={{
          backgroundImage:
            "url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='160' height='160'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='0.9'/></filter><rect width='100%' height='100%' filter='url(%23n)' opacity='0.6'/></svg>\")",
        }}
      />

      <div className="relative z-10 flex min-h-screen flex-col items-center justify-center px-4 pt-24 pb-16 text-center">
        <div className="mb-8 relative">
          <div className="absolute inset-0 rounded-full blur-2xl bg-copper/30" />
          <img
            src={logo}
            alt="Brasão Café Moto e Asfalto"
            width={1024}
            height={1024}
            className="relative h-44 w-44 sm:h-56 sm:w-56 md:h-72 md:w-72 rounded-full ring-4 ring-copper/40 shadow-[0_30px_80px_-20px_rgba(0,0,0,0.7)]"
          />
        </div>

        <p className="eyebrow mb-4">Atibaia · SP · Desde 2024</p>
        <h1
          className="text-cream text-5xl sm:text-6xl md:text-7xl lg:text-8xl font-bold uppercase leading-[0.95] max-w-5xl"
          style={{ fontFamily: "var(--font-display)" }}
        >
          Café quente.
          <br />
          <span className="text-copper">Asfalto livre.</span>
        </h1>
        <p className="mt-6 max-w-2xl text-base md:text-lg text-cream/85 font-serif italic" style={{ fontFamily: "var(--font-serif)" }}>
          "O primeiro de muitos quilômetros juntos." Um grupo de amigos, algumas motos
          e uma vontade enorme de pegar a estrada.
        </p>

        <div className="mt-10 flex flex-wrap items-center justify-center gap-3">
          <a
            href="#moto-clube"
            className="btn-copper inline-flex items-center justify-center rounded-md px-7 py-3.5 text-sm md:text-base uppercase tracking-[0.18em] font-semibold"
            style={{ fontFamily: "var(--font-display)" }}
          >
            Conheça o clube
          </a>
          <a
            href="#galeria"
            className="inline-flex items-center justify-center rounded-md border border-copper/50 px-7 py-3.5 text-sm md:text-base uppercase tracking-[0.18em] font-semibold text-cream hover:bg-copper/10 transition"
            style={{ fontFamily: "var(--font-display)" }}
          >
            Ver galeria
          </a>
        </div>

        <div className="mt-14 flex items-center gap-6 text-cream/70 text-xs uppercase tracking-[0.32em]" style={{ fontFamily: "var(--font-display)" }}>
          <span>Respeito</span>
          <span className="text-copper">·</span>
          <span>Liberdade</span>
          <span className="text-copper">·</span>
          <span>Estrada</span>
        </div>
      </div>
    </section>
  );
}