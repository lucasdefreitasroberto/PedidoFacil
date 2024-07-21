unit DM.Conexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.FB, System.IniFiles, Vcl.Dialogs, Vcl.Forms,
  FireDAC.VCLUI.Wait, DataSet.Serialize.Config;

type
  TDMConexao = class(TDataModule)
    con: TFDConnection;
    FBDriverLink: TFDPhysFBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure conBeforeConnect(Sender: TObject);
  private
    { Private declarations }
    procedure HandleConnectionError(E: Exception);
    procedure ConnectToDatabase;
    procedure CarregarConfigDB(Connection: TFDConnection);
    procedure ConfigDataSetSerialize;
  public
   constructor Create; reintroduce;
  end;

var
  DMConexao: TDMConexao;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

constructor TDMConexao.Create;
begin
  inherited Create(nil);
end;

procedure TDMConexao.DataModuleCreate(Sender: TObject);
begin
  Self.ConfigDataSetSerialize();
  Self.ConnectToDatabase();
end;

procedure TDMConexao.conBeforeConnect(Sender: TObject);
begin
   CarregarConfigDB(con);
end;

procedure TDMConexao.ConfigDataSetSerialize;
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

procedure TDMConexao.ConnectToDatabase;
begin
  try
    con.Connected := True;
  except
    on E: Exception do
      HandleConnectionError(E);
  end;
end;

procedure TDMConexao.HandleConnectionError(E: Exception);
begin
  var
  auxError := Copy(E.Message, 20, 500);

  MessageDlg('Erro ao conectar com o banco de dados.' + sLineBreak + 'Motivo:' +
    sLineBreak + auxError, TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
end;

procedure TDMConexao.CarregarConfigDB(Connection: TFDConnection);
var
    ini : TIniFile;
    arq: string;
begin
  try
    arq := ExtractFilePath(ParamStr(0)) + 'config.ini';   // Caminho do INI...

    if not FileExists(arq) then  // Validar arquivo INI...
      raise Exception.Create('Arquivo INI não encontrado: ' + arq);

    ini := TIniFile.Create(arq);   // Instanciar arquivo INI...
    Connection.DriverName := ini.ReadString('Banco de Dados', 'DriverID', '');

    with Connection.Params do   // Buscar dados do arquivo fisico...
    begin
      Clear;
      Add('DriverID=' + ini.ReadString('Banco de Dados', 'DriverID', ''));
      Add('Database=' + ini.ReadString('Banco de Dados', 'Database', ''));
      Add('User_Name=' + ini.ReadString('Banco de Dados', 'User_name', ''));
      Add('Password=' + ini.ReadString('Banco de Dados', 'Password', ''));

      if ini.ReadString('Banco de Dados', 'Port', '') <> '' then
        Add('Port=' + ini.ReadString('Banco de Dados', 'Port', ''));

      if ini.ReadString('Banco de Dados', 'Server', '') <> '' then
        Add('Server=' + ini.ReadString('Banco de Dados', 'Server', ''));

      if ini.ReadString('Banco de Dados', 'Protocol', '') <> '' then
        Add('Protocol=' + ini.ReadString('Banco de Dados', 'Protocol', ''));

      if ini.ReadString('Banco de Dados', 'VendorLib', '') <> '' then
        FBDriverLink.VendorLib := ini.ReadString('Banco de Dados', 'VendorLib', '');
    end;

  finally
    if Assigned(ini) then
      ini.DisposeOf;
  end;
end;

end.
