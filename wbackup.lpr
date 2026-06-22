program wbackup;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, MainMenu_unit, floginunit, mainback_uint, choice_unit,
  advunit, stateunit, s3000_unit, s5000_unit, warningu, fragmentback_uint,
  modipass_unit, ToolsFunction_unit, GoogleOAuth_unit;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm1, MainForm1);
  //Application.CreateForm(Tmainback, mainback);
  Application.Run;
end.
