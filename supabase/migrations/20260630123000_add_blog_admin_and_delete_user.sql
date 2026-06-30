-- 1. Alter app_role enum to add 'blog_admin'
ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'blog_admin';

-- 2. Create function to delete user completely
CREATE OR REPLACE FUNCTION public.delete_user_completely(target_user_id uuid)
RETURNS void
SECURITY DEFINER
SET search_path = public, auth
LANGUAGE plpgsql
AS $$
BEGIN
  IF NOT public.has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  -- Deleting from auth.users cascades to public.profiles and other related tables
  DELETE FROM auth.users WHERE id = target_user_id;
END;
$$;

-- 3. Update public.news RLS policies to allow 'blog_admin'
DROP POLICY IF EXISTS "Admins manage news" ON public.news;
CREATE POLICY "Admins manage news" ON public.news 
  FOR ALL TO authenticated 
  USING (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'blog_admin')) 
  WITH CHECK (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'blog_admin'));

DROP POLICY IF EXISTS "Public reads published news" ON public.news;
CREATE POLICY "Public reads published news" ON public.news 
  FOR SELECT TO anon, authenticated 
  USING (status = 'published' OR public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'blog_admin'));
