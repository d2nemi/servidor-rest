unit Banco.Classe;

interface

Uses
  Db,
  System.SysUtils,
  System.Classes,
  StrUtils,
  System.JSON,
  Rest.ConstStr,
  Rest.Utils;

Type
  TBanco = Class
  private
    FBan_Codigo: Integer;
    FBan_Nome: String;

  Public

    Property Ban_Codigo: Integer read FBan_Codigo write FBan_Codigo;
    Property Ban_Nome: String read FBan_Nome write FBan_Nome;
    Procedure ToObject(JSON: string);
    Function toSQL(aAcao: TAcao = acSelect): string;
    Function toJSON(const DataSet: TDataSet; JSONType: TJSONType = jsArray): TextJSON;
    Function toOrderBy(Field:String='ban_codigo'; TypeOrder:String='ASC'): string;
  End;

implementation

const
  SQL_DELETE = 'DELETE FROM Bancos WHERE ban_codigo=%S;';

  SQL_SELECTE = 'SELECT ' +
                ' ban_codigo,' +
                ' ban_nome' +
                ' FROM Bancos ';

  SQL_UPDATE =  'UPDATE Bancos SET ' +
                ' ban_nome=%S' +
                ' WHERE ban_codigo=%S;';

  SQL_INSERT =  'INSERT INTO Bancos(' +
                ' ban_codigo,' +
                ' ban_nome' +
                ') VALUES(%S,%S) ';

{ TBanco }


procedure TBanco.toObject(JSON: String);
{$IFNDEF FPC}
var
  Obj: TJSONObject;
{$ENDIF}
begin
{$IFNDEF FPC}
  Try

    { Obj := TJSONObject.ParseJSONValue( TEncoding.ASCII.GetBytes(JSON),0)  as TJSONObject;
      Self.Ban_codigo :=Obj.Get('ban_codigo').JsonValue.ToJSON.ToInteger;
      Self.Ban_nome :=Obj.Get('ban_nome').JsonValue.ToJSON; }

    Obj := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
    if Assigned(Obj) then
    begin
      self.Ban_codigo := Obj.GetValue<string>('ban_codigo').ToInteger;
      self.Ban_nome := Obj.GetValue<string>('ban_nome');
    end
    else
      raise Exception.Create('Formato do JSON n�o � v�lido');
  Finally
    FreeAndNil(Obj);
  End;
{$ENDIF}
end;

function TBanco.toJSON(const DataSet: TDataSet; JSONType: TJSONType = jsArray): TextJSON;
var
  lTagName: String;
begin

  lTagName := Lowercase(Copy(self.ClassName, 2, length(self.ClassName)));

  if JSONType = jsObject then
    Result := DataSetToJSONObject(DataSet, lTagName)
  else
    Result := DataSetToJSONArray(DataSet);

end;

function TBanco.toSQL(aAcao: TAcao = acSelect): string;
begin

  case aAcao of
    acAdd:
      begin
        Result := Format(SQL_INSERT, [
          IfThen(self.Ban_codigo = 0, 'null', IntToStr(self.Ban_codigo)),
          IfThen(self.Ban_nome = EmptyStr, 'null', QuotedStr(self.Ban_nome))
          ]);
      end;
    acUpdate:
      begin
        Result := Format(SQL_UPDATE, [
          IfThen(self.Ban_nome = EmptyStr, 'null', QuotedStr(self.Ban_nome)),
          IfThen(self.Ban_codigo = 0, 'null', IntToStr(self.Ban_codigo))]);
      end;
    acDelete:
      begin
        Result := Format(SQL_DELETE, [IntToStr(self.Ban_codigo)]);
      end
  else
    begin
      if (self.Ban_codigo > 0) then
        Result := SQL_SELECTE + ' where ban_codigo=' + self.Ban_codigo.ToString
      else
        Result := SQL_SELECTE;

     // Result := Result + ' order by ban_codigo'
    end;
  end;

end;
function TBanco.toOrderBy(Field:String='ban_codigo'; TypeOrder:String='ASC'): string;
begin
   Result:=' order by '+Field +' ' +TypeOrder
end;



end.
