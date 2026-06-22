Unit choice_unit;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, StrUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons,
  DBGrids, Grids, DB, BufDataset, dbf, Dialogs, Windows, DateUtils, Process,
  Graphics, ComCtrls, MaskEdit, DBCtrls;

Type

  { Tchoice }

  Tchoice = Class(TForm)
    BitBtn_Find: TBitBtn;
    BitBtn_Exit: TBitBtn;
    DataSource2: TDataSource;
    DBEdit1: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    Edit_Cusno: TEdit;
    Edit_Cusna: TEdit;
    Edit_DestDrive: TMaskEdit;
    Edit_Year: TMaskEdit;
    Label1: TLabel;
    Label_OptionLabel: TLabel;
    Label_Title: TLabel;
    Label_Title1: TLabel;
    Label_Year: TLabel;
    Label_ThisCnt: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label_Cmd: TLabel;
    Label_SelectCount: TLabel;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    SpeedButton_Page4_F8: TSpeedButton;
    SpeedButton_Page4_F9: TSpeedButton;
    SpeedButton_Page3_Esc: TSpeedButton;
    SpeedButton_Page2_F8: TSpeedButton;
    SpeedButton_Page2_F9: TSpeedButton;
    Table1: TBufDataset;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Edit_FindText: TEdit;
    Label_ActionNa: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label_Drive: TLabel;
    Label9: TLabel;
    Label_warnring: TLabel;
    PageControl1: TPageControl;
    Panel_Top: TPanel;
    Panel2: TPanel;
    Panel_Search: TPanel;
    Panel_Bottom: TPanel;
    RadioGroup2: TRadioGroup;
    SpeedButton_Esc: TSpeedButton;
    SpeedButton_F11: TSpeedButton;
    SpeedButton_Space: TSpeedButton;
    SpeedButton_F2: TSpeedButton;
    SpeedButton_F3: TSpeedButton;
    SpeedButton_F4: TSpeedButton;
    SpeedButton_F5: TSpeedButton;
    SpeedButton_F6: TSpeedButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Procedure BitBtn_FindClick(Sender: TObject);
    Procedure BitBtn_ExitClick(Sender: TObject);
    Procedure DBGrid1DblClick(Sender: TObject);
    Procedure DBGrid1KeyDown_(Sender: TObject; Var Key: word; Shift: TShiftState);

    Procedure Edit_DestDriveEditingDone(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var CloseAction: TCloseAction);
    Procedure FormDestroy(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: word; Shift: TShiftState);
    Procedure FormShow(Sender: TObject);
    Procedure FormWindowStateChange(Sender: TObject);
    Procedure Label_CmdDblClick(Sender: TObject);
    Procedure Label_TitleDblClick(Sender: TObject);
    Procedure RadioGroup1SelectionChanged(Sender: TObject);
    Procedure SpeedButton_EscClick(Sender: TObject);
    Procedure SpeedButton_F11Click(Sender: TObject);
    Procedure SpeedButton_F2Click(Sender: TObject);
    Procedure SpeedButton_F3Click(Sender: TObject);
    Procedure SpeedButton_F4Click(Sender: TObject);
    Procedure SpeedButton_F5Click(Sender: TObject);
    Procedure SpeedButton_F6Click(Sender: TObject);
    Procedure SpeedButton_Page4_F8Click(Sender: TObject);
    Procedure SpeedButton_Page2_F8Click(Sender: TObject);
    Procedure SpeedButton_Page2_F9Click(Sender: TObject);
    Procedure SpeedButton_Page4_F9Click(Sender: TObject);
    Procedure SpeedButton_SpaceClick(Sender: TObject);
  private
    Debug: boolean;
  public
    transpic: string;
    panelvalue: string;

    PriorForm: TForm;
    run_script: string;
    bak_res: string;
    showyear: string;
    limitYear: string;
    actionCaption: string;

    SelCnt: integer;  // 備份回置家數

    WriteHistoryFlag: boolean;
    Function getNameFromScriptName(scriptna: string): string;
    Procedure RunBackupRestore(SL: TStringList; Cusno, ScriptPath, wbakFile, DestDrive, bYear, myTmpFile, myDropBoxPath: string);
    Procedure RunBackupRestore_Comm(SL: TStringList; Cusno, ScriptPath, wbakFile, DestDrive, bYear, myTmpFile, myDropBoxPath: string);
    Procedure RunBackupRestore_W307(SL: TStringList; Cusno, ScriptPath, wbakFile, DestDrive, bYear, myTmpFile, myDropBoxPath: string);

    Function EnabledDBEditItem(Item: integer; Flag: boolean): TDBEdit;
    Procedure EnabledDBEditAll(Flag: boolean);
    Function Initial_HistoryDataSet: boolean;
    Function SaveTo_HistoryDataSet: boolean;
    Procedure LoadFrom_HistoryDataSet;
  End;

Var
  choice: Tchoice;

Procedure showForm_ChoiceMainback(xPriorForm: TForm; xrun_script, xbak_res, xshowyear, xactionCaption, xlimitYear: string);

Implementation

