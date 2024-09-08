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
  FMX.Graphics;

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
  TServicesProduto = class(TDMConexao)
  private
    function SQLInsertProduto: string;
    function SQLUpdateProduto: string;
    function SQLListarProduto: string;
    function SQLListarFotoProduto: string;
    function SQLEditarFotoProduto: string;
    function ExtrairProdutoData(const Aproduto: TJSONObject): TProdutoData;
  public
    function SListarProdutos(Req: THorseRequest): TJSONArray;
    function SInserirProduto(Req: THorseRequest): TJSONObject;
    function SListarFotoProduto(CodProduto: integer): TMemoryStream;
    procedure SEditarFotoProduto(CodProduto: Integer; Foto: TBitmap);
  end;

const
  QTD_REG_PAGINA_PRODUTOS = 100; //Limite de Registro por Pagina

implementation

{ TServicesProduto }

{$REGION ' SListarProdutos '}
function TServicesProduto.SListarProdutos(Req: THorseRequest): TJSONArray;
var
   LPagina : integer;
begin

  try
    LPagina := Req.Query['pagina'].ToInteger;
  except
    LPagina := 1;
  end;

  var
  LSkip := (LPagina * QTD_REG_PAGINA_PRODUTOS) - QTD_REG_PAGINA_PRODUTOS;

  var
  LDtUltSincronizacao := Req.Query['dt_ult_sincronizacao'];

  var
  LDtUltSincVazia := TDtUltSincVaziaValidation.Create(LDtUltSincronizacao);
  LDtUltSincVazia.Validate;

  var
  FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(Self.SQLListarProduto())
                .Params('FIRST', QTD_REG_PAGINA_PRODUTOS)
                .Params('SKIP', LSkip)
                .Params('DATA_ULT_ALTERACAO', LDtUltSincronizacao)
                .Open
                .ToJSONArray;
  finally
    FQuery.Free;
    LDtUltSincVazia.Free;
  end;

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

  var
  LDescricaoProdValidate := TDescVazioValidation.Create(LProdutoDados.Descricao);

  try
    LDescricaoProdValidate.Validate;
  finally
    LDescricaoProdValidate.Free;
  end;

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

{$REGION ' SQL-ListarProduto '}
function TServicesProduto.SQLListarProduto: string;
begin
  Result := ' select first :FIRST skip :SKIP'+
            ' COD_PRODUTO,'+
            ' DESCRICAO,'+
            ' VALOR,'+
            ' FOTO,'+
            ' QTD_ESTOQUE,'+
            ' COD_USUARIO,'+
            ' DATA_ULT_ALTERACAO'+
            ' from PRODUTO'+
            ' where DATA_ULT_ALTERACAO > :DATA_ULT_ALTERACAO'+
            ' order by COD_PRODUTO';
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
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := Self.con;
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
  end;
end;

{$ENDREGION}

{$REGION ' SEditarFotoProduto '}
procedure TServicesProduto.SEditarFotoProduto(CodProduto: Integer; Foto: TBitmap);
var
  FQuery: TFDQuery;
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := Self.con;
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
