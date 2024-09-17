unit Repository.Interfaces.ICondPagtoRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client;

  type
  ICondPagtoRepository = interface
  ['{761AE571-98B0-4713-9E5D-F493DDCC78FF}']
    function ListarCondPagto: TJSONArray;
  end;

implementation

end.
