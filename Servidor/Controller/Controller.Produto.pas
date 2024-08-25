unit Controller.Produto;

interface

uses
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  system.SysUtils,
  system.JSON,
  Controller.Auth,
  Horse.JWT,
  Horse.OctetStream,
  Horse.HandleException,
  Services.Produto,
  IdSSLOpenSSLHeaders,
  System.Classes;

procedure RegistrarRotas;

implementation

{$REGION ' CListarProduto '}

procedure CListarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesProduto;
  LJsonRetorno : TJSONArray;
begin
  LService := TServicesProduto.Create;
  try

    try
      LJsonRetorno := LService.SListarProdutos(Req.Body<TJSONObject>, Req);
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

{$REGION ' CInserirProduto '}

procedure CInserirProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesProduto;
  LJsonRetorno : TJSONObject;
begin
  LService := TServicesProduto.Create;
  try

    try
      LJsonRetorno := LService.SInserirProduto(Req.Body<TJSONObject>, Req);
      Res.Send<TJSONObject>(LJsonRetorno).Status(THTTPStatus.OK);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;

  finally
    FreeAndNil(LService);
  end;
end;

{$ENDREGION}

{$REGION ' CListarFotoProduto '}
procedure CListarFotoProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesProduto;
  LStreamRetorno : TStream;
begin
  LService := TServicesProduto.Create;
  try

    try
      LStreamRetorno := LService.SListarFotoProduto(Req.Body<TJSONObject>, Req);
      Res.Send<TStream>(LStreamRetorno).Status(THTTPStatus.OK);
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
  .Get('/produtos/sincronizacao',
  CListarProduto);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Post('/produtos/sincronizacao',
  CInserirProduto);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Get('/produtos/foto/:codProduto',
  CListarFotoProduto);
end;
{$ENDREGION}

end.
