# README #

### How to use ###

```pascal
uses
  SSO.Interfaces,
  SSO.Windows;

procedure Test;
var
  SSO: ISSOComposite;
begin
  SSO := TSSOWindows.Create;
  SSO.SetFallbackMode(TFallbackMode.AlwaysReturnSomething);

  ShowMessage('Logged in as user: ' + SSO.GetUPN);
end;
```
