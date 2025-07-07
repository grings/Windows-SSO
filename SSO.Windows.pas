
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
  end;

implementation

uses
  SSO.NetAPI32, SSO.Secur32, SSO.Envvars;

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
  Username, Domain: string;
  SecurQuery: ISSOQuery;
  NTQuery: ISSOQuery;
  EnvQuery: ISSOQuery;
begin
  Result := '';

  SecurQuery := TSSOSecur32Query.Create;
  if SecurQuery.TryGetUsername(Username, Domain) then
  begin
    Result := TUPN.Format(Username, Domain);
    Exit;
  end;

  NTQuery := TSSONetAPI32Query.Create;
  if NTQuery.TryGetUsername(Username, Domain) then
  begin
    Result := TUPN.Format(Username, Domain);
    Exit;
  end;

  if FFallbackMode = TFallbackMode.AlwaysReturnSomething then
  begin
    EnvQuery := TSSOEnvvarsQuery.Create;

    if EnvQuery.TryGetUsername(Username, Domain) then
    begin
      Result := TUPN.Format(Username, Domain);
    end;
  end
  else
  begin
    raise ESSOException.Create('Could not determine UPN');
  end;
end;

end.
