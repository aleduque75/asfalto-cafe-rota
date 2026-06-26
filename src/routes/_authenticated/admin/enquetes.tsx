import { createFileRoute } from "@tanstack/react-router";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "../../../integrations/supabase/client";
import { Button } from "../../../components/ui/button";
import { Input } from "../../../components/ui/input";
import { Textarea } from "../../../components/ui/textarea";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "../../../components/ui/card";
import { Label } from "../../../components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "../../../components/ui/tabs";
import { Plus, Trash2, Image as ImageIcon, Archive } from "lucide-react";
import { toast } from "sonner";
import { uploadMedia } from "../../../lib/upload";

export const Route = createFileRoute("/_authenticated/admin/enquetes")({
  component: AdminEnquetesPage,
});

function AdminEnquetesPage() {
  const queryClient = useQueryClient();
  const [activeTab, setActiveTab] = useState("active");

  // Formulário State
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [file, setFile] = useState<File | null>(null);
  const [options, setOptions] = useState<string[]>(["", ""]);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Queries
  const { data: activePolls, isLoading: loadingActive } = useQuery({
    queryKey: ["admin-polls", "active"],
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

  const { data: archivedPolls, isLoading: loadingArchived } = useQuery({
    queryKey: ["admin-polls", "archived"],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from("polls")
        .select("*, poll_options(*), poll_votes(*)")
        .eq("status", "archived")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data as any[];
    },
  });

  // Mutações
  const createPoll = useMutation({
    mutationFn: async () => {
      setIsSubmitting(true);
      try {
        if (!title.trim()) throw new Error("O título é obrigatório.");
        const validOptions = options.filter((o) => o.trim() !== "");
        if (validOptions.length < 2) throw new Error("Mínimo de 2 opções obrigatórias.");

        let imageUrl = null;
        if (file) {
          imageUrl = await uploadMedia(file, "enquetes");
        }

        // Criar enquete
        const { data: poll, error: pollError } = await (supabase as any)
          .from("polls")
          .insert({
            title,
            description,
            image_url: imageUrl,
            status: "active",
          })
          .select()
          .single();

        if (pollError) throw pollError;

        // Inserir opções
        const optionsData = validOptions.map((text, index) => ({
          poll_id: poll.id,
          text,
          order: index,
        }));

        const { error: optionsError } = await (supabase as any)
          .from("poll_options")
          .insert(optionsData);

        if (optionsError) throw optionsError;

        return poll;
      } finally {
        setIsSubmitting(false);
      }
    },
    onSuccess: () => {
      toast.success("Enquete criada com sucesso!");
      setTitle("");
      setDescription("");
      setFile(null);
      setOptions(["", ""]);
      queryClient.invalidateQueries({ queryKey: ["admin-polls"] });
      setActiveTab("active");
    },
    onError: (error: Error) => {
      toast.error(error.message);
    },
  });

  const archivePoll = useMutation({
    mutationFn: async (id: string) => {
      const { error } = await (supabase as any)
        .from("polls")
        .update({ status: "archived" })
        .eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      toast.success("Enquete arquivada!");
      queryClient.invalidateQueries({ queryKey: ["admin-polls"] });
    },
    onError: () => toast.error("Erro ao arquivar enquete."),
  });

  const deletePoll = useMutation({
    mutationFn: async (id: string) => {
      const { error } = await (supabase as any).from("polls").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      toast.success("Enquete apagada permanentemente!");
      queryClient.invalidateQueries({ queryKey: ["admin-polls"] });
    },
    onError: () => toast.error("Erro ao apagar enquete."),
  });

  // Funções de Formulário
  const addOption = () => setOptions([...options, ""]);
  const removeOption = (index: number) => {
    if (options.length <= 2) return;
    setOptions(options.filter((_, i) => i !== index));
  };
  const updateOption = (index: number, value: string) => {
    const newOptions = [...options];
    newOptions[index] = value;
    setOptions(newOptions);
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Enquetes</h1>
        <p className="text-muted-foreground">Gerencie as votações do Moto Clube</p>
      </div>
      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
        <TabsList>
          <TabsTrigger value="active">Enquetes Ativas</TabsTrigger>
          <TabsTrigger value="archived">Arquivadas / Resultados</TabsTrigger>
          <TabsTrigger value="new">Criar Nova</TabsTrigger>
        </TabsList>

        {/* --- ABA: NOVA ENQUETE --- */}
        <TabsContent value="new">
          <Card className="bg-black/40 border-primary/20">
            <CardHeader>
              <CardTitle>Criar Nova Votação</CardTitle>
              <CardDescription>
                Esta enquete ficará visível no painel de todos os membros.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-2">
                <Label>Título / Pergunta</Label>
                <Input
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  placeholder="Ex: Qual será a cor da camisa 2026?"
                  className="bg-black/50"
                />
              </div>

              <div className="space-y-2">
                <Label>Descrição (Opcional)</Label>
                <Textarea
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="Detalhes adicionais sobre a votação..."
                  className="bg-black/50"
                />
              </div>

              <div className="space-y-2">
                <Label>Foto Principal (Opcional)</Label>
                <div className="flex items-center gap-4">
                  <Input
                    type="file"
                    accept="image/*"
                    onChange={(e) => setFile(e.target.files?.[0] || null)}
                    className="bg-black/50"
                  />
                  {file && <span className="text-sm text-primary">Arquivo anexado</span>}
                </div>
              </div>

              <div className="space-y-4">
                <Label>Opções de Voto</Label>
                {options.map((option, index) => (
                  <div key={index} className="flex items-center gap-2">
                    <Input
                      value={option}
                      onChange={(e) => updateOption(index, e.target.value)}
                      placeholder={`Opção ${index + 1}`}
                      className="bg-black/50"
                    />
                    <Button
                      variant="destructive"
                      size="icon"
                      onClick={() => removeOption(index)}
                      disabled={options.length <= 2}
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
                ))}
                <Button variant="outline" onClick={addOption} className="w-full">
                  <Plus className="w-4 h-4 mr-2" /> Adicionar Opção
                </Button>
              </div>

              <Button
                className="w-full"
                onClick={() => createPoll.mutate()}
                disabled={isSubmitting}
              >
                {isSubmitting ? "Criando..." : "Publicar Enquete"}
              </Button>
            </CardContent>
          </Card>
        </TabsContent>

        {/* --- ABA: ATIVAS --- */}
        <TabsContent value="active" className="space-y-4">
          {loadingActive ? (
            <p>Carregando...</p>
          ) : activePolls?.length === 0 ? (
            <Card className="bg-black/20 border-dashed border-muted text-center p-8">
              <p className="text-muted-foreground">Nenhuma enquete ativa no momento.</p>
            </Card>
          ) : (
            activePolls?.map((poll: any) => (
              <Card key={poll.id} className="bg-black/40 border-primary/20">
                <CardHeader className="flex flex-row items-start justify-between space-y-0">
                  <div>
                    <CardTitle className="text-xl">{poll.title}</CardTitle>
                    <CardDescription>
                      Criado em: {new Date(poll.created_at).toLocaleDateString("pt-BR")}
                    </CardDescription>
                  </div>
                  <div className="flex gap-2">
                    <Button
                      variant="secondary"
                      size="sm"
                      onClick={() => archivePoll.mutate(poll.id)}
                    >
                      <Archive className="w-4 h-4 mr-2" /> Encerrar
                    </Button>
                    <Button
                      variant="destructive"
                      size="sm"
                      onClick={() => {
                        if (confirm("Tem certeza que deseja apagar? Os votos serão perdidos.")) {
                          deletePoll.mutate(poll.id);
                        }
                      }}
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="flex gap-4">
                    {poll.image_url && (
                      <img
                        src={poll.image_url}
                        alt={poll.title}
                        className="w-32 h-32 object-cover rounded-md border border-border"
                      />
                    )}
                    <div className="flex-1">
                      <p className="text-sm text-muted-foreground mb-4">
                        Total de Votos: {poll.poll_votes?.length || 0}
                      </p>
                      <ul className="space-y-2">
                        {poll.poll_options?.map((opt: any) => {
                          const votesCount = poll.poll_votes?.filter(
                            (v: any) => v.option_id === opt.id
                          ).length;
                          return (
                            <li
                              key={opt.id}
                              className="bg-black/20 p-2 rounded flex justify-between text-sm"
                            >
                              <span>{opt.text}</span>
                              <span className="font-bold text-primary">{votesCount} votos</span>
                            </li>
                          );
                        })}
                      </ul>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))
          )}
        </TabsContent>

        {/* --- ABA: ARQUIVADAS --- */}
        <TabsContent value="archived" className="space-y-4">
          {loadingArchived ? (
            <p>Carregando...</p>
          ) : archivedPolls?.length === 0 ? (
            <Card className="bg-black/20 border-dashed border-muted text-center p-8">
              <p className="text-muted-foreground">Nenhuma enquete arquivada.</p>
            </Card>
          ) : (
            archivedPolls?.map((poll: any) => (
              <Card key={poll.id} className="bg-black/20 opacity-80">
                <CardHeader className="flex flex-row items-start justify-between space-y-0">
                  <div>
                    <CardTitle className="text-lg line-through">{poll.title}</CardTitle>
                    <CardDescription>Resultado Final</CardDescription>
                  </div>
                  <Button
                    variant="destructive"
                    size="sm"
                    onClick={() => {
                      if (confirm("Tem certeza que deseja apagar o histórico?")) {
                        deletePoll.mutate(poll.id);
                      }
                    }}
                  >
                    <Trash2 className="w-4 h-4" />
                  </Button>
                </CardHeader>
                <CardContent>
                  <div className="space-y-2">
                    {poll.poll_options?.map((opt: any) => {
                      const totalVotes = poll.poll_votes?.length || 1; // previne div by 0
                      const votesCount = poll.poll_votes?.filter(
                        (v: any) => v.option_id === opt.id
                      ).length || 0;
                      const percentage = Math.round((votesCount / totalVotes) * 100);

                      return (
                        <div key={opt.id} className="space-y-1">
                          <div className="flex justify-between text-sm">
                            <span>{opt.text}</span>
                            <span>{percentage}% ({votesCount})</span>
                          </div>
                          <div className="h-2 bg-black/40 rounded overflow-hidden">
                            <div
                              className="h-full bg-primary"
                              style={{ width: `${percentage}%` }}
                            />
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </CardContent>
              </Card>
            ))
          )}
        </TabsContent>
      </Tabs>
    </div>
  );
}
