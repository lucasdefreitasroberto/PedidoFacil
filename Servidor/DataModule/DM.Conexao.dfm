object DMConexao: TDMConexao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 109
  Width = 205
  object con: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Database=G:\Arquivos\PedidoFacil\Dados\PEDIDOFACIL.FDB'
      'Protocol=TCPIP'
      'Server=localhost'
      'Port=3050'
      'CharacterSet=ISO8859_1'
      'DriverID=FB')
    LoginPrompt = False
    BeforeConnect = conBeforeConnect
    Left = 32
    Top = 32
  end
  object FBDriverLink: TFDPhysFBDriverLink
    VendorLib = 'C:\Program Files (x86)\Firebird\Firebird_3_0\fbclient.dll'
    Left = 120
    Top = 32
  end
end
