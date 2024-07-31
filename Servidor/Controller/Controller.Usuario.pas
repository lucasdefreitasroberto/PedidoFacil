unit Controller.Usuario;

interface

uses
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  Services.Usuario,
  system.SysUtils,
  system.JSON,
  Controller.Auth,
  Horse.JWT,
  Horse.HandleException;

procedure RegistrarRotas;

implementation

{$REGION ' CInserirUsuarios '}

procedure CInserirUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LJsonRetorno: TJSONObject;
  LCodigoUser : Integer;
begin
  var
  LService := TServicesUsuario.Create;
  try

    try
      LJsonRetorno := LService.SInserirUsuarios(Req.Body<TJSONObject>);
      LCodigoUser := LJsonRetorno.GetValue<Integer>('cod_usuario', 0);
      LJsonRetorno.AddPair('token', Criar_Token(LCodigoUser)); {GERANDO TOKEN PELO ID}

      Res.Send<TJSONObject>(LJsonRetorno).Status(THTTPStatus.Created);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;

  finally
    FreeAndNil(LService);
  end;
end;
{$ENDREGION}

{$REGION ' CLogin '}
procedure CLogin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LEmail, LSenha: string;
  Body, LJsonRetorno: TJSONObject;
  LCodigoUser : Integer;
begin
  Body := Req.Body<TJSONObject>;
  LEmail := Body.GetValue<string>('email', '');
  LSenha := Body.GetValue<string>('senha', '');

  if (LEmail = '') or (LSenha = '') then
   raise EHorseException.New.Error('Informe o e-mail e a senha');

  var
  LService := TServicesUsuario.Create;
  try

    try
      LJsonRetorno := LService.SLogin(LEmail.ToLower, LSenha);

      if LJsonRetorno.Size = 0 then
        Res.Send('E-mail ou Senha inválida.').Status(THTTPStatus.Unauthorized)
      else
      begin
        LCodigoUser := LJsonRetorno.GetValue<Integer>('cod_usuario', 0);

        LJsonRetorno.AddPair('token', Criar_Token(LCodigoUser));
        Res.Send<TJSONObject>(LJsonRetorno).Status(THTTPStatus.Created);
      end;
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;

  finally
    FreeAndNil(LService);
  end;
end;
{$ENDREGION}

{$REGION ' CPush '}

procedure CPush(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LEmail, LSenha: string;
  LTokenPush : string;
  LBody, LJsonRetorno: TJSONObject;
  LCodigoUser : Integer;
begin
  if (LTokenPush = '') then
    raise Exception.Create('Informe o token_push do usuário');

  var
  LService := TServicesUsuario.Create;
  try

    try
      LCodigoUser := Controller.Auth.Get_Usuario_Request(Req);
      LBody := Req.Body<TJSONObject>;
      LTokenPush := LBody.GetValue<string>('token_push', '');

      LJsonRetorno := LService.SPush(LCodigoUser, LTokenPush);
      Res.Send<TJSONObject>(LJsonRetorno).Status(THTTPStatus.OK);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(THTTPStatus.Unauthorized);
    end;

  finally
    FreeAndNil(LService);
  end;
end;
{$ENDREGION}

{$REGION ' CEditarUsuario '}

procedure CEditarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LJsonRetorno: TJSONObject;
  LCodigoUser : Integer;
  LEmail, LNome : string;
begin
  LEmail := Req.Body<TJSONObject>.GetValue<string>('email', '');
  LNome := Req.Body<TJSONObject>.GetValue<string>('nome', '');

  if (LNome = '') or (LEmail = '') then
    raise EHorseException.New.Error('Informe o nome e o e-mail do usuário');

  var
  LService := TServicesUsuario.Create;
  try

    try
      LCodigoUser := Controller.Auth.Get_Usuario_Request(Req);
      LJsonRetorno := LService.SEditarUsuario(LCodigoUser, LNome, LEmail);
      Res.Send<TJSONObject>(LJsonRetorno).Status(THTTPStatus.OK);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;

  finally
    FreeAndNil(LService);
  end;
end;
{$ENDREGION}

{$REGION ' CEditarSenha '}

procedure CEditarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LJsonRetorno: TJSONObject;
  LCodigoUser : Integer;
  LSenha : string;
begin
  LSenha := Req.Body<TJSONObject>.GetValue<string>('senha', '');

  if (LSenha = '') then
    raise EHorseException.New.Error('Informe a senha do usuário');

  var
  LService := TServicesUsuario.Create;
  try

    try
      LCodigoUser := Controller.Auth.Get_Usuario_Request(Req);
      LJsonRetorno := LService.SEditarSenha(LCodigoUser, LSenha);
      Res.Send<TJSONObject>(LJsonRetorno).Status(THTTPStatus.OK);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;

  finally
    FreeAndNil(LService);
  end;
end;
{$ENDREGION}

{$REGION ' Registra Rotas '}
procedure RegistrarRotas;
begin
  THorse.Post('/usuarios', CInserirUsuario);
  THorse.Post('/usuarios/login', CLogin);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Post('/usuarios/push',
  CPush);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Put('/usuarios',
  CEditarUsuario);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Put('/usuarios/senha',
  CEditarSenha);
end;
{$ENDREGION}

end.
