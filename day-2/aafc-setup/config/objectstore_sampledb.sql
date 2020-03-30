--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE migration_user;
ALTER ROLE migration_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5e7f07265532e52b6a887c6b236504881';
CREATE ROLE web_user;
ALTER ROLE web_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md55caa6317d2d0c8a3095efbb484b3dc59';






--
-- Database creation
--

REVOKE CONNECT,TEMPORARY ON DATABASE object_store_db FROM PUBLIC;
GRANT TEMPORARY ON DATABASE object_store_db TO PUBLIC;
GRANT CONNECT ON DATABASE object_store_db TO migration_user;
GRANT CONNECT ON DATABASE object_store_db TO web_user;
REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect object_store_db

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.15
-- Dumped by pg_dump version 9.6.15

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

--
-- Name: object_store; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA object_store;


ALTER SCHEMA object_store OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: dctype; Type: TYPE; Schema: object_store; Owner: migration_user
--

CREATE TYPE object_store.dctype AS ENUM (
    'IMAGE',
    'MOVING_IMAGE',
    'SOUND',
    'TEXT',
    'DATASET',
    'UNDETERMINED'
);


ALTER TYPE object_store.dctype OWNER TO migration_user;

--
-- Name: managed_attribute_type; Type: TYPE; Schema: object_store; Owner: migration_user
--

CREATE TYPE object_store.managed_attribute_type AS ENUM (
    'INTEGER',
    'STRING'
);


ALTER TYPE object_store.managed_attribute_type OWNER TO migration_user;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: agent; Type: TABLE; Schema: object_store; Owner: migration_user
--

CREATE TABLE object_store.agent (
    id integer NOT NULL,
    uuid uuid NOT NULL,
    display_name character varying(250) NOT NULL,
    email character varying(250) NOT NULL
);


ALTER TABLE object_store.agent OWNER TO migration_user;

--
-- Name: agent_id_seq; Type: SEQUENCE; Schema: object_store; Owner: migration_user
--

CREATE SEQUENCE object_store.agent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_store.agent_id_seq OWNER TO migration_user;

--
-- Name: agent_id_seq; Type: SEQUENCE OWNED BY; Schema: object_store; Owner: migration_user
--

ALTER SEQUENCE object_store.agent_id_seq OWNED BY object_store.agent.id;


--
-- Name: databasechangelog; Type: TABLE; Schema: object_store; Owner: migration_user
--

CREATE TABLE object_store.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE object_store.databasechangelog OWNER TO migration_user;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: object_store; Owner: migration_user
--

CREATE TABLE object_store.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE object_store.databasechangeloglock OWNER TO migration_user;

--
-- Name: managed_attribute; Type: TABLE; Schema: object_store; Owner: migration_user
--

CREATE TABLE object_store.managed_attribute (
    id integer NOT NULL,
    uuid uuid NOT NULL,
    type object_store.managed_attribute_type NOT NULL,
    name character varying(50) NOT NULL,
    accepted_values text[],
    created_date timestamp with time zone DEFAULT now(),
    description jsonb
);


ALTER TABLE object_store.managed_attribute OWNER TO migration_user;

--
-- Name: managed_attribute_id_seq; Type: SEQUENCE; Schema: object_store; Owner: migration_user
--

CREATE SEQUENCE object_store.managed_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_store.managed_attribute_id_seq OWNER TO migration_user;

--
-- Name: managed_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: object_store; Owner: migration_user
--

ALTER SEQUENCE object_store.managed_attribute_id_seq OWNED BY object_store.managed_attribute.id;


--
-- Name: metadata; Type: TABLE; Schema: object_store; Owner: migration_user
--

CREATE TABLE object_store.metadata (
    id integer NOT NULL,
    uuid uuid NOT NULL,
    file_identifier uuid NOT NULL,
    file_extension character varying(10) NOT NULL,
    bucket character varying(50) NOT NULL,
    ac_caption character varying(250),
    dc_format character varying(150),
    dc_type object_store.dctype NOT NULL,
    xmp_rights_web_statement character varying(250) NOT NULL,
    ac_rights character varying(250) NOT NULL,
    xmp_rights_owner character varying(250) NOT NULL,
    ac_digitization_date timestamp with time zone,
    xmp_metadata_date timestamp with time zone,
    original_filename character varying(250),
    ac_hash_function character varying(50),
    ac_hash_value character varying(128),
    ac_tags text[],
    ac_metadata_creator_id integer,
    created_date timestamp with time zone DEFAULT now(),
    deleted_date timestamp with time zone,
    publicly_releasable boolean DEFAULT false,
    not_publicly_releasable_reason text,
    dc_creator_id integer,
    ac_derived_from_id integer,
    CONSTRAINT check_not_derived_from_self CHECK ((ac_derived_from_id <> id))
);


