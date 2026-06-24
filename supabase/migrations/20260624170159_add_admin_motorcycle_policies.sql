-- Allow admins to manage all motorcycles
CREATE POLICY "Admins manage all motorcycles" ON public.motorcycles
  FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));

-- Allow admins to manage all maintenance items
CREATE POLICY "Admins manage all maintenance items" ON public.maintenance_items
  FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));

-- Allow admins to manage all maintenance records
CREATE POLICY "Admins manage all maintenance records" ON public.maintenance_records
  FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));
