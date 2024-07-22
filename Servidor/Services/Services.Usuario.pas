unit Services.Usuario;

interface

uses
  system.JSON, DataSet.Serialize, Utilitarios, System.SysUtils, DM.Conexao;

type
  TServicesUsuario = class(TDMConexao)
  public
    function Login(email, senha: string): TJSONObject;
    function InserirUsuarios: string;
  end;

implementation

{ TServicesUsuario }

function TServicesUsuario.InserirUsuarios;
begin
  Result := '{"mensagem":  "Usuario Cadastro..."}';
end;

function TServicesUsuario.Login(email, senha: string): TJSONObject;
begin
  var
    SQL := ' select '+
           ' USU.COD_USUARIO, '+
           ' USU.NOME, '+
           ' USU.EMAIL '+
           ' from USUARIO USU '+
           ' where USU.EMAIL = '+QuotedStr(email)+' and '+
           ' USU.SENHA = '+QuotedStr(senha);

  var
    Query := TQueryExecutor.Create(con);

  try
    with Query.ExecuteReader(SQL) do
    begin
      Result := ToJSONObject;
    end;

  finally
    Query.Free;
  end;
end;
end.
