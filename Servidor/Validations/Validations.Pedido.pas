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
  IValidation = interface
    ['{D13998A5-AF83-47C8-BF7A-12C72D7A2F44}']
    procedure Validate;
  end;

type
  TDateEmptyValidation = class(TInterfacedObject, IValidation)
  private
    FData: string;
  public
    constructor Create(Data: string);
    procedure Validate;
  end;

type
  TItensEmptyValidation = class(TInterfacedObject, IValidation)
  private
    FItem: TJSONArray;
  public
    constructor Create(Item: TJSONArray);
    procedure Validate;
  end;
implementation

{ TDtUltSincVaziaValidation }

constructor TDateEmptyValidation.Create(Data: string);
begin
  FData := Data;
end;

procedure TDateEmptyValidation.Validate;
begin
   if (FData = EmptyStr) then
    raise EHorseException.New.Error('Parâmetro dt_ult_sincronizacao não informado')
end;

{ TItensEmptyValidation }

constructor TItensEmptyValidation.Create(Item: TJSONArray);
begin
  FItem := Item
end;

procedure TItensEmptyValidation.Validate;
begin
  if FItem.Size = 0 then
    raise EHorseException.New.Error('O pedido deve conter no mínimo 1 produto')
end;

end.
