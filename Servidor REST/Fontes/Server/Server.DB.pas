unit Server.DB;

// Cada Classe vai ter sua propria conexao, assim evitamos dixa uma conexao por varios dias,
// correndo o risco dela cair e prejutica o sistema.

interface

Uses
  Rest.Config,
  System.SysUtils,
  Data.DB,
  // Uses do FireDAC
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.FB, FireDAC.Comp.UI, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

Function SqlAll(sSQL: String): TFDQuery;
Function ExecuteSQL(sSQL: String): Variant;

implementation

Var
  FDConnection: TFDConnection;

Function MyConnection: TFDConnection;

begin

  Try
    if Not FDConnection.Connected then
    begin
      FDConnection.LoginPrompt := false;
      FDConnection.Params.Clear;
      FDConnection.Params.Add('Database=' + AppConDataBase);
      FDConnection.Params.Add('User_Name=' + AppConUsername);
      FDConnection.Params.Add('Password=' + AppConPassword);
      FDConnection.Params.Add('Server=' + AppConServer);
      FDConnection.Params.Add('Port=' + AppConPorta);
      FDConnection.Params.Add('DriverID=FB');
      FDConnection.Params.Add('Protocol=TCPIP');
      FDConnection.Open();
    end;

    Result := FDConnection;
  Except
    ON E: Exception do
      raise Exception.Create('Erro ao estabecer a conexao com banco de dados Paramentros  Erro: ' + E.Message);
  End;

end;

Function SqlAll(sSQL: String): TFDQuery;
Var
  lQry: TFDQuery;
begin

  Try
    Try

      lQry := TFDQuery.Create(nil);
      lQry.Connection := MyConnection;
      lQry.SQL.Text := lowercase(sSQL);
      lQry.Open();

    Except
      On E: Exception do
      begin
        lQry.Free;
        raise Exception.Create('Erro ao excutadar o comando sql ' + sSQL + ' Erro: ' + E.Message);
      end;
    End;

  Finally
    Result := lQry;
  End;

end;

Function ExecuteSQL(sSQL: String): Variant;
begin

  With TFDQuery.Create(nil) do
  begin
    Try
      Try

        Connection := MyConnection;
        SQL.Text := sSQL;

        ExecSQL();

        Result := RowsAffected > 0;

      Except
        On E: Exception do
        begin
          raise Exception.Create(E.Message);
        end;
      End;
    Finally
      Free;
    End;
  end;

end;

Initialization

FDConnection := TFDConnection.Create(nil);

Finalization

if FDConnection.Connected then
  FDConnection.Close;

FreeAndNil(FDConnection);

end.
