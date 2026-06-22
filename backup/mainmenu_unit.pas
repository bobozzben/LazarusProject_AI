Unit MainMenu_unit;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Menus, Buttons, System.UITypes, IniFiles, LConvEncoding,
  Dialogs, paradoxds, FileUtil, DB, BufDataset, dbf, Windows, ShellAPI;

Type

  { TMainForm1 }

  TMainForm1 = Class(TForm)
    BufDataset_recordm: TBufDataset;
    BufDataset_indedb: TBufDataset;
    BufDataset_Cus: TBufDataset;
    MainMenu1: TMainMenu;
    N14: TMenuItem;
    N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, W1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    Label4: TLabel;
    SpeedButton1, SpeedButton2, SpeedButton3, SpeedButton4, SpeedButton5, SpeedButton6, SpeedButton7: TSpeedButton;
    Procedure FormCreate(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    Procedure N1Click(Sender: TObject);
    Procedure N2Click(Sender: TObject);
    Procedure N3Click(Sender: TObject);
    Procedure N5Click(Sender: TObject);
    Procedure N6Click(Sender: TObject);
    Procedure N7Click(Sender: TObject);
    Procedure N8Click(Sender: TObject);
    Procedure N12Click(Sender: TObject);
    Procedure N13Click(Sender: TObject);
    Procedure N14Click(Sender: TObject);
    Procedure W1Click(Sender: TObject);
    Procedure SpeedButton1Click(Sender: TObject);
    Procedure SpeedButton2Click(Sender: TObject);
    Procedure SpeedButton3Click(Sender: TObject);
    Procedure SpeedButton4Click(Sender: TObject);
    Procedure SpeedButton5Click(Sender: TObject);
    Procedure SpeedButton6Click(Sender: TObject);
    Procedure SpeedButton7Click(Sender: TObject);
  private
    Debug: boolean;
  public
    netsource: string;
    run_script: string;
    bak_res: string;
    labelcap: string;
    visyear: string;
    cussource: string;
    closeform: string;
    bak_res_nimgbuy: string;
    tempcust, tempwmccust, tempsalcompa: string;
    tempcust2, tempwmccust2, tempsalcompa2: string;
    localpath: string;
    DropBoxPath: string;
    succeed_CUS, succeed_INDEDB, succeed_RECORDM: boolean;
    CdsTableFile_RECORDM: string;
    CdsTableFile_Indedb: string;
    WorkForm:TForm;
  End;

Function Intital_Tables(wmc: integer): boolean;
Function myCreateTable_CUS(kind: integer; fieldno, fieldname, tablename: string): boolean;
Function myCreateTable_INDEDB(): boolean;
Function myCreateTable_RECORDM(): boolean;

Const
  hs_URL = 'http://www.hserp.tw/J25/index.php/gmailbackup';

Var
  MainForm1: TMainForm1;


Implementation

Uses dropboxu, modipass_unit, noPictureback_uint, fragmentback_uint, frDelete,
  floginunit, mainback_uint, s3000_unit, s5000_unit, ToolsFunction_unit;

  {$R *.lfm}


Procedure TMainForm1.FormCreate(Sender: TObject);
Var
  config: TDbf;
Begin
  Debug := DirectoryExists('C:\BenDebug.Txt');

  localpath := ExtractFilePath(Application.ExeName);

  If Not FileExists('config.dbf') Then  Begin
    ShowMessage('config.dbf 檔案不存在!');
    Application.Terminate;
    Exit;
  End;

  config := TDbf.Create(Self);
  Try
    config.FilePathFull := ExtractFilePath(Application.ExeName); // 年度兩碼
    config.TableName := 'config.dbf';
    config.TableLevel := 30; // VFP          config.Open;
    config.Open;
    If Not config.EOF Then
      netsource := config.FieldByName('DATADISK').AsString
    Else
      netsource := '';
    config.Close;
  Except
    ShowMessage('無法讀取 config.dbf');
    Application.Terminate;
    Exit;
  End;
  FreeAndNil(config);
  Caption := Caption + ' - 資料磁碟： ' + netsource;

End;

Procedure TMainForm1.FormShow(Sender: TObject);
Var
  alias_name, alias_comm, alias_temp, sourceCust, sourceCust2: string;
  alias_wmc, alias_salary: string;
  ini: TIniFile;
  xModalResult: TModalResult;
Begin
  // Login
  If mrOk <> showForm_FLogin(netsource, 'N') Then Begin
    Application.Terminate;
    Exit;
  End;
  // Initial Path ---------------------------------------------
  alias_name := netsource + ':\w3000\';
  alias_comm := netsource + ':\w3000\comm\';
  alias_temp := netsource + ':\w3000\temp\';
  ForceDirectories(alias_temp);
  // W3000 客戶檔---------------------------------------------------
  sourceCust := alias_Comm + 'CUSTOMER.DBF';
  sourceCust2 := alias_Comm + 'CUSTOMER.CDX';
  tempcust := GetTempFileName(alias_temp, 'DBF', 'cx');
  tempcust2 := StringReplace(tempcust, '.DBF', '.CDX', [rfIgnoreCase]);
  If CopyFile(PChar(sourceCust), PChar(tempcust), False) Then Begin
  End;
  If CopyFile(PChar(sourceCust2), PChar(tempcust2), False) Then Begin
  End;
  // 工商 客戶檔---------------------------------------------------
  alias_wmc := netsource + ':\w3000\wmc\comm\';
  sourceCust := alias_wmc + 'COMPB.DBF';
  sourceCust2 := alias_wmc + 'COMPB.CDX';
  ForceDirectories(alias_wmc + '\temp\');
  tempwmccust := GetTempFileName(alias_wmc + '\temp\', 'DBF', 'cx');
  tempwmccust2 := StringReplace(tempwmccust, '.DBF', '.CDX', [rfIgnoreCase]);
  If CopyFile(PChar(sourceCust), PChar(tempwmccust), False) Then Begin
  End;
  If CopyFile(PChar(sourceCust2), PChar(tempwmccust2), False) Then Begin
  End;
  // 二代健保薪資 客戶檔---------------------------------------------------
  alias_salary := netsource + ':\w3000\comm\';
  sourceCust := alias_salary + 'SALCOMPA.DBF';
  sourceCust2 := alias_salary + 'SALCOMPA.CDX';
  tempsalcompa := GetTempFileName(alias_temp, 'DBF', 'cx');
  tempsalcompa2 := StringReplace(tempsalcompa, '.DBF', '.CDX', [rfIgnoreCase]);
  If CopyFile(PChar(sourceCust), PChar(tempsalcompa), False) Then Begin
  End;
  If CopyFile(PChar(sourceCust2), PChar(tempsalcompa2), False) Then Begin
  End;
  //-----------------------------------------------------------------------
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  DropBoxPath := ini.ReadString('DropBox', 'Path', '');
  FreeAndNil(ini);
  // Open Table ----------------------------------------------
  CdsTableFile_RECORDM := IncludeTrailingPathDelimiter(MainForm1.localpath) + 'recordm.cds';
  CdsTableFile_Indedb := IncludeTrailingPathDelimiter(MainForm1.localpath) + 'indedb.cds';

  Intital_Tables(0);
End;

procedure TMainForm1.Label4Click(Sender: TObject);
Var
  II:Integer;
begin
  Caption := Format('%d',[Application.ComponentCount]);
  II:= Application.ComponentCount;
  //Menu := Nil;
  //Menu := MainMenu1;

end;

Procedure TMainForm1.N14Click(Sender: TObject);
Begin
  if WorkForm <> Nil Then Begin
    WorkForm.BringToFront;
    Exit;
  End;
  Panel2.Enabled := False;
  Image1.Visible := False;
  WorkForm := showForm_fragmentPictureback();
End;

Procedure TMainForm1.N1Click(Sender: TObject);
Begin
  if WorkForm <> Nil Then Begin
    WorkForm.BringToFront;
    Exit;
  End;
  Panel2.Enabled := False;
  Image1.Visible := False;
  WorkForm := showForm_Mainback();
End;

Procedure TMainForm1.N2Click(Sender: TObject);
Begin
  if WorkForm <> Nil Then Begin
    WorkForm.BringToFront;
    Exit;
  End;
  Panel2.Enabled := False;
  Image1.Visible := False;
  WorkForm := showForm_S3000();
End;

Procedure TMainForm1.N3Click(Sender: TObject);
Var
  myDir: string;
Begin
  myDir := netsource + ':\w3000\';
  ShellExecute(Self.Handle, 'open', pansichar(myDir), '', pansichar(myDir), SW_SHOW);
End;

Procedure TMainForm1.N6Click(Sender: TObject);
Begin
  Close;
End;

Procedure TMainForm1.N7Click(Sender: TObject);
Begin
  if WorkForm <> Nil Then Begin
    WorkForm.BringToFront;
    Exit;
  End;
  Panel2.Enabled := False;
  Image1.Visible := False;
  WorkForm := showForm_S5000();
End;

Procedure TMainForm1.SpeedButton1Click(Sender: TObject);
Begin
  N1Click(Sender);
End;

Procedure TMainForm1.SpeedButton2Click(Sender: TObject);
Begin
  N2Click(Sender);
End;

Procedure TMainForm1.SpeedButton3Click(Sender: TObject);
Begin
  N3Click(Sender);
End;

Procedure TMainForm1.SpeedButton4Click(Sender: TObject);
Begin
  N7Click(Sender);
End;

Procedure TMainForm1.SpeedButton5Click(Sender: TObject);
Begin
  if WorkForm <> Nil Then Begin
    WorkForm.BringToFront;
    Exit;
  End;
  If mrOk = showForm_FLogin(netsource, 'Y') Then Begin
    Panel2.Enabled := False;
    Image1.Visible := False;
    WorkForm := showForm_frmDelete(netsource);
  End;
End;

Procedure TMainForm1.SpeedButton6Click(Sender: TObject);
Begin
  N13Click(Sender);
End;

Procedure TMainForm1.SpeedButton7Click(Sender: TObject);
Begin
  N14Click(Sender);
End;

Procedure TMainForm1.N5Click(Sender: TObject);
Begin
  showForm_DropBoxForm;
End;

Procedure TMainForm1.N8Click(Sender: TObject);
Begin
  showForm_ModiPassF(Self.netsource);
End;

Procedure TMainForm1.N12Click(Sender: TObject);
Begin
  // 註冊教學
  ShellExecute(0, 'open', hs_URL, '', '', SW_SHOW);
End;

Procedure TMainForm1.N13Click(Sender: TObject);
Begin
  if WorkForm <> Nil Then Begin
    WorkForm.BringToFront;
    Exit;
  End;
  Panel2.Enabled := False;
  Image1.Visible := False;
  WorkForm := showForm_NoPictureback();
End;

Procedure TMainForm1.W1Click(Sender: TObject);
Var
  whan_name, whan_dd: string;
Begin
  //   函證備份(&W)  20260508
  whan_name := 'C:\A3000\WHAN\PGBACKUP.exe'; // 執行檔位置
  whan_dd := 'C:\A3000\WHAN\'; // 執行檔位置
  If (FileExists(whan_name)) Then Begin
    ShellExecute(Self.Handle, 'open', pansichar(whan_name), '', pansichar(whan_dd), SW_SHOW);
  End;
End;

Function Intital_Tables(wmc: integer): boolean;
Var
  fieldno, fieldname, tablename: string;
Begin
  // Determine which table and fields to use based on wmc parameter
  With MainForm1 Do Begin
    Case wmc Of
      1: Begin
        fieldno := 'CNO';
        fieldname := 'CNAME';
        tablename := MainForm1.tempwmccust;
      End;
      2: Begin
        fieldno := 'NO';
        fieldname := 'NAME';
        tablename := MainForm1.tempsalcompa;
      End;
      Else Begin
        fieldno := 'NO';
        fieldname := 'NAME';
        tablename := MainForm1.tempcust;
      End;
    End;
    Try
      succeed_CUS := myCreateTable_CUS(wmc, fieldno, fieldname, tablename);
      If Not succeed_INDEDB Then
        succeed_INDEDB := myCreateTable_INDEDB();
      If Not succeed_RECORDM Then
        succeed_RECORDM := myCreateTable_RECORDM();
      Result := True;
    Except
      On E: Exception Do Begin
        Result := False;
        ShowMessage('載入客戶資料錯誤! ' + E.Message);
      End;
    End;
  End;
End;


Function myCreateTable_CUS(kind: integer; fieldno, fieldname, tablename: string): boolean;
Var
  Dbf: TDbf;
Begin
  // 建立客戶選單
  With MainForm1 Do Begin
    With BufDataset_Cus Do Begin
      Close;
      FieldDefs.Clear;
      With FieldDefs.AddFieldDef Do Begin
        Name := 'CUSNO';
        DataType := ftString;
        Size := 8;
        Required := True;
      End;
      With FieldDefs.AddFieldDef Do Begin
        Name := 'CUSNAME';
        DataType := ftString;
        Size := 80;
      End;
      With FieldDefs.AddFieldDef Do Begin
        Name := 'CHECKT';
        DataType := ftBoolean;
        //Size := 1;
      End;
      IndexDefs.Clear;
      CreateDataSet;
      Open;
      IndexFieldNames := 'CUSNO';
      // Copy Data
      If FileExists(tablename) Then Begin
        Dbf := TDbf.Create(MainForm1);
        Try
          Dbf.FilePathFull := ExtractFilePath(tablename);
          Dbf.TableName := ExtractFilename(tablename);
          Dbf.TableLevel := 30; // VFP          config.Open;
          Dbf.Open;
          Dbf.First;
          While Not Dbf.EOF Do Begin
            If Not Locate('CUSNO', Dbf.FieldByName(fieldno).AsString, []) Then Begin
              Append;
              FieldByName('CUSNO').AsString := ConvertEncoding(Dbf.FieldByName(fieldno).AsString, 'cp950', 'utf8');
              FieldByName('CUSNAME').AsString := ConvertEncoding(Dbf.FieldByName(fieldname).AsString, 'cp950', 'utf8');
              FieldByName('CHECKT').AsBoolean := False;
              Post;
            End;
            Dbf.Next;
          End;
          Dbf.Close;
        Except
          On E: Exception Do Begin
            Result := False;
            ShowMessage('無法讀取客戶檔! ' + tablename + ' ' + E.Message);
            Application.Terminate;
            Exit;
          End;
        End;
        FreeAndNil(Dbf);
      End;
      First;
      Result := True;
    End;
    //myBrowse(BufDataset_CUS);
  End;
End;

Function myCreateTable_INDEDB(): boolean;
Var
  CdsTableFile, PxTableFile: string;
  ParadoxDataset1: TParadoxDataset;
  II: integer;
  FNa: string;
Begin
  WriteStrToFile_Debug('1 ' + MainForm1.CdsTableFile_indedb);
  CdsTableFile := MainForm1.CdsTableFile_indedb;
  PxTableFile := IncludeTrailingPathDelimiter(MainForm1.localpath) + 'indedb.db';
  With MainForm1 Do Begin
    With BufDataset_indedb Do Begin
      Close;
      If Not FileExists(CdsTableFile) Then  Begin
        WriteStrToFile_Debug('2 ' + CdsTableFile);
        FieldDefs.Clear;
        With FieldDefs.AddFieldDef Do Begin
          Name := 'RECORDNAME';
          DataType := ftString;
          Size := 12;
        End;
        For II := 1 To 20 Do Begin
          FNa := Format('INDEX%d', [II]);
          With FieldDefs.AddFieldDef Do Begin
            Name := FNa;
            DataType := ftString;
            Size := 12;
          End;
        End;
        CreateDataSet;
      End Else Begin
        WriteStrToFile_Debug('3 ' + CdsTableFile);
        BufDataset_indedb.LoadFromFile(CdsTableFile);
        //Open;
      End;
      If EOF Then Begin
        Append;
        Post;
      End;
      // Move Data 轉換後改名
      If FileExists(PxTableFile) Then Begin
        Try
          WriteStrToFile_Debug('4 ' + PxTableFile);
          ParadoxDataset1 := TParadoxDataset.Create(MainForm1);
          WriteStrToFile_Debug('4-1 ' + PxTableFile);
          ParadoxDataset1.TableName := PxTableFile;
          ParadoxDataset1.InputEncoding := 'CP950';
          ParadoxDataset1.TargetEncoding := 'UTF8';
          WriteStrToFile_Debug('4-2 ' + PxTableFile);
          ParadoxDataset1.Open;
          WriteStrToFile_Debug('4-3 ' + PxTableFile);
          ParadoxDataset1.First;
          WriteStrToFile_Debug('4-3-1 ' + PxTableFile);
          If ParadoxDataset1.RecordCount > 0 Then Begin
            WriteStrToFile_Debug('4-3-2 ' + PxTableFile);
            If BufDataset_indedb.RecordCount = 0 Then Begin
              WriteStrToFile_Debug('4-4 ' + PxTableFile);
              BufDataset_indedb.Append;
            End Else Begin
              WriteStrToFile_Debug('4-5 ' + PxTableFile);
              BufDataset_indedb.First;
              BufDataset_indedb.Edit;
            End;
            WriteStrToFile_Debug('5 ' + PxTableFile);
            BufDataset_indedb.FieldByName('RECORDNAME').AsString := ParadoxDataset1.FieldByName('RECORDNAME').AsString;
            For II := 1 To 20 Do Begin
              FNa := Format('INDEX%d', [II]);
              BufDataset_indedb.FieldByName(FNa).AsString := ParadoxDataset1.FieldByName(FNa).AsString;
            End;
            BufDataset_indedb.Post;
            //CopyDataSetByName(ParadoxDataset1, BufDataset_indedb);
            BufDataset_indedb.SaveToFile(CdsTableFile);
          End;
          WriteStrToFile_Debug('6 ' + PxTableFile);
          ParadoxDataset1.Close;
          FreeAndNil(ParadoxDataset1);
          If ReNameFile(PxTableFile, PxTableFile + '_') Then Begin
            // 更名成功
            WriteStrToFile_Debug('7 ' + PxTableFile);
          End;
        Except
          On E: Exception Do Begin
            Result := False;
            ShowMessage('無法讀取 INDEDB 檔! ' + E.Message);
            Exit;
          End;
        End;
      End;
      Result := True;
    End;
  End;
End;

Function myCreateTable_RECORDM(): boolean;
Var
  CdsTableFile, PxTableFile: string;
  ParadoxDataset1: TParadoxDataset;
Begin
  CdsTableFile := MainForm1.CdsTableFile_RECORDM;
  //CdsTableFile_RECORDM := IncludeTrailingPathDelimiter(MainForm1.localpath) + 'recordm.cds';
  PxTableFile := IncludeTrailingPathDelimiter(MainForm1.localpath) + 'recordm.db';
  With MainForm1 Do Begin
    With BufDataset_recordm Do Begin
      Close;
      If Not FileExists(CdsTableFile) Then  Begin
        FieldDefs.Clear;
        With FieldDefs.AddFieldDef Do Begin
          Name := 'SERIESNO';
          DataType := ftString;
          Size := 2;
        End;
        With FieldDefs.AddFieldDef Do Begin
          Name := 'CUSNO';
          DataType := ftString;
          Size := 8;
          Required := True;
        End;
        With FieldDefs.AddFieldDef Do Begin
          Name := 'RECORDNAME';
          DataType := ftString;
          Size := 12;
        End;
        CreateDataSet;
      End Else Begin
        BufDataset_recordm.LoadFromFile(CdsTableFile);
      End;
      // Move Data  轉換後改名
      If FileExists(PxTableFile) Then Begin
        Try
          ParadoxDataset1 := TParadoxDataset.Create(MainForm1);
          ParadoxDataset1.TableName := PxTableFile;
          ParadoxDataset1.InputEncoding := 'CP950';
          ParadoxDataset1.TargetEncoding := 'UTF8';
          ParadoxDataset1.Open;
          ParadoxDataset1.First;
          //myBrowse(ParadoxDataset1);
          If ParadoxDataset1.RecordCount > 0 Then Begin
            While Not ParadoxDataset1.EOF Do Begin
              BufDataset_recordm.Append;
              BufDataset_recordm.FieldByName('SERIESNO').AsString := ParadoxDataset1.FieldByName('SERIESNO').AsString;
              BufDataset_recordm.FieldByName('CUSNO').AsString := ParadoxDataset1.FieldByName('CUSNO').AsString;
              BufDataset_recordm.FieldByName('RECORDNAME').AsString := ParadoxDataset1.FieldByName('RECORDNAME').AsString;
              BufDataset_recordm.Post;
              ParadoxDataset1.Next;
            End;
            BufDataset_recordm.SaveToFile(CdsTableFile);
          End;
          ParadoxDataset1.Close;
          FreeAndNil(ParadoxDataset1);
          If ReNameFile(PxTableFile, PxTableFile + '_') Then Begin
            // 更名成功
          End;
        Except
          On E: Exception Do Begin
            Result := False;
            ShowMessage('無法讀取 RECORDM 檔! ' + E.Message);
            Exit;
          End;
        End;
      End;
      Result := True;
    End;
  End;
End;


End.
