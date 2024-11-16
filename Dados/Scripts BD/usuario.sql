-- Verifica e cria o gerador GEN_USUARIO_ID se ele não existir
execute block as
begin
  if (not exists(select 1 from rdb$generators where rdb$generator_name = 'GEN_USUARIO_ID')) then
    execute statement 'create generator GEN_USUARIO_ID';
end;

-- Verifica e cria a tabela USUARIO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relations where rdb$relation_name = 'USUARIO')) then
    execute statement '
      create table USUARIO (
          COD_USUARIO   INTEGER NOT NULL,
          NOME          VARCHAR(100),
          EMAIL         VARCHAR(100),
          SENHA         VARCHAR(50),
          TOKEN_PUSH    VARCHAR(200),
          PLATAFORMA    VARCHAR(50),
          IND_EXCLUIDO  CHAR(1)
      )';
end;

-- Verifica e adiciona a chave primária na tabela USUARIO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_1')) then
    execute statement 'alter table USUARIO add primary key (COD_USUARIO)';
end;

-- Cria ou altera o trigger TR_USUARIO para garantir o incremento automático de COD_USUARIO
set term ^ ;
execute block as
begin
  execute statement '
    create or alter trigger TR_USUARIO for USUARIO
    active before insert position 0
    as
    begin
        new.COD_USUARIO = gen_id(gen_usuario_id, 1);
    end';
end^
set term ; ^

commit;

