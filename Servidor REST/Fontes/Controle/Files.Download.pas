unit Files.Download;

interface

Uses System.SysUtils,
  System.Classes,
  StrUtils,
  Banco.Classe,
  Vcl.ExtCtrls,
  IdBaseComponent,
  IdComponent,
  IdCustomHTTPServer,
  IdContext, registry, Winapi.Windows;

type
  TControleDownload = Class
  Public
   // function Download(FileDir: String; ARequestInfo: TIdHTTPRequestInfo): TFileStream;
    Function GetFileType(FileName: String): String;
  End;

implementation

uses
  System.JSON;
{
function TControleDownload.Download(FileDir: String; ARequestInfo: TIdHTTPRequestInfo): TFileStream;
var
  lPathFile, FileName, LocalFileName: String;
begin
  lPathFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  lPathFile := lPathFile + IncludeTrailingPathDelimiter(Trim(FileDir));

  Try
    Result := TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'files\Simple.pdf', fmOpenRead and fmShareDenyWrite);

    raise Exception.Create('Erro na recep��o do arquivo tente novamente');

  Finally

  End;

end;
 }
function TControleDownload.GetFileType(FileName: String): String;
var
  Ext: String;
begin

  Ext := LowerCase(ExtractFileExt(FileName));

  if Ext = '.txt' then
    Result := 'text/plain'
    // HyperText Markup Language (HTML)
  else if (Ext = '.html') or (Ext = '.htm') then
    Result := 'text/html'
    // JPEG images
  else if (Ext = '.jpg') or (Ext = '.jpeg') then
    Result := 'image/jpeg'
    // Portable Network Graphics
  else if Ext = '.png' then
    Result := 'image/png'
    // Graphics Interchange Format (GIF)
  else if Ext = '.gif' then
    Result := 'image/gif'
    // Adobe Portable Document Format (PDF)
  else if Ext = '.pdf' then
    Result := 'application/pdf'
    // Rich Text Format (RTF)
  else if Ext = '.rtf' then
    Result := 'application/rtf'
    // Microsoft Word
  else if Ext = '.doc' then
    Result := 'application/msword'
    // Icon format
  else if Ext = '.ico' then
    Result := 'image/x-icon'
    // JSON format
  else if Ext = '.json' then
    Result := 'application/json'
    // JavaScript (ECMAScript)
  else if Ext = '.js' then
    Result := 'application/javascript'
    // Cascading Style Sheets (CSS)
  else if Ext = '.css' then
    Result := 'text/css'
    // Comma-separated values (CSV)
  else if Ext = '.csv' then
    Result := 'text/csv'
    // OpenType font
  else if Ext = '.otf' then
    Result := 'font/otf'
    // Tagged Image File Format (TIFF)
  else if (Ext = '.tif') or (Ext = '.tiff') then
    Result := 'image/tiff'
    // ZIP archive
  else if Ext = '.zip' then
    Result := 'application/zip'
    // 7-zip archive
  else if Ext = '.7z' then
    Result := 'application/x-7z-compressed'
    // XML
  else if Ext = '.xml' then
    Result := 'application/xml'
    // Microsoft Excel
  else if (Ext = '.xls') or (Ext = '.xlsx') then
    Result := 'application/vnd.ms-excel'
    // XHTML
  else if Ext = '.xhtml' then
    Result := 'application/xhtml+xml'
    // Tape Archive (TAR)
  else if Ext = '.tar' then
    Result := 'application/x-tar'
    // RAR archive
  else if Ext = '.rar' then
    Result := 'application/x-rar-compressed'
    // Microsoft PowerPoint
  else if Ext = '.ppt' then
    Result := 'application/vnd.ms-powerpoint'
    // Arquivo compactado  BZip2
  else if Ext = '.bz2' then
    Result := 'application/x-bzip2'
    // Arquivo compactado  BZip
  else if Ext = '.bz' then
    Result := 'application/x-bzip'
    // Scalable Vector Graphics (SVG)
  else if Ext = '.svg' then
    Result := 'image/svg+xml'
    // Restante
  else
    Result := 'application/octet-stream'

end;

end.