Uses MainMenu_unit, ToolsFunction_unit;

  {$R *.lfm}

Procedure showForm_ChoiceMainback(xPriorForm: TForm; xrun_script, xbak_res, xshowyear, xactionCaption, xlimitYear: string);
Begin
  If (choice <> nil) Then Begin
    WriteStrToFile_Debug('1 choice<>Nil ');
    choice := nil;
  End;
  If (Assigned(choice)) Then Begin
    WriteStrToFile_Debug('2 Assigned(choice) ');
    choice := nil;
  End;
  WriteStrToFile_Debug('3 ');
  choice := Tchoice.Create(Application);
  With choice Do Begin
    PriorForm := xPriorForm;
    run_script := xrun_script;
    bak_res := xbak_res;
    showyear := xshowyear;
    actionCaption := xactionCaption;
    Caption := '選擇客戶-[' + xactionCaption + ']';
    limitYear := xlimitYear;
    Label_ActionNa.Caption := xactionCaption;  // Page1
    Label_Drive.Caption := IFThen(xbak_res = 'bak', '備份至', '來源') + '磁碟機';
    Label_Year.Caption := IFThen(xbak_res = 'bak', '備份', '回置') + '作業年度';

    Label_Title.Caption := xactionCaption; // Page2
    Edit_DestDrive.OnEditingDone := @Edit_DestDriveEditingDone;
    Edit_Year.OnEditingDone := @Edit_DestDriveEditingDone;
    Edit_DestDrive.MaxLength := 1;  // 磁碟機
    Edit_Year.MaxLength := 3;  // 年度
    Edit_Year.EditMask := '!900;1;_';
    Edit_Year.Text := RightStr('0' + IntToStr(YearOf(Date()) - 1911), 3);
    EnabledDBEditAll(False);
    //--------------------------
    BorderIcons := [biSystemMenu]; // , biMinimize,biMaximize
    BorderStyle := bsSizeable; // bsSizeable;  bsDialog
    FormStyle := fsNormal; //fsMDIChild; // fsNormal ;
    Position := poMainFormCenter; //poDesigned ;
    WindowState := wsNormal; //wsMaximized; //
    KeyPreview := True;
    //Left := PriorForm.Left;
    //Top := PriorForm.Top;
    //BringToFront;
    ShowModal;
  End;
  //FreeAndNil(choice);
End;

Procedure Tchoice.FormShow(Sender: TObject);
Begin
  PageControl1.ShowTabs := False;
  // 是否顯示年度,給不用選客戶用
  Label_Year.Visible := True;
  Edit_Year.Visible := True;
  If showyear = 'n' Then Begin
    Label_Year.Visible := False;
    Edit_Year.Visible := False;
  End;

  If run_script = '3comm.vbs' Then Begin   //客戶基本資料
    PageControl1.ActivePageIndex := 1;
  End Else If run_script = '3sw.vbs' Then Begin      // 事務所管理
    PageControl1.ActivePageIndex := 1;
  End Else Begin
    PageControl1.ActivePageIndex := 0;
    With MainForm1 Do Begin
      With BufDataset_Cus Do Begin
        Self.DataSource1.DataSet := BufDataset_Cus;
        Self.DBGrid1.DataSource := Self.DataSource1;
        With Self.DBGrid1 Do Begin
          AlternateColor := $00D3EFFE; // 隔行變色 粉土黃色
          Options := Options + [dgRowHighlight, dgDisableInsert, dgDisableDelete]; // 活動列顯色
          With Columns Do Begin
            Clear;
            With Add Do Begin
              Width := 80;
              FieldName := 'CHECKT';
              ReadOnly := False;
              Title.Caption := '選擇';
              Title.Alignment := TAlignment.taCenter;
              Title.Font.Size := 12;
            End;
            With Add Do Begin
              Width := 200;
              FieldName := 'CUSNO';
              Title.Caption := '客戶代號';
              ReadOnly := True;
              Title.Alignment := TAlignment.taCenter;
              Title.Font.Size := 12;
            End;
            With Add Do Begin
              Width := 700;
              FieldName := 'CUSNAME';
              Title.Caption := '客戶名稱';
              ReadOnly := True;
              Title.Alignment := TAlignment.taCenter;
              Title.Font.Size := 12;
            End;
          End;
          If Self.DBGrid1.CanSetFocus Then
            SetFocus;
        End;
      End;
    End;
  End;
  // OnWindowStateChange := @FormWindowStateChange;
  // Self.WindowState := wsMaximized;
End;

Procedure Tchoice.FormWindowStateChange(Sender: TObject);
Begin
  // 縮小時還原最大化 OK
  Case Self.WindowState Of
    wsNormal: Begin
      Self.WindowState := wsMaximized;
      WriteStrToFile_Debug('1 WindowState wsNormal ');
    End;
    wsMinimized: Begin
      Self.WindowState := wsMaximized;
      WriteStrToFile_Debug('2 WindowState wsMinimized ');
    End;
    wsMaximized: WriteStrToFile_Debug('3 WindowState wsMaximized ');
    wsFullScreen: WriteStrToFile_Debug('4 WindowState wsFullScreen ');
  End;

