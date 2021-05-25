/*
	File: 			scriptCatalog.sql
	Version:		2020.07.21b
	Description: 	Create a structure of tenants database, used for license and active the system entities.
	Created At:		2020-07-21 3:22pm
	Auhor:			DUARTE, Jose Wiltomar
	Release notes: {	
					2020-01-21 - Initial version and structure definition.
					2020-11-18 - Redefined the bank name to catalog and created user if not exists.
	}
*/

CREATE USER ewtech WITH
    LOGIN
    SUPERUSER
    INHERIT
    CREATEDB
    CREATEROLE
    REPLICATION
	PASSWORD 'ewp@ssport';

CREATE DATABASE "catalog" WITH
    OWNER = ewtech
    ENCODING = 'UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TYPE IF EXISTS public.usertype;
CREATE TYPE public.usertype AS ENUM (
	'01 - Common user',
	'02 - Tenant administrator',
	'03 - General administrator',
	'99 - Other'
);

DROP TYPE IF EXISTS public.environmenttype;
CREATE TYPE public.environmenttype AS ENUM (
	'01 - Production',
	'02 - Homologation'
);

CREATE SCHEMA IF NOT EXISTS security AUTHORIZATION lombardi;
COMMENT ON SCHEMA security IS 'Persistense of users/tenants data schema.';

DROP TABLE IF EXISTS public.databaseversion;
CREATE TABLE IF NOT EXISTS public.databaseversion (
	id uuid DEFAULT uuid_generate_v4(),
	date TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	version CHARACTER VARYING(14) NOT NULL,
	status BOOLEAN DEFAULT TRUE,
	createdat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	updatedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	CONSTRAINT databaseversion_pkey PRIMARY KEY (id),
	CONSTRAINT databaseversion_ukey_version UNIQUE (version)
);
COMMENT ON TABLE public.databaseversion IS 'Version control of data base.';

DROP TABLE IF EXISTS public.entity;
CREATE TABLE IF NOT EXISTS public.entity (
	id uuid DEFAULT uuid_generate_v4(),
	document CHARACTER VARYING(14) NOT NULL,
	name CHARACTER VARYING(70) NOT NULL,
	status BOOLEAN DEFAULT TRUE,
	createdat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	updatedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	CONSTRAINT entity_pkey PRIMARY KEY (id),
	CONSTRAINT entity_ukey_document UNIQUE (document)
);
COMMENT ON TABLE public.entity IS 'Data structure for system entities.';

DROP TABLE IF EXISTS security.tenant;
CREATE TABLE IF NOT EXISTS security.tenant (
	id uuid DEFAULT uuid_generate_v4(),
	servername CHARACTER VARYING(200) NOT NULL,
	serverport SMALLINT DEFAULT 5432,
	username CHARACTER VARYING(30) DEFAULT 'lombardi',
	userpassword CHARACTER VARYING(64) NOT NULL,
	databasename CHARACTER VARYING(30) NOT NULL,
	status BOOLEAN DEFAULT TRUE,
	createdat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	updatedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	CONSTRAINT tenant_pkey PRIMARY KEY (id),
	CONSTRAINT tenant_ukey_databaseandserver UNIQUE (servername, serverport, databasename)
);
COMMENT ON TABLE security.tenant IS 'List of tenant databases.';

DROP TABLE IF EXISTS security.entitytenant;
CREATE TABLE IF NOT EXISTS security.entitytenant (
	id uuid DEFAULT uuid_generate_v4(),
	entityid uuid NOT NULL,
	tenantid uuid NOT NULL,
	environment public.environmenttype DEFAULT '02 - Homologation',
	status BOOLEAN DEFAULT TRUE,
	createdat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	updatedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	CONSTRAINT entitytenant_pkey PRIMARY KEY (id),
	CONSTRAINT entitytenant_fkey_entity FOREIGN KEY (entityid) REFERENCES public.entity (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT entitytenant_fkey_tenant FOREIGN KEY (tenantid) REFERENCES security.tenant (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT entitytenant_ukey_entitytentantenvironment UNIQUE (entityid, tenantid, environment)
);
COMMENT ON TABLE security.entitytenant IS 'Relationships between entities and your tenants';

DROP TABLE IF EXISTS security.entitytenantlicense;
CREATE TABLE IF NOT EXISTS security.entitytenantlicense (
	id uuid DEFAULT uuid_generate_v4(),
	entitytenantid uuid NOT NULL,
	licensekey CHARACTER VARYING(64),
	status BOOLEAN DEFAULT TRUE,
	createdat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	updatedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	CONSTRAINT entitytenantlicense_pkey PRIMARY KEY (id),
	CONSTRAINT entitytenantlicense_fkey_entitytenant FOREIGN KEY (entitytenantid) REFERENCES security.entitytenant (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT entitytenantlicense_ukey_entitytenantid UNIQUE(entitytenantid)
);
COMMENT ON TABLE security.entitytenantlicense IS 'Table contain the license of tenants';

DROP TABLE IF EXISTS security.user;
CREATE TABLE IF NOT EXISTS security.user (
	id uuid DEFAULT uuid_generate_v4(),
	email CHARACTER VARYING(60) NOT NULL,
	password CHARACTER VARYING(64) NOT NULL,
	type public.usertype DEFAULT '01 - Common user',
	status BOOLEAN DEFAULT TRUE,
	createdat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	updatedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	CONSTRAINT users_pkey PRIMARY KEY (id),
	CONSTRAINT users_ukey_email UNIQUE(email)
);
COMMENT ON TABLE security.user IS 'Persist on data base tenant users.';

DROP TABLE IF EXISTS security.token;
CREATE TABLE IF NOT EXISTS security.token (
    id uuid DEFAULT uuid_generate_v4(),
    userid uuid NOT NULL,
    token CHARACTER VARYING(255) NOT NULL,
    isrevoked BOOLEAN DEFAULT FALSE,
    expiresin TIMESTAMP WITH TIME ZONE,
	status BOOLEAN DEFAULT TRUE,
	createdat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	updatedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
    CONSTRAINT token_pkey PRIMARY KEY (id),
    CONSTRAINT token_fkey_user FOREIGN KEY (userid) REFERENCES security.user (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT token_ukey_token UNIQUE(token)
);
COMMENT ON TABLE security.token IS 'User token to access system.';

DROP TABLE IF EXISTS security.tenantuser;
CREATE TABLE IF NOT EXISTS security.tenantuser (
	id uuid DEFAULT uuid_generate_v4(),
	userid uuid NOT NULL,
	entitytenantid uuid NOT NULL,	
	status BOOLEAN DEFAULT TRUE,
	createdat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	updatedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	CONSTRAINT tenantuser_pkey PRIMARY KEY (id),
	CONSTRAINT tenantuser_fkey_user FOREIGN KEY (userid) REFERENCES security.user (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT tenantuser_fkey_entitytenant FOREIGN KEY (entitytenantid) REFERENCES security.entitytenant (id) ON UPDATE CASCADE ON DELETE RESTRICT
);
COMMENT ON TABLE security.tenantuser IS 'Relationship between tenant and user';
