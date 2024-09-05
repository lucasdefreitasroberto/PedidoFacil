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

  TDtUltSincVaziaValidation = class(TBaseValidation)
  private
    FData: string;
  public
    constructor Create(const Data: string);
    procedure Validate;
  end;

  TDescVazioValidation = class(TBaseValidation)
  private
    FNome: string;
  public
    constructor Create(const Nome: string);
    procedure Validate;
  end;

implementation

{ TDtUltSincronizacaoVaziaValidation }

constructor TDtUltSincVaziaValidation.Create(const Data: string);
begin
  FData := Data;
end;

procedure TDtUltSincVaziaValidation.Validate;
begin
  if (FData = EmptyStr) then
    raise EHorseException.New.Error('Parâmetro dt_ult_sincronizacao não informado')
end;

{ TNomeVazioValidation }

constructor TDescVazioValidation.Create(const Nome: string);
begin
  FNome := Nome;
end;

procedure TDescVazioValidation.Validate;
begin
  if (FNome = EmptyStr) then
    raise EHorseException.New.Error('Nome do Produto precisa ser informado').Status(THTTPStatus.PaymentRequired)
end;

end.

