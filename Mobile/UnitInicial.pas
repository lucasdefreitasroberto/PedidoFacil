unit UnitInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  ACBr.Android.Sunmi.Printer;

type
  TfrmInicial = class(TForm)
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    lyt1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lyt2: TLayout;
    btnProximo1: TSpeedButton;
    Label3: TLabel;
    StyleBook1: TStyleBook;
    Layout1: TLayout;
    Image2: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Layout2: TLayout;
    btnVoltar2: TSpeedButton;
    btnProximo2: TSpeedButton;
    Layout3: TLayout;
    Image3: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Layout4: TLayout;
    btnVoltar3: TSpeedButton;
    btnProximo3: TSpeedButton;
    Layout5: TLayout;
    Layout6: TLayout;
    btnAcessar: TSpeedButton;
    btnCriar: TSpeedButton;
    Image4: TImage;
    Label10: TLabel;
    procedure BtnNavegar(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAcessarClick(Sender: TObject);
    procedure btnCriarClick(Sender: TObject);
  private
    procedure AbrirAba(index: Integer);

  public
  end;

var
  frmInicial: TfrmInicial;

implementation

uses
  UnitLogin;

{$R *.fmx}

procedure TfrmInicial.AbrirAba(index: Integer);
begin
  TabControl.GotoVisibleTab(index);
end;

procedure TfrmInicial.btnAcessarClick(Sender: TObject);
begin
  if not Assigned(frmLogin) then
    Application.CreateForm(TfrmLogin, frmLogin);

  frmLogin.Show;
end;

procedure TfrmInicial.btnCriarClick(Sender: TObject);
begin
  if not Assigned(frmLogin) then
    Application.CreateForm(TfrmLogin, frmLogin);

  frmLogin.Show;
end;

procedure TfrmInicial.BtnNavegar(Sender: TObject);
begin
  AbrirAba(TSpeedButton(Sender).Tag);
end;

procedure TfrmInicial.FormCreate(Sender: TObject);
begin
  AbrirAba(0);
end;

end.

