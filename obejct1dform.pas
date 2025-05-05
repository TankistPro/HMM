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
    isShowValues: TCheckBox;
    ComboBox1: TComboBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
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
    procedure BitBtn2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ShowHHHType;
    procedure RenderSequenceHMM;
    procedure RenderSpiralHMM;
    procedure FormCreate(Sender: TObject);
    procedure VisualizationTypeChange(Sender: TObject);
    procedure UpdateRender;
    procedure setGrid;
  private

  public

  end;

var
  Form2: TForm2;
  TotalNumbers: Integer;
  SquareSize: Integer;
  RenderType: String;

implementation

{$R *.lfm}

{ TForm2 }

// Процедура отрисовки выбранного типа раскарски
procedure TForm2.ShowHHHType;
var
  i, x, y: Integer;
  size: Integer;
  Num: Integer;
begin
  size := 50; // Размер квадрата
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
    Image2.Canvas.FillRect(x, y, x + size, y + size);
    Image2.Canvas.TextOut(x + 10, y + 15, IntToStr(Num));

    // Смещаем координаты для следующего квадрата
    x := x + size;
    if x > Image2.Canvas.Width - size then
    begin
      Break;
    end;
  end;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
     selectedHMM := ComboBox1.Text;
end;

procedure TForm2.VisualizationTypeChange(Sender: TObject);
begin
   RenderType:= VisualizationType.Text;
end;

procedure TForm2.UpdateRender;
begin
  ShowHHHType;
  if RenderType = 'Последовательная' then RenderSequenceHMM;
  if RenderType = 'Спираль' then RenderSpiralHMM;
  //setGrid;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
     TotalNumbers := StrToInt(LabeledEdit1.Text);
     SquareSize := StrToInt(LabeledEdit2.Text);
     UpdateRender;
end;

// Процедура отрисовки "Последовательной HMM"
procedure TForm2.RenderSequenceHMM;
var
  i, x, y: Integer;
  Num: Integer;
begin
  x := 0;
  y := 0;
  Image1.Canvas.Font.Size := 8;
  Image1.Canvas.Font.Color := clWhite;

  Image1.Canvas.Brush.Color := clMenu; // Новый цвет фона
  Image1.Canvas.FillRect(0, 0, Image1.Width, Image1.Height);

  for i := 1 to TotalNumbers do
  begin
    Num := i * 2;

    Image1.Canvas.Brush.Color := HMM1D_module.NumberToColor(Num);
    Image1.Canvas.FillRect(x, y, x + SquareSize, y + SquareSize);

    if isShowValues.Checked then
       Image1.Canvas.TextOut(x + 10, y + 15, IntToStr(Num));

    // Смещаем координаты для следующего квадрата
    x := x + SquareSize;
    if x > Image1.Canvas.Width - SquareSize then
    begin
      x := 0;
      y := y + SquareSize;
    end;
  end;
end;

// Процедура отрисовки "Спираль HMM"
procedure TForm2.RenderSpiralHMM;
var
  x, y, dx, dy, steps, turn, num: Integer;
begin
  Image1.Canvas.Clear;
  Image1.Canvas.Font.Size := 8;

  x := Image1.Canvas.Width div 2;  // центр формы
  y := Image1.Canvas.Height div 2;
  dx := 0; dy := -1;       // начальное направление (вверх)
  steps := 0; turn := 0;   // счетчики шагов и поворотов
  num := 2;                // начинаем с первого четного

  Image1.Canvas.Brush.Color := clMenu; // Новый цвет фона
  Image1.Canvas.FillRect(0, 0, Image1.Width, Image1.Height);

  while (num <= TotalNumbers) and (x > 0) and (x < Image1.Canvas.Width) and (y > 0) and (y < Image1.Canvas.Height) do
  begin
    // Движение в текущем направлении
    Inc(steps);
    x := x + dx * SquareSize;  // шаг по x
    y := y + dy * SquareSize;  // шаг по y

    if (num mod 2 = 0) then begin
       Image1.Canvas.Brush.Color := HMM1D_module.NumberToColor(Num);
       Image1.Canvas.FillRect(x, y, x + SquareSize, y + SquareSize);
       if isShowValues.Checked then
          Image1.Canvas.TextOut(x, y, IntToStr(num));
    end;

    Inc(num, 2);  // следующее четное число

    // Проверка на поворот
    if steps = abs(turn div 2) + 1 then
    begin
      steps := 0;
      Inc(turn);
      // Смена направления (по часовой стрелке)
      case turn mod 4 of
        0: begin dx := 0; dy := -1; end; // вверх
        1: begin dx := 1; dy := 0; end;  // вправо
        2: begin dx := 0; dy := 1; end;  // вниз
        3: begin dx := -1; dy := 0; end; // влево
      end;
    end;
  end;
end;

procedure TForm2.setGrid;
var
  i: Integer;
begin
  // Рисуем сетку
  Image1.Canvas.Pen.Color := clWhite; // Цвет линий сетки
  Image1.Canvas.Pen.Style := psSolid;

  // Вертикальные линии
  for i := 0 to Image1.Width div SquareSize do
  begin
    Image1.Canvas.MoveTo(i * SquareSize, 0);
    Image1.Canvas.LineTo(i * SquareSize, Image1.Height);
  end;

  // Горизонтальные линии
  for i := 0 to Image1.Height div SquareSize do
  begin
    Image1.Canvas.MoveTo(0, i * SquareSize);
    Image1.Canvas.LineTo(Image1.Width, i * SquareSize);
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
  RenderType:=VisualizationType.Text;

  TotalNumbers := 238;
  SquareSize := 50;

  LabeledEdit1.Text := TotalNumbers.ToString;
  LabeledEdit2.Text := SquareSize.ToString;

  UpdateRender;
end;

end.

