import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from "@/components/ui/table";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import { Loader2, ShieldAlert, ShieldCheck, UserX, UserCheck, Trash2 } from "lucide-react";
import type { Database } from "@/integrations/supabase/types";

type AppRole = Database["public"]["Enums"]["app_role"];

type AdminUser = {
  id: string;
  email: string;
  full_name: string | null;
  banned_until: string | null;
  created_at: string;
  role: AppRole | null;
  member_type?: string | null;
  partner_id?: string | null;
  partner_name?: string | null;
};

export const Route = createFileRoute("/_authenticated/admin/usuarios")({
  component: AdminUsuarios,
});

function AdminUsuarios() {
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [loading, setLoading] = useState(true);
  const [processingId, setProcessingId] = useState<string | null>(null);

  async function load() {
    setLoading(true);
    const { data, error } = await supabase.rpc("get_users_for_admin");
    setLoading(false);
    
    if (error) {
      return toast.error("Erro ao carregar usuários: " + error.message);
    }
    
    // Fetch profiles to get member_type and partner details without changing the RPC
    const { data: profilesData } = await supabase
      .from("profiles")
      .select("id, member_type, partner_id, full_name, nickname");

    let mergedData = data || [];
    
    if (profilesData) {
      mergedData = mergedData.map((u: any) => {
        const p = profilesData.find(prof => prof.id === u.id);
        let partnerName = null;
        if (p?.partner_id) {
          const partner = profilesData.find(prof => prof.id === p.partner_id);
          partnerName = partner?.full_name || partner?.nickname || "Sem nome";
        }
        return {
          ...u,
          member_type: p?.member_type,
          partner_id: p?.partner_id,
          partner_name: partnerName
        };
      });
    }
    
    setUsers(mergedData);
  }

  useEffect(() => {
    load();
  }, []);

  async function toggleBan(user: AdminUser) {
    const isBanned = !!user.banned_until;
    const action = isBanned ? "habilitar" : "desabilitar (banir)";
    if (!confirm(`Tem certeza que deseja ${action} o acesso de ${user.full_name || user.email}?`)) return;

    setProcessingId(user.id);
    const { error } = await supabase.rpc("toggle_user_ban", {
      target_user_id: user.id,
      ban: !isBanned,
    });
    setProcessingId(null);

    if (error) {
      toast.error(error.message);
    } else {
      toast.success(`Acesso ${isBanned ? "restaurado" : "bloqueado"} com sucesso.`);
      load();
    }
  }

  async function changeRole(user: AdminUser, newRole: AppRole) {
    if (user.role === newRole) return;
    
    setProcessingId(user.id);
    const { error } = await supabase.rpc("set_user_role", {
      target_user_id: user.id,
      new_role: newRole,
    });
    setProcessingId(null);

    if (error) {
      toast.error(error.message);
      load(); // revert select UI
    } else {
      toast.success(`Cargo de ${user.full_name || user.email} alterado para ${newRole === 'blog_admin' ? 'Membro Blog' : newRole}.`);
      load();
    }
  }

  async function deleteUser(user: AdminUser) {
    if (!confirm(`CUIDADO: Tem certeza que deseja APAGAR COMPLETAMENTE a conta de ${user.full_name || user.email}?\n\nIsso irá excluir também o perfil, as motos e todo o histórico deste usuário. Essa ação não pode ser desfeita.`)) return;
    if (!confirm(`ÚLTIMO AVISO: Confirma a exclusão de ${user.full_name || user.email}?`)) return;

    setProcessingId(user.id);
    const { error } = await supabase.rpc("delete_user_completely", {
      target_user_id: user.id,
    });
    setProcessingId(null);

    if (error) {
      toast.error(error.message);
    } else {
      toast.success(`Usuário ${user.full_name || user.email} excluído permanentemente.`);
      load();
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-end justify-between gap-4 flex-wrap">
        <div>
          <h1 className="text-3xl md:text-4xl font-display text-coffee" style={{ fontFamily: "var(--font-display)" }}>
            Gerenciamento de Usuários
          </h1>
          <p className="text-leather/70 mt-1">
            Controle de acesso, permissões de administrador e status de contas.
          </p>
        </div>
      </div>

      <div className="border border-leather/30 rounded-lg bg-cream shadow-sm overflow-x-auto">
        {loading ? (
          <div className="p-8 text-center text-leather/70">
            <Loader2 className="h-5 w-5 animate-spin inline mr-2" /> Carregando usuários...
          </div>
        ) : users.length === 0 ? (
          <div className="p-8 text-center text-leather/70">
            Nenhum usuário encontrado.
          </div>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Usuário</TableHead>
                <TableHead>Perfil / Vínculo</TableHead>
                <TableHead>Data de Cadastro</TableHead>
                <TableHead>Cargo (Permissão)</TableHead>
                <TableHead>Status de Acesso</TableHead>
                <TableHead className="text-right">Ação</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {users.map((user) => {
                const isBanned = !!user.banned_until;
                const isProcessing = processingId === user.id;
                
                return (
                  <TableRow key={user.id}>
                    <TableCell className="font-medium min-w-[200px]">
                      <div className="flex flex-col gap-0.5">
                        <span className="truncate">{user.full_name || "Sem Nome"}</span>
                        <span className="text-xs text-leather truncate opacity-80">{user.email}</span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex flex-col gap-0.5">
                        <span className="capitalize text-sm font-medium text-coffee">
                          {user.member_type || "Piloto"}
                        </span>
                        {user.partner_id && (
                          <span className="text-xs text-leather truncate opacity-80">
                            Parceiro(a): {user.partner_name}
                          </span>
                        )}
                      </div>
                    </TableCell>
                    <TableCell className="text-leather text-sm">
                      {new Date(user.created_at).toLocaleDateString("pt-BR")}
                    </TableCell>
                    <TableCell>
                      <Select 
                        value={user.role || "member"} 
                        onValueChange={(val: AppRole) => changeRole(user, val)}
                        disabled={isProcessing}
                      >
                        <SelectTrigger className="w-[140px] h-8 text-xs text-coffee bg-white/60 hover:bg-white">
                          <SelectValue placeholder="Selecione o cargo..." />
                        </SelectTrigger>
                        <SelectContent className="bg-white text-coffee border-leather/20">
                          <SelectItem value="member" className="focus:bg-copper/20 focus:text-coffee cursor-pointer">Membro Comum</SelectItem>
                          <SelectItem value="admin" className="focus:bg-copper/20 focus:text-coffee cursor-pointer">Administrador</SelectItem>
                          <SelectItem value="blog_admin" className="focus:bg-copper/20 focus:text-coffee cursor-pointer">Membro Blog</SelectItem>
                        </SelectContent>
                      </Select>
                    </TableCell>
                    <TableCell>
                      {isBanned ? (
                        <Badge variant="destructive" className="flex w-fit items-center gap-1 bg-red-600 text-xs">
                          <ShieldAlert className="h-3 w-3" /> Bloqueado
                        </Badge>
                      ) : (
                        <Badge variant="outline" className="flex w-fit items-center gap-1 border-emerald-600 text-emerald-700 text-xs">
                          <ShieldCheck className="h-3 w-3" /> Ativo
                        </Badge>
                      )}
                    </TableCell>
                    <TableCell className="text-right space-x-2 whitespace-nowrap">
                      {isBanned ? (
                        <Button 
                          size="sm" 
                          variant="outline" 
                          onClick={() => toggleBan(user)} 
                          disabled={isProcessing}
                          className="border-emerald-600 text-emerald-700 hover:bg-emerald-50 h-8"
                        >
                          <UserCheck className="h-4 w-4 mr-1.5" /> Habilitar
                        </Button>
                      ) : (
                        <Button 
                          size="sm" 
                          variant="outline" 
                          onClick={() => toggleBan(user)} 
                          disabled={isProcessing}
                          className="border-red-600 text-red-600 hover:bg-red-50 h-8"
                        >
                          <UserX className="h-4 w-4 mr-1.5" /> Desabilitar
                        </Button>
                      )}
                      <Button
                        size="sm"
                        variant="destructive"
                        onClick={() => deleteUser(user)}
                        disabled={isProcessing}
                        className="h-8 px-2"
                        title="Excluir usuário"
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
          </Table>
        )}
      </div>
    </div>
  );
}
