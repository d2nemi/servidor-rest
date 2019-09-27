unit Rest.Utils;

interface

Uses
{$IFDEF FPC}
  Windows,
  SysUtils,
  Variants,
  Classes,
  StdCtrls,
  ExtCtrls,
  Forms,
  StrUtils,
  Masks,
  MaskUtils,
  DB,
  Dialogs,
  Graphics,
  Clipbrd,

{$ELSE}
  Winapi.Windows,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  StrUtils,
  System.Masks,
  MaskUtils,
  Data.DB,
  Vcl.Dialogs,
  Graphics,
  Clipbrd,
  System.JSON,
{$ENDIF}
  IdHTTP,
  IdIOHandlerStack,
  IdIOHandler,
  IdMultipartFormData,
  IdSSLOpenSSL,
  IdTCPConnection,
  IdComponent,
  Rest.ConstStr,
  IdHashMessageDigest;


function DataSetToArray(const DataSet: TDataSet): TJSONArray;
function DataSetToJSONArray(aDataSet: TDataSet): TextJSON;
function DataSetToJSONObject(aDataSet: TDataSet; TagNome: String = ''): TextJSON;


implementation


function DataSetToArray(const DataSet: TDataSet): TJSONArray;
var
  lArray: TJSONArray;
  FItem: TJSONObject;
  FFieldName: String;
  FFieldValue: Variant;
  i: Integer;
begin

  lArray := TJSONArray.Create;
  // FItem := TJSONObject.Create();
  // FItem.AddPair('nome', TJSONString.Create('teste'));
  // Result.Add(FItem);
  Try
    DataSet.First;
    while (not DataSet.EOF) do
    begin
      FItem := TJSONObject.Create();

      for i := 0 to Pred(DataSet.FieldDefs.Count) do
      begin

        // TCustomJSONDataSetAdapter � casesensetive
        FFieldName := LowerCase(DataSet.FieldDefs[i].Name);
        FFieldValue := DataSet.FieldByName(FFieldName).Value;
        if not DataSet.FieldByName(FFieldName).IsNull then
        begin
          case DataSet.FieldDefs[i].DataType of
            ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftBCD:
              FItem.AddPair(FFieldName, TJSONNumber.Create(FFieldValue));
          else
            FItem.AddPair(FFieldName, TJSONString.Create(FFieldValue))

          end;
        end
        else
        begin
          case DataSet.FieldDefs[i].DataType of
            ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftDateTime, ftTime:
              FItem.AddPair(FFieldName, TJSONNull.Create);
          else
            FItem.AddPair(FFieldName, TJSONNull.Create);
          end;

        end;

      end;

      lArray.Add(FItem);
      DataSet.Next;
    end;
  Finally
    Result := lArray;
    // FreeAndNil(lArray);
  End;

end;

function DataSetToJSONArray(aDataSet: TDataSet): TextJSON;
var
  JSONArray: TJSONArray;
  FItem: System.JSON.TJSONObject;
  FFieldName: String;
  FFieldValue: Variant;
  i: Integer;
begin

  JSONArray := TJSONArray.Create;
  try

    aDataSet.First;
    while (not aDataSet.EOF) do
    begin
      FItem := TJSONObject.Create();

      for i := 0 to Pred(aDataSet.FieldDefs.Count) do
      begin
        // TCustomJSONDataSetAdapter � casesensetive
        FFieldName := LowerCase(aDataSet.FieldDefs[i].Name);
        FFieldValue := aDataSet.FieldByName(FFieldName).Value;
        if not aDataSet.FieldByName(FFieldName).IsNull then
        begin

          case aDataSet.FieldDefs[i].DataType of
            ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftBCD:
              FItem.AddPair(FFieldName, TJSONNumber.Create(FFieldValue));
          else
            FItem.AddPair(FFieldName, TJSONString.Create(UTF8Encode(FFieldValue)))
          end;

        end
        else
        begin
          case aDataSet.FieldDefs[i].DataType of
            ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftDateTime, ftTime:
              FItem.AddPair(FFieldName, TJSONNull.Create);
          else
            FItem.AddPair(FFieldName, TJSONNull.Create);
          end;
        end;
      end;

      JSONArray.Add(FItem);
      aDataSet.Next;

    end;

    Result := JSONArray.toJSON;

  finally
    JSONArray.Free;
  end;
end;

function DataSetToJSONObject(aDataSet: TDataSet; TagNome: String = ''): TextJSON;
var
  FItem: System.JSON.TJSONObject;
  FFieldName: String;
  FFieldValue: Variant;
  i: Integer;
begin
  try
    if Not(Assigned(aDataSet)) then
      raise Exception.Create('DataSet n�o esta criado');

    if Not(aDataSet.Active) then
      raise Exception.Create('DataSet n�o esta ativo');

    // Result := TJSONArray.Create;
    FItem := TJSONObject.Create();
    aDataSet.First;
    while (not aDataSet.EOF) do
    begin
      for i := 0 to Pred(aDataSet.FieldDefs.Count) do
      begin
        // TCustomJSONDataSetAdapter � casesensetive
        FFieldName := LowerCase(aDataSet.FieldDefs[i].Name);
        FFieldValue := aDataSet.FieldByName(FFieldName).Value;

        if not aDataSet.FieldByName(FFieldName).IsNull then
        begin

          case aDataSet.FieldDefs[i].DataType of
            ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftBCD:
              FItem.AddPair(FFieldName, TJSONNumber.Create(FFieldValue));
          else
            FItem.AddPair(FFieldName, TJSONString.Create(FFieldValue))
          end;

        end
        else
        begin
          // FItem.AddPair('FFieldName', TJSONNull.Create);
          case aDataSet.FieldDefs[i].DataType of
            ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftDateTime, ftTime:
              FItem.AddPair(FFieldName, TJSONNull.Create);
          else
            FItem.AddPair(FFieldName, TJSONNull.Create);
          end;

        end;

      end;
      aDataSet.Next;
    end;

    if Assigned(FItem) then
      Result :=  '"'+TagNome + '":' + FItem.toJSON
    else
    begin
      if TagNome <> EmptyStr then
        Result := '{"' + TagNome + '":{XXX}}'
      else
        Result := '{"data":{}}';
    end;
    Result := '{' +Result + ',"count" : ' + IntToSTr(aDataSet.RecordCount)+'}';
  finally
    FreeAndNil(FItem);
  end;
end;

end.