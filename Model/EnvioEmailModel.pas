unit EnvioEmailModel;

interface

uses
  RestConsumeAPI, System.Generics.Collections, System.JSON, System.SysUtils, REST.Types;

   {obj envio de email com padrão global}
 type
    TEnvioEmail = Class
 private
    FDefault_Charset   : string;
    FFrom_Email        : string;
    FFrom_Name         : string;
    FHost_Email        : string;
    FId                : integer;
    FIde_Charset       : string;
    Fuser_name         : string;
    FPassword_Email    : string;
    FPort_Email        : integer;
    FTipo              : integer;     //0 = sendgrid, 1 = api i3 sistemas
    FType_Autentication: string;

    public
    property Default_Charset   : string  read FDefault_Charset    write FDefault_Charset;
    property From_Email        : string  read FFrom_Email         write FFrom_Email;
    property From_Name         : string  read FFrom_Name          write FFrom_Name;
    property Host_Email        : string  read FHost_Email         write FHost_Email;
    property Id                : integer read FId                 write FId;
    property Ide_Charset       : string  read FIde_Charset        write FIde_Charset;
    property Password_Email    : string  read FPassword_Email     write FPassword_Email;
    property user_name         : string  read Fuser_name          write Fuser_name;
    property Port_Email        : integer read FPort_Email         write FPort_Email;
    property Tipo              : integer read FTipo               write FTipo;
    property Type_Autentication: string  read FType_Autentication write FType_Autentication;

    Constructor Create;
    Destructor Destroy;

    class function new: TEnvioEmail;
    End;

implementation

destructor TEnvioEmail.Destroy;
begin
  inherited;
end;
class function TEnvioEmail.new() : TEnvioEmail;
begin
  result := self.create;
end;
constructor TEnvioEmail.Create;
begin
  inherited;
end;

end.
