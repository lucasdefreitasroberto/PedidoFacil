unit SQL.Pedido;

interface

function sqlListarPedidos: string;
function sqlListarItensPedido: string;

implementation

function sqlListarPedidos: string;
begin
  Result :=
  ' select first :FIRST skip :SKIP '+
  ' COD_PEDIDO, '+
  ' COD_CLIENTE, '+
  ' COD_USUARIO, '+
  ' TIPO_PEDIDO, '+
  ' DATA_PEDIDO, '+
  ' CONTATO, '+
  ' OBS, '+
  ' VALOR_TOTAL, '+
  ' COD_COND_PAGTO, '+
  ' PRAZO_ENTREGA, '+
  ' DATA_ENTREGA, '+
  ' COD_PEDIDO_LOCAL, '+
  ' DATA_ULT_ALTERACAO '+
  ' from PEDIDO '+
  ' where DATA_ULT_ALTERACAO > :DATA_ULT_ALTERACAO '+
  ' and COD_USUARIO = :COD_USUARIO '+
  ' order by COD_PEDIDO ';
end;

function sqlListarItensPedido: string;
begin
  Result:=
  ' select COD_ITEM, '+
  ' COD_PEDIDO, '+
  ' COD_PRODUTO, '+
  ' QTD, '+
  ' VALOR_UNITARIO, '+
  ' VALOR_TOTAL '+
  ' from PEDIDO_ITEM '+
  ' where COD_PEDIDO = :COD_PEDIDO '+
  ' order by COD_ITEM ';
end;

end.
