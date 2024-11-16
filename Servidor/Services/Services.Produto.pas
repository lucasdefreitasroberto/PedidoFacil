unit Services.Produto;

interface

uses
  system.JSON,
  DataSet.Serialize,
  Utilitarios,
  System.SysUtils,
  DM.Conexao,
  Data.DB,
  FireDAC.Comp.Client,
  HashXMD5,
  Horse,
  Horse.Exception,
  Horse.HandleException,
  Horse.Commons,
  Horse.OctetStream,
  System.Classes,
  Controller.Auth,
  Interfaces.Conexao,
  Classe.Conexao,
  Validations.Produto,
  Horse.Upload,
  FMX.Graphics,
  Constants,
  Repository.Interfaces.IProdutoRepository,
  Repository.Classes.ProdutoRepository;

type
  IServiceProdutoAbstract = interface
    ['{37433ADC-CDB7-4680-810D-466F6EB59582}']
    function SListarProdutos(Req: THorseRequest): TJSONArray;
    function SInserirProduto(Req: THorseRequest): TJSONObject;
  end;


type
  TServicesProduto = class(TInterfacedObject, IServiceProdutoAbstract)
  private
    FProdutoRepository : IProdutoRepositoryAbstract;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IServiceProdutoAbstract;

    function SListarProdutos(Req: THorseRequest): TJSONArray;
    function SInserirProduto(Req: THorseRequest): TJSONObject;
    function SListarFotoProduto(CodProduto: integer): TMemoryStream;
    procedure SEditarFotoProduto(CodProduto: Integer; Foto: TBitmap);
  end;

implementation

uses
  SQL.Produto;

{ TServicesProduto }

constructor TServicesProduto.Create;
begin
  FProdutoRepository := TProdutoRepository.Create;
end;

destructor TServicesProduto.Destroy;
begin
  FProdutoRepository := nil;
  inherited;
end;

class function TServicesProduto.New: IServiceProdutoAbstract;
begin
  Result := Self.Create;
end;

{$REGION ' SListarProdutos '}
function TServicesProduto.SListarProdutos(Req: THorseRequest): TJSONArray;
var
   LPagina, LSkip: integer;
   LDtUltSinc: string;
begin

  try
    LPagina := Req.Query['pagina'].ToInteger;
  except
    LPagina := 1;
  end;

  LSkip := (LPagina * QTD_REG_PAGINA_PRODUTOS) - QTD_REG_PAGINA_PRODUTOS;

  LDtUltSinc := Req.Query['dt_ult_sincronizacao'];
  TDtUltSincVaziaValidation.New(LDtUltSinc).Validate;

  Result := FProdutoRepository.RListarProdutos(QTD_REG_PAGINA_PRODUTOS, LSkip, LDtUltSinc);
end;
{$ENDREGION}

{$REGION ' SInserirProduto '}
function TServicesProduto.SInserirProduto(Req: THorseRequest): TJSONObject;
begin
  var
  LProduto := Req.Body<TJSONObject>;

  var
  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  Result := FProdutoRepository.RInserirProduto(LCodigoUsuario, LProduto);
end;
{$ENDREGION}

{$REGION ' SListarFotoProduto '}
function TServicesProduto.SListarFotoProduto(CodProduto: Integer): TMemoryStream;
var
  FQuery: TFDQuery;
  LStream: TStream;
  DMConexao: TDMConexao;
  LSQL: string;
begin
  FQuery := TFDQuery.Create(nil);
  DMConexao := TDMConexao.Create;
  FQuery.Connection := DMConexao.con;
  LSQL := SQL.Produto.sqlListarFotoProduto;
  try
    with FQuery do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add(LSQL);
      ParamByName('COD_PRODUTO').AsInteger := CodProduto;
      Active := True;

      if not FieldByName('FOTO').IsNull then
      begin
        LStream := FQuery.CreateBlobStream(FQuery.FieldByName('FOTO'),
          TBlobStreamMode.bmRead);
        try
          Result := TMemoryStream.Create;
          Result.LoadFromStream(LStream);
        finally
          LStream.Free;
        end;
      end
      else
        raise EHorseException.New.Error
          ('Este Produto não possui foto cadastrada')
          .Status(THTTPStatus.Continue);
    end;
  finally
    FQuery.Free;
    DMConexao.Free;
  end;
end;

{$ENDREGION}

{$REGION ' SEditarFotoProduto '}
procedure TServicesProduto.SEditarFotoProduto(CodProduto: Integer; Foto: TBitmap);
var
  FQuery: TFDQuery;
  DMConexao: TDMConexao;
  LSQL: string;
begin
  FQuery := TFDQuery.Create(nil);
  DMConexao := TDMConexao.Create;
  FQuery.Connection := DMConexao.con;
  LSQL := SQL.Produto.sqlEditarFotoProduto;
  try

    with FQuery do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add(LSQL);
      ParamByName('FOTO_PRODUTO').Assign(Foto);
      ParamByName('COD_PRODUTO').Value := CodProduto;
      ExecSQL;
    end;

  finally
    FQuery.Free;
    DMConexao.Free;
  end;
end;
{$ENDREGION}

end.
