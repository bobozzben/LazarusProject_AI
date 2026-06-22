Unit s3000_unit;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, ExtCtrls, Dialogs, Windows,
  DB, dbf;

Type

  { TS3000 }

  TS3000 = Class(TForm)
    CheckBox_nimg: TCheckBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label_Drive: TLabel;
    Panel2: TPanel;
    SpeedButton_Exit: TSpeedButton;
    Table1: TDbf;
    Table1DATADISK: TStringField;
    Table1OTHERDISK: TStringField;
    Table1COMPANY: TStringField;
    SpeedButton1, SpeedButton2, SpeedButton3, SpeedButton4, SpeedButton5, SpeedButton6, SpeedButton7, SpeedButton8, SpeedButton9, SpeedButton10, SpeedButton11, SpeedButton12, SpeedButton13, SpeedButton14, SpeedButton16, SpeedButton17, SpeedButton18, SpeedButton19, SpeedButton20, SpeedButton21, SpeedButton22, SpeedButton23: TSpeedButton;
    Procedure FormCreate(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: word; Shift: TShiftState);
    Procedure FormClose(Sender: TObject; Var CloseAction: TCloseAction);
    Procedure FormWindowStateChange(Sender: TObject);
    Procedure SpeedButton1Click(Sender: TObject);
    Procedure SpeedButton2Click(Sender: TObject);
    Procedure SpeedButton3Click(Sender: TObject);
    Procedure SpeedButton4Click(Sender: TObject);
    Procedure SpeedButton5Click(Sender: TObject);
    Procedure SpeedButton6Click(Sender: TObject);
    Procedure SpeedButton7Click(Sender: TObject);
    Procedure SpeedButton8Click(Sender: TObject);
    Procedure SpeedButton9Click(Sender: TObject);
    Procedure SpeedButton10Click(Sender: TObject);
    Procedure SpeedButton11Click(Sender: TObject);
    Procedure SpeedButton12Click(Sender: TObject);
    Procedure SpeedButton13Click(Sender: TObject);
    Procedure SpeedButton14Click(Sender: TObject);
    Procedure SpeedButton16Click(Sender: TObject);
    Procedure SpeedButton17Click(Sender: TObject);
    Procedure SpeedButton18Click(Sender: TObject);
    Procedure SpeedButton19Click(Sender: TObject);
    Procedure SpeedButton20Click(Sender: TObject);
    Procedure SpeedButton21Click(Sender: TObject);
    Procedure SpeedButton22Click(Sender: TObject);
    Procedure SpeedButton23Click(Sender: TObject);
    Procedure SpeedButton_ExitClick(Sender: TObject);
  private
  public
    Function myShowWarningForm: TModalResult;
  End;

Function showForm_S3000(): TForm;

Var
  S3000: TS3000;

Implementation

{$R *.lfm}

Uses MainMenu_unit, mainback_uint, choice_unit, warningu, ToolsFunction_unit;

Function showForm_S3000(): TForm;
Begin
  S3000 := TS3000.Create(Application);
  Result := S3000;
  With S3000 Do Begin
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

Procedure TS3000.FormCreate(Sender: TObject);
Begin
  Label_Drive.Caption := MainForm1.netsource;
End;

Procedure TS3000.FormKeyDown(Sender: TObject; Var Key: word; Shift: TShiftState);
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
    Ord('9'): SpeedButton9Click(Sender);
    Ord('A'): SpeedButton10Click(Sender);
    Ord('B'): SpeedButton11Click(Sender);
    Ord('C'): SpeedButton12Click(Sender);
    Ord('D'): SpeedButton13Click(Sender);
    Ord('E'): SpeedButton14Click(Sender);
    Ord('F'): SpeedButton16Click(Sender);
    Ord('G'): SpeedButton17Click(Sender);
    Ord('H'): SpeedButton18Click(Sender);
    Ord('I'): SpeedButton19Click(Sender);
    Ord('J'): SpeedButton20Click(Sender);
    Ord('K'): SpeedButton21Click(Sender);
    Ord('L'): SpeedButton22Click(Sender);
    Ord('M'): SpeedButton23Click(Sender);
  End;

End;

Function TS3000.myShowWarningForm: TModalResult;
Var
  WarningForm: TWarningF;
Begin
  Result := mrCancel;
  WarningForm := TWarningF.Create(Application);
  Try
    WarningForm.Position := poMainFormCenter;
    Result := WarningForm.ShowModal;
  Finally
    WarningForm.Free;
  End;
End;

