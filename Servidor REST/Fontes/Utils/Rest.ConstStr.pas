unit Rest.ConstStr;

interface

Const
  LN = #13 + #10;
  _PAR_LIMIT = 'limit';
  _PAR_OFFSET = 'offset';
  _PAR_ID = 'id';
  _PAR_DATA = 'data';

  TXT_NOT_EXIST = 'O Registro %s - %s n�o esta cadastrado no sistema.';
  TXT_EXIST = 'O Registro %s - %s j� est� cadastrado no sistema.';
  TXT_REGISTRO_ATUALIZADO='Registro atualizado com sucesso';
  TXT_REGISTRO_INCLUIDO='Registro incluido com sucesso';
  TXT_REGISTRO_EXCLUIDO='Registro excluido com sucesso';

Type
  TAcao = (acIndefinido, acSelect, acAdd, acUpdate, acDelete, acCancel);
  TJSONType = (jsArray, jsObject);

Type
{$IFDEF HASCODEPAGE}
  TextJSON = type AnsiString(CP_UTF8); // Codepage for an UTF8 string
{$ELSE}
  TextJSON = type AnsiString;
{$ENDIF}

implementation

end.
