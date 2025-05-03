unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls, LCLIntf, LCLType,
  Obejct1DForm;


type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Separator1: TMenuItem;
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Form1D: TForm2;

implementation

{$R *.lfm}

{ TForm1 }

// Выход
procedure TForm1.MenuItem6Click(Sender: TObject);
begin
 Close;
end;

// Зависимость 1D
procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  if not Assigned(Form1D) then
      Form1D := TForm2.Create(Application);
  Form1D.Show;
end;

// О программе
procedure TForm1.MenuItem10Click(Sender: TObject);
begin
      Application.MessageBox('Программа "Хромоматематического моделирования на множестве целых чисел".' + #13#10 +
                      'Выражаю благодарность своим родителям - Гусевой Елене и Гусеву Константину' + #13#10 +
                      '(c)Gusev, Moscow, 2025',
                      'О программе...',
                      MB_OK + MB_ICONINFORMATION);
end;

end.

