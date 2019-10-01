unit uDmServer;

interface

uses
  System.SysUtils,
  System.Classes,
  IdContext,
  IdBaseComponent,
  IdComponent,
  IdCustomTCPServer,
  IdCustomHTTPServer,
  IdHTTPServer,
  Client.Context,
  Rest.Server,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.FB, FireDAC.Comp.UI, FireDAC.Comp.Client, Data.DB, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDmServer = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure ServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmServer: TDmServer;

implementation

uses
  System.JSON;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TDmServer.DataModuleCreate(Sender: TObject);
begin
  Server.OnCommandGet := ServerCommandGet;
  Server.OnCommandOther := ServerCommandGet;
end;

procedure TDmServer.ServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  ErroTxt: TJSONString;
begin

  AResponseInfo.CustomHeaders.AddValue('Access-Control-Allow-Origin', '*');
  AResponseInfo.CacheControl := 'no-store, no-cache, must-revalidate';
  AResponseInfo.CustomHeaders.AddValue('Access-Control-Max-Age', '86400');
  AResponseInfo.CustomHeaders.AddValue('Keep-Alive', 'timeout=5, max=100');
  AResponseInfo.CustomHeaders.AddValue('Access-Control-Request-Headers', 'accept, origin, Content-Type, Authorization, X-Requested-With');
  AResponseInfo.CustomHeaders.AddValue('Access-Control-Allow-Headers', 'accept, origin, Content-Type, Authorization, X-Requested-With, key, token');
  AResponseInfo.CustomHeaders.AddValue('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');

  AResponseInfo.ContentEncoding := 'UTF8';
  AResponseInfo.ContentType := 'application/json';
  AResponseInfo.ContentText := '{}';
  AResponseInfo.ResponseNo := 200;

  if ARequestInfo.URI = '/favicon.ico' then
  begin
    AResponseInfo.ResponseNo := 403;
    exit;
  end;

  Try

    with TClientContext.Create(AContext.Connection) do
      try

        if (ARequestInfo.CommandType in [hcGET, hcPOST, hcDELETE, hcPUT]) then
          HandleRequest(AContext, ARequestInfo, AResponseInfo);

      finally
        Free;
      end;

  Except
    // Tem que fica aqui para evitar, erro de MemoryLeaks  em multiplas solicitações cancelas
    on E: Exception do
    begin
      ErroTxt := TJSONString.Create(E.Message);
      Try
        AResponseInfo.ContentText := '{"result":false,"message":' + ErroTxt.ToJSON + '}';
      Finally
        ErroTxt.Free;
      End;
    end;
  end;

end;

end.
