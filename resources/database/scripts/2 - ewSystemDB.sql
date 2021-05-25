/*
Arquivo     :"lombardiDB.sql
Versão      : 2019.08.build_22
Objetivo    : Criar a estrutura do banco de dados para uso com o aplicativo, com suas tabelas e tipos.
Criação     : 13/09/2015 - Versão: 0.1              - Definições iniciais do projeto, estrutura incial do banco de dados e suas tabelas.
Edições     : 02/11/2015 - Versão: 0.2              - Adição de novas tabelas e tipos de dados ao banco do projeto.
              05/11/2015 - Versão: 0.2.2            - Alteração de algumas tabelas já inseridas no banco.
              24/11/2015 - Versão: 0.3              - 
              26/04/2016 - Versão: 1.0              - 
              15/05/2016 - Versão: 1.2              - 
              16/10/2016 - Versão: 2.0              - Onde foi refeita a estrutura do arquivo em virtude de ter seu conteúdo danificado pela aplicação de gerenciamento do banco de dados (pgAdmin 4).
              30/10/2017 - Versão: 2.1.5            - Adição de novas tabelas, e edição de tabelas existentes.
              20/12/2017 - Versao: 2017.12.build_20 - Nova definiçao de versionamento e reestruturaçao de banco (nova perspectiva).
			  30/07/2018 - Versao: 2018.07.build_30 - Alterações e melhorias para atualização de estrutura.
              12/08/2018 - Versao: 2018.08.build_12 - Adições de tabelas ao schema suprimentos e alteração nas estruturas de clientes e fornecedores.
              01/05/2019 - Versão: 2019.05.build_01 - Alteração da padronização dos nomes das tabelas.
              22/08/2019 - Versão: 2019.08.build_22 - Adição do contexto de permissões do sistema.
Propriedade : ewSoft Tecnologia e Consultoria Ltda.
Responsável : José Wiltomar DUARTE

Observações : 1 - Esse script deve ser executado em partes, pois o pgAdmin não permite a execução de rotina em lote, onde exista a criação de banco de dados.
*/

-- 1º Passo - Criar as roles/usuários ewsoft, para a administração de nosso banco futuro.
CREATE USER ewsoft WITH
    LOGIN
    SUPERUSER
    INHERIT
    CREATEDB
    CREATEROLE
    REPLICATION;

-- 2º Passo - Criar o banco de dados, propriamente dito.
CREATE DATABASE "lombardiDB"
    WITH
    OWNER = ewsoft
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

    
-- 3º Passo - Adicionando um comentário descritivo ao banco.
COMMENT ON DATABASE "lombardiDB"
    IS 'Banco de dados do lombardi ERP, de propriedade da ewSoft Tecnologia e Consultoria Ltda. 2008 - 2019. Todos os direitos reservados';

-- 4º Passo - Criação dos schemas, estrutura limpa para armazenamento das tabelas.
  
DROP SCHEMA IF EXISTS public;
  
DROP SCHEMA IF EXISTS administrativo;
CREATE SCHEMA administrativo AUTHORIZATION ewsoft;
GRANT ALL ON SCHEMA administrativo TO ewsoft;
COMMENT ON SCHEMA administrativo IS 'Manutenção de cadastros gerais, utilizados por todo o sistema.';
  
DROP SCHEMA IF EXISTS comercial;
CREATE SCHEMA comercial AUTHORIZATION ewsoft;
GRANT ALL ON SCHEMA comercial TO ewsoft;
COMMENT ON SCHEMA comercial IS 'Registros de movimentações de compra e venda de produtos e/ou serviços.';

DROP SCHEMA IF EXISTS contabilidade;
CREATE SCHEMA contabilidade AUTHORIZATION ewsoft;
GRANT ALL ON SCHEMA contabilidade TO ewsoft;
COMMENT ON SCHEMA contabilidade IS 'Registros contábeis e fiscais para controle do sistema.';
    
DROP SCHEMA IF EXISTS educacional;
CREATE SCHEMA educacional AUTHORIZATION ewsoft;
GRANT ALL ON SCHEMA educacional TO ewsoft;
COMMENT ON SCHEMA educacional IS 'Dados do módulo educacional, informações acadêmicas.';

DROP SCHEMA IF EXISTS juridico;
CREATE SCHEMA juridico AUTHORIZATION ewsoft;
GRANT ALL ON SCHEMA juridico TO ewsoft;
COMMENT ON SCHEMA juridico IS 'Dados de movimentos e cadastros do módulo jurídico do sistema.';

DROP SCHEMA IF EXISTS pessoal;
CREATE SCHEMA pessoal AUTHORIZATION ewsoft;
GRANT ALL ON SCHEMA pessoal TO ewsoft;
COMMENT ON SCHEMA pessoal IS 'Registros de funcionários e dados relativos aos recursos humanos e gestão de pessoas.';
  
DROP SCHEMA IF EXISTS servico;
CREATE SCHEMA servico AUTHORIZATION ewsoft;
GRANT ALL ON SCHEMA servico TO ewsoft;
COMMENT ON SCHEMA servico IS 'Dados relativos à prestação de serviços de diversas naturezas.';
  
DROP SCHEMA IF EXISTS seguranca;
CREATE SCHEMA seguranca AUTHORIZATION ewsoft;
GRANT ALL ON SCHEMA seguranca TO ewsoft;
COMMENT ON SCHEMA seguranca IS 'Regras de segurança e auditoria do sistema.';
  
DROP SCHEMA IF EXISTS suprimento;
CREATE SCHEMA suprimento AUTHORIZATION ewsoft;
GRANT ALL ON SCHEMA suprimento TO ewsoft;
COMMENT ON SCHEMA suprimento IS 'Cadastros relativos aos produtos e/ou serviços do sistema.';
  
DROP SCHEMA IF EXISTS financeiro;
CREATE SCHEMA financeiro AUTHORIZATION ewsoft;
GRANT ALL ON SCHEMA financeiro TO ewsoft;
COMMENT ON SCHEMA financeiro IS 'Dados relacionados com as rotinas financeiras.';


-- 5º Passo - Criação dos enuns do sistema.

DROP TYPE IF EXISTS administrativo.zona;
CREATE TYPE administrativo.zona AS ENUM (
	 '01 - Norte', 
	 '02 - Leste', 
	 '03 - Oeste', 
	 '04 - Sul'
);

DROP TYPE IF EXISTS administrativo.regiao;
CREATE TYPE administrativo.regiao AS ENUM (
	'01 - Norte', 
	'02 - Nordeste', 
	'03 - Centrooeste', 
	'04 - Sudeste', 
	'05 - Sul'
);

DROP TYPE IF EXISTS administrativo.tipopessoa;
CREATE TYPE administrativo.tipopessoa AS ENUM (
	'01 - Física', 
	'02 - Jurídica', 
	'03 - Segurado especial'
);

DROP TYPE IF EXISTS administrativo.sexo;
CREATE TYPE administrativo.sexo AS ENUM (
	'01 - Masculino', 
	'02 - Feminino', 
	'03 - Personalizado', 
	'04 - Nao informado'
);

DROP TYPE IF EXISTS administrativo.modelodedocumentofiscal;
CREATE TYPE administrativo.modelodedocumentofiscal AS ENUM (
	'01 - Nota fiscal', 
	'1A - Nota fiscal', 
	'1B - Nota fiscal avulsa', 
	'1F - Nota fiscal fatura', 
	'02 - Nota fiscal de venda ao consumidor', 
	'2D - Cupom fiscal emitido por ECF', 
	'2E - Bilhete de passagem emitido por ECF', 
	'04 - Nota fiscal de produtor', 
	'06 - Nota fiscal/conta de energia eletrica', 
	'07 - Nota fiscal de serviço de transporte', 
	'08 - Conhecimento de transporte rodoviario de cargas', 
	'8B - Conhecimento de transporte de carga avulso', 
	'09 - Conhecimento de transporte aquaviário de cargas', 
	'10 - Conhecimento aéreo', 
	'11 - Conhecimento de transporte ferroviário de cargas', 
	'13 - Bilhete de passagem rodoviário', 
	'14 - Bilhete de passagem aquaviário', 
	'15 - Bilhete de passagem e nota de bagagem', 
	'16 - Bilhete de passagem ferroviário', 
	'17 - Despacho de transporte', 
	'18 - Resumo de movimento diário', 
	'20 - Ordem de coleta de cargas', 
	'21 - Nota fiscal de serviço de comunicação', 
	'22 - Nota fiscal de serviço de telecomunicação', 
	'23 - GNRE', 
	'24 - Autorização de carregamento e transporte', 
	'25 - Manifesto de carga', 
	'26 - Conhecimento de transporte multimodal de cargas', 
	'27 - Nota fiscal de transporte ferroviário de cargas', 
	'28 - Nota fiscal/conta de fornecimento de gás canalizado', 
	'29 - Nota fiscal/conta de fornecimento de água canalizada', 
	'30 - Bilhete/recibo do passageiro', 
	'55 - Nota fiscal eletrônica', 
	'57 - Conhecimento de transporte eletrônico - CTe', 
	'59 - Cupom fiscal eletrônico', 
	'61 - Nota de entrega', 
	'65 - Nota fiscal de consumidor eletrônica'
);

DROP TYPE IF EXISTS administrativo.tipodocumento;
CREATE TYPE administrativo.tipodocumento AS ENUM (
	'01 - RG',
	'02 - CNH',
	'03 - Certidão de nascimento',
	'04 - Certidão de casamento',
	'05 - Certificado de alistamento militar',
	'06 - Passaporte',
	'07 - Carteira de trabalho',
	'08 - CPF',
	'09 - Carteira de identidade funcional',
	'10 - Carteira estudantil',
	'11 - CEI',
	'12 - PIS',
	'13 - Título de eleitor',
	'14 - Certidão de óbito',
	'11 - CNPJ',
	'12 - Inscrição estadual',
	'13 - Inscrição municipal',
	'14 - SUFRAMA'
);

DROP TYPE IF EXISTS administrativo.tipologradouro;
CREATE TYPE administrativo.tipologradouro AS ENUM (
	'01 - Aeroporto',
	'02 - Alameda',
	'03 - Área',
	'04 - Avenida',
	'05 - Campo',
	'06 - Chácara',
	'07 - Colônia',
	'08 - Condomínio',
	'09 - Conjunto',
	'10 - Distrito',
	'11 - Esplanada',
	'12 - Estação', 
	'13 - Estrada',
	'14 - Favela',
	'15 - Fazenda',
	'16 - Feira',
	'17 - Jardim',
	'18 - Ladeira',
	'19 - Lago',
	'20 - Lagoa',
	'21 - Largo',
	'22 - Loteamento',
	'23 - Morro',
	'24 - Núcleo',
	'25 - Parque',
	'26 - Passarela',
    '27 - Pátio',
    '28 - Praça',
    '29 - Quadra',
    '30 - Recanto',
    '31 - Residencial',
    '32 - Rodovia',
    '33 - Rua', 
    '34 - Setor', 
    '35 - Sítio',
    '36 - Travessa',
    '37 - Trecho',
    '38 - Trevo',
    '39 - Vale',
    '40 - Vereda',
    '41 - Via',
    '42 - Viaduto',
    '43 - Viela',
    '44 - Vila',
    '45 - Outros'
);

