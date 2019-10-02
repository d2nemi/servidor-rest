unit Login.Classe;

interface

Uses
  Db,
  System.SysUtils,
  System.Classes,
  StrUtils,
  System.JSON,
  Rest.ConstStr,
  Rest.Utils,
  Usuario.Classe;

Type
  TLogin = Class
  private
    FUsuario: TUsuario;
    FToken: String;
    FDataLogin: TDateTime;
    FHost: String;
    FIndex: Integer;
    FActive: Boolean;
    function GetToken: String;
    function GetActive: Boolean;
  Public
    Constructor Create();
    Destructor Destroy(); override;
    Property Usuario: TUsuario read FUsuario write FUsuario;
    Property Token: String read GetToken write FToken;
    Property DataLogin: TDateTime read FDataLogin write FDataLogin;
    Property Host: String read FHost write FHost;
    Property Index: Integer Read FIndex Write FIndex;
    Property Active: Boolean Read GetActive Write FActive Default false;
  End;

implementation

{ TLogin }
constructor TLogin.Create;
begin
  FUsuario := TUsuario.Create;
end;

destructor TLogin.Destroy;
begin

  inherited;

  if Assigned(FUsuario) then
    FreeAndNil(FUsuario);

end;

function TLogin.GetActive: Boolean;
var ss:String;
begin
  Result :=  FDataLogin >= Now();
end;

function TLogin.GetToken: String;
begin

  if FToken=EmptyStr then
    FToken := EncodeMD5(FormatDateTime('sszzz', now()) + Usuario.Use_login + FormatDateTime('zzzss', now()));

  Result := FToken;



end;

end.
