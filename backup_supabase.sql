--
-- PostgreSQL database dump
--

\restrict 0W6mHonHGKrzXZTdYL8OfdEPIb3aiixaGHfdNPJpUoZtU4VurUTmpizRX5UJKcI

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA _realtime;


ALTER SCHEMA _realtime OWNER TO postgres;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: app_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.app_role AS ENUM (
    'admin',
    'member',
    'blog_admin'
);


ALTER TYPE public.app_role OWNER TO postgres;

--
-- Name: content_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.content_status AS ENUM (
    'draft',
    'published'
);


ALTER TYPE public.content_status OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
begin
    if not exists (
        select 1
        from pg_event_trigger_ddl_commands() ev
        join pg_catalog.pg_extension e on ev.objid = e.oid
        where e.extname = 'pg_graphql'
    ) then
        return;
    end if;

    drop function if exists graphql_public.graphql;
    create or replace function graphql_public.graphql(
        "operationName" text default null,
        query text default null,
        variables jsonb default null,
        extensions jsonb default null
    )
        returns jsonb
        language sql
    as $$
        select graphql.resolve(
            query := query,
            variables := coalesce(variables, '{}'),
            "operationName" := "operationName",
            extensions := extensions
        );
    $$;

    -- Attach the wrapper to the extension so DROP EXTENSION cascades to it,
    -- which in turn triggers set_graphql_placeholder to reinstall the "not enabled" stub.
    alter extension pg_graphql add function graphql_public.graphql(text, text, jsonb, jsonb);

    grant usage on schema graphql to postgres, anon, authenticated, service_role;
    grant execute on function graphql.resolve to postgres, anon, authenticated, service_role;
    grant usage on schema graphql to postgres with grant option;
    grant usage on schema graphql_public to postgres with grant option;
end;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: claim_admin_if_first(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.claim_admin_if_first() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


ALTER FUNCTION public.claim_admin_if_first() OWNER TO postgres;

--
-- Name: delete_user_completely(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_user_completely(target_user_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth'
    AS $$
BEGIN
  IF NOT public.has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  -- Deleting from auth.users cascades to public.profiles and other related tables
  DELETE FROM auth.users WHERE id = target_user_id;
END;
$$;


ALTER FUNCTION public.delete_user_completely(target_user_id uuid) OWNER TO postgres;

--
-- Name: get_todays_birthdays(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_todays_birthdays() RETURNS TABLE(id uuid, full_name text, nickname text, avatar_url text, birthdate date)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY 
  SELECT p.id, p.full_name, p.nickname, p.avatar_url, p.birthdate
  FROM public.profiles p
  WHERE EXTRACT(MONTH FROM p.birthdate) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(DAY FROM p.birthdate) = EXTRACT(DAY FROM CURRENT_DATE);
END;
$$;


ALTER FUNCTION public.get_todays_birthdays() OWNER TO postgres;

--
-- Name: get_user_partner_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_partner_id() RETURNS uuid
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT partner_id FROM public.profiles WHERE id = auth.uid() LIMIT 1;
$$;


ALTER FUNCTION public.get_user_partner_id() OWNER TO postgres;

--
-- Name: get_users_for_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_users_for_admin() RETURNS TABLE(id uuid, email character varying, full_name text, banned_until timestamp with time zone, created_at timestamp with time zone, role public.app_role)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


ALTER FUNCTION public.get_users_for_admin() OWNER TO postgres;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
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


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: has_role(uuid, public.app_role); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.has_role(_user_id uuid, _role public.app_role) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role)
$$;


ALTER FUNCTION public.has_role(_user_id uuid, _role public.app_role) OWNER TO postgres;

--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

--
-- Name: set_user_role(uuid, public.app_role); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_user_role(target_user_id uuid, new_role public.app_role) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


ALTER FUNCTION public.set_user_role(target_user_id uuid, new_role public.app_role) OWNER TO postgres;

--
-- Name: sync_partner_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sync_partner_id() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
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


ALTER FUNCTION public.sync_partner_id() OWNER TO postgres;

--
-- Name: toggle_user_ban(uuid, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.toggle_user_ban(target_user_id uuid, ban boolean) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


ALTER FUNCTION public.toggle_user_ban(target_user_id uuid, ban boolean) OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
    -- Regclass of the table e.g. public.notes
    entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

    -- I, U, D, T: insert, update ...
    action realtime.action = (
        case wal ->> 'action'
            when 'I' then 'INSERT'
            when 'U' then 'UPDATE'
            when 'D' then 'DELETE'
            else 'ERROR'
        end
    );

    -- Is row level security enabled for the table
    is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

    subscriptions realtime.subscription[] = array_agg(subs)
        from
            realtime.subscription subs
        where
            subs.entity = entity_
            -- Filter by action early - only get subscriptions interested in this action
            -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
            and (subs.action_filter = '*' or subs.action_filter = action::text);

    -- Subscription vars
    working_role regrole;
    working_selected_columns text[];
    claimed_role regrole;
    claims jsonb;

    subscription_id uuid;
    subscription_has_access bool;
    visible_to_subscription_ids uuid[] = '{}';

    -- structured info for wal's columns
    columns realtime.wal_column[];
    -- previous identity values for update/delete
    old_columns realtime.wal_column[];

    error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

    -- Primary jsonb output for record
    output jsonb;

    -- Loop record for iterating unique roles (outer loop)
    role_record record;
    -- Loop record for iterating unique selected_columns within a role (inner loop)
    cols_record record;
    -- Subscription ids visible at the role level (before fanning out by selected_columns)
    visible_role_sub_ids uuid[] = '{}';

begin
    perform set_config('role', null, true);

    columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'columns') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    old_columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'identity') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    for role_record in
        select claims_role
        from (select distinct claims_role from unnest(subscriptions)) t
        order by claims_role::text
    loop
        working_role := role_record.claims_role;

        -- Update `is_selectable` for columns and old_columns (once per role)
        columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(columns) c;

        old_columns =
                array_agg(
                    (
                        c.name,
                        c.type_name,
                        c.type_oid,
                        c.value,
                        c.is_pkey,
                        pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                    )::realtime.wal_column
                )
                from
                    unnest(old_columns) c;

        if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
            -- Fan out 400 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 400: Bad Request, no primary key']
                )::realtime.wal_rls;
            end loop;

        -- The claims role does not have SELECT permission to the primary key of entity
        elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            -- Fan out 401 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 401: Unauthorized']
                )::realtime.wal_rls;
            end loop;

        else
            -- Create the prepared statement (once per role)
            if is_rls_enabled and action <> 'DELETE' then
                if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                    deallocate walrus_rls_stmt;
                end if;
                execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            -- Collect all visible subscription IDs for this role (filter check + RLS check)
            visible_role_sub_ids = '{}';

            for subscription_id, claims in (
                    select
                        subs.subscription_id,
                        subs.claims
                    from
                        unnest(subscriptions) subs
                    where
                        subs.entity = entity_
                        and subs.claims_role = working_role
                        and (
                            realtime.is_visible_through_filters(columns, subs.filters)
                            or (
                              action = 'DELETE'
                              and realtime.is_visible_through_filters(old_columns, subs.filters)
                            )
                        )
            ) loop

                if not is_rls_enabled or action = 'DELETE' then
                    visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                else
                    -- Check if RLS allows the role to see the record
                    perform
                        -- Trim leading and trailing quotes from working_role because set_config
                        -- doesn't recognize the role as valid if they are included
                        set_config('role', trim(both '"' from working_role::text), true),
                        set_config('request.jwt.claims', claims::text, true);

                    execute 'execute walrus_rls_stmt' into subscription_has_access;

                    if subscription_has_access then
                        visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                    end if;
                end if;
            end loop;

            perform set_config('role', null, true);

            -- Inner loop: per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;

                output = jsonb_build_object(
                    'schema', wal ->> 'schema',
                    'table', wal ->> 'table',
                    'type', action,
                    'commit_timestamp', to_char(
                        ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                        'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
                    ),
                    'columns', (
                        select
                            jsonb_agg(
                                jsonb_build_object(
                                    'name', pa.attname,
                                    'type', pt.typname
                                )
                                order by pa.attnum asc
                            )
                        from
                            pg_attribute pa
                            join pg_type pt
                                on pa.atttypid = pt.oid
                            left join (
                                select unnest(conkey) as pkey_attnum
                                from pg_constraint
                                where conrelid = entity_ and contype = 'p'
                            ) pk on pk.pkey_attnum = pa.attnum
                        where
                            attrelid = entity_
                            and attnum > 0
                            and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
                            and (working_selected_columns is null or pa.attname = any(working_selected_columns) or pk.pkey_attnum is not null)
                    )
                )
                -- Add "record" key for insert and update
                || case
                    when action in ('INSERT', 'UPDATE') then
                        jsonb_build_object(
                            'record',
                            (
                                select
                                    jsonb_object_agg(
                                        -- if unchanged toast, get column name and value from old record
                                        coalesce((c).name, (oc).name),
                                        case
                                            when (c).name is null then (oc).value
                                            else (c).value
                                        end
                                    )
                                from
                                    unnest(columns) c
                                    full outer join unnest(old_columns) oc
                                        on (c).name = (oc).name
                                where
                                    coalesce((c).is_selectable, (oc).is_selectable)
                                    and (working_selected_columns is null or coalesce((c).name, (oc).name) = any(working_selected_columns) or coalesce((c).is_pkey, (oc).is_pkey))
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            )
                        )
                    else '{}'::jsonb
                end
                -- Add "old_record" key for update and delete
                || case
                    when action = 'UPDATE' then
                        jsonb_build_object(
                                'old_record',
                                (
                                    select jsonb_object_agg((c).name, (c).value)
                                    from unnest(old_columns) c
                                    where
                                        (c).is_selectable
                                        and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                        and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                )
                            )
                    when action = 'DELETE' then
                        jsonb_build_object(
                            'old_record',
                            (
                                select jsonb_object_agg((c).name, (c).value)
                                from unnest(old_columns) c
                                where
                                    (c).is_selectable
                                    and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                    and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                            )
                        )
                    else '{}'::jsonb
                end;

                -- Filter visible_role_sub_ids to those matching the current selected_columns group
                visible_to_subscription_ids = coalesce(
                    (
                        select array_agg(s.subscription_id)
                        from unnest(subscriptions) s
                        where s.claims_role = working_role
                          and (s.selected_columns is not distinct from working_selected_columns)
                          and s.subscription_id = any(visible_role_sub_ids)
                    ),
                    '{}'::uuid[]
                );

                return next (
                    output,
                    is_rls_enabled,
                    visible_to_subscription_ids,
                    case
                        when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                        else '{}'
                    end
                )::realtime.wal_rls;
            end loop;

        end if;
    end loop;

    perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT
    realtime.wal2json_escape_identifier(nsp.nspname::text)
    || '.'
    || realtime.wal2json_escape_identifier(pc.relname::text)
  FROM pg_class pc
  JOIN pg_namespace nsp ON pc.relnamespace = nsp.oid
  WHERE pc.oid = entity
$$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: send_binary(bytea, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, binary_payload, event, topic, private, extension)
    VALUES (generated_id, payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    col_names text[] = coalesce(
            array_agg(a.attname order by a.attnum),
            '{}'::text[]
        )
        from
            pg_catalog.pg_attribute a
        where
            a.attrelid = new.entity
            and a.attnum > 0
            and not a.attisdropped
            and pg_catalog.has_column_privilege(
                (new.claims ->> 'role'),
                a.attrelid,
                a.attnum,
                'SELECT'
            );
    filter realtime.user_defined_filter;
    col_type regtype;
    in_val jsonb;
    selected_col text;
begin
    for filter in select * from unnest(new.filters) loop
        if not filter.column_name = any(col_names) then
            raise exception 'invalid column for filter %', filter.column_name;
        end if;

        col_type = (
            select atttypid::regtype
            from pg_catalog.pg_attribute
            where attrelid = new.entity
                  and attname = filter.column_name
        );
        if col_type is null then
            raise exception 'failed to lookup type for column %', filter.column_name;
        end if;

        if filter.op = 'in'::realtime.equality_op then
            in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
            if coalesce(jsonb_array_length(in_val), 0) > 100 then
                raise exception 'too many values for `in` filter. Maximum 100';
            end if;
        else
            perform realtime.cast(filter.value, col_type);
        end if;
    end loop;

    if new.selected_columns is not null then
        for selected_col in select * from unnest(new.selected_columns) loop
            if not selected_col = any(col_names) then
                raise exception 'invalid column for select %', selected_col;
            end if;
        end loop;
    end if;

    new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value),
        '{}'
    ) from unnest(new.filters) f;

    new.selected_columns = (
        select array_agg(c order by c)
        from unnest(new.selected_columns) c
    );

    return new;
