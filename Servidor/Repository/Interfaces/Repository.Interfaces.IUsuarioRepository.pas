unit Repository.Interfaces.IUsuarioRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client,
  Horse.Request;

type
  IUsuarioRepository = interface
    ['{624F8693-B56D-4054-896D-0705AC50D78D}']
    function RLoginUsuario(const Email, Senha: string): TJSONObject;
    function RInserirUsuario(const Nome, Email, Senha: string): TJSONObject;
    function RUpdateTokenPush(CodigoUsuario: Integer; TokenPush: string): TJSONObject;
    function REditarUsuario(const CodigoUsuario: Integer; Nome, Email: string): TJSONObject;
    function REditarSenha(const CodigoUsuario: Integer; Senha: string): TJSONObject;
  end;

implementation

end.

