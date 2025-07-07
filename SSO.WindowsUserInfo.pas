unit SSO.WindowsUserInfo;

interface

uses SSO.Interfaces;

type
  TWindowsUserInfo = class(TInterfacedObject, IWindowsUserInfo)
  private
    FUsername: string;
    FDomain: string;
    FUserFound: Boolean;
  public
    constructor Create(const Username, Domain: string; const UserFound: Boolean);

    function FullQualifiedUserName: string;
    function Username: string;
    function Domain: string;
    function UserFound: Boolean;
  end;

implementation


{ TWindowsUserInfo }

constructor TWindowsUserInfo.Create(const Username, Domain: string; const UserFound: Boolean);
begin
  inherited Create;

  FUsername  := Username;
  FDomain    := Domain;
  FUserFound := UserFound;
end;

function TWindowsUserInfo.Domain: string;
begin
  Result := FDomain;
end;

function TWindowsUserInfo.FullQualifiedUserName: string;
begin
  Result := TUPN.Format(FUsername, FDomain);
end;

function TWindowsUserInfo.UserFound: Boolean;
begin
  Result := FUserFound;
end;

function TWindowsUserInfo.Username: string;
begin
  Result := FUsername;
end;

end.
