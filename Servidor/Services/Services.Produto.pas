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
  Horse.Exception,
  Horse.HandleException,
  Horse.Commons,
  Horse.OctetStream,
  System.Classes,
  Controller.Auth,
  Horse,
  Interfaces.Conexao,
  Classe.Conexao,
  Validations.Produto;

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
    function SQLFotoProduto: string;
    function ExtrairProdutoData(const Aproduto: TJSONObject): TProdutoData;
  public
    function SListarProdutos(const Aproduto:TJSONObject; Req: THorseRequest): TJSONArray;
    function SInserirProduto(const Aproduto: TJSONObject; Req: THorseRequest): TJSONObject;
    function SListarFotoProduto(const Aproduto: TJSONObject; Req: THorseRequest): TStream;
  end;

const
  QTD_REG_PAGINA_PRODUTOS = 5; //Limite de Registro por Pagina

implementation

{ TServicesProduto }

{$REGION ' SListarProdutos '}
function TServicesProduto.SListarProdutos(const Aproduto:TJSONObject; Req: THorseRequest): TJSONArray;
var
   LPagina : integer;
begin

  try
    LPagina := Req.Query['pagina'].ToInteger;
  except
    LPagina := 1;
  end;

  var LDtUltSincronizacao := Req.Query['dt_ult_sincronizacao'];
  var LDtUltSincVazia := TDtUltSincVaziaValidation.Create(LDtUltSincronizacao);
  var LSkip := (LPagina * QTD_REG_PAGINA_PRODUTOS) - QTD_REG_PAGINA_PRODUTOS;
  var LSQL := Self.SQLListarProduto;

  var FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(LSQL)
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
function TServicesProduto.SInserirProduto(const Aproduto: TJSONObject; Req: THorseRequest): TJSONObject;
var
  LSQL : string;
begin
  var LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);
  var LProdutoDados  := Self.ExtrairProdutoData(Aproduto);
  var LDescricaoProdValidate := TDescVazioValidation.Create(LProdutoDados.Descricao);

  try
    LDescricaoProdValidate.Validate;
  finally
    LDescricaoProdValidate.Free;
  end;

  if LProdutoDados.CodProdutoOficial = 0 then
    LSQL := Self.SQLInsertProduto
  else
    LSQL := Self.SQLUpdateProduto;

  var FQuery := TQueryFD.Create;
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
  Result.CodProdutoLocal      := Aproduto.GetValue<Integer>('COD_PRODUTO_LOCAL', 0);
  Result.Descricao            := Aproduto.GetValue<string>('DESCRICAO', '');
  Result.Valor                := Aproduto.GetValue<Double>('VALOR', 0);
  Result.Qtdstoque            := Aproduto.GetValue<Double>('QTD_ESTOQUE', 0);
  Result.DataUltAlteracao     := Aproduto.GetValue<string>('DATA_ULT_ALTERACAO', '');
  Result.CodProdutoOficial    := Aproduto.GetValue<Integer>('COD_PRODUTO_OFICIAL', 0);
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
function TServicesProduto.SListarFotoProduto(const Aproduto: TJSONObject; Req: THorseRequest): TStream;
var
  CodProduto : Integer; //Rota => /produto/foto/10
  Foto : TStream;
  LTVerificaFoto : TVerificaFoto;
begin

  try
    CodProduto := Req.Params.Items['codProduto'].ToInteger;
  except
    CodProduto := 0;
  end;

  var
    FQuery := TQueryFD.Create;
  try
    Foto :=
      FQuery
        .SQL(SQLFotoProduto)
        .Params('COD_PRODUTO', CodProduto)
        .Open
        .ToBlobStream('FOTO');

    LTVerificaFoto := TVerificaFoto.Create(Foto);
    LTVerificaFoto.Validate;

    Result := Foto;
  finally
    FQuery.Free;
    LTVerificaFoto.Free;
  end;
end;
{$ENDREGION}

{$REGION ' SQL-FotoProduto '}
function TServicesProduto.SQLFotoProduto: string;
begin
  Result := ' select ' +
            ' FOTO ' +
            ' from PRODUTO ' +
            ' where COD_PRODUTO = :COD_PRODUTO ';
end;
{$ENDREGION}

end.
