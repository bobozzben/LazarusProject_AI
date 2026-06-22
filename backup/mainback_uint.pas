Unit mainback_uint;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls, Buttons, ExtCtrls, Windows, LCLType,LMessages,
  MaskEdit;

Type

  { Tmainback }

  Tmainback = Class(TForm)
    CheckBox_YearAfter: TCheckBox;
    Label10: TLabel;
    Label7: TLabel;
    Label_Drive: TLabel;
    MaskEdit_Year: TMaskEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton_Exit: TSpeedButton;
    SpeedButton13: TSpeedButton;
    CheckBox_nimg: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label13: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var CloseAction: TCloseAction);
    Procedure FormKeyDown(Sender: TObject; Var Key: word; Shift: TShiftState);
    Procedure FormWindowStateChange(Sender: TObject);
    procedure Label3DblClick(Sender: TObject);
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
    Procedure SpeedButton_ExitClick(Sender: TObject);
    Procedure SpeedButton13Click(Sender: TObject);
  private
  protected
    //Procedure CreateParams(Var Params: TCreateParams); override;
    //procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
  End;

Function showForm_Mainback():TForm;

Var
  mainback: Tmainback;

Implementation

{$R *.lfm}

Uses MainMenu_unit, choice_unit, ToolsFunction_unit;

Function showForm_Mainback():TForm;
Begin
  mainback := Tmainback.Create(Application);
  Result := mainback;
  With mainback Do Begin
    Parent := MainForm1.Panel1;
    Align := alClient;
    //--------------------------
    BorderIcons := [biSystemMenu]; // [biSystemMenu,biMinimize];
    BorderStyle := bsNone; // bsToolWindow  bsSizeToolWin  bsSizeable  bsNone  bsDialog  bsSingle
    FormStyle := fsNormal ; //fsMDIChild;
    KeyPreview := True;
    Show;
  End;
End;

procedure Tmainback.FormCreate(Sender: TObject);
Begin
  Label_Drive.Caption := MainForm1.netsource;
  MaskEdit_Year.EditMask := '!900;1;_';
End;

procedure Tmainback.FormClose(Sender: TObject; var CloseAction: TCloseAction);
Begin
  CloseAction := caFree;
  MainForm1.Image1.Visible := True;
  MainForm1.Panel2.Enabled := True;
  MainForm1.WorkForm:=Nil;
End;

procedure Tmainback.FormKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
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
    Ord('7'): SpeedButton11Click(Sender);
    Ord('8'): SpeedButton13Click(Sender);
    Ord('9'): SpeedButton7Click(Sender);
    Ord('A'): SpeedButton8Click(Sender);
    Ord('B'): SpeedButton9Click(Sender);
    Ord('C'): SpeedButton10Click(Sender);
  End;
End;

procedure Tmainback.FormWindowStateChange(Sender: TObject);
Begin
  // 縮小時還原最大化 OK
  Case Self.WindowState Of
    wsNormal: Begin
        Self.WindowState := wsMaximized;
        WriteStrToFile_Debug('WindowState wsNormal ');
      End;
    wsMinimized: begin
        WriteStrToFile_Debug('WindowState wsMinimized ');
        Self.WindowState := wsMaximized;
    end;
    wsMaximized: WriteStrToFile_Debug('WindowState wsMaximized ');
    wsFullScreen: WriteStrToFile_Debug('WindowState wsFullScreen ');
  End;

End;

procedure Tmainback.Label3DblClick(Sender: TObject);
begin
end;

procedure Tmainback.SpeedButton1Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  If CheckBox_YearAfter.Checked Then Begin
    showForm_ChoiceMainback(Self,'s11.vbs', 'bak', 'n', '備份客戶所有資料', MaskEdit_Year.Text);
  End Else Begin
    showForm_ChoiceMainback(Self,'s1.vbs', 'bak', 'n', '備份客戶所有資料', MaskEdit_Year.Text);
  End;

End;

