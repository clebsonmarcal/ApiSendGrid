unit DadosEnvioEmailModel;

interface

uses  System.classes;

 type
  TDadosEnvioEmail = Class
  private
   FDestinatario     : string;
   FNomeDestinatario : string;
   FAssunto          : string;
   FUsaHTML          : boolean;
   FBodyMsgTxt       : TStringList;
   FBodyMsgHtml      : TStringList;
   FAnexos           : TStringList;

  public
   property Destinatario      : string       read FDestinatario      write FDestinatario;
   property NomeDestinatario  : string       read FNomeDestinatario  write FNomeDestinatario;
   property Assunto           : string       read FAssunto           write FAssunto;
   property BodyMsgTxt        : TStringList  read FBodyMsgTxt        write FBodyMsgTxt;
   property BodyMsgHtml       : TStringList  read FBodyMsgHtml       write FBodyMsgHtml;
   property UsaHTML           : boolean      read FUsaHTML           write FUsaHTML;
   property Anexos            : TStringList  read FAnexos            write FAnexos;

   Constructor Create;
   Destructor Destroy;

    class function new: TDadosEnvioEmail;
  End;

implementation

{ TDadosEnvioEmail }

constructor TDadosEnvioEmail.Create;
begin
  inherited
end;

destructor TDadosEnvioEmail.Destroy;
begin
  inherited
end;

class function TDadosEnvioEmail.new: TDadosEnvioEmail;
begin
  result := self.create;
  result.FBodyMsgTxt      := TStringList.create;
  result.FBodyMsgHtml     := TStringList.create;
  result.FAnexos          := TStringList.create;
end;

end.
