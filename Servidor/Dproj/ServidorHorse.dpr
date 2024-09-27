program ServidorHorse;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in '..\fonte\UnitPrincipal.pas' {frmPrincipal},
  DM.Conexao in '..\DataModule\DM.Conexao.pas' {DMConexao: TDataModule},
  Utilitarios in '..\Utils\Utilitarios.pas',
  Server.Horse in '..\Fonte\Server.Horse.pas',
  HashXMD5 in '..\Utils\HashXMD5.pas',
  Controller.Auth in '..\Controller\Controller.Auth.pas',
  Controller.Notificacoes in '..\Controller\Controller.Notificacoes.pas',
  Controller.Usuario in '..\controller\Controller.Usuario.pas',
  Controller.Cliente in '..\Controller\Controller.Cliente.pas',
  Controller.Produto in '..\Controller\Controller.Produto.pas',
  Controller.Pedido in '..\Controller\Controller.Pedido.pas',
  Controller.CondPagto in '..\Controller\Controller.CondPagto.pas',
  Services.Notificacoes in '..\Services\Services.Notificacoes.pas',
  Services.Usuario in '..\Services\Services.Usuario.pas',
  Services.Cliente in '..\Services\Services.Cliente.pas',
  Services.Produto in '..\Services\Services.Produto.pas',
  Services.Pedido in '..\Services\Services.Pedido.pas',
  Services.CondPagto in '..\Services\Services.CondPagto.pas',
  Classe.Conexao in '..\InfraConexao\Classe.Conexao.pas',
  Interfaces.Conexao in '..\InfraConexao\Interfaces.Conexao.pas',
  Validations.Usuario in '..\Validations\Validations.Usuario.pas',
  Validations.Cliente in '..\Validations\Validations.Cliente.pas',
  Validations.Produto in '..\Validations\Validations.Produto.pas',
  Validations in '..\Validations\Validations.pas',
  Validations.Pedido in '..\Validations\Validations.Pedido.pas',
  Interfaces.Handler in '..\Handler\Interfaces.Handler.pas',
  Classes.Handler in '..\Handler\Classes.Handler.pas',
  Repository.Interfaces.IPedidoRepository in '..\Repository\Interfaces\Repository.Interfaces.IPedidoRepository.pas',
  Repository.Classes.PedidoRepository in '..\Repository\Classes\Repository.Classes.PedidoRepository.pas',
  Repository.Interfaces.ICondPagtoRepository in '..\Repository\Interfaces\Repository.Interfaces.ICondPagtoRepository.pas',
  Repository.Classes.CondPagtoRepository in '..\Repository\Classes\Repository.Classes.CondPagtoRepository.pas',
  Repository.Classes.NotificacoesRepository in '..\Repository\Classes\Repository.Classes.NotificacoesRepository.pas',
  Repository.Interfaces.INotificacoesRepository in '..\Repository\Interfaces\Repository.Interfaces.INotificacoesRepository.pas',
  Repository.Interfaces.IClienteRepository in '..\Repository\Interfaces\Repository.Interfaces.IClienteRepository.pas',
  Repository.Classes.ClienteRepository in '..\Repository\Classes\Repository.Classes.ClienteRepository.pas',
  Repository.Interfaces.IUsuarioRepository in '..\Repository\Interfaces\Repository.Interfaces.IUsuarioRepository.pas',
  Repository.Classes.UsuarioRepository in '..\Repository\Classes\Repository.Classes.UsuarioRepository.pas',
  SQL.CondPagto in '..\SQL\SQL.CondPagto.pas',
  SQL.Notificacoes in '..\SQL\SQL.Notificacoes.pas',
  SQL.Pedido in '..\Sql\SQL.Pedido.pas',
  SQL.Cliente in '..\SQL\SQL.Cliente.pas',
  SQL.Usuario in '..\SQL\SQL.Usuario.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.


