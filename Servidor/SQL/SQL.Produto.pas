unit SQL.Produto;

interface

function sqlListarProduto: string;

implementation

function sqlListarProduto: string;
begin
  Result :=
   ' select first :FIRST skip :SKIP'+
   ' COD_PRODUTO, DESCRICAO, VALOR, FOTO,'+
   ' QTD_ESTOQUE, COD_USUARIO, DATA_ULT_ALTERACAO'+
   ' from PRODUTO'+
   ' where DATA_ULT_ALTERACAO > :DATA_ULT_ALTERACAO'+
   ' order by COD_PRODUTO';
end;

end.
