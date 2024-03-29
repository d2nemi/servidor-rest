unit Server.Methods;

interface

Uses
  Rest.Config,
  System.Classes,
  IdCustomHTTPServer,
  System.JSON;

Type
  TServerMethods = Class
  private

  Public
    Function Upload(Method: TMethods; ARequestInfo: TIdHTTPRequestInfo): String;
    Procedure Download(Method: TMethods; ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
    procedure Relatorios(Method: TMethods; ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);

    Function Banco(Method: TMethods; Params: TStringList): String;
    Function Usuario(Method: TMethods; Params: TStringList): String;

    Function Login(Method: TMethods; Params: TStringList;var ARequestInfo: TIdHTTPRequestInfo): String;


  End;

implementation

{ TServerMethods }

uses
  Banco.Controle,
  Usuario.Controle,
  Login.Controle,
  Files.Upload,
  Files.Download,
  System.SysUtils,
  Relatorios.Classe;



function TServerMethods.Login(Method: TMethods; Params: TStringList;var ARequestInfo: TIdHTTPRequestInfo): String;
begin

  with TControleLogin.Create do
  begin

    Try
      Params.Add('host='+ARequestInfo.RemoteIP);
      Result := Login(Params);
    Finally
      Free
    End;

  end;

end;

Function TServerMethods.Banco(Method: TMethods; Params: TStringList): String;
begin

  with TControleBanco.Create do
  begin

    Try

      case Method of
        mGet:
          Result := Get(Params);
        mPost:
          Result := Post(Params);
        mPut:
          Result := Put(Params);
        mDelete:
          Result := Delete(Params);
      end;
    Finally
      Free
    End;
  end;

end;

Procedure TServerMethods.Download(Method: TMethods; ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
var
  FDir, RootPath, FileName, FileType: String;
  FDocument: TStringList;
  i: Integer;
begin

  RootPath := ExtractFilePath(ParamStr(0));

  Try
    FDocument := TStringList.Create;
    try
      FDocument.Delimiter := '/';
      FDocument.StrictDelimiter := true;
      FDocument.DelimitedText := ARequestInfo.Document;
      FDocument.Delete(0);

      FDir := EmptyStr;
      for i := 0 to FDocument.count - 1 do
      begin
        if DirectoryExists(RootPath + FDocument[i]) then
          FDir := IncludeTrailingPathDelimiter(RootPath + FDocument[i])
        else if FileExists(FDir + FDocument[i]) then
          FileName := FDir + FDocument[i]

      end;

    finally
      FreeAndNil(FDocument);
    end;

    if FileExists(FileName) then
    begin

      with TControleDownload.Create do
      begin

        Try
          if Method = mGet then
          begin
            FileType := GetFileType(ExtractFileName(FileName));
            AResponseInfo.ContentText := EmptyStr;
            AResponseInfo.ContentType := FileType;
            // Obrigar o navegador a fazer o download
            if FileType = 'application/octet-stream' then
              AResponseInfo.ContentDisposition := 'attachment; filename="' + ExtractFileName(FileName) + '"';
            AResponseInfo.ContentStream := TFileStream.Create(FileName, fmOpenRead and fmShareDenyWrite);;
            AResponseInfo.ContentLength := -1;
          end
          else
            raise Exception.Create('O Method n�o � suportado para o  download de arquivo');

        Finally
          Free;
        End;
      end; // with
    end
    else
    begin
      AResponseInfo.ContentType := 'text/html';
      AResponseInfo.ResponseNo := 403;
      AResponseInfo.ContentText := 'O arquivo ' + ExtractFileName(FileName) + ' n�o foi localizado no servidor!!';
    end;

  Except
    On E: Exception do
      AResponseInfo.ContentText := '{"result":false,"message":"' + E.Message + '"}';
  End;

end;

Function TServerMethods.Upload(Method: TMethods; ARequestInfo: TIdHTTPRequestInfo): String;
var
  vParams: TStringList;
  ParamName, ParamValue: String;
begin

  Try

    if ARequestInfo.Params.count > 0 then
    begin
      ParamName := ARequestInfo.Params.Names[0];
      ParamValue := ARequestInfo.Params.Values[ParamName];
    end;

    vParams := TStringList.Create;
    vParams.Add(ParamName + '=' + ParamValue);

    with TControleFileUpload.Create do
    begin

      Try
        if Method = mPost then
        begin
          if Upload('files', ARequestInfo) then
            Result := '{"result":true,"message":"Arquivo recebido com sucesso"}'
          else
            raise Exception.Create('N�o foi poss�vel receber o arquivo');
        end
        else
          raise Exception.Create('O Method n�o � suportado para o  envio de arquivo');

      Finally
        Free;
      End;

    end;

  Except
    On E: Exception do
      Result := '{"result":false,"message":"' + E.Message + '"}';
  End;

end;

function TServerMethods.Usuario(Method: TMethods; Params: TStringList): String;
begin
  with TControleUsuario.Create do
  begin

    Try

      case Method of
        mGet:
          Result := Get(Params);
        mPost:
          Result := Post(Params);
        mPut:
          Result := Put(Params);
        mDelete:
          Result := Delete(Params);
      end;
    Finally
      Free
    End;
  end;
end;

Procedure TServerMethods.Relatorios(Method: TMethods; ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
var
  ParamName, ParamValue: String;
  RootPath, RelName, FileName: String;
  FDocument: TStringList;
  vParams: TStringList;
  i: Integer;
begin

  RootPath := ExtractFilePath(ParamStr(0));

  Try
    vParams := TStringList.Create;
    FDocument := TStringList.Create;
    try
      FDocument.Delimiter := '/';
      FDocument.StrictDelimiter := true;
      FDocument.DelimitedText := ARequestInfo.Document;
      FDocument.Delete(0);

      if FDocument.count = 2 then
        RelName := FDocument[1];
    finally
      FreeAndNil(FDocument);
    end;

    if ARequestInfo.Params.count > 0 then
    begin

      for i := 0 to ARequestInfo.Params.count - 1 do
      begin

        ParamName := ARequestInfo.Params.Names[i];
        ParamValue := LowerCase(ARequestInfo.Params.Values[ParamName]);

        vParams.Add(ParamName + '=' + ParamValue);

      end;
    end;

    with TRelatorio.Create do
    begin

      Try

        if RelName = 'bancos' then
          FileName := Bancos.Exportar(vParams);

        if FileExists(FileName) then
        begin
          if (vParams.IndexOfName('return') > -1) and (vParams.Values['return'] = 'data') then
          begin
            // FileType := GetFileType(ExtractFileName(FileName));
            AResponseInfo.ContentType := 'application/pdf';
            AResponseInfo.ContentText := EmptyStr;
            AResponseInfo.ContentStream := TFileStream.Create(FileName, fmOpenRead and fmShareDenyWrite);;
            AResponseInfo.ContentLength := -1;
          end
          else
          begin
            AResponseInfo.ContentText := '{"result":true,"message":"Relatorio gerado com sucesso","filename":"' + UTF8Encode(ExtractFileName(FileName)) + '"}';
          end;

        end
        else
        begin

          AResponseInfo.ResponseNo := 403;
          AResponseInfo.ContentText := '{"result":false,"message":"O Relatorio ' + RelName + ' n�o foi localizado no servidor!!"}';
        end;

      Finally
        if vParams <> nil then
          FreeAndNil(vParams);
        Free;
      End;
    end; // with

  Except
    On E: Exception do
      AResponseInfo.ContentText := '{"result":false,"message":"' + E.Message + '"}';
  End;

end;

end.
