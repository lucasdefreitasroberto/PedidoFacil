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

  TDtSincVaziaValidation = class(TBaseValidation)
  private
    FData: string;
  public
    constructor Create(Data: string);
    procedure Validate;
  end;
implementation

{ TDtUltSincVaziaValidation }

constructor TDtSincVaziaValidation.Create(Data: string);
begin
  FData := Data;
end;

procedure TDtSincVaziaValidation.Validate;
begin
   if (FData = EmptyStr) then
    raise EHorseException.New.Error('Parâmetro dt_ult_sincronizacao não informado')
end;

end.
