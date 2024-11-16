unit Repository.Interfaces.IProdutoRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client,
  Horse.Request;

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
  IProdutoRepositoryAbstract = interface
    ['{94ADCB26-B036-460D-9409-993736D30732}']
   function RListarProdutos(const RegPagina, Skip: Integer; DtUltSinc: string): TJSONArray;
   function RInserirProduto(const CodigoUsuario: integer; Produto: TJSONObject): TJSONObject;
  end;

implementation

end.

