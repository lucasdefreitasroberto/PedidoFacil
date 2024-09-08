unit Controller.Pedido;

interface

uses
  Horse,
  Horse.CORS,
  Horse.Jhonson,
  Horse.JWT,
  Horse.OctetStream,
  Horse.HandleException,
  Horse.Commons,
  IdSSLOpenSSLHeaders,
  system.SysUtils,
  system.JSON,
  Controller.Auth,
  System.Classes,
  Services.Pedido;

 procedure CListarPedidos(Req: THorseRequest; Res: THorseResponse);
 procedure CInserirEditarPedidos(Req: THorseRequest; Res: THorseResponse);
 procedure RegistrarRotas;

implementation

{$REGION ' CListarPedidos '}

procedure CListarPedidos(Req: THorseRequest; Res: THorseResponse);
var
  LService : TServicesPedido;
  LJsonRetorno : TJSONArray;
begin
  LService := TServicesPedido.Create;
  try

    try
      LJsonRetorno := LService.SListarPedidos(Req);
      Res.Send<TJSONArray>(LJsonRetorno).Status(THTTPStatus.OK);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;

  finally
    FreeAndNil(LService);
  end;
end;

{$ENDREGION}

{$REGION ' CInserirEditarPedidos '}

procedure CInserirEditarPedidos(Req: THorseRequest; Res: THorseResponse);
var
  LService : TServicesPedido;
  LJsonRetorno : TJSONObject;
begin
  LService := TServicesPedido.Create;
  try

    try
      LJsonRetorno := LService.SInserirEditarPedidos(Req);
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
  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Get('/pedidos/sincronizacao',
  CListarPedidos);

   THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Post('/pedidos/sincronizacao',
  CInserirEditarPedidos);
end;
{$ENDREGION}

end.
