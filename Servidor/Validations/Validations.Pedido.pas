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
  System.Classes;

type
  IDateEmptyValidation = interface
    ['{D13998A5-AF83-47C8-BF7A-12C72D7A2F44}']
    procedure Validate;
  end;

type
  TDateEmptyValidation = class(TInterfacedObject, IDateEmptyValidation)
  private
    FData: string;
  public
    constructor Create(Data: string);
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

end.
