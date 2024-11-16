unit Repository.Classes.ProdutoRepository;

interface

uses
  Repository.Interfaces.IProdutoRepository,
  System.JSON,
  FireDAC.Comp.Client,
  Classe.Conexao,
  Interfaces.Conexao,
  System.SysUtils,
  System.Variants,
  HashXMD5,
  SQL.Produto;

type
  TProdutoRepository = class(TInterfacedObject, IProdutoRepositoryAbstract)
  private
    function ExtrairProdutoData(const Aproduto: TJSONObject): TProdutoData;
  public
    function RListarProdutos(const RegPagina, Skip: Integer; DtUltSinc: string): TJSONArray;
    function RInserirProduto(const CodigoUsuario: Integer; Produto: TJSONObject): TJSONObject;
  end;

implementation

uses
  Validations.Produto;

{ TProdutoRepository }

function TProdutoRepository.RInserirProduto(const CodigoUsuario: Integer; Produto: TJSONObject): TJSONObject;
var
  LSQL: string;
  LProdutoDados: TProdutoData;
begin
  LProdutoDados := Self.ExtrairProdutoData(Produto);

  TDescVazioValidation.New(LProdutoDados.Descricao);

  if LProdutoDados.CodProdutoOficial = 0 then
    LSQL := SQL.Produto.sqlInserirProduto
  else
    LSQL := SQL.Produto.sqlAtualizarProduto;

  Result :=
    TQueryFD.New
      .SQL(LSQL)
      .Params('COD_USUARIO', CodigoUsuario)
      .Params('COD_PRODUTO', LProdutoDados.CodProdutoOficial)
      .Params('DESCRICAO',   LProdutoDados.Descricao)
      .Params('VALOR',       LProdutoDados.Valor)
      .Params('QTD_ESTOQUE', LProdutoDados.Qtdstoque)
      .Params('DATA_ULT_ALTERACAO',LProdutoDados.DataUltAlteracao)
      .Open
      .ToJSONObject
      .AddPair('cod_produto_local', TJSONNumber.Create(LProdutoDados.CodProdutoLocal)); {"cod_produto: 50, "cod_produto_local": 123}
end;

function TProdutoRepository.RListarProdutos(const RegPagina, Skip: Integer; DtUltSinc: string): TJSONArray;
begin
  Result :=
    TQueryFD.New
      .SQL(SQL.Produto.sqlListarProduto)
      .Params('FIRST', RegPagina)
      .Params('SKIP', Skip)
      .Params('DATA_ULT_ALTERACAO', DtUltSinc)
      .Open
      .ToJSONArray;
end;

function TProdutoRepository.ExtrairProdutoData(const Aproduto: TJSONObject): TProdutoData;
begin
  Result.CodProdutoLocal   :=  Aproduto.GetValue<Integer>('COD_PRODUTO_LOCAL', 0);
  Result.Descricao         :=  Aproduto.GetValue<string>('DESCRICAO', '');
  Result.Valor             :=  Aproduto.GetValue<Double>('VALOR', 0);
  Result.Qtdstoque         :=  Aproduto.GetValue<Double>('QTD_ESTOQUE', 0);
  Result.DataUltAlteracao  :=  Aproduto.GetValue<string>('DATA_ULT_ALTERACAO', '');
  Result.CodProdutoOficial :=  Aproduto.GetValue<Integer>('COD_PRODUTO_OFICIAL', 0);
end;

end.
