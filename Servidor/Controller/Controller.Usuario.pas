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
  Horse.HandleException, Classes.Handler;

procedure RegistrarRotas;

implementation

{$REGION ' CInserirUsuarios '}
procedure CInserirUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  TRequestHandler<TJSONObject>
    .New(TServicesUsuario.New.SInserirUsuarios(Req))
    .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' CLogin '}
procedure CLogin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
 TRequestHandler<TJSONObject>
    .New(TServicesUsuario.New.SLoginUsuario(Req))
    .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' CPush '}
procedure CPush(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
 TRequestHandler<TJSONObject>
    .New(TServicesUsuario.New.SPush(Req))
    .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' CEditarUsuario '}
procedure CEditarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  TRequestHandler<TJSONObject>
    .New(TServicesUsuario.New.SEditarUsuario(Req))
    .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' CEditarSenha '}
procedure CEditarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  TRequestHandler<TJSONObject>
    .New(TServicesUsuario.New.SEditarSenhaUsuario(Req))
    .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' ObterDataHoraServidor '}
procedure ObterDataHoraServidor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  TRequestHandler<string>
    .New(TServicesUsuario.New.SObterDataHoraServidor)
    .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' Registra Rotas '}
procedure RegistrarRotas;
begin
  THorse.Post('/usuarios', CInserirUsuario);

  THorse.Post('/usuarios/login', CLogin);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
    .Post('/usuarios/push', CPush);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
    .Put('/usuarios', CEditarUsuario);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
    .Put('/usuarios/senha', CEditarSenha);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
    .Get('/usuarios/horario', ObterDataHoraServidor);
end;
{$ENDREGION}

end.
