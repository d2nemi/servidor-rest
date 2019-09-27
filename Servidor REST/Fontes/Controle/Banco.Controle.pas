unit Banco.Controle;

interface

uses
  pngimage,
  JPeg,
  windows,
  Vcl.Graphics,
  System.SysUtils,
  System.Classes,
  StrUtils,
  Banco.Classe,
  Vcl.ExtCtrls,
  Data.DB,
  Banco.Model,
  System.JSON,
  Rest.ConstStr,
  Relatorios.Classe;

Type
  TControleBanco = Class
  private
    PathRel: String;
    ParamID: String;
    FBanco: TBanco;
  Public
    constructor Create;
    destructor Destroy; override;
    Function Get(Params: TStringList): String;
    Function Post(Params: TStringList): String;
    Function Put(Params: TStringList): String;
    Function Delete(Params: TStringList): String;
   // Function Relatorio(Params: TStringList): String;
  End;

implementation


{ TBanco }

constructor TControleBanco.Create;
begin

  FBanco := TBanco.Create;
  

end;

destructor TControleBanco.Destroy;
begin
  inherited;
  if FBanco <> nil then
    FreeAndNil(FBanco);
end;

function TControleBanco.Get(Params: TStringList): String;
var
  limit, Offset: Integer;
begin

  Result := '[]';
  ParamID := Params.Names[0];
  FBanco.Ban_Codigo := StrToIntDef(Params.Values[ParamID], 0);

  limit := StrToIntDef(Params.Values[_PAR_LIMIT], 0);
  Offset := StrToIntDef(Params.Values[_PAR_OFFSET], 0);

  With TModelBanco.Create() do
  begin
    Try
      Result := Get(FBanco, Offset, limit)
    Finally
      Free;
    End;
  end;

end;

function TControleBanco.Delete(Params: TStringList): String;
begin
  ParamID := Params.Names[0];
  FBanco.Ban_Codigo := StrToIntDef(Params.Values[ParamID], 0);
  With TModelBanco.Create do
  begin
    Try

      if Delete(FBanco) then
        Result := '{"result":true,"message":"' + TXT_REGISTRO_EXCLUIDO + '"}';

    Finally
      Free;
    End;
  end;

end;

function TControleBanco.Post(Params: TStringList): String;
var
  JSON: String;
begin

  With TModelBanco.Create do
  begin

    Try
      JSON := Params.Values[_PAR_DATA];
      FBanco.ToObject(JSON);
      if Post(FBanco) then
        Result := '{"result":true,"message":"' + TXT_REGISTRO_INCLUIDO + '"}';

    Finally
      Free;
    End;

  end;

end;

function TControleBanco.Put(Params: TStringList): String;
var
  JSON: String;
begin

  With TModelBanco.Create do
  begin

    Try
      JSON := Params.Values[_PAR_DATA];
      FBanco.ToObject(JSON);
      if Put(FBanco) then
        Result := '{"result":true,"message":"' + TXT_REGISTRO_ATUALIZADO + '"}';

    Finally
      Free;
    End;

  end;

end;


end.
