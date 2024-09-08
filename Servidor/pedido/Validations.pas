unit Validations;

interface

type
  IValidation = interface
    ['{4C6E3F8E-BCEA-4B9F-ABCF-921F23EB1D5F}']
    procedure Validate;
  end;

  TBaseValidation = class abstract(TInterfacedObject, IValidation)
  public
    procedure Validate; virtual; abstract;
  end;

implementation

end.

