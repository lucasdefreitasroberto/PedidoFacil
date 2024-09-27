unit Interfaces.Conexao;

interface

uses
  Data.DB,
  System.JSON,
  System.Classes,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.Rtti,
  System.SysUtils,
  FireDAC.Comp.Client;

type
  iQuery = interface

    function StartTransaction: iQuery;
    function SQL(Value: string): iQuery;
    function Params(aParams: string; Value: Variant): iQuery; overload;
    function Params(aParams: string; Value: TPersistent): iQuery; overload;
    function Params(aParams: string): Variant; overload;
    function Open: iQuery;
    function ExecSQL: iQuery;
    function DataSet(Value: TDataSource): iQuery; overload;
    function DataSet: TDataSet; overload;
    function Commit: iQuery;
    function Rollback: iQuery;
    function ToJSONObject: TJSONObject;
    function ToJSONArray: TJSONArray;
    function ToBlobStream(aParams: string): TStream;
    function ToStream: TStream;
    procedure Free;
  end;

implementation

end.

