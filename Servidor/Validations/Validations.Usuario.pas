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
  Validations,
  SQL.Usuario;

type

  TEmptyLoginValidation = class(TInterfacedObject, IValidation)
  private
    FValues: TArray<string>;
  public
    constructor Create(const Values: array of string);
    procedure Validate;
    class function New(Const Values: array of string): IValidation;
  end;

  TNomeEmailVaziaValidation = class(TBaseValidation)
  private
    FNome: string;
    FEmail: string;
  public
    constructor Create(const Nome, Email: string);
    procedure Validate; override;
  end;

  TLoginVerifyValidation = class(TInterfacedObject, IValidation)
  private
    FEmail: string;
    FSenha: string;
  public
    constructor Create(const Email, Senha: string);
    procedure Validate;
    class function New(const Email, Senha: string): IValidation;
  end;

  TSenhaVaziaValidation = class(TBaseValidation)
  private
    FSenha: string;
  public
    constructor Create(const Senha: string);
    procedure Validate; override;
  end;

  TSenhaTamanhoValidation = class(TInterfacedObject, IValidation)
  private
    FSenha: string;
  public
    constructor Create(const Senha: string);
    procedure Validate;
    class function New(const Senha: string): IValidation;
  end;

  TTokenPushVazioValidation = class(TInterfacedObject, IValidation)
  private
    FTokenPush: string;
  public
    constructor Create(const TokenPush: string);
    procedure Validate;
    class function New(const TokenPush: string): IValidation;
  end;

  TEmailExistenteValidation = class(TInterfacedObject, IValidation)
  private
    FEmail: string;
  public
    constructor Create(const Email: string);
    procedure Validate;
    class function New(const Email: string): IValidation;
  end;

implementation

{ TNomeEmailSenhaVaziaValidation }
constructor TEmptyLoginValidation.Create(const Values: array of string);
begin
  FValues := FValues;
end;

class function TEmptyLoginValidation.New(Const Values: array of string): IValidation;
begin
  Result := Self.Create(Values);
end;

procedure TEmptyLoginValidation.Validate;
var
  Value: string;
begin
  for Value in FValues do
  begin
    if Value.Trim.IsEmpty then
      raise EHorseException.New.Error('Informe o nome, e-mail e a senha corretamente');
  end;
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
constructor TLoginVerifyValidation.Create(const Email, Senha: string);
begin
  FEmail := Email;
  FSenha := Senha;
end;

class function TLoginVerifyValidation.New(const Email, Senha: string): IValidation;
begin
  Result := Self.Create(Email, Senha);
end;

procedure TLoginVerifyValidation.Validate;
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

class function TSenhaTamanhoValidation.New(const Senha: string): IValidation;
begin
  Result := Self.Create(Senha);
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

class function TTokenPushVazioValidation.New(const TokenPush: string): IValidation;
begin
  Result := Self.Create(TokenPush);
end;

procedure TTokenPushVazioValidation.Validate;
begin
  if FTokenPush.Trim.IsEmpty then
    raise EHorseException.New.Error('Informe o token push do usuário');
end;

{ TEmailExistenteValidation }
constructor TEmailExistenteValidation.Create(const Email: string);
begin
  FEmail := Email;
end;

class function TEmailExistenteValidation.New(const Email: string): IValidation;
begin
  Result := Self.Create(Email);
end;

procedure TEmailExistenteValidation.Validate;
var
  LCount: Integer;
  Query: IQueryExecutor;
begin
  DMConexao := TDMConexao.Create;
  try
    Query := TQueryExecutor.Create(DMConexao.con);
    LCount := Query.ExecuteScalar(SQL.Usuario.sqlValidarEmail);

    if (LCount > 0) then
      raise EHorseException.New.Error('Esse e-mail já está em uso por outra conta');
  finally
    DMConexao.Free;
  end;
end;

end.
