unit SingleSignOnExample.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SSO.Interfaces;

type
  TMainForm = class(TForm)
    btnGetUserInfo: TButton;
    checkUserFound: TCheckBox;
    edUsername: TEdit;
    edDomain: TEdit;
    btnCheckUserInfo: TButton;
    labelFullQualifiedName: TLabel;
    procedure btnGetUserInfoClick(Sender: TObject);
    procedure btnCheckUserInfoClick(Sender: TObject);
  private
    { Private declarations }
    procedure DisplayUserInfo(const UserInfo: IWindowsUserInfo);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses SSO.SingleSignOn, System.UITypes;

procedure TMainForm.btnCheckUserInfoClick(Sender: TObject);
var
  SingleSignOn: ISingleSignOn;
begin
  SingleSignOn := TSingleSignOn.Create;

  SingleSignOn.CheckUser(
    procedure(UserInfo: IWindowsUserInfo)
    begin
      // At this place you can add your own authentication or display code
      if UserInfo.UserFound then

        // Check if the username and domain corresponds with the input fields
        // Most common is to store the Fully Qualifield User Name for each user in your application
        // In that case you can find your user using SQL (for example):
        //   "SELECT * FROM User WHERE FullyQualifiedName = :UserInfoFQN"

        if (UserInfo.Username = edUsername.Text) and
           (UserInfo.Domain = edDomain.Text) then

          MessageDlg('This is the current system user!', mtInformation, [mbOk], 0)
        else
          MessageDlg('Current system user is not the given user.', mtInformation, [mbOk], 0)
      else
        MessageDlg('No user found.', mtError, [mbOk], 0)
    end);
end;

procedure TMainForm.btnGetUserInfoClick(Sender: TObject);
begin
  // Use the simple access to the check user function, using the TSimpleSingleSignOn class procedure
  TSimpleSingleSignOn.CheckUser(
    procedure(UserInfo: IWindowsUserInfo)
    begin
      // At this place you can add your own authentication or display code
      // Or you can use the info to link it with the application's user info
      DisplayUserInfo(UserInfo);

      if not(UserInfo.UserFound) then
        MessageDlg('No user found.', mtError, [mbOk], 0)
    end);
end;

procedure TMainForm.DisplayUserInfo(const UserInfo: IWindowsUserInfo);
begin
  checkUserFound.Checked := UserInfo.UserFound;
  labelFullQualifiedName.Caption := UserInfo.FullQualifiedUserName;

  edUsername.Text := UserInfo.Username;
  edDomain.Text   := UserInfo.Domain;
end;

end.
