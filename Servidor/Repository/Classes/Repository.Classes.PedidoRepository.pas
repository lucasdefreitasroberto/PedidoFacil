unit Repository.Classes.PedidoRepository;

interface

uses
  Repository.Interfaces.IPedidoRepository,
  System.JSON,
  FireDAC.Comp.Client,
  Classe.Conexao;

type
  TPedidoRepository = class(TInterfacedObject, IPedidoRepository)
  private
    FQuery: TQueryFD;
  public
    function ListarPedidos(const QuantidadePagina: integer; LSkip, LCodigoUsuario : Integer; LDtUltSinc: string): TJSONArray;
    function ListarItensPedido(CodigoPedido: Integer): TJSONArray;
  end;

implementation

uses
  SQL.Pedido;

function TPedidoRepository.ListarPedidos(const QuantidadePagina: integer; LSkip, LCodigoUsuario : Integer; LDtUltSinc: string): TJSONArray;
begin
  FQuery := TQueryFD.Create;
  try
    Result := FQuery
               .SQL(SQL.Pedido.sqlListarPedidos)
               .Params('FIRST', QuantidadePagina)
               .Params('SKIP', LSkip)
               .Params('DATA_ULT_ALTERACAO', LDtUltSinc)
               .Params('COD_USUARIO', LCodigoUsuario)
               .Open
               .ToJSONArray;
  finally
    FQuery.Free;
  end;

end;

function TPedidoRepository.ListarItensPedido(CodigoPedido: Integer): TJSONArray;
begin
  FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(SQL.Pedido.sqlListarItensPedido)
                .Params('COD_PEDIDO', CodigoPedido)
                .Open
                .ToJSONArray;
  finally
    FQuery.Free;
  end;
end;

end.