End;

Procedure Tchoice.Label_CmdDblClick(Sender: TObject);
Begin
  Str2Clipboard(Label_Cmd.Caption, 1500);
End;

Procedure Tchoice.Label_TitleDblClick(Sender: TObject);
Begin
  Debug := Not Debug;

  If Debug Then
    Label_Cmd.Visible := True;

End;

Function Tchoice.EnabledDBEditItem(Item: integer; Flag: boolean): TDBEdit;
Var
  vDBEdit: TDBEdit;
  sDBEdit: string;
Begin
  Result := nil;
  sDBEdit := Format('DBEdit%d', [Item]);
  vDBEdit := FindComponent(sDBEdit) As TDBEdit;
  If vDBEdit <> nil Then Begin
    vDBEdit.Enabled := Flag;
    Result := vDBEdit;
  End;
End;

Procedure Tchoice.EnabledDBEditAll(Flag: boolean);
Var
  II: integer;
Begin
  For II := 1 To 20 Do Begin
    EnabledDBEditItem(II, Flag);
  End;
End;

Procedure Tchoice.RadioGroup1SelectionChanged(Sender: TObject);
Var
  vItem: integer;
  vDBEdit: TDBEdit;
Begin
  If WriteHistoryFlag Then Begin
    EnabledDBEditAll(False);
    vItem := RadioGroup1.ItemIndex + 1;
    vDBEdit := EnabledDBEditItem(vItem, True);
    If vDBEdit <> nil Then
      If vDBEdit.CanSetFocus Then
        vDBEdit.SetFocus;
  End;

End;

Procedure Tchoice.FormClose(Sender: TObject; Var CloseAction: TCloseAction);
Begin
  PriorForm.BringToFront;
  CloseAction := caFree;
End;

Procedure Tchoice.FormDestroy(Sender: TObject);
Begin
End;

Procedure Tchoice.FormKeyDown(Sender: TObject; Var Key: word; Shift: TShiftState);
Begin
  Case Key Of
    VK_RETURN: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then Begin
        Key := 0;
        If (Panel_Search.Visible) Then  Begin
          If (string(Edit_FindText.Text).IsEmpty) Then Begin
            Panel_Search.Visible := False;
            Self.DBGrid1.SetFocus;
          End Else Begin
            BitBtn_Find.Click;
          End;
        End;
      End Else If Self.PageControl1.ActivePageIndex = 1 Then Begin
        self.SelectNext(self.ActiveControl, True, True);
      End;
    End;
    VK_Space: Begin
      Key := 0;
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_Space.Click;
    End;
    VK_F2: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F2.Click;
    End;
    VK_F3: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F3.Click;
    End;
    VK_F4: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F4.Click;
    End;
    VK_F5: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F5.Click;
    End;
    VK_F6: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F6.Click;
    End;
    VK_F11: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F11.Click;
    End;
    VK_ESCAPE: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then Begin
        If (Panel_Search.Visible) Then  Begin
          BitBtn_Exit.Click;
        End Else Begin
          SpeedButton_Esc.Click;
        End;
      End
      Else If Self.PageControl1.ActivePageIndex = 2 Then
        SpeedButton_Page3_Esc.Click;
    End;
    VK_F8: Begin
      If Self.PageControl1.ActivePageIndex = 1 Then
        SpeedButton_Page2_F8.Click
      Else If Self.PageControl1.ActivePageIndex = 3 Then
        SpeedButton_Page4_F8.Click;
    End;
    VK_F9: Begin
      If Self.PageControl1.ActivePageIndex = 1 Then
        SpeedButton_Page2_F9.Click
      Else If Self.PageControl1.ActivePageIndex = 3 Then
        SpeedButton_Page4_F9.Click;
    End;
  End;

End;

Procedure Tchoice.SpeedButton_EscClick(Sender: TObject);
Begin
  PostMessage(self.Handle, WM_Close, 0, 0);
End;

Procedure Tchoice.SpeedButton_F11Click(Sender: TObject);
Begin
  SelCnt := 0;
  With self.DBGrid1.DataSource.DataSet Do Begin
    DisableControls;
    CheckBrowseMode;
    Last;
    While Not Bof Do Begin
      If FieldByName('CHECKT').AsBoolean Then
        Inc(SelCnt);
      Prior;
    End;
    EnableControls;
  End;
  If SelCnt > 0 Then Begin
    PageControl1.ActivePageIndex := 1;
    If (Self.run_script = '3s1.vbs') Or (Self.run_script = '3s2.vbs') Then
      Label_warnring.Visible := True;
    Label_Year.Visible := True;
    Edit_Year.Visible := True;
    If showyear = 'n' Then Begin
      Label_Year.Visible := False;
      Edit_Year.Visible := False;
    End;
    If Edit_DestDrive.CanSetFocus Then
      Edit_DestDrive.SetFocus;
  End Else Begin
    ShowMessage('未選擇客戶!');
  End;
End;

