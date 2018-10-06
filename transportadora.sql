CREATE TABLE modelo_veiculo(
  cod_modelo          INTEGER     NOT NULL,
  desc_modelo_veiculo VARCHAR(30) NOT NULL,
  CONSTRAINT pk_modelo_veiculo
    PRIMARY KEY(cod_modelo)
);

CREATE TABLE veiculo(
  placa_veiculo        CHAR(7)     NOT NULL,
  descricao_veiculo    VARCHAR(30) NOT NULL,
  cod_modelo_veiculo_v INTEGER     NOT NULL,
  CONSTRAINT pk_veiculo
    PRIMARY KEY(placa_veiculo),
  CONSTRAINT fk_veiculo_modelo
    FOREIGN KEY(cod_modelo_veiculo_v)
    REFERENCES modelo_veiculo(cod_modelo)
);

CREATE TABLE uf(
  sigla_uf CHAR(2)     NOT NULL,
  nome_uf  VARCHAR(30) NOT NULL,
  CONSTRAINT pk_uf
    PRIMARY KEY(sigla_uf)
);

CREATE TABLE cidade(
  cod_cidade      INTEGER     NOT NULL,
  nome_cidade     VARCHAR(40) NOT NULL,
  sigla_uf_cidade CHAR(2)     NOT NULL,
  CONSTRAINT pk_cidade
    PRIMARY KEY(cod_cidade),
  CONSTRAINT fk_cidade_uf
    FOREIGN KEY(sigla_uf_cidade)
    REFERENCES uf(sigla_uf)
);

CREATE TABLE filial(
  sigla_filial  CHAR(3)     NOT NULL,
  nome_filial   VARCHAR(30) NOT NULL,
  cidade_filial INTEGER     NOT NULL,
  CONSTRAINT pk_filial
    PRIMARY KEY(sigla_filial),
  CONSTRAINT fk_filial_cidade
    FOREIGN KEY(cidade_filial)
    REFERENCES cidade(cod_cidade)
);

CREATE TABLE motorista(
  cnh_motorista  CHAR(11) NOT NULL,
  nome_motorista VARCHAR(40) NOT NULL,
  categoria_cnh  CHAR(2) NOT NULL,
  CONSTRAINT pk_motorista
    PRIMARY KEY(cnh_motorista)
);

CREATE TABLE red(
  filial_origem_red CHAR(3)  NOT NULL,
  num_red           CHAR(6)  NOT NULL,
  data_red          DATE     NOT NULL,
  cnh_motorista_red CHAR(11) NOT NULL,
  veiculo_red       CHAR(7)  NOT NULL,
  posicao_red       CHAR(1)  NOT NULL,
  CONSTRAINT pk_red
    PRIMARY KEY(filial_origem_red,num_red),
  CONSTRAINT fk_red_filial
    FOREIGN KEY(filial_origem_red)
    REFERENCES filial(sigla_filial),
  CONSTRAINT fk_red_motorista
    FOREIGN KEY(cnh_motorista_red)
    REFERENCES motorista(cnh_motorista),
  CONSTRAINT fk_red_veiculo
    FOREIGN KEY(veiculo_red)
    REFERENCES veiculo(placa_veiculo)
);

CREATE TABLE cliente(
  cod_cliente    INTEGER NOT NULL,
  nome_cliente   VARCHAR(40)   NOT NULL,
  rua_cliente    VARCHAR(40)   NOT NULL,
  bairro_cliente VARCHAR(30)   NOT NULL,
  cidade_cliente INTEGER       NOT NULL,
  cep_cliente    CHAR(8)       NOT NULL,
  tipo_cliente   CHAR(1)       NOT NULL,
  cpf_cliente    CHAR(11)      NULL,
  cnpj_cliente   CHAR(14)      NULL,
  limite_credito NUMERIC(12,2) NOT NULL,
  CONSTRAINT pk_cliente
    PRIMARY KEY(cod_cliente),
  CONSTRAINT fk_cliente_cidade
    FOREIGN KEY(cidade_cliente)
    REFERENCES cidade(cod_cidade)
);

