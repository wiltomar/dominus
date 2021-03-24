/*
	File: 			scriptDominus.sql
	Version:		2020.07.22b
	Description: 	Create a structure of main database, used for access and maintenance in the system.
	Created At:		2020-07-22 4:41pm
	Auhor:			DUARTE, Jose Wiltomar
	Release notes: {	
					2020-07-22 - Initial version and structure definition.
	}
*/

CREATE DATABASE dominus	WITH
	OWNER = ewtech
	ENCODING = 'UTF8'
	TABLESPACE = pg_default
	CONNECTION LIMIT = -1;

COMMENT ON DATABASE dominus IS 'The main system database, to persiste the data of system and user operations.';

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA administrative AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA administrative TO ewtech;

CREATE SCHEMA commercial AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA commercial TO ewtech;

CREATE SCHEMA accounting AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA accounting TO ewtech;

CREATE SCHEMA educational AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA educational TO ewtech;

CREATE SCHEMA legal AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA legal TO ewtech;

CREATE SCHEMA folks AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA folks TO ewtech;

CREATE SCHEMA service AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA service TO ewtech;

CREATE SCHEMA safety AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA safety TO ewtech;

CREATE SCHEMA supply AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA supply TO ewtech;

CREATE SCHEMA financial AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA financial TO ewtech;

CREATE SCHEMA localized AUTHORIZATION ewtech;
GRANT ALL ON SCHEMA localized TO ewtech;

ALTER SCHEMA public OWNER TO ewtech;

CREATE TABLE IF NOT EXISTS public.currency (
	id uuid DEFAULT uuid_generate_v4(),
	isocode CHAR(3) NOT NULL,
	description VARCHAR(30) NOT NULL,
	pluraldescription VARCHAR(30) NOT NULL,
	symbol VARCHAR(5) NOT NULL,
	smallestunit VARCHAR(30) NOT NULL,
	smallestpluralunit VARCHAR(30) NOT NULL,
	isactive BOOLEAN DEFAULT TRUE,
	insertedat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	editedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	isdeleted BOOLEAN DEFAULT FALSE,
	CONSTRAINT currency_pkey PRIMARY KEY (id),
	CONSTRAINT currency_ukey_isocode UNIQUE (isocode)
);

CREATE TABLE IF NOT EXISTS public.language (
	id uuid DEFAULT uuid_generate_v4(),
	acronym VARCHAR(5) NOT NULL,
	description VARCHAR(40) NOT NULL,
	reduceddescription VARCHAR(20) NOT NULL,
	codepage VARCHAR(10),
	isactive BOOLEAN DEFAULT TRUE,
	insertedat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	editedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	isdeleted BOOLEAN DEFAULT FALSE,
	CONSTRAINT language_pkey PRIMARY KEY (id),
	CONSTRAINT language_ukey_acronym UNIQUE (acronym)
);

CREATE TABLE IF NOT EXISTS public.country (
	id uuid DEFAULT uuid_generate_v4(),
	siscomexcode CHAR(5),
	name VARCHAR(40) NOT NULL,
	acronym VARCHAR(3) NOT NULL,
	domain CHAR(2),
	gentile VARCHAR(40),
	isactive BOOLEAN DEFAULT TRUE,
	insertedat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	editedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	isdeleted BOOLEAN DEFAULT FALSE,
	CONSTRAINT country_pkey PRIMARY KEY (id),
	CONSTRAINT country_ukey_siscomexcode UNIQUE (siscomexcode),
	CONSTRAINT country_chek_siscomexcode CHECK (siscomexcode ~*'^[0-9]{4}$'),
	CONSTRAINT country_chek_domain CHECK (domain ~*'[a-z]{2}$')
);

CREATE TABLE IF NOT EXISTS public.countryidd (
	id uuid DEFAULT uuid_generate_V4(),
	countryid uuid NOT NULL,
	idd VARCHAR(3) NOT NULL,
	isactive BOOLEAN DEFAULT TRUE,
	insertedat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	editedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	isdeleted BOOLEAN DEFAULT FALSE,
	CONSTRAINT countryidd_pkey PRIMARY KEY (id),
	CONSTRAINT countryidd_fkey_countryid FOREIGN KEY (countryid) REFERENCES public.country (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT countryidd_chek_idd CHECK (idd ~*'^[0-9]{3}$'),
	CONSTRAINT countryidd_ukey_countryandidd UNIQUE(id, idd)
);

CREATE TABLE IF NOT EXISTS public.currencycountry (
	id uuid DEFAULT uuid_generate_v4(),
	countryid uuid NOT NULL,
	currencyid uuid NOT NULL,
	ordering SMALLINT DEFAULT 1,
	isactive BOOLEAN DEFAULT TRUE,
	insertedat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	editedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	isdeleted BOOLEAN DEFAULT FALSE,
	CONSTRAINT currencycountry_pkey PRIMARY KEY (id),
	CONSTRAINT currencycountry_fkey_countryid FOREIGN KEY (countryid) REFERENCES public.country (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT currencycountry_ukey_countryidandorder UNIQUE(countryid, ordering),
	CONSTRAINT currencycountry_ukey_countryidandcurrencyid UNIQUE(countryid, currencyid)
);

CREATE TABLE IF NOT EXISTS public.languagecountry (
	id uuid DEFAULT uuid_generate_v4(),
	countryid uuid NOT NULL,
	languageid uuid NOT NULL,
	ordering SMALLINT DEFAULT 1,
	isactive BOOLEAN DEFAULT TRUE,
	insertedat TIMESTAMP WITH TIME ZONE DEFAULT statement_timestamp(),
	editedat TIMESTAMP WITH TIME ZONE,
	deletedat TIMESTAMP WITH TIME ZONE,
	isdeleted BOOLEAN DEFAULT FALSE,
	CONSTRAINT languagecountry_pkey PRIMARY KEY (id),
	CONSTRAINT languagecountry_fkey_countryid FOREIGN KEY (countryid) REFERENCES public.country (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT languagecountry_fkey_languageid FOREIGN KEY (languageid) REFERENCES public.language (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT languagecountry_ukey_countryidandorder UNIQUE(countryid, ordering),
	CONSTRAINT languagecountry_ukey_countryandlanguage UNIQUE (countryid, languageid)
);
