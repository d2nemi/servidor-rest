object DesignerRelatorios: TDesignerRelatorios
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 348
  Width = 665
  object DesignerRelatorio: TfrxReport
    Version = '6.2.1'
    DotMatrixReport = False
    EngineOptions.DoublePass = True
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Padr'#65533'o'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.Author = 'Datta System Inform'#225'tica'
    ReportOptions.CreateDate = 38674.618055555500000000
    ReportOptions.Name = 'Usuarios Web'
    ReportOptions.LastChange = 43733.764547754630000000
    ScriptLanguage = 'PascalScript'
    StoreInDFM = False
    Left = 216
    Top = 64
  end
  object DesignerDBDataSet: TfrxDBDataset
    UserName = 'DBRelatorio'
    CloseDataSource = False
    FieldAliases.Strings = (
      'BAN_CODIGO=BAN_CODIGO'
      'BAN_NOME=BAN_NOME')
    DataSet = QrDesigner
    BCDToCurrency = False
    Left = 384
    Top = 64
  end
  object DesignerConexao: TFDConnection
    Params.Strings = (
      
        'Database=E:\'#193'rea de Trabalho\Teste HttpServer\IdHTTServer\Servid' +
        'or REST\Banco\EMPLOYEE.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3055'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 216
    Top = 136
  end
  object QrDesigner: TFDQuery
    Active = True
    Connection = DesignerConexao
    SQL.Strings = (
      'SELECT * FROM BANCO')
    Left = 376
    Top = 136
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 384
    Top = 224
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 208
    Top = 224
  end
end
