unit SQL.Produto;

interface

function sqlListarProduto: string;
function sqlInserirProduto: string;
function sqlAtualizarProduto: string;
function sqlListarFotoProduto: string;
function sqlEditarFotoProduto: string;

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

function sqlInserirProduto: string;
begin
  Result :=
    ' insert into PRODUTO('+
    ' COD_PRODUTO, COD_USUARIO, DESCRICAO, VALOR, FOTO, QTD_ESTOQUE, DATA_ULT_ALTERACAO) '+
    ' values ('+
    ' :COD_PRODUTO, :COD_USUARIO, :DESCRICAO, :VALOR, :FOTO, :QTD_ESTOQUE, :DATA_ULT_ALTERACAO) '+
    ' returning COD_PRODUTO ';
end;

function sqlAtualizarProduto: string;
begin
  Result :=
    ' update PRODUTO '+
    ' set COD_USUARIO = :COD_USUARIO, '+
    ' DESCRICAO = :DESCRICAO, '+
    ' VALOR = :VALOR, '+
    ' FOTO = :FOTO, '+
    ' QTD_ESTOQUE = :QTD_ESTOQUE, '+
    ' DATA_ULT_ALTERACAO = :DATA_ULT_ALTERACAO '+
    ' where (COD_PRODUTO = :COD_PRODUTO) '+
    ' returning COD_PRODUTO ';
end;

function sqlListarFotoProduto: string;
begin
  Result :=
    ' select FOTO from PRODUTO ' +
    ' where COD_PRODUTO = :COD_PRODUTO ';
end;

function sqlEditarFotoProduto: string;
begin
  Result :=
    ' update PRODUTO '+
    ' set PRODUTO.FOTO = :FOTO_PRODUTO '+
    ' where PRODUTO.COD_PRODUTO = :COD_PRODUTO ';
end;

end.

