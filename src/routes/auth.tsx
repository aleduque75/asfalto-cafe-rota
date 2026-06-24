import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { toast } from "sonner";
import { Toaster } from "@/components/ui/sonner";
import logo from "@/assets/logo-badge.png";

export const Route = createFileRoute("/auth")({
  ssr: false,
  head: () => ({ meta: [{ title: "Entrar — Café Moto e Asfalto" }] }),
  component: AuthPage,
});

function AuthPage() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [fullName, setFullName] = useState("");

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => {
      if (data.session) navigate({ to: "/dashboard", replace: true });
    });
  }, [navigate]);

  async function handleSignIn(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    setLoading(false);
    if (error) return toast.error(error.message);
    toast.success("Bem-vindo de volta!");
    navigate({ to: "/dashboard", replace: true });
  }

  async function handleSignUp(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        emailRedirectTo: `${window.location.origin}/dashboard`,
        data: { full_name: fullName },
      },
    });
    setLoading(false);
    if (error) return toast.error(error.message);
    toast.success("Conta criada! Confirme seu e-mail para entrar.");
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4" style={{ background: "var(--coffee)" }}>
      <div className="w-full max-w-md">
        <Link to="/" className="flex flex-col items-center gap-3 mb-8">
          <img src={logo} alt="" className="h-20 w-20 rounded-full ring-2 ring-copper/50" />
          <span className="font-display text-cream text-xl tracking-wide" style={{ fontFamily: "var(--font-display)" }}>
            Café Moto e Asfalto
          </span>
        </Link>
        <Card className="border-leather/40 bg-cream">
          <CardHeader>
            <CardTitle className="font-display text-2xl" style={{ fontFamily: "var(--font-display)" }}>
              Área do integrante
            </CardTitle>
            <CardDescription>Entre para gerenciar suas motos e manutenções.</CardDescription>
          </CardHeader>
          <CardContent>
            <Tabs defaultValue="signin">
              <TabsList className="grid grid-cols-2 w-full">
                <TabsTrigger value="signin">Entrar</TabsTrigger>
                <TabsTrigger value="signup">Cadastrar</TabsTrigger>
              </TabsList>
              <TabsContent value="signin">
                <form onSubmit={handleSignIn} className="space-y-4 mt-4">
                  <div>
                    <Label htmlFor="email-in" className="text-coffee font-medium">E-mail</Label>
                    <Input id="email-in" type="email" placeholder="seu@email.com" required value={email} onChange={(e) => setEmail(e.target.value)} className="bg-white text-coffee border-leather/30 placeholder:text-leather/50 mt-1" />
                  </div>
                  <div>
                    <Label htmlFor="pwd-in" className="text-coffee font-medium">Senha</Label>
                    <Input id="pwd-in" type="password" placeholder="••••••••" required value={password} onChange={(e) => setPassword(e.target.value)} className="bg-white text-coffee border-leather/30 placeholder:text-leather/50 mt-1" />
                  </div>
                  <Button type="submit" disabled={loading} className="w-full btn-copper mt-6">
                    {loading ? "Entrando..." : "Entrar"}
                  </Button>
                </form>
              </TabsContent>
              <TabsContent value="signup">
                <form onSubmit={handleSignUp} className="space-y-4 mt-4">
                  <div>
                    <Label htmlFor="name-up" className="text-coffee font-medium">Nome completo</Label>
                    <Input id="name-up" placeholder="João da Silva" required value={fullName} onChange={(e) => setFullName(e.target.value)} className="bg-white text-coffee border-leather/30 placeholder:text-leather/50 mt-1" />
                  </div>
                  <div>
                    <Label htmlFor="email-up" className="text-coffee font-medium">E-mail</Label>
                    <Input id="email-up" type="email" placeholder="seu@email.com" required value={email} onChange={(e) => setEmail(e.target.value)} className="bg-white text-coffee border-leather/30 placeholder:text-leather/50 mt-1" />
                  </div>
                  <div>
                    <Label htmlFor="pwd-up" className="text-coffee font-medium">Senha</Label>
                    <Input id="pwd-up" type="password" placeholder="Mínimo 6 caracteres" required minLength={6} value={password} onChange={(e) => setPassword(e.target.value)} className="bg-white text-coffee border-leather/30 placeholder:text-leather/50 mt-1" />
                  </div>
                  <Button type="submit" disabled={loading} className="w-full btn-copper mt-6">
                    {loading ? "Criando..." : "Criar conta"}
                  </Button>
                </form>
              </TabsContent>
            </Tabs>
            <div className="mt-6 text-center">
              <Link to="/" className="text-xs text-leather hover:text-copper underline-offset-2 hover:underline">
                ← Voltar ao site
              </Link>
            </div>
          </CardContent>
        </Card>
      </div>
      <Toaster />
    </div>
  );
}