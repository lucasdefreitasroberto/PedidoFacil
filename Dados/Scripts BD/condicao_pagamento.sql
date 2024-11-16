-- Verifica e cria o gerador GEN_COND_PAGTO_ID se ele não existir
execute block as
begin
  if (not exists(select 1 from rdb$generators where rdb$generator_name = 'GEN_COND_PAGTO_ID')) then
    execute statement 'create generator GEN_COND_PAGTO_ID';
end;

-- Verifica e cria a tabela COND_PAGTO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relations where rdb$relation_name = 'COND_PAGTO')) then
    execute statement '
      create table COND_PAGTO (
          COD_COND_PAGTO      INTEGER NOT NULL,
          COND_PAGTO          VARCHAR(100),
          DATA_ULT_ALTERACAO  TIMESTAMP,
          IND_EXCLUIDO        CHAR(1)
      )';
end;

-- Verifica e adiciona a chave primária na tabela COND_PAGTO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_1')) then
    execute statement 'alter table COND_PAGTO add primary key (COD_COND_PAGTO)';
end;

-- Cria ou altera o trigger TR_COND_PAGTO para garantir que o código seja auto-incrementado
set term ^ ;
execute block as
begin
  execute statement '
    create or alter trigger TR_COND_PAGTO for COND_PAGTO
    active before insert position 0
    as
    begin
        new.COD_COND_PAGTO = gen_id(gen_cond_pagto_id, 1);
    end';
end^
set term ; ^

commit;

