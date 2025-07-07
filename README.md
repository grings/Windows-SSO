# Delphi Windows Single Sign-On (SSO) Library

A lightweight Delphi library for retrieving Windows user authentication information without requiring credentials. The library provides a reliable way to get the currently logged-in Windows user's details with automatic fallback mechanisms.

## Features

- **Multiple Authentication Methods**: Uses Windows Security API with automatic fallback to Network API
- **Zero User Interaction**: Retrieves user information without prompting for credentials
- **Flexible Fallback Modes**: Choose between strict authentication or always returning a result
- **Clean Interface Design**: Simple, intuitive API with proper interface-based architecture
- **Cross-Platform Support**: Works with both Win32 and Win64 applications
- **No External Dependencies**: Uses only Windows system DLLs (secur32.dll, netapi32.dll)

## Installation

1. Clone this repository or download the source files
2. Add the SSO units to your Delphi project
3. Ensure your project targets Windows (Win32 or Win64)

## Quick Start

### Simple Usage

The easiest way to get the current Windows user:

```pascal
uses
  SSO.SingleSignOn;

procedure GetCurrentUser;
begin
  TSimpleSingleSignOn.CheckUser(
    procedure(UserInfo: IWindowsUserInfo)
    begin
      if UserInfo.UserFound then
        ShowMessage('Hello, ' + UserInfo.FullQualifiedUserName)
      else
        ShowMessage('Could not determine Windows user');
    end);
end;
```

### Advanced Usage

For more control over the authentication process:

```pascal
uses
  SSO.Interfaces,
  SSO.Windows;

procedure GetUserWithFallback;
var
  SSO: ISSOComposite;
  UserInfo: IWindowsUserInfo;
begin
  SSO := TSSOWindows.Create;
  
  // Choose fallback mode
  SSO.SetFallbackMode(TFallbackMode.AlwaysReturnSomething);
  
  // Get user info
  UserInfo := SSO.GetUserInfo;
  
  if UserInfo.UserFound then
  begin
    WriteLn('Username: ', UserInfo.Username);
    WriteLn('Domain: ', UserInfo.Domain);
    WriteLn('UPN: ', UserInfo.FullQualifiedUserName);
  end;
end;
```

## API Reference

### Main Interfaces

#### `IWindowsUserInfo`
Contains the authenticated user's information:
- `Username: string` - The user's login name
- `Domain: string` - The Windows domain name
- `FullQualifiedUserName: string` - Full UPN (user@domain or domain\user format)
- `UserFound: Boolean` - Indicates if user information was successfully retrieved

#### `ISSOComposite`
Main interface for authentication:
- `SetFallbackMode(Mode: TFallbackMode)` - Configure fallback behavior
- `GetUPN: string` - Get user principal name (raises exception if not found)
- `GetUserInfo: IWindowsUserInfo` - Get complete user information

### Fallback Modes

- `TFallbackMode.Minimal` - Throws exception if primary methods fail (default)
- `TFallbackMode.AlwaysReturnSomething` - Falls back to environment variables if needed

## Authentication Methods

The library attempts authentication in the following order:

1. **Windows Security API (Secur32.dll)**
   - Primary method using `GetUserNameEx`
   - Most reliable for domain-joined computers

2. **Windows Network API (NetAPI32.dll)**
   - Fallback method using `NetWkstaUserGetInfo`
   - Works when Security API is unavailable

3. **Environment Variables** (optional)
   - Only used when `AlwaysReturnSomething` mode is enabled
   - Reads from `USERNAME` and `USERDOMAIN` environment variables

## Example Application

A complete example application is included in the `Examples` folder. To run it:

1. Open `Examples/SingleSignOnExample.dproj` in Delphi
2. Compile and run the application
3. Click "Get User Info" to see the current user's details

## Requirements

- Delphi/RAD Studio (tested with recent versions)
- Windows operating system (Windows 7 or later)
- Target platform: Win32 or Win64

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues, questions, or contributions, please use the GitHub issue tracker.