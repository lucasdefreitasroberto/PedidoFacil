unit Services.Usuario;

interface

uses
  system.JSON,
  DataSet.Serialize,
  Utilitarios,
  System.SysUtils,
  DM.Conexao,
  Data.DB,
  FireDAC.Comp.Client,
  HashXMD5,
  Horse.Exception,
  Horse.HandleException;

type
  TServicesUsuario = class(TDMConexao)
  public
    function SLogin(Email, Senha: string): TJSONObject;
    function SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
    function SPush(CodUsuario: Integer; TokenPush: string): TJSONObject;
    function SEditarUsuario(CodUser : Integer; Nome, Email : string): TJSONObject;
    function SEditarSenha(CodUser : Integer; Senha : string): TJSONObject;
    function VerifyEmailExistence(Email : string): Boolean;
  end;

implementation

{ TServicesUsuario }

{$REGION ' InserirUsuarios '}
function TServicesUsuario.SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
var
  LNome, LEmail, LSenha: string;
begin
  LNome :=  AUsuario.GetValue<string>('nome', '');
  LEmail := AUsuario.GetValue<string>('email', '');
  LSenha := AUsuario.GetValue<string>('senha', '');

  if (LNome = '') or (LEmail.Trim = '') or (LSenha = '') then
    raise EHorseException.New.Error('Informe o nome, e-mail e a senha');

  if VerifyEmailExistence(LEmail.Trim) then
    raise EHorseException.New.Error('Esse e-mail já está em uso por outra conta');

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

{$REGION ' EditarUsuario '}
function TServicesUsuario.SEditarUsuario(CodUser : Integer; Nome, Email : string): TJSONObject;
begin

  var
    LSQL := ' update USUARIO '+
            ' set NOME = :NOME, '+
            ' EMAIL = :EMAIL '+
            ' where (COD_USUARIO = :COD_USUARIO) '+
            ' returning COD_USUARIO, NOME, EMAIL ';

  var
    Query := TFDQuery.Create(nil);
    Query.Connection := con;
  try
     with Query do
     begin
       Active := False;
       SQL.Append(LSQL);

       ParamByName('NOME').Value := Nome;
       ParamByName('EMAIL').Value := Email.ToLower;
       ParamByName('COD_USUARIO').Value :=  CodUser;

       Active := True;
     end;

     Result := Query.ToJSONObject;
  finally
    Query.Free;
  end;
end;
{$ENDREGION}

{$REGION ' EditarUsuario '}
function TServicesUsuario.SEditarSenha(CodUser : Integer; Senha : string): TJSONObject;
begin

  var
    LSQL := ' update USUARIO '+
            ' set SENHA = :SENHA '+
            ' where (COD_USUARIO = :COD_USUARIO) '+
            ' returning COD_USUARIO ';

  var
    Query := TFDQuery.Create(nil);
    Query.Connection := con;
  try
     with Query do
     begin
       Active := False;
       SQL.Append(LSQL);

       ParamByName('SENHA').Value := SaltPassword(Senha);
       ParamByName('COD_USUARIO').Value := CodUser;

       Active := True;
     end;

     Result := Query.ToJSONObject;
  finally
    Query.Free;
  end;

end;
{$ENDREGION}

{$REGION ' VerifyEmailExistence '}
function TServicesUsuario.VerifyEmailExistence(Email: string): Boolean;
var
  LSQL: string;
  Query: TFDQuery;
begin
  Result := False;
  LSQL := 'SELECT COUNT(*) AS EmailCount ' +
          'FROM USUARIO ' +
          'WHERE EMAIL = :EMAIL';
  Query := TFDQuery.Create(nil);
  Query.Connection := con;
  try
    with Query do
    begin
      SQL.Append(LSQL);
      ParamByName('EMAIL').AsString := QuotedStr(Email);
    end;

    Query.Open;
    if not Query.IsEmpty then
      Result := True;
  finally
    Query.Free;
  end;
end;
{$ENDREGION}

end.

