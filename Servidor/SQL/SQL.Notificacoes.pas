unit SQL.Notificacoes;

interface

function sqlUpdateNotificLida: string;
function sqlListarNotific: string;

implementation

function sqlUpdateNotificLida: string;
begin
  Result :=
    ' update NOTIFICACAO'+
    ' set IND_LIDO = ''S'' '+
    '   where COD_USUARIO = :COD_USUARIO '+
    '   and IND_LIDO = :IND_LIDO';
end;

function sqlListarNotific: string;
begin
  Result :=
    ' select COD_NOTIFICACAO,'+
    '   DATA_NOTIFICACAO,'+
    '   TITULO,'+
    '   TEXTO'+
    ' from NOTIFICACAO'+
    '   where COD_USUARIO = :COD_USUARIO'+
    '   and IND_LIDO = :IND_LIDO ';
end;
end.
