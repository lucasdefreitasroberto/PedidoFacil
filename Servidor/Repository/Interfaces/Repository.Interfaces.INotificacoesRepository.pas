unit Repository.Interfaces.INotificacoesRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client,
  Horse.Request;
type
  INotificacoesRepository = interface
  ['{FE441B68-DF85-4572-88B3-27785B52C75A}']
     function RListarNotificacoes(Req: THorseRequest): TJSONArray;
  end;
implementation

end.
