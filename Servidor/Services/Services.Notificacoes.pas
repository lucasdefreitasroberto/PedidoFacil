unit Services.Notificacoes;

interface

uses
  system.JSON,
  DataSet.Serialize,
  Utilitarios,
  System.SysUtils,
  DM.Conexao,
  Data.DB,
  FireDAC.Comp.Client,
  HashXMD5,
  Horse.Exception,
  Horse.HandleException,
  Horse.Commons,
  Controller.Auth,
  Horse,
  Interfaces.Conexao,
  Classe.Conexao;
type
  TServicesNotificacoes = class(TDMConexao)
  private
    procedure MarcarNotificacoesLidas(CodUsuario: Integer);
  public
    function SListarNotificacoes(Req: THorseRequest): TJSONArray;
  end;
implementation

{ TServicesNotificacoes }

{$REGION ' MarcarNotificacoesLidas '}

procedure TServicesNotificacoes.MarcarNotificacoesLidas(CodUsuario: Integer);
begin
 var LSQL := ' update NOTIFICACAO'+
             ' set IND_LIDO = ''S'' '+
             ' where COD_USUARIO = :COD_USUARIO '+
             ' and IND_LIDO = :IND_LIDO';

 var FQuery := TQueryFD.Create;
 try
   FQuery
    .SQL(LSQL)
    .Params('COD_USUARIO', CodUsuario)
    .Params('IND_LIDO', 'N')
    .ExecSQL;
 finally
   FQuery.Free;
 end;
end;

{$ENDREGION}

{$REGION ' SListarNotificacoes '}

function TServicesNotificacoes.SListarNotificacoes(Req: THorseRequest): TJSONArray;
begin
  var LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);

  var LSQL := ' select'+
              ' COD_NOTIFICACAO,'+
              ' DATA_NOTIFICACAO,'+
              ' TITULO,'+
              ' TEXTO'+
              ' from NOTIFICACAO'+
              ' where COD_USUARIO = :COD_USUARIO'+
              ' and IND_LIDO = :IND_LIDO ';
  try
    var FQuery := TQueryFD.Create;
    try
       Result := FQuery
                   .SQL(LSQL)
                   .Params('COD_USUARIO', LCodigoUsuario)
                   .Params('IND_LIDO', 'N')
                   .Open
                   .ToJSONArray;
    finally
      FQuery.Free;
    end;
  finally
    //Se conseguir ler as notificações ela é marcarcada como lidas
    Self.MarcarNotificacoesLidas(LCodigoUsuario);
  end;

end;

{$ENDREGION}

end.
