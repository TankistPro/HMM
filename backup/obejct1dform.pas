unit Obejct1DForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls,Graphics, ExtCtrls, Buttons,
  HMM1D_module;

type

  { TForm2 }

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ComboBox1: TComboBox;
    LabeledEdit1: TLabeledEdit;
    VisualizationType: TComboBox;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ShowHHHType;
    procedure RenderHMM;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

// Процедура отрисовки выбранного типа раскарски
procedure TForm2.ShowHHHType;
var
  i, x, y: Integer;
  SquareSize: Integer;
  Num: Integer;
begin
  SquareSize := 50; // Размер квадрата
  x := 10;
  y := 10;
  Image2.Canvas.Font.Size := 9;
  Image2.Canvas.Font.Color := clWhite;

  Image2.Canvas.Brush.Color := clMenu; // Новый цвет фона
  Image2.Canvas.FillRect(0, 0, Image2.Width, Image2.Height);

  for i := 1 to 8 do
  begin
    Num := i * 2;

    Image2.Canvas.Brush.Color := HMM1D_module.NumberToColor(Num);
    Image2.Canvas.FillRect(x, y, x + SquareSize, y + SquareSize);
    Image2.Canvas.TextOut(x + 10, y + 15, IntToStr(Num));

    // Смещаем координаты для следующего квадрата
    x := x + SquareSize;
    if x > Image2.Canvas.Width - SquareSize then
    begin
      Break;
    end;
  end;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
     selectedHMM := ComboBox1.Text;
     ShowHHHType;
     RenderHMM;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

// Процедура отрисовки HMM
procedure TForm2.RenderHMM;
var
  i, x, y: Integer;
  SquareSize: Integer;
  Num: Integer;
begin
  SquareSize := 50; // Размер квадрата
  x := 10;
  y := 10;
  Image1.Canvas.Font.Size := 9;
  Image1.Canvas.Font.Color := clWhite;

  Image1.Canvas.Brush.Color := clMenu; // Новый цвет фона
  Image1.Canvas.FillRect(0, 0, Image1.Width, Image1.Height);

  for i := 1 to 238 do
  begin
    Num := i * 2;

    Image1.Canvas.Brush.Color := HMM1D_module.NumberToColor(Num);
    Image1.Canvas.FillRect(x, y, x + SquareSize, y + SquareSize);
    Image1.Canvas.TextOut(x + 10, y + 15, IntToStr(Num));

    // Смещаем координаты для следующего квадрата
    x := x + SquareSize;
    if x > Image1.Canvas.Width - SquareSize then
    begin
      x := 10;
      y := y + SquareSize;
    end;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('HMM_N');
  ComboBox1.Items.Add('HMM_DN');
  ComboBox1.ItemIndex := 0;
  selectedHMM:=ComboBox1.Text;

  VisualizationType.Items.Clear;
  VisualizationType.Items.Add('Последовательная');
  VisualizationType.Items.Add('Спираль');
  VisualizationType.Items.Add('Столбчатая');
  VisualizationType.ItemIndex := 0;

  ShowHHHType;
  RenderHMM;
end;

end.

