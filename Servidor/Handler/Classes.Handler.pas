unit Classes.Handler;

interface

uses
  Interfaces.Handler,
  Horse,
  Horse.Jhonson,
  system.JSON,
  Horse.HandleException,
  System.SysUtils,
  System.Classes;

type
  TRequestHandler<T> = class(TInterfacedObject, IRequestHandler<T>)
  private
    FServiceMethod: TFunc<THorseRequest, T>;

  public
    constructor Create(const AServiceMethod: TFunc<THorseRequest, T>);

    // Método para lidar com a requisição e enviar a resposta
    procedure HandleRequestAndRespond(Req: THorseRequest; Res: THorseResponse);
    destructor Destroy; override;

   // Envia a resposta com o resultado de uma função genérica
    procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<T>); overload;
    procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<TJSONObject>); overload;
    procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<TJSONArray>); overload;
    procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<string>); overload;
    procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<Integer>); overload;

//procedure SendResponse(Res: THorseResponse; const Value: T);
//procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<TJSONObject>); overload;
//procedure SendResponse(Res: THorseResponse; const Value: TJSONArray); overload;
//procedure SendResponse(Res: THorseResponse; const Value: string); overload;
  end;

implementation

{ TRequestHandler }

//TFunc<T1, TResult> é um tipo genérico que representa um ponteiro de função
//Recebe um argumento do tipo T1 (neste caso, um THorseRequest) e Retorna um valor do tipo TResult (neste caso, o tipo genérico T)..
constructor TRequestHandler<T>.Create(const AServiceMethod: TFunc<THorseRequest, T>);
begin
  FServiceMethod := AServiceMethod;
end;

destructor TRequestHandler<T>.Destroy;
begin
  FServiceMethod := nil;
  inherited;
end;

// Procedimento que lida com a requisição e envia a resposta
procedure TRequestHandler<T>.HandleRequestAndRespond(Req: THorseRequest; Res: THorseResponse);
var
  LRetorno: T;
begin
  try
    // Executa o método de serviço e obtém a resposta
    // LRetorno := FServiceMethod(Req);

    SendResponse(Res,
      function: T
      begin
        Result := FServiceMethod(Req);
      end);

    { Res.Send<T> não funciona diretamente com tipos genéricos, pois o Delphi
    realiza a verificação do tipo em tempo de compilação. Como T é genérico,
    o compilador não consegue determinar o tipo correto para o Send, resultando em erros.

    A solução é criar uma função genérica TFunc<TResult> para encapsular
    a obtenção do valor. Isso delega a responsabilidade de retornar o tipo esperado,
    permitindo trabalhar de forma mais flexível com TResult. Dessa forma,
    podemos verificar o tipo em tempo de execução e, com segurança, enviar o valor correto. }

   // SendResponse(Res, LRetorno);
  except
    on E: Exception do
    begin
      // Tratamento de erro: envia a mensagem de erro e define status como erro interno do servidor
      Res.Send(E.Message).Status(THTTPStatus.InternalServerError);
    end;
  end;
end;

procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const GetResult: TFunc<T>);
begin
{ SendResponse: A função SendResponse recebe como argumento uma função genérica (TFunc<T>)
    que, quando chamada, retorna o valor de tipo T.
  Ela então verifica o tipo do valor e faz o envio correto da resposta,
  seja TJSONObject, TJSONArray, string, ou Integer.

  Porem eu preciso de deixar essa implementação para digamos "Enganar o compilador"}

 // Res.Send<T>(Value).Status(THTTPStatus.OK);
end;

procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const GetResult: TFunc<TJSONObject>);
var
  JsonResult: TJSONObject;
begin
  // Obtém o resultado da função passada
  JsonResult := GetResult();
  // Envia o JSON na resposta
  Res.Send(JsonResult).Status(THTTPStatus.OK);
end;

procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const GetResult: TFunc<TJSONArray>);
var
  JsonArrayResult: TJSONArray;
begin
  JsonArrayResult := GetResult();
  Res.Send(JsonArrayResult).Status(THTTPStatus.OK);
end;

procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const GetResult: TFunc<string>);
var
  StringResult: string;
begin
  StringResult := GetResult();
  Res.Send(StringResult).Status(THTTPStatus.OK);
end;

procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const GetResult: TFunc<Integer>);
var
  IntegerResult: Integer;
begin
  IntegerResult := GetResult();
  Res.Send(IntToStr(IntegerResult)).Status(THTTPStatus.OK);
end;


// Método auxiliar para enviar a resposta correta baseada no tipo de T
//procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const GetResult: TFunc<TJSONObject>);
//begin
//  Res.Send(GetResult).Status(THTTPStatus.OK);
//end;
//
//procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const Value: TJSONArray);
//begin
//  Res.Send(Value).Status(THTTPStatus.OK);
//end;
//
//procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const Value: string);
//begin
//  Res.Send(Value).Status(THTTPStatus.OK);
//end;

//procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const Value: TFunc<T>);
//begin
//  Res.Send<TFunc<T>(Value).Status(THTTPStatus.OK);
//end;

// Método auxiliar para enviar a resposta correta baseada no tipo de T
//procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const Value: T);
//begin
//  // Verifica o tipo de T em tempo de execução e envia a resposta correspondente
//  if TypeInfo(T) = TypeInfo(TJSONObject) then
//     Res.Send(TJSONObject(Value)).Status(THTTPStatus.OK)
//     //Res.Send(Value as TJSONObject).Status(THTTPStatus.OK)
//  else if TypeInfo(T) = TypeInfo(TJSONArray) then
//    Res.Send(TJSONArray(Value)).Status(THTTPStatus.OK)
//  else if TypeInfo(T) = TypeInfo(string) then
//    Res.Send(string(Value)).Status(THTTPStatus.OK)
//  else
//    Res.Send('Unsupported return type').Status(THTTPStatus.BadRequest);  // Se o tipo não for suportado
//end;

end.

