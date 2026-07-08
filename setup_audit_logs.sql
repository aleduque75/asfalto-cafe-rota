-- 1. Cria a tabela de logs
CREATE TABLE IF NOT EXISTS public.activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    action_type TEXT NOT NULL,
    entity_id TEXT,
    details JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Ativa o Row Level Security (RLS)
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

-- 3. Regra: Apenas Admins podem ver os logs
CREATE POLICY "Admins can view logs" ON public.activity_logs
    FOR SELECT
    TO authenticated
    USING (public.has_role('admin', auth.uid()));

-- 4. Regra: Usuários logados podem registrar logs (para quando quisermos gravar logs pelo site, ex: logins)
CREATE POLICY "Users can insert their own logs" ON public.activity_logs
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- 5. Criação de um Trigger Genérico para monitorar mudanças nas tabelas
CREATE OR REPLACE FUNCTION public.audit_log_trigger()
RETURNS trigger AS $$
DECLARE
    v_user_id uuid;
    v_action text;
    v_entity_id text;
    v_details jsonb;
BEGIN
    -- Tenta pegar o ID do usuário que fez a ação no site (via auth.uid do token)
    v_user_id := auth.uid();
    
    -- Determina o tipo de ação (Ex: motorcycles_INSERT, routes_UPDATE)
    v_action := UPPER(TG_TABLE_NAME) || '_' || TG_OP;
    
    -- Coleta os dados baseado se foi Delete, Update ou Insert
    IF TG_OP = 'DELETE' THEN
        BEGIN v_entity_id := OLD.id::text; EXCEPTION WHEN OTHERS THEN v_entity_id := NULL; END;
        v_details := jsonb_build_object('old_data', row_to_json(OLD));
    ELSIF TG_OP = 'UPDATE' THEN
        BEGIN v_entity_id := NEW.id::text; EXCEPTION WHEN OTHERS THEN v_entity_id := NULL; END;
        v_details := jsonb_build_object('old_data', row_to_json(OLD), 'new_data', row_to_json(NEW));
    ELSE
        BEGIN v_entity_id := NEW.id::text; EXCEPTION WHEN OTHERS THEN v_entity_id := NULL; END;
        v_details := jsonb_build_object('new_data', row_to_json(NEW));
    END IF;

    -- Salva o log
    INSERT INTO public.activity_logs (user_id, action_type, entity_id, details)
    VALUES (v_user_id, v_action, v_entity_id, v_details);
    
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Adiciona os gatilhos (Triggers) nas tabelas principais para monitorar tudo que acontece

DROP TRIGGER IF EXISTS audit_motorcycles_trigger ON public.motorcycles;
CREATE TRIGGER audit_motorcycles_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.motorcycles
    FOR EACH ROW EXECUTE FUNCTION public.audit_log_trigger();

DROP TRIGGER IF EXISTS audit_routes_trigger ON public.routes;
CREATE TRIGGER audit_routes_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.routes
    FOR EACH ROW EXECUTE FUNCTION public.audit_log_trigger();

DROP TRIGGER IF EXISTS audit_profiles_trigger ON public.profiles;
CREATE TRIGGER audit_profiles_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.audit_log_trigger();
