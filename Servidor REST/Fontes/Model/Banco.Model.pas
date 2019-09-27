unit Banco.Model;

interface

Uses
  Banco.Classe,
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
  TModelBanco = Class(TInterfacedObject, IModelBanco)
  Private
    sSQL: String;
    fDataSet: TDataSet;
    lResult: Boolean;
  Public
    Constructor Create();
    Destructor Destroy; Override;
    Function Get(Banco: TBanco; Offset: integer = 0; limit: integer = 0): TextJSON;
    Function Put(Banco: TBanco): Boolean;
    Function Post(Banco: TBanco): Boolean;
    function Delete(Banco: TBanco): Boolean;
  End;

implementation


{ TModelBanco }

uses Server.DB;

constructor TModelBanco.Create();
begin
end;

destructor TModelBanco.Destroy;
begin
  inherited;
end;

function TModelBanco.Get(Banco: TBanco; Offset: integer = 0; limit: integer = 0): TextJSON;
begin

  try

    sSQL := Banco.toSQL(acSelect);

    if (limit > 0) then
      sSQL := sSQL + ' Offset ' + IntToStr(Offset) + ' limit ' + IntToStr(limit);

    fDataSet := SqlAll(sSQL);
    Try
      if Banco.Ban_Codigo > 0 then
        Result := Banco.toJSON(fDataSet, jsObject)
      else
        Result := Banco.toJSON(fDataSet, jsArray);

    Finally
      FreeAndNil(fDataSet);
    End;

  except
    On e: Exception do
      raise Exception.Create(e.Message);
  end;

end;

function TModelBanco.Post(Banco: TBanco): Boolean;
begin

  try

    sSQL := Banco.toSQL(acSelect);
    fDataSet := SqlAll(sSQL);
    Try
      sSQL := Banco.toSQL(acAdd);
      if fDataSet.RecordCount = 0 then
        Result := ExecuteSQL(sSQL)
      else
        raise Exception.Create(Format(TXT_EXIST, [IntToStr(Banco.Ban_Codigo), Banco.Ban_Nome]));
    Finally
      FreeAndNil(fDataSet);
    End;

  except
    On e: Exception do
      raise Exception.Create(e.Message);
  end;

end;

function TModelBanco.Put(Banco: TBanco): Boolean;
begin
  try

    sSQL := Banco.toSQL(acSelect);
    fDataSet := SqlAll(sSQL);
    Try
      sSQL := Banco.toSQL(acUpdate);
      if fDataSet.RecordCount > 0 then
        Result := ExecuteSQL(sSQL)
      else
        raise Exception.Create(Format(TXT_NOT_EXIST, [IntToStr(Banco.Ban_Codigo), Banco.Ban_Nome]));
    Finally
      FreeAndNil(fDataSet);
    End;

  except
    On e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TModelBanco.Delete(Banco: TBanco): Boolean;
begin
  try

    sSQL := Banco.toSQL(acSelect);
    fDataSet := SqlAll(sSQL);
    Try
      sSQL := Banco.toSQL(acDelete);
      if fDataSet.RecordCount > 0 then
        Result := ExecuteSQL(sSQL)
      else
        raise Exception.Create(Format(TXT_NOT_EXIST, [IntToStr(Banco.Ban_Codigo), Banco.Ban_Nome]))

    Finally
      FreeAndNil(fDataSet);
    End;

  except
    On e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

end.
