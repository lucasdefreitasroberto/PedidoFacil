unit Repository.Classes.UsuarioRepository;

interface

uses
  Repository.Interfaces.IUsuarioRepository,
  System.JSON,
  FireDAC.Comp.Client,
  Classe.Conexao,
  Interfaces.Conexao,
  System.SysUtils,
  System.Variants,
  HashXMD5;

type
  TUsuarioRepository = class(TInterfacedObject, IUsuarioRepository)
  public
    function RLoginUsuario(const Email, Senha: string): TJSONObject;
    function RInserirUsuario(const Nome, Email, Senha: string): TJSONObject;
    function RUpdateTokenPush(CodigoUsuario: Integer; TokenPush: string): TJSONObject;
end;

implementation

uses
  SQL.Usuario, Controller.Auth;

{ TUsuarioRepository }

function TUsuarioRepository.RInserirUsuario(const Nome, Email, Senha: string): TJSONObject;
var
  LJsonRetorno: TJSONObject;
  LCodigoUser : Integer;
  LTokenResult: TTokenResult;
begin
  LJsonRetorno :=
    TQueryFD.New
      .SQL(SQL.Usuario.sqlInserirUsuario)
      .Params('NOME', Nome)
      .Params('EMAIL', Email)
      .Params('SENHA', SaltPassword(Senha))
      .Open
      .ToJSONObject;

  LCodigoUser := LJsonRetorno.GetValue<Integer>('cod_usuario', 0);
  LTokenResult := Criar_Token(LCodigoUser);
  LJsonRetorno.AddPair('token', LTokenResult.Token);
  LJsonRetorno.AddPair('exp',
    TJSONString.Create(FormatDateTime('dd-mm-yyyy hh:nn:ss', LTokenResult.Expiration)));

  Result := LJsonRetorno;
end;

function TUsuarioRepository.RLoginUsuario(const Email, Senha: string): TJSONObject;
begin
  Result :=
    TQueryFD.New
      .SQL(SQL.Usuario.sqlLogin)
      .Params('EMAIL', Email)
      .Params('SENHA', SaltPassword(Senha))
      .Open
      .ToJSONObject;
end;

function TUsuarioRepository.RUpdateTokenPush(CodigoUsuario: Integer; TokenPush: string): TJSONObject;
begin
  Result :=
    TQueryFD.New
      .SQL(SQL.Usuario.sqlUpdateTokenPush)
      .Params('TOKEN_PUSH', TokenPush)
      .Params('COD_USUARIO', CodigoUsuario)
      .Open
      .ToJSONObject;
end;

end.

