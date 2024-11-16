-- Verifica e cria o gerador GEN_PEDIDO_ITEM_ID se ele não existir
execute block as
begin
  if (not exists(select 1 from rdb$generators where rdb$generator_name = 'GEN_PEDIDO_ITEM_ID')) then
    execute statement 'create generator GEN_PEDIDO_ITEM_ID';
end;

-- Verifica e cria a tabela PEDIDO_ITEM se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relations where rdb$relation_name = 'PEDIDO_ITEM')) then
    execute statement '
      create table PEDIDO_ITEM (
          COD_ITEM        INTEGER NOT NULL,
          COD_PEDIDO      INTEGER NOT NULL,
          COD_PRODUTO     INTEGER,
          QTD             INTEGER,
          VALOR_UNITARIO  DECIMAL(12,2),
          VALOR_TOTAL     DECIMAL(12,2)
      )';
end;

-- Verifica e adiciona a chave primária na tabela PEDIDO_ITEM se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_1')) then
    execute statement 'alter table PEDIDO_ITEM add primary key (COD_ITEM)';
end;

-- Verifica e adiciona a chave estrangeira para COD_PEDIDO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_2')) then
    execute statement 'alter table PEDIDO_ITEM add foreign key (COD_PEDIDO) references PEDIDO (COD_PEDIDO)';
end;

-- Verifica e adiciona a chave estrangeira para COD_PRODUTO se ela não existir
execute block as
begin
  if (not exists(select 1 from rdb$relation_constraints where rdb$constraint_name = 'INTEG_3')) then
    execute statement 'alter table PEDIDO_ITEM add foreign key (COD_PRODUTO) references PRODUTO (COD_PRODUTO)';
end;

-- Cria ou altera o trigger TR_PEDIDO_ITEM para garantir o incremento automático de COD_ITEM
set term ^ ;
execute block as
begin
  execute statement '
    create or alter trigger TR_PEDIDO_ITEM for PEDIDO_ITEM
    active before insert position 0
    as
    begin
        new.COD_ITEM = gen_id(gen_pedido_item_id, 1);
    end';
end^
set term ; ^

commit;

