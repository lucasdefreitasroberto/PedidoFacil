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
  Horse.HandleException, Horse.Commons, Controller.Auth, Horse;

type
  TServicesUsuario = class(TDMConexao)
  public
    function SLogin(const AUsuario: TJSONObject): TJSONObject;
    function SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
    function SPush(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
    function SEditarUsuario(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
    function SEditarSenha(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
    function VerifyEmailExistence(Email : string): Boolean;
  end;

implementation

{ TServicesUsuario }

{$REGION ' InserirUsuarios '}
function TServicesUsuario.SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
begin
  var LNome :=  AUsuario.GetValue<string>('nome', '');
  var LEmail := AUsuario.GetValue<string>('email', '');
  var LSenha := AUsuario.GetValue<string>('senha', '');

  if (LNome = EmptyStr) or (LEmail.Trim = EmptyStr) or (LSenha = EmptyStr) then
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
function TServicesUsuario.SLogin(const AUsuario: TJSONObject): TJSONObject;
begin
  var LEmail := AUsuario.GetValue<string>('email', '');
  var LSenha := AUsuario.GetValue<string>('senha', '');

  if (LEmail.IsEmpty) or (LSenha.IsEmpty) then
    raise EHorseException.New.Error('Informe o e-mail e a senha').Status(THTTPStatus.Unauthorized);

  var
    LSQL := ' select '+
            ' USU.COD_USUARIO, '+
            ' USU.NOME, '+
            ' USU.EMAIL '+
            ' from USUARIO USU '+
            ' where USU.EMAIL = '+QuotedStr(LEmail.ToLower)+' and '+
            ' USU.SENHA = '+QuotedStr(SaltPassword(LSenha));
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
function TServicesUsuario.SPush(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
begin
  var LTokenPush := AUsuario.GetValue<string>('token_push', '');
  var LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  if LTokenPush.IsEmpty then
    raise EHorseException.New.Error('Informe o token push do usuário');

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

       ParamByName('TOKEN_PUSH').Value := LTokenPush;
       ParamByName('COD_USUARIO').Value := LCodigoUsuario;

       Active := True;
     end;

     Result := Query.ToJSONObject;
  finally
    Query.Free;
  end;
end;
{$ENDREGION}

{$REGION ' EditarUsuario '}
function TServicesUsuario.SEditarUsuario(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
begin
  var LEmail := AUsuario.GetValue<string>('email', '');
  var LNome := AUsuario.GetValue<string>('nome', '');
  var LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

 if LNome.IsEmpty or LEmail.IsEmpty then
    raise EHorseException.New.Error('Informe o nome e o e-mail do usuário');

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
       ParamByName('NOME').Value := LNome;
       ParamByName('EMAIL').Value := LEmail.ToLower;
       ParamByName('COD_USUARIO').Value :=  LCodigoUsuario;
       Active := True;
     end;

     Result := Query.ToJSONObject;
  finally
    Query.Free;
  end;
end;
{$ENDREGION}

{$REGION ' EditarUsuario '}
function TServicesUsuario.SEditarSenha(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
begin
  var  LSenha := AUsuario.GetValue<string>('senha', '');
  var  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  if (LSenha = '') then
    raise EHorseException.New.Error('Informe a senha do usuário');

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

       ParamByName('SENHA').Value := SaltPassword(LSenha);
       ParamByName('COD_USUARIO').Value := LCodigoUsuario;

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
begin
  var LSQL := 'SELECT COUNT(*) AS EmailCount ' +
              'FROM USUARIO ' +
              'WHERE EMAIL = '+QuotedStr(Email);

  var Query := TQueryExecutor.Create(con);
  try
    var LCount := Query.ExecuteScalar(LSQL);

    if LCount > 0 then
      Result := True;
  finally
    Query.Free;
  end;
end;
{$ENDREGION}

end.

