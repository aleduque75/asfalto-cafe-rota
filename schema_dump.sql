


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."app_role" AS ENUM (
    'admin',
    'member',
    'blog_admin'
);


ALTER TYPE "public"."app_role" OWNER TO "postgres";


CREATE TYPE "public"."content_status" AS ENUM (
    'draft',
    'published'
);


ALTER TYPE "public"."content_status" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."claim_admin_if_first"() RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  uid uuid := auth.uid();
  has_any boolean;
BEGIN
  IF uid IS NULL THEN
    RETURN false;
  END IF;
  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE role = 'admin') INTO has_any;
  IF has_any THEN
    RETURN false;
  END IF;
  INSERT INTO public.user_roles (user_id, role) VALUES (uid, 'admin') ON CONFLICT DO NOTHING;
  RETURN true;
END;
$$;


ALTER FUNCTION "public"."claim_admin_if_first"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."delete_user_completely"("target_user_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'auth'
    AS $$
BEGIN
  IF NOT public.has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  -- Deleting from auth.users cascades to public.profiles and other related tables
  DELETE FROM auth.users WHERE id = target_user_id;
END;
$$;


ALTER FUNCTION "public"."delete_user_completely"("target_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_todays_birthdays"() RETURNS TABLE("id" "uuid", "full_name" "text", "nickname" "text", "avatar_url" "text", "birthdate" "date")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY 
  SELECT p.id, p.full_name, p.nickname, p.avatar_url, p.birthdate
  FROM public.profiles p
  WHERE EXTRACT(MONTH FROM p.birthdate) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(DAY FROM p.birthdate) = EXTRACT(DAY FROM CURRENT_DATE);
END;
$$;


ALTER FUNCTION "public"."get_todays_birthdays"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_partner_id"() RETURNS "uuid"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    AS $$
  SELECT partner_id FROM public.profiles WHERE id = auth.uid() LIMIT 1;
$$;


ALTER FUNCTION "public"."get_user_partner_id"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_users_for_admin"() RETURNS TABLE("id" "uuid", "email" character varying, "full_name" "text", "banned_until" timestamp with time zone, "created_at" timestamp with time zone, "role" "public"."app_role")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_users_for_admin"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, member_type)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'member_type', 'piloto')
  );
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."has_role"("_user_id" "uuid", "_role" "public"."app_role") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role)
$$;


ALTER FUNCTION "public"."has_role"("_user_id" "uuid", "_role" "public"."app_role") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."set_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_user_role"("target_user_id" "uuid", "new_role" "public"."app_role") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."set_user_role"("target_user_id" "uuid", "new_role" "public"."app_role") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_partner_id"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  -- If we are linking a new partner
  IF NEW.partner_id IS NOT NULL AND (OLD.partner_id IS NULL OR OLD.partner_id <> NEW.partner_id) THEN
    -- Update the new partner to point back to us
    UPDATE public.profiles SET partner_id = NEW.id WHERE id = NEW.partner_id;
    -- If we had an old partner, remove us from them
    IF OLD.partner_id IS NOT NULL THEN
      UPDATE public.profiles SET partner_id = NULL WHERE id = OLD.partner_id;
    END IF;
  END IF;

  -- If we are removing our partner
  IF NEW.partner_id IS NULL AND OLD.partner_id IS NOT NULL THEN
    -- Remove us from the old partner
    UPDATE public.profiles SET partner_id = NULL WHERE id = OLD.partner_id AND partner_id = NEW.id;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."sync_partner_id"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."toggle_user_ban"("target_user_id" "uuid", "ban" boolean) RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."toggle_user_ban"("target_user_id" "uuid", "ban" boolean) OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."gallery_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text",
    "caption" "text",
    "image_url" "text" NOT NULL,
    "instagram_url" "text",
    "sort_order" integer DEFAULT 0 NOT NULL,
    "status" "public"."content_status" DEFAULT 'draft'::"public"."content_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."gallery_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."maintenance_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "motorcycle_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "interval_km" integer,
    "interval_months" integer,
    "last_change_km" integer,
    "last_change_date" "date",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."maintenance_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."maintenance_records" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "motorcycle_id" "uuid" NOT NULL,
    "maintenance_item_id" "uuid",
    "user_id" "uuid" NOT NULL,
    "item_name" "text" NOT NULL,
    "service_date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "km_at_service" integer,
    "cost" numeric(10,2),
    "workshop" "text",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."maintenance_records" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."motorcycles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "brand" "text" NOT NULL,
    "model" "text" NOT NULL,
    "year" integer,
    "plate" "text",
    "color" "text",
    "nickname" "text",
    "current_km" integer DEFAULT 0 NOT NULL,
    "photo_url" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."motorcycles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."news" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text" NOT NULL,
    "slug" "text" NOT NULL,
    "excerpt" "text",
    "content" "text",
    "cover_url" "text",
    "tag" "text",
    "status" "public"."content_status" DEFAULT 'draft'::"public"."content_status" NOT NULL,
    "published_at" timestamp with time zone,
    "author_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."news" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."poll_options" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "poll_id" "uuid" NOT NULL,
    "text" "text" NOT NULL,
    "image_url" "text",
    "order" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."poll_options" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."poll_votes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "poll_id" "uuid" NOT NULL,
    "option_id" "uuid" NOT NULL,
    "profile_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."poll_votes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."polls" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text" NOT NULL,
    "description" "text",
    "image_url" "text",
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "polls_status_check" CHECK (("status" = ANY (ARRAY['active'::"text", 'archived'::"text"])))
);


