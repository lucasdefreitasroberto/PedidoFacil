unit Services.Notificacoes;

interface

uses
  Horse,
  System.JSON,
  Repository.Classes.NotificacoesRepository,
  Repository.Interfaces.INotificacoesRepository,
  Controller.Auth,
  DM.Conexao,
  SQL.Notificacoes;

type
  IServicesNotificacoes = interface(IInterface)
  ['{9F7B20B5-10A9-4A1F-ADE2-FF97225D8C75}']
   function SListarNotificacoes(Req: THorseRequest): TJSONArray;
  end;

type
  TServicesNotificacoes = class(TInterfacedObject, IServicesNotificacoes)
  private
    FNotificacoesRepository : INotificacoesRepository;
  public
    constructor Create;
    destructor Destroy; override;

    function SListarNotificacoes(Req: THorseRequest): TJSONArray;
    Class function New: IServicesNotificacoes;
  end;

implementation

{ TServicesNotificacoes }


constructor TServicesNotificacoes.Create;
begin
  FNotificacoesRepository := TNotificacoesRepository.Create;
end;

destructor TServicesNotificacoes.Destroy;
begin
  FNotificacoesRepository := Nil;
  inherited;
end;

class function TServicesNotificacoes.New: IServicesNotificacoes;
begin
  Result := Self.Create;
end;

{$REGION ' SListarNotificacoes '}
function TServicesNotificacoes.SListarNotificacoes(Req: THorseRequest): TJSONArray;
begin
  Result := TNotificacoesRepository.New.RListarNotificacoes(Req);
end;
{$ENDREGION}

end.
