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
  SingleSignOn: ISingleSignOn;
begin
  SingleSignOn := TSingleSignOn.Create;
  SingleSignOn.CheckUser(Action);
end;

{ TSingleSignOn }

procedure TSingleSignOn.CheckUser(const Action: TProc<IWindowsUserInfo>);
var
  SSOWindows: ISSOComposite;
  UserInfo: IWindowsUserInfo;
begin
  if not Assigned(Action) then
    raise ESSOException.Create('No action given for user authentication');

  SSOWindows := TSSOWindows.Create(TFallbackMode.AlwaysReturnSomething);
  UserInfo := SSOWindows.GetUserInfo;

  Action(UserInfo);
end;

end.
