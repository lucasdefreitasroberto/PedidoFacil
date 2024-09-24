unit SQL.Usuario;

interface

function sqlLogin: string;

implementation

function sqlLogin: string;
begin
  Result :=
     ' select USU.COD_USUARIO, USU.NOME, '+
     ' USU.EMAIL from USUARIO USU '+
     ' where USU.EMAIL = :EMAIL and '+
     ' USU.SENHA = :SENHA';
end;

end.