Procedure Tchoice.SpeedButton_F2Click(Sender: TObject);
Begin
  With self.DBGrid1.DataSource.DataSet Do Begin
    DisableControls;
    CheckBrowseMode;
    Last;
    While Not Bof Do Begin
      Edit;
      FieldByName('CHECKT').AsBoolean := True;
      Post;
      Prior;
    End;
    EnableControls;
  End;
End;

Procedure Tchoice.SpeedButton_F3Click(Sender: TObject);
Begin
  With self.DBGrid1.DataSource.DataSet Do Begin
    DisableControls;
    CheckBrowseMode;
    Last;
    While Not Bof Do Begin
      Edit;
      FieldByName('CHECKT').AsBoolean := False;
      Post;
      Prior;
    End;
    EnableControls;
  End;
End;

Procedure Tchoice.SpeedButton_F4Click(Sender: TObject);
Begin
  With self.DBGrid1.DataSource.DataSet Do Begin
    CheckBrowseMode;
  End;
  Panel_Search.Visible := True;
  Edit_FindText.Text := '';
  Edit_FindText.SetFocus;
End;

Procedure Tchoice.SpeedButton_F5Click(Sender: TObject);
Begin
  // 儲存為記錄
  If Initial_HistoryDataSet Then Begin
    WriteHistoryFlag := True;
    Label_OptionLabel.Caption := '【請選擇要儲存的名稱】';
    PageControl1.ActivePageIndex := 3;
    If RadioGroup1.CanSetFocus Then
      RadioGroup1.SetFocus;
  End;

End;

Procedure Tchoice.SpeedButton_F6Click(Sender: TObject);
Begin
  // 載入記錄
  If Initial_HistoryDataSet Then Begin
    WriteHistoryFlag := False;
    Label_OptionLabel.Caption := '【請選擇要載入的名稱】';
    PageControl1.ActivePageIndex := 3;
    If RadioGroup1.CanSetFocus Then
      RadioGroup1.SetFocus;
  End;

End;

Procedure Tchoice.SpeedButton_Page4_F8Click(Sender: TObject);
Begin
  If WriteHistoryFlag Then Begin   // 儲存為記錄
    SaveTo_HistoryDataSet;
  End Else Begin // 載入記錄
    LoadFrom_HistoryDataSet;
  End;
  MainForm1.BufDataset_Cus.First;
  PageControl1.ActivePageIndex := 0;

End;

Procedure Tchoice.SpeedButton_Page2_F8Click(Sender: TObject);
Var
  ScriptPath, wbakFile, TempFilePath, dts, myTmpFile, myDropBoxPath, bYear, DestDrive, UnzipPath: string;
  myDestDBInageName, myDBInagePath, myDestDBInageFullNameDBF, myDestDBInageFullNameCDX, mySourDBInageFullNameDBF, mySourDBInageFullNameCDX: string;
  SL: TStringList;
  iCnt: integer;
