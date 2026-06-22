Unit modipass_unit;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, Dialogs, FileUtil;

Type
  TModiPassF = Class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    MaskEdit1: TEdit;
    Procedure BitBtn1Click(Sender: TObject);
    Procedure BitBtn2Click(Sender: TObject);
    Procedure FormCloseQuery(Sender: TObject; Var CanClose: boolean);
    Procedure FormShow(Sender: TObject);
  private
  public
    NetSource: string;
  End;

Procedure showForm_ModiPassF(xNetSource: string);

Var
  ModiPassF: TModiPassF;

Implementation

{$R *.lfm}

Uses ToolsFunction_unit;

Procedure showForm_ModiPassF(xNetSource: string);
Begin
  ModiPassF := TModiPassF.Create(Application);
  With ModiPassF Do Begin
    NetSource := xNetSource;
    //--------------------------
    BorderIcons := [biSystemMenu, biMinimize];
    BorderStyle := bsDialog;
    Position := poMainFormCenter;
    WindowState := wsNormal;
    KeyPreview := True;
    BringToFront;
    ShowModal();
  End;
End;

Procedure TModiPassF.FormCloseQuery(Sender: TObject; Var CanClose: boolean);
Begin

End;

Procedure TModiPassF.FormShow(Sender: TObject);
Begin

End;

Procedure TModiPassF.BitBtn1Click(Sender: TObject);
Var
  xalias: string;
  SL: TStringList;
Begin
  xalias := netsource + ':\w3000\comm\';
  SL := TStringList.Create;
  Try
    Sl.Text := encrypts(string(MaskEdit1.Text).SubString(0, 10));
    Sl.SaveToFile(xalias + 'motherpw.txt');
    ShowMessage('密碼已變更!');
    Close;
  Finally
    FreeAndNil(Sl);
  End;

End;

Procedure TModiPassF.BitBtn2Click(Sender: TObject);
Begin
  Close;
End;

End.
