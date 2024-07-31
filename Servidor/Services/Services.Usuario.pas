unit Services.Usuario;

interface

uses
  system.JSON, DataSet.Serialize, Utilitarios, System.SysUtils, DM.Conexao,
  Data.DB, FireDAC.Comp.Client, HashXMD5;

type
  TServicesUsuario = class(TDMConexao)
  public
    function SLogin(Email, Senha: string): TJSONObject;
    function SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
    function SPush(CodUsuario: Integer; TokenPush: string): TJSONObject;
  end;

implementation

{ TServicesUsuario }

{$REGION ' InserirUsuarios '}
function TServicesUsuario.SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
var
  LNome, LEmail, LSenha: string;
  Body: TJSONObject;
begin
  LNome :=  AUsuario.GetValue<string>('nome', '');
  LEmail := AUsuario.GetValue<string>('email', '');
  LSenha := AUsuario.GetValue<string>('senha', '');

  var
    LSQL := ' insert into USUARIO '+
            ' (NOME, EMAIL, SENHA)'+
            ' values '+
            ' (:NOME, :EMAIL, :SENHA)'+
            ' returning COD_USUARIO, NOME, EMAIL';

  var
    Query := TFDQuery.Create(nil);
    Query.Connection := con;
  try
     with Query do
     begin
       Active := False;
       SQL.Append(LSQL);

       ParamByName('NOME').Value := LNome;
       ParamByName('EMAIL').Value := LEmail.ToLower;
       ParamByName('SENHA').Value := SaltPassword(LSenha);

       Active := True;
     end;

     Result := Query.ToJSONObject;
  finally
    Query.Free;
  end;

end;
{$ENDREGION}

{$REGION ' Login '}
function TServicesUsuario.SLogin(Email, Senha: string): TJSONObject;
begin
  var
    LSQL := ' select '+
            ' USU.COD_USUARIO, '+
            ' USU.NOME, '+
            ' USU.EMAIL '+
            ' from USUARIO USU '+
            ' where USU.EMAIL = '+QuotedStr(Email)+' and '+
            ' USU.SENHA = '+QuotedStr(SaltPassword(Senha));
  var
    Query := TQueryExecutor.Create(con);
  try
    with Query.ExecuteReader(LSQL) do
    begin
      Result := ToJSONObject;
    end;

  finally
    Query.Free;
  end;
end;
{$ENDREGION}

{$REGION ' Push '}

function TServicesUsuario.SPush(CodUsuario: Integer; TokenPush: string): TJSONObject;
begin

  if (TokenPush = '') then
    raise Exception.Create('Informe o token push do usuário');

  var
    LSQL := ' update USUARIO USU ' +
            ' set TOKEN_PUSH = :TOKEN_PUSH ' +
            ' where (USU.COD_USUARIO = :COD_USUARIO) ' +
            ' returning USU.COD_USUARIO ';

  var
    Query := TFDQuery.Create(nil);
    Query.Connection := con;
  try
     with Query do
     begin
       Active := False;
       SQL.Append(LSQL);

       ParamByName('TOKEN_PUSH').Value := TokenPush;
       ParamByName('COD_USUARIO').Value := CodUsuario;

       Active := True;
     end;

     Result := Query.ToJSONObject;
  finally
    Query.Free;
  end;
end;
{$ENDREGION}
end.