ALTER TABLE object_store.metadata OWNER TO migration_user;

--
-- Name: metadata_id_seq; Type: SEQUENCE; Schema: object_store; Owner: migration_user
--

CREATE SEQUENCE object_store.metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_store.metadata_id_seq OWNER TO migration_user;

--
-- Name: metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: object_store; Owner: migration_user
--

ALTER SEQUENCE object_store.metadata_id_seq OWNED BY object_store.metadata.id;


--
-- Name: metadata_managed_attribute; Type: TABLE; Schema: object_store; Owner: migration_user
--

CREATE TABLE object_store.metadata_managed_attribute (
    id integer NOT NULL,
    uuid uuid NOT NULL,
    metadata_id integer,
    managed_attribute_id integer,
    assigned_value character varying(250) NOT NULL
);


ALTER TABLE object_store.metadata_managed_attribute OWNER TO migration_user;

--
-- Name: metadata_managed_attribute_id_seq; Type: SEQUENCE; Schema: object_store; Owner: migration_user
--

CREATE SEQUENCE object_store.metadata_managed_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_store.metadata_managed_attribute_id_seq OWNER TO migration_user;

--
-- Name: metadata_managed_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: object_store; Owner: migration_user
--

ALTER SEQUENCE object_store.metadata_managed_attribute_id_seq OWNED BY object_store.metadata_managed_attribute.id;


--
-- Name: object_subtype; Type: TABLE; Schema: object_store; Owner: migration_user
--

CREATE TABLE object_store.object_subtype (
    id integer NOT NULL,
    dc_type object_store.dctype NOT NULL,
    ac_subtype character varying(50) NOT NULL,
    uuid uuid NOT NULL
);


ALTER TABLE object_store.object_subtype OWNER TO migration_user;

--
-- Name: object_subtype_id_seq; Type: SEQUENCE; Schema: object_store; Owner: migration_user
--

CREATE SEQUENCE object_store.object_subtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_store.object_subtype_id_seq OWNER TO migration_user;

--
-- Name: object_subtype_id_seq; Type: SEQUENCE OWNED BY; Schema: object_store; Owner: migration_user
--

ALTER SEQUENCE object_store.object_subtype_id_seq OWNED BY object_store.object_subtype.id;


--
-- Name: agent id; Type: DEFAULT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.agent ALTER COLUMN id SET DEFAULT nextval('object_store.agent_id_seq'::regclass);


--
-- Name: managed_attribute id; Type: DEFAULT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.managed_attribute ALTER COLUMN id SET DEFAULT nextval('object_store.managed_attribute_id_seq'::regclass);


--
-- Name: metadata id; Type: DEFAULT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata ALTER COLUMN id SET DEFAULT nextval('object_store.metadata_id_seq'::regclass);


--
-- Name: metadata_managed_attribute id; Type: DEFAULT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata_managed_attribute ALTER COLUMN id SET DEFAULT nextval('object_store.metadata_managed_attribute_id_seq'::regclass);


--
-- Name: object_subtype id; Type: DEFAULT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.object_subtype ALTER COLUMN id SET DEFAULT nextval('object_store.object_subtype_id_seq'::regclass);


--
-- Data for Name: agent; Type: TABLE DATA; Schema: object_store; Owner: migration_user
--

COPY object_store.agent (id, uuid, display_name, email) FROM stdin;
1	72a2ca2f-bea3-4d09-b3dd-72cb449870d8	Heather Cole	Heather Cole@example.com
2	2896aebe-79bf-4412-97ef-76f0a119ccb2	Michelle Locke	MichelleLocke@example.com
3	d47dd99e-52f4-4e36-bf2a-b507e28b876f	Owen Lonsdale	OwenLonsdale@example.com
4	e221b4fb-48b3-4f81-8497-f889a5641eff	Shannon Asencio	ShannonAsencio@example.com
5	8102eccd-72a7-4bd8-a2a1-4b4816173401	Tara Rintoul	TaraRintoul@example.com
6	35094f3b-095f-4e1c-a155-96dfd8bc21fe	Claudia Banchini	ClaudiaBanchini@example.com
\.


--
-- Name: agent_id_seq; Type: SEQUENCE SET; Schema: object_store; Owner: migration_user
--

SELECT pg_catalog.setval('object_store.agent_id_seq', 6, true);


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: object_store; Owner: migration_user
--

