unit SSO.Interfaces;

interface

uses
  System.SysUtils;

type
  IWindowsUserInfo = interface
    ['{D90A9307-35E5-49C0-89A0-333D8CBE64FE}']

    function Username: string;
    function Domain: string;
    function FullQualifiedUserName: string;
    function UserFound: Boolean;
  end;

  ISingleSignOn = interface
    ['{1736519A-F304-4627-9C54-0D8D97F8E97A}']

    procedure CheckUser(const Action: TProc<IWindowsUserInfo>);
  end;

  ISSOQuery = interface
    ['{BF3F6306-07B5-4176-83E8-BD3C5F1DB8AC}']

    function TryGetUsername(var Username: string; var Domain: string): Boolean;
    function LastError: string;
  end;

  {$SCOPEDENUMS ON}
  TFallbackMode = (
    Minimal,
    AlwaysReturnSomething
  );
  {$SCOPEDENUMS OFF}

  ISSOComposite = interface
    ['{ECCBCE93-618A-4D62-9133-0D21E5AC2C56}']

    procedure SetFallbackMode(const Mode: TFallbackMode);

    function GetUPN: string;
  end;

  TUPN = class
  public
    class function Format(const Username: string; const Domain: string): string;
    class function TryToSplit(const UPN: string; var Username: string; var Domain: string): Boolean;
  end;

  ESSOException = class(Exception);

implementation

{ TUPN }

class function TUPN.Format(const Username, Domain: string): string;
begin
  Result := System.SysUtils.Format('%s@%s', [Username, Domain]);
end;

class function TUPN.TryToSplit(const UPN: string; var Username, Domain: string): Boolean;
var
  UPNParts: TArray<string>;
begin
  Result := False;

  UPNParts := UPN.Split(['@']);
  if Length(UPNParts) = 2 then
  begin
    Username := UPNParts[0];
    Domain := UPNParts[1];
    Result := True;
  end
  else
  begin

    UPNParts := UPN.Split(['\']);
    if Length(UPNParts) = 2 then
    begin
      Domain := UPNParts[0];
      Username := UPNParts[1];
      Result := True;
    end;

  end;
end;

end.
