unit Interfaces.Handler;

interface

uses
  Horse;

type
  // Interface genérica para lidar com requisições e respostas
  IRequestHandler<T> = interface
    ['{8A26D4FA-B5D9-4EFA-B239-9A7FE4C529F4}']
    procedure HandleRequestAndRespond(Req: THorseRequest; Res: THorseResponse);
  end;

implementation

end.

