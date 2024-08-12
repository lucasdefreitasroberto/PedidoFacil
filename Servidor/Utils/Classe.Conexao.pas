unit Classe.Conexao;

interface

uses
  Interfaces.Conexao, Data.DB, DM.Conexao, FireDAC.Comp.Client,
  DataSet.Serialize, System.JSON, System.SysUtils;

type
  TQueryFD = class(TInterfacedObject, iQuery)
  private
    FDBaseConexao: TDMConexao;
    FDQuery: TFDQuery;
  public
    constructor Create;
    destructor Destroy; override;

    function StartTransaction: iQuery;
    function SQL(Value: string): iQuery;
    function Params(aParams: string; Value: Variant): iQuery; overload;
    function Params(aParams: string): Variant; overload;
    function Open: iQuery;
    function ExecSQL: iQuery;
    function DataSet(Value: TDataSource): iQuery; overload;
    function DataSet: TDataSet; overload;
    function Commit: iQuery;
    function Rollback: iQuery;
    function ToJSONObject: TJSONObject; overload;
    procedure Free;
  end;

implementation

{ TQueryFD }

constructor TQueryFD.Create;
begin
  if not Assigned(FDBaseConexao) then
    FDBaseConexao := TDMConexao.Create;

  FDQuery := TFDQuery.Create(nil);
  FDQuery.Connection := FDBaseConexao.con;
end;

destructor TQueryFD.Destroy;
begin
  FDBaseConexao.Free;
  FDQuery.Free;
  inherited;
end;

procedure TQueryFD.Free;
begin
  FreeAndNil(FDBaseConexao);
  FreeAndNil(FDQuery);
end;

function TQueryFD.Commit: iQuery;
begin
  Result := Self;
  FDBaseConexao.con.Commit;
end;

function TQueryFD.DataSet: TDataSet;
begin
  Result := FDQuery;
end;

function TQueryFD.DataSet(Value: TDataSource): iQuery;
begin
  Result := Self;
  Value.DataSet := FDQuery;
end;

function TQueryFD.ExecSQL: iQuery;
begin
  Result := Self;
  FDQuery.ExecSQL(True);
end;

function TQueryFD.ToJSONObject: TJSONObject;
begin
  Result := FDQuery.ToJSONObject;
end;

function TQueryFD.Open: iQuery;
begin
  Result := Self;
  FDQuery.Open;
end;

function TQueryFD.Params(aParams: string; Value: Variant): iQuery;
begin
  Result := Self;
  FDQuery.ParamByName(aParams).Value := Value;
end;

function TQueryFD.Params(aParams: string): Variant;
begin
  Result := FDQuery.ParamByName(aParams).Value;
end;

function TQueryFD.Rollback: iQuery;
begin
  Result := Self;
  FDBaseConexao.con.Rollback;
end;

function TQueryFD.SQL(Value: string): iQuery;
begin
  Result := Self;
  FDQuery.Close;
  FDQuery.SQL.Clear;
  FDQuery.SQL.Add(Value);
end;

function TQueryFD.StartTransaction: iQuery;
begin
  Result := Self;
  FDBaseConexao.con.StartTransaction;
end;

end.

