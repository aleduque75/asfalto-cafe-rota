CREATE TABLE public.route_photos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    route_id UUID REFERENCES public.routes(id) ON DELETE CASCADE,
    profile_id UUID REFERENCES auth.users(id),
    photo_url TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.route_photos ENABLE ROW LEVEL SECURITY;

-- Policies
-- 1. Viewable by all authenticated users
CREATE POLICY "Route photos viewable by authenticated users" 
ON public.route_photos FOR SELECT 
TO authenticated 
USING (true);

-- 2. Authenticated users can insert (but only for their own profile)
CREATE POLICY "Authenticated users can insert route photos" 
ON public.route_photos FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = profile_id);

-- 3. Users can delete their own photos, Admins can delete any photo
CREATE POLICY "Users can delete own route photos or admins can delete any" 
ON public.route_photos FOR DELETE 
TO authenticated
USING (
    auth.uid() = profile_id 
    OR 
    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')
);

-- Grant privileges to the table so the Supabase roles can access it
GRANT ALL ON TABLE public.route_photos TO anon, authenticated, service_role;
