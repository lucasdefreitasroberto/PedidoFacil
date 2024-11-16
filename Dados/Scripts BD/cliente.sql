-- Verifica e cria o gerador GEN_CLIENTE_ID se ele não existir
execute block as
begin
  if (not exists(select 1 from rdb$generators where rdb$generator_name = 'GEN_CLIENTE_ID')) then
    execute statement 'create generator GEN_CLIENTE_ID';
end;

-- Verifica e cria a tabela CLIENTE se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relations where rdb$relation_name = 'CLIENTE')) then
    execute statement '
      create table CLIENTE (
          COD_CLIENTE         INTEGER NOT NULL,
          COD_USUARIO         INTEGER,
          CNPJ_CPF            VARCHAR(20),
          NOME                VARCHAR(100),
          FONE                VARCHAR(20),
          EMAIL               VARCHAR(100),
          ENDERECO            VARCHAR(500),
          NUMERO              VARCHAR(50),
          COMPLEMENTO         VARCHAR(50),
          BAIRRO              VARCHAR(50),
          CIDADE              VARCHAR(50),
          UF                  VARCHAR(2),
          CEP                 VARCHAR(10),
          LATITUDE            DECIMAL(12,6),
          LONGITUDE           DECIMAL(12,6),
          LIMITE_DISPONIVEL   DECIMAL(12,2),
          DATA_ULT_ALTERACAO  TIMESTAMP
      )';
end;

-- Verifica e adiciona a chave primária na tabela CLIENTE se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_1')) then
    execute statement 'alter table CLIENTE add primary key (COD_CLIENTE)';
end;

-- Verifica e adiciona a chave estrangeira para COD_USUARIO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_2')) then
    execute statement 'alter table CLIENTE add foreign key (COD_USUARIO) references USUARIO (COD_USUARIO)';
end;

-- Cria ou altera o trigger TR_CLIENTE
set term ^ ;
execute block as
begin
  execute statement '
    create or alter trigger TR_CLIENTE for CLIENTE
    active before insert position 0
    as
    begin
        new.COD_CLIENTE = gen_id(gen_cliente_id, 1);
    end';
end^
set term ; ^

commit;

