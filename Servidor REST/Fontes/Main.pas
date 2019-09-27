unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmMain = class(TForm)
    GroupBox2: TGroupBox;
    MemoLog: TMemo;
    EditConBanco: TLabeledEdit;
    BtnLocalizarBanco: TBitBtn;
    EditConServidor: TLabeledEdit;
    EditConPorta: TLabeledEdit;
    EditConUsername: TLabeledEdit;
    EditConPassword: TLabeledEdit;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    EditUserName: TEdit;
    EditPassword: TEdit;
    GroupBox5: TGroupBox;
    Label2: TLabel;
    Label7: TLabel;
    EditPortHttp: TEdit;
    EditPortSSL: TEdit;
    BtnStart: TBitBtn;
    BtnStop: TBitBtn;
    ChUserSSL: TCheckBox;
    BtnLocalizarCert: TBitBtn;
    EdtiParthCertificos: TLabeledEdit;
    ChAuthentication: TCheckBox;
    procedure BtnStartClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnLocalizarBancoClick(Sender: TObject);
    procedure BtnLocalizarCertClick(Sender: TObject);
    procedure ChAuthenticationClick(Sender: TObject);
    procedure ChUserSSLClick(Sender: TObject);
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

{$R *.dfm}
  { TForm3 }

procedure TFrmMain.BtnLocalizarBancoClick(Sender: TObject);
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

procedure TFrmMain.BtnLocalizarCertClick(Sender: TObject);
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
    RESTPortSSL := EditPortSSL.Text;
    AppConUsername := EditConUsername.Text;
    AppConPassword := EditConPassword.Text;
    AppDirCertFile := EdtiParthCertificos.Text;
    AppAuthentication := ChAuthentication.Checked;
    AppUserSSL := ChUserSSL.Checked;

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

procedure TFrmMain.ChAuthenticationClick(Sender: TObject);
begin
  setBtnStates;
end;

procedure TFrmMain.ChUserSSLClick(Sender: TObject);
begin
  setBtnStates;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  LoardConfig();

  EditConBanco.Text := AppConDataBase;
  EditConServidor.Text := AppConServer;
  EditConPorta.Text := AppConPorta;
  EditConUsername.Text := AppConUsername;
  EditConPassword.Text := AppConPassword;
  ChAuthentication.Checked := AppAuthentication;
  ChUserSSL.Checked := AppUserSSL;
  EdtiParthCertificos.Text := AppDirCertFile;
  setBtnStates;
end;

procedure TFrmMain.setBtnStates;
begin
  BtnStart.Enabled := Not Server.Active;
  BtnStop.Enabled := Server.Active;
  EditConBanco.Enabled:=BtnStart.Enabled;
  EditConServidor.Enabled:=BtnStart.Enabled;
  EditConPorta.Enabled:=BtnStart.Enabled;
  EditConUsername.Enabled:=BtnStart.Enabled;
  EditConPassword.Enabled:=BtnStart.Enabled;
  ChUserSSL.Enabled:=BtnStart.Enabled;
  ChAuthentication.Enabled:=BtnStart.Enabled;
  EditPortHttp.Enabled:=BtnStart.Enabled;
  BtnLocalizarBanco.Enabled:=BtnStart.Enabled;

  EditPortHttp.Enabled := not (ChUserSSL.Checked) and (BtnStart.Enabled);
  EditPortSSL.Enabled  :=  (ChUserSSL.Checked) and (BtnStart.Enabled);
  EdtiParthCertificos.Enabled :=  (ChUserSSL.Checked) and (BtnStart.Enabled);
  BtnLocalizarCert.Enabled :=  (ChUserSSL.Checked) and (BtnStart.Enabled);

  EditUserName.Enabled :=  (ChAuthentication.Checked) and (BtnStart.Enabled);
  EditPassword.Enabled :=  (ChAuthentication.Checked) and (BtnStart.Enabled);

  Application.ProcessMessages;
end;

procedure TFrmMain.ShowErro(const s: String; const Args: array of Const);
begin
  MemoLog.Lines.Add(Format(s, Args))
end;

end.