-- 6º Passo - Criação das tabelas do sistema.
-- 6.1 Tabelas do schema administrativo

CREATE TABLE IF NOT EXISTS administrativo.moeda (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    codigoiso CHAR(3) NOT NULL UNIQUE,
    descricao VARCHAR(30) NOT NULL,
    descricaoplural VARCHAR(30) NOT NULL,
    simbolo VARCHAR(5)  NOT NULL,
    menorunidade VARCHAR(30) NOT NULL,
    menorunidadeplural VARCHAR(30) NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE administrativo.moeda IS 'Cadastro de moedas para uso no sistema.';
  
CREATE TABLE IF NOT EXISTS administrativo.idioma (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    sigla VARCHAR(5) NOT NULL,
    descricao VARCHAR(40) NOT NULL,
    descricaoreduzida VARCHAR(20) NOT NULL,
    paginadecodigo VARCHAR(10),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE administrativo.idioma IS 'Cadastro de idiomas a serem utilizados no sistema.';
  
CREATE TABLE IF NOT EXISTS administrativo.pais (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    codigosiscomex CHAR(5) NOT NULL UNIQUE CHECK(codigosiscomex ~*'^[0-9]{4}$'),
    nome VARCHAR(40) NOT NULL,
    sigla VARCHAR(3) NOT NULL UNIQUE,
    dominio CHAR(2) CHECK(dominio ~*'^[A-Z]{2}$'),
    gentilico VARCHAR(40),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE administrativo.pais IS 'Cadastro com lista de paises do mundo.';

    
CREATE TABLE IF NOT EXISTS contabilidade.grupotributario (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    iniciovigencia DATE DEFAULT NOW(),
    finalvigencia DATE,      
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE contabilidade.grupotributario IS 'Relaçao de grupos tributarios para filtros de pessoas.';
  
CREATE TABLE IF NOT EXISTS contabilidade.icmsinterestadual (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    estadoorigemid SMALLINT NOT NULL REFERENCES administrativo.estado(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    estadodestinoid SMALLINT NOT NULL REFERENCES administrativo.estado(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    aliquota NUMERIC(5,2) DEFAULT 12,
    iniciovigencia DATE NOT NULL,
    finalvigencia DATE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE CHECK(ativo = (finalvigencia IS NULL)),
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(estadoorigemid, estadodestinoid)
); COMMENT ON TABLE contabilidade.icmsinterestadual IS 'Aliquotas de ICMS praticadas entre estados da federaçao.';
  
CREATE TABLE IF NOT EXISTS contabilidade.faixasimplesnacional (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    ufid SMALLINT REFERENCES administrativo.estado(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    receitabrutade MONEY NOT NULL CHECK (receitabrutade > 0.0::MONEY) UNIQUE,
    receitabrutaate MONEY NOT NULL CHECK (receitabrutaate > receitabrutade) UNIQUE,
    tabela SMALLINT NOT NULL CHECK(tabela BETWEEN 1 AND 5),
    aliquota NUMERIC(5,2) NOT NULL DEFAULT 0,
    irpj NUMERIC(5,2) NOT NULL DEFAULT 0,
    csll NUMERIC(5,2) NOT NULL DEFAULT 0,
    cofins NUMERIC(5,2) NOT NULL DEFAULT 0,
    pispasep NUMERIC(5,2) NOT NULL DEFAULT 0,
    cpp NUMERIC(5,2) NOT NULL DEFAULT 0,
    icms NUMERIC(5,2) NOT NULL DEFAULT 0,
    iss NUMERIC(5,2) NOT NULL DEFAULT 0,
    ipi NUMERIC(5,2) NOT NULL DEFAULT 0,
    iniciovigencia DATE NOT NULL,
    finalvigencia DATE,      
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE CHECK(ativo = (finalvigencia IS NULL)),
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE contabilidade.faixasimplesnacional IS 'Faixas de receita do Simples Nacional.';
  
CREATE TABLE IF NOT EXISTS contabilidade.pessoacontabilista (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoajuridicafilial(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT NOT NULL REFERENCES administrativo.pessoa(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    crc	VARCHAR(14) NOT NULL,
    crcsequencial VARCHAR(22) NOT NULL,
    crcvalidade DATE NOT NULL,
    crcestadoid SMALLINT NOT NULL REFERENCES administrativo.estado(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE contabilidade.pessoacontabilista IS 'Cadastro de contadores do sistema.';
  
CREATE TABLE IF NOT EXISTS contabilidade.planodecontas (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoajuridicafilial(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(70) NOT NULL,
    niveldesubconta SMALLINT DEFAULT 3,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    iniciovigencia DATE,
    finalvigencia DATE,
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE contabilidade.planodecontas IS 'Cadastro de plano de contas do sistema.';

CREATE TABLE IF NOT EXISTS contabilidade.pessoajuridicafilialfiscal (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoajuridicafilial(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    planodecontaid INTEGER NOT NULL REFERENCES contabilidade.planodecontas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoacontabilistaid SMALLINT REFERENCES contabilidade.pessoacontabilista(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigofpas VARCHAR(4),
    database SMALLINT DEFAULT 5,
    codigoacidentedotrabalho VARCHAR(8),
    obrigatoriedadeefd BOOLEAN DEFAULT FALSE,
    obrigatoriedadeecf BOOLEAN DEFAULT FALSE,
    obrigatoriedadeesocial BOOLEAN DEFAULT FALSE,
    perfilsped CHAR(1) CHECK(perfilsped IN ('A', 'B', 'C')),
    causarais CHAR(1),
    tipoimportacao SMALLINT CHECK(tipoimportacao BETWEEN 1 AND 2), 
    sufixoean VARCHAR(4),
    regimetributario SMALLINT NOT NULL CHECK(regimetributario BETWEEN 1 AND 5),
    mudancaregime DATE NOT NULL,
    recolhepis BOOLEAN,
    recolhecofins BOOLEAN,
    recolhecsll BOOLEAN,
    recolhecide BOOLEAN,
	aliquotaissbase DECIMAL(5,2) DEFAULT 5.0,
	permiteservicoemcupom BOOLEAN DEFAULT TRUE,    
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    iniciovigencia DATE,
    finalvigencia DATE,
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE    
); COMMENT ON TABLE contabilidade.pessoajuridicafilialfiscal IS 'Dados fiscais/tributarios do contribuinte.';
  
CREATE TABLE IF NOT EXISTS contabilidade.pessoasjuridicasfiliaissocios (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT NOT NULL REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    percentualcapital NUMERIC(5,2) DEFAULT 100,
    cargo VARCHAR(20),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, pessoaid)
); COMMENT ON TABLE contabilidade.pessoasjuridicasfiliaissocios IS 'Lista de sócios da filial.';
  
CREATE TABLE IF NOT EXISTS contabilidade.pessoasjuridicasfiliaiscnaes (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    cnaeid INTEGER NOT NULL REFERENCES administrativo.cnaes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    ordem SMALLINT NOT NULL DEFAULT 1,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, ordem),
    UNIQUE(pessoajuridicafilialid, cnaeid)
); COMMENT ON TABLE contabilidade.pessoasjuridicasfiliaiscnaes IS 'Codigo de atividade economica das empresas do sistema.';
  
CREATE TABLE IF NOT EXISTS contabilidade.grupostributariosexcecoes (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    grupotributarioid SMALLINT NOT NULL REFERENCES contabilidade.grupostributarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    icmsordem SMALLINT NOT NULL,
    estadodestinoid SMALLINT REFERENCES administrativo.estados(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    aliquotaicmsinterna NUMERIC(5,2) DEFAULT 0,
    aliquotaicmsexterna NUMERIC(5,2) DEFAULT 0,
    margemdelucro NUMERIC(5,2) DEFAULT 0,
    iss BOOLEAN DEFAULT FALSE,
    icmspauta NUMERIC(5,2) DEFAULT 0,
    ipipauta NUMERIC(5,2) DEFAULT 0,
    pispauta NUMERIC(5,2) DEFAULT 0,
    cofinspauta NUMERIC(5,2) DEFAULT 0,
    icmspautapropria NUMERIC(5,2) DEFAULT 0,
    aliquotaipi NUMERIC(5,2) DEFAULT 0,
    aliquotapis NUMERIC(5,2) DEFAULT 0,
    aliquotacofins NUMERIC(5,2) DEFAULT 0,
    reducaobaseicms NUMERIC(5,2) DEFAULT 0,
    reducaobaseipi NUMERIC(5,2) DEFAULT 0,
    reducaobasepis NUMERIC(5,2) DEFAULT 0,
    reducaobasecofins NUMERIC(5,2) DEFAULT 0,
    reducaobaseicmsst NUMERIC(5,2) DEFAULT 0,
    origemdamercadoria SMALLINT NOT NULL CHECK(origemdamercadoria BETWEEN 0 AND 8),
    csticms SMALLINT CHECK(csticms IN (0, 10, 20, 30, 40, 41, 50, 51, 60, 70, 90)),
    csosn SMALLINT CHECK(csosn IN (101, 102, 103, 201, 202, 203, 300, 400, 500, 900)),
    cstipi SMALLINT CHECK(cstipi IN (0, 1, 2, 3, 4, 5, 49, 50, 51, 52, 53, 54, 55, 99)),
    cstpis SMALLINT CHECK(cstpis IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 49, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 75, 98, 99)),
    cstcofins SMALLINT CHECK(cstcofins IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 49, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 75, 98, 99)),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, grupotributarioid, icmsordem)
); COMMENT ON TABLE contabilidade.grupostributariosexcecoes IS 'Cadastro de excecoes fiscais por grupos tributarios.';
  	    
CREATE TABLE IF NOT EXISTS contabilidade.historicoscontabeis (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigo CHAR(3) NOT NULL CHECK(codigo ~*'^[0-9]{3}$'),
    descricao VARCHAR(40) NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, codigo)
); COMMENT ON TABLE contabilidade.historicoscontabeis IS 'Alteraçoes contabeis e seus historicos.';
  
CREATE TABLE IF NOT EXISTS contabilidade.contascontabeis (
    id SERIAL NOT NULL PRIMARY KEY,
    planodecontaid INTEGER NOT NULL REFERENCES contabilidade.planosdecontas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    superiorid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigo VARCHAR(20) NOT NULL,
    descricao VARCHAR(70) NOT NULL,
    classe SMALLINT DEFAULT 1 CHECK(classe BETWEEN 1 AND 2),
    condicaonormal SMALLINT DEFAULT 1 CHECK(condicaonormal BETWEEN 1 AND 3),
    moedaid SMALLINT NOT NULL REFERENCES administrativo.moedas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    historicopadraoid INTEGER REFERENCES contabilidade.historicoscontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contadeestornoid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(planodecontaid, codigo)
); COMMENT ON TABLE contabilidade.contascontabeis IS 'Lista de contas do plano de contas da empresa/filial.';
  
CREATE TABLE IF NOT EXISTS contabilidade.centrosdecustos (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigo VARCHAR(9) NOT NULL,
    classe SMALLINT DEFAULT 2 CHECK(classe BETWEEN 1 AND 2),
    tipo SMALLINT NOT NULL CHECK(tipo BETWEEN 1 AND 3),
    descricao VARCHAR(50) NOT NULL,
    contacontabilid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    moedaid SMALLINT NOT NULL REFERENCES administrativo.moedas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inicioexistencia DATE,
    apontamento SMALLINT CHECK(apontamento BETWEEN 1 AND 3),
    percentualterceiros NUMERIC(5,2) DEFAULT 0,
    percentualempresa NUMERIC(5,2) CHECK((100 - percentualterceiros) >= 0),
    pessoaresponsavelid INTEGER REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, codigo)
); COMMENT ON TABLE contabilidade.centrosdecustos IS 'Relaçao de centros de custos do sistema.';
  
CREATE TABLE IF NOT EXISTS contabilidade.lancamentoscontabeis (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    numerodocumento VARCHAR(10) NOT NULL CHECK(numerodocumento ~*'^[0-9]{10}$'),
    emissao TIMESTAMP WITH TIME ZONE,
    origemdolancamento SMALLINT NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, numerodocumento)
); COMMENT ON TABLE contabilidade.lancamentoscontabeis IS 'Tabela de lançamentos contabeis do sistema.';
  
CREATE TABLE IF NOT EXISTS contabilidade.lancamentoscontabeisitens (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    lancamentocontabilid BIGINT NOT NULL REFERENCES contabilidade.lancamentoscontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    linha SMALLINT NOT NULL DEFAULT 1, 
    tipo SMALLINT NOT NULL CHECK(tipo BETWEEN 1 AND 4),
    contadebitoid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contacredito INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    valor MONEY CHECK(valor > 0.0::MONEY),
    historicoid INTEGER NOT NULL REFERENCES contabilidade.historicoscontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    centrodecustodebitoid INTEGER REFERENCES contabilidade.centrosdecustos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    centrodecustocreditoid INTEGER REFERENCES contabilidade.centrosdecustos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    numerodolote VARCHAR(10),
    numerododocumento VARCHAR(10),
    lancamentodelucroouperda BOOLEAN DEFAULT FALSE,
    rotinageradora SMALLINT,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, lancamentocontabilid, linha)
); COMMENT ON TABLE contabilidade.lancamentoscontabeisitens IS 'Itens dos lançamentos contabeis.';
  
CREATE TABLE IF NOT EXISTS contabilidade.saldoscontabeis (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contacontabilid INTEGER CHECK(centrodecustoid IS NULL) REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    centrodecustoid INTEGER CHECK(contacontabilid IS NULL) REFERENCES contabilidade.centrosdecustos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    saldonofechamento MONEY DEFAULT 0.0,
    fechamento TIMESTAMP WITH TIME ZONE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, contacontabilid, centrodecustoid, fechamento)
); COMMENT ON TABLE contabilidade.saldoscontabeis IS 'Implantaçao dos saldos contabeis do plano de contas.';
    
CREATE TABLE IF NOT EXISTS comercial.pessoasvendedores (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT NOT NULL REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    classe SMALLINT DEFAULT 1 CHECK(classe BETWEEN 1 AND 6),
    gerenteid INTEGER REFERENCES comercial.pessoasvendedores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    supervisorid INTEGER REFERENCES comercial.pessoasvendedores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    comissaoaprazo NUMERIC(5,2) DEFAULT 0,
    comissaoavista NUMERIC(5,2) DEFAULT 0,
    descontomaximo NUMERIC(5,2) DEFAULT 0,
    percentualemissao NUMERIC(5,2) DEFAULT 100 CHECK(percentualemissao <= (100 - percentualbaixa)),
    percentualbaixa NUMERIC(5,2) DEFAULT 0 CHECK(percentualbaixa <= (100 - percentualemissao)),
    tipo SMALLINT DEFAULT 1 CHECK(tipo BETWEEN 1 AND 3), 
    diarecebimento SMALLINT DEFAULT 31,
    diasparareserva SMALLINT DEFAULT 0,
    registrosla VARCHAR(6),
    vendamovel BOOLEAN DEFAULT TRUE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoaid)
); COMMENT ON TABLE comercial.pessoasvendedores IS 'Cadastro de vendedores e percentuais de comissao.';
  
CREATE TABLE IF NOT EXISTS financeiro.pessoascontasbancarias (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT NOT NULL REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    agenciaid INTEGER NOT NULL REFERENCES administrativo.agenciasbancarias(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodeconta SMALLINT NOT NULL DEFAULT 1 CHECK(tipodeconta BETWEEN 1 AND 5),
    numero VARCHAR(14) NOT NULL CHECK(numero ~*'^[0-9]{14}$'),
    digito VARCHAR(3),
    abertura DATE,
    saldonaabertura MONEY DEFAULT 0,
    limite MONEY DEFAULT 0,
    bloqueada BOOLEAN DEFAULT FALSE,
    databloqueio DATE,
    moedaid SMALLINT REFERENCES administrativo.moedas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contacontabilid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoaid, agenciaid, tipodeconta, numero, digito)
); COMMENT ON TABLE financeiro.pessoascontasbancarias IS 'Cadastro de contas bancarias das pessoas do sistema.';
  
CREATE TABLE IF NOT EXISTS financeiro.pessoascontasbancariasparametros (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contabancariaid INTEGER NOT NULL REFERENCES financeiro.pessoascontasbancarias(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    modelocnab SMALLINT DEFAULT 1 CHECK(modelocnab BETWEEN 1 AND 2),
    contrato VARCHAR(20) NOT NULL CHECK(contrato ~*'^[0-9]{20}$'),
    nossonumero INTEGER DEFAULT 1,
    sequencialcnab INTEGER DEFAULT 1,
    instrucao TEXT,
    diasparadesconto SMALLINT DEFAULT 0,
    descontocondicionado NUMERIC(5,2) DEFAULT 0,
    descontoincondicionado NUMERIC(5,2) DEFAULT 0,
    jurosdeatraso NUMERIC(5,2) DEFAULT 0,
    valormulta MONEY DEFAULT 0,
    recebervencido BOOLEAN DEFAULT FALSE,
    receberfracionado BOOLEAN DEFAULT FALSE,
    moedaid SMALLINT NOT NULL REFERENCES administrativo.moedas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    carteira VARCHAR(5),
    aceite CHAR(1) DEFAULT 'N',
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(contabancariaid, modelocnab, contrato)
); COMMENT ON TABLE financeiro.pessoascontasbancariasparametros IS 'Dados das contas bancarias para comunicaçao bancaria.';

CREATE TABLE IF NOT EXISTS financeiro.administradorasfinanceiras (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT NOT NULL REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    diavirada SMALLINT DEFAULT 5,
    taxacobranca NUMERIC(5,2) DEFAULT 0,
    vencimentopadrao SMALLINT DEFAULT 30,
    prazorepasse SMALLINT DEFAULT 5,
    utilizafator BOOLEAN DEFAULT FALSE,
    codigosoftwareexpress VARCHAR(3),
    codigositef VARCHAR(3),
    privatelabel BOOLEAN DEFAULT FALSE,
    valorminimo MONEY DEFAULT 0,
    qtdmininaparcelas SMALLINT DEFAULT 1,
    qtdmaximaparcelas SMALLINT DEFAULT 99,
    pessoacontabancariaid INTEGER NOT NULL REFERENCES financeiro.pessoascontasbancarias(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE financeiro.administradorasfinanceiras IS 'Dados das administradoras utilizadas no sistema.';
  
  CREATE TABLE IF NOT EXISTS financeiro.formasdepagamento (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(40) NOT NULL,
    tipo SMALLINT NOT NULL DEFAULT 1 CHECK(tipo BETWEEN 1 AND 6),
    modalidade SMALLINT NOT NULL DEFAULT 1 CHECK(modalidade BETWEEN 1 AND 11),
    administradorafinanceiraid INTEGER REFERENCES financeiro.administradorasfinanceiras(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    analisacredito BOOLEAN DEFAULT FALSE,
    financiamentoproprio BOOLEAN DEFAULT FALSE,
    permitetroco BOOLEAN DEFAULT FALSE,
    utilizatef BOOLEAN DEFAULT FALSE,
    codigonoecf CHAR(2),
    descricaonoecf VARCHAR(20),
    carnefiscalnoecf BOOLEAN DEFAULT FALSE,
    tipocomissao SMALLINT DEFAULT 1 CHECK(tipocomissao BETWEEN 1 AND 3),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(codigonoecf)
); COMMENT ON TABLE financeiro.formasdepagamento IS 'Cadastro geral de formas de pagamento.';
  
CREATE TABLE IF NOT EXISTS financeiro.planosdepagamento (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    formadepagamentoid INTEGER NOT NULL REFERENCES financeiro.formasdepagamento(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(70) NOT NULL,
    parcelas SMALLINT DEFAULT 1,
    intervaloentreparcelas SMALLINT DEFAULT 30,
    valorminimo MONEY DEFAULT 0,
    valormaximo MONEY DEFAULT 0,
    vencimentoprimeiraparcela SMALLINT DEFAULT 0,
    tipodemulta SMALLINT DEFAULT 2 CHECK(tipodemulta BETWEEN 1 AND 2),
    valormulta REAL DEFAULT 0,
    tipodejuros SMALLINT DEFAULT 1 CHECK(tipodejuros BETWEEN 1 AND 2),
    valorjuros REAL DEFAULT 0,
    diasaplicacaomulta SMALLINT DEFAULT 0,
    tipodedesconto SMALLINT DEFAULT 1 CHECK(tipodedesconto BETWEEN 1 AND 2),
    valordesconto REAL DEFAULT 0,
    diasparadesconto SMALLINT DEFAULT 0,
    tipodeentrada SMALLINT DEFAULT 1 CHECK(tipodeentrada BETWEEN 1 AND 2),
    valorentrada REAL DEFAULT 0,
    incidejurosemparcelas BOOLEAN DEFAULT FALSE,
    taxadejurosemparcelas NUMERIC(5,2) DEFAULT 0,
    tratamentoipi SMALLINT CHECK(tratamentoipi BETWEEN 1 AND 3),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE financeiro.planosdepagamento IS 'Cadastro de condiçoes de pagamento do sistema.';
  
CREATE TABLE IF NOT EXISTS comercial.tabelasdepreco (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(70) NOT NULL,
    iniciovigencia DATE,
    finalvigencia DATE,
    formadepagamentoid INTEGER REFERENCES financeiro.formasdepagamento(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    recorrente BOOLEAN DEFAULT FALSE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE comercial.tabelasdepreco IS 'Tabela de preços para os produtos e clientes.';
  
CREATE TABLE IF NOT EXISTS comercial.pessoasclientes (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT NOT NULL REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    limitedecredito MONEY DEFAULT 0,
    descontopadrao NUMERIC(5,2) DEFAULT 0,
    contribuinteinss BOOLEAN DEFAULT TRUE,
    retemiss BOOLEAN DEFAULT FALSE,
    issinclusonopreco BOOLEAN DEFAULT TRUE,
    aliquotairrf NUMERIC(5,2),
    codigosuframa VARCHAR(12),
    descontosuframa BOOLEAN DEFAULT FALSE,
    vendedorid INTEGER REFERENCES comercial.pessoasvendedores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tabeladeprecoid INTEGER REFERENCES comercial.tabelasdepreco(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    comissao NUMERIC(5,2) DEFAULT 0,
    transportadoraid BIGINT REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodefrete SMALLINT DEFAULT 1 CHECK(tipodefrete BETWEEN 1 AND 4),
    grauderisco CHAR(1) DEFAULT 'C' CHECK(grauderisco IN ('A', 'B', 'C', 'D', 'E')),
    classedecredito CHAR(1) CHECK(classedecredito IN ('A', 'B', 'C')),
    planodepagamentoid INTEGER REFERENCES financeiro.planosdepagamento(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contacontabilid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipo SMALLINT DEFAULT 1 CHECK (tipo BETWEEN 1 AND 5),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE comercial.pessoasclientes IS 'Dados dos clientes do sistema.';
  
CREATE TABLE IF NOT EXISTS suprimento.pessoasfornecedores (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT NOT NULL REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    representanteid INTEGER REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descontopadrao NUMERIC(5,2) DEFAULT 0,
    prioridade SMALLINT CHECK(prioridade BETWEEN 1 AND 5),
    planodepagamentoid INTEGER REFERENCES financeiro.planosdepagamento(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contacontabilid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,  
    utilizab2b BOOLEAN DEFAULT FALSE,
    utilizaedi BOOLEAN DEFAULT TRUE,
    diasparaentrega SMALLINT DEFAULT 0,
    toleranciaentrega SMALLINT DEFAULT 0,
    participacotacao BOOLEAN DEFAULT TRUE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE    
); COMMENT ON TABLE suprimento.pessoasfornecedores IS 'Dados cadastrais dos fornecedores.';
   
CREATE TABLE IF NOT EXISTS financeiro.naturezasfinanceiras (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(70) not null,
    classecontabil SMALLINT DEFAULT 1 CHECK(classecontabil BETWEEN 1 AND 2),
    movimentobancario BOOLEAN DEFAULT TRUE,
    calculairrf BOOLEAN DEFAULT FALSE,
    baseirrf NUMERIC(5,2) DEFAULT 0,
    aliquotairrf NUMERIC(5,2) DEFAULT 0,
    recolheirrf BOOLEAN DEFAULT TRUE,
    calculaiss BOOLEAN DEFAULT FALSE,
    aliquotaiss NUMERIC(5,2) DEFAULT 0,
    calculainss BOOLEAN DEFAULT FALSE,
    aliquotainss NUMERIC(5,2) DEFAULT 0,
    calculacsll BOOLEAN DEFAULT FALSE,
    aliquotacsll NUMERIC(5,2) DEFAULT 0,
    calculapis BOOLEAN DEFAULT FALSE,
    basepis NUMERIC(5,2) DEFAULT 0,
    aliquotapis NUMERIC(5,2) DEFAULT 0,
    calculacofins BOOLEAN DEFAULT FALSE,
    deduzpis BOOLEAN DEFAULT FALSE,
    calculasestsenat BOOLEAN DEFAULT FALSE,
    basesestsenat NUMERIC(5,2) DEFAULT 0,
    aliquotasestsenat NUMERIC(5,2) DEFAULT 0,
    aliquotaiof NUMERIC(5,2) DEFAULT 0,
    mododeapuracaopis SMALLINT CHECK(mododeapuracaopis BETWEEN 1 AND 2),
    mododeapuracaocofins SMALLINT CHECK(mododeapuracaocofins BETWEEN 1 AND 2),
    reducaoapuracaopis NUMERIC(5,2) DEFAULT 0,
    reducaoapuracaocofins NUMERIC(5,2) DEFAULT 0,
    aliquotaapuracaopis NUMERIC(5,2) DEFAULT 0,
    aliquotaapuracaocofins NUMERIC(5,2) DEFAULT 0,
    classificacao SMALLINT CHECK(classificacao BETWEEN 1 AND 3),
    contacontabilid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE financeiro.naturezasfinanceiras IS 'Dados básicos da natureza financeira.';

CREATE TABLE IF NOT EXISTS financeiro.moedascotacoes (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    moedaorigemid SMALLINT NOT NULL REFERENCES administrativo.moedas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    moedadestinoid SMALLINT NOT NULL REFERENCES administrativo.moedas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    datacotacao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    taxa MONEY DEFAULT 0,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(moedaorigemid, moedadestinoid, datacotacao)
); COMMENT ON TABLE financeiro.moedascotacoes IS 'Movimento de cotaçao de moeda.';

CREATE TABLE IF NOT EXISTS suprimento.grifes (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    grifenome VARCHAR(70) NOT NULL,
    grifefonecedor INTEGER REFERENCES suprimento.fornecedores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE suprimento.grifes IS 'Dados gerais de grifes de produtos.';

CREATE TABLE IF NOT EXISTS suprimento.colecao (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    colecaonome VARCHAR(70) NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE suprimento.colecao IS 'Cadastro de coleçoes, lançamentos, etc.';
  
CREATE TABLE IF NOT EXISTS suprimento.armazens (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaresponsavelid INTEGER REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(70) NOT NULL,
    altura REAL,
    largura REAL,
    comprimento REAL,
    tipo SMALLINT DEFAULT 1 CHECK(tipo BETWEEN 1 AND 3), 
    entramrp BOOLEAN DEFAULT TRUE,
    entradaavulsa BOOLEAN DEFAULT FALSE,
    permitetransferencia BOOLEAN DEFAULT TRUE,
    faturarsemsaldo BOOLEAN DEFAULT FALSE,
    exibeestoque BOOLEAN DEFAULT TRUE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE suprimento.armazens IS 'Dados gerais dos armazens para deposito de produto.';
  
CREATE TABLE IF NOT EXISTS suprimento.tiposdemateriais (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(50) NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT TRUE
); COMMENT ON TABLE suprimento.tiposdemateriais IS 'Tipos basicos de materiais utilizados no sistema.';
  
CREATE TABLE IF NOT EXISTS suprimento.unitizadores (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(70) NOT NULL,
    altura REAL,
    largura REAL,
    comprimento REAL,
    capacidade REAL,
    empilhamentomaximo REAL,
    tara REAL,
    consumo BOOLEAN DEFAULT FALSE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE suprimento.unitizadores IS 'Cadastro de unidade de unitizaçao para armazenagem.';
  
CREATE TABLE IF NOT EXISTS suprimento.marcasdeprodutos (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(50) NOT NULL,
    pessoaid BIGINT REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE suprimento.marcasdeprodutos IS 'Cadastro geral de marcas de produtos.';
  
CREATE TABLE IF NOT EXISTS suprimento.gruposdeprodutos (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    grupopaiid INTEGER REFERENCES suprimento.gruposdeprodutos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigo CHAR(4) NOT NULL,
    descricao VARCHAR(50) NOT NULL,
    procedenciaoriginal BOOLEAN DEFAULT TRUE,
    status SMALLINT DEFAULT 1 CHECK(status BETWEEN 1 AND 4),
    analitico BOOLEAN DEFAULT FALSE,
    controlaestoque BOOLEAN DEFAULT TRUE,
    pessoaresponsavelid INTEGER REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    marcadeprodutoid INTEGER REFERENCES suprimento.marcasdeprodutos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    classificacao SMALLINT DEFAULT 3 CHECK(classificacao BETWEEN 1 AND 3),
    markup NUMERIC(5,2) DEFAULT 0,
    descontomaximo NUMERIC(5,2),
    contacontabilid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    centrodecustoid INTEGER REFERENCES contabilidade.centrosdecustos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, codigo)
); COMMENT ON TABLE suprimento.gruposdeprodutos IS 'Grupos genericos de produtos.';
  
CREATE TABLE IF NOT EXISTS contabilidade.tiposdeoperacoes (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigo SMALLINT NOT NULL CHECK(codigo BETWEEN 100 AND 799),
    descricao VARCHAR(50) NOT NULL,
    tipo SMALLINT NOT NULL CHECK(tipo = (CASE WHEN codigo BETWEEN 100 AND 399 THEN 1 WHEN codigo BETWEEN 400 AND 699 THEN 2 END)),
    calculaicms BOOLEAN DEFAULT TRUE,
    calculaipi BOOLEAN DEFAULT TRUE,
    creditaicms BOOLEAN DEFAULT TRUE,
    creditapis BOOLEAN DEFAULT TRUE,
    gerafinanceiro BOOLEAN DEFAULT TRUE,
    atualizaestoque BOOLEAN DEFAULT TRUE,
    cfopid INTEGER NOT NULL REFERENCES administrativo.cfops(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricaoreduzida VARCHAR(40) NOT NULL,
    reducaobaseicms NUMERIC(5,2) DEFAULT 0,
    reducaobaseipi NUMERIC(5,2) DEFAULT 0,
    poderdeterceiro SMALLINT DEFAULT 3 CHECK(poderdeterceiro BETWEEN 1 AND 3),
    livrofiscalicms SMALLINT DEFAULT 1 CHECK(livrofiscalicms BETWEEN 1 AND 6),
    livrofiscalipi SMALLINT DEFAULT 6 CHECK(livrofiscalipi BETWEEN 1 AND 6),
    destacaipi BOOLEAN DEFAULT TRUE,
    ipinabase BOOLEAN DEFAULT TRUE,
    calculadiferencaicms BOOLEAN DEFAULT FALSE,
    ipisobreofrete BOOLEAN DEFAULT FALSE,
    reducaobaseiss NUMERIC(5,2) DEFAULT 0,
    calculaiss BOOLEAN DEFAULT FALSE,
    livrofiscaliss SMALLINT DEFAULT 3 CHECK(livrofiscaliss BETWEEN 1 AND 6),
    numerolivrofiscal SMALLINT CHECK(numerolivrofiscal BETWEEN 1 AND 9),
    atualizaprecodecompra BOOLEAN DEFAULT TRUE,
    materialdeconsumo BOOLEAN DEFAULT FALSE,
    devolucaoid INTEGER REFERENCES contabilidade.tiposdeoperacoes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    transfereentrefiliais BOOLEAN DEFAULT FALSE,
    atualizaativo BOOLEAN DEFAULT FALSE,
    reducaobaseicmsst NUMERIC(5,2) DEFAULT 0,
    creditaicmsst BOOLEAN DEFAULT FALSE,
    origemdamercadoria SMALLINT NOT NULL CHECK(origemdamercadoria BETWEEN 0 AND 8),
    csticms SMALLINT CHECK(csticms IN (0, 10, 20, 30, 40, 41, 50, 51, 60, 70, 90)),
    csosn SMALLINT CHECK(csosn IN (101, 102, 103, 201, 202, 203, 300, 400, 500, 900)),
    cstipi SMALLINT CHECK(cstipi IN (0, 1, 2, 3, 4, 5, 49, 50, 51, 52, 53, 54, 55, 99)),
    cstpis SMALLINT CHECK(cstpis IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 49, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 75, 98, 99)),
    cstcofins SMALLINT CHECK(cstcofins IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 49, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 75, 98, 99)),    
    reducaobasepis NUMERIC(5,2) DEFAULT 0,
    reducaobasecofins NUMERIC(5,2) DEFAULT 0,
    gerapisconfins BOOLEAN DEFAULT FALSE,
    retornoterceiroid INTEGER REFERENCES contabilidade.tiposdeoperacoes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    naturezaiss SMALLINT DEFAULT 1 CHECK(naturezaiss BETWEEN 1 AND 3),
    retemiss BOOLEAN DEFAULT FALSE,
    inss BOOLEAN DEFAULT FALSE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, codigo)
); COMMENT ON TABLE contabilidade.tiposdeoperacoes IS 'Estrutura principal das operaçoes do sistema.';
  
CREATE TABLE IF NOT EXISTS suprimento.produtos (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigointerno VARCHAR(14) NOT NULL,
    codigogtin VARCHAR(14) CHECK(codigogtin ~*'^[0-9]{14}$'),
    descricao VARCHAR(70) NOT NULL,
    grupodeproduto SMALLINT CHECK(grupodeproduto BETWEEN 1 AND 7),
    tipodeproduto SMALLINT DEFAULT 11 CHECK(tipodeproduto BETWEEN 1 AND 14),
    origemdamercadoria SMALLINT DEFAULT 0 CHECK(origemdamercadoria BETWEEN 0 AND 8),
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pesoliquido REAL DEFAULT 0,
    pesobruto REAL DEFAULT 0,
    armazemid SMALLINT REFERENCES suprimento.armazens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    grupodeprodutoid INTEGER REFERENCES suprimento.gruposdeprodutos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodeoperacaodeentradaid INTEGER REFERENCES contabilidade.tiposdeoperacoes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodeoperacaodesaidaid INTEGER REFERENCES contabilidade.tiposdeoperacoes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoalternativoid INTEGER REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    custopadrao MONEY,
    ultimoprecodecompra MONEY,
    ultimadatadecompra DATE,
    ippt SMALLINT DEFAULT 2 CHECK (ippt BETWEEN 1 AND 2), 
    iat SMALLINT DEFAULT 1 CHECK (iat BETWEEN 1 AND 2),
    grade BOOLEAN DEFAULT FALSE,
    contacontabilid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    centrodecustoid INTEGER REFERENCES contabilidade.centrosdecustos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    familia BOOLEAN DEFAULT FALSE,
    apropriacaodireta BOOLEAN DEFAULT TRUE,
    fantasma BOOLEAN DEFAULT FALSE,
    rastro BOOLEAN DEFAULT FALSE,
    comissao NUMERIC(5,2) DEFAULT 0,
    intervalodeinventario SMALLINT DEFAULT 0,
    controlaenderecamento BOOLEAN DEFAULT FALSE,
    aliquotaicms NUMERIC(5,2) DEFAULT 0,
    aliquotaipi NUMERIC(5,2) DEFAULT 0,
    aliquotaiss NUMERIC(5,2) DEFAULT 0,
    tipincmid INTEGER NOT NULL REFERENCES administrativo.tipincm(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigoservicoiss VARCHAR(14),
    tributacaonomunicipio VARCHAR(20),
    cnaedeservicoid INTEGER REFERENCES administrativo.cnaes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    margemdelucrosolidariosaida NUMERIC(5,2) DEFAULT 0,
    margemdelucrosolidarioentrada NUMERIC(5,2) DEFAULT 0,
    pontodepedido REAL DEFAULT 0,
    estoquedeseguranca REAL DEFAULT 0,
    prazodeentrega SMALLINT DEFAULT 0,
    tipodeprazo SMALLINT CHECK(tipodeprazo BETWEEN 1 AND 4),
    loteeconomico REAL DEFAULT 0,
    loteminimo REAL DEFAULT 0,
    validade SMALLINT DEFAULT 0,
    estoquemaximo REAL DEFAULT 0,
    cqnotaminima SMALLINT DEFAULT 0,
    cqquantidade REAL DEFAULT 0,
    imagem BYTEA,
    garantiaestendida BOOLEAN DEFAULT FALSE,
    garantiaestendidapercentual NUMERIC(5,2) DEFAULT 0,
    garantiaestendidatempo SMALLINT DEFAULT 0,
    fracionado BOOLEAN DEFAULT TRUE,
    descricaoprocessoprodutivo TEXT,
    markup NUMERIC(5,2) DEFAULT 0,
    percentualmacronutrientes NUMERIC(5,2) DEFAULT 0,
    percentualmicronutrientes NUMERIC(5,2) DEFAULT 0,
    md5 VARCHAR(32),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, codigointerno)
); COMMENT ON TABLE suprimento.produtos IS 'Cadastro generico dos produtos do sistema.';
  
CREATE TABLE IF NOT EXISTS suprimento.produtoscomplementos (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    nomecientifico VARCHAR(70) NOT NULL,
    temcertificado BOOLEAN,
    estadofisico SMALLINT DEFAULT 1,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, produtoid)
); COMMENT ON TABLE suprimento.produtoscomplementos IS 'Informaçoes complementares sobre o produto.';
  
CREATE TABLE IF NOT EXISTS suprimento.produtosestruturas (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    versao SMALLINT DEFAULT 0,
    quantidadebase REAL DEFAULT 1,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, produtoid, versao)
); COMMENT ON TABLE suprimento.produtosestruturas IS 'Informaçoes para lançamento de ordem de produçao.';
  
CREATE TABLE IF NOT EXISTS suprimento.produtosestruturasitens (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoestruturaid INTEGER NOT NULL REFERENCES suprimento.produtosestruturas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    sequencia SMALLINT NOT NULL,
    quantidade REAL DEFAULT 1,
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    perdaaceitavel NUMERIC(5,2) DEFAULT 0,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, produtoestruturaid, produtoid, sequencia)
); COMMENT ON TABLE suprimento.produtosestruturasitens IS 'Itens das ordens de produçao.';

CREATE TABLE IF NOT EXISTS suprimento.produtosinformacoesnutricionais (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantidadeporcao REAL DEFAULT 1,
    unidadeporcaoid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, produtoid)
); COMMENT ON TABLE suprimento.produtosinformacoesnutricionais IS 'Tabela de informaçoes nutricionais de generos alimenticios.';

CREATE TABLE IF NOT EXISTS suprimento.produtosinformacoesnutricionaisitens (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoinformacaonutricionalid INTEGER NOT NULL REFERENCES suprimento.produtosinformacoesnutricionais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    propriedade SMALLINT NOT NULL CHECK(propriedade BETWEEN 1 AND 9), -- 1 - Valor energetico, 2 - Carboidratos, 3 - Proteinas, 4 - Gorduras saturadas, 5 - Gorduras trans, 6 - Fibra alimentar, 7 - Sodio, 8 - Outros minerais, 9 - Vitaminas.
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    percentualvd REAL NOT NULL DEFAULT 0,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, produtoinformacaonutricionalid, propriedade)
); COMMENT ON TABLE suprimento.produtosinformacoesnutricionaisitens IS 'Dados detalhes das informaçoes nutricionais do produto.';
  
CREATE TABLE IF NOT EXISTS comercial.tabelasdeprecoprodutos (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tabeladeprecoid INTEGER NOT NULL REFERENCES comercial.tabelasdepreco(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    precobase MONEY NOT NULL,
    precovenda MONEY NOT NULL,
    quantidademaxima REAL DEFAULT 999999.99,
    moedaid SMALLINT DEFAULT 1 REFERENCES administrativo.moedas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    frete MONEY DEFAULT 0,
    descontomaximo NUMERIC(5,2) DEFAULT 0,
    estadoid SMALLINT REFERENCES administrativo.estados(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, tabeladeprecoid, produtoid, estadoid)
); COMMENT ON TABLE comercial.tabelasdeprecoprodutos IS 'Itens das tabelas de preços.';
  
CREATE TABLE IF NOT EXISTS comercial.produtosclientes (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    clienteid BIGINT NOT NULL REFERENCES comercial.pessoasclientes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigo VARCHAR(14) NOT NULL,
    qrcode TEXT,
    descricao VARCHAR(70),
    tabeladeprecoid INTEGER REFERENCES comercial.tabelasdepreco(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodeconversao SMALLINT DEFAULT 1 CHECK (tipodeconversao BETWEEN 1 AND 2),
    fatordeconversao REAL DEFAULT 1,
    pesovariavel BOOLEAN DEFAULT FALSE,
    tempodedescarregamento TIME WITH TIME ZONE,
    compartilhaendereco BOOLEAN DEFAULT FALSE,
    utilizapulmao BOOLEAN DEFAULT TRUE,
    comprimento REAL DEFAULT 0,
    largura REAL DEFAULT 0,
    altura REAL DEFAULT 0,
    fatordearmazenamento REAL DEFAULT 1,
    empilhamentomaximo REAL,
    imprimeetiqueta BOOLEAN DEFAULT TRUE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, clienteid, produtoid)
); COMMNET ON TABLE comercial.produtosclientes IS 'Amarraçao produto x cliente.';
  
CREATE TABLE IF NOT EXISTS suprimento.produtosfornecedores (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    fornecedorid BIGINT NOT NULL REFERENCES suprimento.pessoasfornecedores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigo VARCHAR(14) NOT NULL,
    qrcode TEXT,
    descricao VARCHAR(70),
    tabeladeprecoid INTEGER REFERENCES comercial.tabelasdepreco(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodeconversao SMALLINT DEFAULT 1 CHECK (tipodeconversao BETWEEN 1 AND 2),
    fatordeconversao REAL DEFAULT 1,
    pesovariavel BOOLEAN DEFAULT FALSE,
    toleranciaemquantidade NUMERIC(5,2) DEFAULT 0,
    toleranciaempreco NUMERIC(5,2) DEFAULT 0,
    toleranciaemdias NUMERIC(5,2) DEFAULT 0,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, fornecedorid, produtoid)  
); COMMENT ON TABLE suprimento.produtosfornecedores IS 'Amarraçao produto x fornecedor.';
  
CREATE TABLE IF NOT EXISTS suprimento.produtostamanhos (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigo VARCHAR(5) NOT NULL,
    descricao VARCHAR(70) NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, codigo)
); COMMENT ON TABLE suprimento.produtostamanhos IS 'Lista de possíveis tamanhos para os produtos de grade.';

CREATE TABLE IF NOT EXISTS suprimento.produtosgrades (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    corid SMALLINT REFERENCES administrativo.cores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tamanhoid SMALLINT REFERENCES suprimentos.produtostamanhos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, produtoid, corid, tamanhoid)
); COMMENT ON TABLE suprimento.produtosgrades IS 'Lista de produtos adicionados à grade.';

CREATE TABLE IF NOT EXISTS suprimento.produtosgradetamanhos (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtogradeid INTEGER NOT NULL REFERENCES suprimento.produtosgrade(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tamanhoid SMALLINT NOT NULL REFERENCES suprimento.produtostamanhos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, produtogradeid, tamanhoid)
); COMMENT ON TABLE suprimento.produtosgradetamanhos IS 'Tamanhos dos produtos da grade.';
  
CREATE TABLE IF NOT EXISTS suprimento.lotes (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    fabricacao TIMESTAMP WITH TIME ZONE,
    validade TIMESTAMP WITH TIME ZONE,
    status SMALLINT DEFAULT 1 CHECK(status BETWEEN 1 AND 6),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE suprimento.lotes IS 'Cadastro de lotes de produtos.';
  
CREATE TABLE IF NOT EXISTS suprimento.normasdearmazenagem (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(70) NOT NULL,
    unitizadorid INTEGER NOT NULL REFERENCES suprimento.unitizadores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    lastro REAL NOT NULL,
    camada REAL NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE suprimento.normasdearmazenagem IS 'Lista de regras/normas para armazenagem.';
  
CREATE TABLE IF NOT EXISTS suprimento.zonasdearmazenagem (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(50) NOT NULL,
    corid INTEGER REFERENCES administrativo.cores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    procedimento TEXT,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE suprimento.zonasdearmazenagem IS 'Cadastro das zonas de armazenagem de produtos.';
  
CREATE TABLE IF NOT EXISTS suprimento.estruturasdearmazenagem (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(50) NOT NULL,
    largura REAL,
    altura REAL,
    comprimento REAL,
    unidadedemedidaid SMALLINT REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    capacidade REAL,
    unitizada BOOLEAN DEFAULT TRUE,
    tipo SMALLINT DEFAULT 1 CHECK(tipo BETWEEN 1 AND 6),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE suprimento.estruturasdearmazenagem IS 'Lista das estruturas de armazenagem do WMS.';
  
CREATE TABLE IF NOT EXISTS suprimento.enderecosfisicos (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigo VARCHAR(14) NOT NULL,
    armazemid SMALLINT NOT NULL REFERENCES suprimento.armazens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(50) NOT NULL,
    prioridade SMALLINT,
    estruturadearmazenagemid INTEGER REFERENCES suprimento.estruturasdearmazenagem(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    indicedeperda NUMERIC(5,2) DEFAULT 0,
    zonadearmazenagemid INTEGER REFERENCES suprimento.zonasdearmazenagem(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    disponibilidade SMALLINT DEFAULT 1 CHECK(disponibilidade BETWEEN 1 AND 4),
    ultimoinventario DATE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, armazemid, codigo)
); COMMENT ON TABLE suprimento.enderecosfisicos IS 'Relaçao de endereços para localizaçao dos produtos.';
  
CREATE TABLE IF NOT EXISTS suprimento.enderecosexternos (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(50) NOT NULL,
    estruturadearmazenagemid INTEGER REFERENCES suprimento.estruturasdearmazenagem(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    horasdia TIME,
    custohora MONEY,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE suprimento.enderecosexternos IS 'Cadastro de armazens externos à infraestrutura de armazenagem.';
  
CREATE TABLE IF NOT EXISTS suprimento.produtossaldosiniciais (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    armazemid INTEGER NOT NULL REFERENCES suprimento.armazens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantidade REAL DEFAULT 0,
    valor MONEY DEFAULT 0,
    data DATE DEFAULT NOW(),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, produtoid, armazemid)
); COMMENT ON TABLE suprimento.produtossaldosiniciais IS 'Definiçao de saldos iniciais dos produtos por localizaçao.';
  
CREATE TABLE IF NOT EXISTS suprimento.gruposdecompras (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    descricao VARCHAR(70) NOT NULL,
    tipo SMALLINT DEFAULT 1 CHECK(tipo BETWEEN 1 AND 4),
    superiorid INTEGER REFERENCES suprimento.gruposdecompras(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodelimite SMALLINT DEFAULT 1 CHECK(tipodelimite BETWEEN 1 AND 4),
    quantidadelimite REAL,
    valorlimite MONEY,
    pedidosemsolicitacao BOOLEAN DEFAULT FALSE,
    grupodeprodutoid INTEGER REFERENCES suprimento.gruposdeprodutos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS seguranca.controledeversao (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    versaobanco VARCHAR(16) NOT NULL DEFAULT '2018.08.build_12',
    versaoaplicativo VARCHAR(16) NOT NULL DEFAULT '2018.08.build_12',
    invalidaporversao BOOLEAN DEFAULT TRUE,
    iniciovigencia DATE,
    finalvigencia DATE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    md5 VARCHAR(32) NOT NULL, 
    UNIQUE(versaobanco, versaoaplicativo)
);

CREATE TABLE IF NOT EXISTS seguranca.licenca (
	id SERIAL NOT NULL PRIMARY KEY,
	pessoajuridicafilialid BIGINT NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	descricao VARCHAR(70) NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
	edicao TIMESTAMP WITH TIME ZONE,
	licencaativa BOOLEAN DEFAULT FALSE,
	md5 VARCHAR(32) NOT NULL,
	ativo BOOLEAN DEFAULT TRUE,
	deletado BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS seguranca.licencaconfiguracoes (
	id SERIAL NOT NULL PRIMARY KEY,
	licencaid INTEGER NOT NULL REFERENCES seguranca.licenca(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	servidorsmtp VARCHAR(100) NOT NULL,
	servidorsmtpporta SMALLINT DEFAULT 587,
	servidorsmtpusuario VARCHAR(100) NOT NULL,
	servidorsmtpsenha VARCHAR(100) NOT NULL,
	usatls BOOLEAN DEFAULT TRUE,
	usassl BOOLEAN DEFAULT FALSE,
	inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
	edicao TIMESTAMP WITH TIME ZONE,
	ativo BOOLEAN DEFAULT TRUE,
	deletado BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS seguranca.menus (
	id SERIAL NOT NULL PRIMARY KEY,
	modulo SMALLINT NOT NULL CHECK(modulo IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)), -- 1 - administrativo, 2 - comercial, 3 - contabilidade, 4 - educacional, 5 - juridico, 6 - pessoal, 7 - seguranca, 8 - servico, 9 - suprimento, 10 - financeiro
	descricao VARCHAR(50) NOT NULL,
	menupai INTEGER REFERENCES seguranca.menu(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	icone VARCHAR(50),
	nomeformulario VARCHAR(50),
	inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
	edicao TIMESTAMP WITH TIME ZONE,
	ativo BOOLEAN DEFAULT TRUE,
	deletado BOOLEAN DEFAULT FALSE	
);
 
CREATE TABLE IF NOT EXISTS seguranca.usuarios (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT NOT NULL REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    login VARCHAR(32) NOT NULL,
    senhaencriptada VARCHAR(64) NOT NULL CHECK(LENGTH(senhaencriptada) > 6),
    perguntasecreta VARCHAR(100),
    respostasecreta VARCHAR(100),
	tipo int DEFAULT 1,
    grupodeusuarioid INTEGER NOT NULL REFERENCES seguranca.gruposdeusuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    grupodecompraid INTEGER REFERENCES suprimento.gruposdecompras(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, pessoaid),
    UNIQUE(login)
);

CREATE TABLE IF NOT EXISTS seguranca.usuariosmenus (
	id SERIAL NOT NULL PRIMARY KEY,
	usuarioid INTEGER NOT NULL REFERENCES seguranca.usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	menuid INTEGER NOT NULL REFERENCES seguranca.menus(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	inclui BOOLEAN DEFAULT FALSE,
	edita BOOLEAN DEFAULT FALSE,
	exclui BOOLEAN DEFAULT FALSE,
	visualiza BOOLEAN DEFAULT FALSE,
	inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
	edicao TIMESTAMP WITH TIME ZONE,
	ativo BOOLEAN DEFAULT TRUE,
	deletado BOOLEAN DEFAULT FALSE,
	UNIQUE(usuarioid, menuid)
);
  
CREATE TABLE IF NOT EXISTS seguranca.auditoria (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    usuarioid INTEGER NOT NULL REFERENCES seguranca.usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodelog SMALLINT NOT NULL CHECK(tipodelog BETWEEN 1 AND 4),
    tabela VARCHAR(30) NOT NULL,
    valorantigo VARCHAR(200),
    valornovo VARCHAR(200),
    mensagem VARCHAR(200) NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    md5 VARCHAR(32) NOT NULL,
    deletado BOOLEAN DEFAULT FALSE
);
  
CREATE TABLE IF NOT EXISTS suprimento.solicitacaodematerial (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    usuarioid INTEGER NOT NULL REFERENCES seguranca.usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    status SMALLINT DEFAULT 1 CHECK(status BETWEEN 1 AND 7), 
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE
);
  
CREATE TABLE IF NOT EXISTS suprimento.solicitacaodematerialitens (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    solicitacaodematerialid BIGINT NOT NULL REFERENCES suprimento.solicitacaodematerial(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantidadesolicitada REAL CHECK(quantidadesolicitada > 0),
    quantidadeatendida REAL DEFAULT 0 CHECK(quantidadeatendida <= quantidadesolicitada),
    quantidaderesidual REAL CHECK(quantidaderesidual = quantidadesolicitada - quantidadeatendida),
    status SMALLINT DEFAULT 1 CHECK(status BETWEEN 1 AND 7),
    centrodecustoid INTEGER REFERENCES contabilidade.centrosdecustos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    necessidade DATE,
    observacao TEXT,
    armazemid SMALLINT NOT NULL REFERENCES suprimento.armazens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE
);
  
CREATE TABLE IF NOT EXISTS suprimento.cotacoesitens (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    usuarioid INTEGER NOT NULL REFERENCES seguranca.usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    solicitacaodematerialitemid BIGINT NOT NULL REFERENCES suprimento.solicitacaodematerialitens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    sequencialitem SMALLINT NOT NULL,
    fornecedorid BIGINT NOT NULL REFERENCES suprimento.pessoasfornecedores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantidade REAL CHECK(quantidade > 0),
    valorunitario MONEY,
    descontounitario DECIMAL(5,2) DEFAULT 0,
    aliquotaipi DECIMAL(5,2) DEFAULT 0,
    aliquotaicms DECIMAL(5,2) DEFAULT 0,
    valortotal MONEY CHECK(valortotal = valorunitario - (valorunitario * (descontounitario/100) + valorunitario * (aliquotaipi/100) * quantidade)),
    tipodefrete SMALLINT DEFAULT 1 CHECK(tipodefrete BETWEEN 1 AND 4),
    valorfrete MONEY DEFAULT 0,
    diasparaentrega SMALLINT NOT NULL,
    planodepagamentoid INTEGER REFERENCES financeiro.planosdepagamento(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    validade DATE,
    necessidade DATE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, solicitacaodematerialitemid, fornecedorid)
);
  
CREATE TABLE IF NOT EXISTS suprimento.pedidosdemateriais (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    usuarioid INTEGER NOT NULL REFERENCES seguranca.usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    fornecedorid BIGINT NOT NULL REFERENCES suprimento.pessoasfornecedores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    planodepagamentoid INTEGER NOT NULL REFERENCES financeiro.planosdepagamento(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contato VARCHAR(30),
    fonecontato INTEGER,
    filialparaentregaid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    moedadacompraid SMALLINT NOT NULL REFERENCES administrativo.moedas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    status SMALLINT DEFAULT 1 CHECK(status BETWEEN 1 AND 5),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE
);
  
CREATE TABLE IF NOT EXISTS suprimento.pedidosdemateriaisitens (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pedidodematerialid BIGINT NOT NULL REFERENCES suprimento.pedidosdemateriais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    sequencial SMALLINT NOT NULL,
    solicitacaodematerialitemid BIGINT REFERENCES suprimento.solicitacaodematerialitens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    cotacaoitemid BIGINT REFERENCES suprimento.cotacoesitens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantidade REAL CHECK(quantidade > 0),
    precounitario MONEY,
    desconto NUMERIC(5,2) DEFAULT 0,
    tipodeoperacaoid INTEGER NOT NULL REFERENCES contabilidade.tiposdeoperacoes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    baseicms MONEY NOT NULL,
    aliquotaicms NUMERIC(5,2) NOT NULL,
    valoricms MONEY CHECK (valoricms = baseicms * (aliquotaicms/100)),
    baseipi MONEY,
    aliquotaipi NUMERIC(5,2) DEFAULT 0,
    valoripi MONEY CHECK (valoripi = baseipi * (aliquotaipi/100)),
    basecsll MONEY DEFAULT 0,
    aliquotacsll NUMERIC(5,2) DEFAULT 0,
    valorcsll MONEY CHECK (valorcsll = basecsll * (aliquotacsll/100)),
    baseinss MONEY DEFAULT 0,
    aliquotainss NUMERIC(5,2) DEFAULT 0,
    valorinss MONEY CHECK (valorinss = baseinss * (aliquotainss/100)),
    baseiss MONEY DEFAULT 0,
    aliquotaiss NUMERIC(5,2) DEFAULT 0,
    valoriss MONEY CHECK (valoriss = baseiss * (aliquotaiss/100)),
    outrasdespesas MONEY DEFAULT 0,
    tipodefrete SMALLINT DEFAULT 1 CHECK(tipodefrete BETWEEN 1 AND 4),
    valordofrete MONEY DEFAULT 0,
    precototal MONEY CHECK (precototal = quantidade * (precounitario - (precounitario * desconto/100)) + valordofrete + valoripi + outrasdespesas),
    previsaodeentrega DATE,
    observacao TEXT,
    armazemid SMALLINT NOT NULL REFERENCES suprimento.armazens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    centrodecustoid INTEGER REFERENCES contabilidade.centrosdecustos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contacontabilid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    residuoeliminado BOOLEAN DEFAULT FALSE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE
);
  
CREATE TABLE IF NOT EXISTS suprimento.tiposdemovimentacao (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigo SMALLINT NOT NULL,
    tipo SMALLINT NOT NULL CHECK(tipo BETWEEN 1 AND 4),
    atualizaempenho BOOLEAN DEFAULT FALSE,
    quantidadezerada BOOLEAN DEFAULT FALSE,
    atualizaestoque BOOLEAN DEFAULT TRUE,
    atualizacusto BOOLEAN DEFAULT TRUE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, codigo)
);
  
CREATE TABLE IF NOT EXISTS suprimento.ordensdeproducao (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipo SMALLINT DEFAULT 1 CHECK(tipo BETWEEN 1 AND 4),
    abertura DATE NOT NULL,
    previsao DATE,
    entrega DATE,
    situacao SMALLINT DEFAULT 1 CHECK(situacao BETWEEN 1 AND 3),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE
);
  
CREATE TABLE IF NOT EXISTS suprimento.ordensdeproducaoitens (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    ordemdeproducaoid BIGINT NOT NULL REFERENCES suprimento.ordensdeproducao(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    itemsequencia SMALLINT NOT NULL,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantidade REAL CHECK (quantidade > 0),
    armazemid SMALLINT NOT NULL REFERENCES suprimento.armazens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    centrodecustoid INTEGER REFERENCES contabilidade.centrosdecustos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    observacao TEXT,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, ordemdeproducaoid, itemsequencia)
);
  
CREATE TABLE IF NOT EXISTS servico.fabricantes (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicaid BIGINT NOT NULL REFERENCES administrativo.pessoasjuridicas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    sigla VARCHAR(20),
    nacional BOOLEAN DEFAULT TRUE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicaid)    
);
  
CREATE TABLE IF NOT EXISTS servico.modelos (
    id SERIAL NOT NULL PRIMARY KEY,
    fabricanteid INTEGER NOT NULL REFERENCES administrativo.fabricantes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    nome VARCHAR(70) NOT NULL,
    modalidadedegarantia SMALLINT DEFAULT 2 CHECK(modalidadedegarantia BETWEEN 1 AND 3),
    tipodegarantia SMALLINT DEFAULT 1 CHECK(tipodegarantia BETWEEN 1 AND 2),
    tempodegarantia SMALLINT DEFAULT 1,
    tipodetransporte SMALLINT DEFAULT 1 CHECK(tipodetransporte BETWEEN 1 AND 5),
    tipodecombustivel SMALLINT DEFAULT 1 CHECK(tipodecombustivel BETWEEN 1 AND 8),
    especiedetransporte SMALLINT DEFAULT 1 CHECK(especiedetransporte BETWEEN 1 AND 6),
    numerodepassageiros SMALLINT DEFAULT 5,
    numerodeeixos SMALLINT DEFAULT 2,
    veiculopopular BOOLEAN DEFAULT FALSE,
    tara REAL,
    altura REAL,
    largura REAL,
    comprimento REAL,
    capacidademaxima REAL,
    icmsnovo DECIMAL(5,2),
    icmsusado DECIMAL(5,2),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
);
  
CREATE TABLE IF NOT EXISTS servico.rastreadores (
    id SERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    marca VARCHAR(30) NOT NULL,
    modelo VARCHAR(30) NOT NULL,
    numerodeserie VARCHAR(60) NOT NULL,
    numero INTEGER,
    imei BIGINT,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, imei)
);
  
CREATE TABLE IF NOT EXISTS servico.veiculos (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    rastreadorid INTEGER REFERENCES administrativo.rastreadores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    modeloid INTEGER NOT NULL REFERENCES administrativo.modelos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    proprietarioid BIGINT NOT NULL REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    anofabricacao SMALLINT,
    anomodelo SMALLINT CHECK(anomodelo >= anofabricacao),
    corid INTEGER NOT NULL REFERENCES administrativo.cores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    placa CHAR(7) NOT NULL,
    municipioid INTEGER NOT NULL REFERENCES administrativo.municipios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    renavam VARCHAR(20),
    chassi VARCHAR(30),
    rntc VARCHAR(8),
    rntcvalidade DATE,
    cavalosforca SMALLINT,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, placa)
);
  
CREATE TABLE IF NOT EXISTS servico.veiculosdadosadicionais (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    veiculoid BIGINT NOT NULL REFERENCES administrativo.veiculos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    numerodomotor VARCHAR(30),
    numerodocambio VARCHAR(30),
    codigodachave VARCHAR(30),
    codigodosom VARCHAR(30),
    imagem BYTEA,
    crv BYTEA,
    crlv BYTEA,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, veiculoid)
);
  
CREATE TABLE IF NOT EXISTS servico.veiculosacessorios (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    veiculoid BIGINT NOT NULL REFERENCES administrativo.veiculos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantidade REAL DEFAULT 1,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE
);
  
CREATE TABLE IF NOT EXISTS suprimento.inventarios (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    usuarioid INTEGER NOT NULL REFERENCES seguranca.usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    documento VARCHAR(14) NOT NULL,
    validade TIMESTAMP WITH TIME ZONE,
    bloqueiaprodutos BOOLEAN DEFAULT FALSE,
    status SMALLINT DEFAULT 1 CHECK(status BETWEEN 1 AND 3),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, documento)
);
  
CREATE TABLE IF NOT EXISTS suprimento.iventariositens (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inventarioid BIGINT NOT NULL REFERENCES suprimento.inventarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    armazemid SMALLINT NOT NULL REFERENCES suprimento.armazens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantidade REAL DEFAULT 0,
    enderecofisicoid INTEGER REFERENCES suprimento.enderecosfisicos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    estruturadearmazenagemid INTEGER REFERENCES suprimento.estruturasdearmazenagem(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    loteid INTEGER REFERENCES suprimento.lotes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    sublote VARCHAR(6),
    contagem SMALLINT DEFAULT 1,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, inventarioid, produtoid, armazemid)    
);
  
CREATE TABLE IF NOT EXISTS suprimento.movimentosinternos (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodemovimentacaoid INTEGER NOT NULL REFERENCES suprimento.tiposdemovimentacao(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    usuarioid INTEGER NOT NULL REFERENCES seguranca.usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE
);
  
CREATE TABLE IF NOT EXISTS contabilidade.documentosfiscais (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    numero INTEGER NOT NULL CHECK(numero > 0),
    serie SMALLINT DEFAULT 1,
    emissao TIMESTAMP WITH TIME ZONE,
    pessoaid BIGINT NOT NULL REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    enderecofaturamentoid BIGINT NOT NULL REFERENCES administrativo.enderecos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    enderecoentregaid BIGINT DEFAULT enderecofaturamentoid REFERENCES administrativo.enderecos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodemovimentacao SMALLINT DEFAULT 0 CHECK(tipodemovimentacao BETWEEN 0 AND 1), -- 0 - Entrada, 1 - Saida
    modelodedocumento SMALLINT DEFAULT 25 CHECK(modelodedocumento BETWEEN 1 AND 30),
    planodepagamentoid INTEGER NOT NULL REFERENCES financeiro.planosdepagamento(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    transportadoraid BIGINT REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    veiculoid BIGINT REFERENCES administrativo.veiculos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    saida TIMESTAMP WITH TIME ZONE CHECK(saida >= emissao),
    finalidade SMALLINT DEFAULT 1 CHECK(finalidade BETWEEN 1 AND 4),
    usuarioid INTEGER NOT NULL REFERENCES seguranca.usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodefrete SMALLINT DEFAULT 1 CHECK(tipodefrete BETWEEN 1 AND 4),
    valorfrete MONEY DEFAULT 0,
    outrasdespesas MONEY DEFAULT 0,
    descontos MONEY DEFAULT 0,
    digitacao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    recebimento TIMESTAMP WITH TIME ZONE,
    observacoes TEXT,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, pessoaid, numero)
);
  
CREATE TABLE IF NOT EXISTS suprimento.movimentosdeestoqueitens (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    movimentointernoid BIGINT REFERENCES suprimento.movimentosinternos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    documentofiscalid BIGINT REFERENCES contabilidade.documentosfiscais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    itemsequencia SMALLINT NOT NULL,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantidade REAL CHECK(quantidade > 0),
    precounitario MONEY,
    descontopercentual NUMERIC(5,2) DEFAULT 0,
    descontovalor MONEY CHECK(descontovalor = precounitario * (descontopercentual/100)),
    valorunitario MONEY CHECK(valorunitario = precounitario - descontovalor),
    valortotal MONEY CHECK(valortotal = valorunitario * quantidade),
    valorfrete MONEY,
    tipodeoperacaoid INTEGER NOT NULL REFERENCES contabilidade.tiposdeoperacoes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    cfopid INTEGER REFERENCES administrativo.cfops(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    origemdamercadoria SMALLINT DEFAULT 0 CHECK(origemdamercadoria BETWEEN 0 AND 8),
    centrodecustoid INTEGER REFERENCES contabilidade.centrosdecustos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contacontabilid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    armazemid SMALLINT NOT NULL REFERENCES suprimento.armazens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    regradearmazenagem SMALLINT CHECK(regradearmazenagem BETWEEN 1 AND 4),
    enderecofisicoid INTEGER REFERENCES suprimento.enderecosfisicos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    custo MONEY DEFAULT 0,
    documentoorigemid BIGINT REFERENCES contabilidade.documentosfiscais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    itemorigemid BIGINT REFERENCES suprimento.movimentosdeestoqueitens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE
);
  
CREATE TABLE IF NOT EXISTS suprimento.saldosemestoque (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    produtoid BIGINT NOT NULL REFERENCES suprimento.produtos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    armazemid SMALLINT NOT NULL REFERENCES suprimento.armazens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    fechamento TIMESTAMP WITH TIME ZONE,
    quantidade REAL,
    unidadedemedidaid SMALLINT NOT NULL REFERENCES administrativo.unidadesdemedidas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    valor MONEY,
    custo MONEY,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, pessoaid, produtoid, armazemid, fechamento)
);
  
CREATE TABLE IF NOT EXISTS sped.documentosfiscaiseletronicos (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    documentofiscalid BIGINT NOT NULL REFERENCES contabilidade.documentosfiscais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    destinooperacao SMALLINT DEFAULT 1 CHECK(destinooperacao BETWEEN 1 AND 3),
    
);  

CREATE TABLE IF NOT EXISTS contabilidade.documentosfiscaistributacao (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    documentofiscalid BIGINT NOT NULL REFERENCES contabilidade.documentosfiscais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    movimentodeestoqueitemid BIGINT NOT NULL REFERENCES suprimento.movimentosdeestoqueitens(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipodocimportacao CHAR(1),
    tipodeimposto SMALLINT CHECK(tipodeimposto BETWEEN 1 AND 12),
    basedecalculo MONEY DEFAULT 0,
    percentualdereducao NUMERIC(5,2) DEFAULT 0,
    aliquota NUMERIC(5,2) DEFAULT 0,
    valor MONEY CHECK(valor = basedecalculo * (aliquota/100)),
    valordesconto MONEY DEFAULT 0,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, documentofiscalid, movimentodeestoqueitemid, tipodeimposto)
);
  
CREATE TABLE IF NOT EXISTS financeiro.titulos (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER NOT NULL REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    prefixo VARCHAR(3),
    numero INTEGER NOT NULL CHECK (numero > 0),
    parcela SMALLINT,
    carteira SMALLINT NOT NULL CHECK(carteira IN (0, 1)), -- 0 - Receber, 1 - Pagar
    tipo SMALLINT NOT NULL,
    documentofiscalid BIGINT REFERENCES contabilidade.documentosfiscais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoaid BIGINT NOT NULL REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    naturezafinanceiraid INTEGER REFERENCES financeiro.naturezasfinanceiras(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    movimentobancario BOOLEAN DEFAULT TRUE,
    portadorid INTEGER NOT NULL REFERENCES financeiro.pessoascontasbancarias(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    emissao DATE DEFAULT NOW(),
    valor MONEY CHECK(valor > 0.00::MONEY),
    vencimento DATE CHECK(vencimento >= emissao),
    vencimentoreal DATE,
    valorirrf MONEY DEFAULT 0.0,
    valoriss MONEY DEFAULT 0.0,
    valorinss MONEY DEFAULT 0.0,
    valorcsll MONEY DEFAULT 0.0,
    valorpis MONEY DEFAULT 0.0,
    valorcofins MONEY DEFAULT 0.0,
    valorsestsenat MONEY DEFAULT 0.0,
    valoriof MONEY DEFAULT 0.0,
    valoracrescimos MONEY DEFAULT 0.0,
    valordescontos MONEY DEFAULT 0.0,
    valorreal MONEY CHECK(valorreal = CASE WHEN carteira = 0 THEN (valor + valoracrescimos - valordescontos) ELSE (valor + valoracrescimos - valordescontos - valorirrf - valoriss - valorinss - valorcsll - valorpis - valorcofins - valorsestsenat - valoriof) END),
    planodepagamentoid INTEGER NOT NULL REFERENCES financeiro.planosdepagamento(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    contacontabilid INTEGER REFERENCES contabilidade.contascontabeis(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    geradirf BOOLEAN DEFAULT FALSE,
    historico TEXT,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoajuridicafilialid, prefixo, numero, parcela, carteira, pessoaid)
);

CREATE TABLE IF NOT EXISTS financeiro.cheques (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    codigocmc7 CHAR(34),
    compensacao CHAR(3) NOT NULL CHECK(compensacao ~*'^[0-9]{3}$'),
    pessoaid BIGINT REFERENCES administrativo.pessoas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoacontabancariaid INTEGER NOT NULL REFERENCES financeiro.pessoascontasbancarias(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tituloid BIGINT NOT NULL REFERENCES financeiro.titulos(ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    numero CHAR(6) NOT NULL,
    valor MONEY CHECK(valor > 0.00::MONEY),
    emissao DATE DEFAULT NOW(),
    predatado DATE,
    clientedesde CHAR(6) CHECK(clientedesde ~*'^[0-9]{6}$'),
    cruzado BOOLEAN DEFAULT FALSE,
    nominal BOOLEAN DEFAULT FALSE,
    nomeemissor VARCHAR(70),
    cpfcnpjemissor VARCHAR(14) CHECK(cpfcnpjemissor ~*'^[0-9]{14}$'),
    rgemissor VARCHAR(14),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(pessoacontabancariaid, numero)
);
  
CREATE TABLE IF NOT EXISTS financeiro.movimentacaodecheque (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoajuridicafilial(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    chequeid BIGINT NOT NULL REFERENCES financeiro.cheque(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    baixa DATE DEFAULT NOW(),
    devolvido BOOLEAN DEFAULT FALSE,
    motivodevolucao SMALLINT CHECK (motivodevolucao IN (11, 12, 13, 14, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35, 37, 38, 39, 40, 41, 42, 43, 44, 45, 48, 49, 59, 60, 61, 64, 70, 71, 72)),
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(chequeid, baixa, motivodevolucao)    
);
  
CREATE TABLE IF NOT EXISTS financeiro.boleto (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
);
  
CREATE TABLE IF NOT EXISTS financeiro.bordero (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
);
  /*
  		-- Dados pessoafisica
      	naturezajuridica SMALLINT CHECK(naturezajuridica BETWEEN 1015 AND 5037),
    	tipodeenquadramento SMALLINT DEFAULT 6 CHECK(tipodeenquadramento BETWEEN 1 AND 8),
    	grupotributarioid SMALLINT REFERENCES administrativo.grupostributarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
        
        -- Dados estado
        iniciovigencia DATE DEFAULT NOW(),
        finalvigencia DATE,	    
        icmsaliquotainterna DECIMAL(5,2) DEFAULT 18.0,
	    fundoamparoapobreza NUMERIC(5,2) DEFAULT 0,
    
        -- Dados pessoasjuridicasfiliaisfiscais
	    numeronire VARCHAR(25),
    	emissaonire DATE,
    	inscricaosuframa VARCHAR(13),
        
        
CREATE TABLE IF NOT EXISTS administrativo.gruposdeempresas (
    id SMALLSERIAL NOT NULL PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    iniciovigencia DATE DEFAULT NOW(),
    finalvigencia DATE,            
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE administrativo.gruposdeempresas IS 'Grupos empresariais.';                 

CREATE TABLE IF NOT EXISTS administrativo.contratos (
    id SERIAL NOT NULL PRIMARY KEY,
    descricao VARCHAR(70) NOT NULL,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    iniciovigencia DATE DEFAULT NOW(),
    finalvigencia DATE,            
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE
); COMMENT ON TABLE administrativo.contratos IS 'Relaçao de contratos firmados entre parceiros.';
  
CREATE TABLE IF NOT EXISTS administrativo.contratosconfig (
    id SERIAL NOT NULL PRIMARY KEY,
    entidade SMALLINT NOT NULL CHECK(entidade BETWEEN 1 AND 8),
    grupodeempresaid SMALLINT REFERENCES administrativo.gruposdeempresas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoajuridicaid INTEGER REFERENCES administrativo.pessoasjuridicas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    pessoajuridicafilialid INTEGER REFERENCES administrativo.pessoasjuridicasfiliais(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    planodecontaid INTEGER REFERENCES contabilidade.planosdecontas(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inclusao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edicao TIMESTAMP WITH TIME ZONE,
    ativo BOOLEAN DEFAULT TRUE,
    deletado BOOLEAN DEFAULT FALSE,
    UNIQUE(entidade, grupodeempresaid, pessoajuridicaid, pessoajuridicafilialid)
);  
*/
