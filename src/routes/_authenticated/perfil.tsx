import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { toast } from "sonner";
import { User, Lock, Save, Users, ArrowLeft } from "lucide-react";

export const Route = createFileRoute("/_authenticated/perfil")({
  head: () => ({ meta: [{ title: "Meu Perfil — Café Moto e Asfalto" }] }),
  component: PerfilPage,
});

function PerfilPage() {
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [savingPwd, setSavingPwd] = useState(false);
  
  const [form, setForm] = useState({
    full_name: "",
    nickname: "",
    phone: "",
    city: "",
    instagram: "",
    birthdate: "",
    partner_id: "none",
    member_type: "piloto"
  });

  const [availablePartners, setAvailablePartners] = useState<{id: string, name: string, type: string}[]>([]);

  const [pwd, setPwd] = useState({
    newPassword: "",
    confirmPassword: ""
  });

  useEffect(() => {
    async function loadProfile() {
      const { data: u } = await supabase.auth.getUser();
      if (!u.user) return;
      
      const { data } = await supabase
        .from("profiles")
        .select("*")
        .eq("id", u.user.id)
        .maybeSingle();
        
      if (data) {
        setForm({
          full_name: data.full_name || "",
          nickname: data.nickname || "",
          phone: data.phone || "",
          city: data.city || "",
          instagram: data.instagram || "",
          birthdate: data.birthdate || "",
          partner_id: data.partner_id || "none",
          member_type: data.member_type || "piloto"
        });
      }

      // Load available partners
      const { data: partnersData } = await supabase
        .from("profiles")
        .select("id, full_name, nickname, member_type")
        .neq("id", u.user.id)
        .order("full_name");
      if (partnersData) {
        setAvailablePartners(partnersData.map(p => ({
          id: p.id,
          name: p.full_name || p.nickname || "Membro Sem Nome",
          type: p.member_type || "piloto"
        })));
      }

      setLoading(false);
    }
    loadProfile();
  }, []);

  async function handleSaveProfile(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const { data: u } = await supabase.auth.getUser();
    if (!u.user) {
        setSaving(false);
        return toast.error("Sessão expirada");
    }

    let cleanPhone = form.phone.replace(/\D/g, "");
    if (cleanPhone.length === 10 || cleanPhone.length === 11) {
      cleanPhone = "55" + cleanPhone;
    }

    const { error } = await supabase
      .from("profiles")
      .update({
        full_name: form.full_name.trim() || null,
        nickname: form.nickname.trim() || null,
        phone: cleanPhone || null,
        city: form.city.trim() || null,
        instagram: form.instagram.trim() || null,
        birthdate: form.birthdate || null,
        member_type: form.member_type,
        partner_id: form.partner_id === "none" ? null : form.partner_id
      })
      .eq("id", u.user.id);

    setSaving(false);
    if (error) {
      toast.error(error.message);
    } else {
      toast.success("Perfil atualizado com sucesso!");
    }
  }

  async function handleSavePassword(e: React.FormEvent) {
    e.preventDefault();
    if (pwd.newPassword !== pwd.confirmPassword) {
      return toast.error("As senhas não conferem!");
    }
    if (pwd.newPassword.length < 6) {
      return toast.error("A senha deve ter pelo menos 6 caracteres.");
    }
    
    setSavingPwd(true);
    const { error } = await supabase.auth.updateUser({
      password: pwd.newPassword
    });
    
    setSavingPwd(false);
    if (error) {
      toast.error(error.message);
    } else {
      toast.success("Senha atualizada com sucesso!");
      setPwd({ newPassword: "", confirmPassword: "" });
    }
  }

  if (loading) return <p className="text-leather">Carregando...</p>;

  return (
    <div className="max-w-4xl mx-auto">
      <div className="flex flex-col gap-4 mb-8">
        <Link to="/dashboard" className="self-start">
          <Button variant="ghost" size="sm" className="pl-0 text-leather hover:text-copper hover:bg-transparent -ml-2">
            <ArrowLeft className="h-4 w-4 mr-1.5" /> Voltar para o dashboard
          </Button>
        </Link>
        <div>
          <p className="text-xs uppercase tracking-[0.25em] text-copper mb-2">Configurações</p>
          <h1 className="font-display text-3xl md:text-4xl text-coffee" style={{ fontFamily: "var(--font-display)" }}>
            Meu Perfil
          </h1>
          <p className="text-sm text-leather mt-2">Gerencie suas informações e segurança da conta.</p>
        </div>
      </div>

      <div className="grid md:grid-cols-2 gap-8">
        {/* Dados Gerais */}
        <Card className="border-leather/30 bg-cream text-coffee">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-coffee">
              <User className="h-5 w-5 text-copper" /> Dados Gerais
            </CardTitle>
            <CardDescription>Informações públicas e de contato.</CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSaveProfile} className="space-y-4">
              <div>
                <Label>Nome Completo</Label>
                <Input 
                  value={form.full_name} 
                  onChange={(e) => setForm({...form, full_name: e.target.value})} 
                  placeholder="João da Silva"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Apelido</Label>
                  <Input 
                    value={form.nickname} 
                    onChange={(e) => setForm({...form, nickname: e.target.value})} 
                    placeholder="João"
                  />
                </div>
                <div>
                  <Label>Data de Nascimento</Label>
                  <Input 
                    type="date"
                    value={form.birthdate} 
                    onChange={(e) => setForm({...form, birthdate: e.target.value})} 
                  />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>WhatsApp (DDD + Número)</Label>
                  <Input 
                    type="tel"
                    value={form.phone} 
                    onChange={(e) => setForm({...form, phone: e.target.value})} 
                    placeholder="11999999999"
                  />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Cidade</Label>
                  <Input 
                    value={form.city} 
                    onChange={(e) => setForm({...form, city: e.target.value})} 
                    placeholder="São Paulo - SP"
                  />
                </div>
                <div>
                  <Label>Instagram</Label>
                  <Input 
                    value={form.instagram} 
                    onChange={(e) => setForm({...form, instagram: e.target.value})} 
                    placeholder="@joaomoto"
                  />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Tipo de Membro</Label>
                  <Select value={form.member_type} onValueChange={(val) => setForm({...form, member_type: val})}>
                    <SelectTrigger className="w-full">
                      <SelectValue placeholder="Selecione..." />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="piloto">Sou Piloto</SelectItem>
                      <SelectItem value="garupa">Sou Garupa</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              {/* Casal / Garupa */}
              <div className="pt-4 border-t border-leather/20 mt-4">
                <Label className="flex items-center gap-2 mb-2">
                  <Users className="h-4 w-4 text-copper" /> 
                  Vincular Parceiro(a) / Garupa
                </Label>
                <p className="text-xs text-leather/80 mb-3">
                  Se você costuma viajar em casal, selecione o perfil do seu(ua) parceiro(a) aqui. Isso unifica as planilhas financeiras de vocês.
                </p>
                <Select value={form.partner_id} onValueChange={(val) => setForm({...form, partner_id: val})}>
                  <SelectTrigger className="w-full">
                    <SelectValue placeholder="Selecione um parceiro" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="none">Nenhum / Vou sozinho(a)</SelectItem>
                    {availablePartners
                      .filter(p => form.member_type === "piloto" ? p.type === "garupa" : p.type === "piloto")
                      .map(p => (
                        <SelectItem key={p.id} value={p.id}>{p.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <Button type="submit" className="btn-copper w-full mt-4" disabled={saving}>
                {saving ? "Salvando..." : <><Save className="h-4 w-4 mr-2" /> Salvar perfil</>}
              </Button>
            </form>
          </CardContent>
        </Card>

        {/* Segurança */}
        <Card className="border-leather/30 bg-cream text-coffee">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-coffee">
              <Lock className="h-5 w-5 text-copper" /> Segurança
            </CardTitle>
            <CardDescription>Altere a sua senha de acesso.</CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSavePassword} className="space-y-4">
              <div>
                <Label>Nova Senha</Label>
                <Input 
                  type="password"
                  value={pwd.newPassword} 
                  onChange={(e) => setPwd({...pwd, newPassword: e.target.value})} 
                  placeholder="Mínimo 6 caracteres"
                />
              </div>
              <div>
                <Label>Confirmar Nova Senha</Label>
                <Input 
                  type="password"
                  value={pwd.confirmPassword} 
                  onChange={(e) => setPwd({...pwd, confirmPassword: e.target.value})} 
                  placeholder="Repita a senha"
                />
              </div>
              <Button type="submit" variant="outline" className="w-full mt-4 border-copper text-copper hover:bg-copper hover:text-white" disabled={savingPwd}>
                {savingPwd ? "Atualizando..." : <><Lock className="h-4 w-4 mr-2" /> Atualizar senha</>}
              </Button>
            </form>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
