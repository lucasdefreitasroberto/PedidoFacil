unit Services.Pedido;

interface

uses
  Horse,
  System.JSON,
  Repository.Interfaces.IPedidoRepository,
  Repository.Classes.PedidoRepository,
  Controller.Auth,
  Validations.Pedido,
  DM.Conexao;

  type
  IServicesPedido = interface(IInterface)
  ['{E9554601-CE62-44D8-A85B-91B4488BCD93}']
    function SListarPedidos(Req: THorseRequest): TJSONArray;
    function SInserirEditarPedidos(Req: THorseRequest): TJSONObject;
  end;

  type
  TServicesPedido = class(TDMConexao, IServicesPedido)
  private
    FPedidoRepository: IPedidoRepository;
  public
    constructor Create;
    destructor Destroy; override;

    function SListarPedidos(Req: THorseRequest): TJSONArray;
    function SInserirEditarPedidos(Req: THorseRequest): TJSONObject;
  end;

implementation

uses
  System.SysUtils;

const
  QTD_REG_PAGINA_PEDIDO = 100;

constructor TServicesPedido.Create;
begin
  FPedidoRepository := TPedidoRepository.Create;
end;

destructor TServicesPedido.Destroy;
begin
  // Limpeza de recursos, se necessário
  FPedidoRepository := nil; // Libera a referência ao repositório
  inherited;
end;

function TServicesPedido.SListarPedidos(Req: THorseRequest): TJSONArray;
var
  LPagina, LSkip, LCodigoUsuario: Integer;
  LDtValidate: TDtSincVaziaValidation;
  LDtUltSinc: string;
  LPedidos: TJSONArray;
begin
  // Obter e validar a página
  try
    LPagina := Req.Query['pagina'].ToInteger;
  except
    LPagina := 1;
  end;

  // Obter o código do usuário
  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  // Calcular o LSkip
  LSkip := (LPagina * QTD_REG_PAGINA_PEDIDO) - QTD_REG_PAGINA_PEDIDO;

  // Obter e validar a data de última sincronização
  LDtUltSinc := Req.Query['dt_ult_sincronizacao'];
  LDtValidate := TDtSincVaziaValidation.Create(LDtUltSinc);
  try
    LDtValidate.Validate;

    // Obter os pedidos do repositório
    LPedidos := FPedidoRepository.ListarPedidos(QTD_REG_PAGINA_PEDIDO, LSkip, LCodigoUsuario, LDtUltSinc);

    // Adicionar os itens aos pedidos
    for var I := 0 to LPedidos.Size - 1 do
    begin
      var LCodigoPedido := LPedidos[I].GetValue<Integer>('cod_pedido', 0);
      (LPedidos[I] as TJSONObject).AddPair('itens', FPedidoRepository.ListarItensPedido(LCodigoPedido));
    end;

    Result := LPedidos;
  finally
    LDtValidate.Free;
  end;
end;

function TServicesPedido.SInserirEditarPedidos(Req: THorseRequest): TJSONObject;
begin
  // Implementar lógica de inserção/edição de pedidos
end;

end.

