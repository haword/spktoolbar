unit SpkGraphTools;
{$H+}
{$DEFINE SPKGRAPHTOOLS}
interface
uses
  FMX.Graphics, FMX.Types, System.UITypes, Classes, Math, Sysutils, FMX.Dialogs, SpkMath,
  System.Types;
const
  NUM_ZERO = 0.00000001;
  (*******************************************************************************
  *                                                                              *
  *                              Proste struktury                                *
  *                                                                              *
  *******************************************************************************)
type
  // WskaŸnik do tablicy TRGBTriple
  //TColor = TAlphaColor;



  COLOR16 = Word;

  PTriVertex = ^TTriVertex;
  {$EXTERNALSYM _TRIVERTEX}
  _TRIVERTEX = record
    x: Longint;
    y: Longint;
    Red: COLOR16;
    Green: COLOR16;
    Blue: COLOR16;
    Alpha: COLOR16;
  end;
  TTriVertex = _TRIVERTEX;

  PRGBTriple = ^TRGBTriple;
  {$EXTERNALSYM tagRGBTRIPLE}
  tagRGBTRIPLE = record
    rgbtBlue: Byte;
    rgbtGreen: Byte;
    rgbtRed: Byte;
  end;
  TRGBTriple = tagRGBTRIPLE;
  {$EXTERNALSYM RGBTRIPLE}
  RGBTRIPLE = tagRGBTRIPLE;

  TRIVERTEX = _TRIVERTEX;

  PRGBTripleArray = ^TRGBTripleArray;
  // Tablica TRGBTriple (u¿ywana podczas operacji ze ScanLine)
  TRGBTripleArray = array[word] of TRGBTriple;
  THSLTriple = record
    H, S, L: extended;
  end;

  ULONG = Cardinal;

  _GRADIENT_RECT = record
    UpperLeft: ULONG;
    LowerRight: ULONG;
  end;
  TGradientRect = _GRADIENT_RECT;
  {$EXTERNALSYM GRADIENT_RECT}
  GRADIENT_RECT = _GRADIENT_RECT;


  // Rodzaj gradientu
  TGradientType = (gtVertical, gtHorizontal);
  // Rodzaj linii gradientowej (miejsce rozmycia)
  TGradientLineShade = (lsShadeStart, lsShadeEnds, lsShadeCenter, lsShadeEnd);
  // Rodzaj linii gradientowej (wypuk³oœæ)
  TGradient3dLine = (glRaised, glLowered);
  (*******************************************************************************
  *                                                                              *
  *                              Klasy narzêdziowe                               *
  *                                                                              *
  *******************************************************************************)
  TColorTools = class(TObject)

  public
    class function Darken(kolor: TAlphaColor; percentage: byte): TAlphaColor;
    class function Brighten(kolor: TAlphaColor; percentage: byte): TAlphaColor;
    class function Shade(kol1, kol2: TAlphaColor; percentage: byte): TAlphaColor; overload;
    class function Shade(kol1, kol2: TAlphaColor; Step: extended): TAlphaColor; overload;
    class function AddColors(c1, c2: TAlphaColor): TAlphaColor;
    class function MultiplyColors(c1, c2: TAlphaColor): TAlphaColor;
    class function MultiplyColor(color: TAlphaColor; scalar: integer): TAlphaColor; overload;
    class function MultiplyColor(color: TAlphaColor; scalar: extended): TAlphaColor; overload;
    class function percent(min, pos, max: integer): byte;
    class function RGB2HSL(ARGB: TRGBTriple): THSLTriple;
    class function HSL2RGB(AHSL: THSLTriple): TRGBTriple;
    class function RgbTripleToColor(ARgbTriple: TRGBTriple): TAlphaColor;
    class function ColorToRgbTriple(AColor: TAlphaColor): TRGBTriple;
    class function ColorToGrayscale(AColor: TAlphaColor): TAlphaColor;
  end;
  TGradientTools = class(TObject)

  public
    class procedure HGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; rect: T2DIntRect); overload;
    class procedure HGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; p1, p2: TPoint); overload;
    class procedure HGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; x1, y1, x2, y2: integer); overload;
    class procedure VGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; rect: T2DIntRect); overload;
    class procedure VGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; p1, p2: TPoint); overload;
    class procedure VGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; x1, y1, x2, y2: integer); overload;
    class procedure Gradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; rect: T2DIntRect; GradientType:
      TGradientType); overload;
    class procedure Gradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; p1, p2: TPoint; GradientType:
      TGradientType); overload;
    class procedure Gradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; x1, y1, x2, y2: integer; GradientType:
      TGradientType); overload;
    class procedure HGradientLine(canvas: TCanvas; cBase, cShade: TAlphaColor; x1, x2, y: integer; ShadeMode:
      TGradientLineShade);
    class procedure VGradientLine(canvas: TCanvas; cBase, cShade: TAlphaColor; x, y1, y2: integer; ShadeMode:
      TGradientLineShade);
    class procedure HGradient3dLine(canvas: TCanvas; x1, x2, y: integer; ShadeMode: TGradientLineShade;
      A3dKind: TGradient3dLine = glLowered);
    class procedure VGradient3dLine(canvas: TCanvas; x, y1, y2: integer; ShadeMode: TGradientLineShade;
      A3dKind: TGradient3dLine = glLowered);
  end;
  TTextTools = class
  private
  public
    class procedure TextRect(FCanvas: TCanvas; const Rect: TRect; X, Y: Integer; const Text: String; TextAlign: TTextAlign = TTextAlign.Leading; VerticalAlign: TTextAlign = TTextAlign.Center); static;
    class procedure TextOut(FCanvas: TCanvas; X, Y: integer; Text: String); static;
    class procedure OutlinedText(Canvas: TCanvas; x, y: integer; const text: string);
  end;


