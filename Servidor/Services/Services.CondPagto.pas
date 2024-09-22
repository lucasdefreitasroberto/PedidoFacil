unit Services.CondPagto;

interface

uses
  Horse,
  System.JSON,
  Controller.Auth,
  DM.Conexao,
  Repository.Interfaces.ICondPagtoRepository,
  Repository.Classes.CondPagtoRepository;

type
  IServicesCondPagto = interface(IInterface)
    ['{B5805004-EEEE-4FD9-A4D6-15DED7A0C120}']
    function SListarCondPagto: TJSONArray;
  end;
type
  TServicesCondPagto = class(TInterfacedObject, IServicesCondPagto)
  private
    FCondPagtoRepository: ICondPagtoRepository;
  public
    destructor Destroy; override;
    constructor Create;
    function SListarCondPagto: TJSONArray;
    Class function New: IServicesCondPagto;
  end;

implementation

{ tServicesCondPagto }

constructor TServicesCondPagto.Create;
begin
  FCondPagtoRepository := TCondPagtoRepository.Create;
end;

destructor TServicesCondPagto.Destroy;
begin
  FCondPagtoRepository := nil;
  inherited;
end;

class function TServicesCondPagto.New: IServicesCondPagto;
begin
  Result := Self.Create;
end;

{$REGION ' SListarCondPagto '}
function TServicesCondPagto.SListarCondPagto: TJSONArray;
begin
  Result := FCondPagtoRepository.ListarCondPagto;
end;
{$ENDREGION}

end.

