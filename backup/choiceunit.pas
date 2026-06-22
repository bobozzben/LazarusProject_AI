unit choiceunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons, DBGrids,
  Grids, DB, dbf, Dialogs, Windows, DateUtils, Process, Graphics;

type

  { Tchoice }

  Tchoice = class(TForm)
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label_warnring: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    RadioGroup2: TRadioGroup;
    Table1: TDbf;
    Table1Checkt: TStringField;
    Table1Cusname: TStringField;
    Table1Cusno: TStringField;
    Table2: TDbf;
    Table3: TDbf;
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: char);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure Label14Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
  public
    serno: string;
    transpic: string;
    panelvalue: string;
    function CreateTable_CUS: boolean;
    function CreateTable_INDEDB: boolean;
    function CreateTable_RECORDM: boolean;
  end;

var
  choice: Tchoice;

implementation

uses MainMenu_unit, stateunit, s5000;

{$R *.lfm}

var
  pic1, pic3: TBitmap;

function Get_TempPath: string;
var
  TmpPath: array[0..MAX_PATH] of Char;
begin
  if Windows.GetTempPath(MAX_PATH, TmpPath) = 0 then
    Result := ''
  else
    Result := StrPas(TmpPath);
end;

procedure Tchoice.Label1Click(Sender: TObject);
var
  Bookmark: TBookmark;
begin
  // F1 - Select All (mark all rows as Checkt = 'T')
  if Table1.Active then
  begin
    Bookmark := Table1.GetBookmark;
    try
      Table1.First;
      while not Table1.Eof do
      begin
        Table1.Edit;
        Table1.FieldByName('Checkt').AsString := 'T';
        Table1.Post;
        Table1.Next;
      end;
    finally
      Table1.GotoBookmark(Bookmark);
      Table1.FreeBookmark(Bookmark);
    end;
  end;
end;

procedure Tchoice.Label2Click(Sender: TObject);
var
  Bookmark: TBookmark;
begin
  // F3 - Deselect All (mark all rows as Checkt = 'F')
  if Table1.Active then
  begin
    Bookmark := Table1.GetBookmark;
    try
      Table1.First;
      while not Table1.Eof do
      begin
        Table1.Edit;
        Table1.FieldByName('Checkt').AsString := 'F';
        Table1.Post;
        Table1.Next;
      end;
    finally
      Table1.GotoBookmark(Bookmark);
      Table1.FreeBookmark(Bookmark);
    end;
  end;
end;

procedure Tchoice.Label3Click(Sender: TObject);
begin
  Panel2.Visible := True;
  DBGrid1.Enabled := False;
  Label_warnring.Visible := False;
  if (Form1.run_script = '3s1.vbs') or (Form1.run_script = '3s2.vbs') then
    Label_warnring.Visible := True;

  Edit1.OnChange := nil;
  if Edit1.Text = '' then
    Edit1.Text := 'C';
  Edit1.OnChange := @Edit1Change;
  Edit1.SetFocus;
end;

procedure Tchoice.Label4Click(Sender: TObject);
begin
  // F6 - Import Records mode
  DBGrid1.Enabled := False;
  ShowMessage('導入記錄模式。請準備輸入檔案。');
end;

procedure Tchoice.Label5Click(Sender: TObject);
begin
  // F5 - Save Records (set save mode, show label with message)
  panelvalue := '1';  // Save mode
  ShowMessage('儲存客戶記錄模式。請確認要儲存的記錄。');
end;

function Tchoice.CreateTable_CUS: boolean;
var
  tableFile: string;
begin
  tableFile := IncludeTrailingPathDelimiter(Form1.localpath) + 'cus.db';
  Table1.Close;
  Table1.TableName := ExtractFileName(tableFile);
  Table1.FilePathFull := ExtractFilePath(tableFile);

  if not FileExists(tableFile) then
  begin
    Table1.FieldDefs.Clear;
    with Table1.FieldDefs.AddFieldDef do
    begin
      Name := 'CUSNO';
      DataType := ftString;
      Size := 8;
      Required := True;
    end;
    with Table1.FieldDefs.AddFieldDef do
    begin
      Name := 'CUSNAME';
      DataType := ftString;
      Size := 80;
    end;
    with Table1.FieldDefs.AddFieldDef do
    begin
      Name := 'CHECKT';
      DataType := ftString;
      Size := 1;
    end;
    Table1.IndexDefs.Clear;
    Table1.CreateTable;
  end;
  Table1.Open;
  Result := True;
end;

