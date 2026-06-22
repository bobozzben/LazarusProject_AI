unit stateunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, ExtCtrls, Dialogs,
  ComCtrls, Windows;

type

  { Tstate }

  Tstate = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Labelp: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Button1: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    checkburn: integer;
  public
  end;

var
  state: Tstate;

implementation

uses MainMenu_unit, choice_unit;

{$R *.lfm}

procedure Tstate.Button1Click(Sender: TObject);
begin
Close;
end;

procedure Tstate.FormShow(Sender: TObject);
begin
  Label2.Caption := '0';
  Button1.Visible := False;
end;

procedure Tstate.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  state := nil;
end;

end.