Begin
  If string(Edit_DestDrive.Text).IsEmpty Then Begin
    ShowMessage('請輸入磁碟機代號!');
    Edit_DestDrive.SetFocus;
    Exit;
  End;
  If showyear <> 'n' Then Begin
    If string(Edit_Year.Text).IsEmpty Then Begin
      ShowMessage('請輸入年度!');
      Edit_Year.SetFocus;
      Exit;
    End;
  End;

  PageControl1.ActivePageIndex := 2;
  Label_SelectCount.Caption := Format('%d', [SelCnt]);
  // 通用備份
  DestDrive := Edit_DestDrive.Text;
  ScriptPath := MainForm1.netsource + ':\W3000\';
  If Edit_Year.Text = '' Then
    Edit_Year.Text := '100';
  bYear := Trim(Edit_Year.Text);
  If (limitYear <> '') And (run_script = 's11.vbs') Then Begin
    bYear := limitYear;
  End;
  If Length(bYear) >= 2 Then
    bYear := Copy(bYear, Length(bYear) - 1, 2);
  // 回置的 LOG
  SL := TStringList.Create;
  wbakFile := MainForm1.netsource + ':\W3000\COMM\wBackup.log';
  TempFilePath := MainForm1.netsource + ':\W3000\backup\';
  ForceDirectories(TempFilePath);
  // vbs 回填的 LOG 檔
  dts := FormatDateTime('yyyy_mm_dd_hh_mm_ss_AM/PM', Now);
  myTmpFile := TempFilePath + 'wbackup_' + dts + '.TXT';

  myDropBoxPath := '"' + MainForm1.DropBoxPath + '"';
  If Trim(MainForm1.DropBoxPath) = '' Then
    myDropBoxPath := '';

  Label_ThisCnt.Caption := Format('%d', [1]);
  Edit_Cusno.Text := '';
  Edit_Cusna.Text := '';
  Application.ProcessMessages;
  If run_script = '3comm.vbs' Then Begin   //客戶基本資料
    SetCurrentDirectory(pansichar(ScriptPath));
    RunBackupRestore_Comm(SL, '', ScriptPath, wbakFile, DestDrive, bYear, myTmpFile, myDropBoxPath);
  End Else If run_script = '3sw.vbs' Then Begin      // 事務所管理
    // 回置先檢查目錄在不在
    If bak_res = 'res' Then Begin
      UnzipPath := Format('%s:\W3000\Data\%s', [MainForm1.netsource, 'w307acc']);
      ForceDirectories(UnzipPath);
      SetCurrentDirectory(pansichar(UnzipPath));
    End;
    RunBackupRestore_W307(SL, '', ScriptPath, wbakFile, DestDrive, bYear, myTmpFile, myDropBoxPath);
  End Else Begin
    // 一般通用備份回置
    With self.DBGrid1.DataSource.DataSet Do Begin
      iCnt := 1;
      First;
      While Not EOF Do Begin
        If FieldByName('CHECKT').AsBoolean Then Begin
          Label_ThisCnt.Caption := Format('%d', [iCnt]);
          Edit_Cusno.Text := FieldByName('CUSNO').AsString;
          Edit_Cusna.Text := FieldByName('CUSName').AsString;
          // 回置先檢查目錄在不在
          If bak_res = 'res' Then Begin
            If run_script = '3mc.vbs' Then Begin   //二代健保薪資
              UnzipPath := Format('%s:\W3000\wmc\Data\%s', [MainForm1.netsource, 'w' + Copy(FieldByName('CUSNO').AsString.Trim, 1, 7)]);
            End Else If run_script = '3salaryall.vbs' Then Begin   //二代健保薪資
              UnzipPath := Format('%s:\W3000\Data\%s', [MainForm1.netsource, 'w' + Copy(FieldByName('CUSNO').AsString.Trim, 1, 7)]);
            End Else Begin
              UnzipPath := Format('%s:\W3000\Data\%s', [MainForm1.netsource, FieldByName('CUSNO').AsString.Trim]);

              // 回置時備份，不分系統，名稱加流水號  DBImage.dbf  FormatDateTime("dddd, mmmm d, yyyy ' at ' hh:mm AM/PM", Now() + 0.125);
              Randomize;
              myDestDBInageName := 'DBImage_';
              myDestDBInageName := myDestDBInageName + StringReplace(run_script, '.', '_', [rfReplaceAll]) + '_';
              myDestDBInageName := myDestDBInageName + FormatDateTime('yyyymmdd_hh:mm:ss', Now()) + '_' + IntToStr(random(MilliSecondOf(Now())));
              myDestDBInageName := StringReplace(myDestDBInageName, ':', '', [rfReplaceAll]);
              myDBInagePath := MainForm1.netsource + ':\W3000\Backup\' + FieldByName('CUSNO').AsString.Trim + '\' + bYear + '\';
              myDestDBInageFullNameDBF := myDBInagePath + myDestDBInageName + '.dbf';
              myDestDBInageFullNameCDX := myDBInagePath + myDestDBInageName + '.cdx';
              mySourDBInageFullNameDBF := MainForm1.netsource + ':\W3000\DATA\' + FieldByName('CUSNO').AsString.Trim + '\' + bYear + '\Img\' + 'DBImage.DBF';
              mySourDBInageFullNameCDX := MainForm1.netsource + ':\W3000\DATA\' + FieldByName('CUSNO').AsString.Trim + '\' + bYear + '\Img\' + 'DBImage.CDX';
              If (FileExists(mySourDBInageFullNameDBF)) Then Begin
                If (ForceDirectories(myDBInagePath)) Then Begin
                  CopyFile(pansichar(mySourDBInageFullNameDBF), pansichar(myDestDBInageFullNameDBF), False);
                  CopyFile(pansichar(mySourDBInageFullNameCDX), pansichar(myDestDBInageFullNameCDX), False);
                End;
              End;
              //----------------------------------------------------------
            End;
            ForceDirectories(UnzipPath);
            SetCurrentDirectory(pansichar(UnzipPath));
          End;
          Application.ProcessMessages;
          RunBackupRestore(SL, FieldByName('CUSNO').AsString, ScriptPath, wbakFile, DestDrive, bYear, myTmpFile, myDropBoxPath);
          Inc(iCnt);
        End;
        Next;
      End;
    End;
  End;
  SL.SaveToFile(wbakFile);
  FreeAndNil(SL);

  SetCurrentDirectory(pansichar(ExtractFilePath(Application.ExeName)));

  ShellExecute(Application.Handle, pansichar('open'), pansichar(myTmpFile), pansichar(''), nil, SW_SHOWNORMAL);

End;

Procedure Tchoice.SpeedButton_Page2_F9Click(Sender: TObject);
Begin // 取消,回到前一頁
  If run_script = '3comm.vbs' Then Begin   //客戶基本資料
    Close;
  End Else If run_script = '3sw.vbs' Then Begin      // 事務所管理
    Close;
  End Else If run_script = '3salaryall.vbs' Then Begin   //二代健保薪資
    Close;
  End Else Begin
    PageControl1.ActivePageIndex := 0;
  End;
End;

Procedure Tchoice.SpeedButton_Page4_F9Click(Sender: TObject);
Begin // F9 取消,回到前一頁
  PageControl1.ActivePageIndex := 0;
End;

