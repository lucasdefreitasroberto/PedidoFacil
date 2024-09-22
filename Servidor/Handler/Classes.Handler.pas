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
    destructor Destroy; override;

    // M�todo para lidar com a requisi��o e enviar a resposta
    procedure HandleRequestAndRespond(Req: THorseRequest; Res: THorseResponse);

   // Envia a resposta com o resultado de uma fun��o gen�rica
    procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<T>); overload;
    procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<TJSONObject>); overload;
    procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<TJSONArray>); overload;
    procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<string>); overload;
    procedure SendResponse(Res: THorseResponse; const GetResult: TFunc<Integer>); overload;

    {**********************************************************
     Desta forma vou poder criar uma inst�ncia utilizando
    um ponteiro de fun��o, para eu n�o precisar
    de ter que passar a function como m�todo an�nimo toda vez no controller
    **********************************************************}
    class function New(AServiceMethod: T): IRequestHandler<T>;
  end;

implementation

{ TRequestHandler }
{*****************************
  por enquanto vai ficar assim....
{*****************************}

{****************************************************************************************
  TFunc<T1, TResult> � um tipo gen�rico que representa um ponteiro de fun��o
  Recebe um argumento do tipo T1 (neste caso, um THorseRequest)
  e Retorna um valor do tipo TResult (neste caso, o tipo gen�rico T)..
****************************************************************************************}
constructor TRequestHandler<T>.Create(const AServiceMethod: TFunc<THorseRequest, T>);
begin
  FServiceMethod := AServiceMethod;
end;

class function TRequestHandler<T>.New(AServiceMethod: T): IRequestHandler<T>;
begin
  Result := Self.Create(
    function(Req: THorseRequest): T
    begin
      Result := AServiceMethod;
    end);
end;

destructor TRequestHandler<T>.Destroy;
begin
  FServiceMethod := nil;
  inherited;
end;

{****************************************************************************************
 Procedimento que lida com a requisi��o e envia a resposta

 Res.Send<T> n�o funciona diretamente com tipos gen�ricos, pois o Delphi
 realiza a verifica��o do tipo em tempo de compila��o. Como T � gen�rico,
 o compilador n�o consegue determinar o tipo correto para o Send, resultando em erros.

 A solu��o � criar uma fun��o gen�rica TFunc<TResult> para encapsular
 a obten��o do valor. Isso delega a responsabilidade de retornar o tipo esperado,
 permitindo trabalhar de forma mais flex�vel com TResult.
 Dessa forma, eu posso verificar o tipo em tempo de execu��o e, com seguran�a,
 enviar o valor correto.
*****************************************************************************************}
procedure TRequestHandler<T>.HandleRequestAndRespond(Req: THorseRequest; Res: THorseResponse);
begin
  try
    SendResponse(Res,
      function: T
      begin
        Result := FServiceMethod(Req);
      end);
  except
    on E: Exception do
    begin
      Res.Send(E.Message).Status(THTTPStatus.InternalServerError);
    end;
  end;
end;

{****************************************************************************************
  SendResponse: A fun��o SendResponse recebe como argumento uma fun��o gen�rica (TFunc<T>)
    que, quando chamada, retorna o valor de tipo T.

  Ela ent�o verifica o tipo do valor e faz o envio correto da resposta,
  seja TJSONObject, TJSONArray, string, ou Integer.

  Porem eu preciso de deixar essa implementa��o para digamos "Enganar o compilador"
 ****************************************************************************************}
procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const GetResult: TFunc<T>);
begin
  // Implementar envio gen�rico para diferentes tipos
end;

procedure TRequestHandler<T>.SendResponse(Res: THorseResponse; const GetResult: TFunc<TJSONObject>);
var
  JsonResult: TJSONObject;
begin
  // Obt�m o resultado
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

end.
