unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls, LCLIntf, LCLType,
  Obejct1DForm, about, object2dForm;


type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Separator1: TMenuItem;
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Form1D: TForm2;
  Form2D: TForm4;
  AboutForm: TForm3;

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

// Зависимость 2D
procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  if not Assigned(Form2D) then
      Form2D := TForm4.Create(Application);
  Form2D.Show;
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
   if not Assigned(AboutForm) then
      AboutForm := TForm3.Create(Application);
  AboutForm.Show;
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

