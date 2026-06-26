ALTER TABLE public.routes ADD COLUMN status text NOT NULL DEFAULT 'open';
ALTER TABLE public.routes ADD COLUMN estimated_duration_mins integer;
ALTER TABLE public.routes ADD COLUMN visited_places text;
