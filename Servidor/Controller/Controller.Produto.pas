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
  System.Classes,
  Horse.Upload,
  Classes.Handler;

procedure RegistrarRotas;

implementation

uses
  FMX.Graphics;

{$REGION ' CListarProduto '}
procedure CListarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  TRequestHandler<TJSONArray>
    .New(TServicesProduto.New.SListarProdutos(Req))
    .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' CInserirProduto '}
procedure CInserirProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  TRequestHandler<TJSONObject>
  .New(TServicesProduto.New.SInserirProduto(Req))
  .HandleRequestAndRespond(Req, Res);
end;
{$ENDREGION}

{$REGION ' CListarFotoProduto '}
procedure CListarFotoProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesProduto;
  LCodProduto : Integer;
begin
  LService := TServicesProduto.Create;
  try

    try
      LCodProduto := Req.Params.Items['codproduto'].ToInteger;
    except
      LCodProduto := 0;
    end;

    try
      Res.Send<TMemoryStream>(LService.SListarFotoProduto(LCodProduto))
        .Status(THTTPStatus.OK);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;

  finally
    FreeAndNil(LService);
  end;
end;
{$ENDREGION}

{$REGION ' CEditarFotoProduto '}
procedure CEditarFotoProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesProduto;
  LCodProduto: Integer;
  LUploadConfig: TUploadConfig;
  LFoto: TBitmap;
begin
  LService := TServicesProduto.Create;

  try
    LCodProduto := Req.Params.Items['codProduto'].ToInteger;
  except
    LCodProduto := 0;
  end;

  try

    LUploadConfig := TUploadConfig.Create(ExtractFilePath(ParamStr(0)) + 'fotos'); //Caminho Exe + Pasta fotos
    LUploadConfig.ForceDir := True;      // Se não achar pasta fotos ele vai criar ela.
    LUploadConfig.OverrideFiles := True; // Se for subir um arquivo que ja existe ele sobrescreve

    LUploadConfig.UploadFileCallBack :=
      procedure(Sender: TObject; AFile: TUploadFileInfo)
      begin
        try
          LFoto := TBitmap.CreateFromFile(AFile.fullpath);
          LService.SEditarFotoProduto(LCodProduto, LFoto);
          FreeAndNil(LFoto);
        finally
          FreeAndNil(LService);
        end;
      end;

  except
    on ex: Exception do
      Res.Send(ex.Message).Status(500);
  end;

   Res.Send<TUploadConfig>(LUploadConfig);

   {Não posso destruir meu processo depois que a aplicação e executada,
    o UploadFileCallBack e executado depois que todo o processo e rodado,
    Não verifiquei afundo ainda a chamada, assim que verificar preciso comentar sobre}
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
  .Get('/produtos/foto/:codproduto',
  CListarFotoProduto);

  //THorse.Get('/produtos/foto/:codproduto', CListarFotoProduto);

  THorse.AddCallback(HorseJWT(Controller.Auth.SECRET, THorseJWTConfig.New.SessionClass(TMyClaims)))
  .Put('/produtos/foto/:codproduto',
  CEditarFotoProduto);
end;
{$ENDREGION}

end.
