object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'Servidor HTTP indy'
  ClientHeight = 657
  ClientWidth = 784
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
  object GroupBox2: TGroupBox
    AlignWithMargins = True
    Left = 341
    Top = 8
    Width = 436
    Height = 121
    Caption = 'Conex'#227'o banco de dados'
    TabOrder = 1
    object EditConBanco: TLabeledEdit
      Left = 17
      Top = 40
      Width = 312
      Height = 21
      EditLabel.Width = 76
      EditLabel.Height = 13
      EditLabel.Caption = 'Banco de dados'
      TabOrder = 0
    end
    object BtnLocalizarBanco: TBitBtn
      Left = 331
      Top = 37
      Width = 84
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
      OnClick = BtnLocalizarBancoClick
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
      Width = 81
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = 'Porta'
      TabOrder = 3
    end
    object EditConUsername: TLabeledEdit
      Left = 232
      Top = 85
      Width = 88
      Height = 21
      EditLabel.Width = 36
      EditLabel.Height = 13
      EditLabel.Caption = 'Usu'#225'rio'
      TabOrder = 4
    end
    object EditConPassword: TLabeledEdit
      Left = 326
      Top = 85
      Width = 89
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'Senha'
      TabOrder = 5
    end
  end
  object MemoLog: TMemo
    AlignWithMargins = True
    Left = 5
    Top = 213
    Width = 771
    Height = 434
    Lines.Strings = (
      
        '-----------------Exemplo Obter Registro-------------------------' +
        '------------'
      'GET http://localhost/banco'
      'GET http://localhost/banco?ban_codigo=1'
      'GET http://localhost/banco?offset=50&limit=100'
      'GET http://localhost/files/imag.png'
      'GET http://localhost/files/bancos.pdf'
      'POS http://localhost/fileupload'
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
  end
  object GroupBox3: TGroupBox
    AlignWithMargins = True
    Left = 341
    Top = 135
    Width = 436
    Height = 72
    Caption = 'Certificado SSL'
    TabOrder = 3
    object BtnLocalizarCert: TBitBtn
      Left = 337
      Top = 28
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
      TabOrder = 0
      OnClick = BtnLocalizarCertClick
    end
    object EdtiParthCertificos: TLabeledEdit
      Left = 17
      Top = 31
      Width = 316
      Height = 21
      EditLabel.Width = 82
      EditLabel.Height = 13
      EditLabel.Caption = 'Path Certificados'
      TabOrder = 1
    end
  end
  object GroupBox4: TGroupBox
    Left = 3
    Top = 131
    Width = 332
    Height = 77
    Caption = 'Authentication'
    TabOrder = 4
    object Label1: TLabel
      Left = 17
      Top = 29
      Width = 49
      Height = 13
      Caption = 'UserName'
    end
    object Label3: TLabel
      Left = 161
      Top = 29
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object EditUserName: TEdit
      Left = 17
      Top = 46
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'admin'
    end
    object EditPassword: TEdit
      Left = 161
      Top = 46
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'admin'
    end
  end
  object GroupBox5: TGroupBox
    Left = 2
    Top = 8
    Width = 333
    Height = 121
    Caption = 'Settings'
    TabOrder = 0
    object Label2: TLabel
      Left = 15
      Top = 21
      Width = 48
      Height = 13
      Caption = 'Port HTTP'
    end
    object Label7: TLabel
      Left = 23
      Top = 49
      Width = 40
      Height = 13
      Caption = 'Port SSL'
    end
    object EditPortHttp: TEdit
      Left = 72
      Top = 16
      Width = 100
      Height = 21
      TabOrder = 1
      Text = '80'
    end
    object EditPortSSL: TEdit
      Left = 72
      Top = 46
      Width = 100
      Height = 21
      TabOrder = 2
      Text = '443'
    end
    object BtnStart: TBitBtn
      Left = 199
      Top = 14
      Width = 100
      Height = 31
      Caption = 'Start'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C2001800120011F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C80016112800120011F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C800162126112800120011F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C8001821682166112800120011F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C8001C21E821661126112800120011F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C8001C326A21EA21EA21E821680014001
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C8001EA2AEB2AE92AE92AE92A80014001
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C80010B2F0D370D33E92A800120011F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C80010D374F3F4F3F800120011F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C80010C335147800120011F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C8001A71E800120011F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C2001800120011F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
      ParentFont = False
      TabOrder = 0
      OnClick = BtnStartClick
    end
    object BtnStop: TBitBtn
      Left = 199
      Top = 51
      Width = 100
      Height = 31
      Caption = 'Stop'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7CAB75A250404C404C404C404C404C404C404C404C814CAB75
        1F7C1F7C1F7C1F7CA26060608160A260A260A164A264A264806460644054824C
        1F7C1F7C1F7C1F7C6064C268C368E470057104710371E270C170A0706064404C
        1F7C1F7C1F7C1F7C8068C368057126712571257103710271E270C1708064404C
        1F7C1F7C1F7C1F7CC268047147714671267125710371E370E270C170C264404C
        1F7C1F7C1F7C1F7CE470267147714671267125710371E270C270C170C264404C
        1F7C1F7C1F7C1F7C267168714871467126710571E36CC26CC26CC26CC264404C
        1F7C1F7C1F7C1F7C47718971687147710671056DE36CC268C26CC26CC264404C
        1F7C1F7C1F7C1F7C4871AA758971486D2671056DE46CE368C36CC26CC264404C
        1F7C1F7C1F7C1F7C89710D76CB75897148714671266D056D046DE468C264614C
        1F7C1F7C1F7C1F7CCB755176ED75CA758A7189716971687147712571C264C350
        1F7C1F7C1F7C1F7CCB75CB7569714771267126710571E570E468E368C360AB75
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
      ParentFont = False
      TabOrder = 3
      OnClick = BtnStopClick
    end
    object ChUserSSL: TCheckBox
      Left = 22
      Top = 87
      Width = 81
      Height = 17
      Caption = 'Activar SSL'
      TabOrder = 4
      OnClick = ChUserSSLClick
    end
    object ChAuthentication: TCheckBox
      Left = 120
      Top = 88
      Width = 103
      Height = 17
      Caption = 'Authentication '
      TabOrder = 5
      OnClick = ChAuthenticationClick
    end
  end
end
