unit Server.Horse;

interface

uses
  Horse,
  Horse.HandleException,
  Horse.CORS,
  Horse.Jhonson,
  Horse.OctetStream,
  Controller.Usuario,
  Controller.Notificacoes,
  Controller.Cliente,
  Controller.Produto,
  Controller.Pedido,
  Controller.CondPagto,
  System.SysUtils,
  Horse.Upload;

type
  TServerHorse = class
  public
    class procedure ConfigureMiddlewares;
    class procedure RegisterRoutes;
    class procedure StartServer(Port: Integer);
    class procedure StopServer;
    class function VerifyStartingHorse: Boolean;
    class function PortRunner: string;
  end;

implementation

{$REGION ' ConfigureMiddlewares '}
class procedure TServerHorse.ConfigureMiddlewares;
begin
  THorse
  .Use(Jhonson())
  .Use(CORS)
  .Use(HandleException)
  .Use(OctetStream)
  .Use(Upload);
end;
{$ENDREGION}

{$REGION ' RegisterRoutes '}
class procedure TServerHorse.RegisterRoutes;
begin
  Controller.Usuario.RegistrarRotas;
  Controller.Notificacoes.RegistrarRotas;
  Controller.Cliente.RegistrarRotas;
  Controller.Produto.RegistrarRotas;
  Controller.Pedido.RegistrarRotas;
  Controller.CondPagto.RegistrarRotas;
end;
{$ENDREGION}

{$REGION ' StartServer '}
class procedure TServerHorse.StartServer(Port: Integer);
begin
  THorse.Listen(Port);
  ConfigureMiddlewares;
  RegisterRoutes;
end;
{$ENDREGION}

{$REGION ' StopServer '}
class procedure TServerHorse.StopServer;
begin
  THorse.StopListen;
end;
{$ENDREGION}

{$REGION ' VerifyStartingHorse '}
class function TServerHorse.VerifyStartingHorse: Boolean;
begin
  Result := THorse.IsRunning;
end;
{$ENDREGION}

{$REGION ' PortRunner '}
class function TServerHorse.PortRunner: string;
begin
  Result := IntToStr(THorse.Port);
end;
{$ENDREGION}

end.
