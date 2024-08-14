unit Controller.Cliente;

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
  Services.Cliente,
  IdSSLOpenSSLHeaders;

procedure RegistrarRotas;

implementation

{$REGION ' CListarClientes '}

procedure CListarClientes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesCliente;
  LJsonRetorno : TJSONArray;
begin
  LService := TServicesCliente.Create;
  try

    try
      LJsonRetorno := LService.SListarClientes(Req.Body<TJSONObject>, Req);
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

{$REGION ' CInserirCliente '}

procedure CInserirCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesCliente;
  LJsonRetorno : TJSONObject;
begin
  LService := TServicesCliente.Create;
  try

    try
      LJsonRetorno := LService.SInserirCliente(Req.Body<TJSONObject>, Req);
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

{$REGION ' RegistrarRotas '}
procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Get('/clientes/sincronizacao',
  CListarClientes);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Get('/clientes/sincronizacao',
  CInserirCliente);
end;
{$ENDREGION}

end.