ALTER TABLE "public"."polls" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "full_name" "text",
    "nickname" "text",
    "city" "text",
    "phone" "text",
    "avatar_url" "text",
    "instagram" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "birthdate" "date",
    "partner_id" "uuid",
    "member_type" "text" DEFAULT 'piloto'::"text",
    CONSTRAINT "profiles_member_type_check" CHECK (("member_type" = ANY (ARRAY['piloto'::"text", 'garupa'::"text"])))
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."route_photos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "route_id" "uuid",
    "profile_id" "uuid",
    "photo_url" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."route_photos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."routes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text" NOT NULL,
    "description" "text",
    "destination" "text" NOT NULL,
    "start_date" timestamp with time zone NOT NULL,
    "meeting_point" "text" NOT NULL,
    "meeting_time" time without time zone NOT NULL,
    "estimated_distance_km" numeric,
    "waze_url" "text",
    "media_url" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "status" "text" DEFAULT 'open'::"text" NOT NULL,
    "estimated_duration_mins" integer,
    "visited_places" "text",
    "route_type" "text" DEFAULT 'passeio'::"text",
    "has_financial_plan" boolean DEFAULT false,
    CONSTRAINT "routes_route_type_check" CHECK (("route_type" = ANY (ARRAY['passeio'::"text", 'viagem'::"text"])))
);


ALTER TABLE "public"."routes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."site_content" (
    "key" "text" NOT NULL,
    "value" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "status" "public"."content_status" DEFAULT 'published'::"public"."content_status" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."site_content" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."trip_financial_plans" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "route_id" "uuid" NOT NULL,
    "profile_id" "uuid" NOT NULL,
    "costs" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "observations" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "fuel_calc" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "has_passenger" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."trip_financial_plans" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "role" "public"."app_role" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."user_roles" OWNER TO "postgres";


ALTER TABLE ONLY "public"."gallery_items"
    ADD CONSTRAINT "gallery_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."maintenance_items"
    ADD CONSTRAINT "maintenance_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."maintenance_records"
    ADD CONSTRAINT "maintenance_records_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."motorcycles"
    ADD CONSTRAINT "motorcycles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."news"
    ADD CONSTRAINT "news_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."news"
    ADD CONSTRAINT "news_slug_key" UNIQUE ("slug");



ALTER TABLE ONLY "public"."poll_options"
    ADD CONSTRAINT "poll_options_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."poll_votes"
    ADD CONSTRAINT "poll_votes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."poll_votes"
    ADD CONSTRAINT "poll_votes_poll_id_profile_id_key" UNIQUE ("poll_id", "profile_id");



