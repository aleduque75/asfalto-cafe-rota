import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import React, { useEffect, useState, useMemo } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { ArrowLeft, Printer, FileText, Bike, Calendar, PieChart } from "lucide-react";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/garagem_/$id/relatorio")({
  head: () => ({ meta: [{ title: "Relatório de Despesas — Café Moto e Asfalto" }] }),
  component: RelatorioFinanceiro,
});

type Moto = {
  id: string; brand: string; model: string; nickname: string | null;
  photo_url: string | null;
};

type Item = {
  id: string; name: string;
};

type Record_ = {
  id: string; maintenance_item_id: string | null; service_date: string; 
  item_name: string; cost: number | null;
};

function RelatorioFinanceiro() {
  const { id } = Route.useParams();
  const navigate = useNavigate();
  const [moto, setMoto] = useState<Moto | null>(null);
  const [items, setItems] = useState<Item[]>([]);
  const [records, setRecords] = useState<Record_[]>([]);
  const [loading, setLoading] = useState(true);
  const [period, setPeriod] = useState<"mensal" | "trimestral" | "semestral" | "anual" | "todos">("todos");

  useEffect(() => {
    async function loadData() {
      const [{ data: m }, { data: it }, { data: rc }] = await Promise.all([
        supabase.from("motorcycles").select("id, brand, model, nickname, photo_url").eq("id", id).maybeSingle(),
        supabase.from("maintenance_items").select("id, name").eq("motorcycle_id", id),
        supabase.from("maintenance_records").select("id, maintenance_item_id, service_date, item_name, cost").eq("motorcycle_id", id).order("service_date", { ascending: false }),
      ]);
      if (!m) { toast.error("Moto não encontrada"); navigate({ to: "/garagem" }); return; }
      setMoto(m as Moto);
      setItems((it ?? []) as Item[]);
      setRecords((rc ?? []) as Record_[]);
      setLoading(false);
    }
    loadData();
  }, [id, navigate]);

  const itemsMap = useMemo(() => {
    const map = new Map<string, string>();
    items.forEach(i => map.set(i.id, i.name));
    return map;
  }, [items]);

  const filteredRecords = useMemo(() => {
    const now = new Date();
    return records.filter(r => {
      if (period === "todos") return true;
      const recordDate = new Date(r.service_date);
      const diffTime = Math.abs(now.getTime() - recordDate.getTime());
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
      
      if (period === "mensal") return diffDays <= 30;
      if (period === "trimestral") return diffDays <= 90;
      if (period === "semestral") return diffDays <= 180;
      if (period === "anual") return diffDays <= 365;
      return true;
    });
  }, [records, period]);

  const groupedRecords = useMemo(() => {
    const groups: Record<string, { total: number; records: Record_[] }> = {};
    
    filteredRecords.forEach(r => {
      const cost = Number(r.cost || 0);
      if (cost <= 0) return; // ignorar manutenções sem custo registrado
      
      const categoryName = r.maintenance_item_id && itemsMap.has(r.maintenance_item_id)
        ? itemsMap.get(r.maintenance_item_id)!
        : "Avulso / Sem categoria";
        
      if (!groups[categoryName]) {
        groups[categoryName] = { total: 0, records: [] };
      }
      
      groups[categoryName].total += cost;
      groups[categoryName].records.push(r);
    });

    // Ordenar do maior para o menor custo total
    return Object.entries(groups).sort((a, b) => b[1].total - a[1].total);
  }, [filteredRecords, itemsMap]);

  const totalCost = groupedRecords.reduce((sum, [_, data]) => sum + data.total, 0);

  if (loading || !moto) return <p className="text-leather p-8 text-center">Carregando relatório...</p>;

  return (
    <div className="max-w-4xl mx-auto w-full pb-20 print:pb-0 print:p-0 print:max-w-none print:bg-white">
      {/* Botões de Ação - Não aparecem na impressão */}
      <div className="flex justify-between items-center mb-6 print:hidden">
        <Button 
          variant="ghost" 
          className="text-leather hover:text-copper hover:bg-transparent -ml-3"
          onClick={() => navigate({ to: `/garagem/${id}` })}
        >
          <ArrowLeft className="h-4 w-4 mr-2" /> Voltar para Moto
        </Button>
        <Button onClick={() => window.print()} className="btn-copper">
          <Printer className="h-4 w-4 mr-2" /> Imprimir PDF
        </Button>
      </div>

      <div className="bg-cream border border-leather/20 rounded-xl p-8 print:border-none print:p-0 print:bg-white shadow-sm print:shadow-none">
        {/* Cabeçalho do Relatório */}
        <div className="flex items-center gap-6 pb-6 border-b border-leather/20 print:border-leather/40 mb-8">
          <div className="w-20 h-20 bg-leather/10 rounded-full flex items-center justify-center overflow-hidden shrink-0 print:hidden border border-leather/20">
            {moto.photo_url ? (
              <img src={moto.photo_url} alt={moto.model} className="w-full h-full object-cover" />
            ) : (
              <Bike className="h-10 w-10 text-copper/60" />
            )}
          </div>
          <div>
            <h1 className="font-display text-3xl text-coffee m-0" style={{ fontFamily: "var(--font-display)" }}>
              Relatório de Despesas
            </h1>
            <p className="text-leather mt-1 text-lg">
              {moto.nickname || moto.model} <span className="opacity-60 text-sm ml-2">{moto.brand}</span>
            </p>
          </div>
        </div>

        {/* Filtros - Não aparecem na impressão */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-8 print:hidden">
          <div className="flex items-center gap-2 text-coffee font-medium">
            <Calendar className="w-5 h-5 text-copper" /> 
            <span>Período do Relatório:</span>
          </div>
          <Select value={period} onValueChange={(val: any) => setPeriod(val)}>
            <SelectTrigger className="w-[220px] bg-white border-leather/30">
              <SelectValue placeholder="Selecione o período" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="mensal">Últimos 30 dias (Mensal)</SelectItem>
              <SelectItem value="trimestral">Últimos 90 dias (Trimestral)</SelectItem>
              <SelectItem value="semestral">Últimos 180 dias (Semestral)</SelectItem>
              <SelectItem value="anual">Últimos 365 dias (Anual)</SelectItem>
              <SelectItem value="todos">Todo o período</SelectItem>
            </SelectContent>
          </Select>
        </div>

        {/* Resumo Impressão (Só aparece no PDF) */}
        <div className="hidden print:block mb-6 text-sm text-leather">
          <strong>Período filtrado:</strong> {
            period === 'mensal' ? 'Últimos 30 dias' :
            period === 'trimestral' ? 'Últimos 90 dias' :
            period === 'semestral' ? 'Últimos 180 dias' :
            period === 'anual' ? 'Últimos 365 dias' : 'Todo o período'
          }
          <br />
          <strong>Data de emissão:</strong> {new Date().toLocaleDateString('pt-BR')} às {new Date().toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })}
        </div>

        {/* Conteúdo */}
        {groupedRecords.length === 0 ? (
          <div className="text-center py-16 bg-white rounded-lg border border-leather/10 print:border-none">
            <PieChart className="w-12 h-12 text-leather/30 mx-auto mb-3" />
            <p className="text-leather text-lg">Nenhuma despesa registrada para o período selecionado.</p>
          </div>
        ) : (
          <div className="space-y-8">
            <div className="bg-white rounded-lg border border-leather/20 overflow-x-auto print:overflow-visible print:border-leather/40">
              <table className="w-full text-left text-sm">
                <thead className="bg-leather/5 print:bg-transparent border-b border-leather/20 print:border-leather/40">
                  <tr>
                    <th className="py-3 px-3 sm:py-4 sm:px-6 font-semibold text-coffee uppercase tracking-wider text-xs">Data / Serviço</th>
                    <th className="py-3 px-3 sm:py-4 sm:px-6 font-semibold text-coffee uppercase tracking-wider text-xs text-right w-[120px] sm:w-[150px]">Custo (R$)</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-leather/10 print:divide-leather/30">
                  {groupedRecords.map(([category, data]) => (
                    <React.Fragment key={category}>
                      {/* Cabeçalho da Categoria */}
                      <tr className="bg-leather/5 print:bg-transparent">
                        <td colSpan={2} className="py-2 px-3 sm:py-3 sm:px-6 font-display font-semibold text-coffee uppercase tracking-wide border-b border-leather/20 print:border-leather/40 bg-[#F0EBE1] print:bg-transparent text-xs sm:text-sm" style={{ fontFamily: "var(--font-display)" }}>
                          {category}
                        </td>
                      </tr>
                      {/* Itens da Categoria */}
                      {data.records.map((record) => (
                        <tr key={record.id} className="hover:bg-leather/5 print:hover:bg-transparent">
                          <td className="py-2 px-3 sm:py-3 sm:px-6 text-leather">
                            <div className="flex flex-col sm:flex-row sm:items-center gap-0.5 sm:gap-4">
                              <span className="font-medium text-coffee text-[11px] sm:text-sm tabular-nums shrink-0">
                                {new Date(record.service_date).toLocaleDateString('pt-BR')}
                              </span>
                              <span className="text-xs sm:text-sm line-clamp-2 sm:line-clamp-1">{record.item_name}</span>
                            </div>
                          </td>
                          <td className="py-2 px-3 sm:py-3 sm:px-6 text-coffee text-right whitespace-nowrap tabular-nums text-xs sm:text-sm font-medium">
                            R$ {Number(record.cost || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                          </td>
                        </tr>
                      ))}
                      {/* Subtotal da Categoria */}
                      <tr className="border-b-2 border-leather/20 print:border-leather/40 bg-leather/5 print:bg-transparent">
                        <td className="py-2 px-3 sm:py-2 sm:px-6 text-right font-medium text-leather text-[10px] sm:text-xs uppercase tracking-wider">
                          Subtotal {category}:
                        </td>
                        <td className="py-2 px-3 sm:py-2 sm:px-6 text-right font-semibold text-copper tabular-nums text-xs sm:text-sm">
                          R$ {data.total.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                        </td>
                      </tr>
                    </React.Fragment>
                  ))}
                </tbody>
                <tfoot className="bg-copper/5 print:bg-transparent border-t-4 border-copper/30 print:border-leather/60">
                  <tr>
                    <td className="py-4 px-3 sm:py-5 sm:px-6 font-display text-lg sm:text-xl text-coffee font-bold" style={{ fontFamily: "var(--font-display)" }}>
                      Total Geral
                    </td>
                    <td className="py-4 px-3 sm:py-5 sm:px-6 text-base sm:text-xl text-copper font-bold text-right whitespace-nowrap">
                      R$ {totalCost.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                    </td>
                  </tr>
                </tfoot>
              </table>
            </div>
            
            <div className="text-center text-xs text-leather/60 mt-12 print:block">
              Gerado por Café Moto e Asfalto — Plataforma de Gestão de Motocicletas
            </div>
          </div>
        )}
      </div>

      <style dangerouslySetInnerHTML={{__html: `
        @media print {
          /* Oculta completamente a Sidebar, navegação, botões e rodapé mobile durante a impressão */
          aside, nav, header, button, .fixed.bottom-0 {
            display: none !important;
          }
          
          /* Garante que o fundo seja branco para economizar tinta e melhorar legibilidade */
          body, html, #root, main {
            background-color: white !important;
            height: auto !important;
            overflow: visible !important;
          }

          /* Remove restrições de altura/scroll que podem cortar o conteúdo no PDF */
          * {
            overflow: visible !important;
          }

          .print\\:hidden {
            display: none !important;
          }
          .print\\:block {
            display: block !important;
          }
          .print\\:bg-transparent {
            background-color: transparent !important;
          }
          .print\\:border-none {
            border: none !important;
          }
          .print\\:border-leather\\/40 {
            border-color: rgba(94, 76, 60, 0.4) !important;
          }
          .print\\:border-leather\\/60 {
            border-color: rgba(94, 76, 60, 0.6) !important;
          }
          .print\\:shadow-none {
            box-shadow: none !important;
          }
          
          /* Ajusta layout do conteúdo principal */
          main {
            margin: 0 !important;
            padding: 0 !important;
            width: 100% !important;
            max-width: none !important;
          }
        }
      `}} />
    </div>
  );
}
