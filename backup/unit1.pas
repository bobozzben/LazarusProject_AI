unit unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Menus, Buttons, UITypes,
  Dialogs, Windows, FileUtil, db, dbf;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, W1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    Label4: TLabel;
    SpeedButton1, SpeedButton2, SpeedButton3, SpeedButton4,
      SpeedButton5, SpeedButton6, SpeedButton7: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure W1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
  private
    function GetTempPath: string;
    function GetTempFileName(const TempPath, FileExt, Prefix: string ): string;
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
  end;

var
  Form1: TForm1;

implementation

//uses floginunit, mainback_uint, stubs;


uses warningu, dropboxu, modipass_unit, unit2, noPictureback_uint, fragmentback_uint,frDelete,
     advunit, floginunit,  mainback_uint, s3000unit, s5000;
{$R *.lfm}

procedure TForm1.N1Click(Sender: TObject);
begin
  showForm_Mainback();
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  S3000 := TS3000.Create(Application);
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  advres := Tadvres.Create(Application);
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  S5000f := TS5000f.Create(Application);
  S5000f.Show;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  N1Click(Sender);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  N2Click(Sender);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  N3Click(Sender);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  N7Click(Sender);
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  FLogin := TFLogin.Create(Self);
  try
    FLogin.netsource := netsource;
    FLogin.DeleteData := 'Y';
    if FLogin.ShowModal = mrOk then
    begin
      frmDelete := TfrmDelete.Create(Self);
      try
        frmDelete.ShowModal;
      finally
        frmDelete.Free;
      end;
    end;
  finally
    FLogin.Free;
  end;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
  noPictureback := TnoPictureback.Create(Application);
  noPictureback.Show;
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
  fragmentPictureback := TfragmentPictureback.Create(Application);
  fragmentPictureback.Show;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  DropBoxForm := TDropBoxForm.Create(Self);
  try
    DropBoxForm.ShowModal;
  finally
    DropBoxForm.Free;
  end;
end;

procedure TForm1.N8Click(Sender: TObject);
begin
  ModiPassF := TModiPassF.Create(Self);
  try
    ModiPassF.NetSource := netsource;
    ModiPassF.ShowModal;
  finally
    ModiPassF.Free;
  end;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
  WarningF := TWarningF.Create(Self);
  try
    WarningF.ShowModal;
  finally
    WarningF.Free;
  end;
end;

procedure TForm1.N13Click(Sender: TObject);
begin
  FLogin := TFLogin.Create(Self);
  try
    FLogin.netsource := netsource;
    FLogin.DeleteData := 'N';
    if FLogin.ShowModal = mrOk then
    begin
      bak_res := 'bak';
      mainback := Tmainback.Create(Application);
    end;
  finally
    FLogin.Free;
  end;
end;

procedure TForm1.W1Click(Sender: TObject);
begin
  mail := Tmail.Create(Application);
  mail.Show;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  config: TDbf;
  xModalResult:TModalResult;
begin
  if not FileExists('config.dbf') then  begin
    ShowMessage('config.dbf 失落或無法開啟');
    Application.Terminate;
    Exit;
  end;

  config := TDbf.Create(Self);
  try
    config.FilePathFull := ExtractFilePath(Application.ExeName); // 年度兩碼
    config.TableName    := 'config.dbf';
    config.TableLevel := 30; // VFP          config.Open;
    config.open;
    if not config.EOF then
      netsource := config.FieldByName('DATADISK').AsString
    else
      netsource := '';
    config.Close;
  except
    ShowMessage('無法讀取 config.dbf');
    Application.Terminate;
    Exit;
  end;

  Caption := Caption + ' - 資料磁碟： ' + netsource;
  Application.CreateForm(TFLogin, FLogin);
  xModalResult :=FLogin.ShowModal;
  if xModalResult = mrOK Then Begin
     FreeAndNil(FLogin);
  End  Else Begin
    Application.Terminate;
    Exit;
  end;


  //run_script := ExtractFilePath(ParamStr(0)) + 'w307acc.vbs';
  //DropBoxPath := ExtractFilePath(ParamStr(0));
  //bak_res_nimgbuy := 'N';
  //BmpFile := DropBoxPath + 'res\奇勝-資.bmp';
  //if not FileExists(BmpFile) then
  //  BmpFile := DropBoxPath + 'res\奇勝-更.bmp';
  //if FileExists(BmpFile) then
  //  Image1.Picture.LoadFromFile(BmpFile);
 // if MessageDlg('請登入', mtConfirmation, [mbOK, mbCancel], 0) <> mrOk then
 //   Application.Terminate;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  alias_name3, chk_name1, sourceCust: string;
begin
  alias_name3 := netsource + ':\\w3000\\temp\\';
  chk_name1 := netsource + ':\\w3000\\COPYFIAL.CHK';
  sourceCust := netsource + ':\\w3000\\comm\\CUSTOMER.DBF';

  if not DirectoryExists(alias_name3) then
    CreateDir(alias_name3);

  tempcust := GetTempFileName(alias_name3, 'DBF', 'cx');
  tempcust2 := StringReplace(tempcust, '.DBF', '.CDX', [rfIgnoreCase]);

  if CopyFile(PChar(sourceCust), PChar(tempcust), False) then
  begin
    if FileExists(chk_name1) then
      ShowMessage('備份資料庫已鎖定');
  end;
end;

function TForm1.GetTempPath: string;
var
  TmpPath: array[0..MAX_PATH] of Char;
begin
  if Windows.GetTempPath(MAX_PATH, TmpPath) = 0 then
    Result := ''
  else
    Result := StrPas(TmpPath);
end;

function TForm1.GetTempFileName(const TempPath, FileExt, Prefix: string): string;
var
  TmpName: array[0..MAX_PATH] of Char;
  TempPath2: string;
begin
  TempPath2 := TempPath;
  if TempPath2 = '' then
    TempPath2 := GetTempPath;

  if Windows.GetTempFileName(PChar(TempPath2), PChar(Prefix), 0, TmpName) = 0 then
  begin
    Result := 'C:\\W3000\\TEMP\\xxx';
    Exit;
  end;

  if FileExt = '' then
    Result := ChangeFileExt(string(TmpName), '')
  else
    Result := ChangeFileExt(string(TmpName), '.' + FileExt);
end;

end.
