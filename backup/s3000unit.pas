unit s3000unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, ExtCtrls, Dialogs,
  DB, dbf, unit1, mainback_uint, choiceunit, warningu;

type
  TS3000 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4, Label5, Label6, Label7, Label8, Label9, Label10, Label11,
    Label12, Label13, Label14, Label15, Label16: TLabel;
    Table1: TDbf;
    Table1DATADISK: TStringField;
    Table1OTHERDISK: TStringField;
    Table1COMPANY: TStringField;
    SpeedButton1, SpeedButton2, SpeedButton3, SpeedButton4, SpeedButton5,
    SpeedButton6, SpeedButton7, SpeedButton8, SpeedButton9, SpeedButton10,
    SpeedButton11, SpeedButton12, SpeedButton13, SpeedButton14, SpeedButton15,
    SpeedButton16, SpeedButton17, SpeedButton18, SpeedButton19, SpeedButton20,
    SpeedButton21, SpeedButton22, SpeedButton23: TSpeedButton;
    CheckBox_nimg: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
    procedure SpeedButton18Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure SpeedButton22Click(Sender: TObject);
    procedure SpeedButton23Click(Sender: TObject);
  private
  public
  end;

var
  S3000: TS3000;

implementation

{$R *.lfm}

procedure menucheck(enable: boolean);
begin
  Form1.N11.Enabled := enable;
  Form1.SpeedButton2.Enabled := enable;
  Form1.Panel1.Enabled := enable;
  // Form1.CoolBar1.Enabled := enable; // Not implemented in Lazarus yet
end;

procedure TS3000.FormCreate(Sender: TObject);
begin
  Form1.closeform := '3000';
  menucheck(false);
end;

procedure TS3000.FormKeyPress(Sender: TObject; var Key: char);
begin
  S3000.Enabled := True;
  if Key = #27 then
    Close;
end;

procedure TS3000.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  menucheck(true);
  CloseAction := caFree;
end;

procedure TS3000.FormShow(Sender: TObject);
begin
  Label3.Caption := Form1.netsource;
end;

procedure TS3000.SpeedButton15Click(Sender: TObject);
begin
  // Close button - return to main form
  S3000.Enabled := True;
  Close;
end;

procedure TS3000.SpeedButton1Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '備份視聽資料下載碎片';
  Form1.run_script := '3s1.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
  if CheckBox_nimg.Checked then
    Form1.bak_res_nimgbuy := '1'
  else
    Form1.bak_res_nimgbuy := '';
end;

procedure TS3000.SpeedButton2Click(Sender: TObject);
var
  WarningForm: TWarningF;
begin
  WarningForm := TWarningF.Create(Application);
  try
    if WarningForm.ShowModal <> mrOk then
      Exit;
  finally
    WarningForm.Free;
  end;

  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '回復視聽資料下載碎片';
  Form1.run_script := '3s1.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
  if CheckBox_nimg.Checked then
    Form1.bak_res_nimgbuy := '1'
  else
    Form1.bak_res_nimgbuy := '';
end;

procedure TS3000.SpeedButton3Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '備份總帳成本資料';
  Form1.run_script := '3s2.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton4Click(Sender: TObject);
var
  WarningForm: TWarningF;
begin
  WarningForm := TWarningF.Create(Application);
  try
    if WarningForm.ShowModal <> mrOk then
      Exit;
  finally
    WarningForm.Free;
  end;

  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '回復總帳成本資料';
  Form1.run_script := '3s2.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton5Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '備份養護資料';
  Form1.run_script := '3sa.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton6Click(Sender: TObject);
var
  WarningForm: TWarningF;
begin
  WarningForm := TWarningF.Create(Application);
  try
    if WarningForm.ShowModal <> mrOk then
      Exit;
  finally
    WarningForm.Free;
  end;

  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '回復養護資料';
  Form1.run_script := '3sa.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton7Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '備份視聽資料下載碎片';
  Form1.run_script := '3s3.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton8Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '回復視聽資料下載碎片';
  Form1.run_script := '3s3.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton9Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '備份帳務資料';
  Form1.run_script := '3s4.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton10Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '回復帳務資料';
  Form1.run_script := '3s4.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton11Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '備份營業稅資料';
  Form1.run_script := '3s5.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton12Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '回復營業稅資料';
  Form1.run_script := '3s5.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton13Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '備份薪資所得稅資料';
  Form1.run_script := '3s6.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton14Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '回復薪資所得稅資料';
  Form1.run_script := '3s6.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton16Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '備份薪資所得稅資料';
  Form1.run_script := '3ss.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton17Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '回復薪資所得稅資料';
  Form1.run_script := '3ss.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton18Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '備份薪資所得稅資料';
  Form1.run_script := '3ss.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton19Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '回復薪資所得稅資料';
  Form1.run_script := '3ss.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton20Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '備份薪資所得稅資料';
  Form1.run_script := '3ss.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton21Click(Sender: TObject);
begin
  if not mainback.get_customer(0) then
    Exit;
  choice.Label12.Caption := '回復薪資所得稅資料';
  Form1.run_script := '3ss.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton22Click(Sender: TObject);
begin
  if not mainback.get_customer(2) then
    Exit;
  choice.Label12.Caption := '備份薪資資料';
  Form1.run_script := '3salary.vbs';
  Form1.bak_res := 'bak';
  Form1.visyear := 'y';
end;

procedure TS3000.SpeedButton23Click(Sender: TObject);
begin
  if not mainback.get_customer(2) then
    Exit;
  choice.Label12.Caption := '回復薪資資料';
  Form1.run_script := '3salary.vbs';
  Form1.bak_res := 'res';
  Form1.visyear := 'y';
end;

end.