const

//clWhite = TAlphaColors.White;
//clBlack = TAlphaColors.Black;
//clRed = TAlphaColors.Red;
//clBlue = TAlphaColors.Blue;
//clGray = TAlphaColors.Gray;
//clWindow =  $fff0f0f0;
clBtnFace = $fff0f0f0;
clBtnHighlight = TAlphaColors.White;
clBtnShadow = TAlphaColors.Gray;
clWindowText = TAlphaColors.Black;
clLime = TAlphaColors.Lime;

clBtnText = TAlphaColors.Black;
clHighlight = $FF3299FF;
clHighlightText =  TAlphaColors.White;
clCream = $FFF1CAA6;

clPurple = TAlphaColors.Purple;

clNone = TAlphaColors.Null;


function GetRValue(Color: TAlphaColor): Byte;
function GetGValue(Color: TAlphaColor): Byte;
function GetBValue(Color: TAlphaColor): Byte;

function rgb(r,g,b: byte; a: byte = 255): TAlphaColor;

implementation
{ TColorTools }



function GetRValue(Color: TAlphaColor): Byte;
begin
  Result := TAlphaColorRec(Color).R;
end;

function GetGValue(Color: TAlphaColor): Byte;
begin
  Result := TAlphaColorRec(Color).G;;
end;

function GetBValue(Color: TAlphaColor): Byte;
begin
  Result := TAlphaColorRec(Color).B;
end;

function GetAValue(Color: TAlphaColor): Byte;
begin
  Result := TAlphaColorRec(Color).A;
end;

function rgb(r,g,b: byte; a: byte = 255): TAlphaColor;
begin
  result := TAlphaColorF.Create(r / 255, g / 255, b / 255, a / 255).ToAlphaColor;
end;

class function TColorTools.Darken(kolor: TAlphaColor; percentage: byte): TAlphaColor;
var
  r, g, b, a: byte;
begin
  r := round(GetRValue(kolor) * (100 - percentage) / 100);
  g := round(GetGValue(kolor) * (100 - percentage) / 100);
  b := round(GetBValue(kolor) * (100 - percentage) / 100);
  a := round(GetAValue(kolor));

  result := rgb(r, g, b, a);

