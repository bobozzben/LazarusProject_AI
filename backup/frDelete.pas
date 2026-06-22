Unit frDelete;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons, DBGrids, DateUtils, Windows,
  DB, Dialogs, FileUtil, Grids, MaskEdit, StrUtils, LazFileUtils;

Type

  { TfrmDelete }

  TfrmDelete = Class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Edit_YY1: TMaskEdit;
    Edit_YY2: TMaskEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Procedure BitBtn1Click(Sender: TObject);
    Procedure BitBtn2Click(Sender: TObject);
    Procedure DBGrid1DblClick(Sender: TObject);
    Procedure DBGrid1KeyPress(Sender: TObject; Var Key: char);
    Procedure Edit1EditingDone(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var CloseAction: TCloseAction);
    Procedure FormCreate(Sender: TObject);
    Procedure FormWindowStateChange(Sender: TObject);
  private
    Function DeleteTree(Const directory, DelYear: string): integer;
  public
    NetSource: string;
  End;

Function showForm_frmDelete(xNetSource: string): TForm;

Var
  frmDelete: TfrmDelete;

Implementation

Uses MainMenu_unit, ToolsFunction_unit;

  {$R *.lfm}

Function showForm_frmDelete(xNetSource: string): TForm;
Begin
  frmDelete := TfrmDelete.Create(Application);
  Result := frmDelete;
  With frmDelete Do Begin
    NetSource := xNetSource;
    Parent := MainForm1.Panel1;
    Align := alClient;
    //--------------------------
    BorderIcons := [biSystemMenu]; // [biSystemMenu,biMinimize];
    BorderStyle := bsNone; // bsToolWindow  bsSizeToolWin  bsSizeable  bsNone  bsDialog  bsSingle
    FormStyle := fsNormal; //fsMDIChild;
    KeyPreview := True;
    Show;
  End;
End;

Procedure TfrmDelete.FormCreate(Sender: TObject);
Begin
  If Not Intital_Tables(0) Then
    Exit;

  Edit_YY1.MaxLength := 3;  // 年度
  Edit_YY1.EditMask := '!900;1;_';
  Edit_YY1.Text := RightStr('0' + IntToStr(YearOf(Date()) - 1911), 3);
  Edit_YY2.MaxLength := 3;  // 年度
  Edit_YY2.EditMask := '!900;1;_';
  Edit_YY2.Text := RightStr('0' + IntToStr(YearOf(Date()) - 1911), 3);
  Edit_YY1.OnEditingDone := @Edit1EditingDone;
  Edit_YY2.OnEditingDone := @Edit1EditingDone;

  Self.DataSource1.DataSet := Mainform1.BufDataset_Cus;
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

Procedure TfrmDelete.FormWindowStateChange(Sender: TObject);
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

Procedure TfrmDelete.DBGrid1DblClick(Sender: TObject);
Begin
  If DBGrid1.SelectedField = nil Then
    Exit;
  If UpperCase(DBGrid1.SelectedField.FieldName) <> 'CHECKT' Then
    Exit;

  DBGrid1.DataSource.DataSet.Edit;
  DBGrid1.SelectedField.AsBoolean := Not DBGrid1.SelectedField.AsBoolean;
  DBGrid1.DataSource.DataSet.Post;
End;

Procedure TfrmDelete.DBGrid1KeyPress(Sender: TObject; Var Key: char);
Begin
  If Key = ' ' Then
    DBGrid1DblClick(Sender);
End;

Procedure TfrmDelete.Edit1EditingDone(Sender: TObject);
Var
  cNew, cShowNa: string;
  ActiveObj: TWinControl;
Begin
  ActiveObj := FindControl((Sender As TWinControl).Handle);
  cNew := (ActiveObj As TCustomEdit).Text;
  cShowNa := (ActiveObj As TCustomEdit).Name;
  If cNew.IsEmpty Then Exit;
  Case cShowNa Of
    'Edit_YY1', 'Edit_YY2': Begin  // 作業年度:
      If (cNew >= '100') And (cNew <= '199') Then Begin
      End Else Begin
        (ActiveObj As TCustomEdit).Text := IntToStr(YearOf(Date) - 1911);
        ActiveObj.SetFocus;
      End;
    End;
  End;
End;

Procedure TfrmDelete.FormClose(Sender: TObject; Var CloseAction: TCloseAction);
Begin
  CloseAction := caFree;
  MainForm1.Image1.Visible := True;
  MainForm1.Panel2.Enabled := True;
  MainForm1.WorkForm := nil;
End;

Function TfrmDelete.DeleteTree(Const directory, DelYear: string): integer;
Begin
  If Not DirectoryExists(directory) Then
    Exit(1);

  If DelYear = 'Y' Then Begin
    If Not FileExists(IncludeTrailingPathDelimiter(directory) + 'hvoucher.dbf') And Not FileExists(IncludeTrailingPathDelimiter(directory) + 'sou_mast.dbf') Then
      Exit(2);
  End Else Begin
    If Not FileExists(IncludeTrailingPathDelimiter(directory) + 'accparau.dbf') And Not FileExists(IncludeTrailingPathDelimiter(directory) + 'sou_mast.dbf') Then
      Exit(2);
  End;

  If DeleteDirectory(directory, False) Then
    Result := 0
  Else
    Result := 1;
