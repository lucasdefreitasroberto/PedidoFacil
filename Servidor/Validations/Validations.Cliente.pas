unit Validations.Cliente;

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
  // Interface para valida��es
  IValidation = interface
    ['{A1C5F19F-5B7D-4D19-A6BB-5AD3BA7BCF39}']
    procedure Validate;
  end;

  // Classe base para valida��es de strings
  TBaseStringValidation = class(TInterfacedObject, IValidation)
  private
    FValue: string;
    FErrorMessage: string;
  public
    constructor Create(const Value: string; const ErrorMessage: string);
    procedure Validate;
    class function New(const Value: string; const ErrorMessage: string): IValidation;
  end;

  // Valida��o para a Data de Sincroniza��o
  TDtUltSincVaziaValidation = class(TBaseStringValidation)
  public
    class function New(const Data: string): IValidation;
  end;

  // Valida��o para Nome do Cliente
  TInserirClienteValidation = class(TBaseStringValidation)
  public
    class function New(const Nome: string): IValidation;
  end;

implementation

{ TBaseStringValidation }

constructor TBaseStringValidation.Create(const Value: string; const ErrorMessage: string);
begin
  FValue := Value;
  FErrorMessage := ErrorMessage;
end;

class function TBaseStringValidation.New(const Value: string; const ErrorMessage: string): IValidation;
begin
  Result := Self.Create(Value, ErrorMessage);
end;

procedure TBaseStringValidation.Validate;
begin
  if FValue.Trim.IsEmpty then
    raise EHorseException.New.Error(FErrorMessage);
end;

{ TDtUltSincVaziaValidation }

class function TDtUltSincVaziaValidation.New(const Data: string): IValidation;
begin
  Result := TBaseStringValidation.New(Data, 'Par�metro dt_ult_sincronizacao n�o informado');
end;

{ TInserirClienteValidation }

class function TInserirClienteValidation.New(const Nome: string): IValidation;
begin
  Result := TBaseStringValidation.New(Nome, 'Nome do cliente precisa ser informado');
end;

end.

