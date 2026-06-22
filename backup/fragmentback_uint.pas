Unit fragmentback_uint;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, ExtCtrls, Graphics,
  DB, dbf, Dialogs, Process, Windows, DateUtils;

Type

  { TfragmentPictureback }

  TfragmentPictureback = Class(TForm)
    Label1: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label_Drive: TLabel;
    Panel2: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton_Exit: TSpeedButton;
    Procedure FormClose(Sender: TObject; Var CloseAction: TCloseAction);
    Procedure FormCreate(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: word; Shift: TShiftState);
    Procedure FormWindowStateChange(Sender: TObject);
    Procedure SpeedButton1Click(Sender: TObject);
    Procedure SpeedButton2Click(Sender: TObject);
    Procedure SpeedButton3Click(Sender: TObject);
    Procedure SpeedButton4Click(Sender: TObject);
    Procedure SpeedButton_ExitClick(Sender: TObject);
  private

  public
  End;

Function showForm_fragmentPictureback(): TForm;

Var
  fragmentPictureback: TfragmentPictureback;

Implementation

Uses MainMenu_unit, choice_unit, stateunit, ToolsFunction_unit;

  {$R *.lfm}

Function showForm_fragmentPictureback(): TForm;
Begin
  fragmentPictureback := TfragmentPictureback.Create(Application);
  Result := fragmentPictureback;
  With fragmentPictureback Do Begin
    Parent := MainForm1.Panel1;
    Align := alClient;
    //--------------------------
    BorderIcons := [biSystemMenu]; // [biSystemMenu,biMinimize];
    BorderStyle := bsNone; // bsToolWindow  bsSizeToolWin  bsSizeable  bsNone  bsDialog  bsSingle
    FormStyle := fsNormal; //fsMDIChild;
    KeyPreview := True;
    Show();
  End;
End;

Procedure TfragmentPictureback.FormClose(Sender: TObject; Var CloseAction: TCloseAction);
Begin
  CloseAction := caFree;
  MainForm1.Image1.Visible := True;
  MainForm1.Panel2.Enabled := True;
  MainForm1.WorkForm := nil;
End;

Procedure TfragmentPictureback.FormCreate(Sender: TObject);
Begin
  Label_Drive.Caption := MainForm1.netsource;
End;

Procedure TfragmentPictureback.FormKeyDown(Sender: TObject; Var Key: word; Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    Close;
  Case Key Of
    Ord('1'): SpeedButton1Click(Sender);
    Ord('2'): SpeedButton2Click(Sender);
    Ord('3'): SpeedButton3Click(Sender);
    Ord('4'): SpeedButton4Click(Sender);
    VK_ESCAPE: SpeedButton_Exit.Click;
  End;
End;

Procedure TfragmentPictureback.FormWindowStateChange(Sender: TObject);
Begin
  // 縮小時還原最大化 OK
  Case Self.WindowState Of
    wsNormal: Begin
      Self.WindowState := wsMaximized;
      WriteStrToFile_Debug('WindowState wsNormal ');
    End;
    wsMinimized: Begin
      WriteStrToFile_Debug('WindowState wsMinimized ');
      Self.WindowState := wsMaximized;
    End;
    wsMaximized: WriteStrToFile_Debug('WindowState wsMaximized ');
    wsFullScreen: WriteStrToFile_Debug('WindowState wsFullScreen ');
  End;

End;

Procedure TfragmentPictureback.SpeedButton1Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3ssp1.vbs', 'bak', 'y', '備份年度下圖檔', '');

End;

Procedure TfragmentPictureback.SpeedButton2Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3ssp1.vbs', 'res', 'y', '回置年度下圖檔', '');
End;

Procedure TfragmentPictureback.SpeedButton3Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3ssp2.vbs', 'bak', 'y', '備份年度資料+圖檔', '');
End;

Procedure TfragmentPictureback.SpeedButton4Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3ssp2.vbs', 'res', 'y', '回置年度資料+圖檔', '');
End;

Procedure TfragmentPictureback.SpeedButton_ExitClick(Sender: TObject);
Begin // 離開
  PostMessage(self.Handle, WM_Close, 0, 0);
End;

End.
