CREATE OR REPLACE FUNCTION public.get_users_for_admin()
RETURNS TABLE (
  id uuid,
  email varchar,
  full_name text,
  banned_until timestamptz,
  created_at timestamptz,
  role app_role
)
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  IF NOT has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  RETURN QUERY
  SELECT 
    u.id,
    u.email::varchar,
    p.full_name,
    u.banned_until,
    u.created_at,
    r.role
  FROM auth.users u
  LEFT JOIN public.profiles p ON p.id = u.id
  LEFT JOIN public.user_roles r ON r.user_id = u.id;
END;
$$;

CREATE OR REPLACE FUNCTION public.toggle_user_ban(target_user_id uuid, ban boolean)
RETURNS void
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  IF NOT has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  IF ban THEN
    UPDATE auth.users SET banned_until = '2100-01-01' WHERE id = target_user_id;
  ELSE
    UPDATE auth.users SET banned_until = NULL WHERE id = target_user_id;
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.set_user_role(target_user_id uuid, new_role app_role)
RETURNS void
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  IF NOT has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  -- Remove existing roles for this user
  DELETE FROM public.user_roles WHERE user_id = target_user_id;
  
  IF new_role IS NOT NULL THEN
    INSERT INTO public.user_roles (user_id, role) VALUES (target_user_id, new_role);
  END IF;
END;
$$;
