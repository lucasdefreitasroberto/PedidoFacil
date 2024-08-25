unit Interfaces.Conexao;

interface

uses
  Data.DB,
  System.JSON,
  System.Classes;

type
  iQuery = interface

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
    function ToJSONObject: TJSONObject;
    function ToJSONArray: TJSONArray;
    function ToBlobStream(AValue: string): TStream;
    procedure Free;
  end;

implementation

end.

