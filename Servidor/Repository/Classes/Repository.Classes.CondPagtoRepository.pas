unit Repository.Classes.CondPagtoRepository;

interface

uses
  Repository.Interfaces.ICondPagtoRepository,
  System.JSON,
  FireDAC.Comp.Client,
  Classe.Conexao,
  Interfaces.Conexao,
  System.SysUtils,
  System.Variants,
  SQL.CondPagto;

type
  TCondPagtoRepository = class(TInterfacedObject, ICondPagtoRepository)
  public
    function ListarCondPagto: TJSONArray;
  end;

implementation

{ TCondPagtoRepository }

{$REGION ' ListarCondPagto '}
function TCondPagtoRepository.ListarCondPagto: TJSONArray;
begin
  Result :=
    TQueryFD
    .New
    .SQL(SQL.CondPagto.sqlListarCondPagto)
    .Open
    .ToJSONArray;
end;
{$ENDREGION}

end.

