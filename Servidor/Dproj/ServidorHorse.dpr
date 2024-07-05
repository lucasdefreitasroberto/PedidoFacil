program ServidorHorse;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in '..\fonte\UnitPrincipal.pas' {frmPrincipal},
  {$R}
  {$R}
  {$R}
  Controller.Usuario in '..\controller\Controller.Usuario.pas' {$R *.res},
  DM.Global in '..\DataModule\DM.Global.pas' {DMGlobal: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDMGlobal, DMGlobal);
  Application.Run;
end.
