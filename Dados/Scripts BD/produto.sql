-- Verifica e cria o gerador GEN_PRODUTO_ID se ele não existir
execute block as
begin
  if (not exists(select 1 from rdb$generators where rdb$generator_name = 'GEN_PRODUTO_ID')) then
    execute statement 'create generator GEN_PRODUTO_ID';
end;

-- Verifica e cria a tabela PRODUTO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relations where rdb$relation_name = 'PRODUTO')) then
    execute statement '
      create table PRODUTO (
          COD_PRODUTO         INTEGER NOT NULL,
          COD_USUARIO         INTEGER,
          DESCRICAO           VARCHAR(200),
          VALOR               DECIMAL(12,2),
          FOTO                BLOB SUB_TYPE BINARY SEGMENT SIZE 80,
          QTD_ESTOQUE         DECIMAL(12,2),
          DATA_ULT_ALTERACAO  TIMESTAMP
      )';
end;

-- Verifica e adiciona a chave primária na tabela PRODUTO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_1')) then
    execute statement 'alter table PRODUTO add primary key (COD_PRODUTO)';
end;

-- Verifica e adiciona a chave estrangeira para COD_USUARIO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_2')) then
    execute statement 'alter table PRODUTO add foreign key (COD_USUARIO) references USUARIO (COD_USUARIO)';
end;

-- Cria ou altera o trigger TR_PRODUTO para garantir o incremento automático de COD_PRODUTO
set term ^ ;
execute block as
begin
  execute statement '
    create or alter trigger TR_PRODUTO for PRODUTO
    active before insert position 0
    as
    begin
        new.COD_PRODUTO = gen_id(gen_produto_id, 1);
    end';
end^
set term ; ^

commit;

