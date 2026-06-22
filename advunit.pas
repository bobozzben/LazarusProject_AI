unit advunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, ExtCtrls, FileCtrl,
  Dialogs, FileUtil;

type

  { Tadvres }

  Tadvres = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    FileListBox1: TFileListBox;
    Label1: TLabel;
    Image2: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Label2: TLabel;
    SpeedButton5: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
  public
  end;

var
  advres: Tadvres;

implementation

{$R *.lfm}

procedure Tadvres.FormCreate(Sender: TObject);
var
  ResPath, BmpFile: string;
begin
  ResPath := ExtractFilePath(ParamStr(0)) + 'res\';
  FileListBox1.Directory := ExtractFilePath(ParamStr(0));
  Label1.Caption := '目錄: ' + FileListBox1.Directory;
  
  { Load decoration image if available }
  BmpFile := ResPath + 'pl1.bmp';
  if FileExists(BmpFile) then
    Image1.Picture.LoadFromFile(BmpFile);

  { Load clickable image icon }
  BmpFile := ResPath + 'nochoice.bmp';
  if not FileExists(BmpFile) then
    BmpFile := ResPath + 'choice.bmp';
  if not FileExists(BmpFile) then
    BmpFile := ResPath + 'choice1.bmp';
  if FileExists(BmpFile) then
    Image2.Picture.LoadFromFile(BmpFile);
end;

procedure Tadvres.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  pname: string;
begin
  pname := ExtractFilePath(ParamStr(0));
  //DirectoryListBox1.Directory := pname;
  // Enable menu items
  CloseAction := caFree;
end;

procedure Tadvres.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then
    Close;
end;

procedure Tadvres.Image2Click(Sender: TObject);
begin
  Close;
end;

procedure Tadvres.SpeedButton1Click(Sender: TObject);
begin
  FileListBox1.Mask := '*.*';
  Label2.Caption := '*.*(所有檔案)';
end;

procedure Tadvres.SpeedButton2Click(Sender: TObject);
begin
  FileListBox1.Directory := 'C:\';
  Label1.Caption := '目錄: C:\';
end;

procedure Tadvres.SpeedButton3Click(Sender: TObject);
begin
  FileListBox1.Mask := '*.bak';
  Label2.Caption := '*.bak(備份檔案)';
end;

procedure Tadvres.SpeedButton4Click(Sender: TObject);
begin
  FileListBox1.Mask := '*.all';
  Label2.Caption := '*.all(全部)';
end;

procedure Tadvres.SpeedButton5Click(Sender: TObject);
var
  selDir: string;
begin
  if SelectDirectory('選擇目錄', '', selDir) then
  begin
    FileListBox1.Directory := selDir;
    Label1.Caption := '目錄: ' + selDir;
  end;
end;

end.
