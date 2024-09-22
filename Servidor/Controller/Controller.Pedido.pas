unit Controller.Pedido;

interface

uses
  Horse,
  Horse.JWT,
  Horse.Jhonson,
  Horse.CORS,
  Controller.Auth,
  System.JSON,
  Classes.Handler,
  Services.Pedido,
  Interfaces.Handler;

procedure CListarPedidos(Req: THorseRequest; Res: THorseResponse);
procedure CInserirEditarPedidos(Req: THorseRequest; Res: THorseResponse);
procedure RegistrarRotas;

implementation

{$REGION ' CListarPedidos '}
procedure CListarPedidos(Req: THorseRequest; Res: THorseResponse);
begin
  TRequestHandler<TJSONArray>
    .New(TServicesPedido.New.SListarPedidos(Req))
    .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' CInserirEditarPedidos '}
procedure CInserirEditarPedidos(Req: THorseRequest; Res: THorseResponse);
begin
  TRequestHandler<TJSONObject>
    .New(TServicesPedido.New.SInserirEditarPedidos(Req))
    .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' RegistrarRotas '}
procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET,
    THorseJWTConfig.New.SessionClass(TMyClaims))).Get('/pedidos/sincronizacao',
    CListarPedidos);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET,
    THorseJWTConfig.New.SessionClass(TMyClaims))).Post('/pedidos/sincronizacao',
    CInserirEditarPedidos);
end;
{$ENDREGION}

end.
