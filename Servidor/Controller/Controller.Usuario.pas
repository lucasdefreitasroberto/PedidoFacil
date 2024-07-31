unit Controller.Usuario;

interface

uses
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  Services.Usuario,
  system.SysUtils,
  system.JSON,
  Controller.Auth,
  Horse.JWT;

procedure RegistrarRotas;

implementation

{$REGION ' CInserirUsuarios '}

procedure CInserirUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  {LNome, LEmail, LSenha: string; 'ESTOU FAZENDO A ATRIBUIÇÃO AGORA DENTRO DO SERVICE'}
  LJsonRetorno: TJSONObject;
  LCodigoUser : Integer;
begin
  var
  LService := TServicesUsuario.Create;
  try

    try
      LJsonRetorno := LService.SInserirUsuarios(Req.Body<TJSONObject>);
      LCodigoUser := LJsonRetorno.GetValue<Integer>('cod_usuario', 0);

      LJsonRetorno.AddPair('token', Criar_Token(LCodigoUser)); {GERANDO TOKEN PELO ID}

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

{$REGION ' CLogin '}
procedure CLogin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LEmail, LSenha: string;
  Body, LJsonRetorno: TJSONObject;
  LCodigoUser : Integer;
begin
  Body := req.Body<TJSONObject>;
  LEmail := Body.GetValue<string>('email', '');
  LSenha := Body.GetValue<string>('senha', '');

  var
  LService := TServicesUsuario.Create;
  try

    try
      LJsonRetorno := LService.SLogin(LEmail.ToLower, LSenha);

      if LJsonRetorno.Size = 0 then
        Res.Send('E-mail ou Senha inválida.').Status(THTTPStatus.Unauthorized)
      else
      begin
        LCodigoUser := LJsonRetorno.GetValue<Integer>('cod_usuario', 0);

        LJsonRetorno.AddPair('token', Criar_Token(LCodigoUser));
        Res.Send<TJSONObject>(LJsonRetorno).Status(THTTPStatus.Created);
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

{$REGION ' CPush '}

procedure CPush(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LEmail, LSenha: string;
  LTokenPush : string;
  LBody, LJsonRetorno: TJSONObject;
  LCodigoUser : Integer;
begin

  var
  LService := TServicesUsuario.Create;
  try

    try
      LCodigoUser := Controller.Auth.Get_Usuario_Request(Req);

      LBody := req.Body<TJSONObject>;
      LTokenPush := LBody.GetValue<string>('token_push', '');

      LJsonRetorno := LService.SPush(LCodigoUser, LTokenPush);
      Res.Send<TJSONObject>(LJsonRetorno).Status(THTTPStatus.Created);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(THTTPStatus.Unauthorized);
    end;

  finally
    FreeAndNil(LService);
  end;
end;
{$ENDREGION}

{$REGION ' Registra Rotas '}
procedure RegistrarRotas;
begin
  THorse.Post('/usuarios', CInserirUsuarios);
  THorse.Post('/usuarios/login', CLogin);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
    .Post('/usuarios/push',
    CPush);

end;
{$ENDREGION}

end.
