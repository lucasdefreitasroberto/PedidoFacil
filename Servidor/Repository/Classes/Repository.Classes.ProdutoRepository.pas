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
  TProdutoRepository = class(TInterfacedObject, IProdutoRepository)
    function RListarProdutos(const RegPagina, Skip: Integer; DtUltSinc: string): TJSONArray;
  end;

implementation


{ TProdutoRepository }

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

end.
