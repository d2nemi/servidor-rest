unit Login.Model;

interface

Uses
  Login.Classe,
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
  TModelLogin = Class(TInterfacedObject, IModelLogin)
  Private
    sSQL: String;
    fDataSet: TDataSet;
    lResult: Boolean;
  Public
    Function Login(Login: TLogin): TextJSON;
  End;

implementation

uses Server.DB, Rest.Utils, User.sessao;

{ TModelLogin }

function TModelLogin.Login(Login: TLogin): TextJSON;
var
  SrJSON: String;
  LoginSessao: TLogin;
begin

  try

    SrJSON := '{"result":true, "username":"%S", "email":"%S", "token":"%S"}';
    sSQL := Login.Usuario.toSQL(acSelect);

    sSQL := sSQL + ' where  Use_login= ' + QuotedStr(Login.Usuario.Use_login) + ' and Use_password=' + QuotedStr(EncodeMD5(Login.Usuario.Use_password));

    fDataSet := SqlAll(sSQL);
    Try
      if fDataSet.RecordCount > 0 then
      begin

        Result := Format(SrJSON,
          [
          UTF8Encode(fDataSet.FieldByName('Use_nome').AsString),
          UTF8Encode(fDataSet.FieldByName('Use_mail').AsString),
          UTF8Encode(Login.Token)
          ]);

         //Login para salvar a sessão do usuario, nao pode ser destruido
         LoginSessao:=TLogin.Create;
         LoginSessao.Usuario.Use_Codigo:=Login.Usuario.Use_Codigo;
         LoginSessao.Usuario.Use_Nome:=Login.Usuario.Use_Nome;
         LoginSessao.Usuario.Use_login:=Login.Usuario.Use_login;
         LoginSessao.Usuario.Use_mail:=Login.Usuario.Use_mail;

         LoginSessao.DataLogin:=Login.DataLogin;
         LoginSessao.Token:=Login.Token;
         LoginSessao.Host:=Login.Host;

         TUserSessao.New.Add(LoginSessao);

      end
      else
        raise Exception.Create('Usuário ou senha incorreto, tente novamente');

    Finally
      FreeAndNil(fDataSet);
    End;

  except
    On e: Exception do
      raise Exception.Create(e.Message);
  end;

end;

end.
