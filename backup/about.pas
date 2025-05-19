unit about;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, RTTICtrls, Windows;

type

  { TForm3 }

  TForm3 = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }


procedure TForm3.FormCreate(Sender: TObject);
begin
  if FileExists('./data/static/main_about.txt') then begin
     Memo1.Lines.LoadFromFile('./data/static/main_about.txt');
     HideCaret(Memo1.Handle);
  end
  else
      ShowMessage('main_about.txt');
end;

end.

