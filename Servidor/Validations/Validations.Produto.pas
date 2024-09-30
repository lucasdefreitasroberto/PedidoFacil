unit Validations.Produto;

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
  System.Classes;

type
  // Interface para validações
  IValidation = interface
    ['{D13998A5-AF83-47C8-BF7A-12C72D7A2F44}']
    procedure Validate;
  end;

  // Classe base para validações de strings
  TBaseStringValidation = class(TInterfacedObject, IValidation)
  private
    FValue: string;
    FErrorMessage: string;
  public
    constructor Create(const Value: string; const ErrorMessage: string);
    procedure Validate;
    class function New(const Value: string; const ErrorMessage: string): IValidation;
  end;

  // Validação para Data de Sincronização Vazia
  TDtUltSincVaziaValidation = class(TBaseStringValidation)
  public
    class function New(const Data: string): IValidation;
  end;

  // Validação para Descrição do Produto Vazia
  TDescVazioValidation = class(TBaseStringValidation)
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
  Result := TBaseStringValidation.New(Data, 'Parâmetro dt_ult_sincronizacao não informado');
end;

{ TDescVazioValidation }

class function TDescVazioValidation.New(const Nome: string): IValidation;
begin
  Result := TBaseStringValidation.New(Nome, 'Nome do Produto precisa ser informado');
end;

end.

