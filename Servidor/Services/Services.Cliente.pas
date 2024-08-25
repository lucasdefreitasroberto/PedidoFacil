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
  Validations.Cliente;

type
  TClienteData = record
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
  TServicesCliente = class(TDMConexao)
  private
    function InsertSQLCliente: string;
    function UpdateSQLCliente: string;
    function ListarCliente: string;
    function ExtrairClienteData(const ACliente: TJSONObject): TClienteData;
  public
    function SListarClientes(const ACliente:TJSONObject; Req: THorseRequest): TJSONArray;
    function SInserirCliente(const ACliente: TJSONObject; Req: THorseRequest): TJSONObject;
  end;



const
  QTD_REG_PAGINA_CLIENTE = 5; //Limite de Registro por Pagina
  
implementation

{ TServicesCliente }

{$REGION ' SListarClientes '}
function TServicesCliente.SListarClientes(const ACliente: TJSONObject; Req: THorseRequest): TJSONArray;
var
   LDtUltSincronizacao : string;
   LPagina : integer;
begin                                                       {yyyy-mm-dd hh:nn:ss Retorno do Front-end;}
  LDtUltSincronizacao := Req.Query['dt_ult_sincronizacao']; {url = clientes/sincronizacao?dt_ult_sincronizacao=2024-01-13 08:00:00}

  var LDtUltSincValidation := TDtUltSincVaziaValidation.Create(LDtUltSincronizacao);
  try
    LDtUltSincValidation.Validate;
  finally
    LDtUltSincValidation.Free;
  end;

  try
    LPagina := Req.Query['pagina'].ToInteger;{url = clientes/sincronizacao?dt_ult_sincronizacao=2024-01-13 08:00:00&pagina=1}
  except
    LPagina := 1;
  end;

  var LSkip := (LPagina * QTD_REG_PAGINA_CLIENTE) - QTD_REG_PAGINA_CLIENTE;  //Pular Registros

  var LSQL := Self.ListarCliente;

  var FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(LSQL)
                .Params('FIRST', QTD_REG_PAGINA_CLIENTE)
                .Params('SKIP', LSkip)
                .Params('DATA_ULT_ALTERACAO', LDtUltSincronizacao)
                .Open
                .ToJSONArray;
  finally
    FQuery.Free;
  end;

end;

{$ENDREGION}

{$REGION ' SInserirCliente '}
function TServicesCliente.SInserirCliente(const ACliente: TJSONObject; Req: THorseRequest): TJSONObject;
var
  LSQL : string;
  resultado :TJSONObject;
begin
  var LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);
  var LClienteData   := Self.ExtrairClienteData(ACliente);
  var LNomeValidate  := TNomeVazioValidation.Create(LClienteData.Nome);

  try
    LNomeValidate.Validate;
  finally
    LNomeValidate.Free;
  end;

  if LClienteData.CodClienteOficial = 0 then
    LSQL := Self.InsertSQLCliente
  else
    LSQL := Self.UpdateSQLCliente;

  var FQuery := TQueryFD.Create;
  try
    Result :=
      FQuery
        .SQL(LSQL)
        .Params('COD_USUARIO', LCodigoUsuario)
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
  finally
    FQuery.Free;
  end;

end;
{$ENDREGION}

