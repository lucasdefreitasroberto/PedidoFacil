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
    function ReturnSQLInsertUpdate(CodigoPedido : integer): string;
  public
    function ListarPedidos(const QuantidadePagina: integer; LSkip, LCodigoUsuario : Integer; LDtUltSinc: string): TJSONArray;
    function ListarItensPedido(CodigoPedido: Integer): TJSONArray;
    function ExtractPedidoData(const APedido: TJSONObject): RPedidoData;
    function InserirPedido(CodigoUsuario: Integer): TJSONObject;
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

{$REGION ' ExtractPedidoData '}
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
{$ENDREGION}

{$REGION ' ReturnSQLInsertUpdate '}
function TPedidoRepository.ReturnSQLInsertUpdate(CodigoPedido : integer): string;
begin
  if CodigoPedido = 0 then
    Result := SQL.Pedido.sqlInserirPedido
  else
    Result := SQL.Pedido.sqlUpdatePedido;
end;
{$ENDREGION}

{$REGION ' InserirPedido(CodigoPedido: Integer) '}
function TPedidoRepository.InserirPedido(CodigoUsuario: Integer): TJSONObject;
var
  LPedidoData : RPedidoData;
begin
  FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(ReturnSQLInsertUpdate(LPedidoData.CodPedido))
                .Params('COD_PEDIDO',         LPedidoData.CodPedido)
                .Params('COD_CLIENTE',        LPedidoData.CodCliente)
                .Params('COD_USUARIO',        CodigoUsuario)
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
                .ToJSONObject
                .AddPair('COD_PEDIDO_LOCAL', TJSONNumber.Create(LPedidoData.CodPedidoLocal));;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

end.