Procedure Tchoice.SpeedButton_SpaceClick(Sender: TObject);
Begin
  With self.DBGrid1.DataSource.DataSet Do Begin
    CheckBrowseMode;
    Edit;
    FieldByName('CHECKT').AsBoolean := Not FieldByName('CHECKT').AsBoolean;
    Post;
    If Not EOF Then
      Next;
  End;
End;

Function Tchoice.getNameFromScriptName(scriptna: string): string;
Begin
  Result := '';
  If (scriptna = 's1p.vbs') Then Begin
    Result := '回置客戶所有資料(不含圖檔)';
  End Else
  If (scriptna = 's2p.vbs') Then  Begin
    Result := '回置客戶年度所有資料(不含圖檔)';
  End Else
  If (scriptna = '3s1p.vbs') Then  Begin
    Result := '回置客戶營業稅年度資料(不含圖檔)';
  End Else
  If (scriptna = '3s2p.vbs') Then Begin
    Result := '回置客戶會計總帳及成本年度資料(不含圖檔)';
  End Else
  If (scriptna = 's1.vbs') Then  Begin
    Result := '回置客戶所有資料';
  End Else
  If (scriptna = 's2.vbs') Then  Begin
    Result := '回置客戶年度所有資料';
  End Else
  If (scriptna = '3mc.vbs') Then  Begin
    Result := '回置工商客戶資料';
  End Else
  If (scriptna = '3sw.vbs') Then Begin
    Result := '回置事務所管理系統資料';
  End Else
  If (scriptna = '3s1.vbs') Then Begin
    Result := '回置客戶營業稅年度資料';
  End Else
  If (scriptna = '3s2.vbs') Then Begin
    Result := '回置客戶會計總帳及成本年度資料';
  End Else
  If (scriptna = '3s4.vbs') Then  Begin
    Result := '回置客戶固定資產年度資料';
  End Else
  If (scriptna = '3s5.vbs') Then  Begin
    Result := '回置客戶薪資扣繳年度資料';
  End Else
  If (scriptna = '3s6.vbs') Then Begin
    Result := '回置客戶結算申報年度資料';
  End Else
  If (scriptna = '3sa.vbs') Then Begin
    Result := '回置客戶兩稅及未分配盈餘年度資料';
  End Else
  If (scriptna = '3s8.vbs') Then Begin
    Result := '回置客戶預估系統年度資料';
  End Else
  If (scriptna = '3sp.vbs') Then Begin
    Result := '回置執行業務資料';
  End Else
  If (scriptna = '3sq.vbs') Then Begin
    Result := '回置清算系統資料';
  End Else
  If (scriptna = '3ss.vbs') Then Begin
    Result := '回置客戶機關團體結算年度資料';
  End Else
  If (scriptna = '5s1.vbs') Then  Begin
    Result := '回置客戶抽查系統年度資料';
  End Else
  If (scriptna = '5s2.vbs') Then Begin
    Result := '回置客戶財稅簽系統年度資料';
  End Else
  If (scriptna = '5s3.vbs') Then Begin
    Result := '回置客戶機關團體稅簽系統年度資料';
  End Else
  If (scriptna = '3salary.vbs') Then Begin
    Result := '回置客戶二代健保薪資系統年度資料';
  End Else
  If (scriptna = '3salaryall.vbs') Then Begin
    Result := '回置客戶二代健保薪資系統所有資料';
  End;

End;

Procedure Tchoice.RunBackupRestore(SL: TStringList; Cusno, ScriptPath, wbakFile, DestDrive, bYear, myTmpFile, myDropBoxPath: string);
Var
  command: string;
  myLog: string;
Begin
  //                客戶代號 , 年度 , 磁碟代號, BAK/RES, 資料磁碟 ,轉出暫存檔 ,dropbox 路徑
  //wscript F:\W3000\s1.vbs 0-0 97 C bak F: F:\W3000\backup\wbackup_2026_05_19_09_56_11_AM.TXT
  command := Format('wscript %s %s %s %s %s %s: %s %s %s', [ScriptPath + run_script, Cusno, bYear, DestDrive, bak_res, MainForm1.netsource, myTmpFile, myDropBoxPath, MainForm1.bak_res_nimgbuy]);
  //WriteStrToFile_Debug(command);
  Label_Cmd.Caption := command;
  Label_Cmd.Refresh;
  Application.ProcessMessages;

  ExecuteAndWait(command);

  If (Self.bak_res = 'res') Then Begin
    If FileExists(wbakFile) Then
      SL.LoadFromFile(wbakFile);
    SL.LoadFromFile(wbakFile);
    myLog := '動作:' + getNameFromScriptName(run_script) + ' 客戶:' + Cusno + ' 年度:' + bYear + ' 目的磁碟:' + DestDrive + ' 資料磁碟' + MainForm1.netsource + ':' + ' 程序檔:' + ScriptPath + run_script + ' 回置時間:' + DateToStr(Date()) + ' ' + TimeToStr(Time());
    SL.Add(myLog);
  End;

End;

Procedure Tchoice.RunBackupRestore_COMM(SL: TStringList; Cusno, ScriptPath, wbakFile, DestDrive, bYear, myTmpFile, myDropBoxPath: string);
Var
  command: string;
  myLog: string;
