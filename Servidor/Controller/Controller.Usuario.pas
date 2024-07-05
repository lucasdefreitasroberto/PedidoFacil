unit Controller.Usuario;

interface

uses
  Horse, Horse.Jhonson, Horse.CORS;

procedure RegistrarRotas;

procedure InserirUsuarios(Req: THorseRequest; Res: THorseResponse);
procedure Login(Req: THorseRequest; Res: THorseResponse);

implementation

procedure InserirUsuarios(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('{"mensagem":  "Usuario Cadastro..."}');
end;

procedure Login(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('{"erro":  "E-mail ou senha inválida..."}').Status(THTTPStatus.Unauthorized);
end;

procedure RegistrarRotas;
begin
  THorse
    .Post('/usuarios', InserirUsuarios)
    .Post('/usuarios/login', Login)
end;
end.

