unit Server.Horse;

interface

uses
  Horse, Horse.CORS, Horse.Jhonson, Controller.Usuario, System.SysUtils;

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

class procedure TServerHorse.ConfigureMiddlewares;
begin
  THorse.Use(Jhonson()).Use(CORS)
end;

class procedure TServerHorse.RegisterRoutes;
begin
  Controller.Usuario.RegistrarRotas;
end;

class procedure TServerHorse.StartServer(Port: Integer);
begin
  THorse.Listen(Port);
  ConfigureMiddlewares;
  RegisterRoutes;
end;

class procedure TServerHorse.StopServer;
begin
  THorse.StopListen;
end;

class function TServerHorse.VerifyStartingHorse: Boolean;
begin
  Result := THorse.IsRunning;
end;

class function TServerHorse.PortRunner: string;
begin
  Result := IntToStr(THorse.Port);
end;

end.
