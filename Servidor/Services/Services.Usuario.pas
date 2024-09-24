unit Services.Usuario;

interface

uses
  system.JSON,
  DataSet.Serialize,
  Utilitarios,
  system.SysUtils,
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
  Classe.Conexao,
  Validations.Usuario,
  Repository.Interfaces.IUsuarioRepository,
  Repository.Classes.UsuarioRepository;

type
  IServicesUsuario = interface
    ['{C7B44EBF-9C25-47D0-B102-9A065A80CD78}']
    function SLoginUsuario(Req: THorseRequest): TJSONObject;
  end;

type
  TServicesUsuario = class(TInterfacedObject, IServicesUsuario)
  private
    FUsuarioRepository: IUsuarioRepository;
  public
    constructor Create;
    destructor Destroy;

    function SLoginUsuario(Req: THorseRequest): TJSONObject;
    function SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
    function SPush(const AUsuario: TJSONObject; Req: THorseRequest)
      : TJSONObject;
    function SEditarUsuario(const AUsuario: TJSONObject; Req: THorseRequest)
      : TJSONObject;
    function SEditarSenhaUsuario(const AUsuario: TJSONObject;
      Req: THorseRequest): TJSONObject;
    function SObterDataHoraServidor: String;
    class function New: IServicesUsuario;
  end;

implementation

{ TServicesUsuario }

constructor TServicesUsuario.Create;
begin
  FUsuarioRepository := TUsuarioRepository.Create;
end;

destructor TServicesUsuario.Destroy;
begin
  FUsuarioRepository := nil;
end;

class function TServicesUsuario.New: IServicesUsuario;
begin
  Result := Self.Create;
end;

{$REGION ' InserirUsuarios '}

function TServicesUsuario.SInserirUsuarios(const AUsuario: TJSONObject)
  : TJSONObject;
begin
  var
  LNome := AUsuario.GetValue<string>('nome', '');
  var
  LEmail := AUsuario.GetValue<string>('email', '');
  var
  LSenha := AUsuario.GetValue<string>('senha', '');

  var
  LNomeEmailSenhaVaziaValidation := TNomeEmailSenhaVaziaValidation.Create(LNome,
    LEmail, LSenha);
  var
  LEmailExistenteValidation := TEmailExistenteValidation.Create(LEmail);
  var
  LSenhaTamanhoValidation := TSenhaTamanhoValidation.Create(LSenha);

  try
    LNomeEmailSenhaVaziaValidation.Validate;
    LEmailExistenteValidation.Validate;
    LSenhaTamanhoValidation.Validate;
  finally
    LNomeEmailSenhaVaziaValidation.Free;
    LEmailExistenteValidation.Free;
    LSenhaTamanhoValidation.Free;
  end;

  var
  LSQL := ' insert into USUARIO ' + ' (NOME, EMAIL, SENHA)' + ' values ' +
    ' (:NOME, :EMAIL, :SENHA)' + ' returning COD_USUARIO, NOME, EMAIL';

  var
  FQuery := TQueryFD.Create;
  try
    Result := FQuery.SQL(LSQL).Params('NOME', LNome)
      .Params('SENHA', SaltPassword(LSenha)).Params('EMAIL', LEmail)
      .Open.ToJSONObject;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

{$REGION ' Login '}

function TServicesUsuario.SLoginUsuario(Req: THorseRequest): TJSONObject;
var
  LJsonRetorno: TJSONObject;
begin
  var
  LEmail :=
    Req.Body<TJSONObject>.GetValue<string>('email', '');
  var
  LSenha :=
    Req.Body<TJSONObject>.GetValue<string>('senha', '');

  TLoginVerifyValidation.New(LEmail, LSenha).Validate;

  LJsonRetorno :=
    FUsuarioRepository.RLoginUsuario(LEmail, LSenha);

  if LJsonRetorno.Size = 0 then
    EHorseException.New.Error('E-mail ou Senha inválida.').Status(THTTPStatus.Unauthorized)
  else
  begin
    var
    LCodigoUser := LJsonRetorno.GetValue<Integer>('cod_usuario', 0);
    var
    LTokenResult := Criar_Token(LCodigoUser);
    LJsonRetorno.AddPair('token', LTokenResult.Token);
    LJsonRetorno.AddPair('exp',
      TJSONString.Create(FormatDateTime('dd-mm-yyyy hh:nn:ss',
      LTokenResult.Expiration)));

    Result := LJsonRetorno;
  end;
