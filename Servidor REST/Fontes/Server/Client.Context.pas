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
  IdTCPConnection,
  Rest.Server,
  User.Sessao;

Type
  TClientContext = Class(TIdTCPConnection)
  private

    function GetRouterName(URI: string): string;
    procedure Split(const Delimiter: Char; Value: string; const Strings: TStringList);
    function GetMethod(cmd: String): TMethods;
  Public
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
  FBasicAuthentication: TBasicAuthentication;
  I, ResponseErro: Integer;
  FKey: string;
begin

  Params := TStringList.Create;
  AResponseInfo.ContentType := 'application/json';
  AResponseInfo.ContentText := '';
  ResponseErro := 403;
  FMethod := GetMethod(ARequestInfo.Command);

  Try

    if not(FMethod in [mGet, mPost, mPut, mDelete]) then
      raise Exception.Create('O Methdo não e suportado');

{$REGION 'Obtem o parametros enviados'}
    if ARequestInfo.Params.Count > 0 then
    begin
      for I := 0 to ARequestInfo.Params.Count - 1 do
      begin
        ParamName := ARequestInfo.Params.Names[I];
        ParamValue := ARequestInfo.Params.Values[ParamName];
        Params.Add(ParamName + '=' + ParamValue);
      end;
    end;
{$ENDREGION}

{$REGION 'verifica a autenticação do usuário'}
    if (AppAuthentication) then
    begin
      AResponseInfo.ResponseNo := 401;
      FKey:=Params.Values['key'];
      FBasicAuthentication := TUserSessao.New.Sessao(FKey);
      if FBasicAuthentication = nil then
        raise Exception.Create('Autenticação requerida!!')
      else
      begin
        Try
          if Not FBasicAuthentication.Active then
            raise Exception.Create('Sessão expirada!!');
        Finally
          FreeAndNil(FBasicAuthentication);
        end;
      end;
    end;
{$ENDREGION}

{$REGION 'Obtem o JSON enviado'}
    if (FMethod = mPost) OR (FMethod = mPut) then
    begin

      aRequestStream := TStringStream.Create;
      try
        aRequestStream.LoadFromStream(ARequestInfo.PostStream);
        aRequestStream.Position := 0;
        Json := UTF8ToString(aRequestStream.DataString);
        Params.Add('data=' + Json);
      finally
        aRequestStream.Free;
      end;

    end;
{$ENDREGION}

{$REGION 'Methods do Servidor'}
    with TServerMethods.Create do
    begin

      try
        FRouterName := LowerCase(GetRouterName(ARequestInfo.URI));
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
          AResponseInfo.ContentText := '{"result":false,"message":"API não localizado no servidor!!"}';
        end;

      finally
        Free;
      end;

    end;
{$ENDREGION}
  Except
    On E: Exception do
    begin
      AResponseInfo.ResponseNo := ResponseErro;
      AResponseInfo.ContentText := '{"result":false,"message":"' + UTF8Encode(E.Message) + '"}';
    end;
  End;

  AResponseInfo.WriteContent;

  if Assigned(AResponseInfo.ContentStream) then
    AResponseInfo.ContentStream := nil;

  if Assigned(Params) then
    FreeAndNil(Params);

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

Initialization

Finalization

end.
