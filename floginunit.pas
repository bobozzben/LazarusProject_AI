Unit floginunit;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, Dialogs, FileUtil, System.UITypes, IniFiles;

Type

  { TFLogin }

  TFLogin = Class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    MaskEdit1: TEdit;
    Procedure BitBtn1Click(Sender: TObject);
    Procedure BitBtn2Click(Sender: TObject);
    Procedure FormCloseQuery(Sender: TObject; Var CanClose: boolean);
    Procedure FormShow(Sender: TObject);
  private

  public
    vtimes: integer;
    myCancel: boolean;
    netsource: string;
    DeleteData: string;
    AuthorizedEmail: string;
    AuthorizedName: string;
  End;

Function showForm_FLogin(xNetSource: string; xDeleteData: string): TModalResult;

Var
  FLogin: TFLogin;

Implementation

{$R *.lfm}

Uses ToolsFunction_unit, GoogleOAuth_unit;

Function showForm_FLogin(xNetSource: string; xDeleteData: string): TModalResult;
Begin
  FLogin := TFLogin.Create(Application);
  With FLogin Do Begin
    NetSource := xNetSource;
    DeleteData := xDeleteData;
    //--------------------------
    BorderIcons := [biSystemMenu, biMinimize];
    BorderStyle := bsDialog;
    Position := poMainFormCenter;
    WindowState := wsNormal;
    KeyPreview := True;
    BringToFront;
    Result := ShowModal();
  End;
End;

Procedure TFLogin.BitBtn1Click(Sender: TObject);
Var
  ini: TIniFile;
  clientId: string;
  expectedEmail: string;
  authEmail: string;
  authName: string;
  accessToken: string;
Begin
  myCancel := False;
  expectedEmail := Trim(MaskEdit1.Text);
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  Try
    clientId := Trim(ini.ReadString('GoogleOAuth', 'ClientId', ''));
    if expectedEmail = '' then
    begin
      ShowMessage('請輸入 Google 帳號 Email。');
      Exit;
    end;

    if GoogleDeviceLogin(clientId, expectedEmail, authEmail, authName, accessToken) then
    begin
      AuthorizedEmail := authEmail;
      AuthorizedName := authName;
      ini.WriteString('GoogleOAuth', 'LastEmail', authEmail);
      ini.UpdateFile;
      ModalResult := mrOk;
      Close;
    end;
  Finally
    ini.Free;
  End;
End;

Procedure TFLogin.BitBtn2Click(Sender: TObject);
Begin
  myCancel := True;
  ModalResult := mrCancel;
  Close;
End;

Procedure TFLogin.FormCloseQuery(Sender: TObject; Var CanClose: boolean);
Begin
  CanClose := True;
End;

Procedure TFLogin.FormShow(Sender: TObject);
Var
  ini: TIniFile;
Begin
  vtimes := 3;
  myCancel := False;
  AuthorizedEmail := '';
  AuthorizedName := '';
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  Try
    MaskEdit1.Text := Trim(ini.ReadString('GoogleOAuth', 'LastEmail', ''));
  Finally
    ini.Free;
  End;
  Caption := 'Google 登入';
  Label1.Caption := 'Google 帳號:';
  If DeleteData = 'Y' Then
    Label2.Caption := '刪除前請先輸入 Google 帳號 Email，並完成授權。'
  Else
    Label2.Caption := '輸入 Google 帳號 Email，按 Google 登入 後完成授權。';
  BitBtn1.Caption := 'Google 登入';
  BitBtn1.ModalResult := mrNone;
  BitBtn2.Caption := '取消';
  BitBtn2.ModalResult := mrCancel;
  MaskEdit1.EchoMode := emNormal;
  MaskEdit1.PasswordChar := #0;
End;

End.
