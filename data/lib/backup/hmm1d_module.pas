unit HMM1D_module;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

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

end.