Begin
  //要執行的命令  解壓密碼 hisq
  //String command=prog + dash + Form1->run_script + dash + "hisq"+ dash+ "99" dash + bYear + dash + Form1->bak_res+ dash + Form1->netsource+":" +dash + myTmpFile + dash +  myDropBoxPath  ;
  command := Format('wscript %s %s %s %s %s %s: %s %s', [ScriptPath + run_script, 'hisq', '99', DestDrive, bak_res, MainForm1.netsource, myTmpFile, myDropBoxPath]);
  //WriteStrToFile_Debug(command);
  Label_Cmd.Caption := command;
  Label_Cmd.Refresh;
  Application.ProcessMessages;

  ExecuteAndWait(command);

  If (Self.bak_res = 'res') Then Begin
    If FileExists(wbakFile) Then
      SL.LoadFromFile(wbakFile);
    SL.LoadFromFile(wbakFile);
    myLog := '動作:' + actionCaption + ' 客戶:' + 'Comm' + ' 年度:' + 'None' + ' 目的磁碟:' + DestDrive + ' 資料磁碟' + MainForm1.netsource + ':' + ' 程序檔:' + ScriptPath + run_script + ' 回置時間:' + DateToStr(Date()) + ' ' + TimeToStr(Time());
    SL.Add(myLog);
  End;

End;

Procedure Tchoice.RunBackupRestore_W307(SL: TStringList; Cusno, ScriptPath, wbakFile, DestDrive, bYear, myTmpFile, myDropBoxPath: string);
Var
  command: string;
  myLog: string;
Begin
  //要執行的命令  解壓密碼 hisq
  //String command=prog + dash + Form1->run_script + dash + "w307acc"+ dash+ "99" + dash + bYear + dash + Form1->bak_res + dash + Form1->netsource+":"+ dash + myTmpFile + dash + myDropBoxPath;
  command := Format('wscript %s %s %s %s %s %s: %s %s', [ScriptPath + run_script, 'w307acc', '99', DestDrive, bak_res, MainForm1.netsource, myTmpFile, myDropBoxPath]);
  //WriteStrToFile_Debug(command);
  Label_Cmd.Caption := command;
  Label_Cmd.Refresh;
  Application.ProcessMessages;

  ExecuteAndWait(command);

  If (Self.bak_res = 'res') Then Begin
    If FileExists(wbakFile) Then
      SL.LoadFromFile(wbakFile);
    myLog := '動作:' + actionCaption + ' 客戶:' + 'W307ACC' + ' 年度:' + 'None' + ' 目的磁碟:' + DestDrive + ' 資料磁碟' + MainForm1.netsource + ':' + ' 程序檔:' + ScriptPath + run_script + ' 回置時間:' + DateToStr(Date()) + ' ' + TimeToStr(Time());
    SL.Add(myLog);
  End;

End;

Function Tchoice.Initial_HistoryDataSet: boolean;
Var
  vDBEdit: TDBEdit;
  sIndexFna: string;
  sDBEdit: string;
  II: integer;
Begin
  Result := False;
  If DataSource2.DataSet = nil Then Begin
    DataSource2.DataSet := MainForm1.BufDataset_indedb;
    For II := 1 To 20 Do Begin
      sDBEdit := Format('DBEdit%d', [II]);
      sIndexFna := Format('Index%d', [II]);
      vDBEdit := FindComponent(sDBEdit) As TDBEdit;
      If vDBEdit <> nil Then Begin
        vDBEdit.DataSource := DataSource2;
        vDBEdit.DataField := sIndexFna;
      End;
    End;
  End;
  If DataSource2.DataSet <> nil Then Begin
    Result := True;
  End;
End;

Function Tchoice.SaveTo_HistoryDataSet: boolean;
Var
  serno: string;
Begin
  Result := True;
  If Not YesNo('將會覆蓋已選的記錄，確定嗎?') Then Exit;

  With MainForm1 Do Begin
    With BufDataset_indedb Do Begin
      If BufDataset_indedb.Modified Then Begin
        BufDataset_indedb.Post;
        BufDataset_indedb.SaveToFile(CdsTableFile_indedb);
      End;
    End;
    serno := Format('%d', [RadioGroup1.ItemIndex + 1]);
    With BufDataset_recordm Do Begin
      First;
      While Not EOF Do Begin
        If FieldByName('SERIESNO').AsString = serno Then
          Delete
        Else
          Next;
      End;
    End;
    BufDataset_Cus.First;
    While Not BufDataset_Cus.EOF Do Begin
      If BufDataset_Cus.FieldByName('Checkt').AsBoolean Then Begin
        BufDataset_recordm.Append;
        BufDataset_recordm.FieldByName('SERIESNO').AsString := serno;
        BufDataset_recordm.FieldByName('CUSNO').AsString := BufDataset_Cus.FieldByName('CUSNO').AsString;
        BufDataset_recordm.Post;
      End;
      BufDataset_Cus.Next;
    End;
    BufDataset_recordm.SaveToFile(CdsTableFile_RECORDM);
  End;
