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
  end;

implementation

end.

