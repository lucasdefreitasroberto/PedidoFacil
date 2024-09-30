unit Validations.Pedido;

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
  System.Classes, System.JSON;

type
  // Interface para validações
  IValidation = interface
    ['{D13998A5-AF83-47C8-BF7A-12C72D7A2F44}']
    procedure Validate;
  end;

  // Classe base para validações de strings
  TBaseStringValidation = class(TInterfacedObject, IValidation)
  private
    FValues: TArray<string>;
    FErrorMessage: string;
  public
    constructor Create(const Values: TArray<string>; const ErrorMessage: string);
    procedure Validate;
    class function New(const Values: TArray<string>; const ErrorMessage: string): IValidation;
  end;

  // Validação de Data Vazia
  TDateEmptyValidation = class(TBaseStringValidation)
  public
    class function New(const Data: string): IValidation;
  end;

  // Validação de Itens Vazio no Pedido
  TItensEmptyValidation = class(TInterfacedObject, IValidation)
  private
    FItem: TJSONArray;
  public
    constructor Create(Item: TJSONArray);
    procedure Validate;
    class function New(Item: TJSONArray): IValidation;
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

{ TDateEmptyValidation }

class function TDateEmptyValidation.New(const Data: string): IValidation;
begin
  Result := TBaseStringValidation.New([Data], 'Parâmetro dt_ult_sincronizacao não informado');
end;

{ TItensEmptyValidation }

constructor TItensEmptyValidation.Create(Item: TJSONArray);
begin
  FItem := Item;
end;

class function TItensEmptyValidation.New(Item: TJSONArray): IValidation;
begin
  Result := Self.Create(Item);
end;

procedure TItensEmptyValidation.Validate;
begin
  if FItem.Count = 0 then
    raise EHorseException.New.Error('O pedido deve conter no mínimo 1 produto');
end;

end.

