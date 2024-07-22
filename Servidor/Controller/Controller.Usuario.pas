unit Controller.Usuario;

interface

uses
  Horse, Horse.Jhonson, Horse.CORS, Services.Usuario, system.SysUtils, system.JSON;

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
var
  Email, Senha: string;
  Body, JsonRetorno: TJSONObject;
begin
  Body := req.Body<TJSONObject>;
  Email := Body.GetValue<string>('email', '');
  Senha := Body.GetValue<string>('senha', '');

  var
  LService := TServicesUsuario.Create;
  try
    try
      JsonRetorno := LService.Login(email, senha);

      if JsonRetorno.Size = 0 then
        Res.Send('E-mail ou Senha inválida.').Status(THTTPStatus.Unauthorized)
      else
      begin
        {'Ainda preciso gear o token para usuario'}
        JsonRetorno.AddPair('token', '0000000000000000000000000');
        Res.Send<TJSONObject>(JsonRetorno).Status(THTTPStatus.OK);
      end;
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
