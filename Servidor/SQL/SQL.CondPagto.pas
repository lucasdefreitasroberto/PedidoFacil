unit SQL.CondPagto;

interface

function sqlListarCondPagto: string;

implementation

{$REGION ' sqlListarCondPagto '}
function sqlListarCondPagto: string;
begin
  Result :=
    ' select COD_COND_PAGTO, COND_PAGTO '+
    ' from COND_PAGTO '+
    ' order by COD_COND_PAGTO ';
end;
{$ENDREGION}

end.
