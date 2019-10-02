unit Usuario.Model;

interface

Uses
  Usuario.Classe,
  Data.DB,
  FireDAC.Comp.Client,
  Datasnap.DBClient,
  MidasLib,
  Vcl.ExtCtrls,
  Interfaces.Model,
  System.SysUtils,
  System.Classes,
  System.JSON,
  Rest.ConstStr;

Type
  TModelUsuario = Class(TInterfacedObject, IModelUsuario)
  Private
    sSQL: String;
    fDataSet: TDataSet;
    lResult: Boolean;
  Public
    Constructor Create();
    Destructor Destroy; Override;
    Function Get(Usuario: TUsuario; Offset: integer = 0; limit: integer = 0): TextJSON;
    Function Put(Usuario: TUsuario): Boolean;
    Function Post(Usuario: TUsuario): Boolean;
    function Delete(Usuario: TUsuario): Boolean;
  End;

implementation


{ TModelUsuario }

uses Server.DB;

constructor TModelUsuario.Create();
begin
end;

destructor TModelUsuario.Destroy;
begin
  inherited;
end;

function TModelUsuario.Get(Usuario: TUsuario; Offset: integer = 0; limit: integer = 0): TextJSON;
begin

  try

    sSQL := Usuario.toSQL(acSelect);

    if (limit > 0) then
      sSQL := sSQL + ' Offset ' + IntToStr(Offset) + ' limit ' + IntToStr(limit);

    fDataSet := SqlAll(sSQL);
    Try
      if Usuario.Use_Codigo > 0 then
        Result := Usuario.toJSON(fDataSet, jsObject)
      else
        Result := Usuario.toJSON(fDataSet, jsArray);

    Finally
      FreeAndNil(fDataSet);
    End;

  except
    On e: Exception do
      raise Exception.Create(e.Message);
  end;

end;

function TModelUsuario.Post(Usuario: TUsuario): Boolean;
begin

  try

    sSQL := Usuario.toSQL(acSelect);
    fDataSet := SqlAll(sSQL);
    Try
      sSQL := Usuario.toSQL(acAdd);
      if fDataSet.RecordCount = 0 then
        Result := ExecuteSQL(sSQL)
      else
        raise Exception.Create(Format(TXT_EXIST, [IntToStr(Usuario.Use_Codigo), Usuario.Use_Nome]));
    Finally
      FreeAndNil(fDataSet);
    End;

  except
    On e: Exception do
      raise Exception.Create(e.Message);
  end;

end;

function TModelUsuario.Put(Usuario: TUsuario): Boolean;
begin
  try

    sSQL := Usuario.toSQL(acSelect);
    fDataSet := SqlAll(sSQL);
    Try
      sSQL := Usuario.toSQL(acUpdate);
      if fDataSet.RecordCount > 0 then
        Result := ExecuteSQL(sSQL)
      else
        raise Exception.Create(Format(TXT_NOT_EXIST, [IntToStr(Usuario.Use_Codigo), Usuario.Use_Nome]));
    Finally
      FreeAndNil(fDataSet);
    End;

  except
    On e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TModelUsuario.Delete(Usuario: TUsuario): Boolean;
begin
  try

    sSQL := Usuario.toSQL(acSelect);
    fDataSet := SqlAll(sSQL);
    Try
      sSQL := Usuario.toSQL(acDelete);
      if fDataSet.RecordCount > 0 then
        Result := ExecuteSQL(sSQL)
      else
        raise Exception.Create(Format(TXT_NOT_EXIST, [IntToStr(Usuario.Use_Codigo), Usuario.Use_Nome]))

    Finally
      FreeAndNil(fDataSet);
    End;

  except
    On e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

end.