CREATE TABLE cliente_telefone(
  cod_cliente_telefone INTEGER  NOT NULL,
  telefone             CHAR(10) NOT NULL,
  CONSTRAINT pk_cliente_telefone
    PRIMARY KEY(cod_cliente_telefone,telefone),
  CONSTRAINT fk_cliente_telefone_cliente
    FOREIGN KEY(cod_cliente_telefone)
    REFERENCES cliente(cod_cliente)
);

CREATE TABLE frete(
  filial_origem_frete  CHAR(3)      NOT NULL,
  filial_destino_frete CHAR(3)      NOT NULL,
  valor_frete          NUMERIC(9,2) NOT NULL,
  CONSTRAINT pk_frete
    PRIMARY KEY(filial_origem_frete,filial_destino_frete),
  CONSTRAINT fk_frete_origem_filial
    FOREIGN KEY(filial_origem_frete)
    REFERENCES filial(sigla_filial),
  CONSTRAINT fk_frete_destino_frete
    FOREIGN KEY(filial_destino_frete)
    REFERENCES filial(sigla_filial)
);

CREATE TABLE ctrc(
  filial_origem_ctrc CHAR(3) NOT NULL,
  num_ctrc           CHAR(6) NOT NULL,
  cliente_remetente  INTEGER NOT NULL,
  filial_destino_ctrc CHAR(3) NOT NULL,
  cliente_destinatario INTEGER NOT NULL,
  data_emissao         DATE    NOT NULL,
  peso_ctrc            NUMERIC(9,3) NOT NULL,
  frete_ctrc           NUMERIC(9,2) NOT NULL,
  CONSTRAINT pk_ctrc
    PRIMARY KEY(filial_origem_ctrc,num_ctrc),
  CONSTRAINT fk_ctrc_cliente_origem
    FOREIGN KEY(cliente_remetente)
    REFERENCES cliente(cod_cliente),
  CONSTRAINT fk_ctrc_cliente_destino
    FOREIGN KEY(cliente_destinatario)
    REFERENCES cliente(cod_cliente),
  CONSTRAINT fk_ctrc_filial_origem
    FOREIGN KEY(filial_origem_ctrc)
    REFERENCES filial(sigla_filial),
  CONSTRAINT fk_ctrc_flial_destino
    FOREIGN KEY(filial_destino_ctrc)
    REFERENCES filial(sigla_filial)
);

CREATE TABLE ctrc_nf(
  filial_origem_ctrc_nf CHAR(3)       NOT NULL,
  num_ctrc_nf           CHAR(6)       NOT NULL,
  num_nf                CHAR(6)       NOT NULL,
  valor_nf              NUMERIC(10,2) NOT NULL,
  CONSTRAINT pk_ctrc_nf
    PRIMARY KEY(filial_origem_ctrc_nf,num_ctrc_nf,num_nf),
  CONSTRAINT fk_ctrc_nf_ctrc
    FOREIGN KEY(filial_origem_ctrc_nf,num_ctrc_nf)
    REFERENCES ctrc(filial_origem_ctrc,num_ctrc)
);

CREATE TABLE itens_red(
  filial_origem_red_ir  CHAR(3) NOT NULL,
  num_red_ir            CHAR(6) NOT NULL,
  filial_origem_ctrc_ir CHAR(3) NOT NULL,
  num_ctrc_ir           CHAR(6) NOT NULL,
  CONSTRAINT pk_itens_red
    PRIMARY KEY(filial_origem_red_ir,num_red_ir,filial_origem_ctrc_ir,num_ctrc_ir),
  CONSTRAINT fk_itens_red_ctrc
    FOREIGN KEY(filial_origem_ctrc_ir,num_ctrc_ir)
    REFERENCES ctrc(filial_origem_ctrc,num_ctrc),
  CONSTRAINT fk_itens_red_red
    FOREIGN KEY(filial_origem_red_ir,num_red_ir)
    REFERENCES red(filial_origem_red,num_red)
);

