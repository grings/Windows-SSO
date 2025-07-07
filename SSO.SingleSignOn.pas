unit SSO.SingleSignOn;

interface

uses
  System.SysUtils, SSO.Interfaces;

type
  TSimpleSingleSignOn = class
  public
    class procedure CheckUser(const Action: TProc<IWindowsUserInfo>);
  end;

  TSingleSignOn = class(TInterfacedObject, ISingleSignOn)
  public
    constructor Create;
    procedure CheckUser(const Action: TProc<IWindowsUserInfo>);
  end;

implementation

{ TSimpleSingleSignOn }

uses SSO.Windows
{$ifdef TRIAL}
, Vcl.Dialogs
{$endif}
;

class procedure TSimpleSingleSignOn.CheckUser(const Action: TProc<IWindowsUserInfo>);
var
  SingleSignOn: TSingleSignOn;
begin
  SingleSignOn := TSingleSignOn.Create;
  SingleSignOn.CheckUser(Action);
end;

{ TSingleSignOn }

procedure TSingleSignOn.CheckUser(const Action: TProc<IWindowsUserInfo>);
var
  SSOWindows: TSSOWindows;
  UserInfo: IWindowsUserInfo;
begin
  if not Assigned(Action) then
    raise ESSOException.Create('No action given for user authentication');

  SSOWindows := TSSOWindows.Create(TFallbackMode.AlwaysReturnSomething);
  UserInfo := SSOWindows.GetUserInfo;

  Action(UserInfo);
end;

constructor TSingleSignOn.Create;
begin
  inherited;
{$ifdef TRIAL}
  ShowMessage('This is a trial version of the Delphi Single-Sign-On Module. Please consider buying the software.');
{$endif}
end;

end.
