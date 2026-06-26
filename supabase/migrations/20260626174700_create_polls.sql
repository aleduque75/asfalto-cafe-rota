-- Criação da tabela de enquetes (polls)
CREATE TABLE public.polls (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'archived')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Habilitar RLS para polls
ALTER TABLE public.polls ENABLE ROW LEVEL SECURITY;

-- Membros podem ver todas as enquetes
CREATE POLICY "Membros podem ver enquetes" 
    ON public.polls FOR SELECT 
    USING (auth.role() = 'authenticated');

-- Somente admins podem inserir, atualizar ou apagar enquetes
CREATE POLICY "Admins podem inserir enquetes" 
    ON public.polls FOR INSERT 
    WITH CHECK (
        public.has_role(auth.uid(), 'admin')
    );

CREATE POLICY "Admins podem atualizar enquetes" 
    ON public.polls FOR UPDATE 
    USING (
        public.has_role(auth.uid(), 'admin')
    );

CREATE POLICY "Admins podem apagar enquetes" 
    ON public.polls FOR DELETE 
    USING (
        public.has_role(auth.uid(), 'admin')
    );


-- Criação da tabela de opções da enquete (poll_options)
CREATE TABLE public.poll_options (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    poll_id UUID NOT NULL REFERENCES public.polls(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    image_url TEXT,
    "order" INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Habilitar RLS para poll_options
ALTER TABLE public.poll_options ENABLE ROW LEVEL SECURITY;

-- Membros podem ver opções
CREATE POLICY "Membros podem ver opções" 
    ON public.poll_options FOR SELECT 
    USING (auth.role() = 'authenticated');

-- Somente admins podem gerenciar opções
CREATE POLICY "Admins podem inserir opções" 
    ON public.poll_options FOR INSERT 
    WITH CHECK (
        public.has_role(auth.uid(), 'admin')
    );

CREATE POLICY "Admins podem atualizar opções" 
    ON public.poll_options FOR UPDATE 
    USING (
        public.has_role(auth.uid(), 'admin')
    );

CREATE POLICY "Admins podem apagar opções" 
    ON public.poll_options FOR DELETE 
    USING (
        public.has_role(auth.uid(), 'admin')
    );


-- Criação da tabela de votos (poll_votes)
CREATE TABLE public.poll_votes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    poll_id UUID NOT NULL REFERENCES public.polls(id) ON DELETE CASCADE,
    option_id UUID NOT NULL REFERENCES public.poll_options(id) ON DELETE CASCADE,
    profile_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    -- Restrição: Um perfil só pode votar uma vez em cada enquete
    UNIQUE(poll_id, profile_id)
);

-- Habilitar RLS para poll_votes
ALTER TABLE public.poll_votes ENABLE ROW LEVEL SECURITY;

-- Membros podem ver votos (necessário para calcular os resultados)
CREATE POLICY "Membros podem ver os votos" 
    ON public.poll_votes FOR SELECT 
    USING (auth.role() = 'authenticated');

-- Membros podem inserir seu próprio voto
CREATE POLICY "Membros podem votar" 
    ON public.poll_votes FOR INSERT 
    WITH CHECK (auth.uid() = profile_id);

-- Ninguém pode atualizar um voto depois de feito (imutável)
-- Admins podem apagar votos se necessário (ex: usuário banido)
CREATE POLICY "Admins podem apagar votos" 
    ON public.poll_votes FOR DELETE 
    USING (
        public.has_role(auth.uid(), 'admin')
    );
