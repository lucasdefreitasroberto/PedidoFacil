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
  ServicesPedido: IServicesPedido;
begin
  ServicesPedido := TServicesPedido.Create;

  RequestHandler := TRequestHandler<TJSONArray>.Create(
    function(Req: THorseRequest): TJSONArray
    begin
      Result := ServicesPedido.SListarPedidos(Req);
    end);

  // Usa o método da interface para lidar com a requisição e resposta
  RequestHandler.HandleRequestAndRespond(Req, Res);

// Desta forma ele implementa a classe direto e o Delphi não faz a gerenciamento de memorio automatico
// RequestHandler := TRequestHandler<TJSONArray>.Create(TServicesPedido.Create.SListarPedidos);
end;

procedure CInserirEditarPedidos(Req: THorseRequest; Res: THorseResponse);
var
  RequestHandler: IRequestHandler<TJSONObject>;
  ServicesPedido: IServicesPedido;
begin
  ServicesPedido := TServicesPedido.Create;

  RequestHandler := TRequestHandler<TJSONObject>.Create(
    function(Req: THorseRequest): TJSONObject
    begin
      Result := ServicesPedido.SInserirEditarPedidos(Req);
    end);

  RequestHandler.HandleRequestAndRespond(Req, Res);
end;

procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET,
    THorseJWTConfig.New.SessionClass(TMyClaims))).Get('/pedidos/sincronizacao',
    CListarPedidos);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET,
    THorseJWTConfig.New.SessionClass(TMyClaims))).Post('/pedidos/sincronizacao',
    CInserirEditarPedidos);
end;

end.
