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
  // Interface para validações
  IValidation = interface
    ['{A1C5F19F-5B7D-4D19-A6BB-5AD3BA7BCF39}']
    procedure Validate;
  end;

  // Classe base para validações de strings implementando IValidation
  TBaseStringValidation = class(TInterfacedObject, IValidation)
  private
    FValues: TArray<string>;
    FErrorMessage: string;
  public
    constructor Create(const Values: TArray<string>; const ErrorMessage: string);
    procedure Validate;
    class function New(const Values: TArray<string>; const ErrorMessage: string): IValidation;
  end;

  // Validação de Login
  TEmptyLoginValidation = class(TBaseStringValidation)
  public
    class function New(const Values: TArray<string>): IValidation;
  end;

  // Validação de Nome e Email vazios
  TNomeEmailVaziaValidation = class(TBaseStringValidation)
  public
    class function New(const Nome, Email: string): IValidation;
  end;

  // Validação de Login com Email e Senha
  TLoginVerifyValidation = class(TBaseStringValidation)
  public
    class function New(const Email, Senha: string): IValidation;
  end;

  // Validação de Senha vazia
  TSenhaValidation = class(TBaseStringValidation)
  public
    class function New(const Senha: string): IValidation;
  end;

  // Validação de tamanho da Senha
  TSenhaTamanhoValidation = class(TInterfacedObject, IValidation)
  private
    FSenha: string;
  public
    constructor Create(const Senha: string);
    procedure Validate;
    class function New(const Senha: string): IValidation;
  end;

  // Validação de Token Push vazio
  TTokenPushVazioValidation = class(TBaseStringValidation)
  public
    class function New(const TokenPush: string): IValidation;
  end;

  // Validação de Email Existente
  TEmailExistenteValidation = class(TInterfacedObject, IValidation)
  private
    FEmail: string;
  public
    constructor Create(const Email: string);
    procedure Validate;
    class function New(const Email: string): IValidation;
  end;

implementation

{ TBaseStringValidation }

constructor TBaseStringValidation.Create(const Values: TArray<string>; const ErrorMessage: string);
begin
  FValues := Values;
  FErrorMessage := ErrorMessage;
end;

class function TBaseStringValidation.New(const Values: TArray<string>; const ErrorMessage: string): IValidation;
begin
  Result := Self.Create(Values, ErrorMessage);
end;

procedure TBaseStringValidation.Validate;
var
  Value: string;
begin
  for Value in FValues do
  begin
    if Value.Trim.IsEmpty then
      raise EHorseException.New.Error(FErrorMessage);
  end;
end;

{ TEmptyLoginValidation }

class function TEmptyLoginValidation.New(const Values: TArray<string>): IValidation;
begin
  Result := TBaseStringValidation.New(Values, 'Informe o nome, e-mail e a senha corretamente');
end;

{ TNomeEmailVaziaValidation }

class function TNomeEmailVaziaValidation.New(const Nome, Email: string): IValidation;
begin
  Result := TBaseStringValidation.New([Nome, Email], 'Informe o nome e o e-mail');
end;

{ TLoginVerifyValidation }

class function TLoginVerifyValidation.New(const Email, Senha: string): IValidation;
begin
  Result := TBaseStringValidation.New([Email, Senha], 'Informe o e-mail e a senha');
end;

{ TSenhaValidation }

class function TSenhaValidation.New(const Senha: string): IValidation;
begin
  Result := TBaseStringValidation.New([Senha], 'Informe a senha do usuário');
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

class function TTokenPushVazioValidation.New(const TokenPush: string): IValidation;
begin
  Result := TBaseStringValidation.New([TokenPush], 'Informe o token push do usuário');
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
  Query: TQueryExecutor;
  DMConexao: TDMConexao;
begin
  DMConexao := TDMConexao.Create;
  try
    Query := TQueryExecutor.Create(DMConexao.con);
    try
      LCount := Query.ExecuteScalar(SQL.Usuario.sqlValidarEmail);

      if LCount > 0 then
        raise EHorseException.New.Error('Esse e-mail já está em uso por outra conta');
    finally
      FreeAndNil(Query);  // Certifique-se de liberar o Query
    end;
  finally
    DMConexao.Free;  // Libere a conexão corretamente
  end;
end;

end.

