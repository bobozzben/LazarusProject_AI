unit stubs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons, DBGrids,
  DB, Dialogs, FileUtil, Grids, StrUtils, LazFileUtils;

type
  TS5000f = class(TForm)
    ButtonClose: TButton;
    Label1: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
  private
    procedure SetSelection(const script, res, captionText: string);
  end;

  TfrmDelete = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function DeleteTree(const directory, DelYear: string): Integer;
  public
    netdatadisk: string;
  end;

var
  S5000f: TS5000f;
  frmDelete: TfrmDelete;

implementation

uses unit1, mainback_uint, choiceunit;

{$R *.lfm}

procedure TS5000f.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TS5000f.FormCreate(Sender: TObject);
begin
  Form1.closeform := '5000';
end;

procedure TS5000f.FormShow(Sender: TObject);
begin
  Label3.Caption := '來源: ' + Form1.netsource;
end;

procedure TS5000f.SetSelection(const script, res, captionText: string);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label1.Caption := captionText;
  Form1.run_script := script;
  Form1.bak_res := res;
  Form1.visyear := 'y';
end;

procedure TS5000f.SpeedButton1Click(Sender: TObject);
begin
  SetSelection('5s1.vbs', 'bak', '1. 備份資產資料');
end;

procedure TS5000f.SpeedButton2Click(Sender: TObject);
begin
  SetSelection('5s1.vbs', 'res', '2. 回置資產資料');
end;

procedure TS5000f.SpeedButton3Click(Sender: TObject);
begin
  SetSelection('5s2.vbs', 'bak', '3. 備份帳務資料');
end;

procedure TS5000f.SpeedButton4Click(Sender: TObject);
begin
  SetSelection('5s2.vbs', 'res', '4. 回置帳務資料');
end;

procedure TS5000f.SpeedButton5Click(Sender: TObject);
begin
  SetSelection('5s3.vbs', 'bak', '5. 備份其他資料');
end;

procedure TS5000f.SpeedButton6Click(Sender: TObject);
begin
  SetSelection('5s3.vbs', 'res', '6. 回置其他資料');
end;

procedure TS5000f.SpeedButton13Click(Sender: TObject);
begin
  SetSelection('3sa.vbs', 'bak', '13. 備份年度資料');
end;

procedure TS5000f.SpeedButton14Click(Sender: TObject);
begin
  SetSelection('3sa.vbs', 'res', '14. 回置年度資料');
end;

procedure TfrmDelete.FormCreate(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  DataSource1.DataSet := choice.Table1;
end;

procedure TfrmDelete.FormShow(Sender: TObject);
begin
  netdatadisk := Form1.netsource;
end;

procedure TfrmDelete.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Assigned(Column.Field) and (Column.Field.FieldName = 'Checkt') then
  begin
    if Column.Field.AsString = 'T' then
      DBGrid1.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, '✔')
    else
      DBGrid1.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, ' ');
  end
  else
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfrmDelete.DBGrid1DblClick(Sender: TObject);
begin
  if not Assigned(DBGrid1.SelectedField) then
    Exit;
  if DBGrid1.SelectedField.FieldName <> 'Checkt' then
    Exit;
  if not choice.Table1.Active then
    Exit;
  choice.Table1.Edit;
  if choice.Table1.FieldByName('Checkt').AsString = 'T' then
    choice.Table1.FieldByName('Checkt').AsString := 'F'
  else
    choice.Table1.FieldByName('Checkt').AsString := 'T';
  choice.Table1.Post;
end;

procedure TfrmDelete.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ' ' then
    DBGrid1DblClick(Sender);
end;

function TfrmDelete.DeleteTree(const directory, DelYear: string): Integer;
begin
  if not DirectoryExists(directory) then
    Exit(1);

  if DelYear = 'Y' then
  begin
    if not FileExists(IncludeTrailingPathDelimiter(directory) + 'hvoucher.dbf') and
       not FileExists(IncludeTrailingPathDelimiter(directory) + 'sou_mast.dbf') then
      Exit(2);
  end
  else
  begin
    if not FileExists(IncludeTrailingPathDelimiter(directory) + 'accparau.dbf') and
       not FileExists(IncludeTrailingPathDelimiter(directory) + 'sou_mast.dbf') then
      Exit(2);
  end;

  if DeleteDirectory(directory, True) then
    Result := 0
  else
    Result := 1;
