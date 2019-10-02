unit Usuario.Classe;

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
  TUsuario = Class
  private
    FUse_Codigo: Integer;
    FUse_Nome: String;
    FUse_login: String;
    FUse_mail: String;
    FUse_password: String;

  Public

    Property Use_Codigo: Integer read FUse_Codigo write FUse_Codigo;
    Property Use_Nome: String read FUse_Nome write FUse_Nome;
    Property Use_login: String read FUse_login write FUse_login;
    Property Use_mail: String read FUse_mail write FUse_mail;
    Property Use_password: String read FUse_password write FUse_password;

    Procedure ToObject(JSON: string);
    Function toSQL(aAcao: TAcao = acSelect): string;
    Function toJSON(const DataSet: TDataSet; JSONType: TJSONType = jsArray): TextJSON;
    Function toOrderBy(Field:String='Use_Codigo'; TypeOrder:String='ASC'): string;
  End;

implementation

const
  SQL_DELETE = 'DELETE FROM Usuarios WHERE Use_Codigo=%S;';

  SQL_SELECTE = 'SELECT ' +
                ' Use_Codigo' +
                ' ,Use_Nome' +
                ' ,Use_login' +
               // ' ,Use_password' +
                ' ,Use_mail' +
                ' FROM Usuarios ';

  SQL_UPDATE =  'UPDATE Usuarios SET ' +
                ' Use_Nome=%S' +
                ' ,Use_login=%S' +
                ' ,Use_password=%S' +
                ' ,Use_mail=%S' +
                ' WHERE Use_Codigo=%S;';

  SQL_INSERT =  'INSERT INTO Usuarios(' +
                ' Use_Nome' +
                ' ,Use_login' +
                ' ,Use_password' +
                ' ,Use_mail' +
                ') VALUES(%S,%S,%S,%S) ';

{ TUsuario }


procedure TUsuario.toObject(JSON: String);
{$IFNDEF FPC}
var
  Obj: TJSONObject;
{$ENDIF}
begin
{$IFNDEF FPC}
  Try

    { Obj := TJSONObject.ParseJSONValue( TEncoding.ASCII.GetBytes(JSON),0)  as TJSONObject;
      Self.Use_Codigo :=Obj.Get('Use_Codigo').JsonValue.ToJSON.ToInteger;
      Self.Use_Nome :=Obj.Get('Use_Nome').JsonValue.ToJSON; }

    Obj := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
    if Assigned(Obj) then
    begin
      self.Use_Codigo   := Obj.GetValue<string>('Use_Codigo').ToInteger;
      self.Use_Nome     := Obj.GetValue<string>('Use_Nome');
      self.Use_login    := Obj.GetValue<string>('Use_login');
      self.Use_mail     := Obj.GetValue<string>('Use_mail');
    //  self.Use_password := Obj.GetValue<string>('Use_password');
    end
    else
      raise Exception.Create('Formato do JSON não é válido');
  Finally
    FreeAndNil(Obj);
  End;
{$ENDIF}
end;

function TUsuario.toJSON(const DataSet: TDataSet; JSONType: TJSONType = jsArray): TextJSON;
var
  lTagName: String;
begin

  lTagName := Lowercase(Copy(self.ClassName, 2, length(self.ClassName)));

  if JSONType = jsObject then
    Result := DataSetToJSONObject(DataSet, lTagName)
  else
    Result := DataSetToJSONArray(DataSet);

end;

function TUsuario.toSQL(aAcao: TAcao = acSelect): string;
begin

  case aAcao of
    acAdd:
      begin
        Result := Format(SQL_INSERT, [
          //IfThen(self.Use_Codigo = 0, 'null', IntToStr(self.Use_Codigo)),
          IfThen(self.Use_Nome = EmptyStr, 'null', QuotedStr(self.Use_Nome)),
          IfThen(self.Use_login = EmptyStr, 'null', QuotedStr(self.Use_login)),
          IfThen(self.Use_password = EmptyStr, 'null', QuotedStr(EncodeMD5(self.Use_password))),
          IfThen(self.Use_mail = EmptyStr, 'null', QuotedStr(self.Use_mail))
          ]);
      end;
    acUpdate:
      begin
        Result := Format(SQL_UPDATE, [
          IfThen(self.Use_Nome = EmptyStr, 'null', QuotedStr(self.Use_Nome)),
          IfThen(self.Use_login = EmptyStr, 'null', QuotedStr(self.Use_login)),
          IfThen(self.Use_password= EmptyStr, 'null', QuotedStr(EncodeMD5(self.Use_password))),
          IfThen(self.Use_mail = EmptyStr, 'null', QuotedStr(self.Use_mail)),
          IfThen(self.Use_Codigo = 0, 'null', IntToStr(self.Use_Codigo))]);
      end;
    acDelete:
      begin
        Result := Format(SQL_DELETE, [IntToStr(self.Use_Codigo)]);
      end
  else
    begin
      if (self.Use_Codigo > 0) then
        Result := SQL_SELECTE + ' where Use_Codigo=' + self.Use_Codigo.ToString
      else
        Result := SQL_SELECTE;

    end;
  end;

end;
function TUsuario.toOrderBy(Field:String='Use_Codigo'; TypeOrder:String='ASC'): string;
begin
   Result:=' order by '+Field +' ' +TypeOrder
end;



end.
