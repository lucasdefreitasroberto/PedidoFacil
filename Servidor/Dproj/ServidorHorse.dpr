program ServidorHorse;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in '..\fonte\UnitPrincipal.pas' {frmPrincipal},
  Controller.Usuario in '..\controller\Controller.Usuario.pas' {,
  DM.Conexao in '..\DataModule\DM.Conexao.pas' {DMConexao: TDataModule},
  DM.Conexao in '..\DataModule\DM.Conexao.pas' {DMConexao: TDataModule},
  Utilitarios in '..\Utils\Utilitarios.pas',
  Services.Usuario in '..\Services\Services.Usuario.pas',
  Server.Horse in '..\Fonte\Server.Horse.pas',
  HashXMD5 in '..\Utils\HashXMD5.pas',
  Controller.Auth in '..\Controller\Controller.Auth.pas',
  Interfaces.Conexao in '..\Utils\Interfaces.Conexao.pas',
  Classe.Conexao in '..\Utils\Classe.Conexao.pas',
  Controller.Notificacoes in '..\Controller\Controller.Notificacoes.pas',
  Services.Notificacoes in '..\Services\Services.Notificacoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
