CREATE TABLE public.routes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    destination TEXT NOT NULL,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    meeting_point TEXT NOT NULL,
    meeting_time TIME NOT NULL,
    estimated_distance_km NUMERIC,
    waze_url TEXT,
    media_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id)
);

-- Enable RLS
ALTER TABLE public.routes ENABLE ROW LEVEL SECURITY;

-- Policies (Viewable by authenticated users)
CREATE POLICY "Routes viewable by authenticated users" 
ON public.routes FOR SELECT 
TO authenticated USING (true);

-- Allow admins to insert/update (assuming user_roles exists)
CREATE POLICY "Admins can insert routes" 
ON public.routes FOR INSERT 
WITH CHECK (
    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')
);

CREATE POLICY "Admins can update routes" 
ON public.routes FOR UPDATE 
USING (
    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')
);

CREATE POLICY "Admins can delete routes" 
ON public.routes FOR DELETE 
USING (
    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')
);
