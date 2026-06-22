Unit ToolsFunction_unit;

{$mode ObjFPC}{$H+}

Interface

Uses
  Windows, Classes, SysUtils, Forms, Controls, DB, BufDataSet, DBGrids,StdCtrls,LazUTF8,clipbrd;

Function GetTempPath: string;
Function GetTempFileName(Const TempPath, FileExt, Prefix: string): string;
Procedure ExecuteAndWait(Const aCommando: string);overload;
Procedure ExecuteAndWait(Const aCommando: string;Memo: TMemo); overload;
// 寫入字串到檔案
Procedure WriteStrToFile(WriteStr, FileName: string; ClearFile: boolean = False);
// 寫入字串到檔案 Debug 用
Procedure WriteStrToFile_Debug(WriteStr: string; FileName: string = 'C:\BENDEBUG.TXT\myLOG_wbackup.txt'; ClearFile: boolean = False);
// Browse 畫面
Procedure myBrowse(DataSet: TDataSet; Descrip: string = '');
// 移除暫存檔的 Required 屬性,要放在 CreateDataSet 之前
Procedure RemoveFieldRequired(CDS: TBufDataset);
// 拷貝單筆或全部資料到另一個資料集
Procedure CopyDataSetByName(SourDS: TDataSet; DestDS: TBufDataset; CopyOneRecord: boolean = False);

function Encrypts(const mepara: AnsiString): AnsiString;
function Decrypts(const mepara: AnsiString): AnsiString;


Function YesNo(Comment: String; DefBU: Boolean = False): Boolean;
Function YesNoCancel(Comment: String; DefButton: Integer = 2): Boolean;
Procedure myShowMessage(Comment: String; Title: String = '訊息');
Procedure Str2Clipboard(Const Str: String; iDelayMs: Integer);
Procedure myClipboard(str: String);

Implementation


Function GetTempPath: string;
Var
  TmpPath: Array[0..MAX_PATH] Of char;
Begin
  If Windows.GetTempPath(MAX_PATH, TmpPath) = 0 Then
    Result := ''
  Else
    Result := StrPas(TmpPath);
End;

Function GetTempFileName(Const TempPath, FileExt, Prefix: string): string;
Var
  TmpName: Array[0..MAX_PATH] Of char;
  TempPath2: string;
Begin
  TempPath2 := TempPath;
  If TempPath2 = '' Then
    TempPath2 := GetTempPath;
  If Windows.GetTempFileName(PChar(TempPath2), PChar(Prefix), 0, TmpName) = 0 Then Begin
    Result := 'C:\W3000\TEMP\xxx';
    Exit;
  End;
  If FileExt = '' Then
    Result := ChangeFileExt(string(TmpName), '')
  Else
    Result := ChangeFileExt(string(TmpName), '.' + FileExt);
End;

Procedure WriteStrToFile(WriteStr, FileName: string; ClearFile: boolean = False);
// 寫入字串到檔案
Var
  SL: TStringList;
Begin
  SL := TStringList.Create;
  If FileExists(FileName) Then Begin
    SL.LoadFromFile(FileName);
    If ClearFile Then SL.Clear;
  End;
  SL.Add(WriteStr);
  SL.DefaultEncoding := TEncoding.UTF8;
  SL.SaveToFile(FileName);
  FreeAndNil(SL);
End;

Procedure WriteStrToFile_Debug(WriteStr: string; FileName: string = 'C:\BENDEBUG.TXT\myLOG_wbackup.txt'; ClearFile: boolean = False);
// 寫入字串到檔案 Debug 用
Var
  NowStr: string;
Begin
  If (DirectoryExists('C:\BENDEBUG.TXT')) Or
    (FileExists(ExtractFilePath(Application.ExeName) + 'DEBUG.TXT')) Then Begin
    If FileExists(ExtractFilePath(Application.ExeName) + 'DEBUG.TXT') Then // 客戶端的除錯
      FileName := ExtractFilePath(Application.ExeName) + 'DEBUG.Log';

    NowStr := FormatDateTime('yyyy/mm/dd hh:nn:ss.zzz', Now);
    WriteStrToFile(NowStr + ' ' + WriteStr, FileName, ClearFile);
  End;
End;


Procedure ExecuteAndWait(Const aCommando: string);overload;
Var
  tmpStartupInfo: TStartupInfo;
  tmpProcessInformation: TProcessInformation;
  tmpProgram: string;
