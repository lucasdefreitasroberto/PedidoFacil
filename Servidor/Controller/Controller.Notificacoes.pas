unit Controller.Notificacoes;

interface

uses
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  system.SysUtils,
  system.JSON,
  Controller.Auth,
  Horse.JWT,
  Horse.HandleException,
  Services.Notificacoes,
  IdSSLOpenSSLHeaders,
  Interfaces.Handler,
  Classes.Handler;

procedure RegistrarRotas;

implementation

{$REGION ' CListarNotificacoes '}
procedure CListarNotificacoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
//var
//  RequestHandler: IRequestHandler<TJSONArray>;
//  ServicesPedido: IServicesNotificacoes;
begin

  {1}
  // RequestHandler := TRequestHandler<TJSONArray>.Create(
  // function(Req: THorseRequest): TJSONArray
  // begin
  // Result := TServicesNotificacoes.New.SListarNotificacoes(Req);
  // end);

  {2}
  // RequestHandler := TRequestHandler<TJSONArray>.New(TServicesNotificacoes.New.SListarNotificacoes(Req));
  // RequestHandler.HandleRequestAndRespond(Req, Res);

  {3}
  TRequestHandler<TJSONArray>
    .New(TServicesNotificacoes.New.SListarNotificacoes(Req))
    .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' Registra Rotas '}
procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET,
    THorseJWTConfig.New.SessionClass(TMyClaims)))
    .Get('/notificacoes', CListarNotificacoes);
end;
{$ENDREGION}

end.
