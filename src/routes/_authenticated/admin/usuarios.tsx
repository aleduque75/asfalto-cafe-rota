import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import { 
  Loader2, ShieldAlert, ShieldCheck, UserX, UserCheck, 
  Trash2, MoreVertical, Pencil, LayoutGrid, List as ListIcon, Search
} from "lucide-react";
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from "@/components/ui/table";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle, CardFooter } from "@/components/ui/card";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
  DropdownMenuSeparator,
} from "@/components/ui/dropdown-menu";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogDescription
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
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
  const [profilesList, setProfilesList] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [processingId, setProcessingId] = useState<string | null>(null);
  const [viewMode, setViewMode] = useState<"card" | "list">("card");
  const [search, setSearch] = useState("");

  // Edit Modal State
  const [editingUser, setEditingUser] = useState<AdminUser | null>(null);
  const [editMemberType, setEditMemberType] = useState<string>("piloto");
  const [editPartnerId, setEditPartnerId] = useState<string>("none");

  async function load() {
    setLoading(true);
    const { data, error } = await supabase.rpc("get_users_for_admin");
    
    if (error) {
      setLoading(false);
      return toast.error("Erro ao carregar usuários: " + error.message);
    }
    
    const { data: profilesData } = await supabase
      .from("profiles")
      .select("id, member_type, partner_id, full_name, nickname")
      .order("full_name");
      
    setProfilesList(profilesData || []);

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
    setLoading(false);
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
      toast.success(`Cargo de ${user.full_name || user.email} alterado.`);
      load();
    }
  }

  async function deleteUser(user: AdminUser) {
    if (!confirm(`CUIDADO: Tem certeza que deseja APAGAR COMPLETAMENTE a conta de ${user.full_name || user.email}?\n\nIsso não pode ser desfeito.`)) return;

    setProcessingId(user.id);
    const { error } = await supabase.rpc("delete_user_completely", {
      target_user_id: user.id,
    });
    setProcessingId(null);

    if (error) {
      toast.error(error.message);
    } else {
      toast.success(`Usuário excluído permanentemente.`);
      load();
    }
  }

  function openEdit(user: AdminUser) {
    setEditingUser(user);
    setEditMemberType(user.member_type || "piloto");
    setEditPartnerId(user.partner_id || "none");
  }

  async function saveEdit() {
    if (!editingUser) return;
    setProcessingId(editingUser.id);
    const { error } = await (supabase.rpc as any)("admin_update_profile", {
      target_user_id: editingUser.id,
      new_member_type: editMemberType,
      new_partner_id: editPartnerId === "none" ? null : editPartnerId,
    });
    setProcessingId(null);

    if (error) {
      toast.error("Erro ao salvar perfil: " + error.message);
    } else {
      toast.success("Perfil atualizado com sucesso!");
      setEditingUser(null);
      load();
    }
  }

  const filteredUsers = users.filter(u => {
    if (!search) return true;
    const q = search.toLowerCase();
    return (u.full_name?.toLowerCase().includes(q) || u.email.toLowerCase().includes(q));
  });

  return (
    <div className="space-y-6 pb-12">
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div className="flex flex-col gap-2">
          <h1 className="text-3xl md:text-4xl font-display text-coffee" style={{ fontFamily: "var(--font-display)" }}>
            Gerenciamento de Usuários
          </h1>
          <p className="text-leather/70">
            Controle de acesso, permissões de administrador e status de contas.
          </p>
        </div>
        
        <div className="flex flex-col sm:flex-row gap-3 items-end">
          <div className="relative">
            <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-leather/60" />
            <Input 
              placeholder="Buscar usuário..." 
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="pl-9 w-full sm:w-[250px] bg-white border-leather/20 h-9"
            />
          </div>
          <div className="flex gap-1 bg-cream/50 p-1 rounded-md border border-leather/20 w-fit">
            <button onClick={() => setViewMode("card")} className={`px-3 py-1.5 text-sm rounded flex items-center gap-2 ${viewMode === 'card' ? 'bg-white shadow-sm text-coffee font-medium' : 'text-leather hover:text-coffee hover:bg-white/50'}`}>
              <LayoutGrid className="w-4 h-4" /> Cards
            </button>
            <button onClick={() => setViewMode("list")} className={`px-3 py-1.5 text-sm rounded flex items-center gap-2 ${viewMode === 'list' ? 'bg-white shadow-sm text-coffee font-medium' : 'text-leather hover:text-coffee hover:bg-white/50'}`}>
              <ListIcon className="w-4 h-4" /> Lista
            </button>
          </div>
        </div>
      </div>

      {loading ? (
        <div className="p-8 text-center text-leather/70 flex justify-center items-center">
          <Loader2 className="h-6 w-6 animate-spin mr-2" /> Carregando usuários...
        </div>
      ) : filteredUsers.length === 0 ? (
        <div className="p-8 text-center text-leather/70 bg-cream rounded-lg border border-leather/30">
          Nenhum usuário encontrado.
        </div>
      ) : viewMode === "card" ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {filteredUsers.map((user) => {
            const isBanned = !!user.banned_until;
            const isProcessing = processingId === user.id;

            return (
              <Card key={user.id} className="border-leather/20 bg-cream/50 hover:bg-cream transition-colors relative flex flex-col">
                <CardHeader className="pb-3 flex flex-row items-start justify-between space-y-0">
                  <div className="flex-1 pr-6 truncate">
                    <CardTitle className="text-lg text-coffee truncate">
                      {user.full_name || "Sem Nome"}
                    </CardTitle>
                    <p className="text-sm text-leather truncate opacity-80">{user.email}</p>
                  </div>
                  
                  {/* Action Menu (3 dots) */}
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <Button variant="ghost" size="sm" className="h-8 w-8 p-0 absolute top-4 right-4 text-leather hover:text-coffee">
                        <span className="sr-only">Abrir menu</span>
                        <MoreVertical className="h-4 w-4" />
                      </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end" className="w-[200px]">
                      <DropdownMenuItem onClick={() => openEdit(user)} disabled={isProcessing} className="cursor-pointer">
                        <Pencil className="mr-2 h-4 w-4" /> Editar Perfil
                      </DropdownMenuItem>
                      
                      <DropdownMenuSeparator />
                      
                      {isBanned ? (
                        <DropdownMenuItem onClick={() => toggleBan(user)} disabled={isProcessing} className="cursor-pointer text-emerald-600 focus:text-emerald-600">
                          <UserCheck className="mr-2 h-4 w-4" /> Habilitar Acesso
                        </DropdownMenuItem>
                      ) : (
                        <DropdownMenuItem onClick={() => toggleBan(user)} disabled={isProcessing} className="cursor-pointer text-red-600 focus:text-red-600">
                          <UserX className="mr-2 h-4 w-4" /> Desabilitar Acesso
                        </DropdownMenuItem>
                      )}
                      
                      <DropdownMenuSeparator />
                      
                      <DropdownMenuItem onClick={() => deleteUser(user)} disabled={isProcessing} className="cursor-pointer text-red-600 focus:text-red-600">
                        <Trash2 className="mr-2 h-4 w-4" /> Excluir Conta
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </CardHeader>
                
                <CardContent className="pb-4 space-y-3 flex-1 text-sm text-coffee">
                  <div className="flex flex-col gap-1">
                    <span className="text-xs text-leather uppercase tracking-wider">Status / Cargo</span>
                    <div className="flex items-center gap-2 flex-wrap">
                      {isBanned ? (
                        <Badge variant="destructive" className="bg-red-600">
                          <ShieldAlert className="h-3 w-3 mr-1" /> Bloqueado
                        </Badge>
                      ) : (
                        <Badge variant="outline" className="border-emerald-600 text-emerald-700">
                          <ShieldCheck className="h-3 w-3 mr-1" /> Ativo
                        </Badge>
                      )}
                      
                      <Select 
                        value={user.role || "member"} 
                        onValueChange={(val: AppRole) => changeRole(user, val)}
                        disabled={isProcessing}
                      >
                        <SelectTrigger className="h-6 px-2 text-xs w-auto min-w-[120px] bg-white border-leather/20">
                          <SelectValue placeholder="Cargo" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="member">Membro</SelectItem>
                          <SelectItem value="admin">Administrador</SelectItem>
                          <SelectItem value="blog_admin">Membro Blog</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </div>

                  <div className="flex flex-col gap-1 pt-2 border-t border-leather/10">
                    <span className="text-xs text-leather uppercase tracking-wider">Perfil de Viagem</span>
                    <p className="capitalize font-medium flex items-center">
                      {user.member_type || "Piloto"}
                    </p>
                    {user.partner_id && (
                      <p className="text-xs text-leather mt-0.5">
                        <span className="opacity-80">Parceiro(a):</span> {user.partner_name}
                      </p>
                    )}
                  </div>
                </CardContent>
                
                <CardFooter className="pt-0 text-xs text-leather/60">
                  Cadastrado em: {new Date(user.created_at).toLocaleDateString("pt-BR")}
                </CardFooter>
              </Card>
            );
          })}
        </div>
      ) : (
        <div className="border border-leather/30 rounded-lg bg-cream shadow-sm overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Usuário</TableHead>
                <TableHead>Perfil / Vínculo</TableHead>
                <TableHead>Data de Cadastro</TableHead>
                <TableHead>Cargo</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Ações</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredUsers.map((user) => {
                const isBanned = !!user.banned_until;
                const isProcessing = processingId === user.id;
                
                return (
                  <TableRow key={user.id}>
                    <TableCell className="font-medium min-w-[200px]">
                      <div className="flex flex-col gap-0.5">
                        <span className="truncate text-coffee">{user.full_name || "Sem Nome"}</span>
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
                        <SelectTrigger className="w-[140px] h-8 text-xs text-coffee bg-white/60 hover:bg-white border-leather/20">
                          <SelectValue placeholder="Cargo..." />
                        </SelectTrigger>
                        <SelectContent className="bg-white text-coffee">
                          <SelectItem value="member">Membro</SelectItem>
                          <SelectItem value="admin">Administrador</SelectItem>
                          <SelectItem value="blog_admin">Membro Blog</SelectItem>
                        </SelectContent>
                      </Select>
                    </TableCell>
                    <TableCell>
                      {isBanned ? (
                        <Badge variant="destructive" className="bg-red-600">
                          <ShieldAlert className="h-3 w-3 mr-1" /> Bloqueado
                        </Badge>
                      ) : (
                        <Badge variant="outline" className="border-emerald-600 text-emerald-700">
                          <ShieldCheck className="h-3 w-3 mr-1" /> Ativo
                        </Badge>
                      )}
                    </TableCell>
                    <TableCell className="text-right">
                      <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                          <Button variant="ghost" size="sm" className="h-8 w-8 p-0 text-leather hover:text-coffee">
                            <MoreVertical className="h-4 w-4" />
                          </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                          <DropdownMenuItem onClick={() => openEdit(user)} disabled={isProcessing} className="cursor-pointer">
                            <Pencil className="mr-2 h-4 w-4" /> Editar Perfil
                          </DropdownMenuItem>
                          <DropdownMenuSeparator />
                          {isBanned ? (
                            <DropdownMenuItem onClick={() => toggleBan(user)} disabled={isProcessing} className="cursor-pointer text-emerald-600 focus:text-emerald-600">
                              <UserCheck className="mr-2 h-4 w-4" /> Habilitar Acesso
                            </DropdownMenuItem>
                          ) : (
                            <DropdownMenuItem onClick={() => toggleBan(user)} disabled={isProcessing} className="cursor-pointer text-red-600 focus:text-red-600">
                              <UserX className="mr-2 h-4 w-4" /> Desabilitar Acesso
                            </DropdownMenuItem>
                          )}
                          <DropdownMenuSeparator />
                          <DropdownMenuItem onClick={() => deleteUser(user)} disabled={isProcessing} className="cursor-pointer text-red-600 focus:text-red-600">
                            <Trash2 className="mr-2 h-4 w-4" /> Excluir Conta
                          </DropdownMenuItem>
                        </DropdownMenuContent>
                      </DropdownMenu>
                    </TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
          </Table>
        </div>
      )}

      {/* Edit Dialog */}
      <Dialog open={!!editingUser} onOpenChange={(open) => !open && setEditingUser(null)}>
        <DialogContent className="sm:max-w-[425px] bg-cream text-coffee border-leather/20">
          <DialogHeader>
            <DialogTitle className="font-display text-2xl">Editar Perfil</DialogTitle>
            <DialogDescription className="text-leather">
              Altere o tipo de membro e o parceiro(a) vinculado.
              {editingUser && <span className="block mt-1 font-medium">{editingUser.full_name || editingUser.email}</span>}
            </DialogDescription>
          </DialogHeader>
          
          <div className="grid gap-4 py-4">
            <div className="grid gap-2">
              <Label htmlFor="memberType">Tipo de Membro (Piloto / Garupa)</Label>
              <Select value={editMemberType} onValueChange={setEditMemberType}>
                <SelectTrigger id="memberType" className="bg-white">
                  <SelectValue placeholder="Selecione o tipo..." />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="piloto">Piloto</SelectItem>
                  <SelectItem value="garupa">Garupa</SelectItem>
                </SelectContent>
              </Select>
            </div>
            
            <div className="grid gap-2">
              <Label htmlFor="partnerId">Vincular a um Parceiro(a)</Label>
              <Select value={editPartnerId} onValueChange={setEditPartnerId}>
                <SelectTrigger id="partnerId" className="bg-white">
                  <SelectValue placeholder="Selecione um usuário..." />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">Nenhum / Vai sozinho(a)</SelectItem>
                  {profilesList
                    .filter(p => p.id !== editingUser?.id)
                    .map(p => (
                      <SelectItem key={p.id} value={p.id}>
                        {p.full_name || p.nickname || "Sem Nome"} ({p.member_type})
                      </SelectItem>
                    ))}
                </SelectContent>
              </Select>
              <p className="text-xs text-leather/70">
                A vinculação é automática de mão dupla. Se você vincular um ao outro, ambos compartilharão o plano financeiro.
              </p>
            </div>
          </div>
          
          <DialogFooter>
            <Button variant="outline" onClick={() => setEditingUser(null)} disabled={processingId !== null}>
              Cancelar
            </Button>
            <Button onClick={saveEdit} disabled={processingId !== null} className="bg-copper hover:bg-copper-dark text-white">
              {processingId ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : <Pencil className="h-4 w-4 mr-2" />}
              Salvar Alterações
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
