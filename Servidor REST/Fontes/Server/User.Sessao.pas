unit User.Sessao;

interface

Uses SyncObjs,
  System.SysUtils,
  System.Classes;

Type
  TBasicAuthentication = class
  private
    FPassword: String;
    FUserName: String;
    FKey: String;
    FActive: Boolean;
    FIndex: Integer;
  public
  Published
    Property Active: Boolean Read FActive Write FActive Default false;
    Property UserName: String Read FUserName Write FUserName;
    Property Password: String Read FPassword Write FPassword;
    Property Key: String Read FKey Write FKey;
    Property Index: Integer Read FIndex Write FIndex;
  End;

Type
  TUserSessao = Class
  private
    FListSessao: TList;
    constructor Create();
  public
    class function New(): TUserSessao;
    class procedure ReleaseInstance();
    destructor Destroy(); override;

    procedure Add(UserSessao: TBasicAuthentication);
    procedure Remove(Index: Integer);
    procedure Clean;
    function Count: Integer;

    Function Sessao(Key: String): TBasicAuthentication;
  Published

  End;

var
  FInstance: TUserSessao;
  Lock: TCriticalSection;

implementation


constructor TUserSessao.Create;

begin

  if not Assigned(FInstance) then
  begin
    inherited Create;
    FListSessao := TList.Create;

  end;

end;

destructor TUserSessao.Destroy();
begin

  inherited;
  if Assigned(FListSessao) then
  begin
    Try
      Clean();
    Except
    End;
    FreeAndNil(FListSessao);
  end;

end;

class function TUserSessao.New: TUserSessao;
begin

  Try
    Lock.Acquire;

    if not Assigned(FInstance) then
      FInstance := TUserSessao.Create;

    Result := FInstance;

  Finally
    Lock.Release;
  End;

end;

class procedure TUserSessao.ReleaseInstance;
begin

  Try
    Lock.Acquire;
    if Assigned(FInstance) then
      FInstance.Free;
  Finally
    Lock.Release;

  End;

end;

function TUserSessao.Sessao(Key: String): TBasicAuthentication;
var
  i: Integer;
begin

  Result := nil;
  for i := 0 to FListSessao.Count - 1 do
  begin
    if FListSessao[i] <> nil then
      if (TBasicAuthentication(FListSessao[i]) is TBasicAuthentication) then
        if (TBasicAuthentication(FListSessao[i]).Key = Key) then
          Result := TBasicAuthentication(FListSessao[i]);
  end;

end;

procedure TUserSessao.Add(UserSessao: TBasicAuthentication);
var
  SessaoOLD: TBasicAuthentication;
begin

  Try

    Lock.Acquire;
    SessaoOLD := Sessao(UserSessao.Key);
    if SessaoOLD = Nil then
    begin
      UserSessao.Index := Count;
      FListSessao.Add(UserSessao);
    end
    else
    begin
      // Remove a sessão da antiga lista
      Remove(SessaoOLD.Index);
      // Remove a sessão antiga  da memoria
      SessaoOLD.Free;
      // Incluir uma nova na lista
      FListSessao.Add(UserSessao);
    end;

  Finally
    Lock.Release;
  End;

end;

procedure TUserSessao.Clean;
var
  i, t: Integer;
begin

  Try
    Lock.Acquire;

    for i := Count - 1 downto 0 do
    begin

      if Assigned(TBasicAuthentication(FListSessao[i])) then
        TBasicAuthentication(FListSessao[i]).Free;

      Remove(i);
    end;

  Finally
    Lock.Release;
  End;

end;

function TUserSessao.Count: Integer;
begin
  if FListSessao.Count > 0 then
    Result := FListSessao.Count
  else
    Result := 0;
end;

procedure TUserSessao.Remove(Index: Integer);
begin

  Try
    Lock.Acquire;
    if Index <= Count - 1 then
    begin
      FListSessao.Delete(Index)
    end;
  Finally
    Lock.Release;
  End;

end;

initialization

FInstance := Nil;
Lock := TCriticalSection.Create;

finalization

TUserSessao.ReleaseInstance();
Lock.Free;

end.
