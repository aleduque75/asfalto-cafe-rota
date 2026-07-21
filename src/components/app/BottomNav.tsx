import { Link, useLocation } from "@tanstack/react-router";
import { Bike, Map, ImageIcon, LayoutDashboard } from "lucide-react";

export function BottomNav() {
  const location = useLocation();
  const currentPath = location.pathname;

  return (
    <div className="md:hidden fixed bottom-0 left-0 right-0 h-16 bg-coffee border-t border-leather/20 z-50 flex items-center justify-around px-2 shadow-[0_-4px_10px_rgba(0,0,0,0.2)] print:hidden">
      <Link 
        to="/dashboard" 
        className={`flex flex-col items-center justify-center w-full h-full space-y-1 transition-colors ${currentPath === '/dashboard' ? 'text-copper' : 'text-cream/70 hover:text-cream'}`}
      >
        <LayoutDashboard className="h-5 w-5" />
        <span className="text-[10px] font-display uppercase tracking-wider" style={{ fontFamily: "var(--font-display)" }}>Início</span>
      </Link>

      <Link 
        to="/garagem" 
        className={`flex flex-col items-center justify-center w-full h-full space-y-1 transition-colors ${currentPath.startsWith('/garagem') ? 'text-copper' : 'text-cream/70 hover:text-cream'}`}
      >
        <Bike className="h-5 w-5" />
        <span className="text-[10px] font-display uppercase tracking-wider" style={{ fontFamily: "var(--font-display)" }}>Garagem</span>
      </Link>
      
      <Link 
        to="/rotas" 
        className={`flex flex-col items-center justify-center w-full h-full space-y-1 transition-colors ${currentPath.startsWith('/rotas') ? 'text-copper' : 'text-cream/70 hover:text-cream'}`}
      >
        <Map className="h-5 w-5" />
        <span className="text-[10px] font-display uppercase tracking-wider" style={{ fontFamily: "var(--font-display)" }}>Rotas</span>
      </Link>

      <Link 
        to="/galerias" 
        className={`flex flex-col items-center justify-center w-full h-full space-y-1 transition-colors ${currentPath.startsWith('/galeria') ? 'text-copper' : 'text-cream/70 hover:text-cream'}`}
      >
        <ImageIcon className="h-5 w-5" />
        <span className="text-[10px] font-display uppercase tracking-wider" style={{ fontFamily: "var(--font-display)" }}>Galeria</span>
      </Link>
    </div>
  );
}
