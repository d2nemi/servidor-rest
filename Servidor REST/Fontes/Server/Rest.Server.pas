unit Rest.Server;

interface

uses
  System.SysUtils,
  System.Classes,
  IdContext,
  IdBaseComponent,
  IdComponent,
  IdCustomTCPServer,
  IdCustomHTTPServer,
  IdHTTPServer,
  IdServerIOHandler,
  IdSSL,
  IdSSLOpenSSL,
  Rest.Config;

Var
  Server: TIdHTTPServer;
  FServerIOHandler: TIdServerIOHandlerSSLOpenSSL;

Procedure StartServer;
Procedure StopServer;
procedure SetSSLOptions();

implementation

procedure SetSSLOptions();
begin

  if (Assigned(FServerIOHandler)) then
  begin
    FServerIOHandler.SSLOptions.SSLVersions := [sslvSSLv2, sslvSSLv3, sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    FServerIOHandler.SSLOptions.VerifyDepth := 1;
    FServerIOHandler.SSLOptions.VerifyMode := [sslvrfPeer];
    FServerIOHandler.SSLOptions.CertFile := IncludeTrailingPathDelimiter(AppDirCertFile) + 'mycert.pem';
    FServerIOHandler.SSLOptions.KeyFile := IncludeTrailingPathDelimiter(AppDirCertFile) + 'mycert.pem';
    FServerIOHandler.SSLOptions.RootCertFile := IncludeTrailingPathDelimiter(AppDirCertFile) + 'mycert.pem';;
  end;

end;

Procedure StartServer;
begin

  if Assigned(Server) then
  begin

    if (AppProtocolo = 'HTTPS')
    then
    begin
      SetSSLOptions();
      Server.IOHandler := FServerIOHandler;
    end
    else
      Server.IOHandler := nil;

    if Not Server.Active then
    begin
      Server.Active := true;
      SaveConfig();
    end;

  end;

end;

Procedure StopServer;
begin

  if Assigned(Server) then
    if Server.Active then
    begin
      Server.StopListening;
      Server.Active := False;

    end;

end;

Initialization

FServerIOHandler := TIdServerIOHandlerSSLOpenSSL.Create(nil);
Server := TIdHTTPServer.Create(nil);

Server.AutoStartSession := False;
Server.SessionState := true;
Server.ParseParams := true;
Server.KeepAlive := true;
Server.MaxConnections := 0;
Server.Bindings.Clear;
Server.Bindings.Add.Port := RESTPortHTTP.ToInteger;
Server.Bindings.Add.Port := RESTPortSSL.ToInteger;
Server.DefaultPort := RESTPortHTTP.ToInteger;

Finalization

StopServer;

if (Assigned(FServerIOHandler)) then
  FreeAndNil(FServerIOHandler);

if (Assigned(Server)) then
  FreeAndNil(Server);

end.
