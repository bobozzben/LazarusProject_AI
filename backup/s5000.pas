unit s5000;

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

var
  S5000f: TS5000f;

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

end.
