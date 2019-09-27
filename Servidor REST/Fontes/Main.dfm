object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'Servidor HTTP indy'
  ClientHeight = 627
  ClientWidth = 742
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 199
    Width = 736
    Height = 78
    Align = alTop
    Caption = 'Servidor'
    TabOrder = 0
    ExplicitWidth = 788
    object BtnStop: TBitBtn
      Left = 110
      Top = 30
      Width = 75
      Height = 31
      Caption = 'Stop'
      Enabled = False
      TabOrder = 0
      OnClick = BtnStopClick
    end
    object BtnStart: TBitBtn
      Left = 17
      Top = 30
      Width = 75
      Height = 31
      Caption = 'Start'
      TabOrder = 1
      OnClick = BtnStartClick
    end
    object CheckBox1: TCheckBox
      Left = 217
      Top = 37
      Width = 81
      Height = 17
      Caption = 'Activar SSL'
      TabOrder = 2
      OnExit = CheckBox1Exit
    end
  end
  object GroupBox2: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 736
    Height = 122
    Align = alTop
    Caption = 'Conex'#227'o banco de dados'
    TabOrder = 1
    ExplicitWidth = 788
    object EditConBanco: TLabeledEdit
      Left = 17
      Top = 40
      Width = 584
      Height = 21
      EditLabel.Width = 76
      EditLabel.Height = 13
      EditLabel.Caption = 'Banco de dados'
      TabOrder = 0
    end
    object BitBtn1: TBitBtn
      Left = 600
      Top = 37
      Width = 89
      Height = 25
      Caption = 'Localizar'
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7CA56AC66EA46A1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7CA56A7377B07F0973A46A8362836283621F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7CA56AEA72F37FF27F6E7B6E7B6E7B6E7B0973A46A83621F7C
        1F7C1F7C1F7C1F7CA56AEA72F57FD17FB17FB17FB17F6E7B6E7B6E7B0977A46A
        1F7C1F7C1F7C1F7CA56AA56A7577D27FD27FB17FB17FB17FB17F6E7B6E7B0977
        1F7C1F7C1F7C1F7CA56A6E7BA56AF37FD17FD17FD17FB17FB17FB17F6E7B6E7B
        83621F7C1F7C1F7CA56AD27FA56A7577B47BB47BD47FB17FB17FB17F6E7BC005
        83621F7C1F7C1F7CA56AF37F6E7BA56A8362836283627577D17FB07FC0058B47
        C00583621F7C1F7CA56AF37FD27F6E7B6E7B6E7B6D7BA56A7577C0054A3F4837
        0627C0051F7C1F7CA56AF37FD27FD27FD27FD27F6E7B6E7BA56A836222120627
        621283621F7C1F7CA56AF87FF27FF37FFA7FFA7FB17FB27F6E7B6E7B010AA316
        010A1F7C1F7C1F7CA46A7377F87FF87F7377A36A8362836283628362210A810E
        1F7C1F7C1F7C1F7C1F7CC66EA56A836283621F7C1F7C1F7C1F7C210A810E010A
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CC005E105210A210AE1051F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
      TabOrder = 1
      OnClick = BitBtn1Click
    end
    object EditConServidor: TLabeledEdit
      Left = 17
      Top = 85
      Width = 121
      Height = 21
      EditLabel.Width = 40
      EditLabel.Height = 13
      EditLabel.Caption = 'Servidor'
      TabOrder = 2
    end
    object EditConPorta: TLabeledEdit
      Left = 144
      Top = 85
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = 'Porta'
      TabOrder = 3
    end
    object EditConUsername: TLabeledEdit
      Left = 271
      Top = 85
      Width = 121
      Height = 21
      EditLabel.Width = 36
      EditLabel.Height = 13
      EditLabel.Caption = 'Usu'#225'rio'
      TabOrder = 4
    end
    object EditConPassword: TLabeledEdit
      Left = 408
      Top = 85
      Width = 121
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'Senha'
      TabOrder = 5
    end
  end
  object MemoLog: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 283
    Width = 736
    Height = 341
    Align = alClient
    Lines.Strings = (
      
        '-----------------Exemplo Obter Registro-------------------------' +
        '------------'
      'GET http://localhost/banco'
      'GET http://localhost/banco?id=1'
      'GET http://localhost/fileupload'
      ''
      
        '-----------------Exemplo Deleta Registro------------------------' +
        '-------------'
      'DELETE localhost/banco?id=1000'
      ''
      
        ' -----------------Exemplo Atualizar Registro--------------------' +
        '-----------------'
      'PUT localhost/banco'
      'RAW {"ban_codigo": 1000,"ban_nome": "Banco do Brasil S."}'
      ''
      
        ' -----------------Exemplo incluir Registro----------------------' +
        '---------------'
      'POST localhost/banco'
      'RAW {"ban_codigo": 1000,"ban_nome": "Banco do Brasil S."}'
      ''
      '------------------------------NOTA -----------------------------'
      'Ferramenta utilizada para realizar os teste como cliente web'
      'Postman'
      'Baixa https://github.com/postmanlabs/postman-app-support/ ')
    ScrollBars = ssVertical
    TabOrder = 2
    ExplicitWidth = 788
  end
  object GroupBox3: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 131
    Width = 736
    Height = 62
    Align = alTop
    Caption = 'Certificado SSL'
    TabOrder = 3
    ExplicitWidth = 788
    object EdtiParthCertificos: TLabeledEdit
      Left = 17
      Top = 31
      Width = 584
      Height = 21
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = 'Path Cerftificos'
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 600
      Top = 27
      Width = 89
      Height = 25
      Caption = 'Localizar'
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7CA56AC66EA46A1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7CA56A7377B07F0973A46A8362836283621F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7CA56AEA72F37FF27F6E7B6E7B6E7B6E7B0973A46A83621F7C
        1F7C1F7C1F7C1F7CA56AEA72F57FD17FB17FB17FB17F6E7B6E7B6E7B0977A46A
        1F7C1F7C1F7C1F7CA56AA56A7577D27FD27FB17FB17FB17FB17F6E7B6E7B0977
        1F7C1F7C1F7C1F7CA56A6E7BA56AF37FD17FD17FD17FB17FB17FB17F6E7B6E7B
        83621F7C1F7C1F7CA56AD27FA56A7577B47BB47BD47FB17FB17FB17F6E7BC005
        83621F7C1F7C1F7CA56AF37F6E7BA56A8362836283627577D17FB07FC0058B47
        C00583621F7C1F7CA56AF37FD27F6E7B6E7B6E7B6D7BA56A7577C0054A3F4837
        0627C0051F7C1F7CA56AF37FD27FD27FD27FD27F6E7B6E7BA56A836222120627
        621283621F7C1F7CA56AF87FF27FF37FFA7FFA7FB17FB27F6E7B6E7B010AA316
        010A1F7C1F7C1F7CA46A7377F87FF87F7377A36A8362836283628362210A810E
        1F7C1F7C1F7C1F7C1F7CC66EA56A836283621F7C1F7C1F7C1F7C210A810E010A
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CC005E105210A210AE1051F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
      TabOrder = 1
      OnClick = BitBtn2Click
    end
  end
end