ALTER TABLE ONLY "public"."polls"
    ADD CONSTRAINT "polls_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."route_photos"
    ADD CONSTRAINT "route_photos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."routes"
    ADD CONSTRAINT "routes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."site_content"
    ADD CONSTRAINT "site_content_pkey" PRIMARY KEY ("key");



ALTER TABLE ONLY "public"."trip_financial_plans"
    ADD CONSTRAINT "trip_financial_plans_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."trip_financial_plans"
    ADD CONSTRAINT "trip_financial_plans_route_id_profile_id_key" UNIQUE ("route_id", "profile_id");



ALTER TABLE ONLY "public"."gallery_items"
    ADD CONSTRAINT "unique_instagram_url" UNIQUE ("instagram_url");



ALTER TABLE ONLY "public"."news"
    ADD CONSTRAINT "unique_news_title" UNIQUE ("title");



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_user_id_role_key" UNIQUE ("user_id", "role");



CREATE INDEX "maintenance_items_motorcycle_id_idx" ON "public"."maintenance_items" USING "btree" ("motorcycle_id");



CREATE INDEX "maintenance_records_motorcycle_id_idx" ON "public"."maintenance_records" USING "btree" ("motorcycle_id");



CREATE INDEX "motorcycles_user_id_idx" ON "public"."motorcycles" USING "btree" ("user_id");



CREATE OR REPLACE TRIGGER "gallery_updated_at" BEFORE UPDATE ON "public"."gallery_items" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "maintenance_items_set_updated_at" BEFORE UPDATE ON "public"."maintenance_items" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "motorcycles_set_updated_at" BEFORE UPDATE ON "public"."motorcycles" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "n8n_webhook_photos" AFTER INSERT ON "public"."route_photos" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://n8n.electrosal.com.br/webhook/aa621b0a-8d0b-4932-a06f-5305af533b8c', 'POST', '{"Content-type":"application/json"}', '{}', '5000');



CREATE OR REPLACE TRIGGER "n8n_webhook_polls" AFTER INSERT ON "public"."polls" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://n8n.electrosal.com.br/webhook/aa621b0a-8d0b-4932-a06f-5305af533b8c', 'POST', '{"Content-type":"application/json"}', '{}', '5000');



CREATE OR REPLACE TRIGGER "n8n_webhook_profiles" AFTER INSERT ON "public"."profiles" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://n8n.electrosal.com.br/webhook/aa621b0a-8d0b-4932-a06f-5305af533b8c', 'POST', '{"Content-type":"application/json"}', '{}', '5000');



CREATE OR REPLACE TRIGGER "n8n_webhook_routes" AFTER INSERT ON "public"."routes" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://n8n.electrosal.com.br/webhook/aa621b0a-8d0b-4932-a06f-5305af533b8c', 'POST', '{"Content-type":"application/json"}', '{}', '5000');



CREATE OR REPLACE TRIGGER "news_updated_at" BEFORE UPDATE ON "public"."news" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "on_partner_change" AFTER UPDATE OF "partner_id" ON "public"."profiles" FOR EACH ROW WHEN (("pg_trigger_depth"() = 0)) EXECUTE FUNCTION "public"."sync_partner_id"();



CREATE OR REPLACE TRIGGER "profiles_set_updated_at" BEFORE UPDATE ON "public"."profiles" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "route_webhook_trigger" AFTER INSERT ON "public"."routes" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://n8n.electrosal.com.br/webhook-test/0712d4af-864c-414a-817d-03504541331f', 'POST', '{"Content-type":"application/json"}', '{}', '1000');



CREATE OR REPLACE TRIGGER "site_content_updated_at" BEFORE UPDATE ON "public"."site_content" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



