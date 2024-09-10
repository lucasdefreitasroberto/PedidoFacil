unit SQL.Pedido;

interface

function sqlListarPedidos: string;
function sqlListarItensPedido: string;
function sqlInserirPedido: string;
function sqlUpdatePedido: string;

implementation

{$REGION ' sqlListarPedidos '}
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
{$ENDREGION}

{$REGION ' sqlListarItensPedido '}
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
{$ENDREGION}

{$REGION ' sqlInserirPedido '}
function sqlInserirPedido: string;
begin
  Result :=
  ' insert into PEDIDO (COD_PEDIDO, COD_CLIENTE, COD_USUARIO, TIPO_PEDIDO, DATA_PEDIDO, CONTATO, OBS, VALOR_TOTAL, '+
  ' COD_COND_PAGTO, PRAZO_ENTREGA, DATA_ENTREGA, COD_PEDIDO_LOCAL, DATA_ULT_ALTERACAO) '+
  ' values (:COD_PEDIDO, :COD_CLIENTE, :COD_USUARIO, :TIPO_PEDIDO, :DATA_PEDIDO, :CONTATO, :OBS, :VALOR_TOTAL, '+
  ' :COD_COND_PAGTO, :PRAZO_ENTREGA, :DATA_ENTREGA, :COD_PEDIDO_LOCAL, :DATA_ULT_ALTERACAO) '+
  ' returning COD_PEDIDO ';
end;
{$ENDREGION}

{$REGION ' sqlUpdatePedido '}
function sqlUpdatePedido: string;
begin
  Result :=
  ' update PEDIDO '+
  ' set COD_CLIENTE = :COD_CLIENTE, '+
  ' COD_USUARIO = :COD_USUARIO, '+
  ' TIPO_PEDIDO = :TIPO_PEDIDO, '+
  ' DATA_PEDIDO = :DATA_PEDIDO, '+
  ' CONTATO = :CONTATO, '+
  ' OBS = :OBS, '+
  ' VALOR_TOTAL = :VALOR_TOTAL, '+
  ' COD_COND_PAGTO = :COD_COND_PAGTO, '+
  ' PRAZO_ENTREGA = :PRAZO_ENTREGA, '+
  ' DATA_ENTREGA = :DATA_ENTREGA, '+
  ' COD_PEDIDO_LOCAL = :COD_PEDIDO_LOCAL, '+
  ' DATA_ULT_ALTERACAO = :DATA_ULT_ALTERACAO '+
  ' where (COD_PEDIDO = :COD_PEDIDO) '+
  '  returning COD_PEDIDO ';
end;
{$ENDREGION}

end.