end;
$$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: wal2json_escape_identifier(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.wal2json_escape_identifier(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  -- Prefix `\`, `,`, `.`, and any whitespace with `\`
  SELECT regexp_replace(name, '([\\,.[:space:]])', '\\\1', 'g')
$$;


ALTER FUNCTION realtime.wal2json_escape_identifier(name text) OWNER TO supabase_admin;

--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
  BEGIN
    IF url IS NULL OR url = 'null' THEN
      RAISE EXCEPTION 'url argument is missing';
    END IF;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END
$$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.extensions OWNER TO supabase_admin;

--
-- Name: feature_flags; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.feature_flags (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.feature_flags OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE _realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL,
    migrations_ran integer DEFAULT 0,
    broadcast_adapter character varying(255) DEFAULT 'gen_rpc'::character varying,
    max_presence_events_per_second integer DEFAULT 1000,
    max_payload_size_in_kb integer DEFAULT 3000,
    max_client_presence_events_per_window integer,
    client_presence_window_ms integer,
    presence_enabled boolean DEFAULT false NOT NULL,
    feature_flags jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT jwt_secret_or_jwt_jwks_required CHECK (((jwt_secret IS NOT NULL) OR (jwt_jwks IS NOT NULL)))
);


ALTER TABLE _realtime.tenants OWNER TO supabase_admin;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- Name: gallery_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gallery_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text,
    caption text,
    image_url text NOT NULL,
    instagram_url text,
    sort_order integer DEFAULT 0 NOT NULL,
    status public.content_status DEFAULT 'draft'::public.content_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.gallery_items OWNER TO postgres;

--
-- Name: maintenance_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maintenance_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    motorcycle_id uuid NOT NULL,
    user_id uuid NOT NULL,
    name text NOT NULL,
    interval_km integer,
    interval_months integer,
    last_change_km integer,
    last_change_date date,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.maintenance_items OWNER TO postgres;

--
-- Name: maintenance_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maintenance_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    motorcycle_id uuid NOT NULL,
    maintenance_item_id uuid,
    user_id uuid NOT NULL,
    item_name text NOT NULL,
    service_date date DEFAULT CURRENT_DATE NOT NULL,
    km_at_service integer,
    cost numeric(10,2),
    workshop text,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.maintenance_records OWNER TO postgres;

--
-- Name: motorcycles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.motorcycles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    brand text NOT NULL,
    model text NOT NULL,
    year integer,
    plate text,
    color text,
    nickname text,
    current_km integer DEFAULT 0 NOT NULL,
    photo_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.motorcycles OWNER TO postgres;

--
-- Name: news; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.news (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    excerpt text,
    content text,
    cover_url text,
    tag text,
    status public.content_status DEFAULT 'draft'::public.content_status NOT NULL,
    published_at timestamp with time zone,
    author_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.news OWNER TO postgres;

--
-- Name: poll_options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poll_options (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    poll_id uuid NOT NULL,
    text text NOT NULL,
    image_url text,
    "order" integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.poll_options OWNER TO postgres;

--
-- Name: poll_votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poll_votes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    poll_id uuid NOT NULL,
    option_id uuid NOT NULL,
    profile_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.poll_votes OWNER TO postgres;

--
-- Name: polls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.polls (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    image_url text,
    status text DEFAULT 'active'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT polls_status_check CHECK ((status = ANY (ARRAY['active'::text, 'archived'::text])))
);


ALTER TABLE public.polls OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    full_name text,
    nickname text,
    city text,
    phone text,
    avatar_url text,
    instagram text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    birthdate date,
    partner_id uuid,
    member_type text DEFAULT 'piloto'::text,
    CONSTRAINT profiles_member_type_check CHECK ((member_type = ANY (ARRAY['piloto'::text, 'garupa'::text])))
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: route_photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.route_photos (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    route_id uuid,
    profile_id uuid,
    photo_url text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.route_photos OWNER TO postgres;

--
-- Name: routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    destination text NOT NULL,
    start_date timestamp with time zone NOT NULL,
    meeting_point text NOT NULL,
    meeting_time time without time zone NOT NULL,
    estimated_distance_km numeric,
    waze_url text,
    media_url text,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    status text DEFAULT 'open'::text NOT NULL,
    estimated_duration_mins integer,
    visited_places text,
    route_type text DEFAULT 'passeio'::text,
    has_financial_plan boolean DEFAULT false,
    CONSTRAINT routes_route_type_check CHECK ((route_type = ANY (ARRAY['passeio'::text, 'viagem'::text])))
);


ALTER TABLE public.routes OWNER TO postgres;

--
-- Name: site_content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.site_content (
    key text NOT NULL,
    value jsonb DEFAULT '{}'::jsonb NOT NULL,
    status public.content_status DEFAULT 'published'::public.content_status NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.site_content OWNER TO postgres;

--
-- Name: trip_financial_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trip_financial_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    route_id uuid NOT NULL,
    profile_id uuid NOT NULL,
    costs jsonb DEFAULT '{}'::jsonb NOT NULL,
    observations jsonb DEFAULT '{}'::jsonb NOT NULL,
    fuel_calc jsonb DEFAULT '{}'::jsonb NOT NULL,
    has_passenger boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.trip_financial_plans OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role public.app_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_07_06; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_07_06 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_07_06 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_07_07; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_07_07 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_07_07 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_07_08; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_07_08 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_07_08 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_07_09; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_07_09 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_07_09 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_07_10; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_07_10 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_07_10 OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    selected_columns text[],
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: iceberg_namespaces; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.iceberg_namespaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    catalog_id uuid NOT NULL
);


ALTER TABLE storage.iceberg_namespaces OWNER TO supabase_storage_admin;

--
-- Name: iceberg_tables; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.iceberg_tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    namespace_id uuid NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    location text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    remote_table_id text,
    shard_key text,
    shard_id text,
    catalog_id uuid NOT NULL
);


ALTER TABLE storage.iceberg_tables OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- Name: messages_2026_07_06; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_07_06 FOR VALUES FROM ('2026-07-06 00:00:00') TO ('2026-07-07 00:00:00');


--
-- Name: messages_2026_07_07; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_07_07 FOR VALUES FROM ('2026-07-07 00:00:00') TO ('2026-07-08 00:00:00');


--
-- Name: messages_2026_07_08; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_07_08 FOR VALUES FROM ('2026-07-08 00:00:00') TO ('2026-07-09 00:00:00');


--
-- Name: messages_2026_07_09; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_07_09 FOR VALUES FROM ('2026-07-09 00:00:00') TO ('2026-07-10 00:00:00');


--
-- Name: messages_2026_07_10; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_07_10 FOR VALUES FROM ('2026-07-10 00:00:00') TO ('2026-07-11 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.extensions (id, type, settings, tenant_external_id, inserted_at, updated_at) FROM stdin;
931fca30-1cfc-46c1-9758-49fb486113fa	postgres_cdc_rls	{"region": "us-east-1", "db_host": "TNM+/CcKIHeUSzlv+sQHYfNJPrFVj12yIcAZxB1PHd5PNrrhma6I8nd28t/mto4/", "db_name": "sWBpZNdjggEPTQVlI52Zfw==", "db_port": "+enMDFi1J/3IrrquHHwUmA==", "db_user": "uxbEq/zz8DXVD53TOI1zmw==", "slot_name": "supabase_realtime_replication_slot", "db_password": "sWBpZNdjggEPTQVlI52Zfw==", "publication": "supabase_realtime", "ssl_enforced": false, "poll_interval_ms": 100, "poll_max_changes": 100, "poll_max_record_bytes": 1048576}	realtime-dev	2026-07-07 12:32:05	2026-07-07 12:32:05
\.


--
-- Data for Name: feature_flags; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.feature_flags (id, name, enabled, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.schema_migrations (version, inserted_at) FROM stdin;
20210706140551	2026-06-24 15:37:20
20220329161857	2026-06-24 15:37:20
20220410212326	2026-06-24 15:37:20
20220506102948	2026-06-24 15:37:20
20220527210857	2026-06-24 15:37:20
20220815211129	2026-06-24 15:37:20
20220815215024	2026-06-24 15:37:20
20220818141501	2026-06-24 15:37:20
20221018173709	2026-06-24 15:37:20
20221102172703	2026-06-24 15:37:20
20221223010058	2026-06-24 15:37:20
20230110180046	2026-06-24 15:37:20
20230810220907	2026-06-24 15:37:20
20230810220924	2026-06-24 15:37:20
20231024094642	2026-06-24 15:37:20
20240306114423	2026-06-24 15:37:20
20240418082835	2026-06-24 15:37:20
20240625211759	2026-06-24 15:37:20
20240704172020	2026-06-24 15:37:20
20240902173232	2026-06-24 15:37:20
20241106103258	2026-06-24 15:37:20
20250424203323	2026-06-24 15:37:20
20250613072131	2026-06-24 15:37:20
20250711044927	2026-06-24 15:37:20
20250811121559	2026-06-24 15:37:20
20250926223044	2026-06-24 15:37:20
20251204170944	2026-06-24 15:37:20
20251218000543	2026-06-24 15:37:21
20260209232800	2026-06-24 15:37:21
20260304000000	2026-06-24 15:37:21
20260422000000	2026-06-24 15:37:21
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.tenants (id, name, external_id, jwt_secret, max_concurrent_users, inserted_at, updated_at, max_events_per_second, postgres_cdc_default, max_bytes_per_second, max_channels_per_client, max_joins_per_second, suspend, jwt_jwks, notify_private_alpha, private_only, migrations_ran, broadcast_adapter, max_presence_events_per_second, max_payload_size_in_kb, max_client_presence_events_per_window, client_presence_window_ms, presence_enabled, feature_flags) FROM stdin;
000fd6c1-0a6a-4104-acb8-f135d0bcc14e	realtime-dev	realtime-dev	iNjicxc4+llvc9wovDvqymwfnj9teWMlyOIbJ8Fh6j2WNU8CIJ2ZgjR6MUIKqSmeDmvpsKLsZ9jgXJmQPpwL8w==	200	2026-07-07 12:32:05	2026-07-07 12:32:06	100	postgres_cdc_rls	100000	100	100	f	{"keys": [{"x": "M5Sjqn5zwC9Kl1zVfUUGvv9boQjCGd45G8sdopBExB4", "y": "P6IXMvA2WYXSHSOMTBH2jsw_9rrzGy89FjPf6oOsIxQ", "alg": "ES256", "crv": "P-256", "ext": true, "kid": "b81269f1-21d8-4f2e-b719-c2240a840d90", "kty": "EC", "use": "sig", "key_ops": ["verify"]}, {"k": "c3VwZXItc2VjcmV0LWp3dC10b2tlbi13aXRoLWF0LWxlYXN0LTMyLWNoYXJhY3RlcnMtbG9uZw", "kty": "oct"}]}	f	f	75	gen_rpc	1000	3000	\N	\N	f	{}
\.


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	4b5799c8-ec19-40a4-9bba-8dd03c6eeaba	{"action":"user_signedup","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-06-24 15:39:34.433838+00	
00000000-0000-0000-0000-000000000000	51d4a756-3c06-470c-a197-822fa2da2d15	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 15:39:34.455398+00	
00000000-0000-0000-0000-000000000000	57202843-8d70-451d-92ef-3511c72572e8	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 15:39:40.298569+00	
00000000-0000-0000-0000-000000000000	54479ff4-25f3-4522-a0ad-8f8787f19934	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 15:42:05.466194+00	
00000000-0000-0000-0000-000000000000	93c667ca-db19-48e4-b000-7742e8bb7363	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 15:42:18.076468+00	
00000000-0000-0000-0000-000000000000	690e0492-2991-4d7d-b888-d222a5cf4ba0	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 15:45:46.863212+00	
00000000-0000-0000-0000-000000000000	65bed442-2090-41d9-bf4d-0a2e2fa958d3	{"action":"user_signedup","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-06-24 15:46:23.733603+00	
00000000-0000-0000-0000-000000000000	c39ccfad-5fd3-4bac-b930-893b6d3ac865	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 15:46:23.753299+00	
00000000-0000-0000-0000-000000000000	785086cb-a888-44e1-90cb-4732f8c85906	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 15:46:27.858923+00	
00000000-0000-0000-0000-000000000000	fbfd787c-8ce8-4cd9-a85a-72e079629db9	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 15:46:45.38784+00	
00000000-0000-0000-0000-000000000000	9e4a0b3a-d0e4-4ffe-81b3-c4e2d7ec3d87	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 15:47:12.090091+00	
00000000-0000-0000-0000-000000000000	3eec33b0-7243-486c-bd64-8f2924822a46	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 15:54:36.965452+00	
00000000-0000-0000-0000-000000000000	080ee9aa-c74f-4298-9ca0-b5a1eb6d9c39	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 15:54:47.207676+00	
00000000-0000-0000-0000-000000000000	e8ccb17a-6464-4aa9-9e9d-77ef8c86aba1	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 16:24:03.466823+00	
00000000-0000-0000-0000-000000000000	312378ba-1d08-4187-a943-9dcf139aed83	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 17:00:18.753722+00	
00000000-0000-0000-0000-000000000000	c4649cb6-9a84-4e28-bf23-0c7781717169	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 17:58:45.0891+00	
00000000-0000-0000-0000-000000000000	7fed6924-ed3e-450f-bf73-ab7ebab7965a	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 17:58:45.089921+00	
00000000-0000-0000-0000-000000000000	ed974ae8-701a-4a0a-a5e9-ac39245fe542	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 18:17:53.54465+00	
00000000-0000-0000-0000-000000000000	c762ce3a-81aa-4652-933d-74af476a6854	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 18:17:53.545467+00	
00000000-0000-0000-0000-000000000000	8d7fc8aa-fb29-490c-b276-3ceff3f05ac1	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 18:56:52.36551+00	
00000000-0000-0000-0000-000000000000	f9781f7b-b711-45c6-bef5-0351d7033244	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 18:56:52.366515+00	
00000000-0000-0000-0000-000000000000	45ec50fe-eda5-4e41-bb82-f91e04159f80	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 19:37:34.792764+00	
00000000-0000-0000-0000-000000000000	774c2637-5141-4af1-9fcd-74578acca617	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 19:37:34.794121+00	
00000000-0000-0000-0000-000000000000	bb4700a5-39ff-4479-be06-a5ad2cc12fc3	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 19:57:03.67173+00	
00000000-0000-0000-0000-000000000000	7c065fa2-d1a6-49b5-8f75-d78518b4f33f	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 19:57:03.672892+00	
00000000-0000-0000-0000-000000000000	e8bed2ad-bc9b-4865-baa6-8014f27e5699	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 20:55:22.606846+00	
00000000-0000-0000-0000-000000000000	c6dcb35c-edca-4957-bfb4-410ee4f68aa6	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 20:55:22.607993+00	
00000000-0000-0000-0000-000000000000	87b17db7-f317-40cb-bdfb-3c257cfd53f6	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 21:02:50.316736+00	
00000000-0000-0000-0000-000000000000	68bf2a55-bbfb-4a93-9e55-80a51294f6c1	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 21:02:50.317794+00	
00000000-0000-0000-0000-000000000000	1212ceed-ea9e-46d1-87a2-cc451146a694	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 21:02:52.213964+00	
00000000-0000-0000-0000-000000000000	ae1d12a1-87b8-4924-a42f-2b579fefe465	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 21:03:09.153659+00	
00000000-0000-0000-0000-000000000000	eb85c611-5370-4c9f-8863-9f0506c2c61b	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 21:04:06.392189+00	
00000000-0000-0000-0000-000000000000	87fedc82-0e68-46e0-9edf-cb58c1467d0d	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 21:04:16.83693+00	
00000000-0000-0000-0000-000000000000	47839577-6e02-4160-acb2-78326ac5045a	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 21:05:56.430754+00	
00000000-0000-0000-0000-000000000000	762dd038-a88c-4d18-8aac-ef2cb3239d87	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 22:04:08.113475+00	
00000000-0000-0000-0000-000000000000	17ae73c5-72ba-455c-bda9-bc5a97ee1e9a	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 22:04:08.114491+00	
00000000-0000-0000-0000-000000000000	af8072ae-57b2-41ec-b0bf-33262256d6e7	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 23:02:38.217237+00	
00000000-0000-0000-0000-000000000000	4eba7d0b-12e6-42f6-b905-7af43b6c17c3	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 23:02:38.218099+00	
00000000-0000-0000-0000-000000000000	e3f9d1f2-aea0-4658-96b0-7858ac71c22e	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 00:01:08.298909+00	
00000000-0000-0000-0000-000000000000	b4bfe15a-cd94-4611-95c0-43b1c908d907	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 00:01:08.299999+00	
00000000-0000-0000-0000-000000000000	6185337e-b7aa-4279-9d58-b2e56449b913	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 00:21:34.095789+00	
00000000-0000-0000-0000-000000000000	0fb86a28-8971-4a59-9ee6-336480db4c04	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 00:21:34.096763+00	
00000000-0000-0000-0000-000000000000	148a9a30-ba4e-471e-9e7a-ab415b95da0b	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 00:59:33.27485+00	
00000000-0000-0000-0000-000000000000	1f794612-25a3-4442-aaea-7d4fbae45871	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 00:59:33.275883+00	
00000000-0000-0000-0000-000000000000	255c86e8-c53e-4378-868b-5b7cf8218f0e	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 11:38:02.02693+00	
00000000-0000-0000-0000-000000000000	96a3a91c-47f3-4f53-a5bf-5b4df70b76f7	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 11:38:02.027658+00	
00000000-0000-0000-0000-000000000000	c45dac77-0099-4006-9a9e-a04ab925a096	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 11:39:32.682985+00	
00000000-0000-0000-0000-000000000000	4fbb6b06-5eb0-46a0-b452-53e5083b850f	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 11:39:32.683782+00	
00000000-0000-0000-0000-000000000000	77895252-2393-4613-bcfa-e3f50df5686f	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 12:37:44.409256+00	
00000000-0000-0000-0000-000000000000	223bbd66-e931-4572-8b66-0881ea420006	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 12:37:44.409964+00	
00000000-0000-0000-0000-000000000000	0a6ea33f-9213-47f1-a22f-23f481b041e8	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 13:35:56.202717+00	
00000000-0000-0000-0000-000000000000	9f8b1e9c-ae22-4889-8313-2279f7d41b23	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 13:35:56.203495+00	
00000000-0000-0000-0000-000000000000	8503f5f2-b242-4166-9b13-0fc28b7752cc	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 13:51:51.91861+00	
00000000-0000-0000-0000-000000000000	99f4dcba-1c16-43dd-8bc2-4d99151ddf09	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 13:51:51.919422+00	
00000000-0000-0000-0000-000000000000	6a9d52d5-26f6-4a75-8b17-baf76d600302	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:34:03.211612+00	
00000000-0000-0000-0000-000000000000	6053425e-ac6b-4420-b1ba-bc0e295735e7	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:34:03.21251+00	
00000000-0000-0000-0000-000000000000	09825325-6a8e-45f5-9399-f025c3077421	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:34:03.290493+00	
00000000-0000-0000-0000-000000000000	d6112719-a604-4251-9b5c-c41694019458	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 15:29:02.481157+00	
00000000-0000-0000-0000-000000000000	13a691e3-ffb4-4802-a273-7b97801d9da5	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 15:29:02.481992+00	
00000000-0000-0000-0000-000000000000	9dfe384a-ea6c-4724-ac69-48b7548638d2	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 15:32:33.286725+00	
00000000-0000-0000-0000-000000000000	114f8fcd-468e-4d1b-836e-ad5668442a6f	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 15:32:33.287424+00	
00000000-0000-0000-0000-000000000000	2ecf681d-ab82-4b29-941e-3b4ce111fd8f	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 15:32:33.378263+00	
00000000-0000-0000-0000-000000000000	07dba710-51a5-46bc-bb09-e43ff243a2f5	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 16:31:03.27851+00	
00000000-0000-0000-0000-000000000000	3c4642d1-2292-41cb-9b7e-2ac8c8255087	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 16:31:03.279325+00	
00000000-0000-0000-0000-000000000000	9331d43c-a93e-42ce-8318-33200f6f03c7	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 16:31:03.302325+00	
00000000-0000-0000-0000-000000000000	99a84f01-2982-4d72-901a-8b2db6ee189d	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 17:29:33.30229+00	
00000000-0000-0000-0000-000000000000	d139d695-11d1-4e1e-99b6-81577dc9c8ab	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 17:29:33.30298+00	
00000000-0000-0000-0000-000000000000	f32a6e8b-292e-42e7-85be-72ef5e1b84ce	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 17:29:33.38388+00	
00000000-0000-0000-0000-000000000000	9a5eb795-1be8-4109-8636-6db6720a4e70	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 18:12:29.34191+00	
00000000-0000-0000-0000-000000000000	879e970c-3ca7-41bb-ae69-bfd90ffceeeb	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 18:12:29.342573+00	
00000000-0000-0000-0000-000000000000	5c377ff8-e66e-4d75-a640-de47e7729401	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 18:27:51.327708+00	
00000000-0000-0000-0000-000000000000	d282438c-e03b-43dc-b3e5-6fa28485fe0a	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 18:27:51.328757+00	
00000000-0000-0000-0000-000000000000	ecb693c2-578f-4225-a93f-a951d1bddd4d	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-25 18:44:16.762553+00	
00000000-0000-0000-0000-000000000000	23e82574-a47e-4ce3-87b5-ae4cb0c94b60	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 18:44:20.261479+00	
00000000-0000-0000-0000-000000000000	1ced3861-7db2-430b-af33-97f925a22395	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 18:44:45.500339+00	
00000000-0000-0000-0000-000000000000	81196d90-6124-4f8e-8519-29b6d7c2be37	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-25 18:46:29.605907+00	
00000000-0000-0000-0000-000000000000	54b70b34-a68f-4393-a268-d97b6d7d9ae0	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 18:46:31.51499+00	
00000000-0000-0000-0000-000000000000	8f90137c-2c69-42f0-b4be-9113df024533	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 18:46:40.556653+00	
00000000-0000-0000-0000-000000000000	fe84900e-a900-4f28-980f-88ced0c2151a	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-25 19:21:53.132409+00	
00000000-0000-0000-0000-000000000000	e66ad655-6948-4c16-8162-6199467d96db	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 19:21:56.113501+00	
00000000-0000-0000-0000-000000000000	0175c82f-6ea1-460e-96b3-3341649fdcc9	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 19:42:35.740632+00	
00000000-0000-0000-0000-000000000000	b87041be-6e34-42e3-8f3f-f6e27748be83	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-25 19:47:35.919686+00	
00000000-0000-0000-0000-000000000000	2b2320f8-589e-452b-850d-b62c7f44703b	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-25 20:08:09.787965+00	
00000000-0000-0000-0000-000000000000	7616829a-0f24-476e-a859-94948b417863	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 20:08:17.404498+00	
00000000-0000-0000-0000-000000000000	f99831bf-165a-4ce2-abf1-6be3f517b96e	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 21:05:07.980055+00	
00000000-0000-0000-0000-000000000000	99db747b-c1ec-40c3-8039-fe6b742d76da	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 21:29:45.732777+00	
00000000-0000-0000-0000-000000000000	064c7f2a-7819-4523-97d9-cd8c824f58de	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 21:29:45.733626+00	
00000000-0000-0000-0000-000000000000	8358266a-f934-429c-99ea-ee25ebb6d678	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 21:30:44.801389+00	
00000000-0000-0000-0000-000000000000	fad00888-0b83-4794-9e1c-65e486ee4479	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 22:01:20.188087+00	
00000000-0000-0000-0000-000000000000	2833eb3a-e9f3-4130-8573-92108e74c1fe	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 22:53:53.794335+00	
00000000-0000-0000-0000-000000000000	26962888-6a7e-40fc-8efc-9ddd56389be9	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 22:53:53.795281+00	
00000000-0000-0000-0000-000000000000	d0d9d720-d68c-4377-a3b7-681825277cae	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 22:54:06.68714+00	
00000000-0000-0000-0000-000000000000	ad53a4da-be91-4bb0-bcf2-a2d097f78818	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 22:54:06.687884+00	
00000000-0000-0000-0000-000000000000	ebfa2b46-de9c-4fd7-b97a-af75738204c1	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 22:59:41.863455+00	
00000000-0000-0000-0000-000000000000	9186b6dd-76f9-4674-a12d-6c65d1cdb46d	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 22:59:41.864525+00	
00000000-0000-0000-0000-000000000000	02d55811-a74d-4c46-9fef-7838a5635dad	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 23:57:41.957515+00	
00000000-0000-0000-0000-000000000000	84506e1e-105f-4947-869e-94598e1e05c0	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 23:57:41.958325+00	
00000000-0000-0000-0000-000000000000	e754cb72-e6b9-4dda-bdee-80178b5f5f87	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 08:37:39.920146+00	
00000000-0000-0000-0000-000000000000	efa8ab51-f4df-4eab-b517-9cb4282d8392	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 08:37:39.921016+00	
00000000-0000-0000-0000-000000000000	2aa6399c-0cbe-4f69-9ed5-3589d84ce083	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 10:53:39.051518+00	
00000000-0000-0000-0000-000000000000	29d98fe2-f4b3-4b72-8f09-0551dc883b38	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 10:53:39.05233+00	
00000000-0000-0000-0000-000000000000	93f5c8e0-86e9-41c0-b47c-43d5168b7108	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 10:59:40.36188+00	
00000000-0000-0000-0000-000000000000	e3dcb932-409d-45ff-aaae-9dec83891791	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 10:59:40.362643+00	
00000000-0000-0000-0000-000000000000	2b4c95ed-3fa9-4996-9e98-bc1c1eec3f11	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 11:12:24.437595+00	
00000000-0000-0000-0000-000000000000	3faeb951-7783-4929-bbb6-565f395c27d5	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 11:12:24.438274+00	
00000000-0000-0000-0000-000000000000	059de523-7daa-4413-a7e0-5f74d9a6f5df	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 11:51:39.630989+00	
00000000-0000-0000-0000-000000000000	64b0d9e9-5cad-4414-b15d-a4b97e032c1b	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 11:51:39.631725+00	
00000000-0000-0000-0000-000000000000	1f1f0609-3cd9-49a6-9ef1-79d6bf738b1f	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 12:37:11.381896+00	
00000000-0000-0000-0000-000000000000	a1b90638-023c-4c03-825b-c34d29be0673	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 12:37:11.382556+00	
00000000-0000-0000-0000-000000000000	0b8595b7-f090-4553-a1fc-b85e869fb01d	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 15:30:55.590092+00	
00000000-0000-0000-0000-000000000000	4d88cd75-fd0b-4fa6-8a44-2e60f0121503	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 15:30:55.590822+00	
00000000-0000-0000-0000-000000000000	6b2e6c79-a75d-410a-b80e-9493e317ef77	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 15:31:23.334841+00	
00000000-0000-0000-0000-000000000000	08ed879c-4154-46e6-ac04-142beb2c04d6	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 15:31:23.335579+00	
00000000-0000-0000-0000-000000000000	e6a81899-d5eb-4188-b674-409b19505223	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-26 15:32:22.636635+00	
00000000-0000-0000-0000-000000000000	454a5b43-99fe-4a65-90f3-bb099c047687	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-26 16:45:41.287475+00	
00000000-0000-0000-0000-000000000000	d569ade6-0814-43cc-8fc7-6ec4174aa3a3	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:43:46.62769+00	
00000000-0000-0000-0000-000000000000	f8479db4-fa91-4cb6-9e96-9b96489341c0	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:43:46.62844+00	
00000000-0000-0000-0000-000000000000	f5df6175-a627-42bd-94bd-eeb6f8732992	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-26 17:46:19.976328+00	
00000000-0000-0000-0000-000000000000	831e6135-41ab-4c25-9ce7-860db64f5b2a	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-26 17:53:58.403099+00	
00000000-0000-0000-0000-000000000000	70b49f98-0e8d-4a9d-afc1-1be161fd0fd3	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-26 17:54:04.823771+00	
00000000-0000-0000-0000-000000000000	c1cc6e17-19ef-4c35-8753-74357de89f99	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-26 17:57:25.273585+00	
00000000-0000-0000-0000-000000000000	56ff211d-a144-4d32-9fe3-c57a92cb6886	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-26 18:09:15.67562+00	
00000000-0000-0000-0000-000000000000	91b0efc5-3b14-4a5f-81d3-73ba330b1a0d	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-26 18:09:18.229545+00	
00000000-0000-0000-0000-000000000000	5f7ad2fd-4752-4f12-b5dc-1fcf1d09b9d2	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-26 18:15:41.460118+00	
00000000-0000-0000-0000-000000000000	bd11b40a-3e7a-4329-9fb1-e52711ee1e1a	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-26 18:43:46.677006+00	
00000000-0000-0000-0000-000000000000	47e154ff-afb5-4a86-9792-81e3d39bdd8a	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 18:55:47.38902+00	
00000000-0000-0000-0000-000000000000	6a47fb99-b904-4d95-a95c-f256b329a2bf	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 18:55:47.390045+00	
00000000-0000-0000-0000-000000000000	b8774838-de41-4810-8297-e743f4025c9d	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:15:33.244375+00	
00000000-0000-0000-0000-000000000000	6ec30266-7e2d-4306-96f9-456a0dc22818	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:15:33.246072+00	
00000000-0000-0000-0000-000000000000	ce33c6d3-edfb-467d-8baf-b6f1f8845d78	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:16:02.793556+00	
00000000-0000-0000-0000-000000000000	b3701921-6f39-496b-8f01-037034f19739	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:16:02.794325+00	
00000000-0000-0000-0000-000000000000	08bb88e5-d490-455e-8c73-04e29e0cde69	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:53:57.928622+00	
00000000-0000-0000-0000-000000000000	84666a4a-48b8-4b36-b613-84be4780ba79	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:53:57.92945+00	
00000000-0000-0000-0000-000000000000	d0ef984f-f8a0-4be1-9d3f-793519f98930	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:54:42.433832+00	
00000000-0000-0000-0000-000000000000	d8758c59-8c9f-4782-8468-c78549bbfafa	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:54:42.434615+00	
00000000-0000-0000-0000-000000000000	88475b63-57be-4da5-bc8f-a5dec1549167	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-26 20:04:42.375138+00	
00000000-0000-0000-0000-000000000000	0a4a1424-e208-4e21-87b7-9b95c855b31b	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-26 20:05:38.375864+00	
00000000-0000-0000-0000-000000000000	c18ec283-7d28-487e-8c1c-8cd44a4d9ad9	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-26 20:07:36.730362+00	
00000000-0000-0000-0000-000000000000	00469afe-9b73-4015-b40d-9b90967b06d8	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:33:04.506144+00	
00000000-0000-0000-0000-000000000000	5d0feeff-8981-4f27-b972-302fb87c1bb1	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:33:04.507468+00	
00000000-0000-0000-0000-000000000000	9897fabb-08f4-4b9a-8d6d-71c0491e08c9	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-27 12:22:53.698391+00	
00000000-0000-0000-0000-000000000000	7c17216b-1ea9-4c36-8082-3b4cc6a8af64	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 13:52:49.869414+00	
00000000-0000-0000-0000-000000000000	228fdd5e-dc28-44ca-9857-f69aca774cfc	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 13:52:49.870167+00	
00000000-0000-0000-0000-000000000000	354caafe-bb84-423c-aef1-c95d269e87c6	{"action":"token_refreshed","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 11:25:03.601999+00	
00000000-0000-0000-0000-000000000000	1d5d2877-f40d-4e62-8c5d-4ead4eea8d57	{"action":"token_revoked","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 11:25:03.602988+00	
00000000-0000-0000-0000-000000000000	063dfaea-051e-4580-8137-1aff8d877418	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-29 11:26:40.290003+00	
00000000-0000-0000-0000-000000000000	48d0d895-e94f-4edb-8c39-47f478da2370	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 11:26:42.520819+00	
00000000-0000-0000-0000-000000000000	42a77ce5-b5a4-42d0-929b-478dd7a8d0c0	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-29 12:14:50.106267+00	
00000000-0000-0000-0000-000000000000	083126e2-1d36-46d4-91c0-21867448ea92	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 12:18:11.378027+00	
00000000-0000-0000-0000-000000000000	e09f111a-9c01-4b0a-8923-2d4ab831e6af	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 12:31:49.657697+00	
00000000-0000-0000-0000-000000000000	9897047b-9d5f-4e76-9a59-d158c3a34e91	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-29 12:33:35.760618+00	
00000000-0000-0000-0000-000000000000	ee49e9fe-ec11-4881-b1c3-d4df5e873959	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 12:33:41.146594+00	
00000000-0000-0000-0000-000000000000	fcebe4bf-198d-439a-83b3-16dd98c78c18	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-29 12:58:59.55264+00	
00000000-0000-0000-0000-000000000000	7fc1f8ab-8c97-47e8-8ee8-76398e49f3b8	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 12:59:11.596911+00	
00000000-0000-0000-0000-000000000000	6a4a4d43-e574-4d4d-9ec3-cdf8e54929b8	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 12:59:49.809865+00	
00000000-0000-0000-0000-000000000000	d968ef83-d7be-4920-a7bb-3be955644c88	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 13:14:45.37753+00	
00000000-0000-0000-0000-000000000000	4f8860f3-c7ba-4432-b39e-9b1d40d388b8	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-29 13:35:35.727442+00	
00000000-0000-0000-0000-000000000000	3a89c065-6032-4b67-a699-3dba567b6319	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 13:35:38.258417+00	
00000000-0000-0000-0000-000000000000	b2a8b9a7-4a8e-4daa-bb3a-cb7c8a000421	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-29 14:22:47.063661+00	
00000000-0000-0000-0000-000000000000	13805348-de16-4fba-ac8c-eecf82feb6b4	{"action":"user_signedup","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-06-29 14:23:33.531806+00	
00000000-0000-0000-0000-000000000000	fca03a2a-b2ee-4af8-ab7f-93b66284a381	{"action":"login","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 14:23:33.545246+00	
00000000-0000-0000-0000-000000000000	2ee245b0-f2a9-49a1-b294-a0a9939940b2	{"action":"login","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 14:23:44.824694+00	
00000000-0000-0000-0000-000000000000	2992b104-cf04-43c9-822e-cfe7dc03fc38	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 14:27:24.235092+00	
00000000-0000-0000-0000-000000000000	66c31749-1742-425d-b949-3b15b98f28a7	{"action":"token_refreshed","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 15:22:00.436732+00	
00000000-0000-0000-0000-000000000000	af99bab2-f816-40d5-b517-0b947a9ab3d0	{"action":"token_revoked","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 15:22:00.437509+00	
00000000-0000-0000-0000-000000000000	ecb27438-a4d3-4e36-b05b-31c91c7cf02d	{"action":"token_refreshed","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 19:09:24.145481+00	
00000000-0000-0000-0000-000000000000	cf47f842-2916-445a-baee-14a5a515b137	{"action":"token_revoked","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 19:09:24.146487+00	
00000000-0000-0000-0000-000000000000	6a0fbcfa-5631-419b-b75f-61eb3a2ada7b	{"action":"token_refreshed","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 20:07:52.290524+00	
00000000-0000-0000-0000-000000000000	926b89cd-fd51-4d6c-921d-7a3245aa1b38	{"action":"token_revoked","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 20:07:52.291264+00	
00000000-0000-0000-0000-000000000000	43b07fcb-d9b2-4594-a876-10a3b8f7f4f8	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 20:40:12.669772+00	
00000000-0000-0000-0000-000000000000	f8fdbc96-d117-4b75-9dad-31d427972082	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 20:40:12.673364+00	
00000000-0000-0000-0000-000000000000	44c2cfcc-0ca5-4579-b5cb-332366208c38	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-29 21:02:25.843537+00	
00000000-0000-0000-0000-000000000000	dc49b473-6175-4e60-9b4a-bf451c3e2281	{"action":"token_refreshed","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 21:26:38.259835+00	
00000000-0000-0000-0000-000000000000	4fe9281c-1491-4201-b7ef-f158758fd204	{"action":"token_revoked","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 21:26:38.260536+00	
00000000-0000-0000-0000-000000000000	00a82d48-5ce0-459d-a36f-2c47dc92fbb9	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 21:53:24.445294+00	
00000000-0000-0000-0000-000000000000	3ca4677b-7dfe-4565-bcbf-d407d26c4eac	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-29 21:53:24.446166+00	
00000000-0000-0000-0000-000000000000	3ecb9919-10d5-439c-9ab1-e3bd779e96bf	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 02:32:26.776627+00	
00000000-0000-0000-0000-000000000000	81761999-e908-4cd4-b1e3-c6b753cfa440	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 02:32:26.777596+00	
00000000-0000-0000-0000-000000000000	443239d1-357d-4dc6-aef2-c127bf616136	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 10:29:46.690865+00	
00000000-0000-0000-0000-000000000000	32f52814-a621-4831-b48f-c272b59e0c0f	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 10:29:46.69158+00	
00000000-0000-0000-0000-000000000000	d75de24c-5b9d-4151-a38e-8395627ccef7	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-30 10:32:25.426809+00	
00000000-0000-0000-0000-000000000000	ae06c364-af94-4a70-8b65-25b68e351466	{"action":"user_signedup","actor_id":"ec8eeac1-2b57-4dc3-8b00-56759e94e8f7","actor_name":"Alexandrd","actor_username":"admin@electrosal.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-06-30 10:38:20.655633+00	
00000000-0000-0000-0000-000000000000	c767401f-046a-4591-a836-c8c6e58d2a9d	{"action":"login","actor_id":"ec8eeac1-2b57-4dc3-8b00-56759e94e8f7","actor_name":"Alexandrd","actor_username":"admin@electrosal.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 10:38:20.667579+00	
00000000-0000-0000-0000-000000000000	25f479a0-c710-478e-aaeb-ec1875c253d2	{"action":"user_repeated_signup","actor_id":"ec8eeac1-2b57-4dc3-8b00-56759e94e8f7","actor_name":"Alexandrd","actor_username":"admin@electrosal.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2026-06-30 10:38:30.423365+00	
00000000-0000-0000-0000-000000000000	35f112dd-0629-401d-9032-7fbc355908c0	{"action":"user_signedup","actor_id":"5b8a8662-2f98-4c8a-99d3-1127554939bd","actor_name":"Alexandre","actor_username":"alexandre@electrosal.com.br","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-06-30 10:39:00.435512+00	
00000000-0000-0000-0000-000000000000	7f060d16-db43-46c1-9281-977cd2496d19	{"action":"login","actor_id":"5b8a8662-2f98-4c8a-99d3-1127554939bd","actor_name":"Alexandre","actor_username":"alexandre@electrosal.com.br","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 10:39:00.449019+00	
00000000-0000-0000-0000-000000000000	1a1ec30a-4ff8-4852-9f3a-f78b7a7e698b	{"action":"login","actor_id":"5b8a8662-2f98-4c8a-99d3-1127554939bd","actor_name":"Alexandre","actor_username":"alexandre@electrosal.com.br","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 10:39:15.625023+00	
00000000-0000-0000-0000-000000000000	1224e720-3f26-49e1-80a1-fc9af479f616	{"action":"token_refreshed","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 11:03:31.273195+00	
00000000-0000-0000-0000-000000000000	a0428db4-f6cc-4185-b065-0706559c311d	{"action":"token_revoked","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 11:03:31.274055+00	
00000000-0000-0000-0000-000000000000	d365e8eb-49fe-48bc-b48f-3f689a5806a3	{"action":"logout","actor_id":"98832386-a950-42c9-a4b8-cb997e9fb3ca","actor_name":"teste","actor_username":"teste@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-30 11:04:19.992249+00	
00000000-0000-0000-0000-000000000000	dc448a26-cba3-4e0c-af61-35502fad16c5	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 11:04:22.08288+00	
00000000-0000-0000-0000-000000000000	d3e0b7d7-3117-4960-aada-983e1f4ed4d3	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 12:22:46.444285+00	
00000000-0000-0000-0000-000000000000	2e7bdd2b-598e-4c00-872e-d480336e6980	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 12:22:46.445153+00	
00000000-0000-0000-0000-000000000000	04ebc351-58d5-4bb6-9f23-2ead5423e052	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-30 12:30:18.744217+00	
00000000-0000-0000-0000-000000000000	c04d25ab-25a3-45ca-80e7-337af2bc1170	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 12:30:36.072565+00	
00000000-0000-0000-0000-000000000000	e9683611-47f6-49cc-af3c-ccbcf7175e73	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 12:41:01.496653+00	
00000000-0000-0000-0000-000000000000	350f3bcb-64ed-4b10-84c5-0a100e2e6aa9	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-30 12:42:02.511778+00	
00000000-0000-0000-0000-000000000000	44f604d4-9334-467a-8f7c-d561c8d3618b	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 12:42:05.80964+00	
00000000-0000-0000-0000-000000000000	031a5b24-58fb-415e-8749-cb9e48101bea	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-30 12:43:51.652562+00	
00000000-0000-0000-0000-000000000000	b85fc014-bae1-4ff1-a173-385b1936327f	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 12:43:55.131884+00	
00000000-0000-0000-0000-000000000000	e3a9e728-3bad-448d-993e-4d07f91cfbb3	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 12:51:41.64084+00	
00000000-0000-0000-0000-000000000000	d8b85c1b-964e-4ac1-a264-b7bfa78ad5df	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 13:02:57.374079+00	
00000000-0000-0000-0000-000000000000	96a3cdc8-22f7-429e-ad62-599f430cb14d	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-30 13:34:05.439937+00	
00000000-0000-0000-0000-000000000000	6b94f53d-441f-4b90-92c2-304ea70a22ff	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 13:34:07.866587+00	
00000000-0000-0000-0000-000000000000	63818f8d-9497-4856-9181-687c09f1d67f	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-30 13:34:54.671303+00	
00000000-0000-0000-0000-000000000000	0123329e-447e-4c62-af9a-576e611aaea5	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 13:34:56.896419+00	
00000000-0000-0000-0000-000000000000	9d03e3c8-74df-4617-96da-ba92a0cdcaff	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-30 13:40:22.082116+00	
00000000-0000-0000-0000-000000000000	577daf94-a97e-4986-98c8-7617d420c637	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 14:05:11.118591+00	
00000000-0000-0000-0000-000000000000	b566392d-5d17-46ca-b9cd-174bfefecc30	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 14:12:38.988983+00	
00000000-0000-0000-0000-000000000000	6362e6b3-7719-4762-97c2-089e2e051c46	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 15:09:05.938785+00	
00000000-0000-0000-0000-000000000000	d999d85b-6d87-4b28-97a7-f8ab8527e65c	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 15:09:05.940929+00	
00000000-0000-0000-0000-000000000000	97198dee-19ce-40bc-bead-e0379a957c20	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 15:10:56.85857+00	
00000000-0000-0000-0000-000000000000	4e39cada-3acf-46fa-8f61-af4c47a44766	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 15:10:56.85974+00	
00000000-0000-0000-0000-000000000000	3446d17c-7363-4049-891e-83ad00b761ea	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 16:08:57.11601+00	
00000000-0000-0000-0000-000000000000	30027505-db8e-4213-af02-acdbbf443eb6	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 16:08:57.116641+00	
00000000-0000-0000-0000-000000000000	6c1fe8fe-6951-43b4-aefe-daf4e428a68e	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 17:07:27.090578+00	
00000000-0000-0000-0000-000000000000	fe855583-abf2-4f8b-be23-87afd15bc67b	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 17:07:27.09128+00	
00000000-0000-0000-0000-000000000000	d494ce4c-ab56-4b52-ab67-b60d496bae33	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 17:31:55.683088+00	
00000000-0000-0000-0000-000000000000	a2670df1-11d6-4c09-ba0f-9fd5dd05146d	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 17:31:55.684007+00	
00000000-0000-0000-0000-000000000000	069b8b01-580e-4df9-8b4e-50e6de692645	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 18:05:57.023778+00	
00000000-0000-0000-0000-000000000000	0509d4d3-059b-4225-aba5-7f398ba5af71	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 18:05:57.024512+00	
00000000-0000-0000-0000-000000000000	954b4609-b532-4444-8810-f9cd7f7b4d25	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 19:04:26.935928+00	
00000000-0000-0000-0000-000000000000	4cee9b8f-bb17-4fde-b207-5cbabe9fb811	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 19:04:26.937354+00	
00000000-0000-0000-0000-000000000000	50f96fb0-4f18-4138-b75d-50832db2f0fc	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 19:40:30.511868+00	
00000000-0000-0000-0000-000000000000	a328649d-a9cc-42e7-b09d-5fb744c191b4	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 19:40:30.512701+00	
00000000-0000-0000-0000-000000000000	f7e1687b-e37c-4837-bae0-d587867c9d38	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 20:02:27.035004+00	
00000000-0000-0000-0000-000000000000	ce534da0-f513-4ea6-8078-0bfe31897dfd	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-30 20:02:27.035713+00	
00000000-0000-0000-0000-000000000000	abd258b6-dd4b-436f-a2e5-05054b3305c4	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-30 20:50:06.393759+00	
00000000-0000-0000-0000-000000000000	a0294056-8ff0-4dfa-b3b1-6181d75e18f7	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-30 20:50:11.117425+00	
00000000-0000-0000-0000-000000000000	6df9ff8d-3b7d-48a8-8476-01a5efd8f3cb	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 09:53:07.140853+00	
00000000-0000-0000-0000-000000000000	993b1d5e-e0dc-4184-ac60-265c6f935644	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-01 09:54:07.501481+00	
00000000-0000-0000-0000-000000000000	a4e4ca56-b8e1-45ad-9413-330088d63888	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 09:54:14.870352+00	
00000000-0000-0000-0000-000000000000	ba2b6367-2824-4104-bbac-1f37a5c8273a	{"action":"token_refreshed","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 11:08:46.265689+00	
00000000-0000-0000-0000-000000000000	41a0c7aa-6e25-4fb5-9f1b-91bc8537a25c	{"action":"token_revoked","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 11:08:46.266646+00	
00000000-0000-0000-0000-000000000000	c6e7f7bd-01c8-48e1-8d73-7e78cd5a195e	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-01 11:08:57.719193+00	
00000000-0000-0000-0000-000000000000	b6ed00b8-e124-4f1b-bd30-31d68237aad9	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 11:54:34.739044+00	
00000000-0000-0000-0000-000000000000	5660555e-c6f8-4c2d-872a-1595beb4035d	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 11:55:04.317662+00	
00000000-0000-0000-0000-000000000000	08b70de2-aa5c-49cc-a888-db9118ca5df2	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 12:53:32.888599+00	
00000000-0000-0000-0000-000000000000	b7ecb1d3-1141-46ab-9464-fba1a69b70c3	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 12:53:32.889227+00	
00000000-0000-0000-0000-000000000000	7eb2e026-18f0-48ff-8f8b-b036e0e1649d	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 14:10:10.721868+00	
00000000-0000-0000-0000-000000000000	214017a1-e233-4ab3-8b14-abb819de3f73	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 14:10:10.722802+00	
00000000-0000-0000-0000-000000000000	e31c493d-13c9-46dc-b858-b2c560f9b1fb	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 14:14:55.098159+00	
00000000-0000-0000-0000-000000000000	761ef7ca-e125-4d77-870d-f3ed4677bb0a	{"action":"token_refreshed","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 14:17:50.987703+00	
00000000-0000-0000-0000-000000000000	754a2f42-c811-4757-a907-c933dc18978e	{"action":"token_revoked","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 14:17:50.988385+00	
00000000-0000-0000-0000-000000000000	cf840e3d-13b0-4c75-a5e4-f975b3a8d1db	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-01 14:22:06.312799+00	
00000000-0000-0000-0000-000000000000	d3d8f2b8-65ff-4083-befd-d1921ec0fa71	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 14:22:08.473269+00	
00000000-0000-0000-0000-000000000000	1630899c-777b-4032-bdf7-a4313463a653	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-01 14:22:47.411369+00	
00000000-0000-0000-0000-000000000000	8f99d22b-27e1-4f49-bccb-719f54ba12b5	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 14:23:46.188078+00	
00000000-0000-0000-0000-000000000000	44474147-c182-42c0-a9a3-b49ad2c862f2	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 14:26:03.678944+00	
00000000-0000-0000-0000-000000000000	479dfa87-e900-48fe-bd1f-2d1ba55f006d	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 14:34:25.091406+00	
00000000-0000-0000-0000-000000000000	6631aec7-5fdd-4ecf-8c86-67d6cb15a1f5	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 14:37:00.727488+00	
00000000-0000-0000-0000-000000000000	20b6e140-a46a-4cea-8e66-721d66854467	{"action":"user_signedup","actor_id":"91291c73-587a-4d9e-a4fc-563a6c5fb255","actor_name":"Douglas Gregorio","actor_username":"douglassgregorio@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-07-01 15:34:34.876377+00	
00000000-0000-0000-0000-000000000000	a36cf50f-f8ac-4e22-843c-012082350281	{"action":"login","actor_id":"91291c73-587a-4d9e-a4fc-563a6c5fb255","actor_name":"Douglas Gregorio","actor_username":"douglassgregorio@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 15:34:34.891721+00	
00000000-0000-0000-0000-000000000000	31d4aca8-ce28-4c80-9efc-4175fb6399b2	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 16:35:33.325584+00	
00000000-0000-0000-0000-000000000000	e1806016-c27c-45bd-b060-43ac4dee1ab7	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 16:35:33.326278+00	
00000000-0000-0000-0000-000000000000	3ce63496-5699-4c8a-a08a-444dc42b9f7f	{"action":"token_refreshed","actor_id":"91291c73-587a-4d9e-a4fc-563a6c5fb255","actor_name":"Douglas Gregorio","actor_username":"douglassgregorio@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 16:46:11.167956+00	
00000000-0000-0000-0000-000000000000	98249ee5-b360-4c8d-aee7-ac96245fdf13	{"action":"token_revoked","actor_id":"91291c73-587a-4d9e-a4fc-563a6c5fb255","actor_name":"Douglas Gregorio","actor_username":"douglassgregorio@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 16:46:11.168736+00	
00000000-0000-0000-0000-000000000000	000b9ee0-2136-4101-9d65-e7bb57f38fae	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 18:37:46.103047+00	
00000000-0000-0000-0000-000000000000	fce6b499-d008-4d2b-92af-320c8d36a2ae	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 19:20:12.113852+00	
00000000-0000-0000-0000-000000000000	72e96f47-ca50-4f33-94da-fa70d1bde043	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 19:41:05.225035+00	
00000000-0000-0000-0000-000000000000	423b9081-16e0-4a2b-aea6-749fc9b5216f	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 19:41:05.227194+00	
00000000-0000-0000-0000-000000000000	e89e277d-9a81-41bd-bc22-e553a2b28090	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 19:41:32.504256+00	
00000000-0000-0000-0000-000000000000	bde5e0f3-7edf-42e5-b581-80b67a521c19	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-01 19:41:32.505028+00	
00000000-0000-0000-0000-000000000000	4d9f58d2-d6b5-44a1-a276-9c65d26eb20d	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-01 19:42:06.064803+00	
00000000-0000-0000-0000-000000000000	9820044a-43d5-4edb-b19f-996ac19bd90b	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 19:42:49.738816+00	
00000000-0000-0000-0000-000000000000	d24416f9-43ea-4da4-91cd-d7060127c825	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 19:46:32.180709+00	
00000000-0000-0000-0000-000000000000	672265dd-5245-4e44-b4b5-b416b3f9593a	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-01 19:48:08.377243+00	
00000000-0000-0000-0000-000000000000	51748671-a990-48be-a9cf-d3881dcd7b1f	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 19:48:19.256617+00	
00000000-0000-0000-0000-000000000000	979acf74-0440-4ab9-9b8e-5c4590fc8fda	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-01 19:51:34.528456+00	
00000000-0000-0000-0000-000000000000	1893a079-4567-4770-826e-6dadd8d2cfb1	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-01 19:51:49.632137+00	
00000000-0000-0000-0000-000000000000	2e212e5e-f2c4-4175-9d2c-fed13471e12c	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 10:06:24.669971+00	
00000000-0000-0000-0000-000000000000	319ad4ba-9884-497b-ab0d-2952a5c70a56	{"action":"user_signedup","actor_id":"e807a137-a35c-4814-898a-ce5273cb293f","actor_name":"Test User","actor_username":"testuser@example.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-07-02 10:37:49.109312+00	
00000000-0000-0000-0000-000000000000	ad12590d-4539-4d15-b816-f1e2482ed338	{"action":"login","actor_id":"e807a137-a35c-4814-898a-ce5273cb293f","actor_name":"Test User","actor_username":"testuser@example.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 10:37:49.135235+00	
00000000-0000-0000-0000-000000000000	d1852fee-675b-43b9-a390-ce14578cbfa9	{"action":"user_signedup","actor_id":"54fe2d54-b1a5-48cc-9df9-e972ebe5baf2","actor_name":"Test User","actor_username":"testuser_unique_999@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-07-02 10:38:20.004433+00	
00000000-0000-0000-0000-000000000000	43be3306-b468-430f-a8dd-1b2a4afbdc34	{"action":"login","actor_id":"54fe2d54-b1a5-48cc-9df9-e972ebe5baf2","actor_name":"Test User","actor_username":"testuser_unique_999@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 10:38:20.016662+00	
00000000-0000-0000-0000-000000000000	749eb9c1-bedf-4440-baac-41f7866c2bdb	{"action":"login","actor_id":"54fe2d54-b1a5-48cc-9df9-e972ebe5baf2","actor_name":"Test User","actor_username":"testuser_unique_999@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 10:38:33.90206+00	
00000000-0000-0000-0000-000000000000	43cb24ef-b749-4a7b-872f-b13f453cacbe	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 10:41:36.857802+00	
00000000-0000-0000-0000-000000000000	944b7d6c-818e-46f3-ada0-c529ecb494ce	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 12:14:14.042872+00	
00000000-0000-0000-0000-000000000000	f6acea65-3a71-4120-a913-058158f3c58d	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 12:14:14.043982+00	
00000000-0000-0000-0000-000000000000	f566c081-56e8-4aa6-9899-ec5ac7bf3c32	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 12:14:24.071437+00	
00000000-0000-0000-0000-000000000000	28c8fcdb-5f48-43b0-b53c-1bd62e6bd347	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 12:14:50.492522+00	
00000000-0000-0000-0000-000000000000	a4b01671-36a0-41db-80ed-d882be565ebe	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 13:23:00.613695+00	
00000000-0000-0000-0000-000000000000	288f7e8e-57c4-450f-a3fe-a3031a0dcc8e	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 13:23:00.614457+00	
00000000-0000-0000-0000-000000000000	37d3be06-6455-47b9-984e-2db49e99dbfe	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 14:25:14.270909+00	
00000000-0000-0000-0000-000000000000	2a84a165-e017-47d8-8013-c7e526ea865b	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 14:25:14.275681+00	
00000000-0000-0000-0000-000000000000	0a4f0d49-4e14-4cd1-9fff-5abb1aaf2279	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 15:23:51.381005+00	
00000000-0000-0000-0000-000000000000	2eb27286-5d15-4b77-aec1-28b5a18035b6	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 15:23:51.381832+00	
00000000-0000-0000-0000-000000000000	c66f707d-a7ce-46a7-b45e-45e8b706db2b	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 17:12:39.406104+00	
00000000-0000-0000-0000-000000000000	3be8014c-5e8b-451d-b029-fc7bee87ab88	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 17:12:39.407375+00	
00000000-0000-0000-0000-000000000000	d40e2d95-fbf7-433a-b302-1360bd2d6136	{"action":"token_refreshed","actor_id":"91291c73-587a-4d9e-a4fc-563a6c5fb255","actor_name":"Douglas Gregorio","actor_username":"douglassgregorio@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 17:19:43.876024+00	
00000000-0000-0000-0000-000000000000	5c82cda5-76ee-44c5-a67e-b1ac655401b2	{"action":"token_revoked","actor_id":"91291c73-587a-4d9e-a4fc-563a6c5fb255","actor_name":"Douglas Gregorio","actor_username":"douglassgregorio@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 17:19:43.876717+00	
00000000-0000-0000-0000-000000000000	81a14b10-4b31-4874-a2a6-2b0402653f73	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 17:28:06.874246+00	
00000000-0000-0000-0000-000000000000	058c0d7a-0160-4db8-a66a-e729be7365e2	{"action":"user_signedup","actor_id":"dd0fb9f0-64ee-42c8-9930-c3ae1818c65a","actor_name":"Twste","actor_username":"teste@twsts","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-07-02 17:28:26.301724+00	
00000000-0000-0000-0000-000000000000	ead1e074-9f36-4ffe-9f39-9ddff4144184	{"action":"login","actor_id":"dd0fb9f0-64ee-42c8-9930-c3ae1818c65a","actor_name":"Twste","actor_username":"teste@twsts","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 17:28:26.333384+00	
00000000-0000-0000-0000-000000000000	700a8a28-d535-4233-92df-7f6952b1614d	{"action":"login","actor_id":"dd0fb9f0-64ee-42c8-9930-c3ae1818c65a","actor_name":"Twste","actor_username":"teste@twsts","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 17:28:30.015328+00	
00000000-0000-0000-0000-000000000000	47f899a9-e77b-4ed6-add0-20514130e680	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 17:45:01.85661+00	
00000000-0000-0000-0000-000000000000	0b1929b9-4270-40c5-a26c-df6d0a0ddcca	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 18:05:19.913073+00	
00000000-0000-0000-0000-000000000000	e0519568-a063-4f49-96be-dfdc29a1166e	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 18:06:50.527356+00	
00000000-0000-0000-0000-000000000000	00efdab8-5c92-4c03-9793-a8f0a8e19972	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 18:20:50.877554+00	
00000000-0000-0000-0000-000000000000	54fd9ddf-7b69-4221-ac3b-052b5a6574ae	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 18:22:02.983517+00	
00000000-0000-0000-0000-000000000000	1df1ed00-6531-4dc9-b1a6-68e9034c804b	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 18:22:45.011958+00	
00000000-0000-0000-0000-000000000000	4c856fc5-214e-4790-9299-446b96ae21c6	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 18:22:52.585701+00	
00000000-0000-0000-0000-000000000000	746db13c-7852-4981-bc63-309f1097b6ea	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 18:23:26.408934+00	
00000000-0000-0000-0000-000000000000	662bc392-152e-4afe-9a18-35a699cb0bf0	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 18:23:42.829429+00	
00000000-0000-0000-0000-000000000000	fb22b1d5-0804-4453-9e91-15a6c5034722	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 18:25:32.82098+00	
00000000-0000-0000-0000-000000000000	53d9c76d-c5aa-41ce-a10d-c1db550ecd63	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 18:25:34.817565+00	
00000000-0000-0000-0000-000000000000	44228843-8aba-4f9a-b838-20d02e2be537	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 18:36:42.606776+00	
00000000-0000-0000-0000-000000000000	965cc545-93bb-4dd8-9b65-d3360a6d2c29	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 19:02:56.911256+00	
00000000-0000-0000-0000-000000000000	176283ca-40ef-4db6-b04d-ee5ed87ee495	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 19:17:55.3987+00	
00000000-0000-0000-0000-000000000000	d4ca2abf-443c-4140-a587-02dad38b57cc	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 19:17:58.603649+00	
00000000-0000-0000-0000-000000000000	b32b0dd8-f5cb-4db9-8ded-3cc7a046e630	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 19:24:13.301932+00	
00000000-0000-0000-0000-000000000000	94f7d192-78b7-44fa-9745-cf710848794a	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 20:00:07.586077+00	
00000000-0000-0000-0000-000000000000	5b377445-bac0-46c2-9ef2-afb411db9af6	{"action":"user_signedup","actor_id":"5b89eab5-849b-473d-a06a-2634f58560b0","actor_name":"Jaoao","actor_username":"admin@electrosal.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-07-02 20:00:35.780915+00	
00000000-0000-0000-0000-000000000000	2a6e48c9-0834-4c14-a9d8-685403f1a6ee	{"action":"login","actor_id":"5b89eab5-849b-473d-a06a-2634f58560b0","actor_name":"Jaoao","actor_username":"admin@electrosal.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 20:00:35.884664+00	
00000000-0000-0000-0000-000000000000	32069ce4-b2ca-479b-8f1e-c0f467cbdb53	{"action":"login","actor_id":"5b89eab5-849b-473d-a06a-2634f58560b0","actor_name":"Jaoao","actor_username":"admin@electrosal.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 20:00:42.703562+00	
00000000-0000-0000-0000-000000000000	1df54abd-1f70-4c09-a3a8-0b1f5cf3d633	{"action":"logout","actor_id":"5b89eab5-849b-473d-a06a-2634f58560b0","actor_name":"Jaoao","actor_username":"admin@electrosal.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 20:02:18.596546+00	
00000000-0000-0000-0000-000000000000	b08c42eb-09ea-403b-8e22-dfab194399fe	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 20:02:40.865928+00	
00000000-0000-0000-0000-000000000000	78c1e98b-0285-4410-b0c2-ee4d229bf224	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 20:30:19.682224+00	
00000000-0000-0000-0000-000000000000	d070c2e4-2c23-435a-9d74-b18cd7edb1c4	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-02 20:30:41.504764+00	
00000000-0000-0000-0000-000000000000	8440e4e8-3cae-46a2-87d6-c4bcce0005c0	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-02 20:31:01.904018+00	
00000000-0000-0000-0000-000000000000	5b05d966-8843-4474-94a1-c69bea4d6cf6	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 22:10:43.216346+00	
00000000-0000-0000-0000-000000000000	10a2a36b-a141-43c2-8f55-a10205e70dcc	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-02 22:10:43.217311+00	
00000000-0000-0000-0000-000000000000	e18e041e-fb7e-4317-a4b7-e96b87a748f7	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-03 09:34:49.319878+00	
00000000-0000-0000-0000-000000000000	c31a0ce3-84fe-4821-a5fc-9e89d9dce2e9	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-03 09:34:49.37338+00	
00000000-0000-0000-0000-000000000000	9ac1020b-c1f7-419f-acc8-f3b9f3656e74	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-03 11:08:34.314877+00	
00000000-0000-0000-0000-000000000000	0df890ca-12ed-4f33-a29c-e481280c0633	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-03 11:08:34.315709+00	
00000000-0000-0000-0000-000000000000	6b4a5db5-994e-4195-b0e0-be38119b117e	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 11:18:07.02122+00	
00000000-0000-0000-0000-000000000000	4bf29f3d-41f7-4883-945d-8774c5010b38	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 11:22:00.326538+00	
00000000-0000-0000-0000-000000000000	b428da9d-0bae-4a84-919e-0719cc48ed3e	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-03 11:59:17.974922+00	
00000000-0000-0000-0000-000000000000	2a620e2e-9877-4491-b1d7-60c9d4b8732a	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 11:59:38.173386+00	
00000000-0000-0000-0000-000000000000	9c21d459-5d04-4937-bc63-92e581a434e6	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 12:14:58.604502+00	
00000000-0000-0000-0000-000000000000	93adecf7-3315-463c-b225-64cbb7cddf21	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-03 12:34:36.574271+00	
00000000-0000-0000-0000-000000000000	5e4e19dc-c2cd-42db-9808-7b6134aa6ed5	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 12:35:01.081067+00	
00000000-0000-0000-0000-000000000000	b1c29b21-0c6f-47c4-9266-f9108c182d96	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 12:35:39.49218+00	
00000000-0000-0000-0000-000000000000	e90a3a37-a0cb-4b86-8e04-997f13af5160	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 12:38:07.680716+00	
00000000-0000-0000-0000-000000000000	4d0fbdd7-7b48-4b98-9828-e6501e5ea7bd	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-03 13:15:33.170621+00	
00000000-0000-0000-0000-000000000000	ee2cee28-edb6-4823-b089-42c220244357	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 13:15:36.687645+00	
00000000-0000-0000-0000-000000000000	5e0ef286-4e37-4e93-ac48-24f0beeb0fa9	{"action":"logout","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-03 13:16:28.835113+00	
00000000-0000-0000-0000-000000000000	44409fae-f814-49a5-9417-088dcd3907fc	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 13:16:59.52362+00	
00000000-0000-0000-0000-000000000000	6c08e3c6-bf8a-48bf-8d33-ccf2b4c2936f	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 13:17:22.145285+00	
00000000-0000-0000-0000-000000000000	8e506e6e-c1a4-4ce6-8ec9-40d69da0501e	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-03 14:38:47.0245+00	
00000000-0000-0000-0000-000000000000	a4a7a5b8-4e2b-4598-800c-ef383d331c1d	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-03 14:38:47.025519+00	
00000000-0000-0000-0000-000000000000	45e28a58-c05e-4f18-b7e5-4b64e77e3712	{"action":"user_signedup","actor_id":"ada49681-3ab5-43ce-bc4e-4eefef99d1f1","actor_name":"John Doe","actor_username":"john.doe@example.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-07-03 14:50:29.680358+00	
00000000-0000-0000-0000-000000000000	e61f30f0-847a-4088-8a95-e196f58e5ff6	{"action":"login","actor_id":"ada49681-3ab5-43ce-bc4e-4eefef99d1f1","actor_name":"John Doe","actor_username":"john.doe@example.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 14:50:29.716566+00	
00000000-0000-0000-0000-000000000000	e10d75b2-9376-4ea5-b9da-26d43f0a7a41	{"action":"login","actor_id":"ada49681-3ab5-43ce-bc4e-4eefef99d1f1","actor_name":"John Doe","actor_username":"john.doe@example.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 14:50:48.806598+00	
00000000-0000-0000-0000-000000000000	094bd005-cde2-41d2-b92f-1c5d07ffbea6	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-03 17:01:49.967548+00	
00000000-0000-0000-0000-000000000000	d2293c57-dd70-4c06-a5de-b6ac7ac16169	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-03 17:01:49.969234+00	
00000000-0000-0000-0000-000000000000	805da006-8eb4-4320-928d-9a7365c08bd9	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-03 20:12:07.586854+00	
00000000-0000-0000-0000-000000000000	5a314f72-fe86-4c7d-afc4-27f0dbfae5d6	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-03 20:12:07.587882+00	
00000000-0000-0000-0000-000000000000	036d9168-2aba-4b1a-8437-38dddfc699d1	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-03 20:12:12.293183+00	
00000000-0000-0000-0000-000000000000	2ea76063-b0ea-44b9-9ccb-68a8d2ca44d7	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-03 20:12:33.595748+00	
00000000-0000-0000-0000-000000000000	7ce44048-109e-4755-89b1-3766a822d918	{"action":"token_refreshed","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-04 19:20:21.793041+00	
00000000-0000-0000-0000-000000000000	bbccb795-1f06-46f0-b5f9-a53fdf79501a	{"action":"token_revoked","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-07-04 19:20:21.79585+00	
00000000-0000-0000-0000-000000000000	fe0c9c42-2f35-422b-8ff0-2a0e2f639672	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-04 19:20:31.201745+00	
00000000-0000-0000-0000-000000000000	cf59f714-60e3-4df0-9c0c-9a389c810045	{"action":"user_signedup","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-07-04 19:21:00.698932+00	
00000000-0000-0000-0000-000000000000	01071a44-1782-47bd-8945-a140badc17b4	{"action":"login","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 19:21:00.769885+00	
00000000-0000-0000-0000-000000000000	24837c1f-915c-4774-81ca-e1de57353caf	{"action":"login","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 19:21:08.805405+00	
00000000-0000-0000-0000-000000000000	5d992899-24dd-4dc9-98fa-62ae320c2a04	{"action":"logout","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account"}	2026-07-04 19:23:24.208955+00	
00000000-0000-0000-0000-000000000000	e7a4da17-d612-413f-9ca6-eb72d6f290d4	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 19:23:36.813793+00	
00000000-0000-0000-0000-000000000000	cc72b937-d727-494b-946c-01a5b67e8b7d	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 19:30:49.490664+00	
00000000-0000-0000-0000-000000000000	bf0a83bb-1783-47a5-9df4-c04f937f19c8	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-04 19:36:21.792601+00	
00000000-0000-0000-0000-000000000000	effd7fa3-9ef5-45a4-82bf-d14848979fbb	{"action":"login","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 19:36:33.712589+00	
00000000-0000-0000-0000-000000000000	ec51a94b-f9c4-4d55-b4c1-015e032632bc	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:17:40.293063+00	
00000000-0000-0000-0000-000000000000	e9cf4ec7-b36b-4368-8fc5-d746fc6abc84	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-04 20:18:02.40898+00	
00000000-0000-0000-0000-000000000000	d3d57d33-e7c6-44f8-8706-156c1699c2b1	{"action":"login","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:18:17.99575+00	
00000000-0000-0000-0000-000000000000	e55745ec-bfb2-4cba-9587-27a18cde8a13	{"action":"logout","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account"}	2026-07-04 20:19:07.598762+00	
00000000-0000-0000-0000-000000000000	fccd6ad4-37fd-46ad-b68f-bfde0c4d8957	{"action":"user_signedup","actor_id":"0950e079-e1de-422c-8158-6015a6bd3b16","actor_name":"admin","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2026-07-04 20:19:41.976029+00	
00000000-0000-0000-0000-000000000000	b28cbbff-605e-49b3-9f1b-d35ae3914ce3	{"action":"login","actor_id":"0950e079-e1de-422c-8158-6015a6bd3b16","actor_name":"admin","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:19:41.996884+00	
00000000-0000-0000-0000-000000000000	86941e72-99e8-423b-a62a-dce2b9abac28	{"action":"login","actor_id":"0950e079-e1de-422c-8158-6015a6bd3b16","actor_name":"admin","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:19:50.895343+00	
00000000-0000-0000-0000-000000000000	633eed29-4edb-40f7-8894-37746bfe0568	{"action":"login","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:28:35.106516+00	
00000000-0000-0000-0000-000000000000	adb6c267-4061-4632-8d03-cce20ce40dab	{"action":"logout","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account"}	2026-07-04 20:29:07.094939+00	
00000000-0000-0000-0000-000000000000	61dd11c9-ca8c-4230-9537-b7d8a82412c1	{"action":"login","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:29:20.189264+00	
00000000-0000-0000-0000-000000000000	e8dce1cd-71b4-4878-8b63-4e7c644c16bd	{"action":"logout","actor_id":"0b3b5902-bc9d-4245-a36f-bf0b80b418e1","actor_name":"Alexandre Duque de Almeida","actor_username":"alexandre.duque@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-07-04 20:32:34.504233+00	
00000000-0000-0000-0000-000000000000	3edaa344-3ff4-44db-9a59-37b8c1fd403d	{"action":"login","actor_id":"0950e079-e1de-422c-8158-6015a6bd3b16","actor_name":"admin","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:32:51.410735+00	
00000000-0000-0000-0000-000000000000	5c1168bf-d373-49d6-9e91-2da5519060d9	{"action":"logout","actor_id":"0950e079-e1de-422c-8158-6015a6bd3b16","actor_name":"admin","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2026-07-04 20:34:53.515504+00	
00000000-0000-0000-0000-000000000000	06074f5f-7567-4d71-91a3-c79dc7c5c4a6	{"action":"login","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:35:20.284464+00	
00000000-0000-0000-0000-000000000000	b256f66e-dcce-4feb-8ea0-7948f957480b	{"action":"logout","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account"}	2026-07-04 20:35:47.783542+00	
00000000-0000-0000-0000-000000000000	d1686217-bbb9-4c86-8511-81ae64e7aa76	{"action":"login","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:36:06.968042+00	
00000000-0000-0000-0000-000000000000	6d3722c6-66a3-49f8-9e64-9c49846f2acd	{"action":"login","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:42:01.678384+00	
00000000-0000-0000-0000-000000000000	72282327-4b71-452d-bd5f-a1a748ea557c	{"action":"login","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-04 20:47:17.579562+00	
00000000-0000-0000-0000-000000000000	b519d9d6-a9f5-4c69-8549-9b7e582b399c	{"action":"login","actor_id":"41cf18bd-a62d-49d5-b042-eb22b8401523","actor_name":"Kelly Cerqueira Almeida","actor_username":"kellyfranster@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-07-05 16:56:42.110053+00	
00000000-0000-0000-0000-000000000000	b88d7883-b40f-4c6c-bc8f-550929837823	{"action":"token_refreshed","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"token"}	2026-07-06 12:50:31.54089+00	
00000000-0000-0000-0000-000000000000	c9a23ee8-5492-4af9-8d57-e572a3ffe07f	{"action":"token_revoked","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"token"}	2026-07-06 12:50:31.542032+00	
00000000-0000-0000-0000-000000000000	d350fcf5-d8d9-450f-9a69-95f16fb7249a	{"action":"token_refreshed","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"token"}	2026-07-07 11:41:24.654768+00	
00000000-0000-0000-0000-000000000000	6121ddf6-63fd-4167-824d-beb1ff979291	{"action":"token_revoked","actor_id":"6e400277-94ad-49bd-8e89-02299f919b06","actor_name":"Teste ","actor_username":"teste@teste.com","actor_via_sso":false,"log_type":"token"}	2026-07-07 11:41:24.65713+00	
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
0b3b5902-bc9d-4245-a36f-bf0b80b418e1	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	{"sub": "0b3b5902-bc9d-4245-a36f-bf0b80b418e1", "email": "alexandre.duque@gmail.com", "full_name": "Alexandre Duque de Almeida", "email_verified": false, "phone_verified": false}	email	2026-06-24 15:39:34.430102+00	2026-06-24 15:39:34.430165+00	2026-06-24 15:39:34.430165+00	70c358b7-c2c7-4c86-bdfe-c5ed928db9b8
41cf18bd-a62d-49d5-b042-eb22b8401523	41cf18bd-a62d-49d5-b042-eb22b8401523	{"sub": "41cf18bd-a62d-49d5-b042-eb22b8401523", "email": "kellyfranster@gmail.com", "full_name": "Kelly Cerqueira Almeida", "email_verified": false, "phone_verified": false}	email	2026-06-24 15:46:23.730817+00	2026-06-24 15:46:23.730843+00	2026-06-24 15:46:23.730843+00	74233707-3bc9-4cf4-b992-46f3b4e8fb60
91291c73-587a-4d9e-a4fc-563a6c5fb255	91291c73-587a-4d9e-a4fc-563a6c5fb255	{"sub": "91291c73-587a-4d9e-a4fc-563a6c5fb255", "email": "douglassgregorio@gmail.com", "full_name": "Douglas Gregorio", "email_verified": false, "phone_verified": false}	email	2026-07-01 15:34:34.873272+00	2026-07-01 15:34:34.873314+00	2026-07-01 15:34:34.873314+00	4c99f304-0116-427c-891e-4426539622db
ada49681-3ab5-43ce-bc4e-4eefef99d1f1	ada49681-3ab5-43ce-bc4e-4eefef99d1f1	{"sub": "ada49681-3ab5-43ce-bc4e-4eefef99d1f1", "email": "john.doe@example.com", "full_name": "John Doe", "member_type": "piloto", "email_verified": false, "phone_verified": false}	email	2026-07-03 14:50:29.676722+00	2026-07-03 14:50:29.676919+00	2026-07-03 14:50:29.676919+00	34c14f05-d5f3-4957-a366-f7a96dad5f4a
6e400277-94ad-49bd-8e89-02299f919b06	6e400277-94ad-49bd-8e89-02299f919b06	{"sub": "6e400277-94ad-49bd-8e89-02299f919b06", "email": "teste@teste.com", "full_name": "Teste ", "member_type": "piloto", "email_verified": false, "phone_verified": false}	email	2026-07-04 19:21:00.695834+00	2026-07-04 19:21:00.696251+00	2026-07-04 19:21:00.696251+00	0840f734-1d33-408c-9b62-7a10ca864f51
0950e079-e1de-422c-8158-6015a6bd3b16	0950e079-e1de-422c-8158-6015a6bd3b16	{"sub": "0950e079-e1de-422c-8158-6015a6bd3b16", "email": "admin@admin.com", "full_name": "admin", "member_type": "piloto", "email_verified": false, "phone_verified": false}	email	2026-07-04 20:19:41.974+00	2026-07-04 20:19:41.974023+00	2026-07-04 20:19:41.974023+00	37a9861f-78aa-4b45-b56a-1f1af073f018
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
94b6164e-8710-4cfb-94df-813dc357fb09	2026-07-03 14:50:29.722602+00	2026-07-03 14:50:29.722602+00	password	ee350c13-9643-4cdb-8687-a21b7a7d3aef
00b7be22-44fb-401d-b42d-51a5a0085a76	2026-07-03 14:50:48.813239+00	2026-07-03 14:50:48.813239+00	password	784ffe3d-c7ed-44e1-99b6-81f624c0e6da
0cb89ea9-1ab7-4b60-a61a-60f75c7d05c4	2026-07-01 15:34:34.896387+00	2026-07-01 15:34:34.896387+00	password	995de38f-c7e1-432d-8167-c06a160dd630
794d83c1-1169-4171-827c-eeb3af411ecf	2026-07-04 20:36:06.974651+00	2026-07-04 20:36:06.974651+00	password	7ac26855-8e02-4711-95c2-f031054512ad
7cfab468-c4eb-414b-ab21-00e2dc1e5aff	2026-07-04 20:42:01.688158+00	2026-07-04 20:42:01.688158+00	password	53d22915-8c28-4a7a-bd78-d80add6e6525
3ba2d9d2-5513-48b3-828b-7510f156e6ac	2026-07-04 20:47:17.584037+00	2026-07-04 20:47:17.584037+00	password	5a26f691-ba18-4cd0-bb47-479e830c8ed3
dff5d8cf-b267-4386-8395-a3048a8aca11	2026-07-05 16:56:42.115083+00	2026-07-05 16:56:42.115083+00	password	225f2489-4880-4595-8a2a-887610c28678
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	141	q7pgbzl4h2vp	91291c73-587a-4d9e-a4fc-563a6c5fb255	t	2026-07-01 16:46:11.169643+00	2026-07-02 17:19:43.879433+00	3kju66xwotoy	0cb89ea9-1ab7-4b60-a61a-60f75c7d05c4
00000000-0000-0000-0000-000000000000	161	lrrugftsjdw5	91291c73-587a-4d9e-a4fc-563a6c5fb255	f	2026-07-02 17:19:43.881523+00	2026-07-02 17:19:43.881523+00	q7pgbzl4h2vp	0cb89ea9-1ab7-4b60-a61a-60f75c7d05c4
00000000-0000-0000-0000-000000000000	213	ekwnxpv6y3nd	6e400277-94ad-49bd-8e89-02299f919b06	f	2026-07-04 20:42:01.684944+00	2026-07-04 20:42:01.684944+00	\N	7cfab468-c4eb-414b-ab21-00e2dc1e5aff
00000000-0000-0000-0000-000000000000	214	nnzfke5xg2bq	6e400277-94ad-49bd-8e89-02299f919b06	f	2026-07-04 20:47:17.582614+00	2026-07-04 20:47:17.582614+00	\N	3ba2d9d2-5513-48b3-828b-7510f156e6ac
00000000-0000-0000-0000-000000000000	215	yxtq2jkcxpo2	41cf18bd-a62d-49d5-b042-eb22b8401523	f	2026-07-05 16:56:42.113521+00	2026-07-05 16:56:42.113521+00	\N	dff5d8cf-b267-4386-8395-a3048a8aca11
00000000-0000-0000-0000-000000000000	212	qevhvf57ni7j	6e400277-94ad-49bd-8e89-02299f919b06	t	2026-07-04 20:36:06.972668+00	2026-07-06 12:50:31.54261+00	\N	794d83c1-1169-4171-827c-eeb3af411ecf
00000000-0000-0000-0000-000000000000	216	6lxencvf2l7u	6e400277-94ad-49bd-8e89-02299f919b06	t	2026-07-06 12:50:31.543725+00	2026-07-07 11:41:24.658068+00	qevhvf57ni7j	794d83c1-1169-4171-827c-eeb3af411ecf
00000000-0000-0000-0000-000000000000	217	zo6pcr6i3qpd	6e400277-94ad-49bd-8e89-02299f919b06	f	2026-07-07 11:41:24.659456+00	2026-07-07 11:41:24.659456+00	6lxencvf2l7u	794d83c1-1169-4171-827c-eeb3af411ecf
00000000-0000-0000-0000-000000000000	139	3kju66xwotoy	91291c73-587a-4d9e-a4fc-563a6c5fb255	t	2026-07-01 15:34:34.894946+00	2026-07-01 16:46:11.169173+00	\N	0cb89ea9-1ab7-4b60-a61a-60f75c7d05c4
00000000-0000-0000-0000-000000000000	193	z7igdcqtjuw3	ada49681-3ab5-43ce-bc4e-4eefef99d1f1	f	2026-07-03 14:50:29.721137+00	2026-07-03 14:50:29.721137+00	\N	94b6164e-8710-4cfb-94df-813dc357fb09
00000000-0000-0000-0000-000000000000	194	vu3trjcxnd6z	ada49681-3ab5-43ce-bc4e-4eefef99d1f1	f	2026-07-03 14:50:48.811314+00	2026-07-03 14:50:48.811314+00	\N	00b7be22-44fb-401d-b42d-51a5a0085a76
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
0cb89ea9-1ab7-4b60-a61a-60f75c7d05c4	91291c73-587a-4d9e-a4fc-563a6c5fb255	2026-07-01 15:34:34.893085+00	2026-07-02 17:19:43.883466+00	\N	aal1	\N	2026-07-02 17:19:43.883403	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	162.43.190.104	\N	\N	\N	\N	\N
94b6164e-8710-4cfb-94df-813dc357fb09	ada49681-3ab5-43ce-bc4e-4eefef99d1f1	2026-07-03 14:50:29.719429+00	2026-07-03 14:50:29.719429+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 11; OnePlus8Pro Build/QKR1.191246.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/90.0.4430.210 Mobile Safari/537.36	66.102.6.128	\N	\N	\N	\N	\N
00b7be22-44fb-401d-b42d-51a5a0085a76	ada49681-3ab5-43ce-bc4e-4eefef99d1f1	2026-07-03 14:50:48.807813+00	2026-07-03 14:50:48.807813+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 11; OnePlus8Pro Build/QKR1.191246.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/90.0.4430.210 Mobile Safari/537.36	66.102.6.128	\N	\N	\N	\N	\N
7cfab468-c4eb-414b-ab21-00e2dc1e5aff	6e400277-94ad-49bd-8e89-02299f919b06	2026-07-04 20:42:01.681019+00	2026-07-04 20:42:01.681019+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 16; SM-S938B Build/BP4A.251205.006; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/149.0.7827.163 Mobile Safari/537.36	179.111.23.98	\N	\N	\N	\N	\N
3ba2d9d2-5513-48b3-828b-7510f156e6ac	6e400277-94ad-49bd-8e89-02299f919b06	2026-07-04 20:47:17.580814+00	2026-07-04 20:47:17.580814+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36	179.111.23.98	\N	\N	\N	\N	\N
dff5d8cf-b267-4386-8395-a3048a8aca11	41cf18bd-a62d-49d5-b042-eb22b8401523	2026-07-05 16:56:42.111415+00	2026-07-05 16:56:42.111415+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36	179.111.23.98	\N	\N	\N	\N	\N
794d83c1-1169-4171-827c-eeb3af411ecf	6e400277-94ad-49bd-8e89-02299f919b06	2026-07-04 20:36:06.970013+00	2026-07-07 11:41:24.66496+00	\N	aal1	\N	2026-07-07 11:41:24.6649	Mozilla/5.0 (X11; Linux x86_64; rv:152.0) Gecko/20100101 Firefox/152.0	179.111.23.98	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	0950e079-e1de-422c-8158-6015a6bd3b16	authenticated	authenticated	admin@admin.com	$2a$10$3q7.2ZznNa6LEn4AP.gK7uSK2AIUW.nrvCJWAmFzk4hD.RN5tZuCm	2026-07-04 20:19:41.976517+00	\N		\N		\N			\N	2026-07-04 20:32:51.412319+00	{"provider": "email", "providers": ["email"]}	{"sub": "0950e079-e1de-422c-8158-6015a6bd3b16", "email": "admin@admin.com", "full_name": "admin", "member_type": "piloto", "email_verified": true, "phone_verified": false}	\N	2026-07-04 20:19:41.915278+00	2026-07-04 20:32:51.476453+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	91291c73-587a-4d9e-a4fc-563a6c5fb255	authenticated	authenticated	douglassgregorio@gmail.com	$2a$10$oigag0qggEW1qOIho/6GwO0bihwRKGvgEAMtjp/sOwNC.NfgRsj0q	2026-07-01 15:34:34.877139+00	\N		\N		\N			\N	2026-07-01 15:34:34.892999+00	{"provider": "email", "providers": ["email"]}	{"sub": "91291c73-587a-4d9e-a4fc-563a6c5fb255", "email": "douglassgregorio@gmail.com", "full_name": "Douglas Gregorio", "email_verified": true, "phone_verified": false}	\N	2026-07-01 15:34:34.862318+00	2026-07-02 17:19:43.882448+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ada49681-3ab5-43ce-bc4e-4eefef99d1f1	authenticated	authenticated	john.doe@example.com	$2a$10$XfZV0xsyg6T4FZA0DHN0mOJU3I4L4ybI8epAr83e19ZJ62ulinf4i	2026-07-03 14:50:29.680845+00	\N		\N		\N			\N	2026-07-03 14:50:48.807755+00	{"provider": "email", "providers": ["email"]}	{"sub": "ada49681-3ab5-43ce-bc4e-4eefef99d1f1", "email": "john.doe@example.com", "full_name": "John Doe", "member_type": "piloto", "email_verified": true, "phone_verified": false}	\N	2026-07-03 14:50:29.663519+00	2026-07-03 14:50:48.812681+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	41cf18bd-a62d-49d5-b042-eb22b8401523	authenticated	authenticated	kellyfranster@gmail.com	$2a$10$y99AKevW.uXiRQKtH0gaaOta2W2LfbylYSNiiQqHjtovnBoC99L/q	2026-06-24 15:46:23.734407+00	\N		\N		\N			\N	2026-07-05 16:56:42.11133+00	{"provider": "email", "providers": ["email"]}	{"sub": "41cf18bd-a62d-49d5-b042-eb22b8401523", "email": "kellyfranster@gmail.com", "full_name": "Kelly Cerqueira Almeida", "email_verified": true, "phone_verified": false}	\N	2026-06-24 15:46:23.722861+00	2026-07-05 16:56:42.114592+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	6e400277-94ad-49bd-8e89-02299f919b06	authenticated	authenticated	teste@teste.com	$2a$10$zbh11HCZRNMDIeYf3IgxMuQPytyyOuZZ1ZnmS2cu4rLGSU6X6t3Pu	2026-07-04 19:21:00.699752+00	\N		\N		\N			\N	2026-07-04 20:47:17.580759+00	{"provider": "email", "providers": ["email"]}	{"sub": "6e400277-94ad-49bd-8e89-02299f919b06", "email": "teste@teste.com", "full_name": "Teste ", "member_type": "piloto", "email_verified": true, "phone_verified": false}	\N	2026-07-04 19:21:00.685544+00	2026-07-07 11:41:24.662149+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	authenticated	authenticated	alexandre.duque@gmail.com	$2a$10$AygKBSdQRdQaaDcXfFbLwe283.OCOURFaGZtDsvp6Aru1vhtt/rlu	2026-06-24 15:39:34.434999+00	\N		\N		\N			\N	2026-07-04 20:29:20.191358+00	{"provider": "email", "providers": ["email"]}	{"sub": "0b3b5902-bc9d-4245-a36f-bf0b80b418e1", "email": "alexandre.duque@gmail.com", "full_name": "Alexandre Duque de Almeida", "email_verified": true, "phone_verified": false}	\N	2026-06-24 15:39:34.41625+00	2026-07-04 20:29:20.195392+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: gallery_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gallery_items (id, title, caption, image_url, instagram_url, sort_order, status, created_at, updated_at) FROM stdin;
5db178b1-ae7e-46bb-831d-00f039c74a1c	Post Instagram	Medo de andar de moto?? 😂😂😂\n#reels \n#Motoclube \n#motos	/ig-5db178b1-ae7e-46bb-831d-00f039c74a1c.jpg	https://www.instagram.com/p/DZ5gTaHA4ca	0	published	2026-06-25 10:00:00.509341+00	2026-06-30 14:08:22.761566+00
81a04712-502a-4e1c-9122-b66c66a1fa58	Post Instagram	🏍️☕ CHECKLIST DE VIAGEM DE MOTO — salva aí que vai te salvar na estrada.\nToda viagem boa começa antes de dar a partida. Reunimos os 8 pontos essenciais que todo piloto deveria conferir antes de cair na estrada — do pneu calibrado ao parceiro que ninguém deixa pra trás. E no fim tem um bônus de fofura que é item favorito das meninas. 👀\nArraste pro lado 👉 e veja se você não tá esquecendo nada:\n\n📄 Documentação em dia\n\n🔧 Moto revisada\n\n🦺 Equipamento de proteção\n\n🧰 Ferramentas e emergência\n\n🗺️ Rota e comunicação\n\n💪 Cabeça e corpo prontos pra pilotar\n👉 Salva esse post pra conferir antes do próximo role.\n\n🔖 Marca aquele parceiro que sempre esquece alguma coisa.\n\n💬 Faltou algum item na sua lista? Conta pra gente nos comentários.\n🐾 E não esquece: orelhinha de gatinho da mochilinha também é item de série! Manda aqui a foto da sua. 😼\nRespeito · Liberdade · Estrada 🛣️\n\n📍 Atibaia · São Paulo · Brasil\n#motoclube #cafemotoeasfalto #viagemdemoto #motoviagem #motociclismo	/ig-81a04712-502a-4e1c-9122-b66c66a1fa58.jpg	https://www.instagram.com/p/DZ8YAMnlu1V	0	published	2026-06-25 10:00:00.523702+00	2026-06-30 14:17:24.018286+00
5b8a7728-4aab-41de-8701-4f86ae09ddab	Post Instagram	Reflita 😂🤣😂🤣\n#motoclube \n#motoviagem \n#motociclismo \n#interiordesp	/gallery-1.jpg	https://www.instagram.com/p/DaB3sDOgS2c	0	published	2026-06-26 04:00:00.491645+00	2026-06-30 14:20:41.900494+00
f4351e93-160c-4f69-b573-796338b67814	Post Instagram	🏍️☕ Café Moto e Asfalto — o primeiro de muitos quilômetros juntos!\nTudo começou com um grupo de amigos, algumas motos e uma vontade enorme de pegar a estrada.\nCriamos esse espaço pra dividir o que move a nossa turma: o cheiro do asfalto de manhã cedo, o café quente numa parada no meio do caminho e as paisagens do interior de SP (e além! 🌄) que só quem anda de moto conhece de verdade.\n\nDe Pedra Bela, Monte Verde, Joanópolis, Salesópolis e muitos outros que estão por vir, cada rolê vira história e a amizade se fortalece. Aqui a gente vai compartilhar nossos passeios, viagens, paradas e os melhores momentos da estrada.\n🤝 Respeito · Liberdade · Estrada\n\n📍 Atibaia – São Paulo – Brasil\n\nDesde 2024.\n#CafeMotoEAsfalto #Motoclube #MotoViagem #InteriorDeSP #VidaSobreDuasRodas LiberdadeNaEstrada Atibaia MonteVerde Salesopolis BrothersDeEstrada	/ig-f4351e93-160c-4f69-b573-796338b67814.jpg	https://www.instagram.com/p/DZ42DYpFk8G	0	published	2026-06-25 10:00:00.519827+00	2026-06-30 14:17:24.018286+00
\.


--
-- Data for Name: maintenance_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maintenance_items (id, motorcycle_id, user_id, name, interval_km, interval_months, last_change_km, last_change_date, notes, created_at, updated_at) FROM stdin;
c297800d-11a4-4c59-9ac8-84902f20315e	28f6a51d-a4c7-4cba-99e1-6563c1695e0a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	Oléo	2000	2	28529	2026-06-18	1,200 Litros de Oleo	2026-06-24 17:56:37.680833+00	2026-06-25 12:11:54.544175+00
d7accc4c-2987-4021-871c-f46780809233	8f27df6b-39fc-439a-a384-377eb3080a56	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	Oleo do Motor	3000	3	12000	2026-06-26	\N	2026-06-26 18:01:23.428894+00	2026-06-26 18:01:23.428894+00
\.


--
-- Data for Name: maintenance_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maintenance_records (id, motorcycle_id, maintenance_item_id, user_id, item_name, service_date, km_at_service, cost, workshop, notes, created_at) FROM stdin;
b8253e27-e5b1-41eb-8a0e-334f6ff51131	28f6a51d-a4c7-4cba-99e1-6563c1695e0a	\N	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	Raios Traseiros da Nh 190	2026-06-20	28629	150.00	Atibaia Motos	\N	2026-06-24 18:53:02.035986+00
ebf5ef3d-4328-4eb5-ad2c-b0760146953d	8f27df6b-39fc-439a-a384-377eb3080a56	\N	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	Espelhinhos	2026-04-01	12000	45.00	Motoyama	\N	2026-06-26 18:02:36.96875+00
\.


--
-- Data for Name: motorcycles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.motorcycles (id, user_id, brand, model, year, plate, color, nickname, current_km, photo_url, created_at, updated_at) FROM stdin;
28f6a51d-a4c7-4cba-99e1-6563c1695e0a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	Symm	NH 190	2020	BWM7I66	Branca	Zefinha	28829	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/f976ea43-43ca-474a-8436-cac8e1ab8c80-Captura de tela de 2026-06-24 12-48-37.png	2026-06-24 15:40:42.718668+00	2026-06-24 18:23:26.993018+00
8f27df6b-39fc-439a-a384-377eb3080a56	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	Honda	CB 500	2023	ABC-5L12	Vermelha	Trovão	24000	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/37f845cc-3b78-4796-84c1-20ada3ad74ce-96b028d3-8810-4924-a389-89a5f98e35e6.jpeg	2026-06-26 18:00:40.380111+00	2026-07-04 20:28:58.969519+00
\.


--
-- Data for Name: news; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.news (id, title, slug, excerpt, content, cover_url, tag, status, published_at, author_id, created_at, updated_at) FROM stdin;
817e54e9-4f0f-4f2d-9bb4-b0b694e57002	Pedra Bela ao nascer do sol: como foi o último rolê	pedra-bela-ao-nascer-do-sol-como-foi-o-ultimo-role	Acordamos antes do galo cantar pra pegar o nascer do sol no mirante. O frio compensou — e as fotos também.	[{"id":"af893c78-60a1-4e81-a1f8-5d455cb8cd96","type":"paragraph","value":"Acordamos antes do galo cantar pra pegar o nascer do sol no mirante. O frio compensou — e as fotos também.\\nUma experiência inesquecível para todos os membros."},{"id":"ac41fbed-50ce-47af-98b7-98a9a439e2f9","type":"image","value":"https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/572f04af-39dd-4c96-9a31-af41c30befac-WhatsApp Image 2026-06-24 at 21.42.59.jpeg"}]	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/20be326d-cca8-40ee-8f62-0db5f6dca7d3-Melhorar foto - padrão motociclista(4).jpg	Bastidores	published	2024-07-15 00:00:00+00	\N	2026-06-24 21:12:33.189585+00	2026-06-25 01:12:16.065826+00
12a25e0d-0e9f-4670-b0e6-19b5dcfb56ed	Rolê a Monte Verde reúne a turma na serra	role-monte-verde-reune-a-turma-na-serra	Saída cedo de Atibaia, parada estratégica pra café e um dia inteiro curtindo as curvas da serra. Foi rolê pra entrar pra história do clube.	[{"id":"b597d665-543f-4ee9-bd57-d9bb1d413e6e","type":"subtitle","value":"A chegada em Monte Verde"},{"id":"8312803e-66ac-48bb-88d6-bf3d65127a29","type":"paragraph","value":"Saída cedo de Atibaia, parada estratégica pra café e um dia inteiro curtindo as curvas da serra. Foi rolê pra entrar pra história do clube.\\n\\nMais detalhes em breve..."},{"id":"3354212e-0377-4896-b55c-45a4db94c68c","type":"image","value":"https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/46faad3f-7f44-4b77-8c4f-20f1508e1da8-Melhorar foto - padrão motociclista(1).jpg"},{"id":"1de2663e-22a3-444f-aa61-9c481aac9ae3","type":"subtitle","value":"O Cafe da manhã"},{"id":"af0b0ac3-968a-4b3b-be8b-cdb18e1bedea","type":"image","value":"https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/a4f5d129-3781-4610-9815-1dbe649611ed-Melhorar foto - padrão motociclista(3).jpg"},{"id":"a9be3c4b-1b0b-4a1a-aab1-06f25b1a976e","type":"paragraph","value":"Café da manhã em um lugarzinho fantastico, tudo muito gostoso..."}]	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/2ab78fc0-922d-4bf2-9471-4000c3548dde-Melhorar foto - padrão motociclista.jpg	Passeio	published	2026-03-19 00:00:00+00	\N	2026-06-24 21:12:33.189585+00	2026-06-25 11:56:06.341972+00
662dcf8a-99a3-471f-96b5-87b8f0cf842b	Passeio Salesopolis - Rota Biker monumento 19	salesopolis	Em Salesópolis (SP), o monumento oficial da Rota Biker fica no Rancho Terra Crua (Monumento nº 19). O local oferece estrutura de lazer, restaurante e é um ponto de encontro famoso para motociclistas.	[{"id":"1f0ed019-b3fc-4b8d-a023-805f2a319f78","type":"subtitle","value":"Duas Rodas e Histórias: Nossa Jornada até o Monumento 19 em Salesópolis"},{"id":"af4deea0-abf8-4ea3-93da-ae0fe08ec00a","type":"paragraph","value":"Para quem vive a cultura das duas rodas, o final de semana não é apenas um descanso, é o momento de colocar o vento na cara e acumular novas histórias. Dessa vez, o destino escolhido foi Salesópolis, seguindo pela famosa Rota Biker com destino ao emblemático Monumento 19.\\nSe você curte poeira, belas paisagens e a resenha boa que só o motociclismo proporciona, acompanha como foi essa nossa jornada.\\nO Ponto de Partida: O Despertar dos Motores\\nO dia começou cedo. Às 07h da manhã, o ponto de encontro já estava definido: o Posto Jardim dos Pinheiros. À medida que os relógios se aproximavam do horário, o ronco dos motores começava a quebrar o silêncio da manhã. Abraços, ajustes finos nos equipamentos e tanques cheios. Era hora de partir."},{"id":"d01e253e-7b5c-491e-aab8-65e5f52ba160","type":"paragraph","value":"Parada Obrigatória: Café da Manhã no Rancho da Moto\\n\\nTodo bom motociclista sabe que o caminho é tão importante quanto o destino, e uma parada para o café é sagrada. Seguimos rodando até o Rancho da Moto.\\nAo chegar lá, uma surpresa: o lugar estava completamente lotado! O pátio era um verdadeiro mar de motos de todos os estilos e cilindradas. Mesmo com o movimento intenso e a casa cheia, o clima era de pura camaradagem. Conseguimos encostar, tomar aquele café reforçado para dar energia e, claro, jogar muita conversa fora com a galera. O ambiente do Rancho nunca decepciona; a energia de ver tanta gente compartilhando a mesma paixão torna tudo muito agradável."},{"id":"2c818cca-187f-4643-a61b-e2be0ddfacf9","type":"image","value":"https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/00e28f3f-4a42-4cb4-a93b-6d6132afe1e0-WhatsApp Image 2026-06-26 at 13.57.37.jpeg"},{"id":"66943d68-aa77-4dc8-929c-1bb57adebdaf","type":"paragraph","value":"O Desafio e a Recompensa: Monumento 19\\nDe barriga cheia e alma renovada, pegamos a estrada novamente rumo ao objetivo principal: o Monumento 19.\\nPor ser um ponto clássico e muito visado por quem faz a Rota Biker, sabíamos que não estaríamos sozinhos. Quando chegamos, nos deparamos com uma fila de cerca de 1 hora para conseguir acessar e registrar o momento.\\n    A filosofia da estrada: Para o verdadeiro biker, a espera não é um problema, mas sim parte da resenha.\\nAproveitamos o tempo de fila para conversar, rir das histórias do caminho e planejar os próximos destinos. Quando finalmente chegou a nossa vez, valeu cada minuto. O visual e a energia do lugar são incríveis. Registramos o momento com muitas fotos — daquelas que vão direto para o grupo da família e para as redes sociais para eternizar o final de semana.\\nMoto Turismo na Essência\\nNo fim das contas, passeios como esse nos lembram o porquê de gostarmos tanto de motos. Não se trata apenas da velocidade ou do destino final, mas sim das parcerias, da paciência na fila, do café compartilhado e das memórias que ficam guardadas na bagagem da vida.\\nSalesópolis e a Rota Biker entregaram tudo o que prometiam. Até o próximo acelerada!\\n\\nE você, já fez a Rota Biker até o Monumento 19? Como estava a fila no seu dia? Deixe seu comentário!"},{"id":"db813896-c68a-418f-a5c0-ea7de1f41350","type":"image","value":"https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/26c62d68-5f66-437b-82ae-8ddf92ee6095-1.jpg"}]	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/580cefe6-a71a-49f2-a286-2b768f0f9059-2.jpg	Passeio	published	2026-06-21 00:00:00+00	\N	2026-06-26 17:13:38.485622+00	2026-06-26 17:32:37.454777+00
\.


--
-- Data for Name: poll_options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.poll_options (id, poll_id, text, image_url, "order", created_at) FROM stdin;
c325ec88-61d2-4b4f-80ce-1806db9124ea	5879d48c-8601-40e0-b272-f5c3c3d836e1	(O Clássico): "Estilo inteiro, grande, ao centro do peito. O símbolo é a nossa essência: café, moto e estrada."	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/c29f9e1b-7395-431d-a1a2-40fcc1fade4b-065574a8-9d49-4fc6-8ce2-f50947053199.jpeg	0	2026-06-26 19:48:23.816485+00
316649da-9bf4-47bb-b365-b36a8d5d23d0	5879d48c-8601-40e0-b272-f5c3c3d836e1	(Asfalto): "Selado de forma discreta no peito esquerdo, com o nome do clube e estilo minimalista."	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/87a73d9f-1afa-4f4a-ba3a-9fbda7426c43-WhatsApp Image 2026-06-24 at 18.22.01.jpeg	1	2026-06-26 19:48:23.816485+00
581defd1-76a3-4387-9d08-529ce9f4ae6f	5879d48c-8601-40e0-b272-f5c3c3d836e1	(Estrada): "Foco na aventura e no design robusto que acompanha cada quilômetro rodado."	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/8027ca19-ea02-4113-af10-704d3e7f4ade-WhatsApp Image 2026-06-24 at 18.22.15.jpeg	2	2026-06-26 19:48:23.816485+00
a8e66ad5-fe89-4871-bf97-44087de17e11	5879d48c-8601-40e0-b272-f5c3c3d836e1	(Pedra Grande): "Nossas raízes em Atibaia, com um toque de respeito, liberdade e estradão."	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/493d18e0-e4fc-4484-a6bb-cb0c8a69d649-WhatsApp Image 2026-06-24 at 18.22.28.jpeg	3	2026-06-26 19:48:23.816485+00
1b44bd0f-8edf-4988-92f9-0c0433fdcd5c	b9a5f568-82be-4f89-baa7-a3cd3d10e364	Sim	\N	0	2026-06-30 10:31:23.219354+00
1807a7b9-458e-4874-97c8-a17d838f8981	b9a5f568-82be-4f89-baa7-a3cd3d10e364	Não	\N	1	2026-06-30 10:31:23.219354+00
\.


--
-- Data for Name: poll_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.poll_votes (id, poll_id, option_id, profile_id, created_at) FROM stdin;
b7340154-3aca-448a-a3b0-92e7a2b7333d	b9a5f568-82be-4f89-baa7-a3cd3d10e364	1b44bd0f-8edf-4988-92f9-0c0433fdcd5c	91291c73-587a-4d9e-a4fc-563a6c5fb255	2026-07-02 17:20:13.002143+00
46880d07-20be-4bbc-b1a0-d1024285ca11	5879d48c-8601-40e0-b272-f5c3c3d836e1	581defd1-76a3-4387-9d08-529ce9f4ae6f	91291c73-587a-4d9e-a4fc-563a6c5fb255	2026-07-02 17:23:21.035712+00
613bec59-6bfc-4b74-ac30-d651e9570d95	5879d48c-8601-40e0-b272-f5c3c3d836e1	a8e66ad5-fe89-4871-bf97-44087de17e11	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	2026-07-03 12:55:41.661413+00
bd39afce-a676-41e2-8ca7-9881e036531a	b9a5f568-82be-4f89-baa7-a3cd3d10e364	1b44bd0f-8edf-4988-92f9-0c0433fdcd5c	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	2026-07-03 12:56:10.523733+00
\.


--
-- Data for Name: polls; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.polls (id, title, description, image_url, status, created_at) FROM stdin;
5879d48c-8601-40e0-b272-f5c3c3d836e1	Estamos finalizando os detalhes das nossas camisetas e queremos a opinião de vocês! Qual destas descrições combina mais com o espírito do nosso grupo?		\N	active	2026-06-26 19:48:22.569706+00
b9a5f568-82be-4f89-baa7-a3cd3d10e364	Passeio Socorro		https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/50f9dba0-e846-4fef-bc19-ac9531cc3341-253373.jpg	active	2026-06-30 10:31:23.15408+00
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, full_name, nickname, city, phone, avatar_url, instagram, created_at, updated_at, birthdate, partner_id, member_type) FROM stdin;
91291c73-587a-4d9e-a4fc-563a6c5fb255	Douglas Gregorio	\N	\N	\N	\N	\N	2026-07-01 15:34:34.861871+00	2026-07-01 15:34:34.861871+00	\N	\N	piloto
41cf18bd-a62d-49d5-b042-eb22b8401523	Kelly Cerqueira Almeida	\N	\N	\N	\N	\N	2026-06-24 15:46:23.721857+00	2026-07-02 18:42:30.433835+00	2026-11-16	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	garupa
0b3b5902-bc9d-4245-a36f-bf0b80b418e1	Alexandre Duque de Almeida	\N	\N	5511941779393	\N	\N	2026-06-24 15:39:34.415831+00	2026-07-02 18:42:30.433835+00	1975-03-27	41cf18bd-a62d-49d5-b042-eb22b8401523	piloto
ada49681-3ab5-43ce-bc4e-4eefef99d1f1	John Doe	\N	\N	\N	\N	\N	2026-07-03 14:50:29.663222+00	2026-07-03 14:50:29.663222+00	\N	\N	piloto
6e400277-94ad-49bd-8e89-02299f919b06	Teste 	\N	\N	\N	\N	\N	2026-07-04 19:21:00.685225+00	2026-07-04 19:21:00.685225+00	\N	\N	piloto
0950e079-e1de-422c-8158-6015a6bd3b16	admin	\N	\N	\N	\N	\N	2026-07-04 20:19:41.914983+00	2026-07-04 20:19:41.914983+00	\N	\N	piloto
\.


--
-- Data for Name: route_photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.route_photos (id, route_id, profile_id, photo_url, created_at) FROM stdin;
7eafb32f-29e4-4a5a-9177-0e238d5ae218	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/cb072cb0-d948-4ba0-8178-78d17c2a4505-2.jpg	2026-06-29 12:58:50.483883+00
ce6518a3-29c8-45d2-a083-1466f06440a8	10bf12af-0205-4a42-bf2c-02792877a460	41cf18bd-a62d-49d5-b042-eb22b8401523	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/d1bbd18d-e006-40f9-bb6e-8980486baaad-WhatsApp Image 2026-06-26 at 13.57.37.jpg	2026-06-29 12:59:35.28353+00
d78f02eb-b93f-4b67-a0a0-b5455cbb7b48	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/38255036-945d-4da5-8693-278f27d3fcd5-248421.jpg	2026-06-29 13:04:17.451574+00
16691eb2-9bb4-4b81-874c-fab8aa30a3d4	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/a7c9d71e-2f2c-475b-96da-56e3935d8a94-248426.jpg	2026-06-29 13:05:24.418563+00
68d47883-8f0e-4c33-95ac-2679ea63bca0	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/331f192a-05c4-4041-8875-c2746d6ee6a8-248475.jpg	2026-06-29 13:06:04.310922+00
f54ef344-f34f-4ea6-8e9d-f2c928a5f75e	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/db127461-7373-4c5f-a3bb-671bf03ddc3e-248358.jpg	2026-06-29 13:07:19.11435+00
197a846b-928b-4bad-872c-9de4a38a8651	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/a0349956-8f6a-4750-b45a-51ebbfe220a0-248495.jpg	2026-06-29 13:33:10.954682+00
a5eca7ce-f0b2-43ef-81e4-2f68a94ffc28	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/cdb0af8b-95d4-475d-8c81-6eaa9cf0ef56-248557.jpg	2026-06-29 13:33:12.262646+00
71f11ab0-e1ab-4088-8022-4339aa4071be	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/6929d808-2b27-4aae-8e7c-d5e091e13d2d-248483.jpg	2026-06-29 13:33:13.508946+00
7e172c1a-67b1-4659-ba76-5f951eebf412	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/c0a89ec1-a471-4578-bd0b-5e98f8ad18e7-248545.jpg	2026-06-29 13:33:14.196286+00
8d63294e-1450-4a6c-a06f-b6f0aef4efb3	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/675c1e8f-d4a6-48fb-8b28-dd0fde98892b-248509.jpg	2026-06-29 13:33:14.895525+00
7637ff45-57c8-442f-b0d3-783e04fed064	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/6c757037-c79f-45c4-bb08-b94d5b354a8e-248536.jpg	2026-06-29 13:33:15.661015+00
50f4f8ad-b45c-41b6-b6e2-1f5d6f0dd324	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/5ad25a9a-4c64-4b44-9473-e95ca7f3a182-248490.jpg	2026-06-29 13:33:16.320493+00
0dfade81-f11a-4ed9-9adf-b5a3555c9fb8	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/6432fe78-6736-4010-b87a-044fb4d17a1d-248500.jpg	2026-06-29 13:33:16.835229+00
abedd658-9743-4f24-ac93-26f5029d3480	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/14258d68-ad1b-47a2-80d2-684831594e83-248498.jpg	2026-06-29 13:33:17.34396+00
92d1d321-c7e3-4eeb-bdad-71a90476dc79	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/bc2ba74b-0d0f-4e53-a9e8-5d50e47917b2-248444.jpg	2026-06-29 13:33:17.877782+00
785cdd35-f605-4ed7-9ad4-ff62a3bf6a69	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/1941a9ae-ad18-48c0-85b6-f714001795a5-248361.jpg	2026-06-29 13:33:18.39353+00
81facd59-1cdd-487a-a467-a6aaeadd65c8	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/9091d93b-6502-41c8-b6a9-c3a80e45b5a4-248336.jpg	2026-06-29 13:33:18.998066+00
c1e5e9dc-dbbb-47e0-a81e-ac859ac6d30e	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/53863250-0526-41af-8b96-eaa592f86551-248324.jpg	2026-06-29 13:33:19.579889+00
c4728e41-fc36-4c35-9f90-8090298d7fe2	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/867b4a1f-3a74-4d07-b5b4-dc0f883e58e8-248504.jpg	2026-06-29 13:33:20.101845+00
e1763443-c67a-4f5c-8dd6-25c88e9548b4	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/a0109501-08c8-41e8-913c-31f3601c7a6b-248524.jpg	2026-06-29 13:33:20.599039+00
3b23fd18-fc96-466d-9463-51c4b6f2d90c	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/b267b053-7af8-4d8b-a944-1305d5956e0b-248518.jpg	2026-06-29 13:33:21.082375+00
5414faf3-fc56-4b57-a487-69bcebc1413e	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/d53b2572-3903-4dbf-b4de-6221a083e94c-248539.jpg	2026-06-29 13:33:21.62543+00
c91138a4-bbd9-41ef-ae1e-bc0af5ce6860	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/17991c37-d7cf-4bd9-a52c-89879320b524-248523.jpg	2026-06-29 13:33:22.333982+00
ec3d6c4f-c613-4194-88a8-ec530e3a4c44	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/87f21555-78f3-42e1-b64e-73d994c10ace-248441.jpg	2026-06-29 13:33:22.872871+00
ae01d549-cb14-4c9c-8c33-c4e20778c4cd	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/5d9ee8c2-9be9-4763-a688-2111ecc27efd-248469.jpg	2026-06-29 13:33:23.384692+00
06988172-1d14-4af5-a18e-8566ecb649cd	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/c177aaa1-54ed-478f-9eac-785be9689df0-248474.jpg	2026-06-29 13:33:23.92477+00
329116b5-8ef4-4999-9869-04762ab342a0	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/f475eb09-1dff-4573-828d-d94077297242-248481.jpg	2026-06-29 13:33:24.459338+00
f06665f3-6cc8-4321-a5ce-5dcbd95d6b2a	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/8832dc7d-9bf7-49d8-8900-a9e9c7f18858-248463.jpg	2026-06-29 13:33:24.998109+00
2992f76e-3831-41ed-8ba2-f026d0a05592	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/ddc8e205-d027-4dbc-a64b-6678a5cbe64e-248352.jpg	2026-06-29 13:33:25.619272+00
07a316e5-9fa2-4837-a891-728112a0d257	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/7f514971-6150-4a91-b13a-e04d109d1265-248330.jpg	2026-06-29 13:33:26.103918+00
4de71f1d-58ac-4f5d-8f93-52a6ebc1d8da	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/6938d4c9-dec8-44b2-be26-35bd3f2f9059-248296.jpg	2026-06-29 13:33:26.616023+00
862ad6e7-a794-4490-9c33-6eb6d9d95f16	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/3feb982b-77a8-4a30-81a5-3df2d1ae555c-248298.jpg	2026-06-29 13:33:27.158538+00
1414ab3b-f61b-431d-959e-9d33268f8270	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/c80a2265-a363-4e42-bb76-131cd4419412-248292.jpg	2026-06-29 13:33:27.66546+00
7f9d036e-060b-4b9e-89d4-7d4ac4e9e729	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/caeb1852-bf8e-4108-b105-f12f88fcdb4e-248272.jpg	2026-06-29 13:33:28.279762+00
b80b138c-4468-4839-b77e-0f1114b509c5	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/f6d22e8c-0331-422f-b588-9157af296349-248244.jpg	2026-06-29 13:33:28.822672+00
762e615c-6b78-44ea-b3f2-4e19ddfd7664	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/b1e09765-e7ee-48bb-840f-7fce5637fb2a-248232.jpg	2026-06-29 13:33:29.365047+00
9c8a06e2-6e8a-4e4c-bc17-04e2652735a0	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/b6ef61d4-8d86-419f-b6e8-0a7c293ac033-248216.jpg	2026-06-29 13:33:29.874821+00
d7a61904-c8fb-4113-b072-334c739df29a	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/8a93dc89-cabc-4be0-85c9-d02281aec646-235459.jpg	2026-06-29 20:49:44.703532+00
9c5528bf-665b-4565-b1f5-51f155e90902	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/d282b956-8d89-4840-9986-be196652d5bb-9132.jpg	2026-06-29 20:49:45.550169+00
dd84fa0e-9496-47be-b8e8-5279169d56a1	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/a80e649f-da6f-4e3d-a78f-8c8ba248576b-9130.jpg	2026-06-29 20:49:46.28767+00
a955f1bc-a146-4dfe-8013-79733521d3a4	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/55edd64d-a333-4c33-b116-59cdf462c136-9133.jpg	2026-06-29 20:49:47.1365+00
1a1549a1-73ee-4214-ac8f-d92d57889521	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/dfc9a5eb-4bbb-44c3-8081-a346d004d1ad-9137.jpg	2026-06-29 20:49:47.711456+00
539fc06d-d8c1-4146-a960-4336328f78f1	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/f53a7f0c-0f76-4b94-8e04-5f92e714372a-9136.jpg	2026-06-29 20:49:48.232985+00
6b89c5ef-1f86-442d-a5cc-2e77082757b8	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/6027166a-6dd2-43e5-bdb9-d082fa719fc6-9147.jpg	2026-06-29 20:49:48.768072+00
f8b0cd00-f66c-481f-9b7c-8d7451796b05	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/e4f71d08-3199-466f-b017-8f267bb6921b-9138.jpg	2026-06-29 20:49:49.332742+00
02168e94-40a2-4ad5-a2eb-0689006318be	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/7d952231-ce63-4d1a-83fb-831388f671c6-9148.jpg	2026-06-29 20:49:50.064526+00
e5460a07-f898-4956-b968-3899b033ee1a	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/741ffb27-f9f0-4aee-a8c5-a49db7dd15f3-9120.jpg	2026-06-29 20:49:50.647538+00
c367a045-0845-40a1-aa55-5a7de829b476	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/2f50f63f-3353-4807-a4ed-c4808ae7d7b5-9152.jpg	2026-06-29 20:49:51.182402+00
1a8ece47-146f-4017-9a63-990513127c44	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/e320076c-d24a-4ddc-a671-f41f0deeb9b9-9153.jpg	2026-06-29 20:49:51.76535+00
03194e87-c11a-4ba5-bc6f-a3f60cd1b5d7	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/47c95f63-796f-4f23-a5fe-d211059773c8-9169.jpg	2026-06-29 20:49:52.574781+00
24965f0d-0801-46c2-b3af-48736edd290c	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/2dc0a3d6-84c8-4224-ab61-beea0e0def93-9168.jpg	2026-06-29 20:49:53.270091+00
3a0a1049-9e20-4c68-828c-b55f5fc98848	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/2c900460-a97e-44f0-869d-1be7f3a48b52-9173.jpg	2026-06-29 20:49:53.813984+00
dda2202c-eb66-43d1-b749-716e5979ac0d	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/90058f31-662e-4a46-8222-e01c31ae89df-9171.jpg	2026-06-29 20:49:54.388798+00
a647148a-0386-4bb0-9e23-962fa271fa9f	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/99398d2d-c310-4cf4-a9cd-35ba77d4573f-9175.jpg	2026-06-29 20:49:54.938537+00
72b6e1b0-99fd-4b59-94c7-ea0ccea99d77	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/bb3b7e97-725b-4c5d-adce-2874c21088a4-9188.jpg	2026-06-29 20:49:55.489148+00
6a5e7312-07f7-4370-b035-230225db1818	2c887b2d-a964-461b-854f-3bf30ab87f68	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/66c66803-1449-4389-8c53-5f38045f5081-9189.jpg	2026-06-29 20:49:56.202539+00
51b07e9f-e35a-4f6e-8b25-e2e63727c2cf	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/f123e6ac-4594-4407-a807-94c0d95deac1-219535.jpg	2026-06-29 20:52:01.719899+00
64135731-6056-440a-b272-ede0c0d88fc6	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/c11330f7-0fc9-491a-9982-8357c58b6b2c-219539.jpg	2026-06-29 20:52:02.425773+00
ea72e82e-afaf-4726-bf69-13d8a5e3a72f	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/b7cd3bb3-7b37-4067-9c38-299669392622-219527.jpg	2026-06-29 20:52:03.082001+00
708c4c56-2b1b-43ef-a09a-02bf426a4eda	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/b0944b9a-69f6-4e2f-be25-982f972f344b-219537.jpg	2026-06-29 20:52:03.647658+00
825424dd-cd2f-4bac-8e41-04caa9ba97c3	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/e66dd4c0-2642-4fca-ba6e-61d14dc2646c-219531.jpg	2026-06-29 20:52:04.175722+00
d57ee745-e0f9-4d7f-8273-31de2e942656	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/a79a7bd2-bdfc-4b18-b527-0767d4913b9b-219372.jpg	2026-06-29 20:52:04.882733+00
84d8465d-1ca6-48b9-87af-73d10bebd32b	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/ae4e1266-bfef-48f6-8565-f0d12599b41a-219370.jpg	2026-06-29 20:52:05.622405+00
ac555723-0047-444b-baa9-319dd2f4c7ce	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/f1414c11-3f92-4459-9f57-384f1528dca9-219374.jpg	2026-06-29 20:52:06.309799+00
b864fa8f-44e1-4b2c-8d4f-770c54d6e552	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/63627f3a-6c20-4a2c-b33d-9d018f1f5e71-219376.jpg	2026-06-29 20:52:07.066547+00
8844e376-298a-4268-8861-fc36545d63a3	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/abd2717d-3196-4aad-b902-349725a6dc46-219380.jpg	2026-06-29 20:52:07.625952+00
36b3e89b-29d5-4050-87f1-c3e6f1f86e32	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/c5ac1e92-8b9d-4366-93ee-ad08cd8b790f-219367.jpg	2026-06-29 20:52:08.313458+00
02493e98-60ef-4624-a171-15e946e9a98b	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/d99f1dcb-72f7-4f9d-acc5-f7933d23b066-219364.jpg	2026-06-29 20:52:09.014278+00
88277c94-1185-4914-bb49-9de25ae8d488	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/1d70afad-9dd7-4c29-80bf-860359366a35-219352.jpg	2026-06-29 20:52:09.582877+00
84b8b84f-e2e8-4573-8528-d161eb5f38cb	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/3dc130f9-1ce5-434d-ba24-7c58bcd55f56-219321.jpg	2026-06-29 20:52:10.172452+00
6dae2e09-2675-43b1-8ce6-141a218d4066	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/aea98748-aa40-4f91-b394-d981ac4c76cb-219308.jpg	2026-06-29 20:52:10.686969+00
271fb409-2892-4182-97dd-8045ad7280b4	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/1549ba99-fa1d-49dd-a221-e8753bc79650-219311.jpg	2026-06-29 20:52:11.211543+00
0f776ff7-00bf-4781-9ede-a524d6be6cc8	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/79d83a6a-ee89-4f7e-936d-4425df47d567-219305.jpg	2026-06-29 20:52:11.739042+00
83a09c52-5be9-4ace-97ab-ba6e12e5cd84	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/1a7bac71-d76f-4425-8fe1-bfde4eed2f23-219254.jpg	2026-06-29 20:52:12.402864+00
c18f01e5-1235-489a-bce0-bca113b63ed9	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/805cea98-ddb6-48eb-bb85-94964ba2aa01-219213.jpg	2026-06-29 20:52:13.098749+00
6c9758d5-f100-4d09-b94e-07367ff4aa71	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/fae11bd4-dd5f-4ed1-b359-093f31c9dc5b-219211.jpg	2026-06-29 20:52:13.665663+00
93316161-d708-49ae-813e-f41a9231ba3d	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/458dadf5-48ab-474a-88aa-e70b9b4a2675-219192.jpg	2026-06-29 20:52:15.325458+00
37dbffdf-7b24-438c-be76-b01b1bc588ad	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/7767567c-9098-4e45-b392-4d187d67bdca-218951.jpg	2026-06-29 20:52:17.0454+00
509f30a7-cd9b-41bf-9bb4-ac36d86fe9c2	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/52b43a62-9d07-406b-b8fd-9837986f0be6-219199.jpg	2026-06-29 20:52:14.20815+00
7083d0fa-38c1-4319-a001-3d4c241ef411	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/3532d3cb-6a82-421f-8561-60d4cb28cfcc-219003.jpg	2026-06-29 20:52:15.957723+00
a6dea0c3-8f25-49fa-a6c0-d46ab3b99800	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/4c17f133-3e36-4f98-8ace-caa668c72744-219180.jpg	2026-06-29 20:52:17.534553+00
84cfb8ba-720c-4d6a-bca3-d3866700bd94	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/b4078d82-2a71-497c-acc5-41b4c4b8a754-219186.jpg	2026-06-29 20:52:14.709413+00
96054115-5c45-4656-8b01-3cdb3acaa38f	d1a5767d-74df-4189-a711-d1fa6709af4a	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/b44e125b-32b7-4a27-ac18-744d6d912131-219000.jpg	2026-06-29 20:52:16.493596+00
847bb3c3-c243-46b7-906a-ba442a92d039	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/b2dd0013-1d17-40ea-b2a8-1cedc9c52c24-4258.jpg	2026-06-29 20:55:25.137702+00
6f5b9857-32b6-405a-9764-6e09a2e67c56	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/55b07571-fd6f-4b40-bd28-593a924a0fd4-4260.jpg	2026-06-29 20:55:26.135075+00
5ef393ca-e482-456b-9d93-bdb4f4b4258c	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/cdcce870-d59a-4887-a6a5-6953d8df8f42-4261.jpg	2026-06-29 20:55:27.121058+00
18e7a587-7df5-4a62-a9a9-35b053d83aa6	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/5a5d35de-b917-43fb-91f5-1df635391fd8-4299.jpg	2026-06-29 20:55:27.969161+00
d5f24a9d-d45d-4fdf-83b4-b92e572c70df	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/7424e95b-d3c2-4178-8edf-686ae3555e5d-4304.jpg	2026-06-29 20:55:29.168981+00
c19a595d-dbb1-468f-bfcd-db809bda0e01	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/d0b0ca4c-4e78-4c6c-a0d0-fb7e06d4aec1-4309.jpg	2026-06-29 20:55:30.03933+00
1a7d7929-f704-44d4-9e92-fa586db242cd	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/6f0903ff-77ee-44da-b53e-757f8c8d5708-4312.jpg	2026-06-29 20:55:31.013769+00
c7d80931-eb04-4935-901d-1280f78e498e	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/8b81f2ee-4f3c-46cc-a798-02cd1e5e315b-4310.jpg	2026-06-29 20:55:32.246755+00
8a6cee07-a95a-4ab3-ba62-42028fe97424	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/cd905b61-6672-41f5-8b2c-dd9a0d83c10b-4314.jpg	2026-06-29 20:55:33.038785+00
1333b2e9-f06c-41f2-9936-62ef02b7e51b	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/41eb34b7-1040-497d-aedf-58bcfbac190e-4264.jpg	2026-06-29 20:55:33.847466+00
ea47ccea-ca8f-474f-a2a7-2bf9d5727804	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/79f5a6d1-2202-4744-b597-6ed7987e4dcb-4265.jpg	2026-06-29 20:55:34.691519+00
09cb58a2-4202-47e1-b105-a81a6e97e251	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/0e775ff9-90dc-4dbf-a4cb-095fc5a25c79-4266.jpg	2026-06-29 20:55:35.696524+00
9a181602-e98c-4b34-8997-961dfaade512	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/7bbcc3bb-5c47-438c-9566-7481ca977f80-4267.jpg	2026-06-29 20:55:36.516414+00
c2750568-7d4c-4284-a974-7f2b5c02f96c	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/0bfd60e3-fae0-4e11-8f1f-0b6ddea6dc27-4268.jpg	2026-06-29 20:55:37.477383+00
1f385410-b713-4a53-b4e5-57832e40eaba	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/2ed1fb87-f3a4-4118-a44a-adc5917ee3e0-4270.jpg	2026-06-29 20:55:38.453122+00
7c58dafb-df8b-4366-9e4e-d8e6a7c6ec4b	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/92db0203-a2b5-4d82-b536-71a9ef2e41e6-4271.jpg	2026-06-29 20:55:39.404875+00
c83e39f8-ee47-4c09-993f-12be907e7787	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/00a1ac05-cbe4-471a-ac4d-c471cc87728c-4276.jpg	2026-06-29 20:55:40.404944+00
a44d566b-b97a-479d-bc85-78ba9567f30a	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/036bbe22-136f-48b4-a756-90dcda89b21f-4277.jpg	2026-06-29 20:55:41.375739+00
00dc9167-789d-4321-ac71-12ea689b01fe	0ec44b75-b822-4477-a22f-4cd0eb66b585	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/2078d831-91fe-434c-b01d-bb140f3f30bc-4281.jpg	2026-06-29 20:55:42.180686+00
1f03eabb-69ff-449a-8b4a-f7f656b1a8cc	10bf12af-0205-4a42-bf2c-02792877a460	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/c5a1edf4-32e0-441e-9147-7d5b805fbc5d-250462.jpg	2026-07-02 17:23:34.324889+00
\.


--
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.routes (id, title, description, destination, start_date, meeting_point, meeting_time, estimated_distance_km, waze_url, media_url, created_at, created_by, status, estimated_duration_mins, visited_places, route_type, has_financial_plan) FROM stdin;
0ec44b75-b822-4477-a22f-4cd0eb66b585	Passeio de Pedra Bela	Pedra Bela é uma pequena e charmosa cidade no interior de São Paulo. Fica na Serra da Mantiqueira, a cerca de 1.120 metros de altitude. É muito famosa pela Mega Tirolesa, considerada uma das maiores do mundo, e pelo seu clima agradável de montanha.	Pedra Bela - SP	2024-07-14 10:00:00+00	Posto Pedra Grande	07:00:00	62	https://ul.waze.com/ul?place=ChIJRW9AroVLyZQRwHi7qU6q_18&ll=-22.79479840%2C-46.44335750&navigate=yes&utm_campaign=default&utm_source=waze_website&utm_medium=lm_share_location	\N	2026-06-25 13:51:28.001654+00	\N	completed	120	Pedra Bela	passeio	f
2c887b2d-a964-461b-854f-3bf30ab87f68	Monte Verde	Monte Verde é um charmoso distrito de Camanducaia (MG), localizado a cerca de 160 km de São Paulo. Conhecida como a "Suíça Mineira", a cidade é famosa pelo clima frio, arquitetura europeia e romantismo. É o destino perfeito para casais e amantes da natureza.	Monte Verde - MG	2026-03-18 10:00:00+00	Posto Pedra Grande	07:00:00	104	https://ul.waze.com/ul?place=ChIJ1QdTET4QzJQROiVu16xnmgA&ll=-22.86268810%2C-46.03646040&navigate=yes&utm_campaign=default&utm_source=waze_website&utm_medium=lm_share_location	\N	2026-06-25 18:18:22.141234+00	\N	completed	120	Monte Verde	passeio	f
d1a5767d-74df-4189-a711-d1fa6709af4a	Passeio Joanopolis	Joanópolis é uma cidade turística na Serra da Mantiqueira, a cerca de 120 km de São Paulo. Conhecida como a "Capital do Lobisomem", é famosa pela Cachoeira dos Pretos (segunda maior do estado, com 154 metros) e pelas trilhas, turismo rural e comida caipira.	Joanopolis	2026-05-03 10:00:00+00	Posto Jd dos Pinheiros	07:00:00	70	https://www.waze.com/live-map/directions/cachoeira-dos-pretos-est.-para-a-cachoeira-joanopolis?to=place.w.205653538.2056731992.7001416&from=place.w.205391393.2054110536.255591&utm_medium=lm_share_directions&utm_campaign=default&utm_source=waze_website	\N	2026-06-25 18:24:38.08297+00	\N	completed	80	Cacheora dos Pretos	passeio	f
10bf12af-0205-4a42-bf2c-02792877a460	Passeio Salesopolis	Salesópolis abriga o Monumento Rota Biker número 19, localizado no Rancho Terra Crua. Ele fica às margens da Represa do Rio Paraitinga. Os motociclistas costumam chegar a partir de São Paulo ou do Alto Tietê pela Rodovia SP-088, passando por Santa Branca.	Salesópolis abriga o Monumento Rota Biker número 19	2026-06-21 10:00:00+00	Posto Jd dos Pinheiros	07:00:00	120	https://ul.waze.com/ul?place=ChIJywLkHAC_zZQR8zdfNg7FZp4&ll=-23.52126190%2C-45.89830790&navigate=yes&utm_campaign=default&utm_source=waze_website&utm_medium=lm_share_location	\N	2026-06-25 18:34:30.911893+00	\N	completed	120	\N	passeio	f
88408c00-e8a2-472b-ad01-867f86fed2b1	Viagem Santa Catarina	Planejamento Viagem Santa catarina	Santa Catarina - SC	2026-10-30 20:49:00+00	em aberto	09:00:00	\N	\N	\N	2026-07-02 17:53:01.417378+00	\N	planning	\N	Urubici	viagem	t
a82753fa-9d15-4394-b738-dd68ee63fbea	Socorro - Monumento Rota Biker 12	\N	Socorro - SP	2026-07-12 14:57:00+00	Posto Jardim dos Pinheiros	07:00:00	73	https://www.waze.com/live-map/directions/br/sp/monumento-rota-biker-12?utm_medium=lm_share_directions&utm_campaign=default&utm_source=waze_website&to=place.ChIJ3cm-WwA_yZQRI50dnFsw--4&from=ll.-23.10894841%2C-46.52423736	\N	2026-07-01 12:01:37.979949+00	\N	open	70	Bragança Paulista , Socorro	passeio	t
\.


--
-- Data for Name: site_content; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.site_content (key, value, status, updated_at) FROM stdin;
general	{"logo_url": "https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/ecc2cfd4-b3fc-4367-8458-48e267561e96-Design sem nome(2).svg"}	published	2026-06-24 20:30:22.931971+00
contact	{"email": "contato@cafemotoasfalto.com.br", "address": "Atibaia — São Paulo — Brasil", "whatsapp": "Solicite o contato pela mensagem ao lado", "instagram": "@cafe_moto_asfalto"}	published	2026-06-25 22:01:46.527285+00
club_story	{"title": "Café Moto e Asfalto", "paragraph": "Tudo começou com um grupo de amigos, algumas motos e uma vontade enorme de pegar a estrada.\\n\\nCriamos esse espaço pra dividir o que move a nossa turma: o cheiro do asfalto de manhã cedo, o café quente numa parada no meio do caminho e as paisagens do interior de SP — e além — que só quem anda de moto conhece de verdade.\\n\\nDe Pedra Bela, Monte Verde, Joanópolis, Salesópolis e muitos outros que estão por vir, cada rolê vira história e a amizade se fortalece. Aqui a gente compartilha nossos passeios, viagens, paradas e os melhores momentos da estrada."}	published	2026-06-25 22:01:47.724212+00
hero	{"title": "Café quente.\\nAsfalto livre.", "eyebrow": "Atibaia · SP · Desde 2024", "subtitle": "\\"O primeiro de muitos quilômetros juntos.\\" Um grupo de amigos, algumas motos e uma vontade enorme de pegar a estrada.", "cta_label": "Conheça o clube", "bg_image_url": "https://electrosal-erp-media.s3.us-east-2.amazonaws.com/motoclube/286b92c3-2d73-4d64-b889-4f49c6f91bba-bk1.jpg"}	published	2026-06-25 22:06:05.604349+00
\.


--
-- Data for Name: trip_financial_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trip_financial_plans (id, route_id, profile_id, costs, observations, fuel_calc, has_passenger, created_at, updated_at) FROM stdin;
b3218148-34c3-471a-a247-2d18e6423d4c	88408c00-e8a2-472b-ad01-867f86fed2b1	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	{"outros": 0, "pedagio": 0, "reserva": 0, "revisao": 350, "passeios": 0, "hospedagem": 0, "alimentacao": 0, "combustivel": 241.1}	{}	{"price": 6.3, "autonomy": 26, "distance": 995}	t	2026-07-02 18:33:59.093739+00	2026-07-02 18:33:59.093739+00
dfa5ff55-b2fa-4bee-b9dc-fec6ce9f8625	a82753fa-9d15-4394-b738-dd68ee63fbea	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	{"outros": 0, "pedagio": 0, "reserva": 0, "revisao": 0, "passeios": 0, "hospedagem": 0, "alimentacao": 180, "combustivel": 36.35}	{}	{"price": 6.3, "autonomy": 26, "distance": 150}	t	2026-07-03 13:10:19.761947+00	2026-07-03 13:10:19.761947+00
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (id, user_id, role, created_at) FROM stdin;
62361f3b-0032-483c-a083-099ddbf8d761	0b3b5902-bc9d-4245-a36f-bf0b80b418e1	admin	2026-06-24 15:41:58.516912+00
d3e4bda4-e61e-47ba-a9d5-aa6d5a225e25	41cf18bd-a62d-49d5-b042-eb22b8401523	member	2026-06-30 13:21:20.064312+00
c18b0c2a-0bea-421b-815c-e68b8660c202	91291c73-587a-4d9e-a4fc-563a6c5fb255	admin	2026-07-01 16:36:27.072593+00
2052e563-ba32-449b-87a0-fe0c6d30ae3c	6e400277-94ad-49bd-8e89-02299f919b06	admin	2026-07-04 19:24:03.469256+00
f08a22c5-b315-4ffe-b21d-69e6580f304e	0950e079-e1de-422c-8158-6015a6bd3b16	admin	2026-07-04 20:32:28.075907+00
\.


--
-- Data for Name: messages_2026_07_06; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_07_06 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload) FROM stdin;
\.


--
-- Data for Name: messages_2026_07_07; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_07_07 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload) FROM stdin;
\.


--
-- Data for Name: messages_2026_07_08; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_07_08 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload) FROM stdin;
\.


--
-- Data for Name: messages_2026_07_09; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_07_09 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload) FROM stdin;
\.


--
-- Data for Name: messages_2026_07_10; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_07_10 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-06-24 15:37:22
20211116045059	2026-06-24 15:37:22
20211116050929	2026-06-24 15:37:22
20211116051442	2026-06-24 15:37:22
20211116212300	2026-06-24 15:37:22
20211116213355	2026-06-24 15:37:22
20211116213934	2026-06-24 15:37:22
20211116214523	2026-06-24 15:37:22
20211122062447	2026-06-24 15:37:22
20211124070109	2026-06-24 15:37:22
20211202204204	2026-06-24 15:37:22
20211202204605	2026-06-24 15:37:22
20211210212804	2026-06-24 15:37:22
20211228014915	2026-06-24 15:37:22
20220107221237	2026-06-24 15:37:22
20220228202821	2026-06-24 15:37:22
20220312004840	2026-06-24 15:37:22
20220603231003	2026-06-24 15:37:22
20220603232444	2026-06-24 15:37:22
20220615214548	2026-06-24 15:37:22
20220712093339	2026-06-24 15:37:22
20220908172859	2026-06-24 15:37:22
20220916233421	2026-06-24 15:37:23
20230119133233	2026-06-24 15:37:23
20230128025114	2026-06-24 15:37:23
20230128025212	2026-06-24 15:37:23
20230227211149	2026-06-24 15:37:23
20230228184745	2026-06-24 15:37:23
20230308225145	2026-06-24 15:37:23
20230328144023	2026-06-24 15:37:23
20231018144023	2026-06-24 15:37:23
20231204144023	2026-06-24 15:37:23
20231204144024	2026-06-24 15:37:23
20231204144025	2026-06-24 15:37:23
20240108234812	2026-06-24 15:37:23
20240109165339	2026-06-24 15:37:23
20240227174441	2026-06-24 15:37:23
20240311171622	2026-06-24 15:37:23
20240321100241	2026-06-24 15:37:23
20240401105812	2026-06-24 15:37:23
20240418121054	2026-06-24 15:37:23
20240523004032	2026-06-24 15:37:23
20240618124746	2026-06-24 15:37:23
20240801235015	2026-06-24 15:37:23
20240805133720	2026-06-24 15:37:23
20240827160934	2026-06-24 15:37:23
20240919163303	2026-06-24 15:37:23
20240919163305	2026-06-24 15:37:23
20241019105805	2026-06-24 15:37:23
20241030150047	2026-06-24 15:37:23
20241108114728	2026-06-24 15:37:23
20241121104152	2026-06-24 15:37:23
20241130184212	2026-06-24 15:37:23
20241220035512	2026-06-24 15:37:23
20241220123912	2026-06-24 15:37:23
20241224161212	2026-06-24 15:37:23
20250107150512	2026-06-24 15:37:23
20250110162412	2026-06-24 15:37:23
20250123174212	2026-06-24 15:37:23
20250128220012	2026-06-24 15:37:23
20250506224012	2026-06-24 15:37:23
20250523164012	2026-06-24 15:37:23
20250714121412	2026-06-24 15:37:23
20250905041441	2026-06-24 15:37:23
20251103001201	2026-06-24 15:37:23
20251120212548	2026-06-24 15:37:23
20251120215549	2026-06-24 15:37:23
20260218120000	2026-06-24 15:37:23
20260326120000	2026-06-24 15:37:23
20260514120000	2026-06-24 15:37:23
20260527120000	2026-06-24 15:37:23
20260528120000	2026-06-24 15:37:23
20260603120000	2026-06-24 15:37:23
20260605120000	2026-06-24 15:37:23
20260606110000	2026-06-24 15:37:23
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter, selected_columns) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: iceberg_namespaces; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.iceberg_namespaces (id, bucket_name, name, created_at, updated_at, metadata, catalog_id) FROM stdin;
\.


--
-- Data for Name: iceberg_tables; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.iceberg_tables (id, namespace_id, bucket_name, name, location, created_at, updated_at, remote_table_id, shard_key, shard_id, catalog_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-06-24 15:37:28.883952
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-06-24 15:37:28.890607
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-06-24 15:37:28.896165
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-06-24 15:37:28.90572
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-06-24 15:37:28.914164
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-06-24 15:37:28.917957
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-06-24 15:37:28.929544
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-06-24 15:37:28.936486
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-06-24 15:37:28.941725
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-06-24 15:37:28.947037
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-06-24 15:37:28.950102
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-06-24 15:37:28.952581
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-06-24 15:37:28.957031
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-06-24 15:37:28.959548
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-06-24 15:37:28.963927
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-06-24 15:37:28.977344
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-06-24 15:37:28.97945
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-06-24 15:37:28.981516
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-06-24 15:37:28.986253
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-06-24 15:37:28.99043
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-06-24 15:37:28.992662
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-06-24 15:37:28.996172
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-06-24 15:37:29.005653
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-06-24 15:37:29.017507
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-06-24 15:37:29.022849
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-06-24 15:37:29.027856
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-06-24 15:37:29.035969
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-06-24 15:37:29.053971
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-06-24 15:37:29.063447
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-06-24 15:37:29.065356
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-06-24 15:37:29.074482
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-06-24 15:37:29.076919
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-06-24 15:37:29.081656
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-06-24 15:37:29.086994
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-06-24 15:37:29.092849
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-06-24 15:37:29.100095
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-06-24 15:37:29.107741
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-06-24 15:37:29.11379
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-06-24 15:37:29.125665
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-06-24 15:37:29.155464
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-06-24 15:37:29.160003
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-06-24 15:37:29.165416
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-06-24 15:37:29.169641
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-06-24 15:37:29.172383
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-06-24 15:37:29.174349
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-06-24 15:37:29.17873
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-06-24 15:37:29.191855
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-06-24 15:37:29.199095
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-06-24 15:37:29.207701
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-06-24 15:37:29.24038
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-06-24 15:37:29.243887
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-06-24 15:37:29.257975
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-06-24 15:37:29.258835
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-06-24 15:37:29.265906
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-06-24 15:37:29.26739
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-06-24 15:37:29.269444
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-06-24 15:37:29.273401
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-06-24 15:37:29.277112
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-06-24 15:37:29.2788
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-06-24 15:37:29.284593
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-06-24 15:37:29.28739
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
1	18003	route_webhook_trigger	2026-07-02 13:23:44.409225+00	1
2	18003	route_webhook_trigger	2026-07-02 13:27:01.360143+00	2
3	18003	route_webhook_trigger	2026-07-02 13:31:14.211532+00	3
4	18003	route_webhook_trigger	2026-07-02 13:37:26.576087+00	4
5	19485	n8n_webhook_photos	2026-07-02 15:21:25.360171+00	5
6	19485	n8n_webhook_photos	2026-07-02 17:12:57.63944+00	6
7	19485	n8n_webhook_photos	2026-07-02 17:19:21.99039+00	7
8	19485	n8n_webhook_photos	2026-07-02 17:23:34.324889+00	8
9	18003	n8n_webhook_routes	2026-07-02 17:24:57.282891+00	9
10	18003	route_webhook_trigger	2026-07-02 17:24:57.282891+00	10
11	19382	n8n_webhook_polls	2026-07-02 17:26:27.875675+00	11
12	17825	n8n_webhook_profiles	2026-07-02 17:28:26.270195+00	12
13	18003	n8n_webhook_routes	2026-07-02 17:53:01.417378+00	13
14	18003	route_webhook_trigger	2026-07-02 17:53:01.417378+00	14
15	17825	n8n_webhook_profiles	2026-07-02 20:00:35.6806+00	15
16	17825	n8n_webhook_profiles	2026-07-03 14:50:29.663222+00	16
17	17825	n8n_webhook_profiles	2026-07-04 19:21:00.685225+00	17
18	17825	n8n_webhook_profiles	2026-07-04 20:19:41.914983+00	18
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2026-06-24 15:37:11.060687+00
20210809183423_update_grants	2026-06-24 15:37:11.060687+00
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
20260624133651	{"-- updated_at helper\nCREATE OR REPLACE FUNCTION public.set_updated_at()\nRETURNS TRIGGER AS $$\nBEGIN\n  NEW.updated_at = now();\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SET search_path = public","-- ============== PROFILES ==============\nCREATE TABLE public.profiles (\n  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,\n  full_name TEXT,\n  nickname TEXT,\n  city TEXT,\n  phone TEXT,\n  avatar_url TEXT,\n  instagram TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO authenticated","GRANT ALL ON public.profiles TO service_role","ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Users view own profile\\" ON public.profiles\n  FOR SELECT TO authenticated USING (auth.uid() = id)","CREATE POLICY \\"Users insert own profile\\" ON public.profiles\n  FOR INSERT TO authenticated WITH CHECK (auth.uid() = id)","CREATE POLICY \\"Users update own profile\\" ON public.profiles\n  FOR UPDATE TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id)","CREATE TRIGGER profiles_set_updated_at BEFORE UPDATE ON public.profiles\n  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at()","-- Auto-create profile on signup\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS TRIGGER AS $$\nBEGIN\n  INSERT INTO public.profiles (id, full_name)\n  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name', ''));\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public","CREATE TRIGGER on_auth_user_created\n  AFTER INSERT ON auth.users\n  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user()","-- ============== MOTORCYCLES ==============\nCREATE TABLE public.motorcycles (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n  brand TEXT NOT NULL,\n  model TEXT NOT NULL,\n  year INT,\n  plate TEXT,\n  color TEXT,\n  nickname TEXT,\n  current_km INT NOT NULL DEFAULT 0,\n  photo_url TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","GRANT SELECT, INSERT, UPDATE, DELETE ON public.motorcycles TO authenticated","GRANT ALL ON public.motorcycles TO service_role","ALTER TABLE public.motorcycles ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Users manage own motorcycles\\" ON public.motorcycles\n  FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id)","CREATE TRIGGER motorcycles_set_updated_at BEFORE UPDATE ON public.motorcycles\n  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at()","CREATE INDEX motorcycles_user_id_idx ON public.motorcycles(user_id)","-- ============== MAINTENANCE ITEMS ==============\nCREATE TABLE public.maintenance_items (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  motorcycle_id UUID NOT NULL REFERENCES public.motorcycles(id) ON DELETE CASCADE,\n  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n  name TEXT NOT NULL,\n  interval_km INT,\n  interval_months INT,\n  last_change_km INT,\n  last_change_date DATE,\n  notes TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","GRANT SELECT, INSERT, UPDATE, DELETE ON public.maintenance_items TO authenticated","GRANT ALL ON public.maintenance_items TO service_role","ALTER TABLE public.maintenance_items ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Users manage own maintenance items\\" ON public.maintenance_items\n  FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id)","CREATE TRIGGER maintenance_items_set_updated_at BEFORE UPDATE ON public.maintenance_items\n  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at()","CREATE INDEX maintenance_items_motorcycle_id_idx ON public.maintenance_items(motorcycle_id)","-- ============== MAINTENANCE RECORDS (history) ==============\nCREATE TABLE public.maintenance_records (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  motorcycle_id UUID NOT NULL REFERENCES public.motorcycles(id) ON DELETE CASCADE,\n  maintenance_item_id UUID REFERENCES public.maintenance_items(id) ON DELETE SET NULL,\n  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n  item_name TEXT NOT NULL,\n  service_date DATE NOT NULL DEFAULT CURRENT_DATE,\n  km_at_service INT,\n  cost NUMERIC(10,2),\n  workshop TEXT,\n  notes TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","GRANT SELECT, INSERT, UPDATE, DELETE ON public.maintenance_records TO authenticated","GRANT ALL ON public.maintenance_records TO service_role","ALTER TABLE public.maintenance_records ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Users manage own maintenance records\\" ON public.maintenance_records\n  FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id)","CREATE INDEX maintenance_records_motorcycle_id_idx ON public.maintenance_records(motorcycle_id)"}	faef643f-833a-4762-8c1d-3fc828866345
20260624133710	{"REVOKE EXECUTE ON FUNCTION public.set_updated_at() FROM PUBLIC, anon, authenticated","REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM PUBLIC, anon, authenticated"}	1fd79998-d4bc-488f-9f00-678443946314
20260624135721	{"CREATE TYPE public.app_role AS ENUM ('admin', 'member')","CREATE TABLE public.user_roles (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n  role public.app_role NOT NULL,\n  created_at timestamptz NOT NULL DEFAULT now(),\n  UNIQUE (user_id, role)\n)","GRANT SELECT ON public.user_roles TO authenticated","GRANT ALL ON public.user_roles TO service_role","ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY","CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role public.app_role)\nRETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$\n  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role)\n$$","CREATE POLICY \\"Users view own roles\\" ON public.user_roles FOR SELECT TO authenticated USING (auth.uid() = user_id)","CREATE POLICY \\"Admins view all roles\\" ON public.user_roles FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'))","CREATE POLICY \\"Admins manage roles\\" ON public.user_roles FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'))","CREATE TYPE public.content_status AS ENUM ('draft', 'published')","CREATE TABLE public.news (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  title text NOT NULL,\n  slug text NOT NULL UNIQUE,\n  excerpt text,\n  content text,\n  cover_url text,\n  tag text,\n  status public.content_status NOT NULL DEFAULT 'draft',\n  published_at timestamptz,\n  author_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,\n  created_at timestamptz NOT NULL DEFAULT now(),\n  updated_at timestamptz NOT NULL DEFAULT now()\n)","GRANT SELECT ON public.news TO anon, authenticated","GRANT INSERT, UPDATE, DELETE ON public.news TO authenticated","GRANT ALL ON public.news TO service_role","ALTER TABLE public.news ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Public reads published news\\" ON public.news FOR SELECT TO anon, authenticated USING (status = 'published' OR public.has_role(auth.uid(), 'admin'))","CREATE POLICY \\"Admins manage news\\" ON public.news FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'))","CREATE TRIGGER news_updated_at BEFORE UPDATE ON public.news FOR EACH ROW EXECUTE FUNCTION public.set_updated_at()","CREATE TABLE public.gallery_items (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  title text,\n  caption text,\n  image_url text NOT NULL,\n  instagram_url text,\n  sort_order int NOT NULL DEFAULT 0,\n  status public.content_status NOT NULL DEFAULT 'draft',\n  created_at timestamptz NOT NULL DEFAULT now(),\n  updated_at timestamptz NOT NULL DEFAULT now()\n)","GRANT SELECT ON public.gallery_items TO anon, authenticated","GRANT INSERT, UPDATE, DELETE ON public.gallery_items TO authenticated","GRANT ALL ON public.gallery_items TO service_role","ALTER TABLE public.gallery_items ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Public reads published gallery\\" ON public.gallery_items FOR SELECT TO anon, authenticated USING (status = 'published' OR public.has_role(auth.uid(), 'admin'))","CREATE POLICY \\"Admins manage gallery\\" ON public.gallery_items FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'))","CREATE TRIGGER gallery_updated_at BEFORE UPDATE ON public.gallery_items FOR EACH ROW EXECUTE FUNCTION public.set_updated_at()","CREATE TABLE public.site_content (\n  key text PRIMARY KEY,\n  value jsonb NOT NULL DEFAULT '{}'::jsonb,\n  status public.content_status NOT NULL DEFAULT 'published',\n  updated_at timestamptz NOT NULL DEFAULT now()\n)","GRANT SELECT ON public.site_content TO anon, authenticated","GRANT INSERT, UPDATE, DELETE ON public.site_content TO authenticated","GRANT ALL ON public.site_content TO service_role","ALTER TABLE public.site_content ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Public reads published site content\\" ON public.site_content FOR SELECT TO anon, authenticated USING (status = 'published' OR public.has_role(auth.uid(), 'admin'))","CREATE POLICY \\"Admins manage site content\\" ON public.site_content FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'))","CREATE TRIGGER site_content_updated_at BEFORE UPDATE ON public.site_content FOR EACH ROW EXECUTE FUNCTION public.set_updated_at()"}	07eca512-92bf-4f59-a265-88aa1c9b6ad2
20260624135745	{"CREATE POLICY \\"Public read media\\" ON storage.objects FOR SELECT TO anon, authenticated USING (bucket_id = 'media')","CREATE POLICY \\"Admins upload media\\" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'media' AND public.has_role(auth.uid(), 'admin'))","CREATE POLICY \\"Admins update media\\" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'media' AND public.has_role(auth.uid(), 'admin'))","CREATE POLICY \\"Admins delete media\\" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'media' AND public.has_role(auth.uid(), 'admin'))"}	905a224c-2a23-404d-8d8b-1187a020bf44
20260624135805	{"REVOKE EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) FROM PUBLIC, anon","GRANT EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) TO authenticated, service_role","DROP POLICY IF EXISTS \\"Public reads published news\\" ON public.news","CREATE POLICY \\"Anon reads published news\\" ON public.news FOR SELECT TO anon USING (status = 'published')","CREATE POLICY \\"Auth reads news\\" ON public.news FOR SELECT TO authenticated USING (status = 'published' OR public.has_role(auth.uid(), 'admin'))","DROP POLICY IF EXISTS \\"Public reads published gallery\\" ON public.gallery_items","CREATE POLICY \\"Anon reads published gallery\\" ON public.gallery_items FOR SELECT TO anon USING (status = 'published')","CREATE POLICY \\"Auth reads gallery\\" ON public.gallery_items FOR SELECT TO authenticated USING (status = 'published' OR public.has_role(auth.uid(), 'admin'))","DROP POLICY IF EXISTS \\"Public reads published site content\\" ON public.site_content","CREATE POLICY \\"Anon reads published site content\\" ON public.site_content FOR SELECT TO anon USING (status = 'published')","CREATE POLICY \\"Auth reads site content\\" ON public.site_content FOR SELECT TO authenticated USING (status = 'published' OR public.has_role(auth.uid(), 'admin'))"}	b4ff89bc-2276-487b-8385-d12218892f1e
20260624135838	{"CREATE OR REPLACE FUNCTION public.claim_admin_if_first()\nRETURNS boolean\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n  uid uuid := auth.uid();\n  has_any boolean;\nBEGIN\n  IF uid IS NULL THEN\n    RETURN false;\n  END IF;\n  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE role = 'admin') INTO has_any;\n  IF has_any THEN\n    RETURN false;\n  END IF;\n  INSERT INTO public.user_roles (user_id, role) VALUES (uid, 'admin') ON CONFLICT DO NOTHING;\n  RETURN true;\nEND;\n$$","REVOKE EXECUTE ON FUNCTION public.claim_admin_if_first() FROM PUBLIC, anon","GRANT EXECUTE ON FUNCTION public.claim_admin_if_first() TO authenticated"}	aeddcacf-5cc0-4031-aefc-874d6eb1eaf3
20260624160000	{"CREATE TABLE public.routes (\n    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\n    title TEXT NOT NULL,\n    description TEXT,\n    destination TEXT NOT NULL,\n    start_date TIMESTAMP WITH TIME ZONE NOT NULL,\n    meeting_point TEXT NOT NULL,\n    meeting_time TIME NOT NULL,\n    estimated_distance_km NUMERIC,\n    waze_url TEXT,\n    media_url TEXT,\n    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),\n    created_by UUID REFERENCES auth.users(id)\n)","-- Enable RLS\nALTER TABLE public.routes ENABLE ROW LEVEL SECURITY","-- Policies (Viewable by authenticated users)\nCREATE POLICY \\"Routes viewable by authenticated users\\" \nON public.routes FOR SELECT \nTO authenticated USING (true)","-- Allow admins to insert/update (assuming user_roles exists)\nCREATE POLICY \\"Admins can insert routes\\" \nON public.routes FOR INSERT \nWITH CHECK (\n    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')\n)","CREATE POLICY \\"Admins can update routes\\" \nON public.routes FOR UPDATE \nUSING (\n    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')\n)","CREATE POLICY \\"Admins can delete routes\\" \nON public.routes FOR DELETE \nUSING (\n    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')\n)"}	routes
20260624170159	{"-- Allow admins to manage all motorcycles\nCREATE POLICY \\"Admins manage all motorcycles\\" ON public.motorcycles\n  FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'))","-- Allow admins to manage all maintenance items\nCREATE POLICY \\"Admins manage all maintenance items\\" ON public.maintenance_items\n  FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'))","-- Allow admins to manage all maintenance records\nCREATE POLICY \\"Admins manage all maintenance records\\" ON public.maintenance_records\n  FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'))"}	add_admin_motorcycle_policies
20260625115312	{"-- Add UNIQUE constraint to news title to prevent n8n from duplicating posts\nALTER TABLE public.news ADD CONSTRAINT unique_news_title UNIQUE (title)"}	add_unique_constraints
20260624	{"ALTER TABLE public.gallery_items ADD CONSTRAINT unique_instagram_url UNIQUE (instagram_url)"}	add_unique_instagram_url
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 217, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 18, true);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: feature_flags feature_flags_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.feature_flags
    ADD CONSTRAINT feature_flags_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: gallery_items gallery_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gallery_items
    ADD CONSTRAINT gallery_items_pkey PRIMARY KEY (id);


--
-- Name: maintenance_items maintenance_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_items
    ADD CONSTRAINT maintenance_items_pkey PRIMARY KEY (id);


--
-- Name: maintenance_records maintenance_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_records
    ADD CONSTRAINT maintenance_records_pkey PRIMARY KEY (id);


--
-- Name: motorcycles motorcycles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motorcycles
    ADD CONSTRAINT motorcycles_pkey PRIMARY KEY (id);


--
-- Name: news news_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.news
    ADD CONSTRAINT news_pkey PRIMARY KEY (id);


--
-- Name: news news_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.news
    ADD CONSTRAINT news_slug_key UNIQUE (slug);


--
-- Name: poll_options poll_options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_options
    ADD CONSTRAINT poll_options_pkey PRIMARY KEY (id);


--
-- Name: poll_votes poll_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_votes
    ADD CONSTRAINT poll_votes_pkey PRIMARY KEY (id);


--
-- Name: poll_votes poll_votes_poll_id_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_votes
    ADD CONSTRAINT poll_votes_poll_id_profile_id_key UNIQUE (poll_id, profile_id);


--
-- Name: polls polls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.polls
    ADD CONSTRAINT polls_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: route_photos route_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.route_photos
    ADD CONSTRAINT route_photos_pkey PRIMARY KEY (id);


--
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: site_content site_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_content
    ADD CONSTRAINT site_content_pkey PRIMARY KEY (key);


--
-- Name: trip_financial_plans trip_financial_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trip_financial_plans
    ADD CONSTRAINT trip_financial_plans_pkey PRIMARY KEY (id);


--
-- Name: trip_financial_plans trip_financial_plans_route_id_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trip_financial_plans
    ADD CONSTRAINT trip_financial_plans_route_id_profile_id_key UNIQUE (route_id, profile_id);


--
-- Name: gallery_items unique_instagram_url; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gallery_items
    ADD CONSTRAINT unique_instagram_url UNIQUE (instagram_url);


--
-- Name: news unique_news_title; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.news
    ADD CONSTRAINT unique_news_title UNIQUE (title);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_user_id_role_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_role_key UNIQUE (user_id, role);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_07_06 messages_2026_07_06_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_07_06
    ADD CONSTRAINT messages_2026_07_06_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_07_07 messages_2026_07_07_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_07_07
    ADD CONSTRAINT messages_2026_07_07_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_07_08 messages_2026_07_08_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_07_08
    ADD CONSTRAINT messages_2026_07_08_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_07_09 messages_2026_07_09_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_07_09
    ADD CONSTRAINT messages_2026_07_09_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_07_10 messages_2026_07_10_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_07_10
    ADD CONSTRAINT messages_2026_07_10_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages messages_payload_exclusive; Type: CHECK CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages
    ADD CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL))) NOT VALID;


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: iceberg_namespaces iceberg_namespaces_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_pkey PRIMARY KEY (id);


--
-- Name: iceberg_tables iceberg_tables_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: feature_flags_name_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX feature_flags_name_index ON _realtime.feature_flags USING btree (name);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: maintenance_items_motorcycle_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX maintenance_items_motorcycle_id_idx ON public.maintenance_items USING btree (motorcycle_id);


--
-- Name: maintenance_records_motorcycle_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX maintenance_records_motorcycle_id_idx ON public.maintenance_records USING btree (motorcycle_id);


--
-- Name: motorcycles_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX motorcycles_user_id_idx ON public.motorcycles USING btree (user_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_07_06_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_07_06_inserted_at_topic_idx ON realtime.messages_2026_07_06 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_07_07_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_07_07_inserted_at_topic_idx ON realtime.messages_2026_07_07 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_07_08_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_07_08_inserted_at_topic_idx ON realtime.messages_2026_07_08 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_07_09_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_07_09_inserted_at_topic_idx ON realtime.messages_2026_07_09 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_07_10_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_07_10_inserted_at_topic_idx ON realtime.messages_2026_07_10 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_selec; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_selec ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter, COALESCE(selected_columns, '{}'::text[]));


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_iceberg_namespaces_bucket_id; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_namespaces_bucket_id ON storage.iceberg_namespaces USING btree (catalog_id, name);


--
-- Name: idx_iceberg_tables_location; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_tables_location ON storage.iceberg_tables USING btree (location);


--
-- Name: idx_iceberg_tables_namespace_id; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_tables_namespace_id ON storage.iceberg_tables USING btree (catalog_id, namespace_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2026_07_06_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_07_06_inserted_at_topic_idx;


--
-- Name: messages_2026_07_06_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_07_06_pkey;


--
-- Name: messages_2026_07_07_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_07_07_inserted_at_topic_idx;


--
-- Name: messages_2026_07_07_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_07_07_pkey;


--
-- Name: messages_2026_07_08_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_07_08_inserted_at_topic_idx;


--
-- Name: messages_2026_07_08_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_07_08_pkey;


--
-- Name: messages_2026_07_09_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_07_09_inserted_at_topic_idx;


--
-- Name: messages_2026_07_09_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_07_09_pkey;


--
-- Name: messages_2026_07_10_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_07_10_inserted_at_topic_idx;


--
-- Name: messages_2026_07_10_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_07_10_pkey;


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: gallery_items gallery_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER gallery_updated_at BEFORE UPDATE ON public.gallery_items FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: maintenance_items maintenance_items_set_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER maintenance_items_set_updated_at BEFORE UPDATE ON public.maintenance_items FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: motorcycles motorcycles_set_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER motorcycles_set_updated_at BEFORE UPDATE ON public.motorcycles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: route_photos n8n_webhook_photos; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER n8n_webhook_photos AFTER INSERT ON public.route_photos FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://n8n.electrosal.com.br/webhook/aa621b0a-8d0b-4932-a06f-5305af533b8c', 'POST', '{"Content-type":"application/json"}', '{}', '5000');


--
-- Name: polls n8n_webhook_polls; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER n8n_webhook_polls AFTER INSERT ON public.polls FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://n8n.electrosal.com.br/webhook/aa621b0a-8d0b-4932-a06f-5305af533b8c', 'POST', '{"Content-type":"application/json"}', '{}', '5000');


--
-- Name: profiles n8n_webhook_profiles; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER n8n_webhook_profiles AFTER INSERT ON public.profiles FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://n8n.electrosal.com.br/webhook/aa621b0a-8d0b-4932-a06f-5305af533b8c', 'POST', '{"Content-type":"application/json"}', '{}', '5000');


--
-- Name: routes n8n_webhook_routes; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER n8n_webhook_routes AFTER INSERT ON public.routes FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://n8n.electrosal.com.br/webhook/aa621b0a-8d0b-4932-a06f-5305af533b8c', 'POST', '{"Content-type":"application/json"}', '{}', '5000');


--
-- Name: news news_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER news_updated_at BEFORE UPDATE ON public.news FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: profiles on_partner_change; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_partner_change AFTER UPDATE OF partner_id ON public.profiles FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.sync_partner_id();


--
-- Name: profiles profiles_set_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER profiles_set_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: routes route_webhook_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER route_webhook_trigger AFTER INSERT ON public.routes FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://n8n.electrosal.com.br/webhook-test/0712d4af-864c-414a-817d-03504541331f', 'POST', '{"Content-type":"application/json"}', '{}', '1000');


--
-- Name: site_content site_content_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER site_content_updated_at BEFORE UPDATE ON public.site_content FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: maintenance_items maintenance_items_motorcycle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_items
    ADD CONSTRAINT maintenance_items_motorcycle_id_fkey FOREIGN KEY (motorcycle_id) REFERENCES public.motorcycles(id) ON DELETE CASCADE;


--
-- Name: maintenance_items maintenance_items_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_items
    ADD CONSTRAINT maintenance_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: maintenance_records maintenance_records_maintenance_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_records
    ADD CONSTRAINT maintenance_records_maintenance_item_id_fkey FOREIGN KEY (maintenance_item_id) REFERENCES public.maintenance_items(id) ON DELETE SET NULL;


--
-- Name: maintenance_records maintenance_records_motorcycle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_records
    ADD CONSTRAINT maintenance_records_motorcycle_id_fkey FOREIGN KEY (motorcycle_id) REFERENCES public.motorcycles(id) ON DELETE CASCADE;


--
-- Name: maintenance_records maintenance_records_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_records
    ADD CONSTRAINT maintenance_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: motorcycles motorcycles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motorcycles
    ADD CONSTRAINT motorcycles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: news news_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.news
    ADD CONSTRAINT news_author_id_fkey FOREIGN KEY (author_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: poll_options poll_options_poll_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_options
    ADD CONSTRAINT poll_options_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES public.polls(id) ON DELETE CASCADE;


--
-- Name: poll_votes poll_votes_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_votes
    ADD CONSTRAINT poll_votes_option_id_fkey FOREIGN KEY (option_id) REFERENCES public.poll_options(id) ON DELETE CASCADE;


--
-- Name: poll_votes poll_votes_poll_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_votes
    ADD CONSTRAINT poll_votes_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES public.polls(id) ON DELETE CASCADE;


--
-- Name: poll_votes poll_votes_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_votes
    ADD CONSTRAINT poll_votes_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_partner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: route_photos route_photos_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.route_photos
    ADD CONSTRAINT route_photos_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES auth.users(id);


--
-- Name: route_photos route_photos_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.route_photos
    ADD CONSTRAINT route_photos_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON DELETE CASCADE;


--
-- Name: routes routes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: trip_financial_plans trip_financial_plans_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trip_financial_plans
    ADD CONSTRAINT trip_financial_plans_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: trip_financial_plans trip_financial_plans_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trip_financial_plans
    ADD CONSTRAINT trip_financial_plans_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: iceberg_namespaces iceberg_namespaces_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_namespace_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES storage.iceberg_namespaces(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: routes Admins can delete routes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can delete routes" ON public.routes FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- Name: routes Admins can insert routes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can insert routes" ON public.routes FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- Name: routes Admins can update routes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can update routes" ON public.routes FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- Name: maintenance_items Admins manage all maintenance items; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins manage all maintenance items" ON public.maintenance_items TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: maintenance_records Admins manage all maintenance records; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins manage all maintenance records" ON public.maintenance_records TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: motorcycles Admins manage all motorcycles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins manage all motorcycles" ON public.motorcycles TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: gallery_items Admins manage gallery; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins manage gallery" ON public.gallery_items TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: news Admins manage news; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins manage news" ON public.news TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'blog_admin'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'blog_admin'::public.app_role)));


--
-- Name: user_roles Admins manage roles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins manage roles" ON public.user_roles TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: site_content Admins manage site content; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins manage site content" ON public.site_content TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: polls Admins podem apagar enquetes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins podem apagar enquetes" ON public.polls FOR DELETE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: poll_options Admins podem apagar opções; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins podem apagar opções" ON public.poll_options FOR DELETE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: poll_votes Admins podem apagar votos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins podem apagar votos" ON public.poll_votes FOR DELETE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: polls Admins podem atualizar enquetes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins podem atualizar enquetes" ON public.polls FOR UPDATE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: poll_options Admins podem atualizar opções; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins podem atualizar opções" ON public.poll_options FOR UPDATE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: polls Admins podem inserir enquetes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins podem inserir enquetes" ON public.polls FOR INSERT WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: poll_options Admins podem inserir opções; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins podem inserir opções" ON public.poll_options FOR INSERT WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: user_roles Admins view all roles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins view all roles" ON public.user_roles FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: gallery_items Anon reads published gallery; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anon reads published gallery" ON public.gallery_items FOR SELECT TO anon USING ((status = 'published'::public.content_status));


--
-- Name: news Anon reads published news; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anon reads published news" ON public.news FOR SELECT TO anon USING ((status = 'published'::public.content_status));


--
-- Name: site_content Anon reads published site content; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anon reads published site content" ON public.site_content FOR SELECT TO anon USING ((status = 'published'::public.content_status));


--
-- Name: gallery_items Auth reads gallery; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Auth reads gallery" ON public.gallery_items FOR SELECT TO authenticated USING (((status = 'published'::public.content_status) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: news Auth reads news; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Auth reads news" ON public.news FOR SELECT TO authenticated USING (((status = 'published'::public.content_status) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: site_content Auth reads site content; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Auth reads site content" ON public.site_content FOR SELECT TO authenticated USING (((status = 'published'::public.content_status) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: route_photos Authenticated users can insert route photos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert route photos" ON public.route_photos FOR INSERT TO authenticated WITH CHECK ((auth.uid() = profile_id));


--
-- Name: profiles Authenticated users can view all profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view all profiles" ON public.profiles FOR SELECT TO authenticated USING (true);


--
-- Name: polls Membros podem ver enquetes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Membros podem ver enquetes" ON public.polls FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: poll_options Membros podem ver opções; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Membros podem ver opções" ON public.poll_options FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: poll_votes Membros podem ver os votos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Membros podem ver os votos" ON public.poll_votes FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: poll_votes Membros podem votar; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Membros podem votar" ON public.poll_votes FOR INSERT WITH CHECK ((auth.uid() = profile_id));


--
-- Name: news Public reads published news; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public reads published news" ON public.news FOR SELECT TO authenticated, anon USING (((status = 'published'::public.content_status) OR public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'blog_admin'::public.app_role)));


--
-- Name: route_photos Route photos viewable by authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Route photos viewable by authenticated users" ON public.route_photos FOR SELECT TO authenticated USING (true);


--
-- Name: routes Routes viewable by authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Routes viewable by authenticated users" ON public.routes FOR SELECT TO authenticated USING (true);


--
-- Name: maintenance_items Users and partners manage maintenance items; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users and partners manage maintenance items" ON public.maintenance_items TO authenticated USING (((auth.uid() = user_id) OR (public.get_user_partner_id() = user_id))) WITH CHECK (((auth.uid() = user_id) OR (public.get_user_partner_id() = user_id)));


--
-- Name: maintenance_records Users and partners manage maintenance records; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users and partners manage maintenance records" ON public.maintenance_records TO authenticated USING (((auth.uid() = user_id) OR (public.get_user_partner_id() = user_id))) WITH CHECK (((auth.uid() = user_id) OR (public.get_user_partner_id() = user_id)));


--
-- Name: motorcycles Users and partners manage motorcycles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users and partners manage motorcycles" ON public.motorcycles TO authenticated USING (((auth.uid() = user_id) OR (public.get_user_partner_id() = user_id))) WITH CHECK (((auth.uid() = user_id) OR (public.get_user_partner_id() = user_id)));


--
-- Name: route_photos Users can delete own route photos or admins can delete any; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete own route photos or admins can delete any" ON public.route_photos FOR DELETE TO authenticated USING (((auth.uid() = profile_id) OR (EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role))))));


--
-- Name: trip_financial_plans Users can delete their own or partner's trip financial plans; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own or partner's trip financial plans" ON public.trip_financial_plans FOR DELETE TO authenticated USING (((auth.uid() = profile_id) OR (public.get_user_partner_id() = profile_id)));


--
-- Name: trip_financial_plans Users can insert their own trip financial plans; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own trip financial plans" ON public.trip_financial_plans FOR INSERT TO authenticated WITH CHECK (((auth.uid() = profile_id) OR (public.get_user_partner_id() = profile_id)));


--
-- Name: trip_financial_plans Users can update their own or partner's trip financial plans; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own or partner's trip financial plans" ON public.trip_financial_plans FOR UPDATE TO authenticated USING (((auth.uid() = profile_id) OR (public.get_user_partner_id() = profile_id))) WITH CHECK (((auth.uid() = profile_id) OR (public.get_user_partner_id() = profile_id)));


--
-- Name: trip_financial_plans Users can view all trip financial plans; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view all trip financial plans" ON public.trip_financial_plans FOR SELECT TO authenticated USING (true);


--
-- Name: profiles Users insert own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users insert own profile" ON public.profiles FOR INSERT TO authenticated WITH CHECK ((auth.uid() = id));


--
-- Name: profiles Users update own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users update own profile" ON public.profiles FOR UPDATE TO authenticated USING ((auth.uid() = id)) WITH CHECK ((auth.uid() = id));


--
-- Name: user_roles Users view own roles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users view own roles" ON public.user_roles FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- Name: gallery_items; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.gallery_items ENABLE ROW LEVEL SECURITY;

--
-- Name: maintenance_items; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.maintenance_items ENABLE ROW LEVEL SECURITY;

--
-- Name: maintenance_records; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.maintenance_records ENABLE ROW LEVEL SECURITY;

--
-- Name: motorcycles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.motorcycles ENABLE ROW LEVEL SECURITY;

--
-- Name: news; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.news ENABLE ROW LEVEL SECURITY;

--
-- Name: poll_options; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.poll_options ENABLE ROW LEVEL SECURITY;

--
-- Name: poll_votes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.poll_votes ENABLE ROW LEVEL SECURITY;

--
-- Name: polls; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.polls ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: route_photos; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.route_photos ENABLE ROW LEVEL SECURITY;

--
-- Name: routes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.routes ENABLE ROW LEVEL SECURITY;

--
-- Name: site_content; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.site_content ENABLE ROW LEVEL SECURITY;

--
-- Name: trip_financial_plans; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.trip_financial_plans ENABLE ROW LEVEL SECURITY;

--
-- Name: user_roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Admins delete media; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Admins delete media" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'media'::text) AND public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: objects Admins update media; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Admins update media" ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'media'::text) AND public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: objects Admins upload media; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Admins upload media" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'media'::text) AND public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: objects Public read media; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Public read media" ON storage.objects FOR SELECT TO authenticated, anon USING ((bucket_id = 'media'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_namespaces; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.iceberg_namespaces ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_tables; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.iceberg_tables ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION claim_admin_if_first(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.claim_admin_if_first() FROM PUBLIC;
GRANT ALL ON FUNCTION public.claim_admin_if_first() TO authenticated;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.handle_new_user() FROM PUBLIC;


--
-- Name: FUNCTION has_role(_user_id uuid, _role public.app_role); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) FROM PUBLIC;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO authenticated;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO service_role;


--
-- Name: FUNCTION set_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.set_updated_at() FROM PUBLIC;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION send_binary(payload bytea, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION wal2json_escape_identifier(name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO postgres;
GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO dashboard_user;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;


--
-- Name: TABLE gallery_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.gallery_items TO anon;
GRANT ALL ON TABLE public.gallery_items TO authenticated;
GRANT ALL ON TABLE public.gallery_items TO service_role;


--
-- Name: TABLE maintenance_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.maintenance_items TO anon;
GRANT ALL ON TABLE public.maintenance_items TO authenticated;
GRANT ALL ON TABLE public.maintenance_items TO service_role;


--
-- Name: TABLE maintenance_records; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.maintenance_records TO anon;
GRANT ALL ON TABLE public.maintenance_records TO authenticated;
GRANT ALL ON TABLE public.maintenance_records TO service_role;


--
-- Name: TABLE motorcycles; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.motorcycles TO anon;
GRANT ALL ON TABLE public.motorcycles TO authenticated;
GRANT ALL ON TABLE public.motorcycles TO service_role;


--
-- Name: TABLE news; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.news TO anon;
GRANT ALL ON TABLE public.news TO authenticated;
GRANT ALL ON TABLE public.news TO service_role;


--
-- Name: TABLE poll_options; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.poll_options TO anon;
GRANT ALL ON TABLE public.poll_options TO authenticated;
GRANT ALL ON TABLE public.poll_options TO service_role;


--
-- Name: TABLE poll_votes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.poll_votes TO anon;
GRANT ALL ON TABLE public.poll_votes TO authenticated;
GRANT ALL ON TABLE public.poll_votes TO service_role;


--
-- Name: TABLE polls; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.polls TO anon;
GRANT ALL ON TABLE public.polls TO authenticated;
GRANT ALL ON TABLE public.polls TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE route_photos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.route_photos TO anon;
GRANT ALL ON TABLE public.route_photos TO authenticated;
GRANT ALL ON TABLE public.route_photos TO service_role;


--
-- Name: TABLE routes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.routes TO anon;
GRANT ALL ON TABLE public.routes TO authenticated;
GRANT ALL ON TABLE public.routes TO service_role;


--
-- Name: TABLE site_content; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.site_content TO anon;
GRANT ALL ON TABLE public.site_content TO authenticated;
GRANT ALL ON TABLE public.site_content TO service_role;


--
-- Name: TABLE trip_financial_plans; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.trip_financial_plans TO anon;
GRANT ALL ON TABLE public.trip_financial_plans TO authenticated;
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.trip_financial_plans TO service_role;


--
-- Name: TABLE user_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.user_roles TO anon;
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.user_roles TO authenticated;
GRANT ALL ON TABLE public.user_roles TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2026_07_06; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_07_06 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_07_06 TO dashboard_user;


--
-- Name: TABLE messages_2026_07_07; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_07_07 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_07_07 TO dashboard_user;


--
-- Name: TABLE messages_2026_07_08; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_07_08 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_07_08 TO dashboard_user;


--
-- Name: TABLE messages_2026_07_09; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_07_09 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_07_09 TO dashboard_user;


--
-- Name: TABLE messages_2026_07_10; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_07_10 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_07_10 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE iceberg_namespaces; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.iceberg_namespaces TO service_role;
GRANT SELECT ON TABLE storage.iceberg_namespaces TO authenticated;
GRANT SELECT ON TABLE storage.iceberg_namespaces TO anon;


--
-- Name: TABLE iceberg_tables; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.iceberg_tables TO service_role;
GRANT SELECT ON TABLE storage.iceberg_tables TO authenticated;
GRANT SELECT ON TABLE storage.iceberg_tables TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.hooks TO postgres;
GRANT ALL ON TABLE supabase_functions.hooks TO anon;
GRANT ALL ON TABLE supabase_functions.hooks TO authenticated;
GRANT ALL ON TABLE supabase_functions.hooks TO service_role;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO postgres;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO anon;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO service_role;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.migrations TO postgres;
GRANT ALL ON TABLE supabase_functions.migrations TO anon;
GRANT ALL ON TABLE supabase_functions.migrations TO authenticated;
GRANT ALL ON TABLE supabase_functions.migrations TO service_role;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT UPDATE ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT UPDATE ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT UPDATE ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict 0W6mHonHGKrzXZTdYL8OfdEPIb3aiixaGHfdNPJpUoZtU4VurUTmpizRX5UJKcI

