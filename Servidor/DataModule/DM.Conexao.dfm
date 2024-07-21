object DMConexao: TDMConexao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 109
  Width = 205
  object con: TFDConnection
    BeforeConnect = conBeforeConnect
    Left = 32
    Top = 32
  end
  object FBDriverLink: TFDPhysFBDriverLink
    Left = 120
    Top = 32
  end
end
