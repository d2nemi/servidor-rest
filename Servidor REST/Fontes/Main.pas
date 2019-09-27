unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmMain = class(TForm)
    GroupBox1: TGroupBox;
    BtnStop: TBitBtn;
    BtnStart: TBitBtn;
    GroupBox2: TGroupBox;
    MemoLog: TMemo;
    EditConBanco: TLabeledEdit;
    BitBtn1: TBitBtn;
    EditConServidor: TLabeledEdit;
    EditConPorta: TLabeledEdit;
    EditConUsername: TLabeledEdit;
    EditConPassword: TLabeledEdit;
    GroupBox3: TGroupBox;
    EdtiParthCertificos: TLabeledEdit;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    procedure BtnStartClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Exit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    procedure setBtnStates;
    procedure ShowErro(const s: String; const Args: array of Const);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation


Uses uDmServer, Rest.Server, Rest.Config;

ResourceString
  STAR_ERROR = 'Ocorreu um erro tentar iniciar o servidor  ' + #$D#$A + ' %S';
  STOP_ERROR = 'Ocorreu um erro tentar parar o servidor ' + #$D#$A + ' %S';

  NOTA = '[Exemplo Obter Registro]' + #$D#$A +
    ' GET http://localhost/banco' + #$D#$A +
    ' GET http://localhost/banco?id=1' + #$D#$A +
    ' GET http://localhost/fileupload' + #$D#$A + #$D#$A +

    ' [Exemplo Deleta Registro]' + #$D#$A +
    ' DELETE localhost/banco?id=1000' + #$D#$A + #$D#$A +

    ' [Exemplo Atualizar Registro]' + #$D#$A +
    ' PUT localhost/banco' + #$D#$A +
    ' {"ban_codigo": 1000,"ban_nome": "Banco do Brasil S."}' + #$D#$A + #$D#$A +

    ' [Exemplo incluir Registro]' + #$D#$A +
    ' POST localhost/banco' + #$D#$A +
    ' {"ban_codigo": 1000,"ban_nome": "Banco do Brasil S."}' + #$D#$A + #$D#$A +

    ' [NOTA]' + #$D#$A +
    ' Exemplos executado no "Postman" como cliente http' + #$D#$A +
    ' Postman' + #$D#$A +
    ' Baixa https://github.com/postmanlabs/postman-app-support/';

{$R *.dfm}
  { TForm3 }

procedure TFrmMain.BitBtn1Click(Sender: TObject);
begin
  With TOpenDialog.Create(self) do
  begin
    Try
      if Execute then
        EditConBanco.Text := FileName;
    Finally
      Free
    End;
  end;
end;

procedure TFrmMain.BitBtn2Click(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
    try
      Options := [fdoPickFolders];
      if Execute then
         EdtiParthCertificos.Text := FileName;
    finally
      Free;
    end;

end;

procedure TFrmMain.BtnStartClick(Sender: TObject);
begin
  Try

    AppConDataBase := EditConBanco.Text;
    AppConServer := EditConServidor.Text;
    AppConPorta := EditConPorta.Text;
    AppConUsername := EditConUsername.Text;
    AppConPassword := EditConPassword.Text;
    AppDirCertFile := EdtiParthCertificos.Text;

    StartServer();
    MemoLog.Lines.Add('Servidor iniciado com sucesso ' + DateTimeToStr(now()));

  Except
    on e: exception do
      ShowErro(STAR_ERROR, [e.Message]);
  End;
  setBtnStates;
end;

procedure TFrmMain.BtnStopClick(Sender: TObject);
begin
  Try
    StopServer;
    MemoLog.Lines.Add('Servidor parado com sucesso ' + DateTimeToStr(now()))
  Except
    on e: exception do
      ShowErro(STOP_ERROR, [e.Message]);
  End;
  setBtnStates;
end;

procedure TFrmMain.CheckBox1Exit(Sender: TObject);
begin
  if CheckBox1.Checked then
    AppProtocolo := 'HTTPS'
  else
    AppProtocolo := 'HTTP';
  SaveConfig;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  MemoLog.Lines.Clear;
  MemoLog.Lines.Add(NOTA);
  LoardConfig();

  EditConBanco.Text := AppConDataBase;
  EditConServidor.Text := AppConServer;
  EditConPorta.Text := AppConPorta;
  EditConUsername.Text := AppConUsername;
  EditConPassword.Text := AppConPassword;

  CheckBox1.Checked := (UpperCase(AppProtocolo) = 'HTTPS');
  EdtiParthCertificos.Text := AppDirCertFile;

end;

procedure TFrmMain.setBtnStates;
begin
  BtnStart.Enabled := Not Server.Active;
  BtnStop.Enabled := Server.Active;
  Application.ProcessMessages;
end;

procedure TFrmMain.ShowErro(const s: String; const Args: array of Const);
begin
  MemoLog.Lines.Add(Format(s, Args))
end;

end.
