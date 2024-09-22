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
  QTD_REG_PAGINA_CLIENTE = 5; //Limite de Registro por Pagina

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

  try
    LPagina := Req.Query['pagina'].ToInteger;
  except
    LPagina := 1;
  end;

  LDtUltSincronizacao := Req.Query['dt_ult_sincronizacao'];
  TDtUltSincVaziaValidation.New(LDtUltSincronizacao).Validate;
  LSkip := (LPagina * QTD_REG_PAGINA_CLIENTE) - QTD_REG_PAGINA_CLIENTE;

  Result := FClienteRepository.RListarClientes(QTD_REG_PAGINA_CLIENTE, LSkip,
    LDtUltSincronizacao);
end;

{$ENDREGION}

{$REGION ' SInserirCliente '}
function TServicesCliente.SInserirCliente(Req: THorseRequest): TJSONObject;
var
  LSQL : string;
  resultado :TJSONObject;
begin
//  var
//  LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);
//
//  var
//  LClienteData := Self.ExtrairClienteData(ACliente);
//
//  var
//  LNomeValidate := TNomeVazioValidation.Create(LClienteData.Nome);
//
//  try
//    LNomeValidate.Validate;
//  finally
//    LNomeValidate.Free;
//  end;
//
//  if LClienteData.CodClienteOficial = 0 then
//    LSQL := Self.InsertSQLCliente
//  else
//    LSQL := Self.UpdateSQLCliente;
//
//  var FQuery := TQueryFD.Create;
//  try
//    Result :=
//      FQuery
//        .SQL(LSQL)
//        .Params('COD_USUARIO', LCodigoUsuario)
//        .Params('COD_CLIENTE', LClienteData.CodClienteOficial)
//        .Params('CNPJ_CPF',    LClienteData.CNPJCPF)
//        .Params('NOME',        LClienteData.Nome)
//        .Params('FONE',        LClienteData.Fone)
//        .Params('EMAIL',       LClienteData.Email)
//        .Params('ENDERECO',    LClienteData.Endereco)
//        .Params('NUMERO',      LClienteData.Numero)
//        .Params('COMPLEMENTO', LClienteData.Complemento)
//        .Params('BAIRRO',      LClienteData.Bairro)
//        .Params('CIDADE',      LClienteData.Cidade)
//        .Params('UF',          LClienteData.UF)
//        .Params('CEP',         LClienteData.CEP)
//        .Params('LATITUDE',    LClienteData.Latitude)
//        .Params('LONGITUDE',   LClienteData.Longitude)
//        .Params('LIMITE_DISPONIVEL',  LClienteData.LimiteDisponivel)
//        .Params('DATA_ULT_ALTERACAO', LClienteData.DataUltAlteracao)
//        .Open
//        .ToJSONObject
//        .AddPair('cod_cliente_local', TJSONNumber.Create(LClienteData.CodClienteLocal)); {"cod_cliente: 50, "cod_cliente_local": 123}
//  finally
//    FQuery.Free;
//  end;

end;
{$ENDREGION}

{$REGION ' ExtrairClienteData '}
//function TServicesCliente.ExtrairClienteData(const ACliente: TJSONObject): TClienteData;
//begin
//  Result.CodClienteLocal    :=  ACliente.GetValue<Integer>('COD_CLIENTE_LOCAL', 0);
//  Result.CNPJCPF            :=  ACliente.GetValue<string>('CNPJ_CPF', '');
//  Result.Nome               :=  ACliente.GetValue<string>('NOME', '');
//  Result.Fone               :=  ACliente.GetValue<string>('FONE', '');
//  Result.Email              :=  ACliente.GetValue<string>('EMAIL', '');
//  Result.Endereco           :=  ACliente.GetValue<string>('ENDERECO', '');
//  Result.Numero             :=  ACliente.GetValue<string>('NUMERO', '');
//  Result.Complemento        :=  ACliente.GetValue<string>('COMPLEMENTO', '');
//  Result.Bairro             :=  ACliente.GetValue<string>('BAIRRO', '');
//  Result.Cidade             :=  ACliente.GetValue<string>('CIDADE', '');
//  Result.UF                 :=  ACliente.GetValue<string>('UF', '');
//  Result.CEP                :=  ACliente.GetValue<string>('CEP', '');
//  Result.Latitude           :=  ACliente.GetValue<Double>('LATITUDE', 0);
//  Result.Longitude          :=  ACliente.GetValue<Double>('LONGITUDE', 0);
//  Result.LimiteDisponivel   :=  ACliente.GetValue<Double>('LIMITE_DISPONIVEL', 0);
//  Result.DataUltAlteracao   :=  Now;
//  Result.CodClienteOficial  :=  ACliente.GetValue<Integer>('COD_CLIENTE_OFICIAL', 0);
//end;
{$ENDREGION}

end.