Begin
  tmpProgram := trim(aCommando);
  FillChar(tmpStartupInfo, SizeOf(tmpStartupInfo), 0);
  With tmpStartupInfo Do Begin
    cb := SizeOf(TStartupInfo);
    wShowWindow := SW_HIDE;
  End;
  If CreateProcess(nil, PChar(tmpProgram), nil, nil, True, CREATE_NO_WINDOW, nil, nil, tmpStartupInfo, tmpProcessInformation) Then Begin
    // loop every 10 ms
    While WaitForSingleObject(tmpProcessInformation.hProcess, 15) > 0 Do Begin
      Application.ProcessMessages;
    End;
    CloseHandle(tmpProcessInformation.hProcess);
    CloseHandle(tmpProcessInformation.hThread);
  End Else Begin
    RaiseLastOSError;
  End;
End;



Procedure ExecuteAndWait(Const aCommando: string;Memo: TMemo); overload;
  var
    SI: TStartupInfo;
    PI: TProcessInformation;
    SA: TSecurityAttributes;
    hRead, hWrite: THandle;
    Buffer: array[0..1023] of Char;
    BytesRead: DWORD;
    tmpProgram: string;
  begin
    // 建立可繼承的管道
    SA.nLength := SizeOf(SA);
    SA.bInheritHandle := TRUE;
    SA.lpSecurityDescriptor := nil;
    if not CreatePipe(hRead, hWrite, @SA, 0) then Exit;

    tmpProgram := trim(aCommando);

    FillChar(SI, SizeOf(SI), 0);
    SI.cb := SizeOf(SI);
    SI.dwFlags := STARTF_USESTDHANDLES;
    SI.hStdOutput := hWrite;
    SI.hStdError := hWrite;
    //SI.wShowWindow := SW_HIDE;
    //If CreateProcess(nil, PAnsiChar(tmpProgram), nil, nil, True, CREATE_NO_WINDOW, nil, nil, tmpStartupInfo, tmpProcessInformation) Then Begin
    if CreateProcess(nil, PAnsiChar(tmpProgram),nil, nil, TRUE, 0, nil, nil, SI, PI) then begin
      CloseHandle(hWrite); // 主程式只讀取，不寫入
      while ReadFile(hRead, Buffer, SizeOf(Buffer)-1, BytesRead, nil) and (BytesRead > 0) do begin
        Buffer[BytesRead] := #0;
        WriteStrToFile_Debug(Format('%s' ,[ConsoleToUTF8(PAnsiChar(@Buffer[0]))] ));
        Memo.Lines.Add(ConsoleToUTF8(PAnsiChar(Buffer)));
      end;
      WaitForSingleObject(PI.hProcess, INFINITE);
      CloseHandle(PI.hProcess);
      CloseHandle(PI.hThread);
    end;
    CloseHandle(hRead);
  end;


// Browse 畫面
Procedure myBrowse(DataSet: TDataSet; Descrip: string = '');

  Procedure CopyDataSet(SourDS: TDataSet; DestDS: TBufDataset);
  Var
    ii, jj: integer;
  Begin
    DestDS.FieldDefs.Clear;
    DestDS.FieldDefs.Assign(SourDS.FieldDefs);
    For II := 0 To DestDS.FieldDefs.Count - 1 Do Begin
      If (DestDS.FieldDefs[ii].Required = True) Then DestDS.FieldDefs[ii].Required := False;
    End;
    DestDS.CreateDataSet;
    SourDS.First;
    While Not SourDS.EOF Do Begin
      DestDS.Append;
      For jj := 0 To SourDS.FieldCount - 1 Do DestDS.Fields[jj].Value := SourDS.Fields[jj].Value;
      DestDS.Post;
      SourDS.Next;
    End;
  End;

Var {Uses DBGrids}
  Form: TForm;
  DBGRID: TDBGRID;
  DS: TDataSource;
  ClientDataSet: TBufDataset;
  IsUniDirectionalDataSet: boolean;
  II: integer;
