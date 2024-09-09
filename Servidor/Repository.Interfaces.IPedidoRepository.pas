unit Repository.Interfaces.IPedidoRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client;

type
  IPedidoRepository = interface
    ['{E84A5D0F-12A5-4E39-9ABF-2F431BCEFA32}']
    function ListarPedidos(const QuantidadePagina: integer; LSkip, LCodigoUsuario : Integer; LDtUltSinc: string): TJSONArray;
    function ListarItensPedido(CodigoPedido: Integer): TJSONArray;
  end;

implementation

end.

