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
  LService : TServicesUsuario;
begin
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
  LService: TServicesUsuario;
  LJsonRetorno: TJSONObject;
  LCodigoUser: Integer;
begin
  LService := TServicesUsuario.Create;
  try

    try
      LJsonRetorno := LService.SLoginUsuario(Req.Body<TJSONObject>);

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
  LService: TServicesUsuario;
  LJsonRetorno: TJSONObject;
begin
  LService := TServicesUsuario.Create;
  try

    try
      LJsonRetorno := LService.SPush(Req.Body<TJSONObject>, Req);
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
  LService : TServicesUsuario;
begin
  LService := TServicesUsuario.Create;
  try

    try
      LJsonRetorno := LService.SEditarUsuario(Req.Body<TJSONObject>, Req);
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
  LService : TServicesUsuario;
begin
  LService := TServicesUsuario.Create;
  try

    try
      LJsonRetorno := LService.SEditarSenhaUsuario(Req.Body<TJSONObject>, Req);
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

{$REGION ' ObterDataHoraServidor '}
procedure ObterDataHoraServidor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesUsuario;
begin
  LService := TServicesUsuario.Create;
  try

    try
      Res.Send(LService.SObterDataHoraServidor).Status(THTTPStatus.OK);
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

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Get('/usuarios/horario',
  ObterDataHoraServidor);
end;
{$ENDREGION}

end.
