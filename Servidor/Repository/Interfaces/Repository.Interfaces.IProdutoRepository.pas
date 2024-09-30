unit Repository.Interfaces.IProdutoRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client,
  Horse.Request;

type
  IProdutoRepository = interface
    ['{94ADCB26-B036-460D-9409-993736D30732}']
   function RListarProdutos(const RegPagina, Skip: Integer; DtUltSinc: string): TJSONArray;
  end;

implementation

end.

