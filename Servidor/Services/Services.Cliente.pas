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
  Classe.Conexao;

type
  TServicesCliente = class(TDMConexao)
  private
    procedure VerificaDataUltimaSincronizacaoVazio(Data: string);
    function SInserirCliente(const ACliente: TJSONObject;
      Req: THorseRequest): TJSONObject;
  public
    function SListarClientes(const ACliente:TJSONObject; Req: THorseRequest): TJSONArray;
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
begin

  try
    LDtUltSincronizacao := Req.Query['dt_ult_sincronizacao'];       {yyyy-mm-dd hh:nn:ss Retorno do Front-end;}
    Self.VerificaDataUltimaSincronizacaoVazio(LDtUltSincronizacao); {url = clientes/sincronizacao?dt_ult_sincronizacao=2024-01-13 08:00:00}
  except
    LDtUltSincronizacao := '';
  end;

  try
    LPagina := Req.Query['pagina'].ToInteger;{url = clientes/sincronizacao?dt_ult_sincronizacao=2024-01-13 08:00:00&pagina=1}
  except
    LPagina := 1;
  end;

  var LSkip := (LPagina * QTD_REG_PAGINA_CLIENTE) - QTD_REG_PAGINA_CLIENTE;  //Pular Registros

  var LSQL := ' select first :FIRST skip :SKIP'+
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
begin


end;
{$ENDREGION}


{$REGION ' Validações '}
procedure TServicesCliente.VerificaDataUltimaSincronizacaoVazio(Data: string);
begin
  if Data = EmptyStr then
    raise EHorseException.New.Error('Parâmetro dt_ult_sincronizacao não informado')
end;

{$ENDREGION}

end.
