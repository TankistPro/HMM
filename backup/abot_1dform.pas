unit abot_1dform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TForm5 }

  TForm5 = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form5: TForm5;

implementation

{$R *.lfm}

{ TForm5 }

procedure TForm5.FormCreate(Sender: TObject);
begin
  if FileExists('./data/static/1D_info.txt') then begin
     Memo1.Lines.LoadFromFile('./data/static/1D_info.txt');
  end
  else
      ShowMessage('1D_info.txt');
end;

end.

