unit Controller.Notificacoes;

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
  Services.Notificacoes, IdSSLOpenSSLHeaders;

procedure RegistrarRotas;

implementation

procedure ListarNotificacoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var
  LService := TServicesNotificacoes.Create;
  try

    try
      var
      LJsonRetorno := LService.SListarNotificacoes(Req.Body<TJSONObject>, Req);

      Res.Send<TJSONArray>(LJsonRetorno).Status(THTTPStatus.OK);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;

  finally
    FreeAndNil(LService);
  end;
end;

{$REGION ' Registra Rotas '}
procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Get('/notificacoes',
  ListarNotificacoes);
end;
{$ENDREGION}

end.
