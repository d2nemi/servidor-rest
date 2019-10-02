unit Login.Controle;

interface

uses
  windows,
  ExtCtrls,
  StrUtils,
  System.SysUtils,
  System.Classes,
  Login.Classe,
  DateUtils,
  Login.Model;

Type
  TControleLogin = class
  private
    FLogin: TLogin;
  public
    constructor Create;
    destructor Destroy; override;
    Function Login(Params: TStringList): String;
  end;

implementation

{ TControleLogin }

constructor TControleLogin.Create;
begin
  FLogin := TLogin.Create;
end;

destructor TControleLogin.Destroy;
begin

  inherited;
  if FLogin <> nil then
    FreeAndNil(FLogin);

end;

function TControleLogin.Login(Params: TStringList): String;
begin
  Result := '[]';
  // if (Params.IndexOfName('username') > -1) and (Params.IndexOfName('username') > -1) then
  // begin

  FLogin.Usuario.Use_login := Params.Values['username'];
  FLogin.Usuario.use_password := Params.Values['password'];
  FLogin.DataLogin := IncHour(Now(),4);
  FLogin.Host := Params.Values['host'];

  // Evitar SQLInjection
  FLogin.Usuario.Use_login := StringReplace(FLogin.Usuario.Use_login, '''', '', [rfReplaceAll]);
  FLogin.Usuario.Use_login := StringReplace(FLogin.Usuario.Use_login, ' ', '', [rfReplaceAll]);

  FLogin.Usuario.use_password := StringReplace(FLogin.Usuario.use_password, '''', '', [rfReplaceAll]);
  FLogin.Usuario.use_password := StringReplace(FLogin.Usuario.use_password, ' ', '', [rfReplaceAll]);

  // end;

  if Trim(FLogin.Usuario.Use_login) = EmptyStr then
    raise Exception.Create('Usuário Requerido');

  if Length(FLogin.Usuario.Use_login) > 50 then
    raise Exception.Create('Usuário e muito longo, Usuário invalido');

  With TModelLogin.Create() do
  begin
    Try
      Result := Login(FLogin)
    Finally
      Free;
    End;
  end;

end;

end.
