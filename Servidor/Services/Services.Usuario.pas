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
    function SInserirUsuarios(Req: THorseRequest): TJSONObject;
    function SPush(Req: THorseRequest): TJSONObject;
    function SEditarUsuario(Req: THorseRequest): TJSONObject;
  end;

type
  TServicesUsuario = class(TInterfacedObject, IServicesUsuario)
  private
    FUsuarioRepository: IUsuarioRepository;
  public
    constructor Create;
    destructor Destroy;

    function SLoginUsuario(Req: THorseRequest): TJSONObject;
    function SInserirUsuarios(Req: THorseRequest): TJSONObject;
    function SPush(Req: THorseRequest): TJSONObject;
    function SEditarUsuario(Req: THorseRequest): TJSONObject;
    function SEditarSenhaUsuario(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
    function SObterDataHoraServidor: string;
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

{$REGION ' Login '}
function TServicesUsuario.SLoginUsuario(Req: THorseRequest): TJSONObject;
var
  LJsonRetorno, Body: TJSONObject;
  LEmail, LSenha: string;
  LCodigoUser : integer;
  LTokenResult: TTokenResult;
begin
  Body := Req.Body<TJSONObject>;
  LEmail := Body.GetValue<string>('email', '');
  LSenha := Body.GetValue<string>('senha', '');

  TLoginVerifyValidation.New(LEmail, LSenha).Validate;
  LJsonRetorno := FUsuarioRepository.RLoginUsuario(LEmail, LSenha);

  if LJsonRetorno.Size = 0 then
    EHorseException.New.Error('E-mail ou Senha inválida.')
      .Status(THTTPStatus.Unauthorized)
  else
  begin
    LCodigoUser := LJsonRetorno.GetValue<Integer>('cod_usuario', 0);
    LTokenResult := Controller.Auth.Criar_Token(LCodigoUser);

    LJsonRetorno.AddPair('token', LTokenResult.Token);
    LJsonRetorno.AddPair('exp',
      TJSONString.Create(FormatDateTime('dd-mm-yyyy hh:nn:ss',
        LTokenResult.Expiration)));

    Result := LJsonRetorno;
  end;
end;
{$ENDREGION}

{$REGION ' InserirUsuarios '}
function TServicesUsuario.SInserirUsuarios(Req: THorseRequest): TJSONObject;
var
  Body : TJSONObject;
  LNome, LEmail, LSenha: string;
begin
  Body   := Req.Body<TJSONObject>;
  LNome  := Body.GetValue<string>('nome', '');
  LEmail := Body.GetValue<string>('email', '');
  LSenha := Body.GetValue<string>('senha', '');

  TEmptyLoginValidation.New([LNome, LEmail, LSenha]).Validate;
  TEmailExistenteValidation.New(LEmail).Validate;
  TSenhaTamanhoValidation.New(LSenha).Validate;

  Result := FUsuarioRepository.RInserirUsuario(LNome, LEmail, LSenha);
end;
{$ENDREGION}

{$REGION ' Push '}
function TServicesUsuario.SPush(Req: THorseRequest): TJSONObject;
var
  Body: TJSONObject;
  LTokenPush: string;
  LCodigoUsuario: Integer;
begin
  Body := Req.Body<TJSONObject>;
  LTokenPush := Body.GetValue<string>('token_push', '');
  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);
  TTokenPushVazioValidation.New(LTokenPush).Validate;

  Result := FUsuarioRepository.RUpdateTokenPush(LCodigoUsuario, LTokenPush);
end;
{$ENDREGION}

{$REGION ' EditarUsuario '}
function TServicesUsuario.SEditarUsuario(Req: THorseRequest): TJSONObject;
var
  Body: TJSONObject;
  LTokenPush: string;
  LCodigoUsuario: Integer;
begin
  Body := Req.Body<TJSONObject>;
  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);
  var
  LNome := Body.GetValue<string>('nome', '');
  var
  LEmail := Body.GetValue<string>('email', '');

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
  LSQL :=

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
