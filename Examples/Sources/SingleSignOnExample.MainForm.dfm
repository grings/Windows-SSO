object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Single Sign On Example'
  ClientHeight = 352
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object labelFullQualifiedName: TLabel
    Left = 152
    Top = 151
    Width = 104
    Height = 13
    Caption = '<Full qualified name>'
  end
  object btnGetUserInfo: TButton
    Left = 152
    Top = 88
    Width = 121
    Height = 25
    Caption = 'Get current user'
    TabOrder = 0
    OnClick = btnGetUserInfoClick
  end
  object checkUserFound: TCheckBox
    Left = 152
    Top = 128
    Width = 97
    Height = 17
    Caption = 'User found'
    Enabled = False
    TabOrder = 1
  end
  object edUsername: TEdit
    Left = 152
    Top = 184
    Width = 121
    Height = 21
    TabOrder = 2
    TextHint = 'Username'
  end
  object edDomain: TEdit
    Left = 152
    Top = 211
    Width = 121
    Height = 21
    TabOrder = 3
    TextHint = 'Domain'
  end
  object btnCheckUserInfo: TButton
    Left = 152
    Top = 238
    Width = 121
    Height = 25
    Caption = 'Check user'
    TabOrder = 4
    OnClick = btnCheckUserInfoClick
  end
end
