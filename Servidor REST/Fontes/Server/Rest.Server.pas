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
  IdGlobalProtocols,
  Rest.Config;

Type
  TBasicAuthentication = class(TPersistent)
  private
    FPassword: String;
    FUserName: String;
    FActive: Boolean;
    FAuthRealm: Boolean;
  public
    // Constructor Create;
  Published
    Property AuthRealm: Boolean Read FAuthRealm Write FAuthRealm Default false;
    Property Active: Boolean Read FActive Write FActive Default false;
    Property UserName: String Read FUserName Write FUserName;
    Property Password: String Read FPassword Write FPassword;
  End;

Var
  Server: TIdHTTPServer;
  ServerIOHandler: TIdServerIOHandlerSSLOpenSSL;
  FSSLOptions: TIdSSLOptions;
  FBasicAuthentication: TBasicAuthentication;

Procedure StartServer;
Procedure StopServer;
procedure SetSSLOptions();

implementation

procedure BeforeStartServer();
begin

  //SetSSLOptions();
  Server.AutoStartSession := false;
  Server.SessionState := true;
  Server.ParseParams := true;
  Server.KeepAlive := true;
  Server.MaxConnections := 100;

  Server.Bindings.Clear;
  Server.Bindings.Add.Port := StrToIntDef(RESTPortHTTP, 80);
  Server.Bindings.Add.Port := StrToIntDef(RESTPortSSL, 443);
  Server.DefaultPort := StrToIntDef(RESTPortHTTP, 80);

  if (AppProtocolo = 'HTTPS')
  then
  begin
    SetSSLOptions();
    Server.IOHandler := ServerIOHandler;
  end
  else
    Server.IOHandler := nil;

end;

procedure SetSSLOptions();
begin

  if (Assigned(ServerIOHandler)) then
  begin
    ServerIOHandler.SSLOptions.SSLVersions := [sslvSSLv2, sslvSSLv3, sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    ServerIOHandler.SSLOptions.VerifyDepth := 1;
    ServerIOHandler.SSLOptions.VerifyMode := [sslvrfPeer];
    ServerIOHandler.SSLOptions.CertFile := IncludeTrailingPathDelimiter(AppDirCertFile) + 'mycert.pem';
    ServerIOHandler.SSLOptions.KeyFile := IncludeTrailingPathDelimiter(AppDirCertFile) + 'mycert.pem';
    ServerIOHandler.SSLOptions.RootCertFile := IncludeTrailingPathDelimiter(AppDirCertFile) + 'mycert.pem';;

    // Extras
    ServerIOHandler.SSLOptions.CipherList := FSSLOptions.CipherList;
    ServerIOHandler.SSLOptions.DHParamsFile := FSSLOptions.DHParamsFile;
    ServerIOHandler.SSLOptions.Method := FSSLOptions.Method;
    ServerIOHandler.SSLOptions.Mode := FSSLOptions.Mode;
    ServerIOHandler.SSLOptions.VerifyDirs := FSSLOptions.VerifyDirs;
    ServerIOHandler.SSLOptions.VerifyMode := FSSLOptions.VerifyMode;

  end;

end;

Procedure StartServer;
begin

  if Assigned(Server) then
  begin
    BeforeStartServer;

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
      Server.Active := false;

    end;

end;

{
  function Authentication(RequestInfo: TRequest; ResponseInfo: TResponse; Authentication: TBasicAuthentication): Boolean;
  begin

  Result := true;

  if
  (Authentication.Active) and
  (Assigned(RequestInfo)) and
  (Assigned(ResponseInfo))
  then
  begin
  if Not((RequestInfo.AuthUsername = Authentication.UserName) and
  (RequestInfo.AuthPassword = Authentication.Password))
  Then
  Begin
  if Authentication.AuthRealm then
  ResponseInfo.AuthRealm := 'Authentication HTTP';
  Result := False;
  End
  else
  Result := true;
  end;

  end;
}
Initialization

Server := TIdHTTPServer.Create(nil);
FBasicAuthentication := TBasicAuthentication.Create;
ServerIOHandler := TIdServerIOHandlerSSLOpenSSL.Create(nil);
FSSLOptions := TIdSSLOptions.Create;

FSSLOptions.Method := sslvSSLv23;
FSSLOptions.Mode := sslmBoth;
FSSLOptions.VerifyDepth := 1;
FSSLOptions.VerifyMode := [sslvrfPeer];

Finalization

StopServer;

if (Assigned(FSSLOptions)) then
  FreeAndNil(FSSLOptions);

if (Assigned(FBasicAuthentication)) then
  FreeAndNil(FBasicAuthentication);

if (Assigned(ServerIOHandler)) then
  FreeAndNil(ServerIOHandler);

if (Assigned(Server)) then
  FreeAndNil(Server);

end.
