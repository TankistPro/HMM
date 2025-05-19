unit about_2dform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TForm6 }

  TForm6 = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private

  public

  end;

var
  Form6: TForm6;

implementation

{$R *.lfm}

{ TForm6 }

procedure TForm6.FormCreate(Sender: TObject);
begin
  if FileExists('./data/static/2D_info.txt') then begin
     Memo1.Lines.LoadFromFile('./data/static/2D_info.txt');
  end
  else
     ShowMessage('2D_info.txt');
end;

procedure TForm6.Label1Click(Sender: TObject);
begin

end;

end.