ALTER TABLE ONLY "public"."maintenance_items"
    ADD CONSTRAINT "maintenance_items_motorcycle_id_fkey" FOREIGN KEY ("motorcycle_id") REFERENCES "public"."motorcycles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."maintenance_items"
    ADD CONSTRAINT "maintenance_items_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."maintenance_records"
    ADD CONSTRAINT "maintenance_records_maintenance_item_id_fkey" FOREIGN KEY ("maintenance_item_id") REFERENCES "public"."maintenance_items"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."maintenance_records"
    ADD CONSTRAINT "maintenance_records_motorcycle_id_fkey" FOREIGN KEY ("motorcycle_id") REFERENCES "public"."motorcycles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."maintenance_records"
    ADD CONSTRAINT "maintenance_records_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."motorcycles"
    ADD CONSTRAINT "motorcycles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."news"
    ADD CONSTRAINT "news_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."poll_options"
    ADD CONSTRAINT "poll_options_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "public"."polls"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."poll_votes"
    ADD CONSTRAINT "poll_votes_option_id_fkey" FOREIGN KEY ("option_id") REFERENCES "public"."poll_options"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."poll_votes"
    ADD CONSTRAINT "poll_votes_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "public"."polls"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."poll_votes"
    ADD CONSTRAINT "poll_votes_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "public"."profiles"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."route_photos"
    ADD CONSTRAINT "route_photos_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."route_photos"
    ADD CONSTRAINT "route_photos_route_id_fkey" FOREIGN KEY ("route_id") REFERENCES "public"."routes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."routes"
    ADD CONSTRAINT "routes_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."trip_financial_plans"
    ADD CONSTRAINT "trip_financial_plans_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."trip_financial_plans"
    ADD CONSTRAINT "trip_financial_plans_route_id_fkey" FOREIGN KEY ("route_id") REFERENCES "public"."routes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



CREATE POLICY "Admins can delete routes" ON "public"."routes" FOR DELETE USING ((EXISTS ( SELECT 1
   FROM "public"."user_roles"
  WHERE (("user_roles"."user_id" = "auth"."uid"()) AND ("user_roles"."role" = 'admin'::"public"."app_role")))));



CREATE POLICY "Admins can insert routes" ON "public"."routes" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."user_roles"
  WHERE (("user_roles"."user_id" = "auth"."uid"()) AND ("user_roles"."role" = 'admin'::"public"."app_role")))));



CREATE POLICY "Admins can update routes" ON "public"."routes" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM "public"."user_roles"
  WHERE (("user_roles"."user_id" = "auth"."uid"()) AND ("user_roles"."role" = 'admin'::"public"."app_role")))));



CREATE POLICY "Admins manage all maintenance items" ON "public"."maintenance_items" TO "authenticated" USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role")) WITH CHECK ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins manage all maintenance records" ON "public"."maintenance_records" TO "authenticated" USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role")) WITH CHECK ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins manage all motorcycles" ON "public"."motorcycles" TO "authenticated" USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role")) WITH CHECK ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins manage gallery" ON "public"."gallery_items" TO "authenticated" USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role")) WITH CHECK ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins manage news" ON "public"."news" TO "authenticated" USING (("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role") OR "public"."has_role"("auth"."uid"(), 'blog_admin'::"public"."app_role"))) WITH CHECK (("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role") OR "public"."has_role"("auth"."uid"(), 'blog_admin'::"public"."app_role")));



CREATE POLICY "Admins manage roles" ON "public"."user_roles" TO "authenticated" USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role")) WITH CHECK ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins manage site content" ON "public"."site_content" TO "authenticated" USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role")) WITH CHECK ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins podem apagar enquetes" ON "public"."polls" FOR DELETE USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins podem apagar opções" ON "public"."poll_options" FOR DELETE USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins podem apagar votos" ON "public"."poll_votes" FOR DELETE USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins podem atualizar enquetes" ON "public"."polls" FOR UPDATE USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins podem atualizar opções" ON "public"."poll_options" FOR UPDATE USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins podem inserir enquetes" ON "public"."polls" FOR INSERT WITH CHECK ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins podem inserir opções" ON "public"."poll_options" FOR INSERT WITH CHECK ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Admins view all roles" ON "public"."user_roles" FOR SELECT TO "authenticated" USING ("public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role"));



