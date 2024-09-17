unit Controller.CondPagto;

interface

uses
  Horse,
  Horse.JWT,
  Horse.Jhonson,
  Horse.CORS,
  Controller.Auth,
  System.JSON,
  Classes.Handler,
  Interfaces.Handler,
  Services.CondPagto;

procedure CListarCondPagto(Req: THorseRequest; Res: THorseResponse);
procedure RegistrarRotas;

implementation

{$REGION ' CListarCondPagto '}
procedure CListarCondPagto(Req: THorseRequest; Res: THorseResponse);
var
  RequestHandler: IRequestHandler<TJSONArray>;
  ServicesPedido: IServicesCondPagto;
begin
  ServicesPedido := TServicesCondPagto.Create;

  RequestHandler := TRequestHandler<TJSONArray>.Create(
    function(Req: THorseRequest): TJSONArray
    begin
      Result := ServicesPedido.SListarCondPagto;
    end);

  RequestHandler.HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' RegistrarRotas '}
procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET,
    THorseJWTConfig.New.SessionClass(TMyClaims))).Get('/cond-pagto/sincronizacao',
    CListarCondPagto);
end;
{$ENDREGION}

end.
