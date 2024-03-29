unit Files.Upload;

interface

Uses System.SysUtils,
  System.Classes,
  StrUtils,
  Banco.Classe,
  Vcl.ExtCtrls,
  FormDataReader,
  IdBaseComponent,
  IdComponent,
  IdCustomHTTPServer,
  IdContext;

type
  TControleFileUpload = Class
  Public
    function Upload(DirUpload: String; ARequestInfo: TIdHTTPRequestInfo): Boolean;
  End;

implementation

uses
  System.JSON;


function TControleFileUpload.Upload(DirUpload: String; ARequestInfo: TIdHTTPRequestInfo): Boolean;
var
  Decoder: TIdMultiPartFormDataStreamReader;
  lPathFile, FileName,LocalFileName: String;
  lMemoryStream: TMemoryStream;
begin
    lPathFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
    lPathFile := lPathFile + IncludeTrailingPathDelimiter(Trim(DirUpload));

    if (lPathFile <> EmptyStr) and (Not(DirectoryExists(lPathFile))) then
      ForceDirectories(lPathFile);

    Decoder := TIdMultiPartFormDataStreamReader.Create(ARequestInfo);

    Try
      FileName := Decoder.Fields.Items[0].FileName;
      LocalFileName:=lPathFile + FileName;
      if (Assigned(Decoder.Fields.Items[0].FieldStream)) and (FileName <> EmptyStr) then
      begin

        lMemoryStream := TMemoryStream.Create;
        lMemoryStream.LoadFromStream(Decoder.Fields.Items[0].FieldStream);

        if FileExists(Pchar(LocalFileName)) then
          DeleteFile(Pchar(LocalFileName));

        if FileExists(Pchar(LocalFileName)) then
          raise Exception.Create('N�o foi poisiv�l subistituir o ' + FileName + ' no servidor');

        lMemoryStream.SaveToFile(LocalFileName);


      end
      else
        raise Exception.Create('Erro na recep��o do arquivo tente novamente');

    Finally

      Result:=FileExists(LocalFileName);

      if Assigned(lMemoryStream) then
        FreeAndNil(lMemoryStream);

      if Assigned(Decoder) then
      begin
        Decoder.Fields.Clear;
        Decoder.Clear;
       // FreeAndNil(Decoder);
      end;

    End;


end;

end.
