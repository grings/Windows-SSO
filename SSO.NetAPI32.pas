unit SSO.NetAPI32;

interface

uses
  SSO.Interfaces;

type
  TSSONetAPI32Query = class(TInterfacedObject, ISSOQuery)
  private
    FLastError: string;
  public
    function TryGetUsername(var Username: string; var Domain: string): Boolean;

    function LastError: string;
  end;

implementation

uses
  WinAPI.Windows,
  System.SysUtils;

function NetApiBufferFree(Buffer: pointer): DWORD; stdcall; external 'netapi32.dll' name 'NetApiBufferFree';
function NetWkstaUserGetInfo(ServerName: PWideChar; Level: DWORD; var Buffer: Pointer): Longint; stdcall; external 'netapi32.dll' name 'NetWkstaUserGetInfo';

type
  TUserInfo = record
    UserName: PWideChar;
    DomainName: PWideChar;
    OtherDomainNames: PWideChar;
    ServerName: PWideChar;
  end;

  PUserInfo = ^TUserInfo;

function TryGetUPNViaNetApi(var UPN: string): Boolean;
var
  Userinfo: PUserInfo;
begin
  Result := False;

  if NetWkstaUserGetInfo(nil, 1, Pointer(Userinfo)) = 0 then
  begin
    try
      UPN := WideCharToString(Userinfo^.UserName);

      Result := True;
    finally
      NetApiBufferFree(Userinfo);
    end;
  end;
end;

function TSSONetAPI32Query.LastError: string;
begin
  Result := FLastError;
end;

function TSSONetAPI32Query.TryGetUsername(var Username, Domain: string): Boolean;
var
  UPN: string;
begin
  Result := False;

  if TryGetUPNViaNetApi(UPN) then
  begin
    Result := TUPN.TryToSplit(UPN, Username, Domain);
    if not Result then
    begin
      FLastError := 'UPN format not recognized: ' + UPN;
    end;
  end
  else
  begin
    FLastError := 'Call to NetWkstaUserGetInfo failed';
  end;
end;

end.
