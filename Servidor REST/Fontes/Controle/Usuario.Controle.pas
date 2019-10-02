unit Usuario.Controle;

interface

uses
  windows,
  System.SysUtils,
  System.Classes,
  Vcl.ExtCtrls,
  StrUtils,
  Usuario.Classe,
  Usuario.Model,
  Rest.ConstStr;

Type
  TControleUsuario = Class
  private
    ParamID: String;
    FUsuario: TUsuario;
  Public
    constructor Create;
    destructor Destroy; override;
    Function Get(Params: TStringList): String;
    Function Post(Params: TStringList): String;
    Function Put(Params: TStringList): String;
    Function Delete(Params: TStringList): String;
  End;

implementation


{ TUsuario }

constructor TControleUsuario.Create;
begin

  FUsuario := TUsuario.Create;

end;

destructor TControleUsuario.Destroy;
begin
  inherited;
  if FUsuario <> nil then
    FreeAndNil(FUsuario);
end;

function TControleUsuario.Get(Params: TStringList): String;
var
  limit, Offset: Integer;
begin

  Result := '[]';
 // if Params.IndexOfName('Use_Codigo') > -1 then
 // begin
    //ParamID := Params.Names[Params.IndexOfName('Use_Codigo')];
    FUsuario.Use_Codigo := StrToIntDef(Params.Values['Use_Codigo'], 0);
  //end;

  limit := StrToIntDef(Params.Values[_PAR_LIMIT], 0);
  Offset := StrToIntDef(Params.Values[_PAR_OFFSET], 0);

  With TModelUsuario.Create() do
  begin
    Try
      Result := Get(FUsuario, Offset, limit)
    Finally
      Free;
    End;
  end;

end;

function TControleUsuario.Delete(Params: TStringList): String;
begin

  if Params.IndexOfName('Use_Codigo') > -1 then
  begin
    ParamID := Params.Names[Params.IndexOfName('Use_Codigo')];
    FUsuario.Use_Codigo := StrToIntDef(Params.Values[ParamID], 0);
  end;

  With TModelUsuario.Create do
  begin
    Try

      if Delete(FUsuario) then
        Result := '{"result":true,"message":"' + TXT_REGISTRO_EXCLUIDO + '"}';

    Finally
      Free;
    End;
  end;

end;

function TControleUsuario.Post(Params: TStringList): String;
var
  JSON: String;
begin

  With TModelUsuario.Create do
  begin

    Try
      JSON := Params.Values[_PAR_DATA];
      FUsuario.ToObject(JSON);
      if Post(FUsuario) then
        Result := '{"result":true,"message":"' + TXT_REGISTRO_INCLUIDO + '"}';

    Finally
      Free;
    End;

  end;

end;

function TControleUsuario.Put(Params: TStringList): String;
var
  JSON: String;
begin

  With TModelUsuario.Create do
  begin

    Try
      JSON := Params.Values[_PAR_DATA];
      FUsuario.ToObject(JSON);
      if Put(FUsuario) then
        Result := '{"result":true,"message":"' + TXT_REGISTRO_ATUALIZADO + '"}';

    Finally
      Free;
    End;

  end;

end;

end.
