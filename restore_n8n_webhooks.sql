-- Script para restaurar os Webhooks do n8n no Supabase Cloud

-- 1. Habilitamos a extensão pg_net (nativa do Supabase Cloud para requisições HTTP)
CREATE EXTENSION IF NOT EXISTS pg_net;

-- 2. Criamos uma função genérica para disparar o webhook do n8n
-- Isso garante que funcione independente da UI do Supabase
CREATE OR REPLACE FUNCTION public.notify_n8n_webhook()
RETURNS trigger AS $$
DECLARE
  webhook_url text := 'https://n8n.electrosal.com.br/webhook/aa621b0a-8d0b-4932-a06f-5305af533b8c';
  payload jsonb;
BEGIN
  -- Monta o payload no mesmo formato padrão do Supabase Webhooks
  payload := jsonb_build_object(
    'type', TG_OP,
    'table', TG_TABLE_NAME,
    'schema', TG_TABLE_SCHEMA,
    'record', row_to_json(NEW),
    'old_record', null
  );
  
  -- Dispara a requisição HTTP POST assíncrona
  PERFORM net.http_post(
      url := webhook_url,
      body := payload,
      headers := '{"Content-Type": "application/json"}'::jsonb
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Recriamos as Triggers nas tabelas correspondentes (disparando no INSERT)

-- Fotos (route_photos)
DROP TRIGGER IF EXISTS n8n_webhook_photos ON public.route_photos;
CREATE TRIGGER n8n_webhook_photos
  AFTER INSERT ON public.route_photos
  FOR EACH ROW EXECUTE FUNCTION public.notify_n8n_webhook();

-- Enquetes (polls)
DROP TRIGGER IF EXISTS n8n_webhook_polls ON public.polls;
CREATE TRIGGER n8n_webhook_polls
  AFTER INSERT ON public.polls
  FOR EACH ROW EXECUTE FUNCTION public.notify_n8n_webhook();

-- Membros (profiles)
DROP TRIGGER IF EXISTS n8n_webhook_profiles ON public.profiles;
CREATE TRIGGER n8n_webhook_profiles
  AFTER INSERT ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.notify_n8n_webhook();

-- Rotas (routes)
DROP TRIGGER IF EXISTS n8n_webhook_routes ON public.routes;
CREATE TRIGGER n8n_webhook_routes
  AFTER INSERT ON public.routes
  FOR EACH ROW EXECUTE FUNCTION public.notify_n8n_webhook();
