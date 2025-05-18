unit object2dForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls,Graphics, ExtCtrls, Buttons,
  Math, HMM1D_module;

type

  { TForm4 }

  TForm4 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ComboBox1: TComboBox;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    LabeledEdit2: TLabeledEdit;
    ARatio: TLabeledEdit;
    yMinValue: TLabeledEdit;
    yMaxValue: TLabeledEdit;
    xMinValue: TLabeledEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    xMaxValue: TLabeledEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DrawPoints();
    procedure RenderAxes;
    procedure ShowHHHType;
    procedure UpdateRender;
    function LogicalXToPixel(X: Double): Integer;
    function LogicalYToPixel(Y: Double): Integer;
  private
    Aspect: TPoint;
    xMin, xMax, yMin, yMax: Double;
    Ar:Double;

  public

  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

{ TForm4 }

procedure TForm4.FormCreate(Sender: TObject);
begin
  Aspect.X := 7;
  Aspect.Y := 7;
  LabeledEdit2.Text := Aspect.X.ToString;

  Ar := 9.37;
  ARatio.Text:= Ar.ToString;

  xMin := -10;
  xMax := 10;
  yMin := -10;
  yMax := 10;

  xMinValue.Text := xMin.ToString;
  xMaxValue.Text := xMax.ToString;
  yMinValue.Text := yMin.ToString;
  yMaxValue.Text := yMax.ToString;

  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('HMM_N');
  ComboBox1.Items.Add('HMM_DN');
  ComboBox1.ItemIndex := 0;
  selectedHMM := ComboBox1.Text;

  UpdateRender;
end;

procedure TForm4.UpdateRender;
begin
  GeneratePalette;
  ShowHHHType;
  DrawPoints();
end;

// Процедура отрисовки выбранного типа раскарски
procedure TForm4.ShowHHHType;
var
  i, x, y: Integer;
  BlockWidth: Integer;
begin
  x := 0;
  y := 0;
  Image2.Canvas.Font.Size := 9;
  Image2.Canvas.Font.Color := clWhite;

  Image2.Canvas.Brush.Color := clMenu;
  Image2.Canvas.FillRect(0, 0, Image2.Width, Image2.Height);

  BlockWidth := Image2.Width div ColorsSize;

  for i := 0 to ColorsSize - 1 do
  begin
    Image2.Canvas.Brush.Color := Palette[i];
    Image2.Canvas.FillRect(x, y, x + BlockWidth, y + Image2.Height);

    // Смещаем координаты для следующего квадрата
    x := x + BlockWidth;
    if x > Image2.Canvas.Width - BlockWidth then
    begin
      Break;
    end;
  end;
end;

 //Процедура для рисования осей и точек
procedure TForm4.DrawPoints();
var
  x, y: Double;
  XCoord, YCoord: Integer;
  stepX, stepY: Double;
begin
  Image1.Canvas.Brush.Color := clMenu;
  Image1.Canvas.FillRect(0, 0, Image1.Width, Image1.Height);

  stepX := (xMax - xMin) / (Image1.Width div Aspect.X);
  stepY := (yMax - yMin) / (Image1.Height div Aspect.Y);

  y := yMin;
  while y <= yMax do
  begin
    x := xMin;
    while x <= xMax do
    begin
      Image1.Canvas.Brush.Color := HMM1D_module.GetColor(Ar, Round(x), Round(y));
      XCoord := LogicalXToPixel(x);
      YCoord := LogicalYToPixel(y);
      Image1.Canvas.Ellipse(XCoord - 4, YCoord - 4, XCoord + 4, YCoord + 4);
      x := x + stepX;
    end;
    y := y + stepY;
  end;

  RenderAxes;
end;


procedure TForm4.RenderAxes;
var
  x, y: Double;
  XPos, YPos: Integer;
  labelStepX, labelStepY: Double;
begin
  Image1.Canvas.Brush.Color := clMenu;
  Image1.Canvas.Pen.Style := psSolid;
  Image1.Canvas.Pen.Color := clBlack;
  Image1.Canvas.Pen.Width := 3;
  Image1.Canvas.Font.Color := clBlack;

  // Ось X
  YPos := LogicalYToPixel(0);
  Image1.Canvas.MoveTo(0, YPos);
  Image1.Canvas.LineTo(Image1.Width, YPos);

  // Ось Y
  XPos := LogicalXToPixel(0);
  Image1.Canvas.MoveTo(XPos, 0);
  Image1.Canvas.LineTo(XPos, Image1.Height);

  // Метки на оси X
  labelStepX := (xMax - xMin) / 10; // 10 делений
  x := xMin;
  while x <= xMax do
  begin
    if Abs(x) < 1e-6 then
    begin
      x := x + labelStepX;
      Continue; // не рисуем метку в нуле дважды
    end;
    XPos := LogicalXToPixel(x);
    Image1.Canvas.MoveTo(XPos, YPos - 5);
    Image1.Canvas.LineTo(XPos, YPos + 5);
    Image1.Canvas.TextOut(XPos - 10, YPos + 10, Format('%.1f', [x]));
    x := x + labelStepX;
  end;

  // Метки на оси Y
  labelStepY := (yMax - yMin) / 10;
  y := yMin;
  while y <= yMax do
  begin
    if Abs(y) < 1e-6 then
    begin
      y := y + labelStepY;
      Continue;
    end;
    YPos := LogicalYToPixel(y);
    Image1.Canvas.MoveTo(XPos - 5, YPos);
    Image1.Canvas.LineTo(XPos + 5, YPos);
    Image1.Canvas.TextOut(XPos - 40, YPos - 7, Format('%.2f', [y]));
    y := y + labelStepY;
  end;
end;

// Расчет
procedure TForm4.BitBtn2Click(Sender: TObject);
begin
  Aspect.X := StrToInt64(LabeledEdit2.Text);
  Aspect.Y := StrToInt64(LabeledEdit2.Text);

  Ar := StrToFloat(ARatio.Text);

  xMin := StrToFloat(xMinValue.Text);
  xMax := StrToFloat(xMaxValue.Text);
  yMin := StrToFloat(yMinValue.Text);
  yMax := StrToFloat(yMaxValue.Text);

  UpdateRender;
end;

function TForm4.LogicalXToPixel(X: Double): Integer;
begin
  Result := Round((X - xMin) / (xMax - xMin) * Image1.Width);
end;

function TForm4.LogicalYToPixel(Y: Double): Integer;
begin
  Result := Round(Image1.Height - (Y - yMin) / (yMax - yMin) * Image1.Height);
end;


end.

