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
  SQL.Cliente;

type
  TClienteRepository = class(TInterfacedObject, IClienteRepository)
    private
      function ExtrairClienteData(const ACliente: TJSONObject): RClienteData;
  public

    function RListarClientes(QuantidadePagina, Skip: integer; DataUltSinc: string): TJSONArray; 
  end;

implementation

{ TClienteRepository }
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

function TClienteRepository.RListarClientes(QuantidadePagina, Skip: integer; DataUltSinc: string): TJSONArray;
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

end.
