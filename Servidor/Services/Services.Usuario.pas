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
  Horse.HandleException,
  Horse.Commons,
  Controller.Auth,
  Horse,
  Interfaces.Conexao,
  Classe.Conexao;

type
  TServicesUsuario = class(TDMConexao)
  private
    const
    EmptyFieldError: string = 'Informe o campo %s.';
    function IsEmpty(Value: string): boolean;
    procedure RaiseEmptyFieldError(FieldName: string);

    procedure Verifica_Nome_Email_Senha_Vazio(Nome, Email, Senha: string);
    procedure Verifica_Senha_Vazio(Senha: string);
    procedure Verifica_Email_Senha_Vazio(Email, Senha: string);
    procedure Verifica_Nome_Email_Vazio(Nome, Email: string);
    procedure Verifica_TokenPush_Vazio(TokenPush: string);
    procedure Verifica_Existencia_Email(Email: string);
    procedure Verifica_Tamanho_Senha(Senha: string);

  public
    function SLogin(const AUsuario: TJSONObject): TJSONObject;
    function SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
    function SPush(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
    function SEditarUsuario(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
    function SEditarSenha(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
    function SObterDataHoraServidor: String;
  end;

implementation

{ TServicesUsuario }

{$REGION ' InserirUsuarios '}
function TServicesUsuario.SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
begin
  var LNome :=  AUsuario.GetValue<string>('nome', '');
  var LEmail := AUsuario.GetValue<string>('email', '');
  var LSenha := AUsuario.GetValue<string>('senha', '');

  Self.Verifica_Nome_Email_Senha_Vazio(LNome, LEmail, LSenha);
  Self.Verifica_Existencia_Email(LEmail);
  Self.Verifica_Tamanho_Senha(LSenha);

  var
    LSQL := ' insert into USUARIO '+
            ' (NOME, EMAIL, SENHA)'+
            ' values '+
            ' (:NOME, :EMAIL, :SENHA)'+
            ' returning COD_USUARIO, NOME, EMAIL';
  var
    FQuery := TQueryFD.Create;
  try
    Result := FQuery
               .SQL(LSQL)
               .Params('NOME', LNome)
               .Params('SENHA', LSenha)
               .Params('EMAIL', LEmail)
               .Open
               .ToJSONObject;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

{$REGION ' Login '}
function TServicesUsuario.SLogin(const AUsuario: TJSONObject): TJSONObject;
begin
  var LEmail := AUsuario.GetValue<string>('email', '');
  var LSenha := AUsuario.GetValue<string>('senha', '');

  Self.Verifica_Email_Senha_Vazio(LEmail, LSenha);

  var
    LSQL := ' select '+
            ' USU.COD_USUARIO, '+
            ' USU.NOME, '+
            ' USU.EMAIL '+
            ' from USUARIO USU '+
            ' where USU.EMAIL = '+QuotedStr(LEmail.ToLower)+' and '+
            ' USU.SENHA = '+QuotedStr(SaltPassword(LSenha));
  var
    FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(LSQL)
                .Open
                .ToJSONObject;
  finally
    FQuery.Free;
  end;
end;

{$ENDREGION}

{$REGION ' Push '}
function TServicesUsuario.SPush(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
begin
  var LTokenPush := AUsuario.GetValue<string>('token_push', '');
  var LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  Self.Verifica_TokenPush_Vazio(LTokenPush);

  var
    LSQL := ' update USUARIO USU ' +
            ' set TOKEN_PUSH = :TOKEN_PUSH ' +
            ' where (USU.COD_USUARIO = :COD_USUARIO) ' +
            ' returning USU.COD_USUARIO ';

  var
    FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(LSQL)
                .Params('TOKEN_PUSH', LTokenPush)
                .Params('COD_USUARIO,', LCodigoUsuario)
                .Open
                .ToJSONObject;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

{$REGION ' EditarUsuario '}
function TServicesUsuario.SEditarUsuario(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
begin
  var LNome := AUsuario.GetValue<string>('nome', '');
  var LEmail := AUsuario.GetValue<string>('email', '');
  var LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  Self.Verifica_Nome_Email_Vazio(LNome, LEmail);
  Self.Verifica_Existencia_Email(LEmail);

  var
    LSQL := ' update USUARIO '+
            ' set NOME = :NOME, '+
            ' EMAIL = :EMAIL '+
            ' where (COD_USUARIO = :COD_USUARIO) '+
            ' returning COD_USUARIO, NOME, EMAIL ';

  var
    FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(LSQL)
                .Params('NOME', LNome)
                .Params('EMAIL', LEmail)
                .Params('COD_USUARIO', LCodigoUsuario)
                .Open
                .ToJSONObject
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

{$REGION ' EditarSenha '}
function TServicesUsuario.SEditarSenha(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
begin
  var  LSenha := AUsuario.GetValue<string>('senha', '');
  var  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  Self.Verifica_Senha_Vazio(LSenha);
  Self.Verifica_Tamanho_Senha(LSenha);

  var
    LSQL := ' update USUARIO '+
            ' set SENHA = :SENHA '+
            ' where (COD_USUARIO = :COD_USUARIO) '+
            ' returning COD_USUARIO ';

  var
    FQuery := TQueryFD.Create;
  try
     Result := FQuery
                .SQL(LSQL)
                .Params('SENHA', SaltPassword(LSenha))
                .Params('COD_USUARIO', LCodigoUsuario)
                .Open
                .ToJSONObject;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

{$REGION ' SObterDataServidor '}
function TServicesUsuario.SObterDataHoraServidor: String;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
end;
{$ENDREGION}

{$REGION ' Validacoes '}

function TServicesUsuario.IsEmpty(Value: string): boolean;
begin
  Result := (Value.Trim = EmptyStr);
end;

procedure TServicesUsuario.RaiseEmptyFieldError(FieldName: string);
begin
  raise EHorseException.New.Error(Format(EmptyFieldError, [FieldName]))
    .Status(THTTPStatus.BadRequest);
end;

procedure TServicesUsuario.Verifica_Existencia_Email(Email: string);
begin
  var LSQL := 'SELECT COUNT(*) AS EmailCount ' +
              'FROM USUARIO ' +
              'WHERE EMAIL = '+QuotedStr(Email);

  var Query := TQueryExecutor.Create(con);
  try
    var LCount := Query.ExecuteScalar(LSQL);

    if (LCount > 0) then
     raise EHorseException.New.Error('Esse e-mail já está em uso por outra conta');
  finally
    Query.Free;
  end;
end;

procedure TServicesUsuario.Verifica_Email_Senha_Vazio(Email, Senha: string);
begin
  if IsEmpty(Email) or IsEmpty(Senha) then
    RaiseEmptyFieldError('Email e/ou Senha');
end;

procedure TServicesUsuario.Verifica_Nome_Email_Vazio(Nome, Email: string);
begin
  if IsEmpty(Nome) or IsEmpty(Email) then
    RaiseEmptyFieldError('Nome e/ou Email');
end;

procedure TServicesUsuario.Verifica_Nome_Email_Senha_Vazio(Nome, Email, Senha: string);
begin
  if (Nome = EmptyStr) or (Email.Trim = EmptyStr) or (Senha = EmptyStr) then
    raise EHorseException.New.Error('Informe o nome, e-mail e a senha');
end;

procedure TServicesUsuario.Verifica_Senha_Vazio(Senha: string);
begin
  if IsEmpty(Senha) then
    RaiseEmptyFieldError('Senha');
end;

procedure TServicesUsuario.Verifica_Tamanho_Senha(Senha: string);
begin
  if Senha.Length < 5 then
    raise EHorseException.New.Error('A senha deve ter no mínimo 5 caracteres').Status(THTTPStatus.BadRequest);
end;

procedure TServicesUsuario.Verifica_TokenPush_Vazio(TokenPush: string);
begin
  if IsEmpty(TokenPush) then
    RaiseEmptyFieldError('Token Push');
end;

{$ENDREGION}

end.
