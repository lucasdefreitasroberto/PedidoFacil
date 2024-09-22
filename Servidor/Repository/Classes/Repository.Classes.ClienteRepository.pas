unit Repository.Classes.ClienteRepository;

interface

uses
  Repository.Interfaces.IClienteRepository,
  System.JSON,
  FireDAC.Comp.Client,
  Classe.Conexao,
  Interfaces.Conexao,
  System.SysUtils,
  System.Variants,
  SQL.Cliente, Validations.Cliente;

type
  TClienteRepository = class(TInterfacedObject, IClienteRepository)
    private
      function ExtrairClienteData(const ACliente: TJSONObject): RClienteData;
  public
    function RListarClientes(const QuantidadePagina, Skip: integer; DataUltSinc: string): TJSONArray;
    function RInserirCliente(CodigoUsuario: Integer; const ACliente: TJSONObject): TJSONObject;
  end;

implementation

{ TClienteRepository }

{$REGION ' RListarClientes '}
function TClienteRepository.RListarClientes(const QuantidadePagina,
  Skip: integer; DataUltSinc: string): TJSONArray;
begin
  Result :=
    TQueryFD.New
      .SQL(SQL.Cliente.sqlListarClientes)
      .Params('FIRST', QuantidadePagina)
      .Params('SKIP', Skip)
      .Params('DATA_ULT_ALTERACAO', DataUltSinc)
      .Open
      .ToJSONArray
end;
{$ENDREGION}

{$REGION ' RInserirCliente '}
function TClienteRepository.RInserirCliente(CodigoUsuario: Integer; const ACliente: TJSONObject): TJSONObject;
var
  LClienteData: RClienteData;
begin
  LClienteData := Self.ExtrairClienteData(ACliente);
  TInserirClienteValidation.New(LClienteData.Nome);

  Result :=
    TQueryFD.New
      .SQL(SQL.Cliente.sqlInsertOrUpdateCliente)
      .Params('COD_USUARIO', CodigoUsuario)
      .Params('COD_CLIENTE', LClienteData.CodClienteOficial)
      .Params('CNPJ_CPF',    LClienteData.CNPJCPF)
      .Params('NOME',        LClienteData.Nome)
      .Params('FONE',        LClienteData.Fone)
      .Params('EMAIL',       LClienteData.Email)
      .Params('ENDERECO',    LClienteData.Endereco)
      .Params('NUMERO',      LClienteData.Numero)
      .Params('COMPLEMENTO', LClienteData.Complemento)
      .Params('BAIRRO',      LClienteData.Bairro)
      .Params('CIDADE',      LClienteData.Cidade)
      .Params('UF',          LClienteData.UF)
      .Params('CEP',         LClienteData.CEP)
      .Params('LATITUDE',    LClienteData.Latitude)
      .Params('LONGITUDE',   LClienteData.Longitude)
      .Params('LIMITE_DISPONIVEL',  LClienteData.LimiteDisponivel)
      .Params('DATA_ULT_ALTERACAO', LClienteData.DataUltAlteracao)
      .Open
      .ToJSONObject
      .AddPair('cod_cliente_local', TJSONNumber.Create(LClienteData.CodClienteLocal)); {"cod_cliente: 50, "cod_cliente_local": 123}
end;

function TClienteRepository.ExtrairClienteData(const ACliente: TJSONObject): RClienteData;
begin
  Result.CodClienteLocal    :=  ACliente.GetValue<Integer>('COD_CLIENTE_LOCAL', 0);
  Result.CNPJCPF            :=  ACliente.GetValue<string>('CNPJ_CPF', '');
  Result.Nome               :=  ACliente.GetValue<string>('NOME', '');
  Result.Fone               :=  ACliente.GetValue<string>('FONE', '');
  Result.Email              :=  ACliente.GetValue<string>('EMAIL', '');
  Result.Endereco           :=  ACliente.GetValue<string>('ENDERECO', '');
  Result.Numero             :=  ACliente.GetValue<string>('NUMERO', '');
  Result.Complemento        :=  ACliente.GetValue<string>('COMPLEMENTO', '');
  Result.Bairro             :=  ACliente.GetValue<string>('BAIRRO', '');
  Result.Cidade             :=  ACliente.GetValue<string>('CIDADE', '');
  Result.UF                 :=  ACliente.GetValue<string>('UF', '');
  Result.CEP                :=  ACliente.GetValue<string>('CEP', '');
  Result.Latitude           :=  ACliente.GetValue<Double>('LATITUDE', 0);
  Result.Longitude          :=  ACliente.GetValue<Double>('LONGITUDE', 0);
  Result.LimiteDisponivel   :=  ACliente.GetValue<Double>('LIMITE_DISPONIVEL', 0);
  Result.DataUltAlteracao   :=  Now;
  Result.CodClienteOficial  :=  ACliente.GetValue<Integer>('COD_CLIENTE_OFICIAL', 0);
end;
{$ENDREGION}

end.
