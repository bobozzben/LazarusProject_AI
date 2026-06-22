unit warning_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, ExtCtrls, Dialogs;

type
  TWarningF = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    closeFlag: Boolean;
  public
  end;

var
  WarningF: TWarningF;

implementation

//{$R *.lfm}

procedure TWarningF.BitBtn1Click(Sender: TObject);
begin
  closeFlag := True;
  Close;
end;

procedure TWarningF.BitBtn2Click(Sender: TObject);
begin
  closeFlag := False;
  Close;
end;

procedure TWarningF.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  ModalResult := mrCancel;
  if closeFlag then
    ModalResult := mrOk;
  CanClose := True;
end;

end.
