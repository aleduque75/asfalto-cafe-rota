import { Instagram } from "lucide-react";
import logo from "@/assets/logo-badge.png";

export function Footer() {
  return (
    <footer className="border-t border-border/60 py-12" style={{ backgroundColor: "var(--coffee)" }}>
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-3">
            <img src={logo} alt="" width={48} height={48} className="h-12 w-12 rounded-full ring-2 ring-copper/40" />
            <div className="leading-tight">
              <p className="text-cream uppercase tracking-wider" style={{ fontFamily: "var(--font-display)" }}>
                Café Moto e Asfalto
              </p>
              <p className="text-cream/60 text-xs uppercase tracking-[0.28em]" style={{ fontFamily: "var(--font-display)" }}>
                Atibaia · SP · 2024
              </p>
            </div>
          </div>

          <div className="flex items-center gap-6 text-cream/60 text-xs uppercase tracking-[0.28em]" style={{ fontFamily: "var(--font-display)" }}>
            <span>Respeito</span>
            <span className="text-copper">·</span>
            <span>Liberdade</span>
            <span className="text-copper">·</span>
            <span>Estrada</span>
          </div>

          <a
            href="https://www.instagram.com/cafe_moto_asfalto"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 text-cream/80 hover:text-copper transition text-sm"
          >
            <Instagram className="h-4 w-4" /> @cafe_moto_asfalto
          </a>
        </div>

        <p className="mt-8 text-center text-cream/40 text-xs">
          © {new Date().getFullYear()} Café Moto e Asfalto. Todos os direitos reservados.
        </p>
      </div>
    </footer>
  );
}