CREATE POLICY "Anon reads published gallery" ON "public"."gallery_items" FOR SELECT TO "anon" USING (("status" = 'published'::"public"."content_status"));



CREATE POLICY "Anon reads published news" ON "public"."news" FOR SELECT TO "anon" USING (("status" = 'published'::"public"."content_status"));



CREATE POLICY "Anon reads published site content" ON "public"."site_content" FOR SELECT TO "anon" USING (("status" = 'published'::"public"."content_status"));



CREATE POLICY "Auth reads gallery" ON "public"."gallery_items" FOR SELECT TO "authenticated" USING ((("status" = 'published'::"public"."content_status") OR "public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role")));



CREATE POLICY "Auth reads news" ON "public"."news" FOR SELECT TO "authenticated" USING ((("status" = 'published'::"public"."content_status") OR "public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role")));



CREATE POLICY "Auth reads site content" ON "public"."site_content" FOR SELECT TO "authenticated" USING ((("status" = 'published'::"public"."content_status") OR "public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role")));



CREATE POLICY "Authenticated users can insert route photos" ON "public"."route_photos" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "profile_id"));



CREATE POLICY "Authenticated users can view all profiles" ON "public"."profiles" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Membros podem ver enquetes" ON "public"."polls" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Membros podem ver opções" ON "public"."poll_options" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Membros podem ver os votos" ON "public"."poll_votes" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Membros podem votar" ON "public"."poll_votes" FOR INSERT WITH CHECK (("auth"."uid"() = "profile_id"));



CREATE POLICY "Public reads published news" ON "public"."news" FOR SELECT TO "authenticated", "anon" USING ((("status" = 'published'::"public"."content_status") OR "public"."has_role"("auth"."uid"(), 'admin'::"public"."app_role") OR "public"."has_role"("auth"."uid"(), 'blog_admin'::"public"."app_role")));



CREATE POLICY "Route photos viewable by authenticated users" ON "public"."route_photos" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Routes viewable by authenticated users" ON "public"."routes" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Users and partners manage maintenance items" ON "public"."maintenance_items" TO "authenticated" USING ((("auth"."uid"() = "user_id") OR ("public"."get_user_partner_id"() = "user_id"))) WITH CHECK ((("auth"."uid"() = "user_id") OR ("public"."get_user_partner_id"() = "user_id")));



CREATE POLICY "Users and partners manage maintenance records" ON "public"."maintenance_records" TO "authenticated" USING ((("auth"."uid"() = "user_id") OR ("public"."get_user_partner_id"() = "user_id"))) WITH CHECK ((("auth"."uid"() = "user_id") OR ("public"."get_user_partner_id"() = "user_id")));



CREATE POLICY "Users and partners manage motorcycles" ON "public"."motorcycles" TO "authenticated" USING ((("auth"."uid"() = "user_id") OR ("public"."get_user_partner_id"() = "user_id"))) WITH CHECK ((("auth"."uid"() = "user_id") OR ("public"."get_user_partner_id"() = "user_id")));



CREATE POLICY "Users can delete own route photos or admins can delete any" ON "public"."route_photos" FOR DELETE TO "authenticated" USING ((("auth"."uid"() = "profile_id") OR (EXISTS ( SELECT 1
   FROM "public"."user_roles"
  WHERE (("user_roles"."user_id" = "auth"."uid"()) AND ("user_roles"."role" = 'admin'::"public"."app_role"))))));



CREATE POLICY "Users can delete their own or partner's trip financial plans" ON "public"."trip_financial_plans" FOR DELETE TO "authenticated" USING ((("auth"."uid"() = "profile_id") OR ("public"."get_user_partner_id"() = "profile_id")));



CREATE POLICY "Users can insert their own trip financial plans" ON "public"."trip_financial_plans" FOR INSERT TO "authenticated" WITH CHECK ((("auth"."uid"() = "profile_id") OR ("public"."get_user_partner_id"() = "profile_id")));



