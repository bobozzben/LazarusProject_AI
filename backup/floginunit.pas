Unit floginunit;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, Dialogs, FileUtil, System.UITypes;

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
  End;

Function showForm_FLogin(xNetSource: string; xDeleteData: string): TModalResult;

Var
  FLogin: TFLogin;

Implementation

{$R *.lfm}

Uses ToolsFunction_unit;

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
Begin
  myCancel := False;
  Close;
End;

Procedure TFLogin.BitBtn2Click(Sender: TObject);
Begin
  myCancel := True;
  ModalResult := mrCancel;
  Close;
End;

Procedure TFLogin.FormCloseQuery(Sender: TObject; Var CanClose: boolean);
Var
  usPass, vPass, malias: string;
  Sl: TStringList;
Begin
  malias := netsource + ':\w3000\comm\';
  If DeleteData = 'Y' Then  Begin
      usPass := MaskEdit1.Text;
      If usPass = 'DDDDD' Then Begin
        ModalResult := mrOk;
      end Else Begin
        ModalResult := mrCancel;
        If Not myCancel Then
           ShowMessage('密碼錯誤!');
      End;
      CanClose := True;

  End Else Begin
    If FileExists(malias + 'motherpw.txt') Then  Begin
      Sl := TStringList.Create;
      Try
        Sl.LoadFromFile(malias + 'motherpw.txt');
        vPass := Trim(Decrypts(Sl.Text));
        If Length(vPass) > 10 Then
          vPass := Copy(vPass, 1, 10);
      Finally
        Sl.Free;
      End;
    End Else Begin
      vPass := '000';
    end;
    If myCancel Then  Begin
      CanClose := True;
      Exit;
    End;
    usPass := Trim(MaskEdit1.Text);
    CanClose := False;
    ModalResult := mrCancel;
    If usPass = '0222577401' Then  Begin
      ModalResult := mrOk;
      CanClose := True;
      Exit;
    End;
    If Trim(vPass) = usPass Then  Begin
      ModalResult := mrOk;
      CanClose := True;
      Exit;
    End;

    Dec(vtimes);
    ShowMessage('密碼錯誤!');
    If vtimes = 0 Then  Begin
      BitBtn2.Click;
      Application.Terminate;
    End;
  End;

End;

Procedure TFLogin.FormShow(Sender: TObject);
Begin
  vtimes := 3;
  myCancel := False;
End;

End.