CREATE TABLE manifesto(
  filial_origem_manifesto  CHAR(3) NOT NULL,
  num_manifesto            CHAR(6) NOT NULL,
  filial_destino_manifesto CHAR(3) NOT NULL,
  data_emissao_manifesto   DATE    NOT NULL,
  data_chegada_manifesto   DATE    NULL,
  veiculo_manifesto        CHAR(7) NOT NULL,
  CONSTRAINT pk_manifesto
    PRIMARY KEY(filial_origem_manifesto,num_manifesto),
  CONSTRAINT fk_manifesto_filial_origem
    FOREIGN KEY(filial_origem_manifesto)
    REFERENCES filial(sigla_filial),
  CONSTRAINT fk_manifesto_filial_destino
    FOREIGN KEY(filial_destino_manifesto)
    REFERENCES filial(sigla_filial),
  CONSTRAINT fk_manifesto_veiculo
    FOREIGN KEY(veiculo_manifesto)
    REFERENCES veiculo(placa_veiculo)
);

CREATE TABLE manifesto_motorista(
  filial_origem_manifesto_m CHAR(3)  NOT NULL,
  num_manifesto_m           CHAR(6)  NOT NULL,
  cnh_motorista_m           CHAR(11) NOT NULL,
  CONSTRAINT pk_manifesto_motorista
    PRIMARY KEY(filial_origem_manifesto_m,num_manifesto_m,cnh_motorista_m),
  CONSTRAINT fk_manifesto_motorista_motorista
    FOREIGN KEY(cnh_motorista_m)
    REFERENCES motorista(cnh_motorista),
  CONSTRAINT fk_manifesto_motorista_manifesto
    FOREIGN KEY(filial_origem_manifesto_m,num_manifesto_m)
    REFERENCES manifesto(filial_origem_manifesto,num_manifesto)
);

CREATE TABLE coleta(
  filial_origem_coleta CHAR(3)      NOT NULL,
  num_coleta           CHAR(6)      NOT NULL,
  data_coleta          DATE         NOT NULL,
  cnh_motorista_coleta CHAR(11)     NOT NULL,
  veiculo_coleta       CHAR(7)      NOT NULL,
  posicao_coleta       CHAR(1)      NOT NULL,
  cliente_coleta       INTEGER      NOT NULL,
  valor_nf_coleta      NUMERIC(9,2) NOT NULL,
  CONSTRAINT pk_coleta
    PRIMARY KEY(filial_origem_coleta,num_coleta),
  CONSTRAINT fk_coleta_filial
    FOREIGN KEY(filial_origem_coleta)
    REFERENCES filial(sigla_filial),
  CONSTRAINT fk_coleta_motorista
    FOREIGN KEY(cnh_motorista_coleta)
    REFERENCES motorista(cnh_motorista),
  CONSTRAINT fk_coleta_veiculo
    FOREIGN KEY(veiculo_coleta)
    REFERENCES veiculo(placa_veiculo),
  CONSTRAINT fk_coleta_cliente
    FOREIGN KEY(cliente_coleta)
    REFERENCES cliente(cod_cliente)
);

CREATE TABLE itens_manifesto(
  filial_origem_manifesto_im CHAR(3) NOT NULL,
  num_manifesto_im           CHAR(6) NOT NULL,
  filial_origem_ctrc_im      CHAR(3) NOT NULL,
  num_ctrc_im                CHAR(6) NOT NULL,
  posicao_ctrc               CHAR(1) NOT NULL,
  CONSTRAINT pk_itens_manifesto
    PRIMARY KEY(filial_origem_manifesto_im,num_manifesto_im,filial_origem_ctrc_im,num_ctrc_im),
  CONSTRAINT fk_itens_manifesto_manifesto
    FOREIGN KEY(filial_origem_manifesto_im,num_manifesto_im)
    REFERENCES manifesto(filial_origem_manifesto,num_manifesto),
  CONSTRAINT fk_itens_manifesto_ctrc
    FOREIGN KEY(filial_origem_ctrc_im,num_ctrc_im)
    REFERENCES ctrc(filial_origem_ctrc,num_ctrc)
);