end;

class function TColorTools.Brighten(kolor: TAlphaColor; percentage: byte): TAlphaColor;
var
  r, g, b, a: byte;
begin
  r := round(GetRValue((kolor)) + ((255 - GetRValue((kolor))) * (percentage / 100)));
  g := round(GetGValue((kolor)) + ((255 - GetGValue((kolor))) * (percentage / 100)));
  b := round(GetBValue((kolor)) + ((255 - GetBValue((kolor))) * (percentage / 100)));
  a := round(GetAValue((kolor)));

  result := rgb(r, g, b, a);
end;

class function TColorTools.Shade(kol1, kol2: TAlphaColor; percentage: byte): TAlphaColor;
var
  r, g, b, a: byte;
begin
  r := round(GetRValue(kol1) + ((GetRValue(kol2) - GetRValue(kol1)) *
    (percentage / 100)));
  g := round(GetGValue(kol1) + ((GetGValue(kol2) - GetGValue(kol1)) *
    (percentage / 100)));
  b := round(GetBValue(kol1) + ((GetBValue(kol2) - GetBValue(kol1)) *   (percentage / 100)));

  result := rgb(r, g, b);

end;

class function TColorTools.Shade(kol1, kol2: TAlphaColor; Step: extended): TAlphaColor;
var
  r, g, b, a: byte;
begin
  r := round(GetRValue(kol1) + ((GetRValue(kol2) - GetRValue(kol1)) *
    (Step)));
  g := round(GetGValue(kol1) + ((GetGValue(kol2) - GetGValue(kol1)) *
    (Step)));
  b := round(GetBValue(kol1) + ((GetBValue(kol2) - GetBValue(kol1)) *    (Step)));

  result := rgb(r, g, b);
end;

class function TColorTools.AddColors(c1, c2: TAlphaColor): TAlphaColor;
begin
  result := rgb(max(0, min(255, GetRValue(c1) + GetRValue(c2))),
    max(0, min(255, GetGValue(c1) + GetGValue(c2))),
    max(0, min(255, GetBValue(c1) + GetBValue(c2))));
end;

class function TColorTools.MultiplyColors(c1, c2: TAlphaColor): TAlphaColor;
begin
  result := rgb(max(0, min(255, GetRValue(c1) * GetRValue(c2))),
    max(0, min(255, GetGValue(c1) * GetGValue(c2))),
    max(0, min(255, GetBValue(c1) * GetBValue(c2))));
end;

class function TColorTools.MultiplyColor(color: TAlphaColor; scalar: integer): TAlphaColor;
begin
  result := rgb(max(0, min(255, GetRValue(color) * scalar)),
    max(0, min(255, GetGValue(color) * scalar)),
    max(0, min(255, GetBValue(color) * scalar)));
end;

class function TColorTools.MultiplyColor(color: TAlphaColor; scalar: extended): TAlphaColor;
begin
  result := rgb(max(0, min(255, round(GetRValue(color) * scalar))),
    max(0, min(255, round(GetGValue(color) * scalar))),
    max(0, min(255, round(GetBValue(color) * scalar))));
end;

class function TColorTools.Percent(min, pos, max: integer): byte;
begin
  if max = min then
    result := max
  else
    result := round((pos - min) * 100 / (max - min));
end;
{.$MESSAGE WARN 'Porównywanie liczb rzeczywistych? Trzeba poprawiæ'}

class function TColorTools.RGB2HSL(ARGB: TRGBTriple): THSLTriple;
var
  RGBmin, RGBmax: extended;
  R, G, B: extended;
  H, S, L: extended;
