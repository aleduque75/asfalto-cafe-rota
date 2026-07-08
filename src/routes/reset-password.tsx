import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { toast } from "sonner";
import { Toaster } from "@/components/ui/sonner";
import logo from "@/assets/logo-badge.png";

export const Route = createFileRoute("/reset-password")({
  ssr: false,
  head: () => ({ meta: [{ title: "Redefinir Senha — Café Moto e Asfalto" }] }),
  component: ResetPasswordPage,
});

function ResetPasswordPage() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [password, setPassword] = useState("");

  useEffect(() => {
    // Check if we have an active session (which should be set by the recovery link)
    supabase.auth.getSession().then(({ data }) => {
      if (!data.session) {
        // If they come here without a session, they can't reset the password this way
        toast.error("Sessão inválida. Por favor, solicite um novo link de redefinição.");
        navigate({ to: "/auth", replace: true });
      }
    });

    const { data: authListener } = supabase.auth.onAuthStateChange(
      (event, session) => {
        if (event === "PASSWORD_RECOVERY") {
          // This is the expected event when clicking the link
          console.log("Password recovery event received");
        }
      }
    );

    return () => {
      authListener.subscription.unsubscribe();
    };
  }, [navigate]);

  async function handleUpdatePassword(e: React.FormEvent) {
    e.preventDefault();
    if (password.length < 6) {
      return toast.error("A senha deve ter pelo menos 6 caracteres.");
    }

    setLoading(true);
    const { error } = await supabase.auth.updateUser({ password });
    setLoading(false);

    if (error) {
      return toast.error(error.message);
    }

    toast.success("Senha atualizada com sucesso!");
    navigate({ to: "/dashboard", replace: true });
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4" style={{ background: "var(--coffee)" }}>
      <div className="w-full max-w-md">
        <div className="flex flex-col items-center gap-3 mb-8">
          <img src={logo} alt="" className="h-20 w-20 rounded-full ring-2 ring-copper/50" />
          <span className="font-display text-cream text-xl tracking-wide" style={{ fontFamily: "var(--font-display)" }}>
            Café Moto e Asfalto
          </span>
        </div>
        <Card className="border-leather/40 bg-cream">
          <CardHeader>
            <CardTitle className="font-display text-2xl" style={{ fontFamily: "var(--font-display)" }}>
              Redefinir Senha
            </CardTitle>
            <CardDescription>Digite sua nova senha abaixo.</CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleUpdatePassword} className="space-y-4">
              <div>
                <Label htmlFor="new-pwd" className="text-coffee font-medium">Nova Senha</Label>
                <Input
                  id="new-pwd"
                  type="password"
                  placeholder="Mínimo 6 caracteres"
                  required
                  minLength={6}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="bg-white text-coffee border-leather/30 placeholder:text-leather/50 mt-1"
                />
              </div>
              <Button type="submit" disabled={loading} className="w-full btn-copper mt-6">
                {loading ? "Atualizando..." : "Atualizar Senha"}
              </Button>
            </form>
          </CardContent>
        </Card>
      </div>
      <Toaster />
    </div>
  );
}
