unit SSO.Envvars;

interface

uses
  SSO.Interfaces;

type
  TSSOEnvvarsQuery = class(TInterfacedObject, ISSOQuery)
  public
    function TryGetUsername(var Username: string; var Domain: string): Boolean;

    function LastError: string;
  end;

implementation

uses
  System.SysUtils;

{ TSSOEnvvarsQuery }

function TSSOEnvvarsQuery.LastError: string;
begin
  Result := '';
end;

function TSSOEnvvarsQuery.TryGetUsername(var Username: string; var Domain: string): Boolean;
begin
  Username := GetEnvironmentVariable('USERNAME');

  Domain := GetEnvironmentVariable('USERDNSDOMAIN');
  if Domain = '' then
    Domain := GetEnvironmentVariable('USERDOMAIN');

  Result := True;
end;

end.
