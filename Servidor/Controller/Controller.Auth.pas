unit Controller.Auth;

interface

uses
  Horse,  // Framework Horse para construir APIs REST
  Horse.JWT,  // Middleware JWT para Horse, usado para autentica��o
  JOSE.Core.JWT,  // Manipula��o de tokens JWT
  JOSE.Core.Builder,  // Construtor de tokens JWT
  JOSE.Types.JSON,  // Tipos JSON relacionados ao JWT
  System.JSON,  // Manipula��o de JSON nativa do Delphi
  System.SysUtils,  // Fun��es utilit�rias do sistema
  System.DateUtils;  // Manipula��o de datas

const
  SECRET = '[LUCAS-SECRET-KEY]';  // Chave secreta usada para assinar o token JWT

type
  // Estrutura que representa o resultado do token, incluindo o token gerado e sua expira��o
  TTokenResult = record
    Token: string;  // O token JWT gerado
    Expiration: TDateTime;  // A data de expira��o do token
  end;

type
  // Classe personalizada de claims (informa��es embutidas) do JWT
  TMyClaims = class(TJWTClaims)
  private
    // Fun��o para obter o c�digo do usu�rio das claims do JWT
    function GetCodUsuario: Integer;
    // Procedimento para definir o c�digo do usu�rio nas claims do JWT
    procedure SetCodUsuario(const Value: Integer);
  public
    // Propriedade p�blica para acessar o c�digo do usu�rio
    property COD_USUARIO: Integer read GetCodUsuario write SetCodUsuario;
  end;

function Criar_Token(Cod_Usuario: Integer): TTokenResult;  // Fun��o para criar o token JWT
function Get_Usuario_Request(Req: THorseRequest): Integer;  // Fun��o para obter o usu�rio da requisi��o

implementation

{$REGION ' Criar_Token '}
// Fun��o que cria o token JWT com base no c�digo de usu�rio
function Criar_Token(Cod_Usuario: Integer): TTokenResult;
var
  LJWT: TJWT;  // Cria o token JWT
  LClaims: TMyClaims;  // Armazena as claims (informa��es) que ser�o embutidas no token
begin
  try
    LJWT := TJWT.Create;  // Inicializa o token JWT
    LClaims := TMyClaims(LJWT.Claims);  // Obt�m as claims"reivindica��es" do token e converte para a classe customizada

    try
      LClaims.COD_USUARIO := Cod_Usuario;  // Atribui o c�digo do usu�rio �s claims
      LClaims.Expiration := IncDay(Now, 2);  // Define a expira��o do token para 2 dias a partir de agora
      Result.Token := TJOSE.SHA256CompactToken(SECRET, LJWT);  // Gera o token compactado com a chave secreta
      Result.Expiration := LClaims.Expiration;  // Retorna a data de expira��o junto com o token
    except
      on E: Exception do
      begin
        Result.Token := '';  // Em caso de erro, retorna o token vazio
        raise Exception.Create('Erro ao criar o token: ' + E.Message);  // Levanta uma exce��o com a mensagem de erro
      end;
    end;
  finally
    FreeAndNil(LJWT);  // Libera o objeto LJWT para evitar vazamento de mem�ria
  end;
end;
{$ENDREGION}

{$REGION ' Get_Usuario_Request '}
// Fun��o que obt�m o c�digo do usu�rio a partir da requisi��o HTTP
function Get_Usuario_Request(Req: THorseRequest): Integer;
var
  LClaims: TMyClaims;  // Objeto para armazenar as claims do JWT
begin
  try
    LClaims := Req.Session<TMyClaims>;  // Obt�m as claims da sess�o (se houver uma)
    if Assigned(LClaims) then  // Verifica se as claims est�o presentes
      Result := LClaims.COD_USUARIO  // Retorna o c�digo do usu�rio
      //LClaims.FJSON.ToJSON

    else
      raise Exception.Create('Sess�o inv�lida ou expirada.');  // Levanta exce��o se a sess�o n�o for v�lida
  except
    on E: Exception do
    begin
      Result := -1;  // Se houver erro, retorna -1 como valor de usu�rio inv�lido
      raise Exception.Create('Erro ao obter o usu�rio da requisi��o: ' + E.Message);  // Levanta a exce��o com a mensagem de erro
    end;
  end;
end;
{$ENDREGION}

{$REGION ' GetCodUsuario '}
// Fun��o que obt�m o c�digo do usu�rio da estrutura JSON armazenada no JWT
function TMyClaims.GetCodUsuario: Integer;
begin
  Result := FJSON.GetValue<Integer>('id', 0);  // Acessa o campo 'id' das claims e retorna o valor como Integer
end;
{$ENDREGION}

{$REGION ' SetCodUsuario '}
// Procedimento que define o c�digo do usu�rio nas claims do JWT
procedure TMyClaims.SetCodUsuario(const Value: Integer);
begin
  TJSONUtils.SetJSONValueFrom<Integer>('id', Value, FJSON);  // Define o campo 'id' nas claims com o valor passado
end;
{$ENDREGION}

end.

