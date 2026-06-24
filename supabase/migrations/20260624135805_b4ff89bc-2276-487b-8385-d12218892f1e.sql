REVOKE EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) TO authenticated, service_role;

DROP POLICY IF EXISTS "Public reads published news" ON public.news;
CREATE POLICY "Anon reads published news" ON public.news FOR SELECT TO anon USING (status = 'published');
CREATE POLICY "Auth reads news" ON public.news FOR SELECT TO authenticated USING (status = 'published' OR public.has_role(auth.uid(), 'admin'));

DROP POLICY IF EXISTS "Public reads published gallery" ON public.gallery_items;
CREATE POLICY "Anon reads published gallery" ON public.gallery_items FOR SELECT TO anon USING (status = 'published');
CREATE POLICY "Auth reads gallery" ON public.gallery_items FOR SELECT TO authenticated USING (status = 'published' OR public.has_role(auth.uid(), 'admin'));

DROP POLICY IF EXISTS "Public reads published site content" ON public.site_content;
CREATE POLICY "Anon reads published site content" ON public.site_content FOR SELECT TO anon USING (status = 'published');
CREATE POLICY "Auth reads site content" ON public.site_content FOR SELECT TO authenticated USING (status = 'published' OR public.has_role(auth.uid(), 'admin'));