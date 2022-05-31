program EnvioEmailAPI;

uses
  Vcl.Forms,
  uEnviarEmailApiSendGrid in 'uEnviarEmailApiSendGrid.pas' {Form1},
  EnvioEmail.Utils in 'EnvioEmail.Utils.pas',
  DataSetConverter4D.Helper in 'JSON\DataSetConverter4D.Helper.pas',
  DataSetConverter4D.Impl in 'JSON\DataSetConverter4D.Impl.pas',
  DataSetConverter4D in 'JSON\DataSetConverter4D.pas',
  DataSetConverter4D.Util in 'JSON\DataSetConverter4D.Util.pas',
  RestConsumeAPI in 'JSON\RestConsumeAPI.pas',
  DadosEnvioEmailModel in 'Model\DadosEnvioEmailModel.pas',
  EnvioEmailModel in 'Model\EnvioEmailModel.pas',
  uEmailAPIConfig in 'uEmailAPIConfig.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
