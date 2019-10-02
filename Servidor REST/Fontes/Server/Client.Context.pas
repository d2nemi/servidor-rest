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
  Rest.Utils,
  User.Sessao;

Type
  TClientContext = Class(TIdTCPConnection)
  private

    function GetRouterName(URI: string): string;
    procedure Split(const Delimiter: Char; Value: string; const Strings: TStringList);
    function GetMethod(cmd: String): TMethods;
  Public
    Procedure HandleRequest(AContext: TIdContext; var ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
    function Authenticated(Params: TStringList; var AResponseInfo: TIdHTTPResponseInfo): Boolean;
  Public
  End;

implementation

uses
  IdGlobal,
  Server.Methods,
  System.StrUtils,
  Rest.ConstStr, Login.Classe;

{ TClientContext }
Function GetParams(ARequestInfo: TIdHTTPRequestInfo): TStringList;
var
  FToken: string;
  ParamValue, ParamName: String;
  I: Integer;
begin
  Result := TStringList.Create;
  // Obtem o Token informado no Header
  FToken := ARequestInfo.RawHeaders.Values['key'];
  if FToken <> EmptyStr then
    // Inclui o token na lista de parametros
    Result.Add('key=' + FToken);

  if ARequestInfo.Params.Count > 0 then
  begin
    for I := 0 to ARequestInfo.Params.Count - 1 do
    begin
      ParamName := ARequestInfo.Params.Names[I];
      ParamValue := ARequestInfo.Params.Values[ParamName];
      Result.Add(ParamName + '=' + ParamValue);
    end;

  end;

end;

procedure TClientContext.HandleRequest(AContext: TIdContext; var ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
Var
  FRouterName: String;
  FMethod: TMethods;
  Json: TextJSON;
  aRequestStream: TStringStream;
  Params: TStringList;
begin

  Try
    FRouterName := LowerCase(GetRouterName(ARequestInfo.URI));
    FMethod := GetMethod(ARequestInfo.Command);

    //Obtem a lista de parametros
    Params := GetParams(ARequestInfo);

{$REGION 'verifica a autenticação do usuário'}
    if (AppAuthentication) and (FRouterName <> 'login')  then
      if Not Authenticated(Params, AResponseInfo) then
      begin
        AResponseInfo.ResponseNo := 401;
        raise Exception.Create('Autenticação requerida!!');
      end;

{$ENDREGION}

{$REGION 'Obtem o JSON enviado'}
    if (FMethod = mPost) OR (FMethod = mPut) then
    begin

      aRequestStream := TStringStream.Create;
      try

        if ARequestInfo.PostStream <> nil then
        begin
          aRequestStream.LoadFromStream(ARequestInfo.PostStream);
          aRequestStream.Position := 0;
          Json := UTF8ToString(aRequestStream.DataString);
        end
        else if Params.Values['data'] <> EmptyStr then
          Json := Params.Values['data'];

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


        if FRouterName = 'fileupload' then
          AResponseInfo.ContentText := Upload(FMethod, ARequestInfo)
        else if FRouterName = 'files' then
          Download(FMethod, ARequestInfo, AResponseInfo)
        else if FRouterName = 'relatorios' then
          Relatorios(FMethod, ARequestInfo, AResponseInfo)
        else  if FRouterName = 'banco' then
          AResponseInfo.ContentText := Banco(FMethod, Params)
        else  if FRouterName = 'usuario' then
          AResponseInfo.ContentText := Usuario(FMethod, Params)
        else  if FRouterName = 'login' then
          AResponseInfo.ContentText := Login(FMethod, Params, ARequestInfo);

      finally
        Free;
      end;

    end;
{$ENDREGION}
  Except
    On E: Exception do
    begin
      // AResponseInfo.ResponseNo := ResponseErro;
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

function TClientContext.Authenticated(Params: TStringList; var AResponseInfo: TIdHTTPResponseInfo): Boolean;
var
  FToken: String;
  FLogin: TLogin;
begin
  FToken := Params.Values['key'];

  if FToken='key_debug' then
    FToken:=EncodeMD5(FToken);

  Try
    FLogin := TUserSessao.New.Sessao(FToken); // -->Não pode ser liberada no final do processo, e liberada na propria class de sessão
    if FLogin <> nil then
    begin
      if Not FLogin.Active then
      begin
        Result := false;
        AResponseInfo.ResponseNo := 401;
        raise Exception.Create('Sessão expirada!!');
      end
      else
        Result := true;
    end
    else
      Result := false;
  Except
    On E: Exception do
    begin
      Result := false;
      raise Exception.Create('Erro ao validar a sessão ' + E.Message);
    end;
  End;

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
