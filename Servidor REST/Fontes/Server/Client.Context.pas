unit Client.Context;

interface

Uses
  System.Json,
  Rest.Config,
  SysUtils,
  Classes,
  IdBaseComponent,
  IdComponent,
  IdCustomTCPServer,
  IdCustomHTTPServer,
  IdHTTPServer,
  IdContext,
  IdTCPConnection;

Type
  // TClientContext = Class(TIdServerContext)
  // TClientContext = Class(TIdTCPConnection)
  TClientContext = Class(TIdTCPConnection)
  private

    function GetRouterName(URI: string): string;
    procedure Split(const Delimiter: Char; Value: string; const Strings: TStringList);
    function GetMethod(cmd: String): TMethods;
  Public
    // Constructor Create(Connection: TIdTCPConnection);
    // Destructor Destroy; Override;
    Procedure HandleRequest(AContext: TIdContext; var ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
  Public
  End;

implementation

uses
  IdGlobal,
  Server.Methods,
  System.StrUtils,
  Rest.ConstStr;

{ TClientContext }

procedure TClientContext.HandleRequest(AContext: TIdContext; var ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
Var
  FRouterName: String;
  FMethod: TMethods;
  Json: TextJSON;
  ParamValue, ParamName: String;
  aRequestStream: TStringStream;
  Params: TStringList;
begin

  //AResponseInfo.ContentType := 'text/html';
  AResponseInfo.ContentType := 'application/json';
  AResponseInfo.ContentText := '';

  FRouterName := LowerCase(GetRouterName(ARequestInfo.URI));
  FMethod := GetMethod(ARequestInfo.Command);

  if not(FMethod in [mGet, mPost, mPut, mDelete]) then
  begin

    exit;
  end;

  if (FMethod = mPost) OR (FMethod = mPut) then
  begin

    aRequestStream := TStringStream.Create;
    try
      aRequestStream.LoadFromStream(ARequestInfo.PostStream);
      aRequestStream.Position := 0;
      Json := UTF8ToString(aRequestStream.DataString);
    finally
      aRequestStream.Free;
    end;

  end;

  if ARequestInfo.Params.Count > 0 then
  begin
    ParamName := ARequestInfo.Params.Names[0];
    ParamValue := ARequestInfo.Params.Values[ParamName];
  end;

  with TServerMethods.Create do
  begin

    Params := TStringList.Create;
    Params.Add(ParamName + '=' + ParamValue);
    Params.Add('data=' + Json);

    try

      if FRouterName = 'banco' then
      begin
        AResponseInfo.ContentText := Banco(FMethod, Params)
      end
      else if FRouterName = 'fileupload' then
      begin
        AResponseInfo.ContentText := Upload(FMethod, ARequestInfo);
      end
      else if FRouterName = 'files' then
      begin
        Download(FMethod, ARequestInfo, AResponseInfo);
      end
      else if FRouterName = 'relatorios' then
      begin
        Relatorios(FMethod, ARequestInfo, AResponseInfo);
      end
      else
      begin
        AResponseInfo.ResponseNo := 403;
        AResponseInfo.ContentText := '{"result":false,"message":"API n�o localizado no servidor!!"}';
      end;

    finally
      Params.Free;
      Free;
    end;

  end;

  AResponseInfo.WriteContent;

  if Assigned(AResponseInfo.ContentStream) then
    AResponseInfo.ContentStream := nil;

end;

Function TClientContext.GetRouterName(URI: string): string;
var
  Listparams: TStringList;
  FDocument: string;
begin

  try

    Listparams := TStringList.Create;
    FDocument := Copy(URI, 2, length(URI));
    Split('/', FDocument, Listparams);

    if Listparams.Count > 0 then
      Result := Listparams[0];
  finally
    FreeAndNil(Listparams);
  end;

end;

procedure TClientContext.Split(const Delimiter: Char; Value: string; const Strings: TStringList);
begin

  Assert(Assigned(Strings));
  Strings.Clear;
  Strings.Delimiter := Delimiter;
  Strings.StrictDelimiter := true;
  Strings.DelimitedText := Value;

end;

Function TClientContext.GetMethod(cmd: String): TMethods;
begin

  case AnsiIndexStr(cmd, ['GET', 'PUT', 'POST', 'DELETE']) of
    0:
      Result := mGet;
    1:
      Result := mPut;
    2:
      Result := mPost;
    3:
      Result := mDelete;
  else
    Result := mAll;
  end;

end;

end.