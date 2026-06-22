Unit noPictureback_uint;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, ExtCtrls, Graphics,
  dbf, Dialogs, Windows, DateUtils, MainMenu_unit, mainback_uint, choice_unit, warningu;

Type

  { TnoPictureback }

  TnoPictureback = Class(TForm)
    Label1: TLabel;
    Label13: TLabel;
    Label3: TLabel;
    Label_Drive: TLabel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Label10: TLabel;
    Label4: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Label9: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    Panel1: TPanel;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    Edit1Year: TEdit;
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
  End;

Function showForm_NoPictureback(): TForm;

Var
  noPictureback: TnoPictureback;

Implementation

Uses ToolsFunction_unit;
  {$R *.lfm}

Function showForm_NoPictureback(): TForm;
Begin
  noPictureback := TnoPictureback.Create(Application);
  Result := noPictureback;
  With noPictureback Do Begin
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

Procedure TnoPictureback.FormClose(Sender: TObject; Var CloseAction: TCloseAction);
Begin
  CloseAction := caFree;
  MainForm1.Image1.Visible := True;
  MainForm1.Panel2.Enabled := True;
  MainForm1.WorkForm := nil;
End;

Procedure TnoPictureback.FormCreate(Sender: TObject);
Begin
  Label_Drive.Caption := MainForm1.netsource;
End;

Procedure TnoPictureback.FormKeyDown(Sender: TObject; Var Key: word; Shift: TShiftState);
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
    Ord('7'): SpeedButton7Click(Sender);
    Ord('8'): SpeedButton8Click(Sender);
  End;
End;

Procedure TnoPictureback.FormWindowStateChange(Sender: TObject);
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

Procedure TnoPictureback.SpeedButton1Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, 's1p.vbs', 'bak', 'n', '備份客戶所有資料', '');
End;

Procedure TnoPictureback.SpeedButton2Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, 's1p.vbs', 'res', 'n', '回置客戶所有資料', '');
End;

Procedure TnoPictureback.SpeedButton3Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, 's2p.vbs', 'bak', 'y', '備份客戶年度所有資料', '');
End;

Procedure TnoPictureback.SpeedButton4Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, 's2p.vbs', 'res', 'y', '回置客戶年度所有資料', '');
End;

Procedure TnoPictureback.SpeedButton5Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s1p.vbs', 'bak', 'y', '備份客戶營業稅年度資料', '');
End;

Procedure TnoPictureback.SpeedButton6Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s1p.vbs', 'res', 'y', '回置客戶營業稅年度資料', '');
End;

Procedure TnoPictureback.SpeedButton7Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s2p.vbs', 'bak', 'y', '備份客戶會計總帳及成本年度資料', '');
End;

Procedure TnoPictureback.SpeedButton8Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s2p.vbs', 'res', 'y', '回置客戶會計總帳及成本年度資料', '');
End;

Procedure TnoPictureback.SpeedButton_ExitClick(Sender: TObject);
Begin // 離開
  PostMessage(self.Handle, WM_Close, 0, 0);
End;

End.