CREATE POLICY "Users can update their own or partner's trip financial plans" ON "public"."trip_financial_plans" FOR UPDATE TO "authenticated" USING ((("auth"."uid"() = "profile_id") OR ("public"."get_user_partner_id"() = "profile_id"))) WITH CHECK ((("auth"."uid"() = "profile_id") OR ("public"."get_user_partner_id"() = "profile_id")));



CREATE POLICY "Users can view all trip financial plans" ON "public"."trip_financial_plans" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Users insert own profile" ON "public"."profiles" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Users update own profile" ON "public"."profiles" FOR UPDATE TO "authenticated" USING (("auth"."uid"() = "id")) WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Users view own roles" ON "public"."user_roles" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."gallery_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."maintenance_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."maintenance_records" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."motorcycles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."news" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."poll_options" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."poll_votes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."polls" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."route_photos" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."routes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."site_content" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."trip_financial_plans" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_roles" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";





GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




























































































































































REVOKE ALL ON FUNCTION "public"."claim_admin_if_first"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."claim_admin_if_first"() TO "authenticated";



REVOKE ALL ON FUNCTION "public"."handle_new_user"() FROM PUBLIC;



REVOKE ALL ON FUNCTION "public"."has_role"("_user_id" "uuid", "_role" "public"."app_role") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."has_role"("_user_id" "uuid", "_role" "public"."app_role") TO "authenticated";
GRANT ALL ON FUNCTION "public"."has_role"("_user_id" "uuid", "_role" "public"."app_role") TO "service_role";



REVOKE ALL ON FUNCTION "public"."set_updated_at"() FROM PUBLIC;


















GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."gallery_items" TO "anon";
GRANT ALL ON TABLE "public"."gallery_items" TO "authenticated";
GRANT ALL ON TABLE "public"."gallery_items" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."maintenance_items" TO "anon";
GRANT ALL ON TABLE "public"."maintenance_items" TO "authenticated";
GRANT ALL ON TABLE "public"."maintenance_items" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."maintenance_records" TO "anon";
GRANT ALL ON TABLE "public"."maintenance_records" TO "authenticated";
GRANT ALL ON TABLE "public"."maintenance_records" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."motorcycles" TO "anon";
GRANT ALL ON TABLE "public"."motorcycles" TO "authenticated";
GRANT ALL ON TABLE "public"."motorcycles" TO "service_role";



GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."news" TO "anon";
GRANT ALL ON TABLE "public"."news" TO "authenticated";
GRANT ALL ON TABLE "public"."news" TO "service_role";



GRANT ALL ON TABLE "public"."poll_options" TO "anon";
GRANT ALL ON TABLE "public"."poll_options" TO "authenticated";
GRANT ALL ON TABLE "public"."poll_options" TO "service_role";



GRANT ALL ON TABLE "public"."poll_votes" TO "anon";
GRANT ALL ON TABLE "public"."poll_votes" TO "authenticated";
GRANT ALL ON TABLE "public"."poll_votes" TO "service_role";



GRANT ALL ON TABLE "public"."polls" TO "anon";
GRANT ALL ON TABLE "public"."polls" TO "authenticated";
GRANT ALL ON TABLE "public"."polls" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."route_photos" TO "anon";
GRANT ALL ON TABLE "public"."route_photos" TO "authenticated";
GRANT ALL ON TABLE "public"."route_photos" TO "service_role";



GRANT ALL ON TABLE "public"."routes" TO "anon";
GRANT ALL ON TABLE "public"."routes" TO "authenticated";
GRANT ALL ON TABLE "public"."routes" TO "service_role";



GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."site_content" TO "anon";
GRANT ALL ON TABLE "public"."site_content" TO "authenticated";
GRANT ALL ON TABLE "public"."site_content" TO "service_role";



GRANT ALL ON TABLE "public"."trip_financial_plans" TO "anon";
GRANT ALL ON TABLE "public"."trip_financial_plans" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."trip_financial_plans" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."user_roles" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."user_roles" TO "authenticated";
GRANT ALL ON TABLE "public"."user_roles" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT UPDATE ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT UPDATE ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT UPDATE ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO "service_role";