function Tchoice.CreateTable_INDEDB: boolean;
var
  tableFile: string;
begin
  tableFile := IncludeTrailingPathDelimiter(Form1.localpath) + 'indedb.db';
  Table2.Close;
  Table2.TableName := ExtractFileName(tableFile);
  Table2.FilePathFull := ExtractFilePath(tableFile);

  if not FileExists(tableFile) then
  begin
    Table2.FieldDefs.Clear;
    with Table2.FieldDefs.AddFieldDef do
    begin
      Name := 'RECORDNAME';
      DataType := ftString;
      Size := 12;
    end;
    while Table2.FieldDefs.Count < 21 do
      with Table2.FieldDefs.AddFieldDef do
      begin
        Name := 'INDEX' + IntToStr(Table2.FieldDefs.Count);
        DataType := ftString;
        Size := 12;
      end;
    Table2.CreateTable;
  end;
  Table2.Open;
  if Table2.EOF then
  begin
    Table2.Append;
    Table2.Post;
  end;
  Result := True;
end;

function Tchoice.CreateTable_RECORDM: boolean;
var
  tableFile: string;
begin
  tableFile := IncludeTrailingPathDelimiter(Form1.localpath) + 'recordm.db';
  Table3.Close;
  Table3.TableName := ExtractFileName(tableFile);
  Table3.FilePathFull := ExtractFilePath(tableFile);

  if not FileExists(tableFile) then
  begin
    Table3.FieldDefs.Clear;
    with Table3.FieldDefs.AddFieldDef do
    begin
      Name := 'SERIESNO';
      DataType := ftString;
      Size := 2;
    end;
    with Table3.FieldDefs.AddFieldDef do
    begin
      Name := 'CUSNO';
      DataType := ftString;
      Size := 8;
      Required := True;
    end;
    with Table3.FieldDefs.AddFieldDef do
    begin
      Name := 'RECORDNAME';
      DataType := ftString;
      Size := 12;
    end;
    Table3.CreateTable;
  end;
  Table3.Open;
  Result := True;
end;

procedure Tchoice.Button1Click(Sender: TObject);
begin
  ShowMessage('執行 W307ACC 模式尚未實作。');
end;

procedure Tchoice.Button3Click(Sender: TObject);
var
  selectedCount: Integer;
begin
  selectedCount := 0;
  if Table1.Active then
  begin
    Table1.DisableControls;
    Table1.First;
    while not Table1.Eof do
    begin
      if Table1.FieldByName('Checkt').AsString = 'T' then
        Inc(selectedCount);
      Table1.Next;
    end;
    Table1.EnableControls;
  end;

  ShowMessage('選擇客戶數量: ' + IntToStr(selectedCount) + '。');
  Panel2.Visible := False;
  DBGrid1.Enabled := True;
  DBGrid1.SetFocus;
end;

procedure Tchoice.Button4Click(Sender: TObject);
begin
  ShowMessage('COMM 模式執行尚未實作。');
  Panel2.Visible := False;
  DBGrid1.Enabled := True;
  DBGrid1.SetFocus;
end;

procedure Tchoice.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

procedure Tchoice.BitBtn4Click(Sender: TObject);
begin
  Close;
end;

procedure Tchoice.Button5Click(Sender: TObject);
begin
  Panel2.Visible := False;
  DBGrid1.Enabled := True;
  Edit2.Visible := False;
  Edit1.Visible := True;
  Label8.Caption := '請輸入選擇命令';
  Button1.Visible := False;
  Button3.Visible := False;
  Button4.Visible := False;
end;

procedure Tchoice.Button6Click(Sender: TObject);
begin
  Edit1Change(Edit1);
end;

procedure Tchoice.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  if Assigned(pic1) then
    pic1.Free;
  if Assigned(pic3) then
    pic3.Free;
end;

procedure Tchoice.FormCreate(Sender: TObject);
var
  ResPath, BmpFile: string;
begin
  ResPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'res';
  pic1 := TBitmap.Create;
  pic3 := TBitmap.Create;
  BmpFile := IncludeTrailingPathDelimiter(ResPath) + 'choice.bmp';
  if FileExists(BmpFile) then
    pic1.LoadFromFile(BmpFile);
  BmpFile := IncludeTrailingPathDelimiter(ResPath) + 'nochoice.bmp';
  if FileExists(BmpFile) then
    pic3.LoadFromFile(BmpFile);
end;

