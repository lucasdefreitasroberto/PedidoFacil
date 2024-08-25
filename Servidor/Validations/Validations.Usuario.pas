unit Validations.Usuario;

interface

uses
  System.SysUtils,
  Horse.Exception,
  Classe.Conexao,
  Utilitarios,
  DM.Conexao,
  FireDAC.Comp.Client,
  Horse.Commons,
  Validations;

type

  TNomeEmailSenhaVaziaValidation = class(TBaseValidation)
  private
    FNome: string;
    FEmail: string;
    FSenha: string;
  public
    constructor Create(const Nome, Email, Senha: string);
    procedure Validate; override;
  end;

  TNomeEmailVaziaValidation = class(TBaseValidation)
  private
    FNome: string;
    FEmail: string;
  public
    constructor Create(const Nome, Email: string);
    procedure Validate; override;
  end;

  TEmailSenhaVaziaValidation = class(TBaseValidation)
  private
    FEmail: string;
    FSenha: string;
  public
    constructor Create(const Email, Senha: string);
    procedure Validate; override;
  end;

  TSenhaVaziaValidation = class(TBaseValidation)
  private
    FSenha: string;
  public
    constructor Create(const Senha: string);
    procedure Validate; override;
  end;

  TSenhaTamanhoValidation = class(TBaseValidation)
  private
    FSenha: string;
  public
    constructor Create(const Senha: string);
    procedure Validate; override;
  end;

  TTokenPushVazioValidation = class(TBaseValidation)
  private
    FTokenPush: string;
  public
    constructor Create(const TokenPush: string);
    procedure Validate; override;
  end;

  TEmailExistenteValidation = class(TBaseValidation)
  private
    FEmail: string;
    FCon: TFDConnection;
  public
    constructor Create(const Email: string; AConnection: TFDConnection);
    procedure Validate; override;
  end;

implementation

{ TNomeEmailSenhaVaziaValidation }
constructor TNomeEmailSenhaVaziaValidation.Create(const Nome, Email,
  Senha: string);
begin
  FNome := Nome;
  FEmail := Email;
  FSenha := Senha;
end;

procedure TNomeEmailSenhaVaziaValidation.Validate;
begin
  if (FNome.Trim.IsEmpty) or (FEmail.Trim.IsEmpty) or (FSenha.Trim.IsEmpty) then
    raise EHorseException.New.Error('Informe o nome, e-mail e a senha');
end;

{ TNomeEmailVaziaValidation }
constructor TNomeEmailVaziaValidation.Create(const Nome, Email: string);
begin
  FNome := Nome;
  FEmail := Email;
end;

procedure TNomeEmailVaziaValidation.Validate;
begin
  if (FNome.Trim.IsEmpty) or (FEmail.Trim.IsEmpty) then
    raise EHorseException.New.Error('Informe o nome e o e-mail');
end;


{ TEmailSenhaVaziaValidation }
constructor TEmailSenhaVaziaValidation.Create(const Email, Senha: string);
begin
  FEmail := Email;
  FSenha := Senha;
end;

procedure TEmailSenhaVaziaValidation.Validate;
begin
  if (FEmail.Trim.IsEmpty) or (FSenha.Trim.IsEmpty) then
    raise EHorseException.New.Error('Informe o e-mail e a senha');
end;

{ TSenhaVaziaValidation }
constructor TSenhaVaziaValidation.Create(const Senha: string);
begin
  FSenha := Senha;
end;

procedure TSenhaVaziaValidation.Validate;
begin
  if FSenha.Trim.IsEmpty then
    raise EHorseException.New.Error('Informe a senha do usuário');
end;

{ TSenhaTamanhoValidation }
constructor TSenhaTamanhoValidation.Create(const Senha: string);
begin
  FSenha := Senha;
end;

procedure TSenhaTamanhoValidation.Validate;
begin
  if FSenha.Length < 5 then
    raise EHorseException.New.Error('A senha deve ter no mínimo 5 caracteres').Status(THTTPStatus.BadRequest);
end;


{ TTokenPushVazioValidation }
constructor TTokenPushVazioValidation.Create(const TokenPush: string);
begin
  FTokenPush := TokenPush;
end;

procedure TTokenPushVazioValidation.Validate;
begin
  if FTokenPush.Trim.IsEmpty then
    raise EHorseException.New.Error('Informe o token push do usuário');
end;

{ TEmailExistenteValidation }
constructor TEmailExistenteValidation.Create(const Email: string; AConnection: TFDConnection);
begin
  FEmail := Email;
  FCon := AConnection;
end;

procedure TEmailExistenteValidation.Validate;
begin
  var LSQL := 'select count(*) AS EmailCount ' +
              'from USUARIO ' +
              'where EMAIL = '+
              QuotedStr(FEmail);

  var Query := TQueryExecutor.Create(FCon);
  try
    var LCount := Query.ExecuteScalar(LSQL);

    if (LCount > 0) then
      raise EHorseException.New.Error('Esse e-mail já está em uso por outra conta');
  finally
    Query.Free;
  end;
end;

end.