COPY object_store.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
init-1	gendreauc	db/changelog/db.changelog-init.xml	2020-03-27 19:51:24.444755	1	EXECUTED	8:85b31838a685578a6ed945c2d2044f0f	sql		\N	3.8.5	schema-change AND schema-change	\N	5338684324
init-2	gendreauc	db/changelog/db.changelog-init.xml	2020-03-27 19:51:24.468975	2	EXECUTED	8:d407feed6a8a8c99a07f956279e05ceb	sql		\N	3.8.5	schema-change AND schema-change	\N	5338684324
init-3	gendreauc	db/changelog/db.changelog-init.xml	2020-03-27 19:51:24.508828	3	EXECUTED	8:036e94a0d3d0a321b67064e2b5ccec2f	createTable tableName=metadata		\N	3.8.5	schema-change AND schema-change	\N	5338684324
init-4	gendreauc	db/changelog/db.changelog-init.xml	2020-03-27 19:51:24.534864	4	EXECUTED	8:a5f75fa27e195a8ed906850fb5ae6b67	createTable tableName=managed_attribute		\N	3.8.5	schema-change AND schema-change	\N	5338684324
init-5	shemyg	db/changelog/db.changelog-init.xml	2020-03-27 19:51:24.566646	5	EXECUTED	8:627b7864020aba2ee651a09a05edee96	createTable tableName=metadata_managed_attribute		\N	3.8.5	schema-change AND schema-change	\N	5338684324
init-6	gendreauc	db/changelog/db.changelog-init.xml	2020-03-27 19:51:24.614694	6	EXECUTED	8:075242db86d9ec33a5f4902294119059	createTable tableName=agent; addForeignKeyConstraint baseTableName=metadata, constraintName=fk_metadata_creator_agent, referencedTableName=agent		\N	3.8.5	schema-change AND schema-change	\N	5338684324
1-Add_description_to_managed_attribute	ganx	db/changelog/migrations/1-Add_description_to_managed_attribute.xml	2020-03-27 19:51:24.633888	7	EXECUTED	8:83084e0f083906faf88af8bb090ef6a3	addColumn tableName=managed_attribute		\N	3.8.5	schema-change	\N	5338684324
2-Add_support_for_dcCreator	lyonj	db/changelog/migrations/2-Add_support_for_dcCreator.xml	2020-03-27 19:51:24.652975	8	EXECUTED	8:1a8b7292b8924cb9b8179f517701c552	addColumn tableName=metadata; addForeignKeyConstraint baseTableName=metadata, constraintName=fk_dc_creator_agent, referencedTableName=agent		\N	3.8.5	schema-change	\N	5338684324
3-Add_acDerivedFrom_relationship_to_metadata	keyuk	db/changelog/migrations/3-Add_acDerivedFrom_relationship_to_metadata.xml	2020-03-27 19:51:24.682942	9	EXECUTED	8:22752ae3e0d6b6017ac3677bba9513e1	addColumn tableName=metadata; addForeignKeyConstraint baseTableName=metadata, constraintName=fk_metadata_ac_derived_from_id, referencedTableName=metadata; sql		\N	3.8.5	schema-change	\N	5338684324
2-Add_ac_subtype_table	ganx	db/changelog/migrations/4-Add_object_subtype_table.xml	2020-03-27 19:51:24.724277	10	EXECUTED	8:4e7576729db557313af1ece20eba181f	createTable tableName=object_subtype; addUniqueConstraint constraintName=unique_dctype_acsubtype_combination_per_object, tableName=object_subtype		\N	3.8.5	schema-change	\N	5338684324
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: object_store; Owner: migration_user
--

COPY object_store.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
\.


--
-- Data for Name: managed_attribute; Type: TABLE DATA; Schema: object_store; Owner: migration_user
--

COPY object_store.managed_attribute (id, uuid, type, name, accepted_values, created_date, description) FROM stdin;
1	253e8869-90d0-47d3-8740-a4c8e11ee468	STRING	SpecimenID	\N	2020-03-27 19:51:42.953763+00	\N
2	e451fd8b-8ae3-4d18-bf18-d3417bf2456b	STRING	Type Status	{Holotype,Paratype,Syntype}	2020-03-27 19:51:42.953763+00	\N
3	2e1da550-e6d7-46e1-b270-e4c1ec2421a5	STRING	Scientific Name	\N	2020-03-27 19:51:42.953763+00	\N
4	8672104e-d085-44e9-b286-d49abcc799c3	STRING	Specimen View	{"Habitus Dorsal","Habitus Lateral"}	2020-03-27 19:51:42.953763+00	\N
\.


