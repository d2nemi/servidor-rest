{
  Autor: Enrique Cerdá
  https://github.com/enriquecerda/TIdMultiPartFormDataStreamReader
}
unit FormDataReader;

interface

{$I IdCompilerDefines.inc}


uses System.SysUtils, System.Classes, IdGlobal, IdGlobalProtocols,
  idMultipartFormData, IdCustomHTTPServer,
  IdCoderQuotedPrintable, IdCoderMIME, IdHeaderList;

type
  TIdMultiPartFormDataStreamReader = class(TIdMultiPartFormDataStream)
  private
    FRequestInfo: TIdHTTPRequestInfo;
    // FFields: TIdFormDataFields;  NAO PODE CRIAR PROVOCA ERRO
  protected
    Header: TIdHeaderList;
    FStreamInfo: TMemoryStream;
    procedure DecodeStream;
  public
    property Fields: TIdFormDataFields read FFields;
    constructor Create(ARequestInfo: TIdHTTPRequestInfo);
    Destructor Destroy; Override;
  end;

implementation

{ TIdMultiPartFormDataStreamReader }

constructor TIdMultiPartFormDataStreamReader.Create(
  ARequestInfo: TIdHTTPRequestInfo);
begin
  inherited Create;
  FSize := 0;
  FInitialized := False;
  FFields := TIdFormDataFields.Create(Self);
  FRequestInfo := ARequestInfo;
  DecodeStream;
end;

destructor TIdMultiPartFormDataStreamReader.Destroy;
begin

  if Assigned(Header) then
    FreeAndNil(Header);

  if Assigned(FStreamInfo) then
    FreeAndNil(FStreamInfo);

  inherited;

end;

procedure TIdMultiPartFormDataStreamReader.DecodeStream;
var
  Boundary, ContentStream: string;
  posIniPost, posFinPost, posIniRetorno: Integer;
  StartBoundary: string;
  FieldName: string;
  FieldFileName: string;
  ContentType: string;
  charSet: string;
  TransferEnconding: string;
{$IFDEF STRING_IS_ANSI}
  LBytes: TIdBytes;
{$ENDIF}
  function ReadStringLn(StreamOri: TStream; var cadenaBus: string; char_set: string): Boolean;
  var
    candidato: Boolean;
    posIniSO: Integer;
    posFinSO: Integer;
    StreamDes: TMemoryStream;
    bleer: Byte;
  begin

    candidato := False;
    StreamDes := TMemoryStream.Create;
    posIniSO := StreamOri.Position;
    cadenaBus := '';

    while (not candidato) and (StreamOri.Position < StreamOri.Size) do
    begin
      StreamOri.Read(bleer, 1);
      if (bleer = 13) then
      begin
        StreamOri.Read(bleer, 1);
        if (bleer = 10) then
        begin
          candidato := True;
          posFinSO := StreamOri.Position;
          StreamOri.Position := posIniSO;

          if (posFinSO - 2 - posIniSO > 0) then
          begin
            StreamDes.CopyFrom(StreamOri, posFinSO - 2 - posIniSO);
            StreamDes.Position := 0;
            cadenaBus := IdGlobalProtocols.ReadStringAsCharset(StreamDes, char_set);
          end;
          StreamOri.Position := posFinSO;

        end;
      end;
    end;

    StreamDes.Free;
    Result := candidato;

  end;

