unit Validations.Cliente;

interface

uses
  System.SysUtils,
  Horse.Exception,
  Classe.Conexao,
  utilitarios,
  DM.Conexao,
  FireDAC.Comp.Client,
  Horse.Commons,
  Validations;

type

  TDtUltSincVaziaValidation = class(TBaseValidation)
  private
    FData: string;
  public
    constructor Create(const Data: string);
    procedure Validate; override;
  end;

  TNomeVazioValidation = class(TBaseValidation)
  private
    FNome: string;
  public
    constructor Create(const Nome: string);
    procedure Validate; override;
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
    raise EHorseException.New.Error('Par�metro dt_ult_sincronizacao n�o informado')
end;

{ TNomeVazioValidation }

constructor TNomeVazioValidation.Create(const Nome: string);
begin
  FNome := Nome;
end;

procedure TNomeVazioValidation.Validate;
begin
  if (FNome = EmptyStr) then
    raise EHorseException.New.Error('Nome do cliente precisa ser informado')
end;

end.