{$REGION ' ExtrairClienteData '}
function TServicesCliente.ExtrairClienteData(const ACliente: TJSONObject): TClienteData;
begin
  Result.CodClienteLocal    := ACliente.GetValue<Integer>('COD_CLIENTE_LOCAL', 0);
  Result.CNPJCPF            := ACliente.GetValue<string>('CNPJ_CPF', '');
  Result.Nome               := ACliente.GetValue<string>('NOME', '');
  Result.Fone               := ACliente.GetValue<string>('FONE', '');
  Result.Email              := ACliente.GetValue<string>('EMAIL', '');
  Result.Endereco           := ACliente.GetValue<string>('ENDERECO', '');
  Result.Numero             := ACliente.GetValue<string>('NUMERO', '');
  Result.Complemento        := ACliente.GetValue<string>('COMPLEMENTO', '');
  Result.Bairro             := ACliente.GetValue<string>('BAIRRO', '');
  Result.Cidade             := ACliente.GetValue<string>('CIDADE', '');
  Result.UF                 := ACliente.GetValue<string>('UF', '');
  Result.CEP                := ACliente.GetValue<string>('CEP', '');
  Result.Latitude           := ACliente.GetValue<Double>('LATITUDE', 0);
  Result.Longitude          := ACliente.GetValue<Double>('LONGITUDE', 0);
  Result.LimiteDisponivel   := ACliente.GetValue<Double>('LIMITE_DISPONIVEL', 0);
  Result.DataUltAlteracao   := Now;
  Result.CodClienteOficial  := ACliente.GetValue<Integer>('COD_CLIENTE_OFICIAL', 0);
end;
{$ENDREGION}

{$REGION ' ListarCliente '}
function TServicesCliente.ListarCliente: string;
begin
  Result :=   ' select first :FIRST skip :SKIP'+
              ' COD_CLIENTE,'+
              ' COD_USUARIO,'+
              ' CNPJ_CPF,'+
              ' NOME,'+
              ' FONE,'+
              ' EMAIL,'+
              ' ENDERECO,'+
              ' NUMERO,'+
              ' COMPLEMENTO,'+
              ' BAIRRO,'+
              ' CIDADE,'+
              ' UF,'+
              ' CEP,'+
              ' LATITUDE,'+
              ' LONGITUDE,'+
              ' LIMITE_DISPONIVEL,'+
              ' DATA_ULT_ALTERACAO'+
              ' from CLIENTE'+
              ' where DATA_ULT_ALTERACAO > :DATA_ULT_ALTERACAO'+
              ' order by COD_CLIENTE';
end;
{$ENDREGION}

{$REGION ' InsertSQLCliente '}
function TServicesCliente.InsertSQLCliente: string;
begin
  Result :=
      ' insert into CLIENTE (COD_CLIENTE, COD_USUARIO, CNPJ_CPF, NOME, FONE, EMAIL, ENDERECO, NUMERO, COMPLEMENTO, BAIRRO, ' +
      ' CIDADE, UF, CEP, LATITUDE, LONGITUDE, LIMITE_DISPONIVEL, DATA_ULT_ALTERACAO) ' +
      ' values (:COD_CLIENTE, :COD_USUARIO, :CNPJ_CPF, :NOME, :FONE, :EMAIL, :ENDERECO, :NUMERO, :COMPLEMENTO, :BAIRRO, :CIDADE, ' +
      ' :UF, :CEP, :LATITUDE, :LONGITUDE, :LIMITE_DISPONIVEL, :DATA_ULT_ALTERACAO) '+
      ' returning COD_CLIENTE';
end;
{$ENDREGION}

{$REGION ' UpdateSQLCliente '}
function TServicesCliente.UpdateSQLCliente: string;
begin
  Result :=
        ' update CLIENTE '+
        ' set COD_USUARIO = :COD_USUARIO, '+
        ' CNPJ_CPF = :CNPJ_CPF, '+
        ' NOME = :NOME, '+
        ' FONE = :FONE, '+
        ' EMAIL = :EMAIL, '+
        ' ENDERECO = :ENDERECO, '+
        ' NUMERO = :NUMERO, '+
        ' COMPLEMENTO = :COMPLEMENTO, '+
        ' BAIRRO = :BAIRRO, '+
        ' CIDADE = :CIDADE, '+
        ' UF = :UF, '+
        ' CEP = :CEP, '+
        ' LATITUDE = :LATITUDE, '+
        ' LONGITUDE = :LONGITUDE, '+
        ' LIMITE_DISPONIVEL = :LIMITE_DISPONIVEL, '+
        ' DATA_ULT_ALTERACAO = :DATA_ULT_ALTERACAO '+
        ' where (COD_CLIENTE = :COD_CLIENTE) '+
        ' returning COD_CLIENTE ';
end;
{$ENDREGION}

end.
