unit Repository.Classes.NotificacoesRepository;

interface
uses
  Horse,
  System.JSON,
  Repository.Interfaces.INotificacoesRepository,
  Controller.Auth,
  DM.Conexao,
  SQL.Notificacoes,
  Classe.Conexao;

type
  TNotificacoesRepository = class(TInterfacedObject, INotificacoesRepository)
  private
    procedure MarcarNotificacoesLidas(CodUsuario: Integer);
  public
    function RListarNotificacoes(Req: THorseRequest): TJSONArray;
    Class function New: INotificacoesRepository;
  end;
implementation

{ TNotificacoesRepository }

class function TNotificacoesRepository.New: INotificacoesRepository;
begin
  Result := Self.Create;
end;

{$REGION ' SListarNotificacoes '}
function TNotificacoesRepository.RListarNotificacoes(Req: THorseRequest): TJSONArray;
begin
  var
    LCodigoUsuario := Controller.Auth.Get_Usuario_Request(Req);
  try
    Result :=
      TQueryFD.New
        .SQL(SQL.Notificacoes.sqlListarNotific)
        .Params('COD_USUARIO', LCodigoUsuario)
        .Params('IND_LIDO', 'N')
        .Open
        .ToJSONArray;
  finally
    Self.MarcarNotificacoesLidas(LCodigoUsuario);
  end;
end;
{$ENDREGION}

{$REGION ' MarcarNotificacoesLidas '}
procedure TNotificacoesRepository.MarcarNotificacoesLidas(CodUsuario: Integer);
begin
  TQueryFD.New
    .SQL(SQL.Notificacoes.sqlUpdateNotificLida)
    .Params('COD_USUARIO', CodUsuario)
    .Params('IND_LIDO', 'N')
    .ExecSQL;
end;
{$ENDREGION}

end.
