unit dropboxu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons, Dialogs, FileUtil,IniFiles;

type
  TDropBoxForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    OldDir: string;
  public
  end;

procedure showForm_DropBoxForm();

var
  DropBoxForm: TDropBoxForm;

implementation

uses MainMenu_unit;

{$R *.lfm}

procedure showForm_DropBoxForm();
begin
  DropBoxForm := TDropBoxForm.Create(Application);
  With DropBoxForm Do Begin
    //--------------------------
    BorderIcons:=[biSystemMenu,biMinimize];
    BorderStyle:=bsDialog;
    Position   :=poMainFormCenter;
    WindowState:= wsNormal;
    KeyPreview := True;
    BringToFront;
    ShowModal();
  end;
end;

procedure TDropBoxForm.BitBtn1Click(Sender: TObject);
Var
  ini :TIniFile ;
begin
  ini := TIniFile.create(ChangeFileExt( Application.ExeName, '.INI' ) );
  ini.WriteString( 'DropBox', 'Path', Trim(Edit1.Text)  );
  FreeAndNil(ini);

  MainForm1.DropBoxPath := Trim(Edit1.Text);
  Close;
end;

procedure TDropBoxForm.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TDropBoxForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if DirectoryExists(OldDir) then
    SetCurrentDir(OldDir);
end;

procedure TDropBoxForm.FormShow(Sender: TObject);
begin
  OldDir := GetCurrentDir;
  Edit1.Text := MainForm1.DropBoxPath;
end;

procedure TDropBoxForm.SpeedButton1Click(Sender: TObject);
var
  Dir: string;
begin
  Dir := Edit1.Text;
  if Not (Dir.Trim.IsEmpty) Then
     OpenDialog1.InitialDir  :=  Dir;
  if SelectDirectory('選取 雲端硬碟存放目錄', '', Dir) then
    Edit1.Text := Dir;
end;

end.
