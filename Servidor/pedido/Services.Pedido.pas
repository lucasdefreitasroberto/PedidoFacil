unit Services.Pedido;

interface

uses
  Horse,
  Horse.Jhonson,
  Horse.OctetStream,
  Horse.HandleException,
  system.SysUtils,
  system.JSON,
  Controller.Auth,
  system.Classes,
  DM.Conexao,
  Validations.Pedido,
  SQL.Pedido,
  Classe.Conexao;

type
  TServicesPedido = class(TDMConexao)
  function ListarItensPedido(CodigoPedido: Integer; Query: TQueryFD):TJSONArray;
  public
    function SListarPedidos(Req: THorseRequest): TJSONArray;
    function SInserirEditarPedidos(Req: THorseRequest): TJSONObject;
  end;

implementation

const
  QTD_REG_PAGINA_PEDIDO = 100;

{ TServicesProduto }

{$REGION ' SListarPedidos '}
function TServicesPedido.SListarPedidos(Req: THorseRequest): TJSONArray;
var
   LPagina, LSkip, LCodigoUsuario, LCodigoPedido : integer;
   LDtValidate : TDtSincVaziaValidation;
   LDtUltSinc: string;
   LPedidos: TJSONArray;
begin

  try
    LPagina := Req.Query['pagina'].ToInteger;
  except
    LPagina := 1;
  end;

  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  LSkip := (LPagina * QTD_REG_PAGINA_PEDIDO) - QTD_REG_PAGINA_PEDIDO;

  LDtUltSinc := Req.Query['dt_ult_sincronizacao'];

  LDtValidate := TDtSincVaziaValidation.Create(LDtUltSinc);
  LDtValidate.Validate;

  var
  FQuery := TQueryFD.Create;
  try
    LPedidos := FQuery
                .SQL(SQL.Pedido.sqlListarPedidos)
                .Params('FIRST', QTD_REG_PAGINA_PEDIDO)
                .Params('SKIP', LSkip)
                .Params('DATA_ULT_ALTERACAO', LDtUltSinc)
                .Params('COD_USUARIO', LCodigoUsuario)
                .Open
                .ToJSONArray;

    for var I := 0 to LPedidos.Size - 1 do
    begin
       LCodigoPedido := LPedidos[I].GetValue<Integer>('cod_pedido', 0);
      (LPedidos[I] as TJSONObject).AddPair('itens', ListarItensPedido(LCodigoPedido, FQuery));
    end;

    Result := LPedidos;
  finally
    FQuery.Free;
    LDtValidate.Free;
  end;

  end;
{$ENDREGION}

function TServicesPedido.ListarItensPedido(CodigoPedido: Integer; Query: TQueryFD): TJSONArray;
begin
Result :=
    Query
      .SQL(sqlListarItensPedido)
      .Params('COD_PEDIDO', CodigoPedido)
      .Open
      .ToJSONArray;
end;

function TServicesPedido.SInserirEditarPedidos(Req: THorseRequest): TJSONObject;
begin

end;

end.
