unit HMM1D_module;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, LCLIntf, Math;

procedure GeneratePalette;
function IsEven(n: Integer): Boolean;
function GetColorForNumber(num: Integer): TColor;
function GetColor(A, X, Y: Real): TColor;
function IsValidNumberKeyPress(const CurrentText: string; Key: Char): Boolean;
function InterpolateColor(Color1, Color2: TColor; t: Double): TColor;
function GetColorFor2D(A, X, Y: Real): TColor;

var
   selectedHMM: String;
   Palette: array of TColor;
   ColorsSize: Integer;
   DrawMethod: String;

const
  ColorStart: TColor = clRed;   // Начальный цвет
  ColorEnd: TColor = clGreen;   // Конечный цвет

implementation

// Функция раскраски для HMM_N
procedure GeneratePalette_N;
var
   i: Integer;
   GrayScale: Integer;
begin
  SetLength(Palette, ColorsSize);
  for i := 0 to ColorsSize - 1 do
    begin
      GrayScale := Round((i / (ColorsSize - 1)) * 255);
      Palette[i] := TColor(RGB(GrayScale, GrayScale, GrayScale));
    end;
end;

procedure GeneratePalette_Sin;
var
  i: Integer;
  r, g, b: Byte;
begin
  SetLength(Palette, ColorsSize);
  for i := 0 to ColorsSize-1 do
  begin
    r := Round(127 * Sin(i * 0.1) + 128);
    g := Round(127 * Sin(i * 0.1 + 2) + 128);
    b := Round(127 * Sin(i * 0.1 + 4) + 128);
    Palette[i] := RGBToColor(r, g, b);
  end;
end;

procedure GeneratePalette_N_2D;
var
  i: Integer;
  t: Double;
begin
  SetLength(Palette, ColorsSize);
  for i := 1 to ColorsSize-1 do
  begin
    t := (i - 1) / 8;
    Palette[i] := InterpolateColor(ColorStart, ColorEnd, t);
  end;
end;

function GetColorForNumber(num: Integer): TColor;
var
   index: Integer;
begin
  case DrawMethod of
  'Линейный':
    begin
         index := (num mod ColorsSize);
         Result := Palette[index];
    end;
  'Хеширование':
    begin
      index := (num * 1103515245 + 12345) and $7FFFFFFF; // Простой линейный конгруэнтный генератор
      Result := Palette[index mod ColorsSize];
    end;
  'Золотое сечение':
    begin
       index := Round(num * 0.6180339887 * ColorsSize) mod ColorsSize;
       Result := Palette[index];
    end;
  '2D':
    begin
       index := (num mod ColorsSize);
       Result := Palette[num];
    end;
  end;
end;

// Функция раскраски для HMM_DN
procedure GeneratePalette_DN();
var
   i, r, g, b: Integer;
   t: Double;
begin
  SetLength(Palette, ColorsSize);
  for i := 0 to ColorsSize - 1 do
  begin
    t := i / (ColorsSize - 1); // Нормализация в диапазоне [0..1]

    // Градиент: красный (0) → зелёный (0.5) → синий (1)
    if t < 0.5 then
    begin
      // Переход от красного к зелёному
      r := Round(255 * (1 - 2 * t)); // Уменьшаем красный
      g := Round(255 * (2 * t));     // Увеличиваем зелёный
      b := 0;
    end
    else
    begin
      // Переход от зелёного к синему
      r := 0;
      g := Round(255 * (2 * (1 - t))); // Уменьшаем зелёный
      b := Round(255 * (2 * t - 1));   // Увеличиваем синий
    end;

    Palette[i] := RGBToColor(r, g, b); // Заполняем палитру
  end;
end;

procedure GeneratePalette();
begin
   case selectedHMM of
       'HMM_N': GeneratePalette_N;
       'HMM_DN': GeneratePalette_DN;
       'HMM_N_2D': GeneratePalette_N_2D;
       'HMM_DN_2D': GeneratePalette_Sin;
   end;
end;

function Ker(n: Integer): Integer;
var
  sum: Integer;
begin
  n := Abs(n);
  if n < 10 then
    Result := n
  else
  begin
    sum := 0;
    while n > 0 do
    begin
      sum := sum + (n mod 10);
      n := n div 10;
    end;
    Result := Ker(sum);
  end;
end;

function InterpolateColor(Color1, Color2: TColor; t: Double): TColor;
var
  R1, G1, B1: Byte;
  R2, G2, B2: Byte;
  R, G, B: Byte;
begin
  R1 := GetRValue(Color1);
  G1 := GetGValue(Color1);
  B1 := GetBValue(Color1);

  R2 := GetRValue(Color2);
  G2 := GetGValue(Color2);
  B2 := GetBValue(Color2);

  R := Round(R1 + t * (R2 - R1));
  G := Round(G1 + t * (G2 - G1));
  B := Round(B1 + t * (B2 - B1));

  Result := RGBToColor(R, G, B);
end;

function GetColorFor2D(A, X, Y: Real): TColor;
var
  Value, scaled: Integer;
  index: Integer;
begin
  if selectedHMM = 'HMM_N_2D' then Result := GetColor(A, X, Y);
  if selectedHMM = 'HMM_DN_2D' then begin
    Value := Ker(Round(Abs(A * Sin(X * 0.1 + Y * 0.55))));
    scaled := (Value * 100) div 9;
    index := (scaled mod ColorsSize);
    Result := Palette[index];
  end;
end;

function GetColor(A, X, Y: Real): TColor;
var
  Value: Integer;
  t: Double;
begin

  Value := Ker(Round(Abs(A * Sin(X * 0.1 + Y * 0.55))));
  // Value от 1 до 9, нормируем в диапазон [0..1]
  t := (Value - 1) / 8; // 0 при Value=1, 1 при Value=9
  Result := InterpolateColor(ColorStart, ColorEnd, t);
end;

function IsValidNumberKeyPress(const CurrentText: string; Key: Char): Boolean;
begin
  // Разрешаем цифры, Backspace
  if Key in ['0'..'9', #8] then
  begin
    Result := True;
    Exit;
  end;

  // Разрешаем знак минус только в начале и только один раз
  if Key = '-' then
  begin
    Result := (Length(CurrentText) = 0) and (Pos('-', CurrentText) = 0);
    Exit;
  end;

  // Разрешаем только один десятичный разделитель (запятая или точка)
  if (Key = ',') then
  begin
    Result := (Pos(',', CurrentText) = 0);
    Exit;
  end;

  // Все остальные символы запрещены
  Result := False;
end;


// Является ли число четным
function IsEven(n: Integer): Boolean;
begin
  Result := (n mod 2 = 0); // Проверяем, четное ли число
end;

end.

