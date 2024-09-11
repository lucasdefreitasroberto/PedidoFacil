unit Controller.Auth;

interface

uses
  Horse,  // Framework Horse para construir APIs REST
  Horse.JWT,  // Middleware JWT para Horse, usado para autenticação
  JOSE.Core.JWT,  // Manipulação de tokens JWT
  JOSE.Core.Builder,  // Construtor de tokens JWT
  JOSE.Types.JSON,  // Tipos JSON relacionados ao JWT
  System.JSON,  // Manipulação de JSON nativa do Delphi
  System.SysUtils,  // Funções utilitárias do sistema
  System.DateUtils;  // Manipulação de datas

const
  SECRET = '[LUCAS-SECRET-KEY]';  // Chave secreta usada para assinar o token JWT

type
  // Estrutura que representa o resultado do token, incluindo o token gerado e sua expiração
  TTokenResult = record
    Token: string;  // O token JWT gerado
    Expiration: TDateTime;  // A data de expiração do token
  end;

type
  // Classe personalizada de claims (informações embutidas) do JWT
  TMyClaims = class(TJWTClaims)
  private
    // Função para obter o código do usuário das claims do JWT
    function GetCodUsuario: Integer;
    // Procedimento para definir o código do usuário nas claims do JWT
    procedure SetCodUsuario(const Value: Integer);
  public
    // Propriedade pública para acessar o código do usuário
    property COD_USUARIO: Integer read GetCodUsuario write SetCodUsuario;
  end;

function Criar_Token(Cod_Usuario: Integer): TTokenResult;  // Função para criar o token JWT
function Get_Usuario_Request(Req: THorseRequest): Integer;  // Função para obter o usuário da requisição

implementation

{$REGION ' Criar_Token '}
// Função que cria o token JWT com base no código de usuário
function Criar_Token(Cod_Usuario: Integer): TTokenResult;
var
  LJWT: TJWT;  // Cria o token JWT
  LClaims: TMyClaims;  // Armazena as claims (informações) que serão embutidas no token
begin
  try
    LJWT := TJWT.Create;  // Inicializa o token JWT
    LClaims := TMyClaims(LJWT.Claims);  // Obtém as claims"reivindicações" do token e converte para a classe customizada

    try
      LClaims.COD_USUARIO := Cod_Usuario;  // Atribui o código do usuário às claims
      LClaims.Expiration := IncDay(Now, 2);  // Define a expiração do token para 2 dias a partir de agora
      Result.Token := TJOSE.SHA256CompactToken(SECRET, LJWT);  // Gera o token compactado com a chave secreta
      Result.Expiration := LClaims.Expiration;  // Retorna a data de expiração junto com o token
    except
      on E: Exception do
      begin
        Result.Token := '';  // Em caso de erro, retorna o token vazio
        raise Exception.Create('Erro ao criar o token: ' + E.Message);  // Levanta uma exceção com a mensagem de erro
      end;
    end;
  finally
    FreeAndNil(LJWT);  // Libera o objeto LJWT para evitar vazamento de memória
  end;
end;
{$ENDREGION}

{$REGION ' Get_Usuario_Request '}
// Função que obtém o código do usuário a partir da requisição HTTP
function Get_Usuario_Request(Req: THorseRequest): Integer;
var
  LClaims: TMyClaims;  // Objeto para armazenar as claims do JWT
begin
  try
    LClaims := Req.Session<TMyClaims>;  // Obtém as claims da sessão (se houver uma)
    if Assigned(LClaims) then  // Verifica se as claims estão presentes
      Result := LClaims.COD_USUARIO  // Retorna o código do usuário
      //LClaims.FJSON.ToJSON

    else
      raise Exception.Create('Sessão inválida ou expirada.');  // Levanta exceção se a sessão não for válida
  except
    on E: Exception do
    begin
      Result := -1;  // Se houver erro, retorna -1 como valor de usuário inválido
      raise Exception.Create('Erro ao obter o usuário da requisição: ' + E.Message);  // Levanta a exceção com a mensagem de erro
    end;
  end;
end;
{$ENDREGION}

{$REGION ' GetCodUsuario '}
// Função que obtém o código do usuário da estrutura JSON armazenada no JWT
function TMyClaims.GetCodUsuario: Integer;
begin
  Result := FJSON.GetValue<Integer>('id', 0);  // Acessa o campo 'id' das claims e retorna o valor como Integer
end;
{$ENDREGION}

{$REGION ' SetCodUsuario '}
// Procedimento que define o código do usuário nas claims do JWT
procedure TMyClaims.SetCodUsuario(const Value: Integer);
begin
  TJSONUtils.SetJSONValueFrom<Integer>('id', Value, FJSON);  // Define o campo 'id' nas claims com o valor passado
end;
{$ENDREGION}

end.

