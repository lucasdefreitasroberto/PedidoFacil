-- Verifica e cria o gerador GEN_PEDIDO_ID se ele não existir
execute block as
begin
  if (not exists(select 1 from rdb$generators where rdb$generator_name = 'GEN_PEDIDO_ID')) then
    execute statement 'create generator GEN_PEDIDO_ID';
end;

-- Verifica e cria a tabela PEDIDO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relations where rdb$relation_name = 'PEDIDO')) then
    execute statement '
      create table PEDIDO (
          COD_PEDIDO          INTEGER NOT NULL,
          COD_CLIENTE         INTEGER,
          COD_USUARIO         INTEGER,
          TIPO_PEDIDO         CHAR(1),
          DATA_PEDIDO         TIMESTAMP,
          CONTATO             VARCHAR(100),
          OBS                 VARCHAR(500),
          VALOR_TOTAL         DECIMAL(12,2),
          COD_COND_PAGTO      INTEGER,
          PRAZO_ENTREGA       VARCHAR(50),
          DATA_ENTREGA        TIMESTAMP,
          COD_PEDIDO_LOCAL    INTEGER,
          DATA_ULT_ALTERACAO  TIMESTAMP
      )';
end;

-- Verifica e adiciona a chave primária na tabela PEDIDO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_1')) then
    execute statement 'alter table PEDIDO add primary key (COD_PEDIDO)';
end;

-- Verifica e adiciona a chave estrangeira para COD_USUARIO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_2')) then
    execute statement 'alter table PEDIDO add foreign key (COD_USUARIO) references USUARIO (COD_USUARIO)';
end;

-- Verifica e adiciona a chave estrangeira para COD_CLIENTE se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_3')) then
    execute statement 'alter table PEDIDO add foreign key (COD_CLIENTE) references CLIENTE (COD_CLIENTE)';
end;

-- Verifica e adiciona a chave estrangeira para COD_COND_PAGTO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_4')) then
    execute statement 'alter table PEDIDO add foreign key (COD_COND_PAGTO) references COND_PAGTO (COD_COND_PAGTO)';
end;

-- Cria ou altera o trigger TR_PEDIDO para garantir o incremento automático de COD_PEDIDO
set term ^ ;
execute block as
begin
  execute statement '
    create or alter trigger TR_PEDIDO for PEDIDO
    active before insert position 0
    as
    begin
        new.COD_PEDIDO = gen_id(gen_pedido_id, 1);
    end';
end^
set term ; ^

commit;

