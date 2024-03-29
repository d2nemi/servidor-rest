unit Relatorios.Classe;

interface

uses
  System.SysUtils,
  System.Classes,
  Db,
  frxClass,
  frxDBSet,
  frxExportBaseDialog,
  frxExportPDF;

Type
  TRelBase = Class
  Public
    FDataSet: TDataSet;
    FReport: TfrxReport;
    FPDFExport: TfrxPDFExport;
    FDBDataset: TfrxDBDataset;
    Constructor Create();
    destructor Destroy; override;
    Function GerarRelotrio(FileName: String): String;
  End;

Type
  TRelBanco = Class
  Public
    Function Exportar(vParams: TStringList): String;
  End;

Type
  TRelatorio = Class
  private
    FRelBanco: TRelBanco;
  public
    Constructor Create();
    destructor Destroy; override;
    Property Bancos: TRelBanco read FRelBanco write FRelBanco;
  End;

var
  PathRelDir: String;

implementation

{ TRelBase }

uses Banco.Classe, Server.Db;

Constructor TRelBase.Create();
begin
  FPDFExport := TfrxPDFExport.Create(nil);
  FPDFExport.DefaultPath := ExtractFilePath(ParamStr(0)) + 'files';
  FPDFExport.ShowDialog := false;
  FPDFExport.ShowProgress := false;

  FDBDataset := TfrxDBDataset.Create(nil);
  FDBDataset.UserName := 'DBRelatorio';

  FReport := TfrxReport.Create(nil);
  FReport.PrintOptions.ShowDialog := false;

end;

Destructor TRelBase.Destroy;
begin
  inherited;

  if FPDFExport <> nil then
    FreeAndNil(FPDFExport);

  if FReport <> nil then
    FreeAndNil(FReport);

  if FDBDataset <> nil then
    FreeAndNil(FDBDataset);
end;

Function TRelBase.GerarRelotrio(FileName: String): String;
var
  lFileName: String;
begin

  // Nota: Corrigir o problema para multiplos acesso, para um usuario nao pegar o relatoro do outro.
  // incluidr o ID do usuario no nome do arquivo para corrigir o problema. "RelBancos_01.pdf"

  Try
    lFileName := ChangeFileExt(FileName, '.pdf');
    lFileName := LowerCase(lFileName);

    if (ExtractFilePath(lFileName) <> EmptyStr) and
      (ExtractFilePath(lFileName) <> FPDFExport.DefaultPath) and
      DirectoryExists(ExtractFilePath(lFileName)) then
      FPDFExport.DefaultPath := ExtractFilePath(lFileName);

    FPDFExport.FileName := ExtractFileName(lFileName);

    if FileExists(IncludeTrailingPathDelimiter(FPDFExport.DefaultPath) + FPDFExport.FileName) then
      DeleteFile(IncludeTrailingPathDelimiter(FPDFExport.DefaultPath) + FPDFExport.FileName);


    FReport.PrepareReport(True);
    FReport.Export(FPDFExport);

    Result := IncludeTrailingPathDelimiter(FPDFExport.DefaultPath) + FPDFExport.FileName;

  Except
    On e: exception do
    begin
      Result := '';
      raise exception.Create('Erro gerar o arquivo PDF do relatorio Erro: ' + e.Message);
    end;

  End;

end;

{ TRelatorio }

constructor TRelatorio.Create;
begin
  PathRelDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Relatorios');
  FRelBanco := TRelBanco.Create;
end;

Destructor TRelatorio.Destroy;
begin
  inherited;
  if FRelBanco <> nil then
    FreeAndNil(FRelBanco);
end;

{ TRelBanco }
function TRelBanco.Exportar(vParams: TStringList): String;
var
  sSql,RelName: String;
  Banco: TBanco;
begin

  With TRelBase.Create do
  begin
    Banco := TBanco.Create;
    try
      //Relatorio de listagem
      RelName:='banco.listar.fr3';
      sSql := Banco.toSQL();

      if Assigned(vParams) and
         (vParams.Count > 0) and
         (vParams.IndexOfName('ban_codigo')>-1)
         then
      begin

          //Relatorio de detalhe do banco
          RelName:='banco.detalhe.fr3';
          Banco.Ban_Codigo := StrToIntDef(vParams.Values['ban_codigo'], 0);
          sSql := Banco.toSQL();

      end
      else if Assigned(vParams) and
         (vParams.Count > 1) and
         (vParams.IndexOfName('offset')>-1) and (vParams.IndexOfName('limit')>-1)
         then
      begin
        sSql := Banco.toSQL();
         sSql :=sSql + 'where ban_codigo between '+vParams.Values['offset']+ ' and ' + vParams.Values['limit']
      end;

      sSql := sSql + Banco.toOrderBy;
      FDataSet := SqlAll(sSql);

      FDBDataset.DataSet := FDataSet;

      FReport.DataSet:=FDBDataset;
      FReport.LoadFromFile(PathRelDir + RelName);
      //FReport.GetDataset('DBRelatorio');
      Result := GerarRelotrio(self.ClassName);

    finally

      if Assigned(FDataSet) then
        FreeAndNil(FDataSet);

      if Assigned(Banco) then
        FreeAndNil(Banco);

      Free;
    end;
  end;

end;

end.
