unit uEnviarEmailApiSendGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, dxGDIPlusClasses, JvExControls,
  JvXPCore, JvXPButtons, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox34: TGroupBox;
    Label60: TLabel;
    Label59: TLabel;
    Label66: TLabel;
    Label61: TLabel;
    Label96: TLabel;
    EdtSmtpUser: TEdit;
    EdtSmtpPass: TEdit;
    EdtSMTPFrom: TEdit;
    EdtEmailAssunto: TEdit;
    EdtNomeEmitEmail: TEdit;
    BtnEnvioEmailTeste: TJvXPButton;
    procedure BtnEnvioEmailTesteClick(Sender: TObject);
  private
    procedure CarregarConfiguracaoAPI;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
EnvioEmail.Utils, DadosEnvioEmailModel, Vcl.Dialogs,uEmailAPIConfig;

{$R *.dfm}

procedure TForm1.BtnEnvioEmailTesteClick(Sender: TObject);
var sEmailDest : string;
    dadosEnvio : TDadosEnvioEmail;
    envioTxtTeste : TStringList;
begin


  if (EdtSMTPFrom.text = '') and (EdtSmtpUser.text = '') then
  begin
   showmessage('Informe os dados de configuraÁ„o corretamente');
   exit;
  end;

 CarregarConfiguracaoAPI;


 if InputQuery('Informe o EMAIL de destino', 'EMAIL atual ', sEmailDest) then
  begin


    if sEmailDest = '' then
     showmessage('Destinatario vazio');

    dadosEnvio := TDadosEnvioEmail.new;
    try
      dadosEnvio.Destinatario      := sEmailDest;
      dadosEnvio.NomeDestinatario  := 'cliente teste';
      dadosEnvio.Assunto           := 'Assunto do email de teste';
      dadosEnvio.UsaHTML           := true;
      dadosEnvio.BodyMsgTxt.add('corpo do email de teste');
      dadosEnvio.BodyMsgHtml.add('<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8"></head>' +
                                 '<body text="#000000" bgcolor="#FFFFFF">' +
                                 '<h1>Texto em HTML.</h1><br>' +
                                 '<p>Teste de Envio ¡…Õ”⁄«Á·ÈÌ˙Û ›Õ√„ı’</p><br>' +
                                 '</body></html>');

      envioTxtTeste := TStringList.create;
      envioTxtTeste.Clear;
      envioTxtTeste.Add('=========================================');
      envioTxtTeste.Add('======== Arquivo de texto teste =========');
      envioTxtTeste.Add('=========================================');


        if not DirectoryExists ('C:\EmailAPI') then
        ForceDirectories('C:\EmailAPI');


      envioTxtTeste.SaveToFile(trim('C:\EmailAPI\arquivo_teste.txt'));

      dadosEnvio.Anexos.add('C:\EmailAPI\arquivo_teste.txt');

      if TEnvioEmailControl.new().SendEmail(dadosEnvio,true) then
      begin
        showmessage('Envio de email teste enviado com sucesso!');
      end
      else
      begin
        showmessage('N„o foi possivel enviar email');
      end;

    finally
     FreeAndNil(dadosEnvio);
     freeAndNil(envioTxtTeste);
    end;

  end;
end;
Procedure TForm1.CarregarConfiguracaoAPI;

begin

  Ffrom_email           := EdtSMTPFrom.text;
  Ffrom_name            := EdtNomeEmitEmail.text;
  Fhost_email           := '';
  Fport_email           := 587;
  Ftype_autentication   := 0;
  Fuser_name            := EdtSmtpUser.text;
  Fpassword_email       := EdtSmtpPass.text;
  Fdefault_charset      := 0;


end;
end.
