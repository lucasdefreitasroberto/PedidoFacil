unit Controller.Usuario;

interface

uses
  Horse, Horse.Jhonson, Horse.CORS, Services.Usuario, system.SysUtils;

procedure RegistrarRotas;

implementation

procedure VrcInserirUsuarios(Req: THorseRequest; Res: THorseResponse);
begin
  var
  LService := TServicesUsuario.Create;
  try
    Res.Send(LService.InserirUsuarios);
  finally
    FreeAndNil(LService);
  end;
end;

procedure VrcLogin(Req: THorseRequest; Res: THorseResponse);
begin
  var
  LService := TServicesUsuario.Create;
  try
    try
      Res.Send(LService.Login).Status(THTTPStatus.OK);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    FreeAndNil(LService);
  end;
end;

procedure RegistrarRotas;
begin
  THorse
  .Post('/usuarios', VrcInserirUsuarios)
  .Post('/usuarios/login', VrcLogin)
end;

end.