procedure Tmainback.SpeedButton2Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  showForm_ChoiceMainback(Self,'s1.vbs', 'res', 'n', '回置客戶所有資料', '');
End;

procedure Tmainback.SpeedButton3Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  MainForm1.bak_res_nimgbuy := '';
  If CheckBox_nimg.Checked Then
    MainForm1.bak_res_nimgbuy := '1';
  showForm_ChoiceMainback(Self,'s2.vbs', 'bak', 'y', '備份客戶年度所有資料', '');
End;

procedure Tmainback.SpeedButton4Click(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;
  MainForm1.bak_res_nimgbuy := '';
  If CheckBox_nimg.Checked Then
    MainForm1.bak_res_nimgbuy := '1';
  showForm_ChoiceMainback(Self,'s2.vbs', 'res', 'y', '回置客戶年度所有資料', '');
End;

procedure Tmainback.SpeedButton5Click(Sender: TObject);
Begin
  If Not Intital_Tables(1) Then
    Exit;
  showForm_ChoiceMainback(Self,'3mc.vbs', 'bak', 'n', '備份工商客戶資料', '');
End;

procedure Tmainback.SpeedButton6Click(Sender: TObject);
Begin
  If Not Intital_Tables(1) Then
    Exit;
  showForm_ChoiceMainback(Self,'3mc.vbs', 'res', 'n', '回置工商客戶資料', '');
End;

procedure Tmainback.SpeedButton7Click(Sender: TObject);
Begin
  // 不用開客戶
  showForm_ChoiceMainback(Self,'3sw.vbs', 'bak', 'n', '備份事務所管理系統客戶資料', '');

End;

procedure Tmainback.SpeedButton8Click(Sender: TObject);
Begin
  // 不用開客戶
  showForm_ChoiceMainback(Self,'3sw.vbs', 'res', 'n', '回置事務所管理系統客戶資料', '');
End;

procedure Tmainback.SpeedButton9Click(Sender: TObject);
Begin
  If Not Intital_Tables(2) Then
    Exit;
  showForm_ChoiceMainback(Self,'3salaryall.vbs', 'bak', 'n', '備份二代健保薪資資料', '');
End;

procedure Tmainback.SpeedButton10Click(Sender: TObject);
Begin
  If Not Intital_Tables(2) Then
    Exit;
  showForm_ChoiceMainback(Self,'3salaryall.vbs', 'res', 'n', '回置二代健保薪資資料', '');
End;

procedure Tmainback.SpeedButton11Click(Sender: TObject);
Begin
  // 不用開客戶
  showForm_ChoiceMainback(Self,'3comm.vbs', 'bak', 'n', '備份客戶基本資料', '');
End;

procedure Tmainback.SpeedButton13Click(Sender: TObject);
Begin
  // 不用開客戶
  showForm_ChoiceMainback(Self,'3comm.vbs', 'res', 'n', '回置客戶基本資料', '');
End;

//procedure Tmainback.CreateParams(var Params: TCreateParams);
//Begin
//  Inherited CreateParams(Params);
//  // 移除最大及最小化按鈕  沒作用
//  Params.Style := Params.Style And Not (WS_MINIMIZEBOX Or WS_MAXIMIZEBOX);
//End;
//procedure Tmainback.WMSysCommand(var Msg: TWMSysCommand);
//begin
//  WriteStrToFile_Debug(Format(' 1 TWMSysCommand %X %D ',[Msg.CmdType,Msg.CmdType]));
//  if (Msg.CmdType = SC_MINIMIZE) then begin
//    // 攔截最小化，不執行 , 沒作用
//    WriteStrToFile_Debug(Format(' 2 TWMSysCommand %X %D ',[Msg.CmdType,Msg.CmdType]));
//    //Exit;
//  end;
//  inherited ; //WMSysCommand(Msg);
//end;

procedure Tmainback.SpeedButton_ExitClick(Sender: TObject);
Begin // 離開
  PostMessage(self.Handle, WM_Close, 0, 0);
End;



End.
