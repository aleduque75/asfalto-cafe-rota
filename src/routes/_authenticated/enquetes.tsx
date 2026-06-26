import { createFileRoute } from "@tanstack/react-router";
import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "../../integrations/supabase/client";
import { Button } from "../../components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "../../components/ui/card";
import { RadioGroup, RadioGroupItem } from "../../components/ui/radio-group";
import { Label } from "../../components/ui/label";
import { toast } from "sonner";
import { AlertCircle, CheckCircle2 } from "lucide-react";

export const Route = createFileRoute("/_authenticated/enquetes")({
  component: EnquetesPage,
});

function EnquetesPage() {
  const queryClient = useQueryClient();
  const [selectedOptions, setSelectedOptions] = useState<Record<string, string>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Perfil logado
  const { data: userProfile } = useQuery({
    queryKey: ["user-profile"],
    queryFn: async () => {
      const { data: { session } } = await supabase.auth.getSession();
      return session?.user;
    },
  });

  // Queries
  const { data: activePolls, isLoading } = useQuery({
    queryKey: ["polls", "active"],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from("polls")
        .select("*, poll_options(*), poll_votes(*)")
        .eq("status", "active")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data as any[];
    },
  });

  const voteMutation = useMutation({
    mutationFn: async ({ pollId, optionId }: { pollId: string; optionId: string }) => {
      setIsSubmitting(true);
      if (!userProfile?.id) throw new Error("Usuário não autenticado.");
      try {
        const { error } = await (supabase as any)
          .from("poll_votes")
          .insert({
            poll_id: pollId,
            option_id: optionId,
            profile_id: userProfile.id,
          });
        if (error) throw error;
      } finally {
        setIsSubmitting(false);
      }
    },
    onSuccess: () => {
      toast.success("Seu voto foi registrado com sucesso!");
      queryClient.invalidateQueries({ queryKey: ["polls"] });
    },
    onError: (error: any) => {
      if (error.code === "23505") { // Unique violation
        toast.error("Você já votou nesta enquete.");
      } else {
        toast.error("Erro ao registrar voto.");
      }
    },
  });

  const handleVote = (pollId: string) => {
    const optionId = selectedOptions[pollId];
    if (!optionId) {
      toast.error("Selecione uma opção antes de votar!");
      return;
    }
    voteMutation.mutate({ pollId, optionId });
  };

  if (isLoading) return <div className="p-6">Carregando votações...</div>;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Votações e Enquetes</h1>
        <p className="text-muted-foreground">Participe das decisões do Clube</p>
      </div>

      {activePolls?.length === 0 ? (
        <Card className="bg-black/20 border-dashed border-muted text-center p-8">
          <AlertCircle className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
          <h3 className="text-lg font-medium">Nenhuma votação em andamento</h3>
          <p className="text-muted-foreground">Fique de olho nas novidades.</p>
        </Card>
      ) : (
        <div className="grid gap-6 md:grid-cols-2">
          {activePolls?.map((poll) => {
            // Verificar se o usuário já votou
            const userVote = poll.poll_votes?.find(
              (v: any) => v.profile_id === userProfile?.id
            );
            const hasVoted = !!userVote;

            // Se já votou, calcula os resultados para exibir
            const totalVotes = poll.poll_votes?.length || 1;

            return (
              <Card key={poll.id} className="bg-black/40 border-primary/20 flex flex-col">
                {poll.image_url && (
                  <div className="w-full h-48 md:h-64 overflow-hidden rounded-t-xl">
                    <img
                      src={poll.image_url}
                      alt={poll.title}
                      className="w-full h-full object-cover"
                    />
                  </div>
                )}
                <CardHeader>
                  <CardTitle className="text-xl leading-tight">{poll.title}</CardTitle>
                  {poll.description && (
                    <CardDescription className="whitespace-pre-wrap mt-2 text-foreground/80">
                      {poll.description}
                    </CardDescription>
                  )}
                </CardHeader>
                <CardContent className="flex-1 flex flex-col">
                  {hasVoted ? (
                    <div className="space-y-4">
                      <div className="flex items-center gap-2 text-green-500 bg-green-500/10 p-2 rounded-md mb-4">
                        <CheckCircle2 className="w-5 h-5" />
                        <span className="text-sm font-medium">Você já votou!</span>
                      </div>
                      <h4 className="text-sm text-muted-foreground mb-2">
                        Resultado parcial ({poll.poll_votes?.length} votos):
                      </h4>
                      <div className="space-y-3">
                        {poll.poll_options?.map((opt: any) => {
                          const votesCount = poll.poll_votes?.filter(
                            (v: any) => v.option_id === opt.id
                          ).length || 0;
                          const percentage = Math.round((votesCount / totalVotes) * 100);
                          const isSelected = userVote.option_id === opt.id;

                          return (
                            <div key={opt.id} className="space-y-1">
                              <div className="flex items-center gap-3">
                                {opt.image_url && (
                                  <div className="w-10 h-10 rounded-md overflow-hidden shrink-0 border border-white/10">
                                    <img src={opt.image_url} alt={opt.text} className="w-full h-full object-cover" />
                                  </div>
                                )}
                                <div className="flex-1 space-y-1">
                                  <div className="flex justify-between text-sm">
                                    <span className={isSelected ? "font-bold text-primary" : ""}>
                                      {opt.text} {isSelected && "(Seu voto)"}
                                    </span>
                                    <span>{percentage}%</span>
                                  </div>
                                  <div className="h-2.5 bg-black/40 rounded-full overflow-hidden">
                                    <div
                                      className={`h-full ${isSelected ? "bg-primary" : "bg-primary/40"}`}
                                      style={{ width: `${percentage}%` }}
                                    />
                                  </div>
                                </div>
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  ) : (
                    <div className="space-y-6">
                      <RadioGroup
                        onValueChange={(val) =>
                          setSelectedOptions({ ...selectedOptions, [poll.id]: val })
                        }
                        value={selectedOptions[poll.id]}
                        className="space-y-3"
                      >
                        {poll.poll_options?.map((opt: any) => (
                          <div
                            key={opt.id}
                            className={`flex items-center space-x-3 bg-black/20 border border-transparent p-3 rounded-md transition-colors hover:bg-black/30 cursor-pointer ${
                              selectedOptions[poll.id] === opt.id ? "border-primary/50 bg-black/40" : ""
                            }`}
                            onClick={() => setSelectedOptions({ ...selectedOptions, [poll.id]: opt.id })}
                          >
                            <div className="flex items-center space-x-3 w-full">
                              <RadioGroupItem value={opt.id} id={opt.id} className="mt-0.5" />
                              <div className="flex-1 flex flex-col sm:flex-row items-start sm:items-center gap-3">
                                {opt.image_url && (
                                  <div className="w-16 h-16 sm:w-12 sm:h-12 rounded-md overflow-hidden shrink-0">
                                    <img src={opt.image_url} alt={opt.text} className="w-full h-full object-cover" />
                                  </div>
                                )}
                                <Label htmlFor={opt.id} className="cursor-pointer flex-1 text-base leading-snug">
                                  {opt.text}
                                </Label>
                              </div>
                            </div>
                          </div>
                        ))}
                      </RadioGroup>
                      
                      <div className="pt-2 mt-auto">
                        <Button
                          className="w-full"
                          onClick={() => handleVote(poll.id)}
                          disabled={!selectedOptions[poll.id] || isSubmitting}
                        >
                          {isSubmitting ? "Registrando..." : "Confirmar Voto"}
                        </Button>
                      </div>
                    </div>
                  )}
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
