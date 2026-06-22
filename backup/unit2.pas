unit unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls;

type
  Tmail = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  end;

var
  mail: Tmail;

implementation

{$R *.lfm}

procedure Tmail.FormCreate(Sender: TObject);
begin
  Caption := '函證備份';
  Label1.Caption := '函證備份畫面已轉換為占位表單。';
end;

end.