End;

Procedure TfrmDelete.BitBtn1Click(Sender: TObject);
Var
  cusdirname: string;
  msg: string;
  xy, rCnt: integer;
Begin
  If Not (RadioButton1.Checked Or RadioButton2.Checked Or RadioButton3.Checked) Then Exit;

  If RadioButton1.Checked And (Trim(Edit_YY1.Text) = '') Then Begin
    Edit_YY1.SetFocus;
    ShowMessage('請輸入年度!');
    Exit;
  End;
  If RadioButton2.Checked And (Trim(Edit_YY2.Text) = '') Then Begin
    Edit_YY2.SetFocus;
    ShowMessage('請輸入年度!');
    Exit;
  End;

  If RadioButton1.Checked Then
    xy := StrToIntDef(Trim(Edit_YY1.Text), 0)
  Else If RadioButton2.Checked Then
    xy := StrToIntDef(Trim(Edit_YY2.Text), 0)
  Else
    xy := 0;

  If (RadioButton1.Checked Or RadioButton2.Checked) And (xy <= 80) Then  Begin
    ShowMessage('輸入的年度不正確 (大於 80)');
    Exit;
  End;
  If RadioButton1.Checked Then Begin
    msg := Format('您所選擇的客戶 %d (含)年度下以前之資料將會全部刪除,是否確定?', [xy]);
  End Else If RadioButton2.Checked Then Begin
    msg := Format('您所選擇的客戶 %d 年度資料將會全部刪除,是否確定?', [xy]);
  End Else Begin
    msg := '您所選擇的客戶所有資料將會全部刪除,是否確定?';
  End;
  If MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) <> mrYes Then
    Exit;

  With DBGrid1.DataSource.DataSet Do Begin
    rCnt := 0;
    First;
    While Not EOF Do Begin
      If FieldByName('Checkt').AsBoolean Then Inc(rCnt);
      Next;
    End;
    First;
    If rCnt = 0 Then  Begin
      ShowMessage('沒有選取要刪除的客戶。');
      Exit;
    End;
    If MessageDlg('是否再次確認刪除選取客戶資料？', mtConfirmation, [mbYes, mbNo], 0) <> mrYes Then  Begin
      Exit;
    End;
    While Not EOF Do Begin
      If Not FieldByName('Checkt').AsBoolean Then Begin
        Next;
        Continue;
      End;
      cusdirname := IncludeTrailingPathDelimiter(NetSource + ':') + 'w3000\data\' + Trim(FieldByName('Cusno').AsString) + '\';
      If RadioButton1.Checked Then Begin
        xy := StrToIntDef(Trim(Edit_YY1.Text), 0);
        While xy >= 80 Do Begin
          If xy >= 100 Then
            cusdirname := IncludeTrailingPathDelimiter(NetSource + ':') + 'w3000\data\' + Trim(FieldByName('Cusno').AsString) + '\' + RightStr(IntToStr(xy), 2) + '\'
          Else
            cusdirname := IncludeTrailingPathDelimiter(NetSource + ':') + 'w3000\data\' + Trim(FieldByName('Cusno').AsString) + '\' + IntToStr(xy) + '\';
          If DirectoryExists(cusdirname) Then
            DeleteTree(cusdirname, 'Y');
          Dec(xy);
        End;
      End Else If RadioButton2.Checked Then  Begin
        If Trim(Edit_YY2.Text) <> '' Then Begin
          xy := StrToIntDef(Trim(Edit_YY2.Text), 0);
          If xy >= 100 Then
            cusdirname := IncludeTrailingPathDelimiter(NetSource + ':') + 'w3000\data\' + Trim(FieldByName('Cusno').AsString) + '\' + RightStr(IntToStr(xy), 2) + '\'
          Else
            cusdirname := IncludeTrailingPathDelimiter(NetSource + ':') + 'w3000\data\' + Trim(FieldByName('Cusno').AsString) + '\' + IntToStr(xy) + '\';
          If DirectoryExists(cusdirname) Then
            DeleteTree(cusdirname, 'Y');
        End;
      End Else If RadioButton3.Checked Then  Begin
        cusdirname := IncludeTrailingPathDelimiter(NetSource + ':') + 'w3000\data\' + Trim(FieldByName('Cusno').AsString) + '\';
        If DirectoryExists(cusdirname) Then
          DeleteTree(cusdirname, 'N');
      End;
      Next;
    End;
    First;
    ShowMessage('刪除作業完成。');
  End;

End;

Procedure TfrmDelete.BitBtn2Click(Sender: TObject);
Begin // 離開
  PostMessage(self.Handle, WM_Close, 0, 0);
End;

End.
