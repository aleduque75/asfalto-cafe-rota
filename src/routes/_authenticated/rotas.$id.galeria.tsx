import { createFileRoute, Link } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { supabase } from "@/integrations/supabase/client";
import { generateUploadUrl } from "@/lib/upload";
import { compressImage } from "@/lib/imageCompression";
import { Button } from "@/components/ui/button";
import { Loader2, Trash2, Upload, Image as ImageIcon, MoreVertical, ArrowLeft } from "lucide-react";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import { Carousel, CarouselContent, CarouselItem, CarouselNext, CarouselPrevious } from "@/components/ui/carousel";
import { toast } from "sonner";
import type { Tables } from "@/integrations/supabase/types";

export const Route = createFileRoute("/_authenticated/rotas/$id/galeria")({
  head: () => ({ meta: [{ title: "Galeria da Rota — Café Moto e Asfalto" }] }),
  component: RouteGalleryPage,
});

type RoutePhoto = {
  id: string;
  route_id: string;
  profile_id: string;
  photo_url: string;
  created_at: string;
};

function RouteGalleryPage() {
  const { id: routeId } = Route.useParams();
  const [routeTitle, setRouteTitle] = useState("");
  const [photos, setPhotos] = useState<RoutePhoto[]>([]);
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [currentUserId, setCurrentUserId] = useState<string | null>(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const [enlargedImageIndex, setEnlargedImageIndex] = useState<number | null>(null);

  const loadPhotos = async () => {
    setLoading(true);
    
    const { data: { user } } = await supabase.auth.getUser();
    setCurrentUserId(user?.id || null);

    if (user) {
      const { data: profile } = await supabase.from("profiles").select("is_admin").eq("id", user.id).single();
      if (profile?.is_admin) setIsAdmin(true);
    }

    const { data: routeData } = await supabase.from("routes").select("title").eq("id", routeId).single();
    if (routeData) setRouteTitle(routeData.title);

    const { data, error } = await (supabase as any)
      .from("route_photos")
      .select("*")
      .eq("route_id", routeId)
      .order("created_at", { ascending: false });

    if (error) toast.error("Erro ao carregar fotos: " + error.message);
    else setPhotos(data || []);
    
    setLoading(false);
  };

  useEffect(() => { loadPhotos(); }, [routeId]);

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0 || !currentUserId) return;

    try {
      setUploading(true);
      let successCount = 0;
      let errorCount = 0;

      toast.loading(`Processando ${files.length} foto(s)...`, { id: "upload-toast" });

      for (let i = 0; i < files.length; i++) {
        const file = files[i];
        try {
          const compressedFile = await compressImage(file, 1920, 1920, 0.7);
          const { presignedUrl, publicUrl } = await generateUploadUrl({
            data: { filename: compressedFile.name, contentType: compressedFile.type }
          });

          const uploadRes = await fetch(presignedUrl, {
            method: "PUT",
            body: compressedFile,
            headers: { "Content-Type": compressedFile.type },
          });

          if (!uploadRes.ok) throw new Error("Falha no upload para AWS");

          const { error } = await (supabase as any).from("route_photos").insert({
            route_id: routeId,
            profile_id: currentUserId,
            photo_url: publicUrl
          });

          if (error) throw new Error(error.message);
          successCount++;
        } catch (err) {
          console.error("Erro ao enviar foto:", err);
          errorCount++;
        }
      }

      if (successCount > 0) {
        toast.success(`${successCount} foto(s) adicionada(s) com sucesso!`, { id: "upload-toast" });
        loadPhotos();
      } else {
        toast.dismiss("upload-toast");
      }
      
      if (errorCount > 0) {
        toast.error(`${errorCount} foto(s) falharam no envio.`, { id: "upload-toast-err" });
      }
      
    } catch (err: any) {
      toast.error(err.message || "Erro inesperado ao enviar foto.", { id: "upload-toast" });
    } finally {
      setUploading(false);
      e.target.value = '';
    }
  };

  const handleDelete = async (photoId: string) => {
    if (!confirm("Tem certeza que deseja apagar esta foto?")) return;
    try {
      const { error } = await (supabase as any).from("route_photos").delete().eq("id", photoId);
      if (error) throw new Error(error.message);
      toast.success("Foto apagada.");
      setPhotos(photos.filter(p => p.id !== photoId));
    } catch (err: any) {
      toast.error("Erro ao apagar: " + err.message);
    }
  };

  return (
    <div className="space-y-6 pb-12 max-w-5xl mx-auto">
      <Link to="/rotas" className="inline-flex items-center gap-1 text-sm text-leather hover:text-copper mb-2">
        <ArrowLeft className="h-4 w-4" /> Voltar para rotas
      </Link>
      
      <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 mb-8">
        <div>
          <p className="text-xs uppercase tracking-[0.25em] text-copper mb-2">Galeria da Rota</p>
          <h1 className="font-display text-3xl md:text-4xl text-coffee uppercase" style={{ fontFamily: "var(--font-display)" }}>
            {routeTitle || "Carregando..."}
          </h1>
          <p className="text-sm text-leather mt-2">Compartilhe suas fotos deste passeio com os outros membros.</p>
        </div>
        
        <div className="shrink-0">
          <input
            type="file"
            id="photo-upload"
            accept="image/*"
            multiple
            className="hidden"
            onChange={handleFileUpload}
            disabled={uploading}
          />
          <label htmlFor="photo-upload">
            <Button asChild className="btn-copper cursor-pointer bg-copper text-white hover:bg-copper/90 w-full sm:w-auto" disabled={uploading}>
              <span>
                {uploading ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : <Upload className="w-4 h-4 mr-2" />}
                {uploading ? "Enviando..." : "Adicionar Fotos"}
              </span>
            </Button>
          </label>
        </div>
      </div>

      <div className="bg-cream border border-leather/20 rounded-xl p-6 min-h-[50vh] shadow-sm">
        <div className="mb-6 flex items-center justify-between">
          <h3 className="font-medium text-coffee">
            {photos.length} foto{photos.length !== 1 ? 's' : ''}
          </h3>
        </div>

        {loading ? (
          <div className="flex justify-center py-24">
            <Loader2 className="w-8 h-8 text-copper animate-spin" />
          </div>
        ) : photos.length === 0 ? (
          <div className="text-center py-24 border-2 border-dashed border-leather/30 rounded-xl bg-white/50">
            <ImageIcon className="w-12 h-12 text-leather/40 mx-auto mb-3" />
            <p className="text-coffee font-medium">Nenhuma foto adicionada ainda.</p>
            <p className="text-sm text-leather/80 mt-1">Seja o primeiro a compartilhar um momento deste rolê!</p>
          </div>
        ) : (
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {photos.map((photo, index) => {
              const isOwner = photo.profile_id === currentUserId;
              const canDelete = isOwner || isAdmin;

              return (
                <div key={photo.id} className="group relative aspect-square rounded-xl overflow-hidden bg-white border border-leather/20 shadow-sm hover:shadow-md hover:border-copper/40 transition">
                  <img 
                    src={photo.photo_url} 
                    alt="Passeio" 
                    loading="lazy"
                    onClick={() => setEnlargedImageIndex(index)}
                    className="w-full h-full object-cover transition duration-500 group-hover:scale-105 cursor-pointer" 
                  />
                  
                  {canDelete && (
                    <div className="absolute bottom-2 right-2 z-10">
                      <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                          <Button variant="secondary" size="icon" className="h-8 w-8 rounded-full bg-black/60 hover:bg-black/80 text-white border-none backdrop-blur-sm">
                            <MoreVertical className="h-4 w-4" />
                          </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end" className="bg-cream border-leather/20">
                          <DropdownMenuItem 
                            onClick={() => handleDelete(photo.id)} 
                            className="text-red-500 focus:text-red-600 focus:bg-red-50 cursor-pointer font-medium"
                          >
                            <Trash2 className="w-4 h-4 mr-2" />
                            Excluir foto
                          </DropdownMenuItem>
                        </DropdownMenuContent>
                      </DropdownMenu>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>

      <Dialog open={enlargedImageIndex !== null} onOpenChange={() => setEnlargedImageIndex(null)}>
        <DialogContent className="max-w-4xl w-full bg-transparent border-none shadow-none p-0 flex justify-center items-center">
          {enlargedImageIndex !== null && (
            <Carousel
              opts={{ align: "center", startIndex: enlargedImageIndex }}
              className="w-full max-w-3xl"
            >
              <CarouselContent>
                {photos.map((photo) => (
                  <CarouselItem key={photo.id} className="flex items-center justify-center">
                    <img 
                      src={photo.photo_url} 
                      alt="Ampliada" 
                      className="max-h-[85vh] max-w-full object-contain rounded-lg shadow-2xl"
                    />
                  </CarouselItem>
                ))}
              </CarouselContent>
              <div className="hidden sm:block">
                <CarouselPrevious className="text-white border-white/20 bg-black/50 hover:bg-black/70 hover:text-white" />
                <CarouselNext className="text-white border-white/20 bg-black/50 hover:bg-black/70 hover:text-white" />
              </div>
            </Carousel>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
