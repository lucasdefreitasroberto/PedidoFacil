unit Services.Usuario;

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
  Validations.Usuario;

type
  TServicesUsuario = class(TDMConexao)
  private
  public
    function SLoginUsuario(const AUsuario: TJSONObject): TJSONObject;
    function SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
    function SPush(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
    function SEditarUsuario(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
    function SEditarSenhaUsuario(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
    function SObterDataHoraServidor: String;
  end;

implementation

{ TServicesUsuario }

{$REGION ' InserirUsuarios '}
function TServicesUsuario.SInserirUsuarios(const AUsuario: TJSONObject): TJSONObject;
begin
  var LNome  := AUsuario.GetValue<string>('nome', '');
  var LEmail := AUsuario.GetValue<string>('email', '');
  var LSenha := AUsuario.GetValue<string>('senha', '');

  var LNomeEmailSenhaVaziaValidation := TNomeEmailSenhaVaziaValidation.Create(LNome, LEmail, LSenha);
  var LEmailExistenteValidation      := TEmailExistenteValidation.Create(LEmail, Self.con);
  var LSenhaTamanhoValidation        := TSenhaTamanhoValidation.Create(LSenha);

  try
    LNomeEmailSenhaVaziaValidation.Validate;
    LEmailExistenteValidation.Validate;
    LSenhaTamanhoValidation.Validate;
  finally
    LNomeEmailSenhaVaziaValidation.Free;
    LEmailExistenteValidation.Free;
    LSenhaTamanhoValidation.Free;
  end;

  var LSQL := ' insert into USUARIO '+
              ' (NOME, EMAIL, SENHA)'+
              ' values '+
              ' (:NOME, :EMAIL, :SENHA)'+
              ' returning COD_USUARIO, NOME, EMAIL';

  var FQuery := TQueryFD.Create;
  try
    Result := FQuery
               .SQL(LSQL)
               .Params('NOME', LNome)
               .Params('SENHA', LSenha)
               .Params('EMAIL', LEmail)
               .Open
               .ToJSONObject;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

{$REGION ' Login '}
function TServicesUsuario.SLoginUsuario(const AUsuario: TJSONObject): TJSONObject;
begin
  var LEmail := AUsuario.GetValue<string>('email', '');
  var LSenha := AUsuario.GetValue<string>('senha', '');

  var LEmailSenhaVaziaValidation := TEmailSenhaVaziaValidation.Create(LEmail, LSenha);

  try
    LEmailSenhaVaziaValidation.Validate;
  finally
    LEmailSenhaVaziaValidation.Free;
  end;

  var LSQL := ' select '+
              ' USU.COD_USUARIO, '+
              ' USU.NOME, '+
              ' USU.EMAIL '+
              ' from USUARIO USU '+
              ' where USU.EMAIL = '+QuotedStr(LEmail.ToLower)+' and '+
              ' USU.SENHA = '+QuotedStr(SaltPassword(LSenha));

  var FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(LSQL)
                .Open
                .ToJSONObject;
  finally
    FQuery.Free;
  end;
end;

{$ENDREGION}

{$REGION ' Push '}
function TServicesUsuario.SPush(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
begin
  var LTokenPush     := AUsuario.GetValue<string>('token_push', '');
  var LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  var LTokenPushVazioValidation := TTokenPushVazioValidation.Create(LTokenPush);

  try
    LTokenPushVazioValidation.Validate;
  finally
    LTokenPushVazioValidation.Free;
  end;

  var LSQL := ' update USUARIO ' +
              ' set TOKEN_PUSH = :TOKEN_PUSH ' +
              ' where (COD_USUARIO = :COD_USUARIO) ' +
              ' returning COD_USUARIO ';

  var FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(LSQL)
                .Params('TOKEN_PUSH', LTokenPush)
                .Params('COD_USUARIO', LCodigoUsuario)
                .Open
                .ToJSONObject;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

{$REGION ' EditarUsuario '}
function TServicesUsuario.SEditarUsuario(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
begin
  var LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);
  var LNome  := AUsuario.GetValue<string>('nome', '');
  var LEmail := AUsuario.GetValue<string>('email', '');

  var LNomeEmailVaziaValidation := TNomeEmailVaziaValidation.Create(LNome, LEmail);
  var LEmailExistenteValidation := TEmailExistenteValidation.Create(LEmail, Self.con);

  try
    LNomeEmailVaziaValidation.Validate;
    LEmailExistenteValidation.Validate;
  finally
    LNomeEmailVaziaValidation.Free;
    LEmailExistenteValidation.Free;
  end;

  var
    LSQL := ' update USUARIO '+
            ' set NOME = :NOME, '+
            ' EMAIL = :EMAIL '+
            ' where (COD_USUARIO = :COD_USUARIO) '+
            ' returning COD_USUARIO, NOME, EMAIL ';

  var FQuery := TQueryFD.Create;
  try
    Result := FQuery
                .SQL(LSQL)
                .Params('NOME', LNome)
                .Params('EMAIL', LEmail)
                .Params('COD_USUARIO', LCodigoUsuario)
                .Open
                .ToJSONObject
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

{$REGION ' EditarSenha '}
function TServicesUsuario.SEditarSenhaUsuario(const AUsuario: TJSONObject; Req: THorseRequest): TJSONObject;
begin
  var LSenha := AUsuario.GetValue<string>('senha', '');
  var LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  var LSenhaVaziaValidation   := TSenhaVaziaValidation.Create(LSenha);
  var LSenhaTamanhoValidation := TSenhaTamanhoValidation.Create(LSenha);

  try
    LSenhaVaziaValidation.Validate;
    LSenhaTamanhoValidation.Validate;
  finally
    LSenhaVaziaValidation.Free;
    LSenhaTamanhoValidation.Free;
  end;

  var LSQL := ' update USUARIO '+
              ' set SENHA = :SENHA '+
              ' where (COD_USUARIO = :COD_USUARIO) '+
              ' returning COD_USUARIO ';

  var FQuery := TQueryFD.Create;
  try
     Result := FQuery
                .SQL(LSQL)
                .Params('SENHA', SaltPassword(LSenha))
                .Params('COD_USUARIO', LCodigoUsuario)
                .Open
                .ToJSONObject;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

{$REGION ' SObterDataServidor '}
function TServicesUsuario.SObterDataHoraServidor: String;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
end;
{$ENDREGION}

end.
