unit Repository.Interfaces.IClienteRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client,
  Horse.Request;

type
  RClienteData = record
    CodClienteLocal: Integer;
    CNPJCPF: string;
    Nome: string;
    Fone: string;
    Email: string;
    Endereco: string;
    Numero: string;
    Complemento: string;
    Bairro: string;
    Cidade: string;
    UF: string;
    CEP: string;
    Latitude: Double;
    Longitude: Double;
    LimiteDisponivel: Double;
    DataUltAlteracao: TDateTime;
    CodClienteOficial: Integer;
  end;

  type
  IClienteRepository = interface
   function RListarClientes(QuantidadePagina, Skip: integer; DataUltSinc: string): TJSONArray;
   function ExtrairClienteData(const ACliente: TJSONObject): RClienteData;
  // function RInserirCliente(const ACliente: TJSONObject; Req: THorseRequest): TJSONObject;
  end;
implementation

end.