Begin
  IsUniDirectionalDataSet := False;
  If DataSet.IsUniDirectional Then Begin
    IsUniDirectionalDataSet := True;
    ClientDataSet := TBufDataset.Create(nil);
    CopyDataSet(DataSet, ClientDataSet);
  End;

  Form := TForm.Create(nil);
  DS := TDataSource.Create(Form);

  If IsUniDirectionalDataSet Then DS.DataSet := ClientDataSet
  Else
    DS.DataSet := DataSet;

  DBGRID := TDBGrid.Create(Form);
  DBGRID.Parent := Form;
  DBGRID.DataSource := DS;
  DBGRID.Align := alClient;
  DBGRID.Visible := True;
  DBGRID.ReadOnly := True;
  DBGRID.AutoAdjustColumns;  // 寬度自動調整大小   20250724
  //DBGRID.AutoFillColumns := False;  // 寬度自動填滿視窗 20250724
  For II := 0 To DS.DataSet.FieldCount - 1 Do Begin // 20241014
    If DS.DataSet.Fields[II] Is TNumericField Then Begin
      (DS.DataSet.Fields[II] As TNumericField).DisplayFormat := '#,###.####';
      If DS.DataSet.Fields[II].DisplayWidth <= 10 Then DS.DataSet.Fields[II].DisplayWidth := DS.DataSet.Fields[II].DisplayWidth + 5;
    End;
    If DS.DataSet.Fields[II].DisplayWidth > 40 Then DS.DataSet.Fields[II].DisplayWidth := 40;
  End;
  //if XLoginPara <> Nil then Begin
  //  DBGRID.TitleButtons := True;
  //  DBGRID.OnTitleButtonClick := LoginPara.mywwDBGrid1TitleButtonClick;
  //End;
  Form.Caption := '瀏覽 筆數： ' + IntToStr(DS.DataSet.RecordCount) + '  [' + Descrip + ']';
  Form.Height := 768;
  Form.Width := Screen.Width - 200;
  Form.Position := poScreenCenter;
  Form.WindowState := wsNormal;
  Form.ShowModal;
  FreeAndNil(DBGrid);
  FreeAndNil(DS);
  FreeAndNil(Form);
  If IsUniDirectionalDataSet Then FreeAndNil(ClientDataSet);
End;


Procedure RemoveFieldRequired(CDS: TBufDataset);
Var
  K: integer;
Begin // 要放在 CreateDataSet 之前
  For K := 0 To CDS.FieldDefs.Count - 1 Do Begin
    If (CDS.FieldDefs[K].Required = True) Then CDS.FieldDefs[K].Required := False;
  End;
End;

// 拷貝單筆或全部資料到另一個資料集
Procedure CopyDataSetByName(SourDS: TDataSet; DestDS: TBufDataset; CopyOneRecord: boolean = False);

  Procedure myCopyFromDataset(DataSet: TDataSet; CopyData: boolean);
  Const
    UseStreams = ftBlobTypes;
  Var
    I: integer;
    F, F1, F2: TField;
    L1, L2: TList;
    N: string;
    OriginalPosition: TBookMark;
    S: TMemoryStream;
  Begin
    With DestDS Do Begin
      Close;
      Fields.Clear;
      FieldDefs.Clear;
      For I := 0 To Dataset.FieldCount - 1 Do Begin
        F := Dataset.Fields[I];
        TFieldDef.Create(FieldDefs, F.FieldName, F.DataType, F.Size, False, F.FieldNo);
      End;
      CreateDataset;
      L1 := nil;
      L2 := nil;
      S := nil;
      If CopyData Then
      Try
        L1 := TList.Create;
        L2 := TList.Create;
        Open;
        For I := 0 To FieldDefs.Count - 1 Do Begin
          N := FieldDefs[I].Name;
          F1 := FieldByName(N);
          F2 := DataSet.FieldByName(N);
          L1.Add(F1);
          L2.Add(F2);
          If (FieldDefs[I].DataType In UseStreams) And (S = nil) Then S := TMemoryStream.Create;
        End;
        DisableControls;
        Dataset.DisableControls;
        OriginalPosition := Dataset.GetBookmark;
        Try
          Dataset.Open;
          Dataset.First;
          While Not Dataset.EOF Do Begin
            Append;
            For I := 0 To L1.Count - 1 Do Begin
              F1 := TField(L1[i]);
              F2 := TField(L2[I]);
              If Not F2.IsNull Then Case F1.DataType Of
                  ftFixedChar,
                  ftString: F1.AsString := F2.AsString;
                  ftFixedWideChar,
                  ftWideString: F1.AsWideString := F2.AsWideString;
                  ftBoolean: F1.AsBoolean := F2.AsBoolean;
                  ftFloat: F1.AsFloat := F2.AsFloat;
                  ftAutoInc,
                  ftSmallInt,
                  ftInteger: F1.AsInteger := F2.AsInteger;
                  ftLargeInt: F1.AsLargeInt := F2.AsLargeInt;
                  ftDate: F1.AsDateTime := F2.AsDateTime;
                  ftTime: F1.AsDateTime := F2.AsDateTime;
                  ftTimestamp,
                  ftDateTime: F1.AsDateTime := F2.AsDateTime;
                  ftCurrency: F1.AsCurrency := F2.AsCurrency;
                  ftBCD,
                  ftFmtBCD: F1.AsBCD := F2.AsBCD;
                  Else
                    If (F1.DataType In UseStreams) Then Begin
                      S.Clear;
                      TBlobField(F2).SaveToStream(S);
                      S.Position := 0;
                      TBlobField(F1).LoadFromStream(S);
                    End Else
                      F1.AsString := F2.AsString;
                End;
            End;
            Try
              Post;
            Except
              Cancel;
              Raise;
            End;
            Dataset.Next;
          End;
        Finally
          DataSet.GotoBookmark(OriginalPosition); //Return to original record
          Dataset.EnableControls;
          EnableControls;
        End;
      Finally
        L2.Free;
        l1.Free;
        S.Free;
      End;
    End;
  End;