begin
  R := ARGB.rgbtRed / 255;
  G := ARGB.rgbtGreen / 255;
  B := ARGB.rgbtBlue / 255;
  RGBmin := min(R, min(G, B));
  RGBmax := max(R, min(G, B));
  H := 0;
  if RGBmax = RGBmin then
  begin
    // H jest nieoznaczone, ale przyjmijmy zero dla sensownoœci obliczeñ
    H := 0;
  end
  else if (R = RGBmax) and (G >= B) then
  begin
    H := (pi / 3) * ((G - B) / (RGBmax - RGBmin)) + 0;
  end
  else if (R = RGBmax) and (G < B) then
  begin
    H := (pi / 3) * ((G - B) / (RGBmax - RGBmin)) + (2 * pi);
  end
  else if (G = RGBmax) then
  begin
    H := (pi / 3) * ((B - R) / (RGBmax - RGBmin)) + (2 * pi / 3);
  end
  else if (B = RGBmax) then
  begin
    H := (pi / 3) * ((R - G) / (RGBmax - RGBmin)) + (4 * pi / 3);
  end;
  L := (RGBmax + RGBmin) / 2;
  S := 0;
  if (L < NUM_ZERO) or (rgbMin = rgbMax) then
  begin
    S := 0;
  end
  else if (L <= 0.5) then
  begin
    S := ((RGBmax - RGBmin) / (2 * L));
  end
  else if (L > 0.5) then
  begin
    S := ((RGBmax - RGBmin) / (2 - 2 * L));
  end;
  result.H := H / (2 * pi);
  result.S := S;
  result.L := L;
end;

class function TColorTools.HSL2RGB(AHSL: THSLTriple): TRGBTriple;
var
  R, G, B: extended;
  TR, TG, TB: extended;
  Q, P: extended;
  function ProcessColor(Tc: extended): extended;
  begin
    if (Tc < (1 / 6)) then
      result := P + ((Q - P) * 6.0 * Tc)
    else if (Tc < (1 / 2)) then
      result := Q
    else if (Tc < (2 / 3)) then
      result := P + ((Q - P) * ((2 / 3) - Tc) * 6.0)
    else
      result := P;
  end;
begin
  if AHSL.S < NUM_ZERO then
  begin
    R := AHSL.L;
    G := AHSL.L;
    B := AHSL.L;
  end
  else
  begin
    if (AHSL.L < 0.5) then
      Q := AHSL.L * (AHSL.S + 1.0)
    else
      Q := AHSL.L + AHSL.S - (AHSL.L * AHSL.S);
    P := 2.0 * AHSL.L - Q;
    TR := AHSL.H + (1 / 3);
    TG := AHSL.H;
    TB := AHSL.H - (1 / 3);
    if (TR < 0) then
      TR := TR + 1
    else if (TR > 1) then
      TR := TR - 1;
    if (TG < 0) then
      TG := TG + 1
    else if (TG > 1) then
      TG := TG - 1;
    if (TB < 0) then
      TB := TB + 1
    else if (TB > 1) then
      TB := TB - 1;
    R := ProcessColor(TR);
    G := ProcessColor(TG);
    B := ProcessColor(TB);
  end;
  result.rgbtRed := round(255 * R);
  result.rgbtGreen := round(255 * G);
  result.rgbtBlue := round(255 * B);
end;

class function TColorTools.RgbTripleToColor(ARgbTriple: TRGBTriple): TAlphaColor;
begin
  result := rgb(ARgbTriple.rgbtRed, ARgbTriple.rgbtGreen, ARgbTriple.rgbtBlue);
end;

class function TColorTools.ColorToGrayscale(AColor: TAlphaColor): TAlphaColor;
var
  avg: byte;
begin
  avg := (GetRValue(Acolor) + GetGValue(AColor) + GetBValue(AColor)) div 3;
  result := rgb(avg, avg, avg);
end;

class function TColorTools.ColorToRgbTriple(AColor: TAlphaColor): TRGBTriple;
begin
  result.rgbtRed := GetRValue(AColor);
  result.rgbtGreen := GetGValue(AColor);
  result.rgbtBlue := GetBValue(AColor);
end;
{ TGradientTools }


