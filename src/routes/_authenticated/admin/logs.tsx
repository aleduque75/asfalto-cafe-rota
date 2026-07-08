import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";

export const Route = createFileRoute("/_authenticated/admin/logs")({
  component: AdminLogsPage,
});

function formatActionType(action: string) {
  const map: Record<string, string> = {
    "MOTORCYCLES_INSERT": "Adicionou uma Moto",
    "MOTORCYCLES_UPDATE": "Editou uma Moto",
    "MOTORCYCLES_DELETE": "Excluiu uma Moto",
    "ROUTES_INSERT": "Criou uma Rota",
    "ROUTES_UPDATE": "Editou uma Rota",
    "ROUTES_DELETE": "Excluiu uma Rota",
    "PROFILES_INSERT": "Criou um Perfil",
    "PROFILES_UPDATE": "Editou o Perfil",
    "PROFILES_DELETE": "Excluiu um Perfil",
    "MAINTENANCE_RECORDS_INSERT": "Registrou uma Manutenção",
    "MAINTENANCE_RECORDS_UPDATE": "Editou uma Manutenção",
    "MAINTENANCE_RECORDS_DELETE": "Excluiu uma Manutenção",
    "MAINTENANCE_ITEMS_INSERT": "Criou um Item de Manutenção",
    "MAINTENANCE_ITEMS_UPDATE": "Editou um Item de Manutenção",
    "MAINTENANCE_ITEMS_DELETE": "Excluiu um Item de Manutenção",
  };
  return map[action] || action;
}

function formatDetails(details: any) {
  if (!details) return "-";
  
  // Os detalhes podem vir em new_data (inserts/updates) ou old_data (deletes)
  const data = details.new_data || details.old_data || details;
  
  // Tentar encontrar um nome ou título legível na carga de dados
  const identifier = 
    data.item_name || // Manutenção
    data.title || // Rotas e Notícias
    data.full_name || // Perfis
    (data.brand && data.model ? `${data.brand} ${data.model}` : null) || // Motos
    data.plate || 
    data.name; // Itens

  if (identifier) {
    return <span className="font-medium">{identifier}</span>;
  }

  return <span className="text-leather/50 italic text-xs">Registro interno</span>;
}

function AdminLogsPage() {
  const { data: logs, isLoading } = useQuery({
    queryKey: ["admin-activity-logs"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("activity_logs")
        .select(`
          id,
          action_type,
          entity_id,
          created_at,
          details,
          profiles:user_id ( full_name )
        `)
        .order("created_at", { ascending: false })
        .limit(100);

      if (error) throw error;
      return data;
    },
  });

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-display text-coffee" style={{ fontFamily: "var(--font-display)" }}>
          Logs do Sistema
        </h1>
      </div>

      <Card className="border-leather/20 shadow-sm bg-cream">
        <CardHeader className="bg-cream border-b border-leather/10">
          <CardTitle className="text-xl text-coffee font-display">Histórico de Atividades</CardTitle>
          <CardDescription>
            Últimas 100 ações registradas na plataforma.
          </CardDescription>
        </CardHeader>
        <CardContent className="p-0">
          {isLoading ? (
            <div className="p-8 text-center text-leather">Carregando logs...</div>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Data e Hora</TableHead>
                  <TableHead>Usuário</TableHead>
                  <TableHead>Ação</TableHead>
                  <TableHead>Detalhes</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {logs?.map((log) => (
                  <TableRow key={log.id}>
                    <TableCell className="whitespace-nowrap">
                      {format(new Date(log.created_at), "dd/MM/yyyy HH:mm", { locale: ptBR })}
                    </TableCell>
                    <TableCell className="font-medium">
                      {/* @ts-ignore */}
                      {log.profiles?.full_name || "Sistema"}
                    </TableCell>
                    <TableCell className="whitespace-nowrap">
                      <span className="px-2 py-1 rounded text-xs font-semibold bg-coffee/10 text-coffee border border-coffee/20">
                        {formatActionType(log.action_type)}
                      </span>
                    </TableCell>
                    <TableCell className="max-w-[400px] truncate text-sm text-leather">
                      {formatDetails(log.details)}
                    </TableCell>
                  </TableRow>
                ))}
                {!logs?.length && (
                  <TableRow>
                    <TableCell colSpan={5} className="text-center py-8 text-leather/60">
                      Nenhum log encontrado.
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
