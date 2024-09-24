program ServidorHorse;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in '..\fonte\UnitPrincipal.pas' {frmPrincipal},
  Controller.Usuario in '..\controller\Controller.Usuario.pas' {DM.Conexao in '..\DataModule\DM.Conexao.pas' {DMConexao: TDataModule},
  DM.Conexao in '..\DataModule\DM.Conexao.pas' {DMConexao: TDataModule},
  Utilitarios in '..\Utils\Utilitarios.pas',
  Services.Usuario in '..\Services\Services.Usuario.pas',
  Server.Horse in '..\Fonte\Server.Horse.pas',
  HashXMD5 in '..\Utils\HashXMD5.pas',
  Controller.Auth in '..\Controller\Controller.Auth.pas',
  Controller.Notificacoes in '..\Controller\Controller.Notificacoes.pas',
  Services.Notificacoes in '..\Services\Services.Notificacoes.pas',
  Controller.Cliente in '..\Controller\Controller.Cliente.pas',
  Services.Cliente in '..\Services\Services.Cliente.pas',
  Classe.Conexao in '..\InfraConexao\Classe.Conexao.pas',
  Interfaces.Conexao in '..\InfraConexao\Interfaces.Conexao.pas',
  Validations.Usuario in '..\Validations\Validations.Usuario.pas',
  Validations.Cliente in '..\Validations\Validations.Cliente.pas',
  Controller.Produto in '..\Controller\Controller.Produto.pas',
  Services.Produto in '..\Services\Services.Produto.pas',
  Validations.Produto in '..\Validations\Validations.Produto.pas',
  Validations in '..\Validations\Validations.pas',
  Controller.Pedido in '..\Controller\Controller.Pedido.pas',
  Services.Pedido in '..\Services\Services.Pedido.pas',
  SQL.Pedido in '..\Sql\SQL.Pedido.pas',
  Validations.Pedido in '..\Validations\Validations.Pedido.pas',
  Interfaces.Handler in '..\Handler\Interfaces.Handler.pas',
  Classes.Handler in '..\Handler\Classes.Handler.pas',
  Repository.Interfaces.IPedidoRepository in '..\Repository\Interfaces\Repository.Interfaces.IPedidoRepository.pas',
  Repository.Classes.PedidoRepository in '..\Repository\Classes\Repository.Classes.PedidoRepository.pas',
  Controller.CondPagto in '..\Controller\Controller.CondPagto.pas',
  Services.CondPagto in '..\Services\Services.CondPagto.pas',
  Repository.Interfaces.ICondPagtoRepository in '..\Repository\Interfaces\Repository.Interfaces.ICondPagtoRepository.pas',
  Repository.Classes.CondPagtoRepository in '..\Repository\Classes\Repository.Classes.CondPagtoRepository.pas',
  SQL.CondPagto in '..\SQL\SQL.CondPagto.pas',
  SQL.Notificacoes in '..\SQL\SQL.Notificacoes.pas',
  Repository.Classes.NotificacoesRepository in '..\Repository\Classes\Repository.Classes.NotificacoesRepository.pas',
  Repository.Interfaces.INotificacoesRepository in '..\Repository\Interfaces\Repository.Interfaces.INotificacoesRepository.pas',
  SQL.Cliente in '..\SQL\SQL.Cliente.pas',
  Repository.Interfaces.IClienteRepository in '..\Repository\Interfaces\Repository.Interfaces.IClienteRepository.pas',
  Repository.Classes.ClienteRepository in '..\Repository\Classes\Repository.Classes.ClienteRepository.pas',
  SQL.Usuario in '..\SQL\SQL.Usuario.pas',
  Repository.Interfaces.IUsuarioRepository in '..\Repository\Interfaces\Repository.Interfaces.IUsuarioRepository.pas',
  Repository.Classes.UsuarioRepository in '..\Repository\Classes\Repository.Classes.UsuarioRepository.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  Application.Run;
end.
