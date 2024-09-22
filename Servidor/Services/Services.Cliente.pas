unit Services.Cliente;

interface

uses
  system.JSON,
  DataSet.Serialize,
  Utilitarios,
  System.SysUtils,
  DM.Conexao,
  Data.DB,
  FireDAC.Comp.Client,
  HashXMD5,
  Horse.Exception,
  Horse.HandleException,
  Horse.Commons,
  Controller.Auth,
  Horse,
  Interfaces.Conexao,
  Classe.Conexao,
  Validations.Cliente,
  Repository.Classes.ClienteRepository,
  Repository.Interfaces.IClienteRepository;

type
  IServicesCliente = interface
    ['{90D4B9D0-A03C-413D-8A6B-8C4A670334DC}']
    function SListarClientes(Req: THorseRequest): TJSONArray;
    function SInserirCliente(Req: THorseRequest): TJSONObject;
  end;

type
  TServicesCliente = class(TInterfacedObject, IServicesCliente)
  private
    FClienteRepository: IClienteRepository;
  public
    constructor Create;
    destructor Destroy; override;
    function SListarClientes(Req: THorseRequest): TJSONArray;
    function SInserirCliente(Req: THorseRequest): TJSONObject;
    class function New: IServicesCliente;
  end;

const
  QTD_REG_PAGINA_CLIENTE = 100; //Limite de Registro por Pagina

implementation

{ TServicesCliente }

constructor TServicesCliente.Create;
begin
  FClienteRepository := TClienteRepository.Create;
end;

destructor TServicesCliente.Destroy;
begin
   FClienteRepository := Nil;
  inherited;
end;

class function TServicesCliente.New: IServicesCliente;
begin
  Result := Self.Create;
end;

{$REGION ' SListarClientes '}
function TServicesCliente.SListarClientes(Req: THorseRequest): TJSONArray;
var
   LDtUltSincronizacao : string;
   LPagina, LSkip : integer;
begin
  LDtUltSincronizacao := Req.Query['dt_ult_sincronizacao'];

  try
    LPagina := Req.Query['pagina'].ToInteger;
  except
    LPagina := 1;
  end;

  TDtUltSincVaziaValidation.New(LDtUltSincronizacao).Validate;
  LSkip := (LPagina * QTD_REG_PAGINA_CLIENTE) - QTD_REG_PAGINA_CLIENTE;

  Result :=
    FClienteRepository.RListarClientes(QTD_REG_PAGINA_CLIENTE, LSkip, LDtUltSincronizacao);
end;

{$ENDREGION}

{$REGION ' SInserirCliente '}
function TServicesCliente.SInserirCliente(Req: THorseRequest): TJSONObject;
var
  LSQL : string;
  LCodigoUsuario: integer;
  ACliente :TJSONObject;
begin
  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);
  ACliente := Req.Body<TJSONObject>;

  Result :=
    FClienteRepository.RInserirCliente(LCodigoUsuario, ACliente);
end;
{$ENDREGION}
end.
