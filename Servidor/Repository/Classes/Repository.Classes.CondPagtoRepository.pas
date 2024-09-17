unit Repository.Classes.CondPagtoRepository;

interface

uses
  Repository.Interfaces.ICondPagtoRepository,
  System.JSON,
  FireDAC.Comp.Client,
  Classe.Conexao,
  System.SysUtils,
  System.Variants,
  SQL.CondPagto;

type
  TCondPagtoRepository = class(TInterfacedObject, ICondPagtoRepository)
    private
    FQuery: TQueryFD;
  public
    function ListarCondPagto: TJSONArray;
  end;

implementation

{ TCondPagtoRepository }

{$REGION ' ListarCondPagto '}
function TCondPagtoRepository.ListarCondPagto: TJSONArray;
begin
  FQuery := TQueryFD.Create;
  try
    Result :=
      FQuery
      .SQL(SQL.CondPagto.sqlListarCondPagto)
      .Open
      .ToJSONArray;
  finally
    FQuery.Free;
  end;
end;
{$ENDREGION}

end.