end;

procedure TfrmDelete.BitBtn1Click(Sender: TObject);
var
  cusdirname: string;
  msg: string;
  xy: Integer;
begin
  if RadioButton1.Checked and (Trim(Edit1.Text) = '') then
  begin
    Edit1.SetFocus;
    ShowMessage('請輸入週期');
    Exit;
  end;

  if RadioButton2.Checked and (Trim(Edit2.Text) = '') then
  begin
    Edit2.SetFocus;
    ShowMessage('請輸入週期');
    Exit;
  end;

  if RadioButton1.Checked then
    xy := StrToIntDef(Trim(Edit1.Text), 0)
  else if RadioButton2.Checked then
    xy := StrToIntDef(Trim(Edit2.Text), 0)
  else
    xy := 0;

  if (RadioButton1.Checked or RadioButton2.Checked) and (xy <= 80) then
  begin
    ShowMessage('請輸入有效週期 (大於 80)');
    Exit;
  end;

  msg := '此操作會刪除選取客戶的資料，您確定要繼續嗎？';
  if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  choice.Table1.Filtered := False;
  choice.Table1.Filter := 'Checkt=''T''';
  choice.Table1.Filtered := True;
  choice.Table1.First;
  if choice.Table1.Eof then
  begin
    choice.Table1.Filtered := False;
    choice.Table1.Filter := '';
    ShowMessage('沒有選取要刪除的客戶。');
    Exit;
  end;

  if MessageDlg('是否再次確認刪除選取客戶資料？', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
  begin
    choice.Table1.Filtered := False;
    choice.Table1.Filter := '';
    Exit;
  end;

  while not choice.Table1.Eof do
  begin
    cusdirname := IncludeTrailingPathDelimiter(netdatadisk + ':') + 'w3000\data\' +
      Trim(choice.Table1.FieldByName('Cusno').AsString) + '\';

    if RadioButton1.Checked then
    begin
      xy := StrToIntDef(Trim(Edit1.Text), 0);
      while xy >= 80 do
      begin
        if xy >= 100 then
          cusdirname := IncludeTrailingPathDelimiter(netdatadisk + ':') + 'w3000\data\' +
            Trim(choice.Table1.FieldByName('Cusno').AsString) + '\' + RightStr(IntToStr(xy), 2) + '\'
        else
          cusdirname := IncludeTrailingPathDelimiter(netdatadisk + ':') + 'w3000\data\' +
            Trim(choice.Table1.FieldByName('Cusno').AsString) + '\' + IntToStr(xy) + '\';

        if DirectoryExists(cusdirname) then
          DeleteTree(cusdirname, 'Y');
        Dec(xy);
      end;
    end
    else if RadioButton2.Checked then
    begin
      if Trim(Edit2.Text) <> '' then
      begin
        xy := StrToIntDef(Trim(Edit2.Text), 0);
        if xy >= 100 then
          cusdirname := IncludeTrailingPathDelimiter(netdatadisk + ':') + 'w3000\data\' +
            Trim(choice.Table1.FieldByName('Cusno').AsString) + '\' + RightStr(IntToStr(xy), 2) + '\'
        else
          cusdirname := IncludeTrailingPathDelimiter(netdatadisk + ':') + 'w3000\data\' +
            Trim(choice.Table1.FieldByName('Cusno').AsString) + '\' + IntToStr(xy) + '\';
        if DirectoryExists(cusdirname) then
          DeleteTree(cusdirname, 'Y');
      end;
    end
    else if RadioButton3.Checked then
    begin
      cusdirname := IncludeTrailingPathDelimiter(netdatadisk + ':') + 'w3000\data\' +
        Trim(choice.Table1.FieldByName('Cusno').AsString) + '\';
      if DirectoryExists(cusdirname) then
        DeleteTree(cusdirname, 'N');
    end;

    choice.Table1.Next;
  end;

  choice.Table1.Filtered := False;
  choice.Table1.Filter := '';
  choice.Table1.First;
  ShowMessage('刪除作業完成。');
end;

procedure TfrmDelete.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.
