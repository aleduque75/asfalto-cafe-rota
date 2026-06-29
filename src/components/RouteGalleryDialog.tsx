import { useState, useEffect } from "react";
import { supabase } from "@/integrations/supabase/client";
import { generateUploadUrl } from "@/lib/upload";
import { compressImage } from "@/lib/imageCompression";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Loader2, Trash2, Upload, ZoomIn, Image as ImageIcon } from "lucide-react";
import { toast } from "sonner";

type RoutePhoto = {
  id: string;
  route_id: string;
  profile_id: string;
  photo_url: string;
  created_at: string;
};

type RouteGalleryDialogProps = {
  routeId: string | null;
  routeTitle?: string;
  isOpen: boolean;
  onClose: () => void;
  isAdmin: boolean;
};

export function RouteGalleryDialog({ routeId, routeTitle, isOpen, onClose, isAdmin }: RouteGalleryDialogProps) {
  const [photos, setPhotos] = useState<RoutePhoto[]>([]);
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [currentUserId, setCurrentUserId] = useState<string | null>(null);
  const [enlargedImage, setEnlargedImage] = useState<string | null>(null);

  const loadPhotos = async () => {
    if (!routeId) return;
    setLoading(true);
    
    // Get current user
    const { data: { user } } = await supabase.auth.getUser();
    setCurrentUserId(user?.id || null);

    const { data, error } = await (supabase as any)
      .from("route_photos")
      .select("*")
      .eq("route_id", routeId)
      .order("created_at", { ascending: false });

    if (error) {
      toast.error("Erro ao carregar fotos: " + error.message);
    } else {
      setPhotos(data || []);
    }
    setLoading(false);
  };

  useEffect(() => {
    if (isOpen && routeId) {
      loadPhotos();
    } else {
      setPhotos([]);
    }
  }, [isOpen, routeId]);

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file || !routeId || !currentUserId) return;

    try {
      setUploading(true);
      toast.loading("Comprimindo imagem...", { id: "upload-toast" });
      
      // 1. Compress image
      const compressedFile = await compressImage(file, 1920, 1920, 0.7);

      toast.loading("Enviando para nuvem...", { id: "upload-toast" });
      
      // 2. Upload to AWS S3
      const { presignedUrl, publicUrl } = await generateUploadUrl({
        data: { filename: compressedFile.name, contentType: compressedFile.type }
      });

      const uploadRes = await fetch(presignedUrl, {
        method: "PUT",
        body: compressedFile,
        headers: { "Content-Type": compressedFile.type },
      });

      if (!uploadRes.ok) throw new Error("Falha no upload para AWS");

      toast.loading("Salvando registro...", { id: "upload-toast" });

      // 3. Save to database
      const { error } = await (supabase as any).from("route_photos").insert({
        route_id: routeId,
        profile_id: currentUserId,
        photo_url: publicUrl
      });

      if (error) throw new Error(error.message);

      toast.success("Foto adicionada com sucesso!", { id: "upload-toast" });
      loadPhotos();
    } catch (err: any) {
      toast.error(err.message || "Erro inesperado ao enviar foto.", { id: "upload-toast" });
    } finally {
      setUploading(false);
      // Reset input
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
    <>
      <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
        <DialogContent className="max-w-4xl max-h-[85vh] overflow-y-auto bg-cream border-leather/20">
          <DialogHeader>
            <DialogTitle className="text-2xl font-display text-coffee uppercase">
              Galeria: {routeTitle || "Passeio"}
            </DialogTitle>
            <DialogDescription className="text-leather">
              Compartilhe suas fotos deste passeio com os outros membros.
            </DialogDescription>
          </DialogHeader>

          <div className="flex justify-between items-center my-4">
            <h3 className="text-lg font-medium text-coffee">
              {photos.length} foto{photos.length !== 1 ? 's' : ''}
            </h3>
            
            <div>
              <input
                type="file"
                id="photo-upload"
                accept="image/*"
                className="hidden"
                onChange={handleFileUpload}
                disabled={uploading}
              />
              <label htmlFor="photo-upload">
                <Button asChild className="btn-copper cursor-pointer" disabled={uploading}>
                  <span>
                    {uploading ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : <Upload className="w-4 h-4 mr-2" />}
                    {uploading ? "Enviando..." : "Adicionar Foto"}
                  </span>
                </Button>
              </label>
            </div>
          </div>

          {loading ? (
            <div className="flex justify-center py-12">
              <Loader2 className="w-8 h-8 text-copper animate-spin" />
            </div>
          ) : photos.length === 0 ? (
            <div className="text-center py-16 border border-dashed border-leather/30 rounded-lg">
              <ImageIcon className="w-12 h-12 text-leather/40 mx-auto mb-3" />
              <p className="text-leather">Nenhuma foto adicionada ainda.</p>
              <p className="text-sm text-leather/70">Seja o primeiro a compartilhar um momento deste rolê!</p>
            </div>
          ) : (
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              {photos.map(photo => {
                const isOwner = photo.profile_id === currentUserId;
                const canDelete = isOwner || isAdmin;

                return (
                  <div key={photo.id} className="group relative aspect-square rounded-md overflow-hidden bg-leather/10 border border-leather/20 shadow-sm">
                    <img 
                      src={photo.photo_url} 
                      alt="Passeio" 
                      loading="lazy"
                      className="w-full h-full object-cover transition duration-300 group-hover:scale-105" 
                    />
                    
                    <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="text-white hover:bg-white/20 hover:text-white mx-1"
                        onClick={() => setEnlargedImage(photo.photo_url)}
                      >
                        <ZoomIn className="w-6 h-6" />
                      </Button>
                      
                      {canDelete && (
                        <Button 
                          variant="ghost" 
                          size="icon" 
                          className="text-red-400 hover:bg-red-500/20 hover:text-red-300 mx-1"
                          onClick={() => handleDelete(photo.id)}
                        >
                          <Trash2 className="w-5 h-5" />
                        </Button>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Enlarged Image Modal */}
      <Dialog open={!!enlargedImage} onOpenChange={() => setEnlargedImage(null)}>
        <DialogContent className="max-w-4xl bg-transparent border-none shadow-none p-0 flex justify-center items-center">
          {enlargedImage && (
            <img 
              src={enlargedImage} 
              alt="Ampliada" 
              className="max-h-[85vh] max-w-full object-contain rounded-lg shadow-2xl"
            />
          )}
        </DialogContent>
      </Dialog>
    </>
  );
}