begin
{$IFDEF STRING_IS_ANSI}
  LBytes := nil;
{$ENDIF}
  if (ExtractHeaderItem(FRequestInfo.RawHeaders.Values['Content-Type']) <> 'multipart/form-data') then
    Exit;

  Header := TIdHeaderList.Create(TIdHeaderQuotingType.QuoteHTTP);
  Boundary := FRequestInfo.RawHeaders.Params['Content-Type', 'boundary'];
  FBoundary := Boundary;
  FRequestContentType := sContentTypeFormData + FBoundary;
  FRequestInfo.PostStream.Position := 0;

  if (ReadStringLn(FRequestInfo.PostStream, StartBoundary, FRequestInfo.charSet)) then
  begin

    while (StartBoundary = '--' + Boundary) and (FRequestInfo.PostStream.Position < FRequestInfo.PostStream.Size) do
    begin

      if (ReadStringLn(FRequestInfo.PostStream, StartBoundary, FRequestInfo.charSet)) then
      begin

        while (StartBoundary <> '') and (FRequestInfo.PostStream.Position < FRequestInfo.PostStream.Size) do
        begin

          Header.Add(StartBoundary);
          ReadStringLn(FRequestInfo.PostStream, StartBoundary, FRequestInfo.charSet);

        end;

        FieldName := Header.Params['Content-Disposition', 'name'];
        FieldFileName := Header.Params['Content-Disposition', 'filename'];
        ContentType := ExtractHeaderItem(Header.Values['Content-Type']);
        charSet := Header.Params['Content-Type', 'charset'];
        TransferEnconding := Header.Values['Content-Transfer-Encoding'];

        FStreamInfo := TMemoryStream.Create;
        posIniPost := FRequestInfo.PostStream.Position;
        posFinPost := posIniPost;

        ReadStringLn(FRequestInfo.PostStream, StartBoundary, FRequestInfo.charSet);

        while (StartBoundary <> '--' + Boundary) and
          (StartBoundary <> '--' + Boundary + '--') and
          (FRequestInfo.PostStream.Position < FRequestInfo.PostStream.Size) do
        begin

          posFinPost := FRequestInfo.PostStream.Position;
          ReadStringLn(FRequestInfo.PostStream, StartBoundary, FRequestInfo.charSet);

        end;

        posIniRetorno := FRequestInfo.PostStream.Position;
        FRequestInfo.PostStream.Position := posIniPost;

        if (posFinPost - 2 - posIniPost > 0) then
        begin

          if (FieldFileName <> '') then
          begin

            FStreamInfo.CopyFrom(FRequestInfo.PostStream, posFinPost - 2 - posIniPost);
            if (LowerCase(TransferEnconding) = 'quoted-printable') then
            begin

              FStreamInfo.Position := 0;
              ContentStream := ReadStringFromStream(FStreamInfo);
              FStreamInfo.Clear;
              FStreamInfo.Position := 0;
              TIdDecoderQuotedPrintable.DecodeStream(ContentStream, FStreamInfo);

            end
            else if (LowerCase(TransferEnconding) = 'base64') then
            begin

              FStreamInfo.Position := 0;
              ContentStream := ReadStringFromStream(FStreamInfo);
              FStreamInfo.Clear;
              FStreamInfo.Position := 0;
              TIdDecoderMIME.DecodeStream(ContentStream, FStreamInfo);

            end;

            FStreamInfo.Position := 0;
            AddFormField(FieldName, ContentType, charSet, FStreamInfo, FieldFileName);

          end
          else
          begin

            FStreamInfo.CopyFrom(FRequestInfo.PostStream, posFinPost - 2 - posIniPost);
            ContentStream := '';
            FStreamInfo.Position := 0;

{$IFDEF STRING_IS_ANSI}
            ReadTIdBytesFromStream(stInfo, LBytes, FStreamInfo.Size);
{$ENDIF}
            if (LowerCase(TransferEnconding) = '7bit') then
            begin
{$IFDEF STRING_IS_UNICODE}
              ContentStream := ReadStringFromStream(FStreamInfo, -1, IndyTextEncoding_ASCII);
{$ELSE}
              CheckByteEncoding(LBytes, IndyTextEncoding_ASCII, CharsetToEncoding(charSet));
{$ENDIF}
            end
            else if (LowerCase(TransferEnconding) = 'quoted-printable') then
            begin
{$IFDEF STRING_IS_UNICODE}
              ContentStream := ReadStringFromStream(FStreamInfo);
              ContentStream := TIdDecoderQuotedPrintable.DecodeString(ContentStream, CharsetToEncoding(charSet));
{$ELSE}
              BytesToRaw(LBytes, ContentStream, Length(LBytes));
              LBytes := TIdDecoderQuotedPrintable.DecodeBytes(ContentStream);
{$ENDIF}
            end
            else if (LowerCase(TransferEnconding) = 'base64') then
            begin

{$IFDEF STRING_IS_UNICODE}
              ContentStream := ReadStringFromStream(FStreamInfo);
              ContentStream := TIdDecoderMIME.DecodeString(ContentStream, CharsetToEncoding(charSet));
{$ELSE}
              BytesToRaw(LBytes, ContentStream, Length(LBytes));
              LBytes := TIdDecoderMIME.DecodeBytes(ContentStream);
{$ENDIF}
            end
            else if (LowerCase(TransferEnconding) = '8bit') or (LowerCase(TransferEnconding) = 'binary') then
            begin

{$IFDEF STRING_IS_UNICODE}
              ContentStream := ReadStringAsCharset(FStreamInfo, charSet);
{$ENDIF}
            end;

{$IFDEF STRING_IS_ANSI}
            BytesToRaw(LBytes, ContentStream, Length(LBytes));
{$ENDIF}
            AddFormField(FieldName, ContentStream, charSet, ContentType);
            FStreamInfo.Free;

          end;

        end;

        FRequestInfo.PostStream.Position := posIniRetorno;

        Header.Clear;

      end;

    end;

  end;

end;

end.