class procedure TGradientTools.HGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; rect: T2DIntRect);
var
  vert: array[0..1] of TRIVERTEX;
  gRect: _GRADIENT_RECT;
  Col1, Col2: TAlphaColor;
  locGradient: TGradient;
  ss: TCanvasSaveState;
  ARect: TRectF;
  fill: TBrush;
begin

    ss:= Canvas.SaveState;

    Canvas.BeginScene();

    fill:= TBrush.Create(TBrushKind.Gradient,cStart);
    locGradient := TGradient.Create;
    with locGradient do begin
      Color   := cStart;
      Color1  := cEnd;

      StartPosition .Y  := 0.5;

      StopPosition  .X  := 1;
      StopPosition  .Y  := 0.5;
    end;

    with Fill do
    begin
      Kind      := TBrushKind.Gradient;
      Gradient  := locGradient;
    end;

    ARect:= REctF(rect.Left, rect.Top, rect.Right, Rect.Bottom);

    Canvas.FillRect(ARect,  0, 0, AllCorners, 1.0, Fill);

    Canvas.EndScene;
    Canvas.RestoreState(ss);
//  Col1 := TAlphaColorRec.ColorToRGB(cStart);
//  Col2 := TAlphaColorRec.ColorToRGB(cEnd);
//  with vert[0] do
//  begin
//    x := rect.left;
//    y := rect.top;
//    Red := GetRValue(Col1) shl 8;
//    Green := GetGValue(Col1) shl 8;
//    Blue := GetBValue(Col1) shl 8;
//    Alpha := 0;
//  end;
//  with vert[1] do
//  begin
//    x := rect.right;
//    y := rect.bottom;
//    Red := GetRValue(Col2) shl 8;
//    Green := GetGValue(Col2) shl 8;
//    Blue := GetBValue(Col2) shl 8;
//    Alpha := 0;
//  end;
//  gRect.UpperLeft := 0;
//  gRect.LowerRight := 1;
//  GradientFill(canvas.Handle, vert[0], 2, @gRect, 1, GRADIENT_FILL_RECT_H);
end;

class procedure TGradientTools.HGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; p1, p2: TPoint);
begin
  HGradient(canvas, cstart, cend, T2DIntRect.Create(p1.x, p1.y, p2.x, p2.y));
end;

class procedure TGradientTools.HGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; x1, y1, x2, y2: integer);
begin
  HGradient(canvas, cstart, cend, t2dintrect.Create(x1, y1, x2, y2));
end;

class procedure TGradientTools.VGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; rect: T2DIntRect);
var
  vert: array[0..1] of TRIVERTEX;
  gRect: _GRADIENT_RECT;
  Col1, Col2: TAlphaColor;
  locGradient: TGradient;
  ss: TCanvasSaveState;
  ARect: TRectF;
  fill: TBrush;
begin

    ss:= Canvas.SaveState;

    Canvas.BeginScene();

    fill:= TBrush.Create(TBrushKind.Gradient,cStart);
    locGradient := TGradient.Create;
    with locGradient do begin
      Color   := cStart;
      Color1  := cEnd;

      StartPosition.X  := 0;
      StopPosition.X  := 0;
      StartPosition.Y  := 0;
      StopPosition.Y  := 1;

    end;

    with Fill do
    begin
      Kind      := TBrushKind.Gradient;
      Gradient  := locGradient;
    end;

    ARect:= REctF(rect.Left, rect.Top, rect.Right, Rect.Bottom);

    Canvas.FillRect( ARect,  0, 0, AllCorners, 1.0, Fill);

    Canvas.EndScene;
    Canvas.RestoreState(ss);