Procedure TS3000.FormClose(Sender: TObject; Var CloseAction: TCloseAction);
Begin
  CloseAction := caFree;
  MainForm1.Image1.Visible := True;
  MainForm1.Panel2.Enabled := True;
  MainForm1.WorkForm := nil;
End;

Procedure TS3000.FormWindowStateChange(Sender: TObject);
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

Procedure TS3000.SpeedButton1Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  MainForm1.bak_res_nimgbuy := '';
  If CheckBox_nimg.Checked Then
    MainForm1.bak_res_nimgbuy := '1';
  showForm_ChoiceMainback(Self, '3s1.vbs', 'bak', 'y', '備份客戶營業稅年度資料', '');
End;

Procedure TS3000.SpeedButton2Click(Sender: TObject);
Begin
  If mrOk <> myShowWarningForm Then Exit;

  If Not Intital_Tables(0) Then
    Exit;
  MainForm1.bak_res_nimgbuy := '';
  If CheckBox_nimg.Checked Then
    MainForm1.bak_res_nimgbuy := '1';
  showForm_ChoiceMainback(Self, '3s1.vbs', 'res', 'y', '回置客戶營業稅年度資料', '');

End;

Procedure TS3000.SpeedButton3Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  MainForm1.bak_res_nimgbuy := '';
  If CheckBox_nimg.Checked Then
    MainForm1.bak_res_nimgbuy := '1';
  showForm_ChoiceMainback(Self, '3s2.vbs', 'bak', 'y', '備份客戶會計總帳及成本年度資料', '');

End;

Procedure TS3000.SpeedButton4Click(Sender: TObject);
Begin
  If mrOk <> myShowWarningForm Then Exit;

  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s2.vbs', 'res', 'y', '回置客戶會計總帳及成本年度資料', '');
End;

Procedure TS3000.SpeedButton5Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s4.vbs', 'bak', 'y', '備份客戶固定資產年度資料', '');
End;

Procedure TS3000.SpeedButton6Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s4.vbs', 'res', 'y', '回置客戶固定資產年度資料', '');
End;

Procedure TS3000.SpeedButton7Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s5.vbs', 'bak', 'y', '備份客戶薪資扣繳年度資料', '');
End;

Procedure TS3000.SpeedButton8Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s5.vbs', 'res', 'y', '回置客戶薪資扣繳年度資料', '');
End;

Procedure TS3000.SpeedButton9Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s6.vbs', 'bak', 'y', '備份客戶結算申報年度資料', '');
End;

Procedure TS3000.SpeedButton10Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s6.vbs', 'res', 'y', '回置客戶結算申報年度資料', '');
End;

Procedure TS3000.SpeedButton11Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3sa.vbs', 'bak', 'y', '備份兩稅及未分配盈餘申報年度資料', '');
End;

Procedure TS3000.SpeedButton12Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3sa.vbs', 'res', 'y', '回置客戶兩稅及未分配盈餘年度資料', '');
End;

Procedure TS3000.SpeedButton13Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s8.vbs', 'bak', 'y', '備份預估系統年度資料', '');
End;

Procedure TS3000.SpeedButton14Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3s8.vbs', 'res', 'y', '回置預估系統年度資料', '');
End;

Procedure TS3000.SpeedButton16Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3sp.vbs', 'bak', 'y', '備份執行業務資料', '');
End;

Procedure TS3000.SpeedButton17Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3sp.vbs', 'res', 'y', '回置執行業務資料', '');
End;

Procedure TS3000.SpeedButton18Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3sq.vbs', 'bak', 'y', '備份清算系統資料', '');
End;

Procedure TS3000.SpeedButton19Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3sq.vbs', 'res', 'y', '回置清算系統資料', '');
End;

Procedure TS3000.SpeedButton20Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3ss.vbs', 'bak', 'y', '備份機關團體結算年度資料', '');
End;

Procedure TS3000.SpeedButton21Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self, '3ss.vbs', 'res', 'y', '回置機關團體結算年度資料', '');
End;

Procedure TS3000.SpeedButton22Click(Sender: TObject);
Begin
  If Not Intital_Tables(2) Then
    Exit;
  showForm_ChoiceMainback(Self, '3salary.vbs', 'bak', 'y', '備份二代健保薪資年度資料', '');
End;

Procedure TS3000.SpeedButton23Click(Sender: TObject);
Begin
  If Not Intital_Tables(2) Then
    Exit;
  showForm_ChoiceMainback(Self, '3salary.vbs', 'res', 'y', '回置二代健保薪資年度資料', '');
End;

Procedure TS3000.SpeedButton_ExitClick(Sender: TObject);
Begin // 離開
  PostMessage(self.Handle, WM_Close, 0, 0);
End;

End.
