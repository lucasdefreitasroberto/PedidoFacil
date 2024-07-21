unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo;

type
  TfrmPrincipal = class(TForm)
    Label1: TLabel;
    mmo: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  Server.Horse;

{$R *.fmx}

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
 {******************************************************
  Por enquantou vou deixar desta forma, porem mudarei esse Registrar Rotas
 *******************************************************}
  TServerHorse.RegisterRoutes;
  TServerHorse.StartServer(9000);

  mmo.Lines.Add('Servidor executando na porta: ' + TServerHorse.PortRunner);
end;

end.
