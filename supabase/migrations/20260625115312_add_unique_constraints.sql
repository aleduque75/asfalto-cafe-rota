-- Add UNIQUE constraint to news title to prevent n8n from duplicating posts
ALTER TABLE public.news ADD CONSTRAINT unique_news_title UNIQUE (title);