end;

{$ENDREGION}

{$REGION ' Push '}

function TServicesUsuario.SPush(const AUsuario: TJSONObject; Req: THorseRequest)
  : TJSONObject;
begin
  var
  LTokenPush := AUsuario.GetValue<string>('token_push', '');
  var
  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  var
  LTokenPushVazioValidation := TTokenPushVazioValidation.Create(LTokenPush);

  try
    LTokenPushVazioValidation.Validate;
  finally
    LTokenPushVazioValidation.Free;
  end;

  var
  LSQL := ' update USUARIO ' + ' set TOKEN_PUSH = :TOKEN_PUSH ' +
    ' where (COD_USUARIO = :COD_USUARIO) ' + ' returning COD_USUARIO ';

  var
  FQuery := TQueryFD.Create;
  try
    Result := FQuery.SQL(LSQL).Params('TOKEN_PUSH', LTokenPush)
      .Params('COD_USUARIO', LCodigoUsuario).Open.ToJSONObject;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}
{$REGION ' EditarUsuario '}

function TServicesUsuario.SEditarUsuario(const AUsuario: TJSONObject;
  Req: THorseRequest): TJSONObject;
begin
  var
  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);
  var
  LNome := AUsuario.GetValue<string>('nome', '');
  var
  LEmail := AUsuario.GetValue<string>('email', '');

  var
  LNomeEmailVaziaValidation := TNomeEmailVaziaValidation.Create(LNome, LEmail);
  var
  LEmailExistenteValidation := TEmailExistenteValidation.Create(LEmail);

  try
    LNomeEmailVaziaValidation.Validate;
    LEmailExistenteValidation.Validate;
  finally
    LNomeEmailVaziaValidation.Free;
    LEmailExistenteValidation.Free;
  end;

  var
  LSQL := ' update USUARIO ' + ' set NOME = :NOME, ' + ' EMAIL = :EMAIL ' +
    ' where (COD_USUARIO = :COD_USUARIO) ' +
    ' returning COD_USUARIO, NOME, EMAIL ';

  var
  FQuery := TQueryFD.Create;
  try
    Result := FQuery.SQL(LSQL).Params('NOME', LNome).Params('EMAIL', LEmail)
      .Params('COD_USUARIO', LCodigoUsuario).Open.ToJSONObject
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}
{$REGION ' EditarSenha '}

function TServicesUsuario.SEditarSenhaUsuario(const AUsuario: TJSONObject;
  Req: THorseRequest): TJSONObject;
begin
  var
  LSenha := AUsuario.GetValue<string>('senha', '');
  var
  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  var
  LSenhaVaziaValidation := TSenhaVaziaValidation.Create(LSenha);
  var
  LSenhaTamanhoValidation := TSenhaTamanhoValidation.Create(LSenha);

  try
    LSenhaVaziaValidation.Validate;
    LSenhaTamanhoValidation.Validate;
  finally
    LSenhaVaziaValidation.Free;
    LSenhaTamanhoValidation.Free;
  end;

  var
  LSQL := ' update USUARIO ' + ' set SENHA = :SENHA ' +
    ' where (COD_USUARIO = :COD_USUARIO) ' + ' returning COD_USUARIO ';

  var
  FQuery := TQueryFD.Create;
  try
    Result := FQuery.SQL(LSQL).Params('SENHA', SaltPassword(LSenha))
      .Params('COD_USUARIO', LCodigoUsuario).Open.ToJSONObject;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}
{$REGION ' SObterDataServidor '}

function TServicesUsuario.SObterDataHoraServidor: String;
begin
  Result := FormatDateTime('dd-mm-yyyy hh:nn:ss', Now);
end;
{$ENDREGION}

end.