procedure Tchoice.DBGrid1DblClick(Sender: TObject);
begin
  if DBGrid1.SelectedField = nil then
    Exit;
  if DBGrid1.SelectedField.FieldName <> 'Checkt' then
    Exit;

  DBGrid1.DataSource.DataSet.Edit;
  if DBGrid1.SelectedField.AsString = 'T' then
    DBGrid1.SelectedField.AsString := 'F'
  else
    DBGrid1.SelectedField.AsString := 'T';
  DBGrid1.DataSource.DataSet.Post;
end;

procedure Tchoice.Label10Click(Sender: TObject);
begin
  Close;
end;

procedure Tchoice.Label13Click(Sender: TObject);
begin
  Panel3.Visible := True;
  Edit3.Text := '';
  Edit3.SetFocus;
end;

procedure Tchoice.Label14Click(Sender: TObject);
begin
  DBGrid1.SetFocus;
  keybd_event(Ord(' '), 0, 0, 0);
  keybd_event(Ord(' '), 0, KEYEVENTF_KEYUP, 0);
end;

procedure Tchoice.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then
  begin
    DBGrid1.Enabled := True;
    Panel2.Visible := False;
    DBGrid1.SetFocus;
    Exit;
  end;

  if Key = #13 then
  begin
    if Edit1.Text <> '' then
    begin
      if UpCase(Edit1.Text[1]) in ['A'..'Z'] then
        Button6.SetFocus;
    end;
    Exit;
  end;

  if UpCase(Key) in ['A'..'Z'] then
    Edit1Change(Sender);
end;

procedure Tchoice.Edit1Change(Sender: TObject);
var
  bYear: string;
begin
  if not ((Length(Edit1.Text) = 1) and (UpCase(Edit1.Text[1]) in ['A'..'Z'])) then
  begin
    Edit1.SetFocus;
    Exit;
  end;

  Edit1.Visible := False;
  Button6.Visible := False;

  if Form1.visyear = 'y' then
  begin
    Edit2.Visible := True;
    if Form1.run_script = '3mc.vbs' then
    begin
      if Form1.bak_res = 'res' then
        Label8.Caption := '     回置' + UpperCase(Edit1.Text) + ' 資料' + sLineBreak + '請輸入年度'
      else
        Label8.Caption := '     備份' + UpperCase(Edit1.Text) + ' 資料' + sLineBreak + '請輸入年度';
    end
    else
    begin
      if Form1.bak_res = 'res' then
        Label8.Caption := '     回置' + UpperCase(Edit1.Text) + ' 資料' + sLineBreak + '請輸入年度'
      else
        Label8.Caption := '     備份' + UpperCase(Edit1.Text) + ' 資料' + sLineBreak + '請輸入年度';
    end;

    bYear := FormatDateTime('yyyy', Date);
    if Length(bYear) >= 2 then
      Edit2.Text := Copy(bYear, Length(bYear) - 1, 2);
    Edit2.SetFocus;
  end
  else
  begin
    if Form1.bak_res = 'res' then
      Label8.Caption := '回置' + UpperCase(Edit1.Text) + '資料, 是否執行?'
    else
      Label8.Caption := '備份' + UpperCase(Edit1.Text) + '資料, 是否執行?';
    Edit2.Visible := False;
    Button3.Visible := True;
    Button3.SetFocus;
  end;
  Button3.Visible := True;
end;

procedure Tchoice.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    if Button3.Visible then
      Button3.SetFocus
    else if Button1.Visible then
      Button1.SetFocus;
  end;
end;

procedure Tchoice.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  x, y: Integer;
begin
  if Column.FieldName <> 'Checkt' then
  begin
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Exit;
  end;

  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  if (pic1 <> nil) and not pic1.Empty and (Column.Field.AsString = 'T') then
  begin
    x := Rect.Left + (Rect.Right - Rect.Left - pic1.Width) div 2;
    y := Rect.Top + (Rect.Bottom - Rect.Top - pic1.Height) div 2;
    DBGrid1.Canvas.Draw(x, y, pic1);
  end;
end;

procedure Tchoice.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F1: Label1Click(Sender);
    VK_F3: Label2Click(Sender);
    VK_F11: Label3Click(Sender);
    VK_F6: Label4Click(Sender);
    VK_F5: Label5Click(Sender);
    VK_F4: Label13Click(Sender);
  end;
end;

procedure Tchoice.DBGrid1KeyPress(Sender: TObject; var Key: char);
begin
  if Key = ' ' then
    DBGrid1DblClick(Sender)
  else if Key = #27 then
    Close;
end;

end.
