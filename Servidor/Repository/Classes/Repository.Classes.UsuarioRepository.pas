unit Repository.Classes.UsuarioRepository;

interface

uses
  Repository.Interfaces.IUsuarioRepository,
  System.JSON,
  FireDAC.Comp.Client,
  Classe.Conexao,
  Interfaces.Conexao,
  System.SysUtils,
  System.Variants,
  HashXMD5;

type
  TUsuarioRepository = class(TInterfacedObject, IUsuarioRepository)
  public
    function RLoginUsuario(const Email, Senha: string): TJSONObject;
  end;

implementation

uses
  SQL.Usuario;

{ TUsuarioRepository }

function TUsuarioRepository.RLoginUsuario(const Email, Senha: string): TJSONObject;
begin
  Result := 
    TQueryFD.New
      .SQL(SQL.Usuario.sqlLogin)
      .Params('EMAIL', Email)
      .Params('SENHA', SaltPassword(Senha))
      .Open
      .ToJSONObject;
end;

end.

