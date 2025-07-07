program SingleSignOnExample;

uses
  Vcl.Forms,
  SingleSignOnExample.MainForm in 'Sources\SingleSignOnExample.MainForm.pas' {MainForm},
  SSO.Envvars in '..\SSO.Envvars.pas',
  SSO.Interfaces in '..\SSO.Interfaces.pas',
  SSO.NetAPI32 in '..\SSO.NetAPI32.pas',
  SSO.Secur32 in '..\SSO.Secur32.pas',
  SSO.Windows in '..\SSO.Windows.pas',
  SSO.WindowsUserInfo in '..\SSO.WindowsUserInfo.pas',
  SSO.SingleSignOn in '..\SSO.SingleSignOn.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
