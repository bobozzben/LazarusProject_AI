program project1;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, unit1, floginunit, mainback_uint, choiceunit, advunit,
  stateunit, s3000unit, stubs;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  //Application.CreateForm(Tmainback, mainback);
  Application.Run;
end.
