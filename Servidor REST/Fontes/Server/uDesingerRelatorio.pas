unit uDesingerRelatorio;

interface

uses
  System.SysUtils, System.Classes, frxClass, frxDBSet, frxExportBaseDialog, frxExportPDF, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase, FireDAC.Comp.UI, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDesignerRelatorios = class(TDataModule)
    DesignerRelatorio: TfrxReport;
    DesignerDBDataSet: TfrxDBDataset;
    DesignerConexao: TFDConnection;
    QrDesigner: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  DesignerRelatorios: TDesignerRelatorios;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}


uses Relatorios.Classe;

{$R *.dfm}


procedure TDesignerRelatorios.DataModuleCreate(Sender: TObject);
begin
  //Nao pode existir em runtime
  FreeAndNil(DesignerDBDataSet);
end;


end.
