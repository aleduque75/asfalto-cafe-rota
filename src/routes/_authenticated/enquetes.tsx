import { createFileRoute, Link } from "@tanstack/react-router";
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
import { Checkbox } from "../../components/ui/checkbox";
import { Label } from "../../components/ui/label";
import { Dialog, DialogContent } from "../../components/ui/dialog";
import { toast } from "sonner";
import { AlertCircle, CheckCircle2, ArrowLeft, ZoomIn } from "lucide-react";

export const Route = createFileRoute("/_authenticated/enquetes")({
  component: EnquetesPage,
});

function EnquetesPage() {
  const queryClient = useQueryClient();
  const [selectedOptions, setSelectedOptions] = useState<Record<string, string[]>>({});
  const [editingPolls, setEditingPolls] = useState<Record<string, boolean>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [enlargedImage, setEnlargedImage] = useState<string | null>(null);

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
    mutationFn: async ({ pollId, optionIds }: { pollId: string; optionIds: string[] }) => {
      setIsSubmitting(true);
      if (!userProfile?.id) throw new Error("Usuário não autenticado.");
      try {
        const { error: delError } = await (supabase as any)
          .from("poll_votes")
          .delete()
          .eq("poll_id", pollId)
          .eq("profile_id", userProfile.id);
        if (delError) throw delError;

        const inserts = optionIds.map(optId => ({
            poll_id: pollId,
            option_id: optId,
            profile_id: userProfile.id,
        }));
        const { error: insError } = await (supabase as any)
          .from("poll_votes")
          .insert(inserts);
        if (insError) throw insError;
      } finally {
        setIsSubmitting(false);
      }
    },
    onSuccess: (_, variables) => {
      toast.success("Seu voto foi registrado com sucesso!");
      setEditingPolls(prev => ({ ...prev, [variables.pollId]: false }));
      queryClient.invalidateQueries({ queryKey: ["polls"] });
    },
    onError: (error: any) => {
      toast.error("Erro ao registrar voto.");
    },
  });

  const handleVote = (pollId: string) => {
    const optionIds = selectedOptions[pollId];
    if (!optionIds || optionIds.length === 0) {
      toast.error("Selecione pelo menos uma opção antes de votar!");
      return;
    }
    voteMutation.mutate({ pollId, optionIds });
  };

  if (isLoading) return <div className="p-6 text-foreground">Carregando votações...</div>;

  return (
    <div className="space-y-6 max-w-4xl mx-auto pb-12">
      <div className="flex flex-col sm:flex-row sm:items-center gap-4">
        <Button variant="outline" size="icon" asChild className="shrink-0 bg-white/50 border-leather/30 text-coffee hover:bg-white">
          <Link to="/dashboard">
            <ArrowLeft className="h-4 w-4" />
          </Link>
        </Button>
        <div>
          <h1 className="text-3xl font-bold text-coffee font-display uppercase tracking-wide">Votações e Enquetes</h1>
          <p className="text-coffee/70">Participe das decisões do Clube</p>
        </div>
      </div>

      {activePolls?.length === 0 ? (
        <Card className="bg-[#F0EBE1] border-dashed border-coffee/20 text-center p-8 shadow-sm">
          <AlertCircle className="w-12 h-12 text-coffee/50 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-coffee">Nenhuma votação em andamento</h3>
          <p className="text-coffee/60">Fique de olho nas novidades.</p>
        </Card>
      ) : (
        <div className="grid gap-8">
          {activePolls?.map((poll) => {
            // Verificar se o usuário já votou
            const userVotes = poll.poll_votes?.filter(
              (v: any) => v.profile_id === userProfile?.id
            ) || [];
            const hasVoted = userVotes.length > 0 && !editingPolls[poll.id];

            // Se já votou, calcula os resultados para exibir
            const totalVotes = poll.poll_votes?.length || 1;

            return (
              <Card key={poll.id} className="bg-[#F0EBE1] border border-coffee/10 shadow-lg flex flex-col overflow-hidden">
                {poll.image_url && (
                  <div 
                    className="w-full h-56 md:h-72 overflow-hidden bg-muted relative group cursor-pointer"
                    onClick={() => setEnlargedImage(poll.image_url)}
                  >
                    <img
                      src={poll.image_url}
                      alt={poll.title}
                      className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                    />
                    <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                      <ZoomIn className="w-8 h-8 text-white" />
                    </div>
                  </div>
                )}
                <div className="p-6 flex flex-col flex-1">
                  <div className="mb-6">
                    <CardTitle className="text-2xl font-display uppercase tracking-wide text-coffee mb-2">{poll.title}</CardTitle>
                    {poll.description && (
                      <CardDescription className="whitespace-pre-wrap text-base text-coffee/80 leading-relaxed">
                        {poll.description}
                      </CardDescription>
                    )}
                  </div>
                  
                  <div className="flex-1 flex flex-col">
                    {hasVoted ? (
                      <div className="space-y-6 bg-coffee/5 rounded-xl p-5 border border-coffee/10">
                        <div className="flex items-center gap-3 text-emerald-700 bg-emerald-50 p-3 rounded-lg border border-emerald-100">
                          <CheckCircle2 className="w-5 h-5 shrink-0" />
                          <span className="text-sm font-medium">Você já votou! Obrigado por participar.</span>
                        </div>
                        <div>
                          <h4 className="text-sm font-medium text-coffee/60 mb-4 uppercase tracking-wider">
                            Resultado parcial ({poll.poll_votes?.length} votos)
                          </h4>
                          <div className="space-y-4">
                            {poll.poll_options?.sort((a: any, b: any) => {
                                const votesA = poll.poll_votes?.filter((v: any) => v.option_id === a.id).length || 0;
                                const votesB = poll.poll_votes?.filter((v: any) => v.option_id === b.id).length || 0;
                                return votesB - votesA;
                            }).map((opt: any) => {
                              const votesCount = poll.poll_votes?.filter(
                                (v: any) => v.option_id === opt.id
                              ).length || 0;
                              const percentage = Math.round((votesCount / totalVotes) * 100);
                              const isSelected = userVotes.some((v: any) => v.option_id === opt.id);

                              return (
                                <div key={opt.id} className="space-y-2">
                                  <div className="flex items-center gap-4">
                                    {opt.image_url && (
                                      <div 
                                        className="w-12 h-12 rounded-md overflow-hidden shrink-0 border border-coffee/10 shadow-sm bg-muted cursor-pointer relative group"
                                        onClick={(e) => {
                                          e.stopPropagation();
                                          setEnlargedImage(opt.image_url);
                                        }}
                                      >
                                        <img src={opt.image_url} alt={opt.text} className="w-full h-full object-cover transition-transform group-hover:scale-110" />
                                        <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                                          <ZoomIn className="w-4 h-4 text-white" />
                                        </div>
                                      </div>
                                    )}
                                    <div className="flex-1 space-y-1.5">
                                      <div className="flex justify-between items-start text-sm">
                                        <span className={`pr-4 ${isSelected ? "font-bold text-coffee" : "text-coffee/80"}`}>
                                          {opt.text} {isSelected && <span className="text-primary text-xs ml-1 font-medium uppercase tracking-wider">(Seu voto)</span>}
                                        </span>
                                        <span className="font-medium text-coffee/70 shrink-0">{percentage}%</span>
                                      </div>
                                      <div className="h-2 bg-coffee/10 rounded-full overflow-hidden">
                                        <div
                                          className={`h-full rounded-full transition-all duration-1000 ${isSelected ? "bg-primary" : "bg-primary/50"}`}
                                          style={{ width: `${percentage}%` }}
                                        />
                                      </div>
                                    </div>
                                  </div>
                                </div>
                              );
                            })}
                          </div>
                          <div className="pt-4 mt-4 flex justify-end">
                            <Button
                              variant="outline"
                              size="sm"
                              className="bg-white text-coffee border-coffee/20 hover:bg-white/80"
                              onClick={() => {
                                setEditingPolls({ ...editingPolls, [poll.id]: true });
                                setSelectedOptions({
                                  ...selectedOptions,
                                  [poll.id]: userVotes.map((v: any) => v.option_id),
                                });
                              }}
                            >
                              Mudar Voto
                            </Button>
                          </div>
                        </div>
                      </div>
                    ) : (
                      <div className="space-y-6 flex flex-col flex-1">
                        {poll.allow_multiple_answers ? (
                          <div className="space-y-3">
                            {poll.poll_options?.map((opt: any) => {
                              const isChecked = selectedOptions[poll.id]?.includes(opt.id);
                              return (
                                <div
                                  key={opt.id}
                                  className={`flex items-center space-x-3 bg-[#F0EBE1] border border-coffee/10 p-4 rounded-xl transition-all hover:bg-coffee/5 hover:border-coffee/20 cursor-pointer shadow-sm ${
                                    isChecked ? "border-primary bg-primary/5 shadow-md" : ""
                                  }`}
                                  onClick={() => {
                                    const current = selectedOptions[poll.id] || [];
                                    if (isChecked) {
                                      setSelectedOptions({ ...selectedOptions, [poll.id]: current.filter(id => id !== opt.id) });
                                    } else {
                                      setSelectedOptions({ ...selectedOptions, [poll.id]: [...current, opt.id] });
                                    }
                                  }}
                                >
                                  <div className="flex items-center space-x-4 w-full">
                                    <Checkbox
                                      checked={isChecked}
                                      onCheckedChange={(checked) => {
                                        const current = selectedOptions[poll.id] || [];
                                        if (!checked) {
                                          setSelectedOptions({ ...selectedOptions, [poll.id]: current.filter(id => id !== opt.id) });
                                        } else {
                                          setSelectedOptions({ ...selectedOptions, [poll.id]: [...current, opt.id] });
                                        }
                                      }}
                                      className="border-coffee/30 data-[state=checked]:bg-primary data-[state=checked]:border-primary"
                                    />
                                    <div className="flex-1 flex flex-col sm:flex-row items-start sm:items-center gap-4">
                                      {opt.image_url && (
                                        <div 
                                          className="w-16 h-16 rounded-md overflow-hidden shrink-0 bg-muted border border-coffee/10 shadow-sm relative group z-10"
                                          onClick={(e) => {
                                            e.stopPropagation();
                                            e.preventDefault();
                                            setEnlargedImage(opt.image_url);
                                          }}
                                        >
                                          <img src={opt.image_url} alt={opt.text} className="w-full h-full object-cover transition-transform group-hover:scale-110" />
                                          <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                                            <ZoomIn className="w-5 h-5 text-white" />
                                          </div>
                                        </div>
                                      )}
                                      <Label className="cursor-pointer flex-1 text-base leading-snug text-coffee/90 font-medium">
                                        {opt.text}
                                      </Label>
                                    </div>
                                  </div>
                                </div>
                              );
                            })}
                          </div>
                        ) : (
                          <RadioGroup
                            onValueChange={(val) =>
                              setSelectedOptions({ ...selectedOptions, [poll.id]: [val] })
                            }
                            value={selectedOptions[poll.id]?.[0]}
                            className="space-y-3"
                          >
                            {poll.poll_options?.map((opt: any) => (
                              <div
                                key={opt.id}
                                className={`flex items-center space-x-3 bg-[#F0EBE1] border border-coffee/10 p-4 rounded-xl transition-all hover:bg-coffee/5 hover:border-coffee/20 cursor-pointer shadow-sm ${
                                  selectedOptions[poll.id]?.[0] === opt.id ? "border-primary bg-primary/5 shadow-md" : ""
                                }`}
                                onClick={() => setSelectedOptions({ ...selectedOptions, [poll.id]: [opt.id] })}
                              >
                                <div className="flex items-center space-x-4 w-full">
                                  <RadioGroupItem value={opt.id} id={opt.id} className="mt-0.5 border-coffee/30 text-primary data-[state=checked]:border-primary" />
                                  <div className="flex-1 flex flex-col sm:flex-row items-start sm:items-center gap-4">
                                    {opt.image_url && (
                                      <div 
                                        className="w-16 h-16 rounded-md overflow-hidden shrink-0 bg-muted border border-coffee/10 shadow-sm relative group z-10"
                                        onClick={(e) => {
                                          e.stopPropagation();
                                          e.preventDefault();
                                          setEnlargedImage(opt.image_url);
                                        }}
                                      >
                                        <img src={opt.image_url} alt={opt.text} className="w-full h-full object-cover transition-transform group-hover:scale-110" />
                                        <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                                          <ZoomIn className="w-5 h-5 text-white" />
                                        </div>
                                      </div>
                                    )}
                                    <Label htmlFor={opt.id} className="cursor-pointer flex-1 text-base leading-snug text-coffee/90 font-medium">
                                      {opt.text}
                                    </Label>
                                  </div>
                                </div>
                              </div>
                            ))}
                          </RadioGroup>
                        )}
                        
                        <div className="pt-4 mt-auto">
                          <Button
                            className="w-full btn-copper font-display uppercase tracking-widest py-6"
                            onClick={() => handleVote(poll.id)}
                            disabled={!selectedOptions[poll.id]?.length || isSubmitting}
                          >
                            {isSubmitting ? "Registrando..." : "Confirmar Voto"}
                          </Button>
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              </Card>
            );
          })}
        </div>
      )}

      {/* Modal para ampliar imagem */}
      <Dialog open={!!enlargedImage} onOpenChange={() => setEnlargedImage(null)}>
        <DialogContent className="max-w-3xl bg-transparent border-none shadow-none flex justify-center items-center p-0">
          {enlargedImage && (
            <img 
              src={enlargedImage} 
              alt="Imagem ampliada" 
              className="max-h-[85vh] max-w-full object-contain rounded-lg shadow-2xl border border-white/20"
            />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
