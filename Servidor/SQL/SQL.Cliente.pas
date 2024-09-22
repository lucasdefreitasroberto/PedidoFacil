unit SQL.Cliente;

interface

function sqlInsertOrUpdateCliente: string;
function sqlListarClientes: string;

implementation

function sqlListarClientes: string;
begin
  Result :=
   ' select first :first skip :skip '+
   '   COD_CLIENTE, COD_USUARIO, CNPJ_CPF, '+
   '   NOME, FONE, EMAIL, ENDERECO, NUMERO, COMPLEMENTO, '+
   '   BAIRRO, CIDADE, UF, CEP, LATITUDE, LONGITUDE, '+
   '   LIMITE_DISPONIVEL, DATA_ULT_ALTERACAO '+
   ' from CLIENTE '+
   ' where DATA_ULT_ALTERACAO > :DATA_ULT_ALTERACAO'+
   ' order by COD_CLIENTE';
end;

function sqlInsertOrUpdateCliente:string;
begin
  Result :=
  ' update or insert into CLIENTE( '+
  '   COD_CLIENTE, COD_USUARIO, CNPJ_CPF, NOME, '+
  '   FONE, EMAIL, ENDERECO, NUMERO, COMPLEMENTO, '+
  '   BAIRRO, CIDADE, UF, CEP, LATITUDE, LONGITUDE, '+
  '   LIMITE_DISPONIVEL, DATA_ULT_ALTERACAO) '+
  ' values( '+
  '   :COD_CLIENTE, :COD_USUARIO, :CNPJ_CPF, :NOME, '+
  '   :FONE, :EMAIL, :ENDERECO, :NUMERO, :COMPLEMENTO, '+
  '   :BAIRRO, :CIDADE, :UF, :CEP, :LATITUDE, :LONGITUDE, '+
  '   :LIMITE_DISPONIVEL, :DATA_ULT_ALTERACAO) '+
  ' matching (COD_CLIENTE) '+
  ' returning COD_CLIENTE ';
end;

end.
