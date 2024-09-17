unit Repository.Interfaces.IPedidoRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client;

type
  RPedidoData = record
    CodPedido: Integer;
    CodCliente: Integer;
    TipoPedido: string;
    DataPedido: string;
    Contato: string;
    OBS: string;
    ValorTotal: Double;
    CodCondPagto: Integer;
    PrazoEntrega: string;
    DataEntrega: string;
    CodPedidoLocal: integer;
    DataUltAlteracao: string;
  end;

type
  IPedidoRepository = interface
    ['{E84A5D0F-12A5-4E39-9ABF-2F431BCEFA32}']
    function ListarPedidos(const QuantidadePagina: integer; LSkip, LCodigoUsuario : Integer; LDtUltSinc: string): TJSONArray;
    function ListarItensPedido(CodigoPedido: Integer): TJSONArray;
    function InserirPedido(CodigoUsuario: Integer; PedidoData: RPedidoData; itens: TJSONArray): TJSONObject;
    function ExtractPedidoData(const APedido: TJSONObject): RPedidoData;
  end;

implementation

end.