End;

Procedure Tchoice.LoadFrom_HistoryDataSet;
Var
  serno: string;
Begin
  serno := Format('%d', [RadioGroup1.ItemIndex + 1]);
  With MainForm1 Do Begin
    BufDataset_recordm.First;
    While Not BufDataset_recordm.EOF Do Begin
      If BufDataset_recordm.FieldByName('SERIESNO').AsString = serno Then Begin
        If BufDataset_Cus.Locate('CUSNO', BufDataset_recordm.FieldByName('CUSNO').AsString, []) Then Begin
          BufDataset_Cus.Edit;
          BufDataset_Cus.FieldByName('Checkt').AsBoolean := True;
          BufDataset_Cus.Post;
        End;
      End;
      BufDataset_recordm.Next;
    End;
  End;

End;


Procedure Tchoice.BitBtn_FindClick(Sender: TObject);
Begin
  With self.DBGrid1.DataSource.DataSet Do Begin
    If string(Edit_FindText.Text).IsEmpty Then Begin
      Panel_Search.Visible := False;
      DBGrid1.SetFocus;
      Exit;
    End;
    If RadioGroup2.ItemIndex = 0 Then  Begin
      If Not Locate('cusno', Trim(Edit_FindText.Text), [loCaseInsensitive]) Then
        ShowMessage('查無此客戶!');
    End Else Begin
      If Not Locate('Cusname', Trim(Edit_FindText.Text), [loCaseInsensitive]) Then
        ShowMessage('查無此客戶!!');
    End;
  End;
End;

Procedure Tchoice.BitBtn_ExitClick(Sender: TObject);
Begin
  Panel_Search.Visible := False;
  DBGrid1.SetFocus;
End;


Procedure Tchoice.DBGrid1DblClick(Sender: TObject);
Begin
  If DBGrid1.SelectedField = nil Then
    Exit;
  If UpperCase(DBGrid1.SelectedField.FieldName) <> 'CHECKT' Then
    Exit;

  DBGrid1.DataSource.DataSet.Edit;
  DBGrid1.SelectedField.AsBoolean := Not DBGrid1.SelectedField.AsBoolean;
  DBGrid1.DataSource.DataSet.Post;

End;


Procedure Tchoice.Edit_DestDriveEditingDone(Sender: TObject);
Var
  cNew, cShowNa: string;
  ActiveObj: TWinControl;
Begin
  ActiveObj := FindControl((Sender As TWinControl).Handle);
  cNew := (ActiveObj As TCustomEdit).Text;
  cShowNa := (ActiveObj As TCustomEdit).Name;
  If cNew.IsEmpty Then Exit;
  Case cShowNa Of
    'Edit_Year': Begin  // 作業年度:
      If (cNew >= '100') And (cNew <= '199') Then Begin
      End Else Begin
        (ActiveObj As TCustomEdit).Text := IntToStr(YearOf(Date) - 1911);
        ActiveObj.SetFocus;
      End;
    End;
    'Edit_DestDrive': Begin  // 備份至磁碟機
      If UpCase(Edit_DestDrive.Text[1]) In ['A'..'Z'] Then Begin
      End Else Begin
        (ActiveObj As TCustomEdit).Text := 'C';
        ActiveObj.SetFocus;
      End;
    End;
  End;
End;


Procedure Tchoice.DBGrid1KeyDown_(Sender: TObject; Var Key: word; Shift: TShiftState);
Begin
  Case Key Of
    VK_RETURN: Begin
      Key := 0;
      If Self.PageControl1.ActivePageIndex = 0 Then Begin
        If (Panel_Search.Visible) Then  Begin
          If (string(Edit_FindText.Text).IsEmpty) Then Begin
            Panel_Search.Visible := False;
            Self.DBGrid1.SetFocus;
          End Else Begin
            BitBtn_Find.Click;
          End;
        End;
      End;
    End;
    VK_Space: Begin
      Key := 0;
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_Space.Click;
    End;
    VK_F2: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F2.Click;
    End;
    VK_F3: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F3.Click;
    End;
    VK_F4: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F4.Click;
    End;
    VK_F5: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F5.Click;
    End;
    VK_F6: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F6.Click;
    End;
    VK_F11: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_F11.Click;
    End;
    VK_ESCAPE: Begin
      If Self.PageControl1.ActivePageIndex = 0 Then
        SpeedButton_Esc.Click
      Else If Self.PageControl1.ActivePageIndex = 2 Then
        SpeedButton_Page3_Esc.Click;
    End;
    VK_F8: Begin
      If Self.PageControl1.ActivePageIndex = 1 Then
        SpeedButton_Page2_F8.Click
      Else If Self.PageControl1.ActivePageIndex = 3 Then
        SpeedButton_Page4_F8.Click;
    End;
    VK_F9: Begin
      If Self.PageControl1.ActivePageIndex = 1 Then
        SpeedButton_Page2_F9.Click
      Else If Self.PageControl1.ActivePageIndex = 3 Then
        SpeedButton_Page4_F9.Click;
    End;
  End;
End;


End.
