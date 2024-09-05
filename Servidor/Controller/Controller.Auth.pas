unit Controller.Auth;

interface

uses
  Horse,
  Horse.JWT,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  JOSE.Types.JSON,
  System.JSON,
  System.SysUtils,
  System.DateUtils;

const
  SECRET = '[LUCAS-SECRET-KEY]';

type
  TTokenResult = record
    Token: string;
    Expiration: TDateTime;
  end;

type
  TMyClaims = class(TJWTClaims)
  private
    function GetCodUsuario: Integer;
    procedure SetCodUsuario(const Value: Integer);
  public
    property COD_USUARIO: Integer read GetCodUsuario write SetCodUsuario;
  end;

function Criar_Token(Cod_Usuario: Integer): TTokenResult;
function Get_Usuario_Request(Req: THorseRequest): Integer;

implementation

{$REGION ' Criar_Token '}
function Criar_Token(Cod_Usuario: Integer): TTokenResult;
var
  LJWT: TJWT;
  LClaims: TMyClaims;
begin
  try
    LJWT := TJWT.Create;
    LClaims := TMyClaims(LJWT.Claims);

    try
      LClaims.COD_USUARIO := Cod_Usuario;
      //LClaims.Expiration := DateTimeToUnix(IncDay(Now, 2));
      LClaims.Expiration := IncDay(Now, 2); // Remove o Token Expiration
      //Result := TJOSE.SHA256CompactToken(SECRET, LJWT);
      Result.Token := TJOSE.SHA256CompactToken(SECRET, LJWT);
      Result.Expiration := LClaims.Expiration;
    except
      on E: Exception do
      begin
        Result.Token := '';
        raise Exception.Create('Erro ao criar o token: ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(LJWT);
  end;
end;
{$ENDREGION}

{$REGION ' Get_Usuario_Request '}
function Get_Usuario_Request(Req: THorseRequest): Integer;
var
  LClaims: TMyClaims;
begin
  try
    LClaims := Req.Session<TMyClaims>;
    if Assigned(LClaims) then
      Result := LClaims.COD_USUARIO
    else
      raise Exception.Create('Sessão inválida ou expirada.');
  except
    on E: Exception do
    begin
      Result := -1;
      raise Exception.Create('Erro ao obter o usuário da requisição: ' + E.Message);
    end;
  end;
end;
{$ENDREGION}

{$REGION ' GetCodUsuario '}
function TMyClaims.GetCodUsuario: Integer;
begin
  Result := FJSON.GetValue<Integer>('id', 0);
//   Result := TJSONUtils.GetJSONValueInt('id', FJSON).AsInteger;
end;
{$ENDREGION}

{$REGION ' SetCodUsuario '}
procedure TMyClaims.SetCodUsuario(const Value: Integer);
begin
  TJSONUtils.SetJSONValueFrom<Integer>('id', Value, FJSON);
end;
{$ENDREGION}

end.

