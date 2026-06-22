Unit s5000_unit;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons, DBGrids, Windows,
  DB, Dialogs, FileUtil, Grids, StrUtils, LazFileUtils;

Type

  { TS5000f }

  TS5000f = Class(TForm)
    Label1: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label_Drive: TLabel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton_Exit: TSpeedButton;
    Procedure FormClose(Sender: TObject; Var CloseAction: TCloseAction);
    Procedure FormCreate(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: word; Shift: TShiftState);
    Procedure FormWindowStateChange(Sender: TObject);
    Procedure SpeedButton1Click(Sender: TObject);
    Procedure SpeedButton2Click(Sender: TObject);
    Procedure SpeedButton3Click(Sender: TObject);
    Procedure SpeedButton4Click(Sender: TObject);
    Procedure SpeedButton5Click(Sender: TObject);
    Procedure SpeedButton6Click(Sender: TObject);
    Procedure SpeedButton7Click(Sender: TObject);
    Procedure SpeedButton8Click(Sender: TObject);
    Procedure SpeedButton_ExitClick(Sender: TObject);
  private
  End;

Function showForm_S5000(): TForm;

Var
  S5000f: TS5000f;

Implementation

Uses MainMenu_unit, choice_unit, ToolsFunction_unit;

  {$R *.lfm}


Function showForm_S5000(): TForm;
Begin
  S5000f := TS5000F.Create(Application);
  Result := S5000f;
  With S5000f Do Begin
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

Procedure TS5000f.FormCreate(Sender: TObject);
Begin
  Label_Drive.Caption := MainForm1.netsource;
End;

Procedure TS5000f.FormKeyDown(Sender: TObject; Var Key: word; Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    Close;
  Case Key Of
    Ord('1'): SpeedButton1Click(Sender);
    Ord('2'): SpeedButton2Click(Sender);
    Ord('3'): SpeedButton3Click(Sender);
    Ord('4'): SpeedButton4Click(Sender);
    Ord('5'): SpeedButton5Click(Sender);
    Ord('6'): SpeedButton6Click(Sender);
    Ord('B'): SpeedButton7Click(Sender);
    Ord('C'): SpeedButton8Click(Sender);
  End;

End;

Procedure TS5000f.FormWindowStateChange(Sender: TObject);
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

Procedure TS5000f.FormClose(Sender: TObject; Var CloseAction: TCloseAction);
Begin
  CloseAction := caFree;
  MainForm1.Image1.Visible := True;
  MainForm1.Panel2.Enabled := True;
  MainForm1.WorkForm := nil;
End;


Procedure TS5000f.SpeedButton1Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '5s1.vbs', 'bak', 'y', '備份客戶抽查系統年度資料', '');

End;

Procedure TS5000f.SpeedButton2Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '5s1.vbs', 'res', 'y', '回置客戶抽查系統年度資料', '');
End;

Procedure TS5000f.SpeedButton3Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '5s2.vbs', 'bak', 'y', '備份客戶財稅簽系統年度資料', '');
End;

Procedure TS5000f.SpeedButton4Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '5s2.vbs', 'res', 'y', '回置客戶財稅簽系統年度資料', '');
End;

Procedure TS5000f.SpeedButton5Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '5s3.vbs', 'bak', 'y', '備份客戶機關團體稅簽資料', '');
End;

Procedure TS5000f.SpeedButton6Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '5s3.vbs', 'res', 'y', '回置客戶機關團體稅簽資料', '');

End;

Procedure TS5000f.SpeedButton7Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3sa.vbs', 'bak', 'y', '備份兩稅及未分配盈餘申報年度資料', '');
End;

Procedure TS5000f.SpeedButton8Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3sa.vbs', 'res', 'y', '回置客戶兩稅及未分配盈餘年度資料', '');
End;

Procedure TS5000f.SpeedButton_ExitClick(Sender: TObject);
Begin // 離開
  PostMessage(self.Handle, WM_Close, 0, 0);
End;

End.
