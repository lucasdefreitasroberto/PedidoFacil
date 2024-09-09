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

procedure CListarPedidos(Req: THorseRequest; Res: THorseResponse);
var
  RequestHandler: IRequestHandler<TJSONArray>;  // Uso da interface com TJSONArray
begin
  // Passa o m�todo de listar pedidos para o request handler
  RequestHandler := TRequestHandler<TJSONArray>.Create(TServicesPedido.Create.SListarPedidos);
  RequestHandler.HandleRequestAndRespond(Req, Res);  // Usa o m�todo da interface para lidar com a requisi��o e resposta
end;

procedure CInserirEditarPedidos(Req: THorseRequest; Res: THorseResponse);
var
  RequestHandler: IRequestHandler<TJSONObject>;
begin
  RequestHandler := TRequestHandler<TJSONObject>.Create(TServicesPedido.Create.SInserirEditarPedidos);
  RequestHandler.HandleRequestAndRespond(Req, Res);  // Usa o novo m�todo diretamente
end;

procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
    .Get('/pedidos/sincronizacao', CListarPedidos)
    .Post('/pedidos/sincronizacao', CInserirEditarPedidos);
end;

end.

