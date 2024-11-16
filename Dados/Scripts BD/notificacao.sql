-- Verifica e cria o gerador GEN_NOTIFICACAO_ID se ele não existir
execute block as
begin
  if (not exists(select 1 from rdb$generators where rdb$generator_name = 'GEN_NOTIFICACAO_ID')) then
    execute statement 'create generator GEN_NOTIFICACAO_ID';
end;

-- Verifica e cria a tabela NOTIFICACAO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relations where rdb$relation_name = 'NOTIFICACAO')) then
    execute statement '
      create table NOTIFICACAO (
          COD_NOTIFICACAO   INTEGER NOT NULL,
          COD_USUARIO       INTEGER,
          DATA_NOTIFICACAO  TIMESTAMP,
          TITULO            VARCHAR(100),
          TEXTO             VARCHAR(500),
          IND_LIDO          CHAR(1)
      )';
end;

-- Verifica e adiciona a chave primária na tabela NOTIFICACAO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_1')) then
    execute statement 'alter table NOTIFICACAO add primary key (COD_NOTIFICACAO)';
end;

-- Verifica e adiciona a chave estrangeira para COD_USUARIO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_2')) then
    execute statement 'alter table NOTIFICACAO add foreign key (COD_USUARIO) references USUARIO (COD_USUARIO)';
end;

-- Cria ou altera o trigger TR_NOTIFICACAO para garantir o incremento automático de COD_NOTIFICACAO
set term ^ ;
execute block as
begin
  execute statement '
    create or alter trigger TR_NOTIFICACAO for NOTIFICACAO
    active before insert position 0
    as
    begin
        new.COD_NOTIFICACAO = gen_id(gen_notificacao_id, 1);
    end';
end^
set term ; ^

commit;

