program HttpServer;

uses
  Vcl.Forms,
  Main in 'Main.pas' {FrmMain},
  uDmServer in 'Server\uDmServer.pas' {DmServer: TDataModule},
  Client.Context in 'Server\Client.Context.pas',
  Rest.Server in 'Server\Rest.Server.pas',
  Rest.Config in 'Utils\Rest.Config.pas',
  Banco.Controle in 'Controle\Banco.Controle.pas',
  Banco.Model in 'Model\Banco.Model.pas',
  Banco.Classe in 'Classes\Banco.Classe.pas',
  Server.Methods in 'Server\Server.Methods.pas',
  Server.DB in 'Server\Server.DB.pas',
  FormDataReader in 'Utils\FormDataReader.pas',
  Rest.ConstStr in 'Utils\Rest.ConstStr.pas',
  Interfaces.Model in 'Interfaces\Interfaces.Model.pas',
  Rest.Utils in 'Utils\Rest.Utils.pas',
  Files.Download in 'Controle\Files.Download.pas',
  Files.Upload in 'Controle\Files.Upload.pas',
  uDesingerRelatorio in 'Server\uDesingerRelatorio.pas' {DesignerRelatorios: TDataModule},
  Relatorios.Classe in 'Classes\Relatorios.Classe.pas',
  User.Sessao in 'Server\User.Sessao.pas',
  Usuario.Classe in 'Classes\Usuario.Classe.pas',
  Usuario.Controle in 'Controle\Usuario.Controle.pas',
  Usuario.Model in 'Model\Usuario.Model.pas',
  Login.Controle in 'Controle\Login.Controle.pas',
  Login.Model in 'Model\Login.Model.pas',
  Login.Classe in 'Classes\Login.Classe.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TDmServer, DmServer);
  Application.CreateForm(TDesignerRelatorios, DesignerRelatorios);
  Application.Run;

end.
