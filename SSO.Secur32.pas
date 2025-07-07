unit SSO.Secur32;

interface

uses
  SSO.Interfaces,
  WinAPI.Windows;

type
  TSSOSecur32Query = class(TInterfacedObject, ISSOQuery)
  private
    FLastError: string;

    function TryGetUserNameExString(const ANameFormat: DWORD; var UPN: string): Boolean;
  public
    function TryGetUsername(var Username: string; var Domain: string): Boolean;
    function LastError: string;
  end;

implementation

uses
  System.SysUtils;

const
  NameUserPrincipal      = 8;

function GetUserNameEx(NameFormat: DWORD; lpNameBuffer: LPSTR; var nSize: ULONG): BOOL; stdcall; external 'secur32.dll' name 'GetUserNameExA';

function TSSOSecur32Query.TryGetUserNameExString(const ANameFormat: DWORD; var UPN: string): Boolean;
var
  Buf: array[0..256] of AnsiChar;
  BufSize: DWORD;
begin
  Result := False;

  BufSize := SizeOf(Buf) div SizeOf(Buf[0]);
  if GetUserNameEx(ANameFormat, Buf, BufSize) then
  begin
    UPN := String(AnsiString(Buf));
    Result := True;
  end
  else
  begin
    FLastError := 'Call to GetUserNameEx failed (' + SysErrorMessage(GetLastError) + ')';
  end;
end;

function TSSOSecur32Query.LastError: string;
begin
  Result := FLastError;
end;

function TSSOSecur32Query.TryGetUsername(var Username, Domain: string): Boolean;
var
  UPN: string;
begin
  Result := TryGetUserNameExString(NameUserPrincipal, UPN);

  if Result then
  begin
    Result := TUPN.TryToSplit(UPN, Username, Domain);
    if not Result then
    begin
      FLastError := 'UPN format not recognized: ' + UPN;
    end;
  end;
end;

end.
