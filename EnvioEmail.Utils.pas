unit EnvioEmail.Utils;

interface

uses
  System.SysUtils,DataSetConverter4D, System.Classes,
  DataSetConverter4D.Impl,System.JSON, System.StrUtils,System.NetEncoding,IdCoderMIME,
  RestConsumeAPI,REST.Types,REST.Json,Generics.Collections, EnvioEmailModel, DadosEnvioEmailModel,ACBrMail,
  uEmailAPIConfig;

type
 iEnvioEmail = interface
   ['{87820721-8669-4098-9BCE-0F72249A7486}']

 function getAllConfigEmail():TList<TEnvioEmail>;
 function SendEmail(DadosEnvioEmail : TDadosEnvioEmail ; bAbreMsg : boolean = true ; bUsaThread : boolean = false) : boolean;
 end;

 TEnvioEmailControl = Class(TInterfacedObject)

 private
  FConsumeAPI              : iRestConsumeAPI;
  EnvioEmail_model         : TEnvioEmail;
 public

  function SendEmail(DadosEnvioEmail : TDadosEnvioEmail ; bAbreMsg : boolean = true ; bUsaThread : boolean = false) : boolean;

  class function new():TEnvioEmailControl;
  constructor Create;
  destructor  Destroy; override;

 private


 End;

implementation

uses
  Vcl.Dialogs;



constructor TEnvioEmailControl.Create;
begin

end;

destructor TEnvioEmailControl.Destroy;
begin

  inherited;
end;




class function TEnvioEmailControl.new: TEnvioEmailControl;
begin
  result := TEnvioEmailControl.create;
end;
function TEnvioEmailControl.SendEmail(DadosEnvioEmail : TDadosEnvioEmail ; bAbreMsg : boolean = true ; bUsaThread : boolean = false) : boolean;
 function VerificaConfigDB : boolean;
 begin
   try

     result := false;

     if Ffrom_email.IsEmpty then
     begin
       result := true;
       exit;
     end;
   except
     result := true;
   end;
 end;
 function LoadBase64File( const aFileName: TFileName): WideString;
  var
    LInput : TMemoryStream;
    LOutput: TMemoryStream;
    lStringOutput: WideString;
  begin
    LInput := TMemoryStream.Create;
    LOutput := TMemoryStream.Create;
    try
      LInput.LoadFromFile(aFileName);
      LInput.Position := 0;
      TNetEncoding.Base64.Encode( LInput, LOutput );
      LOutput.Position := 0;
      SetString(lStringOutput, PAnsiChar(LOutput.Memory), LOutput.Size);

      Result:=lStringOutput;
    finally
      LInput.Free;
      LOutput.Free;
    end;
  end;
  function LoadFileToBase64(const AFileName: string): String;
var
  Encoder: TIdEncoderMIME;
  Base64String: String;
  LStream: TMemoryStream;
  begin
    Encoder := TIdEncoderMIME.Create;
    LStream := TMemoryStream.Create;
    try
      LStream.LoadFromFile(AFileName);
      Base64String := Encoder.Encode(LStream);
      result := Base64String;
    finally
      FreeAndNil(Encoder);
      FreeAndNil(LStream);
    end;
  end;
var
  Dir, ArqXML,retorno      : string;
  teste            : wideString;
  iCodRetorno      : integer;
  MS               : TMemoryStream;
  ACBrMail         : TACBrMail;
  xAnexo           : Integer;
  JsonBody         : TJSONObject;
  JsonPerson       : TJSONObject;
  JsonArrayPerson  : TJSONArray;
  JsonContent      : TJSONObject;
  JsonArrayContent,JsonArrayAttachments : TJSONArray;
  JsonDest         : TJSONObject;
  JsonArrayDest    : TJSONArray;
  JsonFrom         : TJSONObject;
  JsonReply_to     : TJSONObject;