Var
  jj, Cnt: integer;
  DL: TStringList;
  fa: string;
  xIndexDefs: TIndexDefs;
  xIndexName: string;
  iNa, fNa: string;
Begin
  If (Not CopyOneRecord) And (DestDS Is TBufDataset) Then Begin
    //拷貝全部
    If (DestDS.FieldDefs.Count = 0) Then Begin
      TBufDataset(DestDS).MergeChangeLog;
      //修改紀錄 會影響排序 所以copy前先清空
      myCopyFromDataset(TDataset(SourDS), True);
      exit;
    End Else Begin
      If DestDS.Active And (DestDS.RecordCount = 0)
      {and (DestDS..FieldDefList.CommaText = TBufDataset(SourDS).FieldDefList.CommaText) } Then Begin
        xIndexName := DestDS.IndexName;
        xIndexDefs := nil;
        If (DestDS.IndexDefs <> nil) Then Begin
          xIndexDefs := TIndexDefs.Create(nil);
          xIndexDefs.Assign(DestDS.IndexDefs);
        End;
        DestDS.Close;
        DestDS.IndexName := '';
        DestDS.IndexDefs.Clear;
        DestDS.FieldDefs.Clear;
        myCopyFromDataset(TDataset(SourDS), True);
        If (xIndexDefs <> nil) Then Begin
          For JJ := 0 To xIndexDefs.Count - 1 Do Begin
            iNa := xIndexDefs.Items[JJ].Name;
            fNa := xIndexDefs.Items[JJ].Fields;
            If fNa = '' Then Continue;
            DestDS.AddIndex(iNa, fNa, []);
          End;
          //DestDS.IndexDefs.Assign(xIndexDefs);
          FreeAndNil(xIndexDefs);
        End;
        TBufDataset(DestDS).IndexName := xIndexName;
        TBufDataset(DestDS).IndexDefs.Update;
        exit;
      End;
    End;
  End;
  If DestDS.FieldDefs.Count = 0 Then Begin
    DestDS.FieldDefs.Clear;
    DestDS.FieldDefs.Assign(SourDS.FieldDefs);
    RemoveFieldRequired(DestDS);
    DestDS.CreateDataSet;
  End;
  If CopyOneRecord Then Begin
    DestDS.Append;
    For jj := 0 To SourDS.FieldCount - 1 Do Begin
      If SourDS.Fields[jj].IsNull Then Begin
      End Else Begin
        If DestDS.FindField(SourDS.Fields[jj].FieldName) <> nil Then DestDS.FieldByName(SourDS.Fields[jj].FieldName).Value :=
            SourDS.Fields[jj].Value;
      End;
    End;
    DestDS.Post;
  End Else Begin
    DL := TStringList.Create;
    For JJ := 0 To DestDS.FieldCount - 1 Do Begin
      If DL.IndexOf(DestDS.Fields[jj].FieldName) = -1 Then DL.Add(DestDS.Fields[jj].FieldName);
    End;
    Cnt := SourDS.FieldCount;
    SourDS.First;
    While Not SourDS.EOF Do Begin
      DestDS.Append;
      For jj := 0 To Cnt - 1 Do Begin
        fa := SourDS.Fields[jj].FieldName;
        If SourDS.Fields[jj].IsNull Then Begin
        End Else Begin
          If DL.IndexOf(fa) >= 0 Then DestDS.FieldByName(fa).Value := SourDS.Fields[jj].Value;
        End;
      End;
      DestDS.Post;
      SourDS.Next;
    End;
    FreeAndNil(DL);
  End;
End;

function Encrypts(const mepara: AnsiString): AnsiString;
var
  mei, mej, mee: Integer;
  xx, jj: Word;
  medone: AnsiString;
  bbb: Integer;