--
-- Name: managed_attribute_id_seq; Type: SEQUENCE SET; Schema: object_store; Owner: migration_user
--

SELECT pg_catalog.setval('object_store.managed_attribute_id_seq', 4, true);


--
-- Data for Name: metadata; Type: TABLE DATA; Schema: object_store; Owner: migration_user
--

COPY object_store.metadata (id, uuid, file_identifier, file_extension, bucket, ac_caption, dc_format, dc_type, xmp_rights_web_statement, ac_rights, xmp_rights_owner, ac_digitization_date, xmp_metadata_date, original_filename, ac_hash_function, ac_hash_value, ac_tags, ac_metadata_creator_id, created_date, deleted_date, publicly_releasable, not_publicly_releasable_reason, dc_creator_id, ac_derived_from_id) FROM stdin;
\.


--
-- Name: metadata_id_seq; Type: SEQUENCE SET; Schema: object_store; Owner: migration_user
--

SELECT pg_catalog.setval('object_store.metadata_id_seq', 1, false);


--
-- Data for Name: metadata_managed_attribute; Type: TABLE DATA; Schema: object_store; Owner: migration_user
--

COPY object_store.metadata_managed_attribute (id, uuid, metadata_id, managed_attribute_id, assigned_value) FROM stdin;
\.


--
-- Name: metadata_managed_attribute_id_seq; Type: SEQUENCE SET; Schema: object_store; Owner: migration_user
--

SELECT pg_catalog.setval('object_store.metadata_managed_attribute_id_seq', 1, false);


--
-- Data for Name: object_subtype; Type: TABLE DATA; Schema: object_store; Owner: migration_user
--

COPY object_store.object_subtype (id, dc_type, ac_subtype, uuid) FROM stdin;
\.


--
-- Name: object_subtype_id_seq; Type: SEQUENCE SET; Schema: object_store; Owner: migration_user
--

SELECT pg_catalog.setval('object_store.object_subtype_id_seq', 1, false);


--
-- Name: agent agent_display_name_key; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.agent
    ADD CONSTRAINT agent_display_name_key UNIQUE (display_name);


--
-- Name: agent agent_email_key; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.agent
    ADD CONSTRAINT agent_email_key UNIQUE (email);


--
-- Name: agent agent_uuid_key; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.agent
    ADD CONSTRAINT agent_uuid_key UNIQUE (uuid);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: managed_attribute managed_attribute_uuid_key; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.managed_attribute
    ADD CONSTRAINT managed_attribute_uuid_key UNIQUE (uuid);


--
-- Name: metadata metadata_file_identifier_key; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata
    ADD CONSTRAINT metadata_file_identifier_key UNIQUE (file_identifier);


--
-- Name: metadata_managed_attribute metadata_managed_attribute_uuid_key; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata_managed_attribute
    ADD CONSTRAINT metadata_managed_attribute_uuid_key UNIQUE (uuid);


--
-- Name: metadata metadata_uuid_key; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata
    ADD CONSTRAINT metadata_uuid_key UNIQUE (uuid);


--
-- Name: object_subtype object_subtype_ac_subtype_key; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.object_subtype
    ADD CONSTRAINT object_subtype_ac_subtype_key UNIQUE (ac_subtype);


--
-- Name: object_subtype object_subtype_uuid_key; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.object_subtype
    ADD CONSTRAINT object_subtype_uuid_key UNIQUE (uuid);


--
-- Name: object_subtype pk_ac_subtype_id; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.object_subtype
    ADD CONSTRAINT pk_ac_subtype_id PRIMARY KEY (id);


--
-- Name: agent pk_agent_id; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.agent
    ADD CONSTRAINT pk_agent_id PRIMARY KEY (id);


--
-- Name: managed_attribute pk_managed_attribute_id; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.managed_attribute
    ADD CONSTRAINT pk_managed_attribute_id PRIMARY KEY (id);


--
-- Name: metadata pk_metadata_id; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata
    ADD CONSTRAINT pk_metadata_id PRIMARY KEY (id);


--
-- Name: metadata_managed_attribute pk_metatdata_managed_attribute_id; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata_managed_attribute
    ADD CONSTRAINT pk_metatdata_managed_attribute_id PRIMARY KEY (id);


--
-- Name: object_subtype unique_dctype_acsubtype_combination_per_object; Type: CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.object_subtype
    ADD CONSTRAINT unique_dctype_acsubtype_combination_per_object UNIQUE (dc_type, ac_subtype);


