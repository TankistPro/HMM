unit HMM1D_module;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

function NumberToColor(num: Integer): TColor;
function IsEven(n: Integer): Boolean;

var
   selectedHMM: String;

implementation

// Функция раскраски для HMM_N
function NumberToColor_N(num: Integer): TColor;
begin
  case num mod 10 of
      0: Result := RGBToColor(255, 255, 255);
      2: Result := RGBToColor(192, 192, 192);
      4: Result := RGBToColor(128, 128, 128);
      6: Result := RGBToColor(96, 96, 96);
      8: Result := RGBToColor(32, 32, 32);
      else Result := RGBToColor(0, 0, 0);
  end;
end;

// Функция раскраски для HMM_DN
function NumberToColor_DN(num: Integer): TColor;
begin
  case num mod 10 of
      0: Result := RGBToColor(255,102, 102);
      2: Result := RGBToColor(255,255, 102);
      4: Result := RGBToColor(102,255, 102);
      6: Result := RGBToColor(102,255, 255);
      8: Result := RGBToColor(102,102, 255);
      else Result := RGBToColor(255,102, 255);
  end;
end;

function NumberToColor(num: Integer): TColor;
begin
   case selectedHMM of
       'HMM_N': Result := NumberToColor_N(num);
       'HMM_DN': Result := NumberToColor_DN(num);
   end;
end;

// Является ли число четным
function IsEven(n: Integer): Boolean;
begin
  Result := (n mod 2 = 0); // Проверяем, четное ли число
end;

procedure FillSpiralEvenNumbers(var A: array of array of Integer; N: Integer);
var
  left, right, top, bottom, i: Integer;
  num: Integer;
begin
  left := 0;
  right := N - 1;
  top := 0;
  bottom := N - 1;
  num := 2; // Начинаем с первого чётного числа

  while (left <= right) and (top <= bottom) do
  begin
    // Вправо
    for i := left to right do
    begin
      A[top, i] := num;
      num := num + 2;
    end;
    Inc(top);

    // Вниз
    for i := top to bottom do
    begin
      A[i, right] := num;
      num := num + 2;
    end;
    Dec(right);

    // Влево
    if top <= bottom then
      for i := right downto left do
      begin
        A[bottom, i] := num;
        num := num + 2;
      end;
    Dec(bottom);

    // Вверх
    if left <= right then
      for i := bottom downto top do
      begin
        A[i, left] := num;
        num := num + 2;
      end;
    Inc(left);
  end;
end;

end.

