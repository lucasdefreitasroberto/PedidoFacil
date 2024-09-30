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
  TProdutoData = record
    CodProdutoLocal: Integer;
    Descricao: string;
    Valor: Double;
    Qtdstoque: Double;
    DataUltAlteracao: string;
    CodProdutoOficial: Integer;
  end;

type
  IServiceProduto = interface
    ['{37433ADC-CDB7-4680-810D-466F6EB59582}']
    function SListarProdutos(Req: THorseRequest): TJSONArray;
  end;


type
  TServicesProduto = class(TInterfacedObject, IServiceProduto)
  private
    FProdutoRepository : IProdutoRepository;
    function SQLInsertProduto: string;
    function SQLUpdateProduto: string;
    function SQLListarFotoProduto: string;
    function SQLEditarFotoProduto: string;
    function ExtrairProdutoData(const Aproduto: TJSONObject): TProdutoData;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IServiceProduto;

    function SListarProdutos(Req: THorseRequest): TJSONArray;
    function SInserirProduto(Req: THorseRequest): TJSONObject;
    function SListarFotoProduto(CodProduto: integer): TMemoryStream;
    procedure SEditarFotoProduto(CodProduto: Integer; Foto: TBitmap);
  end;

implementation

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

class function TServicesProduto.New: IServiceProduto;
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
var
  LSQL : string;
begin
  var
  LProduto := Req.Body<TJSONObject>;

  var
  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  var
  LProdutoDados := Self.ExtrairProdutoData(LProduto);

  TDescVazioValidation.New(LProdutoDados.Descricao);

  if LProdutoDados.CodProdutoOficial = 0 then
    LSQL := Self.SQLInsertProduto
  else
    LSQL := Self.SQLUpdateProduto;

  var
  FQuery := TQueryFD.Create;
  try
    Result :=
      FQuery
        .SQL(LSQL)
        .Params('COD_USUARIO', LCodigoUsuario)
        .Params('COD_PRODUTO', LProdutoDados.CodProdutoOficial)
        .Params('DESCRICAO',   LProdutoDados.Descricao)
        .Params('VALOR',       LProdutoDados.Valor)
        .Params('QTD_ESTOQUE', LProdutoDados.Qtdstoque)
        .Params('DATA_ULT_ALTERACAO',LProdutoDados.DataUltAlteracao)
        .Open
        .ToJSONObject
        .AddPair('cod_produto_local', TJSONNumber.Create(LProdutoDados.CodProdutoLocal)); {"cod_produto: 50, "cod_produto_local": 123}
  finally
    FQuery.Free;
  end;

end;
{$ENDREGION}

{$REGION ' ExtrairProdutoData '}
function TServicesProduto.ExtrairProdutoData(const Aproduto: TJSONObject): TProdutoData;
begin
  Result.CodProdutoLocal   :=  Aproduto.GetValue<Integer>('COD_PRODUTO_LOCAL', 0);
  Result.Descricao         :=  Aproduto.GetValue<string>('DESCRICAO', '');
  Result.Valor             :=  Aproduto.GetValue<Double>('VALOR', 0);
  Result.Qtdstoque         :=  Aproduto.GetValue<Double>('QTD_ESTOQUE', 0);
  Result.DataUltAlteracao  :=  Aproduto.GetValue<string>('DATA_ULT_ALTERACAO', '');
  Result.CodProdutoOficial :=  Aproduto.GetValue<Integer>('COD_PRODUTO_OFICIAL', 0);
end;
{$ENDREGION}

{$REGION ' SQL-InsertSQLProduto '}
function TServicesProduto.SQLInsertProduto: string;
begin
  Result :=
    ' insert into PRODUTO (COD_PRODUTO, COD_USUARIO, DESCRICAO, VALOR, FOTO, QTD_ESTOQUE, DATA_ULT_ALTERACAO) '+
    ' values (:COD_PRODUTO, :COD_USUARIO, :DESCRICAO, :VALOR, :FOTO, :QTD_ESTOQUE, :DATA_ULT_ALTERACAO) '+
    ' returning COD_PRODUTO ';
end;

{$ENDREGION}

{$REGION ' SQL-UpdateProduto '}
function TServicesProduto.SQLUpdateProduto: string;
begin
  Result :=
    ' update PRODUTO '+
    ' set COD_USUARIO = :COD_USUARIO, '+
    ' DESCRICAO = :DESCRICAO, '+
    ' VALOR = :VALOR, '+
    ' FOTO = :FOTO, '+
    ' QTD_ESTOQUE = :QTD_ESTOQUE, '+
    ' DATA_ULT_ALTERACAO = :DATA_ULT_ALTERACAO '+
    ' where (COD_PRODUTO = :COD_PRODUTO) '+
    ' returning COD_PRODUTO ';
end;
{$ENDREGION}

{$REGION ' SListarFotoProduto '}
function TServicesProduto.SListarFotoProduto(CodProduto: Integer): TMemoryStream;
var
  FQuery: TFDQuery;
  LStream: TStream;
  DMConexao: TDMConexao;
begin
  FQuery := TFDQuery.Create(nil);
  DMConexao := TDMConexao.Create;
  FQuery.Connection := DMConexao.con;
  try
    with FQuery do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add(Self.SQLListarFotoProduto);
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
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := DMConexao.con;
  try

    with FQuery do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add(Self.SQLEditarFotoProduto);
      ParamByName('FOTO_PRODUTO').Assign(Foto);
      ParamByName('COD_PRODUTO').Value := CodProduto;
      ExecSQL;
    end;

  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

{$REGION ' SQL-ListarFotoProduto '}
function TServicesProduto.SQLListarFotoProduto: string;
begin
  Result :=
  ' select ' +
  ' FOTO ' +
  ' from PRODUTO ' +
  ' where COD_PRODUTO = :COD_PRODUTO ';
end;
{$ENDREGION}

{$REGION ' SQL-EditarProduto '}
function TServicesProduto.SQLEditarFotoProduto: string;
begin
  Result :=
  ' update PRODUTO '+
  ' set PRODUTO.FOTO = :FOTO_PRODUTO '+
  ' where PRODUTO.COD_PRODUTO = :COD_PRODUTO ';
end;

{$ENDREGION}

end.
