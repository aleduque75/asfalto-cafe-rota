import { useEffect, useState } from "react";
import { Menu, X } from "lucide-react";
import logo from "@/assets/logo-badge.png";
import { cn } from "@/lib/utils";

const links = [
  { href: "#inicio", label: "Início" },
  { href: "#moto-clube", label: "Moto Clube" },
  { href: "#galeria", label: "Galeria" },
  { href: "#noticias", label: "Notícias" },
  { href: "#contato", label: "Contato" },
];

export function Navbar({ logoUrl }: { logoUrl?: string }) {
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 30);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  return (
    <header
      className={cn(
        "fixed top-0 inset-x-0 z-50 transition-all duration-300",
        scrolled
          ? "bg-coffee/85 backdrop-blur-md border-b border-border/60 shadow-[0_8px_30px_-12px_rgba(0,0,0,0.6)]"
          : "bg-transparent"
      )}
      style={scrolled ? { backgroundColor: "color-mix(in oklab, var(--coffee) 85%, transparent)" } : undefined}
    >
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="flex h-16 md:h-20 items-center justify-between">
          <a href="#inicio" className="flex items-center gap-3 group">
            <img
              src={logoUrl || logo}
              alt="Café Moto e Asfalto"
              width={48}
              height={48}
              className="h-10 w-10 md:h-12 md:w-12 object-contain transition-transform group-hover:scale-105"
            />
            <div className="flex flex-col leading-none">
              <span className="eyebrow text-[10px]">Moto Clube</span>
              <span className="font-display text-base md:text-lg tracking-wide text-cream" style={{ fontFamily: "var(--font-display)" }}>
                Café Moto e Asfalto
              </span>
            </div>
          </a>

          <nav className="hidden lg:flex items-center gap-1">
            {links.map((l) => (
              <a
                key={l.href}
                href={l.href}
                className="px-4 py-2 text-sm uppercase tracking-[0.18em] text-cream/80 hover:text-copper transition-colors"
                style={{ fontFamily: "var(--font-display)" }}
              >
                {l.label}
              </a>
            ))}
            <a
              href="/auth"
              className="btn-copper ml-3 inline-flex items-center justify-center rounded-md px-5 py-2.5 text-sm uppercase tracking-[0.18em] font-semibold"
              style={{ fontFamily: "var(--font-display)" }}
            >
              Área do Membro
            </a>
          </nav>

          <button
            type="button"
            onClick={() => setOpen((v) => !v)}
            className="lg:hidden inline-flex items-center justify-center rounded-md p-2 text-cream hover:bg-leather/50"
            aria-label="Abrir menu"
          >
            {open ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
          </button>
        </div>
      </div>

      {open && (
        <div className="lg:hidden border-t border-border/60" style={{ backgroundColor: "var(--coffee)" }}>
          <nav className="px-4 py-4 flex flex-col gap-1">
            {links.map((l) => (
              <a
                key={l.href}
                href={l.href}
                onClick={() => setOpen(false)}
                className="px-3 py-3 text-sm uppercase tracking-[0.2em] text-cream/90 hover:text-copper border-b border-border/40 last:border-0"
                style={{ fontFamily: "var(--font-display)" }}
              >
                {l.label}
              </a>
            ))}
            <a
              href="/auth"
              onClick={() => setOpen(false)}
              className="btn-copper mt-3 inline-flex items-center justify-center rounded-md px-5 py-3 text-sm uppercase tracking-[0.18em] font-semibold"
              style={{ fontFamily: "var(--font-display)" }}
            >
              Área do Membro
            </a>
          </nav>
        </div>
      )}
    </header>
  );
}