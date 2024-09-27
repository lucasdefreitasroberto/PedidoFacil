unit SQL.Usuario;

interface

function sqlLogin: string;
function sqlInserirUsuario: string;
function sqlValidarEmail: string;
function sqlUpdateTokenPush: string;

implementation

function sqlLogin: string;
begin
  Result :=
     ' select USU.COD_USUARIO, USU.NOME, '+
     ' USU.EMAIL from USUARIO USU '+
     ' where USU.EMAIL = :EMAIL and '+
     ' USU.SENHA = :SENHA';
end;

function sqlInserirUsuario: string;
begin
  Result :=
    ' insert into USUARIO ' +
    ' (NOME, EMAIL, SENHA)' +
    ' values (:NOME, :EMAIL, :SENHA)' +
    ' returning COD_USUARIO, NOME, EMAIL';
end;

function sqlValidarEmail: string;
begin
  Result :=
    ' select count(*) AS EmailCount ' +
    ' from USUARIO ' +
    ' where EMAIL = :EMAIL';
end;

function sqlUpdateTokenPush: string;
begin
  Result :=
    ' update USUARIO ' +
    ' set TOKEN_PUSH = :TOKEN_PUSH ' +
    ' where (COD_USUARIO = :COD_USUARIO) ' +
    ' returning COD_USUARIO ';
end;

end.