begin
  mee := Length(mepara);
  medone := '';
  for mei := 1 to mee do
  begin
    if (mei >= 1) and (mei <= 10) then
      mej := mei
    else if (mei >= 11) and (mei <= 20) then
      mej := 10 - mei
    else if (mei >= 21) and (mei <= 30) then
      mej := mei - 20
    else if (mei >= 31) and (mei <= 40) then
      mej := 30 - mei
    else if (mei >= 41) and (mei <= 50) then
      mej := mei - 40
    else if (mei >= 51) and (mei <= 60) then
      mej := 50 - mei
    else if (mei >= 61) and (mei <= 70) then
      mej := mei - 60
    else if (mei >= 71) and (mei <= 80) then
      mej := 70 - mei
    else if (mei >= 81) and (mei <= 90) then
      mej := mei - 80
    else if (mei >= 91) and (mei <= 100) then
      mej := 90 - mei;

    bbb := Ord(mepara[mei]) + mej;

    if bbb < 0 then
      bbb := 256 + bbb
    else if bbb > 255 then
    begin
      xx := bbb div 255;
      jj := bbb mod 255;
      bbb := jj;
    end;

    medone := medone + Chr(bbb);
  end;
  Result := medone;
end;

function Decrypts(const mepara: AnsiString): AnsiString;
var
  mei, mej, mee: Integer;
  xx, jj: Word;
  medone: AnsiString;
  bbb: Integer;
begin
  mee := Length(mepara);
  medone := '';
  for mei := 1 to mee do
  begin
    if (mei >= 1) and (mei <= 10) then
      mej := mei
    else if (mei >= 11) and (mei <= 20) then
      mej := 10 - mei
    else if (mei >= 21) and (mei <= 30) then
      mej := mei - 20
    else if (mei >= 31) and (mei <= 40) then
      mej := 30 - mei
    else if (mei >= 41) and (mei <= 50) then
      mej := mei - 40
    else if (mei >= 51) and (mei <= 60) then
      mej := 50 - mei
    else if (mei >= 61) and (mei <= 70) then
      mej := mei - 60
    else if (mei >= 71) and (mei <= 80) then
      mej := 70 - mei
    else if (mei >= 81) and (mei <= 90) then
      mej := mei - 80
    else if (mei >= 91) and (mei <= 100) then
      mej := 90 - mei;

    bbb := Ord(mepara[mei]) - mej;

    if bbb < 0 then
      bbb := 256 + bbb
    else if bbb > 255 then
    begin
      xx := bbb div 255;
      jj := bbb mod 255;
      bbb := jj;
    end;

    medone := medone + Chr(bbb);
  end;
  Result := medone;
end;

Function YesNo(Comment: String; DefBU: Boolean = False): Boolean;
Begin
  If DefBU Then Begin
    Result := Application.MessageBox(PChar(Comment + '?'), '',
      MB_ICONQUESTION Or MB_YESNO) = idYes;
  End Else Begin
    Result := Application.MessageBox(PChar(Comment + '?'), '',
      MB_ICONQUESTION Or MB_YESNO Or MB_DEFBUTTON2) = idYes;
  End;
End;

Function YesNoCancel(Comment: String; DefButton: Integer = 2): Boolean;
Var
  myFlag: Longint;
Begin
  Case DefButton Of
    1: myFlag := MB_DEFBUTTON1;
    2: myFlag := MB_DEFBUTTON2;
    3: myFlag := MB_DEFBUTTON3;
  End;
  Result := Application.MessageBox(PChar(Comment + '?'), '',
    MB_ICONQUESTION Or MB_YESNOCANCEL Or myFlag) = idYes;
End;

Procedure myShowMessage(Comment: String; Title: String = '訊息');
Begin
  Application.MessageBox(Pansichar(Comment + '!'), Pansichar(Title),
    MB_ICONInformation Or MB_OK);
End;

Procedure Str2Clipboard(Const Str: String; iDelayMs: Integer);
Const
  MaxRetries = 5;
Var
  RetryCount: Integer;
Begin
  For RetryCount := 1 To MaxRetries Do Begin
    Try
      //inc(RetryCount);
      Clipboard.AsText := Str;
      Break;
    Except
      On Exception Do If RetryCount = MaxRetries Then Raise Exception.Create('Cannot set clipboard')
        Else
          Sleep(iDelayMs)
    End;
  End;
End;

Procedure myClipboard(str: String);
Begin
  //Debug 時候才會出現
  If DirectoryExists('C:\BENDEBUG.TXT') Then Begin
    //If FileExists('C:\cc.txt') Then
    Str2Clipboard(Str, 1500);
  End;
End;


End.
