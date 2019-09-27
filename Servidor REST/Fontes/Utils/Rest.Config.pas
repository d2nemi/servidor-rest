unit Rest.Config;

interface

Uses
  System.IniFiles,
  System.SysUtils;

Type
  TMethods = (mAll, mGet, mPost, mPut, mDelete);

var
  AppConServer,
    AppConPorta,
    AppConDataBase,
    AppConUsername,
    AppConPassword,
    RESTPortHTTP,
    RESTPortSSL,
    AppDirCertFile:
    String;
    AppAuthentication,
    AppUserSSL:Boolean;

Procedure SaveConfig();
Procedure LoardConfig();

implementation


Procedure LoardConfig();
begin
  with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
    Try
      AppConServer := ReadString('conexao', 'Server', '127.0.0.1');
      AppConPorta := ReadString('conexao', 'porta', '3050');
      AppConDataBase := ReadString('conexao', 'DataBase', ExtractFilePath(ParamStr(0)) + '..\Banco\EMPLOYEE.FDB');
      AppConUsername := ReadString('conexao', 'Username', 'SYSDBA');
      AppConPassword := ReadString('conexao', 'Password', 'masterkey');

      RESTPortHTTP := ReadString('REST', 'PortHTTP', '80');
      RESTPortSSL := ReadString('REST', 'PortSSL', '443');
      AppDirCertFile := ReadString('REST', 'DirCertFile', ExtractFilePath(ParamStr(0)) + 'ssl');
      AppAuthentication := ReadBool('REST', 'Authentication', false);
      AppUserSSL:= ReadBool('REST', 'UserSSL', false);
    Finally
      Free;
    End;

end;

Procedure SaveConfig();
begin

  with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
    Try
      WriteString('conexao', 'Server', AppConServer);
      WriteString('conexao', 'porta', AppConPorta);
      WriteString('conexao', 'DataBase', AppConDataBase);
      WriteString('conexao', 'Username', AppConUsername);
      WriteString('conexao', 'Password', AppConPassword);

      WriteString('REST', 'PortHTTP', RESTPortHTTP);
      WriteString('REST', 'PortSSL', RESTPortSSL);
      WriteString('REST', 'DirCertFile', AppDirCertFile);
      WriteBool('REST', 'UserSSL', AppUserSSL);
      WriteBool('REST', 'Authentication', AppAuthentication);
    Finally
      Free;
    End;

end;

Initialization

LoardConfig();

Finalization

//

end.