//  Col1 := TAlphaColorRec.ColorToRGB(cStart);
//  Col2 := TAlphaColorRec.ColorToRGB(cEnd);
//  with vert[0] do
//  begin
//    x := rect.left;
//    y := rect.top;
//    Red := GetRValue(Col1) shl 8;
//    Green := GetGValue(Col1) shl 8;
//    Blue := GetBValue(Col1) shl 8;
//    Alpha := 0;
//  end;
//  with vert[1] do
//  begin
//    x := rect.right;
//    y := rect.bottom;
//    Red := GetRValue(Col2) shl 8;
//    Green := GetGValue(Col2) shl 8;
//    Blue := GetBValue(Col2) shl 8;
//    Alpha := 0;
//  end;
//  gRect.UpperLeft := 0;
//  gRect.LowerRight := 1;
//  GradientFill(canvas.Handle, vert[0], 2, @gRect, 1, GRADIENT_FILL_RECT_V);
end;

class procedure TGradientTools.VGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; p1, p2: TPoint);
begin
  VGradient(canvas, cstart, cend, t2dintrect.Create(p1.x, p1.y, p2.x, p2.y));
end;

class procedure TGradientTools.VGradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; x1, y1, x2, y2: integer);
begin
  VGradient(canvas, cstart, cend, t2dintrect.create(x1, y1, x2, y2));
end;

class procedure TGradientTools.Gradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; rect: T2DIntRect;
  GradientType: TGradientType);
begin
  if GradientType = gtVertical then
    VGradient(canvas, cStart, cEnd, rect)
  else
    HGradient(canvas, cStart, cEnd, rect);
end;

class procedure TGradientTools.Gradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; p1, p2: TPoint; GradientType:
  TGradientType);
begin
  if GradientType = gtVertical then
    VGradient(canvas, cStart, cEnd, p1, p2)
  else
    HGradient(canvas, cStart, cEnd, p1, p2);
end;

class procedure TGradientTools.Gradient(canvas: TCanvas; cStart, cEnd: TAlphaColor; x1, y1, x2, y2: integer;
  GradientType: TGradientType);
begin
  if GradientType = gtVertical then
    VGradient(canvas, cStart, cEnd, x1, y1, x2, y2)
  else
    HGradient(canvas, cStart, cEnd, x1, y1, x2, y2);
end;

class procedure TGradientTools.HGradientLine(canvas: TCanvas; cBase, cShade: TAlphaColor; x1, x2, y: integer;
  ShadeMode: TGradientLineShade);
var
  i: integer;
begin
  if x1 = x2 then
    exit;
  if x1 > x2 then
  begin
    i := x1;
    x1 := x2;
    x2 := i;
  end;
  case ShadeMode of
    lsShadeStart: HGradient(canvas, cShade, cBase, t2dintrect.create(x1, y, x2, y + 1));
    lsShadeEnds:
      begin
        i := (x1 + x2) div 2;
        HGradient(canvas, cShade, cBase, t2dintrect.create(x1, y, i, y + 1));
        HGradient(canvas, cBase, cShade, t2dintrect.create(i, y, x2, y + 1));
      end;
    lsShadeCenter:
      begin
        i := (x1 + x2) div 2;
        HGradient(canvas, cBase, cShade, t2dintrect.create(x1, y, i, y + 1));
        HGradient(canvas, cShade, cBase, t2dintrect.create(i, y, x2, y + 1));
      end;
    lsShadeEnd: HGradient(canvas, cBase, cShade, t2dintrect.create(x1, y, x2, y + 1));
  end;
end;

class procedure TGradientTools.VGradientLine(canvas: TCanvas; cBase, cShade: TAlphaColor; x, y1, y2: integer;
  ShadeMode: TGradientLineShade);
var
  i: integer;
begin
  if y1 = y2 then
    exit;
  if y1 > y2 then
  begin
    i := y1;
    y1 := y2;
    y2 := i;
  end;
  case ShadeMode of
    lsShadeStart: VGradient(canvas, cShade, cBase, t2dintrect.create(x, y1, x + 1, y2));
    lsShadeEnds:
      begin
        i := (y1 + y2) div 2;
        VGradient(canvas, cShade, cBase, t2dintrect.create(x, y1, x + 1, i));
        VGradient(canvas, cBase, cShade, t2dintrect.create(x, i, x + 1, y2));
      end;
    lsShadeCenter:
      begin
        i := (y1 + y2) div 2;
        VGradient(canvas, cBase, cShade, t2dintrect.create(x, y1, x + 1, i));
        VGradient(canvas, cShade, cBase, t2dintrect.create(x, i, x + 1, y2));
      end;
    lsShadeEnd: VGradient(canvas, cBase, cShade, t2dintrect.create(x, y1, x + 1, y2));
  end;
