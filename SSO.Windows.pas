
unit SSO.Windows;

interface

uses
  SSO.Interfaces;

type
  TSSOWindows = class(TInterfacedObject, ISSOComposite)
  private
    FFallbackMode: TFallbackMode;
  public
    constructor Create; overload;
    constructor Create(const FallbackMode: TFallbackMode); overload;

    procedure SetFallbackMode(const Mode: TFallbackMode);

    function GetUPN: string;
    function GetUserInfo: IWindowsUserInfo;
  end;

implementation

uses
  SSO.NetAPI32, SSO.Secur32, SSO.Envvars, SSO.WindowsUserInfo;

{ TSSOWindows }

constructor TSSOWindows.Create;
begin
  Create(TFallbackMode.Minimal);
end;

constructor TSSOWindows.Create(const FallbackMode: TFallbackMode);
begin
  inherited Create;

  FFallbackMode := FallbackMode;
end;

procedure TSSOWindows.SetFallbackMode(const Mode: TFallbackMode);
begin
  FFallbackMode := Mode;
end;

function TSSOWindows.GetUPN: string;
var
  UserInfo: IWindowsUserInfo;
begin
  UserInfo := GetUserInfo;

  if UserInfo.UserFound then
    Result := UserInfo.FullQualifiedUserName
  else
    raise ESSOException.Create('Could not determine the current Windows user.');
end;

function TSSOWindows.GetUserInfo: IWindowsUserInfo;
var
  Username, Domain: string;
  SecurQuery: ISSOQuery;
  NTQuery: ISSOQuery;
  EnvQuery: ISSOQuery;
  UserFound: Boolean;
begin
  SecurQuery := TSSOSecur32Query.Create;
  UserFound := SecurQuery.TryGetUsername(Username, Domain);

  if not(UserFound) then
  begin
    NTQuery := TSSONetAPI32Query.Create;
    UserFound := NTQuery.TryGetUsername(Username, Domain);
  end;

  if not(UserFound) and (FFallbackMode = TFallbackMode.AlwaysReturnSomething) then
  begin
    EnvQuery := TSSOEnvvarsQuery.Create;

    UserFound := EnvQuery.TryGetUsername(Username, Domain);
  end;

  Result := TWindowsUserInfo.Create(Username, Domain, UserFound);
end;

end.
