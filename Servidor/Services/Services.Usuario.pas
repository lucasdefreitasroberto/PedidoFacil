unit Services.Usuario;

interface

uses
  DM.Conexao;

type
  TServicesUsuario = class(TDMConexao)
  public
    function Login: string;
    function InserirUsuarios: string;
  end;

implementation

{ TServicesUsuario }

function TServicesUsuario.InserirUsuarios;
begin
  Result := '{"mensagem":  "Usuario Cadastro..."}';
end;

function TServicesUsuario.Login: string;
begin
  Result := '{"Login feito com Sucesso"}';
end;

end.
