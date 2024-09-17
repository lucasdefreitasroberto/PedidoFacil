unit Repository.Classes.PedidoRepository;

interface

uses
  Repository.Interfaces.IPedidoRepository,
  System.JSON,
  FireDAC.Comp.Client,
  Classe.Conexao,
  System.SysUtils,
  System.Variants,
  Validations.Pedido;

type
  TPedidoRepository = class(TInterfacedObject, IPedidoRepository)
  public
    function ListarPedidos(const QuantidadePagina: integer; LSkip, LCodigoUsuario : Integer; LDtUltSinc: string): TJSONArray;
    function ListarItensPedido(CodigoPedido: Integer): TJSONArray;
    function ExtractPedidoData(const APedido: TJSONObject): RPedidoData;
    function InserirPedido(CodigoUsuario: Integer; PedidoData: RPedidoData; itens: TJSONArray): TJSONObject;
  end;

implementation

uses
  SQL.Pedido;

{$REGION ' ListarPedidos '}
function TPedidoRepository.ListarPedidos(const QuantidadePagina: integer; LSkip, LCodigoUsuario : Integer; LDtUltSinc: string): TJSONArray;
begin
  Result :=
   TQueryFD.New
    .SQL(SQL.Pedido.sqlListarPedidos)
    .Params('FIRST', QuantidadePagina)
    .Params('SKIP', LSkip)
    .Params('DATA_ULT_ALTERACAO', LDtUltSinc)
    .Params('COD_USUARIO', LCodigoUsuario)
    .Open
    .ToJSONArray;
end;
{$ENDREGION}

{$REGION ' ListarItensPedido '}
function TPedidoRepository.ListarItensPedido(CodigoPedido: Integer): TJSONArray;
begin
  Result :=
   TQueryFD.New
    .SQL(SQL.Pedido.sqlListarItensPedido)
    .Params('COD_PEDIDO', CodigoPedido)
    .Open
    .ToJSONArray;
end;
{$ENDREGION}

{$REGION ' ExtractPedidoData '}
function TPedidoRepository.ExtractPedidoData(const APedido: TJSONObject): RPedidoData;
begin
  Result.CodPedido        :=  APedido.GetValue<Integer>('COD_PEDIDO', 0);
  Result.CodCliente       :=  APedido.GetValue<Integer>('COD_CLIENTE', 0);
  Result.TipoPedido       :=  APedido.GetValue<string>('TIPO_PEDIDO', '');
  Result.DataPedido       :=  APedido.GetValue<string>('DATA_PEDIDO', '');
  Result.Contato          :=  APedido.GetValue<string>('CONTATO', '');
  Result.OBS              :=  APedido.GetValue<string>('OBS', '');
  Result.ValorTotal       :=  APedido.GetValue<Double>('VALOR_TOTAL', 0);
  Result.CodCondPagto     :=  APedido.GetValue<Integer>('COD_COND_PAGTO', 0);
  Result.PrazoEntrega     :=  APedido.GetValue<string>('PRAZO_ENTREGA', '');
  Result.DataEntrega      :=  APedido.GetValue<string>('DATA_ENTREGA', '');
  Result.CodPedidoLocal   :=  APedido.GetValue<Integer>('COD_PEDIDO_LOCAL', 0);
  Result.DataUltAlteracao :=  APedido.GetValue<string>('DATA_ULT_ALTERACAO', '');
end;
{$ENDREGION}

{$REGION ' InserirPedido(CodigoPedido: Integer) '}
function TPedidoRepository.InserirPedido(CodigoUsuario: Integer; PedidoData: RPedidoData; itens: TJSONArray): TJSONObject;

  function StrToNullDateTime(const DateStr: string): Variant;
  begin
    if Trim(DateStr) = '' then
      Result := Null
    else
      Result := DateStr;
  end;

var
  LValidateItens: IValidation;
begin
  try
    LValidateItens := TItensEmptyValidation.Create(itens);
  finally
    LValidateItens.Validate;
  end;

  Result :=
   TQueryFD.New
    .SQL(SQL.Pedido.sqlInsertOrUpdatePedido)
    .Params('COD_PEDIDO',         PedidoData.CodPedido)
    .Params('COD_CLIENTE',        PedidoData.CodCliente)
    .Params('COD_USUARIO',        CodigoUsuario)
    .Params('TIPO_PEDIDO',        PedidoData.TipoPedido)
    .Params('DATA_PEDIDO',        StrToNullDateTime(PedidoData.DataPedido))
    .Params('VALOR_TOTAL',        PedidoData.ValorTotal)
    .Params('COD_COND_PAGTO',     PedidoData.CodCondPagto)
    .Params('PRAZO_ENTREGA',      PedidoData.PrazoEntrega)
    .Params('DATA_ENTREGA',       StrToNullDateTime(PedidoData.DataEntrega))
    .Params('COD_PEDIDO_LOCAL',   PedidoData.CodPedidoLocal)
    .Params('DATA_ULT_ALTERACAO', StrToNullDateTime(PedidoData.DataUltAlteracao))
    .Params('CONTATO',            PedidoData.Contato)
    .Params('OBS',                PedidoData.OBS)
    .Open
    .ToJSONObject
    .AddPair('cod_pedido_local', TJSONNumber.Create(PedidoData.CodPedidoLocal));

   TQueryFD.New
    .SQL(SQL.Pedido.sqlDeleteItensPedido)
    .Params('COD_PEDIDO', PedidoData.CodPedido)
    .ExecSQL;

   for var I := 0 to itens.Count - 1 do
   begin
    TQueryFD.New
     .SQL(SQL.Pedido.sqlInsertItensPedido)
     .Params('COD_PEDIDO',     Result.GetValue<integer>(LowerCase('COD_PEDIDO')))
     .Params('COD_PRODUTO',    itens[I].GetValue<integer>('COD_PRODUTO', 0))
     .Params('QTD',            itens[I].GetValue<Double>('QTD',0))
     .Params('VALOR_UNITARIO', itens[I].GetValue<Double>('VALOR_UNITARIO',0))
     .Params('VALOR_TOTAL',    itens[I].GetValue<Double>('VALOR_TOTAL',0))
     .ExecSQL;
   end;
end;
{$ENDREGION}

end.

