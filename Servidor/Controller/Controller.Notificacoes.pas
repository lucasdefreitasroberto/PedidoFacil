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
  Services.Notificacoes,
  IdSSLOpenSSLHeaders;

procedure RegistrarRotas;

implementation

{$REGION ' CListarNotificacoes '}

procedure CListarNotificacoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesNotificacoes;
  LJsonRetorno : TJSONArray;
begin
  LService := TServicesNotificacoes.Create;
  try

    try
      LJsonRetorno := LService.SListarNotificacoes(Req);
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

{$REGION ' Registra Rotas '}
procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Get('/notificacoes', CListarNotificacoes);
end;
{$ENDREGION}

end.
