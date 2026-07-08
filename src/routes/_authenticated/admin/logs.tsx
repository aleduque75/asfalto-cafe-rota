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
                  <TableHead>ID da Entidade</TableHead>
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
                    <TableCell>
                      <span className="px-2 py-1 rounded text-xs font-semibold bg-coffee/10 text-coffee border border-coffee/20">
                        {log.action_type}
                      </span>
                    </TableCell>
                    <TableCell className="text-xs font-mono text-leather/70">
                      {log.entity_id || "-"}
                    </TableCell>
                    <TableCell className="max-w-[300px] truncate text-xs text-leather">
                      {log.details ? JSON.stringify(log.details) : "-"}
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
