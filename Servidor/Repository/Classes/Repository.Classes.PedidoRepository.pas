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
    function ReturnSQLInsertUpdate(const PedidoData : RPedidoData): string;
  public
    function ListarPedidos(const QuantidadePagina: integer; LSkip, LCodigoUsuario : Integer; LDtUltSinc: string): TJSONArray;
    function ListarItensPedido(CodigoPedido: Integer): TJSONArray;
    function ExtractPedidoData(const APedido: TJSONObject): RPedidoData;
    function InserirPedido(CodigoPedido: Integer): TJSONObject;
  end;

implementation

uses
  SQL.Pedido;

{$REGION ' ListarPedidos '}
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
{$ENDREGION}

{$REGION ' ListarItensPedido '}
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
{$ENDREGION}

function TPedidoRepository.ExtractPedidoData(const APedido: TJSONObject): RPedidoData;
begin
  Result.CodPedido        :=   APedido.GetValue<Integer>('COD_PEDIDO', 0);
  Result.CodCliente       :=   APedido.GetValue<Integer>('COD_CLIENTE', 0);
  Result.CodUsuario       :=   APedido.GetValue<Integer>('COD_USUARIO', 0);
  Result.TipoPedido       :=   APedido.GetValue<string>('TIPO_PEDIDO', '');
  Result.DataPedido       :=   APedido.GetValue<string>('DATA_PEDIDO', '');
  Result.Contato          :=   APedido.GetValue<string>('CONTATO', '');
  Result.OBS              :=   APedido.GetValue<string>('OBS', '');
  Result.ValorTotal       :=   APedido.GetValue<Double>('VALOR_TOTAL', 0);
  Result.CodCondPagto     :=   APedido.GetValue<Integer>('COD_COND_PAGTO', 0);
  Result.PrazoEntrega     :=   APedido.GetValue<string>('PRAZO_ENTREGA', '');
  Result.DataEntrega      :=   APedido.GetValue<string>('DATA_ENTREGA', '');
  Result.CodPedidoLocal   :=   APedido.GetValue<Integer>('COD_PEDIDO_LOCAL', 0);
  Result.DataUltAlteracao :=   APedido.GetValue<string>('DATA_ULT_ALTERACAO', '');
end;

function TPedidoRepository.ReturnSQLInsertUpdate(const PedidoData : RPedidoData): string;
var
  SQLInserirOrEditar: string;
begin
  if PedidoData.CodPedido = 0 then
    SQLInserirOrEditar := SQL.Pedido.sqlInserirPedido
  else
    SQLInserirOrEditar := SQL.Pedido.sqlUpdatePedido;
end;

function TPedidoRepository.InserirPedido(CodigoPedido: Integer): TJSONObject;
var
  LPedidoData : RPedidoData;
begin
  FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(ReturnSQLInsertUpdate(LPedidoData))
                .Params('COD_PEDIDO',         CodigoPedido)
                .Params('COD_CLIENTE',        LPedidoData.CodCliente)
                .Params('COD_USUARIO',        LPedidoData.CodUsuario)
                .Params('TIPO_PEDIDO',        LPedidoData.TipoPedido)
                .Params('DATA_PEDIDO',        LPedidoData.DataPedido)
                .Params('VALOR_TOTAL',        LPedidoData.ValorTotal)
                .Params('COD_COND_PAGTO',     LPedidoData.CodCondPagto)
                .Params('PRAZO_ENTREGA',      LPedidoData.PrazoEntrega)
                .Params('DATA_ENTREGA',       LPedidoData.DataEntrega)
                .Params('COD_PEDIDO_LOCAL',   LPedidoData.CodPedidoLocal)
                .Params('DATA_ULT_ALTERACAO', LPedidoData.DataUltAlteracao)
                .Params('CONTATO',            LPedidoData.Contato)
                .Params('OBS',                LPedidoData.OBS)
                .Open
                .ToJSONObject;
  finally
    FQuery.Free;
  end;
end;

end.

