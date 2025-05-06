unit HMM1D_module;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, LCLIntf;

procedure GeneratePalette;
function IsEven(n: Integer): Boolean;
function GetColorForNumber(num: Integer): TColor;

var
   selectedHMM: String;
   Palette: array of TColor;
   ColorsSize: Integer;
   DrawMethod: String;

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

function GetColorForNumber(num: Integer): TColor;
var
   index: Integer;
begin
  case DrawMethod of
  'Линейный':
    begin
         index := (num mod ColorsSize) + ColorsSize ;
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

   end;
end;

// Является ли число четным
function IsEven(n: Integer): Boolean;
begin
  Result := (n mod 2 = 0); // Проверяем, четное ли число
end;

end.

