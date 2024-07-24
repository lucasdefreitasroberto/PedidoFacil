unit Controller.Usuario;

interface

uses
  Horse, Horse.Jhonson, Horse.CORS, Services.Usuario, system.SysUtils, system.JSON;

procedure RegistrarRotas;

implementation

{$REGION ' VerificaInserirUsuarios '}
procedure VerificaInserirUsuarios(Req: THorseRequest; Res: THorseResponse);
var
  Nome, Email, Senha: string;
  JsonRetorno: TJSONObject;
begin
  var
  LService := TServicesUsuario.Create;
  try

    try
      JsonRetorno := LService.InserirUsuarios(Req.Body<TJSONObject>);
      { 'Ainda preciso gerar o token para usuario' }
      JsonRetorno.AddPair('token', '0000000000000000000000000');
      Res.Send<TJSONObject>(JsonRetorno).Status(THTTPStatus.Created);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;

  finally
    FreeAndNil(LService);
  end;
end;
{$ENDREGION}

{$REGION ' VerificaLogin '}
procedure VerificaLogin(Req: THorseRequest; Res: THorseResponse);
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
      JsonRetorno := LService.Login(Email.ToLower, Senha);

      if JsonRetorno.Size = 0 then
        Res.Send('E-mail ou Senha inválida.').Status(THTTPStatus.Unauthorized)
      else
      begin
        {'Ainda preciso gerar o token para usuario'}
        JsonRetorno.AddPair('token', '0000000000000000000000000');
        Res.Send<TJSONObject>(JsonRetorno).Status(THTTPStatus.Created);
      end;
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
  THorse
  .Post('/usuarios', VerificaInserirUsuarios)
  .Post('/usuarios/login', VerificaLogin)
end;
{$ENDREGION}

end.
