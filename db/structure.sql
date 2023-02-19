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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: auth_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_permissions (
    id bigint NOT NULL,
    action character varying NOT NULL,
    controller character varying NOT NULL,
    role_id bigint NOT NULL,
    modifiers character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: auth_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_permissions_id_seq OWNED BY public.auth_permissions.id;


--
-- Name: auth_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_roles (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: auth_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_roles_id_seq OWNED BY public.auth_roles.id;


--
-- Name: auth_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_sessions (
    id bigint NOT NULL,
    token character varying NOT NULL,
    valid_to timestamp(6) without time zone NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: auth_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_sessions_id_seq OWNED BY public.auth_sessions.id;


--
-- Name: auth_user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_roles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: auth_user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_user_roles_id_seq OWNED BY public.auth_user_roles.id;


--
-- Name: auth_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_users (
    id bigint NOT NULL,
    email character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    password_attempts_left integer,
    password_digest character varying,
    password_valid_to timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: auth_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_users_id_seq OWNED BY public.auth_users.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: auth_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_permissions_id_seq'::regclass);


--
-- Name: auth_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_roles ALTER COLUMN id SET DEFAULT nextval('public.auth_roles_id_seq'::regclass);


--
-- Name: auth_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_sessions ALTER COLUMN id SET DEFAULT nextval('public.auth_sessions_id_seq'::regclass);


--
-- Name: auth_user_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_roles ALTER COLUMN id SET DEFAULT nextval('public.auth_user_roles_id_seq'::regclass);


--
-- Name: auth_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_users ALTER COLUMN id SET DEFAULT nextval('public.auth_users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: auth_permissions auth_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permissions
    ADD CONSTRAINT auth_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_roles auth_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_roles
    ADD CONSTRAINT auth_roles_pkey PRIMARY KEY (id);


--
-- Name: auth_sessions auth_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_sessions
    ADD CONSTRAINT auth_sessions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_roles auth_user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_roles
    ADD CONSTRAINT auth_user_roles_pkey PRIMARY KEY (id);


--
-- Name: auth_users auth_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_auth_permissions_on_action_and_controller_and_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auth_permissions_on_action_and_controller_and_role_id ON public.auth_permissions USING btree (action, controller, role_id);


--
-- Name: index_auth_permissions_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auth_permissions_on_role_id ON public.auth_permissions USING btree (role_id);


--
-- Name: index_auth_roles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auth_roles_on_name ON public.auth_roles USING btree (name);


--
-- Name: index_auth_sessions_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auth_sessions_on_token ON public.auth_sessions USING btree (token);


--
-- Name: index_auth_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auth_sessions_on_user_id ON public.auth_sessions USING btree (user_id);


--
-- Name: index_auth_user_roles_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auth_user_roles_on_role_id ON public.auth_user_roles USING btree (role_id);


--
-- Name: index_auth_user_roles_on_role_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auth_user_roles_on_role_id_and_user_id ON public.auth_user_roles USING btree (role_id, user_id);


--
-- Name: index_auth_user_roles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auth_user_roles_on_user_id ON public.auth_user_roles USING btree (user_id);


--
-- Name: index_auth_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auth_users_on_email ON public.auth_users USING btree (email);


--
-- Name: auth_sessions fk_rails_4aba5b3f33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_sessions
    ADD CONSTRAINT fk_rails_4aba5b3f33 FOREIGN KEY (user_id) REFERENCES public.auth_users(id);


--
-- Name: auth_permissions fk_rails_926a9b8f43; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permissions
    ADD CONSTRAINT fk_rails_926a9b8f43 FOREIGN KEY (role_id) REFERENCES public.auth_roles(id);


--
-- Name: auth_user_roles fk_rails_b41ee1b3d6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_roles
    ADD CONSTRAINT fk_rails_b41ee1b3d6 FOREIGN KEY (user_id) REFERENCES public.auth_users(id);


--
-- Name: auth_user_roles fk_rails_d08b20cb72; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_roles
    ADD CONSTRAINT fk_rails_d08b20cb72 FOREIGN KEY (role_id) REFERENCES public.auth_roles(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20230215202502'),
('20230218152500'),
('20230219185137'),
('20230219191426'),
('20230219192502');


