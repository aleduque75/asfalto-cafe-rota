ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS birthdate DATE;

-- Create an RPC to safely fetch birthdays for today without violating the strict RLS on profiles
CREATE OR REPLACE FUNCTION get_todays_birthdays() 
RETURNS TABLE(id UUID, full_name TEXT, nickname TEXT, avatar_url TEXT, birthdate DATE) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY 
  SELECT p.id, p.full_name, p.nickname, p.avatar_url, p.birthdate
  FROM public.profiles p
  WHERE EXTRACT(MONTH FROM p.birthdate) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(DAY FROM p.birthdate) = EXTRACT(DAY FROM CURRENT_DATE);
END;
$$;