--
-- Name: metadata fk_dc_creator_agent; Type: FK CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata
    ADD CONSTRAINT fk_dc_creator_agent FOREIGN KEY (dc_creator_id) REFERENCES object_store.agent(id);


--
-- Name: metadata fk_metadata_ac_derived_from_id; Type: FK CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata
    ADD CONSTRAINT fk_metadata_ac_derived_from_id FOREIGN KEY (ac_derived_from_id) REFERENCES object_store.metadata(id);


--
-- Name: metadata fk_metadata_creator_agent; Type: FK CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata
    ADD CONSTRAINT fk_metadata_creator_agent FOREIGN KEY (ac_metadata_creator_id) REFERENCES object_store.agent(id);


--
-- Name: metadata_managed_attribute fk_metadata_managed_attribute_to_managed_attribute_id; Type: FK CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata_managed_attribute
    ADD CONSTRAINT fk_metadata_managed_attribute_to_managed_attribute_id FOREIGN KEY (managed_attribute_id) REFERENCES object_store.managed_attribute(id);


--
-- Name: metadata_managed_attribute fk_metadata_managed_attribute_to_metadata_id; Type: FK CONSTRAINT; Schema: object_store; Owner: migration_user
--

ALTER TABLE ONLY object_store.metadata_managed_attribute
    ADD CONSTRAINT fk_metadata_managed_attribute_to_metadata_id FOREIGN KEY (metadata_id) REFERENCES object_store.metadata(id);


--
-- Name: SCHEMA object_store; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA object_store TO migration_user;
GRANT USAGE ON SCHEMA object_store TO web_user;


--
-- Name: TABLE agent; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,INSERT,REFERENCES,DELETE,UPDATE ON TABLE object_store.agent TO web_user;


--
-- Name: SEQUENCE agent_id_seq; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,USAGE ON SEQUENCE object_store.agent_id_seq TO web_user;


--
-- Name: TABLE databasechangelog; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,INSERT,REFERENCES,DELETE,UPDATE ON TABLE object_store.databasechangelog TO web_user;


--
-- Name: TABLE databasechangeloglock; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,INSERT,REFERENCES,DELETE,UPDATE ON TABLE object_store.databasechangeloglock TO web_user;


--
-- Name: TABLE managed_attribute; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,INSERT,REFERENCES,DELETE,UPDATE ON TABLE object_store.managed_attribute TO web_user;


--
-- Name: SEQUENCE managed_attribute_id_seq; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,USAGE ON SEQUENCE object_store.managed_attribute_id_seq TO web_user;


--
-- Name: TABLE metadata; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,INSERT,REFERENCES,DELETE,UPDATE ON TABLE object_store.metadata TO web_user;


--
-- Name: SEQUENCE metadata_id_seq; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,USAGE ON SEQUENCE object_store.metadata_id_seq TO web_user;


--
-- Name: TABLE metadata_managed_attribute; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,INSERT,REFERENCES,DELETE,UPDATE ON TABLE object_store.metadata_managed_attribute TO web_user;


--
-- Name: SEQUENCE metadata_managed_attribute_id_seq; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,USAGE ON SEQUENCE object_store.metadata_managed_attribute_id_seq TO web_user;


--
-- Name: TABLE object_subtype; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,INSERT,REFERENCES,DELETE,UPDATE ON TABLE object_store.object_subtype TO web_user;


--
-- Name: SEQUENCE object_subtype_id_seq; Type: ACL; Schema: object_store; Owner: migration_user
--

GRANT SELECT,USAGE ON SEQUENCE object_store.object_subtype_id_seq TO web_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: object_store; Owner: migration_user
--

ALTER DEFAULT PRIVILEGES FOR ROLE migration_user IN SCHEMA object_store REVOKE ALL ON SEQUENCES  FROM migration_user;
ALTER DEFAULT PRIVILEGES FOR ROLE migration_user IN SCHEMA object_store GRANT SELECT,USAGE ON SEQUENCES  TO web_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: object_store; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA object_store REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA object_store GRANT ALL ON TABLES  TO migration_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: object_store; Owner: migration_user
--

ALTER DEFAULT PRIVILEGES FOR ROLE migration_user IN SCHEMA object_store REVOKE ALL ON TABLES  FROM migration_user;
ALTER DEFAULT PRIVILEGES FOR ROLE migration_user IN SCHEMA object_store GRANT SELECT,INSERT,REFERENCES,DELETE,UPDATE ON TABLES  TO web_user;


--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.15
-- Dumped by pg_dump version 9.6.15

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

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.15
-- Dumped by pg_dump version 9.6.15

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

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