begin
  try
    try
      if DadosEnvioEmail = nil then
      begin
        if bAbreMsg then
        showmessage('Dados do email estão Vazios, Entre em contato com o suporte tecnico');
        exit;
      end;

      if DadosEnvioEmail.Destinatario = '' then
      begin
        if bAbreMsg then
        showmessage('Sem destinatario, verifique');
        exit;
      end;

      if VerificaConfigDB then
      begin
        if bAbreMsg then
        showmessage('Configuração de email no sistema inválidos, verifique');
        exit;
      end;


        try
          JsonPerson              := TJSONObject.create;
          JsonDest                := TJSONObject.create;
          JsonBody                := TJSONObject.Create;
          JsonContent             := TJSONObject.create;
          JsonArrayPerson         := TJsonArray.create;
          JsonArrayDest           := TJsonArray.create;
          JsonArrayContent        := TJsonArray.create;
          JsonFrom                := TJSONObject.create;
          JsonReply_to            := TJSONObject.create;
          JsonArrayAttachments    := TJSONArray.Create;

          JsonDest.AddPair('email', trim(DadosEnvioEmail.Destinatario));
          JsonDest.AddPair('name', trim(DadosEnvioEmail.NomeDestinatario));
          JsonArrayDest.Add(JsonDest);

          JsonPerson.AddPair('to', JsonArrayDest);
          JsonPerson.AddPair('subject', DadosEnvioEmail.Assunto);
          JsonArrayPerson.Add(JsonPerson);



          if DadosEnvioEmail.UsaHTML then
          begin
           Jsoncontent.AddPair('type', 'text/html');
           Jsoncontent.AddPair('value', DadosEnvioEmail.BodyMsgHtml.text);
           JsonArrayContent.Add(Jsoncontent);
          end
          else
          begin
            Jsoncontent.AddPair('type', 'text/plain');
            if DadosEnvioEmail.BodyMsgTxt <> nil then
             Jsoncontent.AddPair('value', DadosEnvioEmail.BodyMsgTxt.text)
            else
             Jsoncontent.AddPair('value', '');
            JsonArrayContent.Add(Jsoncontent);
          end;

          if (Assigned(DadosEnvioEmail.Anexos)) and (DadosEnvioEmail.Anexos.Count > 0) then
          for xAnexo := 0 to DadosEnvioEmail.Anexos.Count - 1 do
          begin
            JsonArrayAttachments.AddElement(TJSONObject.Create

                                           .AddPair('content',LoadFileToBase64(DadosEnvioEmail.Anexos[xAnexo]))
                                           .AddPair('filename',ExtractFileName(DadosEnvioEmail.Anexos[xAnexo])));

          end;

          JsonFrom.AddPair('email', trim(Ffrom_email));
          JsonFrom.AddPair('name', trim(Ffrom_name));

          JsonReply_to.AddPair('email', trim(Ffrom_email));
          JsonReply_to.AddPair('name', trim(Ffrom_name));

          JsonBody.AddPair('personalizations', JsonArrayPerson);
          JsonBody.AddPair('content', JsonArrayContent);
          if (Assigned(DadosEnvioEmail.Anexos)) and (DadosEnvioEmail.Anexos.Count > 0) then
          JsonBody.AddPair('attachments', JsonArrayAttachments);
          JsonBody.AddPair('from', TJsonObject(JsonFrom));
          JsonBody.AddPair('reply_to', TJsonObject(JsonReply_to));
          FConsumeAPI      := TRestConsumeAPI.New('https://api.sendgrid.com/v3/mail/send');
          FConsumeAPI.bodyclear();
          FConsumeAPI.AddBodyJson(JsonBody);
          FConsumeAPI.AddParameter('Authorization', 'Bearer '+ trim(Fpassword_email),  REST.Types.pkHTTPHEADER, [poDoNotEncode]);
          FConsumeAPI.ExecutaMetodo(tpPost,retorno, iCodRetorno);

          if (iCodRetorno = 200) or (iCodRetorno = 201) or (iCodRetorno = 202) or (iCodRetorno = 203) then
           result := true else
           result := false;

        finally
         FreeAndNil(JsonBody);

          if (iCodRetorno = 400) or (iCodRetorno = 415) then
          begin
            if bAbreMsg then
            showmessage('Erro: '+retorno+ ' ErroEnvioEmail.txt');
          end;
        end;


    except
      on e: Exception do
      begin
        if bAbreMsg then
        showmessage('Erro ao enviar e-mail ' + e.Message);

        result := false;
      end;
    end;
  finally

  end;
end;

end.
