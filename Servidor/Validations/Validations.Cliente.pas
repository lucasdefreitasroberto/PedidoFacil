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

  TDtUltSincVaziaValidation = class(TInterfacedObject, IValidation)
  private
    FData: string;
  public
    constructor Create(const Data: string);
    procedure Validate;
    class function New(const Data: string): IValidation;
  end;

  TInserirClienteValidation = class(TInterfacedObject, IValidation)
  private
    FNome: string;
  public
    constructor Create(const Nome: string);
    procedure Validate;
    class function New(const Nome: string): IValidation;
  end;

implementation

{ TDtUltSincronizacaoVaziaValidation }

constructor TDtUltSincVaziaValidation.Create(const Data: string);
begin
  FData := Data;
end;

class function TDtUltSincVaziaValidation.New(const Data: string): IValidation;
begin
  Result := Self.Create(Data);
end;

procedure TDtUltSincVaziaValidation.Validate;
begin
  if (FData = EmptyStr) then
    raise EHorseException.New.Error('Parâmetro dt_ult_sincronizacao não informado')
end;

{ TInserirClienteValidation }

constructor TInserirClienteValidation.Create(const Nome: string);
begin
  FNome := Nome;
end;

class function TInserirClienteValidation.New(const Nome: string): IValidation;
begin
  Result := Self.Create(Nome);
end;

procedure TInserirClienteValidation.Validate;
begin
  if (FNome = EmptyStr) then
    raise EHorseException.New.Error('Nome do cliente precisa ser informado')
end;

end.