end;

class procedure TGradientTools.HGradient3dLine(canvas: TCanvas; x1, x2, y: integer; ShadeMode:
  TGradientLineShade; A3dKind: TGradient3dLine = glLowered);
begin
  if A3dKind = glRaised then
  begin
    HGradientLine(canvas, clBtnHighlight, clBtnFace, x1, x2, y, ShadeMode);
    HGradientLine(canvas, clBtnShadow, clBtnFace, x1, x2, y + 1, ShadeMode);
  end
  else
  begin
    HGradientLine(canvas, clBtnShadow, clBtnFace, x1, x2, y, ShadeMode);
    HGradientLine(canvas, clBtnHighlight, clBtnFace, x1, x2, y + 1, ShadeMode);
  end;
end;

class procedure TGradientTools.VGradient3dLine(canvas: TCanvas; x, y1, y2: integer; ShadeMode:
  TGradientLineShade; A3dKind: TGradient3dLine = glLowered);
begin
  if A3dKind = glLowered then
  begin
    VGradientLine(canvas, clBtnFace, clBtnHighlight, x, y1, y2, ShadeMode);
    VGradientLine(canvas, clBtnFace, clBtnShadow, x + 1, y1, y2, ShadeMode);
  end
  else
  begin
    VGradientLine(canvas, clBtnFace, clBtnShadow, x, y1, y2, ShadeMode);
    VGradientLine(canvas, clBtnFace, clBtnHighlight, x + 1, y1, y2, ShadeMode);
  end;
end;
{ TTextTools }

class procedure TTextTools.TextOut(FCanvas: TCanvas; X, Y: integer; Text: String);
begin
  if FCanvas = nil then
    exit;

  FCanvas.BeginScene;
  FCanvas.FillRect(
        TRectF.Create(X, Y, X+FCanvas.TextWidth(Text), Y+FCanvas.TextHeight(Text))
    ,0,0,AllCorners,200);
        FCanvas.FillText(
//      FillText(
                TRectF.Create(X, Y, X+FCanvas.TextWidth(Text), Y+FCanvas.TextHeight(Text)),
                Text, false, 100,[],
                TTextAlign.taLeading, TTextAlign.taCenter
        );
  FCanvas.EndScene;
end;

class procedure TTextTools.TextRect(FCanvas: TCanvas; const Rect: TRect; X, Y: Integer;
  const Text: String; TextAlign: TTextAlign; VerticalAlign: TTextAlign);
var
tr: TRectF;
begin
  tr:=TRectF.Create(Rect);
  FCanvas.BeginScene;
  FCanvas.FillRect(tr,0,0,AllCorners,200);
  FCanvas.FillText(
                tr,
                Text, false, 1,[],
                TextAlign, VerticalAlign
        );
  FCanvas.EndScene;
end;


class procedure TTextTools.OutlinedText(Canvas: TCanvas; x, y: integer; const text: string);
var
  ss: TCanvasSaveState;
begin
  ss:= Canvas.SaveState;

  Canvas.Fill.Kind := TBrushKind.None;
  Canvas.Stroke.Color := TAlphaColorRec.Black;
  Canvas.BeginScene();
  TextOut(Canvas, x - 1, y, text);
  TextOut(Canvas, x + 1, y, text);
  TextOut(Canvas, x, y - 1, text);
  TextOut(Canvas, x, y + 1, text);
  Canvas.EndScene;
  Canvas.RestoreState(ss);
end;
end.

