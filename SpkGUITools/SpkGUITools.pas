unit SpkGuiTools;

{$DEFINE SPKGUITOOLS}

interface

uses
  FMX.Graphics, SysUtils, Math, Classes, FMX.Controls, FMX.ImgList,
  SpkGraphTools, SpkMath, FMX.Utils, FMX.Types, System.types, System.UITypes;

type
  TCornerPos = (cpLeftTop, cpRightTop, cpLeftBottom, cpRightBottom);

  TCornerKind = (cpRound, cpNormal);

  TBackgroundKind = (bkSolid, bkVerticalGradient, bkHorizontalGradient, bkConcave);
  TCheckBoxState = (cbUnchecked, cbChecked, cbGrayed);
  TSpkCheckboxStyle = (cbsCheckbox, cbsRadioButton);

  TSpkButtonState = (bsIdle,
                        bsBtnHottrack, bsBtnPressed,
                        bsDropdownHottrack, bsDropdownPressed);

type
  TGUITools = class(TObject)
  private
  protected
    class procedure FillGradientRectangle(ACanvas: TCanvas; Rect: T2DIntRect; Radius: Integer; ColorFrom: TAlphaColor; ColorTo: TAlphaColor; GradientKind: TBackgroundKind; Corners: TCorners = [TCorner.TopLeft, TCorner.TopRight,
    TCorner.BottomLeft, TCorner.BottomRight]);

//    class procedure SaveClipRgn(DC: HDC; var OrgRgnExists: boolean; var OrgRgn: HRGN);
//    class procedure RestoreClipRgn(DC: HDC; OrgRgnExists: boolean; var OrgRgn: HRGN);
  public
    // *** Lines ***

    // Performance:
    // w/ClipRect:  Bitmap is faster (2x)
    // wo/ClipRect: Canvas is faster (a little)
    class procedure DrawHLine(ABitmap: TBitmap; x1, x2: integer; y: integer; Color: TAlphaColor); overload;
    class procedure DrawHLine(ABitmap: TBitmap; x1, x2: integer; y: integer; Color: TAlphaColor; ClipRect: T2DIntRect); overload;
    class procedure DrawHLine(ACanvas: TCanvas; x1, x2: integer; y: integer; Color: TAlphaColor); overload;
    class procedure DrawHLine(ACanvas: TCanvas; x1, x2: integer; y: integer; Color: TAlphaColor; ClipRect: T2DIntRect); overload;

    // Performance:
    // w/ClipRect:  Bitmap is faster (2x)
    // wo/ClipRect: Canvas is faster (a little)
    class procedure DrawVLine(ABitmap: TBitmap; x: integer; y1, y2: integer; Color: TAlphaColor); overload;
    class procedure DrawVLine(ABitmap: TBitmap; x: integer; y1, y2: integer; Color: TAlphaColor; ClipRect: T2DIntRect); overload;
    class procedure DrawVLine(ACanvas: TCanvas; x: integer; y1, y2: integer; Color: TAlphaColor); overload;
    class procedure DrawVLine(ACanvas: TCanvas; x: integer; y1, y2: integer; Color: TAlphaColor; ClipRect: T2DIntRect); overload;

    // *** Background and frame tools ***

    // Performance:
    // w/ClipRect:  Bitmap is faster (extremely)
    // wo/ClipRect: Bitmap is faster (extremely)
    class procedure DrawAARoundCorner(ABitmap: TBitmap; Point: T2DIntVector; Radius: integer; CornerPos: TCornerPos; Color: TAlphaColor); overload;
    class procedure DrawAARoundCorner(ABitmap: TBitmap; Point: T2DIntVector; Radius: integer; CornerPos: TCornerPos; Color: TAlphaColor; ClipRect: T2DIntRect); overload;

//    class procedure DrawAARoundCorner(ACanvas: TCanvas; Point: T2DIntVector; Radius: integer; CornerPos: TCornerPos; Color: TAlphaColor); overload;
//    class procedure DrawAARoundCorner(ACanvas: TCanvas; Point: T2DIntVector; Radius: integer; CornerPos: TCornerPos; Color: TAlphaColor; ClipRect: T2DIntRect); overload;

    // Performance:
    // w/ClipRect:  Bitmap is faster (extremely)
    // wo/ClipRect: Bitmap is faster (extremely)
    class procedure DrawAARoundFrame(ABitmap: TBitmap; Rect: T2DIntRect; Radius: integer; Color: TAlphaColor; Corners: TCorners = [TCorner.TopLeft, TCorner.TopRight,
    TCorner.BottomLeft, TCorner.BottomRight]); overload;
    class procedure DrawAARoundFrame(ABitmap: TBitmap; Rect: T2DIntRect; Radius: integer; Color: TAlphaColor; ClipRect: T2DIntRect; Corners: TCorners = [TCorner.TopLeft, TCorner.TopRight,
    TCorner.BottomLeft, TCorner.BottomRight]); overload;
//    class procedure DrawAARoundFrame(ACanvas: TCanvas; Rect: T2DIntRect; Radius: integer; Color: TAlphaColor); overload;
//    class procedure DrawAARoundFrame(ACanvas: TCanvas; Rect: T2DIntRect; Radius: integer; Color: TAlphaColor; ClipRect: T2DIntRect); overload;

    class procedure RenderBackground(ABuffer: TBitmap; Rect: T2DIntRect; Color1, Color2: TAlphaColor; BackgroundKind: TBackgroundKind);
//    class procedure CopyRoundCorner(ABuffer: TBitmap; ABitmap: TBitmap; SrcPoint: T2DIntVector; DstPoint: T2DIntVector; Radius: integer; CornerPos: TCornerPos; Convex: boolean = true); overload;
//    class procedure CopyRoundCorner(ABuffer: TBitmap;
//      ABitmap: TBitmap;
//      SrcPoint: T2DIntVector;
//      DstPoint: T2DIntVector;
//      Radius: integer;
//      CornerPos: TCornerPos;
//      ClipRect: T2DIntRect;
//      Convex: boolean = true); overload;
//
//    class procedure CopyCorner(ABuffer: TBitmap;
//      ABitmap: TBitmap;
//      SrcPoint: T2DIntVector;
//      DstPoint: T2DIntVector;
//      Radius: integer); overload;
//    class procedure CopyCorner(ABuffer: TBitmap;
//      ABitmap: TBitmap;
//      SrcPoint: T2DIntVector;
//      DstPoint: T2DIntVector;
//      Radius: integer;
//      ClipRect: T2DIntRect); overload;

//    class procedure CopyRectangle(ABuffer: TBitmap;
//      ABitmap: TBitmap;
//      SrcPoint: T2DIntVector;
//      DstPoint: T2DIntVector;
//      Width: integer;
//      Height: integer); overload;
//    class procedure CopyRectangle(ABuffer: TBitmap;
//      ABitmap: TBitmap;
//      SrcPoint: T2DIntVector;
//      DstPoint: T2DIntVector;
//      Width: integer;
//      Height: integer;
//      ClipRect: T2DIntRect); overload;
//    class procedure CopyMaskRectangle(ABuffer: TBitmap;
//      AMask: TBitmap;
//      ABitmap: TBitmap;
//      SrcPoint: T2DIntVector;
//      DstPoint: T2DIntVector;
//      Width: integer;
//      Height: integer); overload;
//    class procedure CopyMaskRectangle(ABuffer: TBitmap;
//      AMask: TBitmap;
//      ABitmap: TBitmap;
//      SrcPoint: T2DIntVector;
//      DstPoint: T2DIntVector;
//      Width: integer;
//      Height: integer;
//      ClipRect: T2DIntRect); overload;

    // Performance (RenderBackground + CopyRoundRect vs DrawRoundRect):
    // w/ClipRect  : Bitmap faster for smaller radiuses, Canvas faster for larger
    // wo/ClipRect : Bitmap faster for smaller radiuses, Canvas faster for larger
//    class procedure CopyRoundRect(ABuffer: TBitmap;
//      ABitmap: TBitmap;
//      SrcPoint: T2DIntVector;
//      DstPoint: T2DIntVector;
//      Width, Height: integer;
//      Radius: integer;
//      LeftTopRound: boolean = true;
//      RightTopRound: boolean = true;
//      LeftBottomRound: boolean = true;
//      RightBottomRound: boolean = true); overload;
//    class procedure CopyRoundRect(ABuffer: TBitmap;
//      ABitmap: TBitmap;
//      SrcPoint: T2DIntVector;
//      DstPoint: T2DIntVector;
//      Width, Height: integer;
//      Radius: integer;
//      ClipRect: T2DIntRect;
//      LeftTopRound: boolean = true;
//      RightTopRound: boolean = true;
//      LeftBottomRound: boolean = true;
//      RightBottomRound: boolean = true); overload;

    class procedure DrawRoundRect(ACanvas: TCanvas; Rect: T2DIntRect; Radius: integer; ColorFrom: TAlphaColor; ColorTo: TAlphaColor; GradientKind: TBackgroundKind; LeftTopRound: boolean = true; RightTopRound: boolean = true; LeftBottomRound: boolean = true; RightBottomRound: boolean = true); overload;
    class procedure DrawRoundRect(ACanvas: TCanvas; Rect: T2DIntRect; Radius: integer; ColorFrom: TAlphaColor; ColorTo: TAlphaColor; GradientKind: TBackgroundKind; ClipRect: T2DIntRect; LeftTopRound: boolean = true; RightTopRound: boolean = true; LeftBottomRound: boolean = true; RightBottomRound: boolean = true); overload;
    class procedure DrawRegion(ACanvas: TCanvas;
//      Region: HRGN;
      Region: TRectF;
      Rect: T2DIntRect; Radius: Integer; ColorFrom: TAlphaColor; ColorTo: TAlphaColor; GradientKind: TBackgroundKind; Corners: TCorners = [TCorner.TopLeft, TCorner.TopRight,
    TCorner.BottomLeft, TCorner.BottomRight]); overload;
    class procedure DrawRegion(ACanvas: TCanvas;
//      Region: HRGN;
      Region: TRectF;
      Rect: T2DIntRect; Radius: Integer; ColorFrom: TAlphaColor; ColorTo: TAlphaColor; GradientKind: TBackgroundKind; ClipRect: T2DIntRect; Corners: TCorners = [TCorner.TopLeft, TCorner.TopRight,
    TCorner.BottomLeft, TCorner.BottomRight]); overload;

    // Imagelist tools
    class procedure DrawImage(ABitmap: TBitmap; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector); overload;
    class procedure DrawImage(ABitmap: TBitmap; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector; ClipRect: T2DIntRect); overload;
    class procedure DrawImage(ACanvas: TCanvas; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector); overload;
    class procedure DrawImage(ACanvas: TCanvas; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector; ClipRect: T2DIntRect); overload;
    class procedure DrawDisabledImage(ABitmap: TBitmap; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector); overload;
    class procedure DrawDisabledImage(ABitmap: TBitmap; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector; ClipRect: T2DIntRect); overload;
    class procedure DrawDisabledImage(ACanvas: TCanvas; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector); overload;
    class procedure DrawDisabledImage(ACanvas: TCanvas; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector; ClipRect: T2DIntRect); overload;

    class procedure DrawCheckbox(ACanvas: TCanvas;
                                 x,y: Integer;
                                 AState: TCheckboxState;
                                 AButtonState: TSpkButtonState;
                                 AStyle: TSpkCheckboxStyle); overload;
    class procedure DrawCheckbox(ACanvas: TCanvas;
                                 x,y: Integer;
                                 AState: TCheckboxState;
                                 AButtonState: TSpkButtonState;
                                 AStyle: TSpkCheckboxStyle;
                                 ClipRect: T2DIntRect); overload;

    // Draw tab
    class procedure DrawTab(ABitmap: TBitmap; RoundTab: T2DIntRect; Radius: Integer; Border, ColorFrom, ColorTo: TAlphaColor);
    // Text tools
    class procedure DrawText(ABitmap: TBitmap; x, y: integer; AText: string; TextColor: TAlphaColor); overload;
    class procedure DrawText(ABitmap: TBitmap; x, y: integer; AText: string; TextColor: TAlphaColor; ClipRect: T2DIntRect); overload;
    class procedure DrawMarkedText(ACanvas: TCanvas; x, y: integer; AText: string; AMarkPhrase: string; TextColor: TAlphaColor; CaseSensitive: boolean = false); overload;
    class procedure DrawMarkedText(ACanvas: TCanvas; x, y: integer; AText: string; AMarkPhrase: string; TextColor: TAlphaColor; ClipRect: T2DIntRect; CaseSensitive: boolean = false); overload;
    class procedure DrawText(ACanvas: TCanvas; x, y: integer; AText: string; TextColor: TAlphaColor); overload;
    class procedure DrawText(ACanvas: TCanvas; x, y: integer; AText: string; TextColor: TAlphaColor; ClipRect: T2DIntRect); overload;
    class procedure DrawFitWText(ABitmap: TBitmap; x1, x2: integer; y: integer; AText: string; TextColor: TAlphaColor; Align: TAlignment); overload;
    class procedure DrawFitWText(ACanvas: TCanvas; x1, x2: integer; y: integer; AText: string; TextColor: TAlphaColor; Align: TAlignment); overload;
    class procedure DrawOutlinedText(ABitmap: TBitmap; x, y: integer; AText: string; TextColor: TAlphaColor; OutlineColor: TAlphaColor); overload;
    class procedure DrawOutlinedText(ABitmap: TBitmap; x, y: integer; AText: string; TextColor: TAlphaColor; OutlineColor: TAlphaColor; ClipRect: T2DIntRect); overload;
    class procedure DrawOutlinedText(ACanvas: TCanvas; x, y: integer; AText: string; TextColor: TAlphaColor; OutlineColor: TAlphaColor); overload;
    class procedure DrawOutlinedText(ACanvas: TCanvas; x, y: integer; AText: string; TextColor: TAlphaColor; OutlineColor: TAlphaColor; ClipRect: T2DIntRect); overload;
    class procedure DrawFitWOutlinedText(ABitmap: TBitmap; x1, x2: integer; y: integer; AText: string; TextColor, OutlineColor: TAlphaColor; Align: TAlignment); overload;
    class procedure DrawFitWOutlinedText(ACanvas: TCanvas; x1, x2: integer; y: integer; AText: string; TextColor, OutlineColor: TAlphaColor; Align: TAlignment); overload;
  end;

implementation

{ TSpkGUITools }

//class procedure TGUITools.CopyRoundCorner(ABuffer, ABitmap: TBitmap; SrcPoint,
//  DstPoint: T2DIntVector; Radius: integer; CornerPos: TCornerPos;
//  ClipRect: T2DIntRect; Convex: boolean);
//
//var
//  BufferRect, BitmapRect, TempRect2: T2DIntRect;
//  OrgSrcRect, UnClippedDstRect, OrgDstRect: T2DIntRect;
//  SrcRect: T2DIntRect;
//  Offset: T2DIntVector;
//  Center: T2DIntVector;
//  y: Integer;
//  SrcLine: Pointer;
//  DstLine: Pointer;
//  SrcPtr, DstPtr: PByte;
//  x: Integer;
//  Dist: double;
//
//begin
//  if (ABuffer.PixelFormat <>  pf24bit) or (ABitmap.PixelFormat <> pf24bit) then
//    raise exception.create('TSpkGUITools.CopyRoundCorner: Tylko 24-bitowe bitmapy s¹ akceptowane!');
//
//  // Sprawdzanie poprawnoœci
//  if Radius < 1 then
//    exit;
//
//  if (ABuffer.width = 0) or (ABuffer.height = 0) or
//    (ABitmap.width = 0) or (ABitmap.height = 0) then
//    exit;
//
//  BufferRect := T2DIntRect.create(0, 0, ABuffer.width - 1, ABuffer.height - 1);
//  if not (BufferRect.IntersectsWith(T2DIntRect.create(SrcPoint.x,
//    SrcPoint.y,
//    SrcPoint.x + Radius - 1,
//    SrcPoint.y + Radius - 1),
//    OrgSrcRect)) then
//    exit;
//
//  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
//  if not (BitmapRect.IntersectsWith(T2DIntRect.create(DstPoint.x,
//    DstPoint.y,
//    DstPoint.x + Radius - 1,
//    DstPoint.y + Radius - 1),
//    UnClippedDstRect)) then
//    exit;
//
//  if not (ClipRect.IntersectsWith(UnClippedDstRect, OrgDstRect)) then
//    exit;
//
//  //Offset:=DstPoint - SrcPoint;
//  Offset.x := DstPoint.x - SrcPoint.x;
//  Offset.y := DstPoint.y - SrcPoint.y;
//  TempRect2 := T2DIntRect.Create(OrgDstRect.Left - Offset.x, OrgDstRect.Top - Offset.y,
//    OrgDstRect.Right - Offset.x, OrgDstRect.Bottom - Offset.y);
//
//  if not (OrgSrcRect.IntersectsWith(TempRect2, SrcRect)) then
//    exit;
//
//  // Ustalamy pozycjê œrodka ³uku
//  case CornerPos of
//    cpLeftTop: Center := T2DIntVector.create(SrcPoint.x + radius - 1, SrcPoint.y + Radius - 1);
//    cpRightTop: Center := T2DIntVector.create(SrcPoint.x, SrcPoint.y + Radius - 1);
//    cpLeftBottom: Center := T2DIntVector.Create(SrcPoint.x + radius - 1, SrcPoint.y);
//    cpRightBottom: Center := T2DIntVector.Create(SrcPoint.x, SrcPoint.y);
//  end;
//
//  // Czy jest cokolwiek do przetworzenia?
//  if Convex then
//  begin
//    if (SrcRect.left <= SrcRect.right) and (SrcRect.top <= SrcRect.bottom) then
//      for y := SrcRect.top to SrcRect.bottom do
//      begin
//        SrcLine := ABuffer.ScanLine[y];
//        DstLine := ABitmap.ScanLine[y + Offset.y];
//
//        SrcPtr := pointer(integer(SrcLine) + 3 * SrcRect.left);
//        DstPtr := pointer(integer(DstLine) + 3 * (SrcRect.left + Offset.x));
//        for x := SrcRect.left to SrcRect.right do
//        begin
//          Dist := Center.DistanceTo(T2DIntVector.create(x, y));
//          if Dist <= (Radius - 1) then
//            Move(SrcPtr^, DstPtr^, 3);
//
//          inc(SrcPtr, 3);
//          inc(DstPtr, 3);
//        end;
//      end;
//  end
//  else
//  begin
//    if (SrcRect.left <= SrcRect.right) and (SrcRect.top <= SrcRect.bottom) then
//      for y := SrcRect.top to SrcRect.bottom do
//      begin
//        SrcLine := ABuffer.ScanLine[y];
//        DstLine := ABitmap.ScanLine[y + Offset.y];
//
//        SrcPtr := pointer(integer(SrcLine) + 3 * SrcRect.left);
//        DstPtr := pointer(integer(DstLine) + 3 * (SrcRect.left + Offset.x));
//        for x := SrcRect.left to SrcRect.right do
//        begin
//          Dist := Center.DistanceTo(T2DIntVector.create(x, y));
//          if Dist >= (Radius - 1) then
//            Move(SrcPtr^, DstPtr^, 3);
//
//          inc(SrcPtr, 3);
//          inc(DstPtr, 3);
//        end;
//      end;
//  end;
//end;
//
//class procedure TGUITools.CopyRoundRect(ABuffer, ABitmap: TBitmap; SrcPoint,
//  DstPoint: T2DIntVector; Width, Height, Radius: integer; ClipRect: T2DIntRect;
//  LeftTopRound, RightTopRound, LeftBottomRound, RightBottomRound: boolean);
//
//begin
//  if (ABuffer.PixelFormat <> pf24bit) or (ABitmap.PixelFormat <> pf24bit) then
//    raise exception.create('TSpkGUITools.CopyBackground: Tylko 24-bitowe bitmapy s¹ akceptowane!');
//
//  // Sprawdzamy poprawnoœæ
//  if Radius < 0 then
//    exit;
//
//  if (Radius > Width div 2) or (Radius > Height div 2) then
//    exit;
//
//  if (ABuffer.width = 0) or (ABuffer.height = 0) or
//    (ABitmap.width = 0) or (ABitmap.height = 0) then
//    exit;
//
//  // Góra
//  CopyRectangle(ABuffer,
//    ABitmap,
//    T2DIntPoint.create(SrcPoint.x + radius, SrcPoint.y),
//    T2DIntPoint.create(DstPoint.x + radius, DstPoint.y),
//    width - 2 * radius,
//    radius,
//    ClipRect);
//  // Dó³
//  CopyRectangle(ABuffer,
//    ABitmap,
//    T2DIntPoint.create(SrcPoint.x + radius, SrcPoint.y + height - radius),
//    T2DIntPoint.create(DstPoint.x + radius, DstPoint.y + height - radius),
//    width - 2 * radius,
//    radius,
//    ClipRect);
//  // Œrodek
//  CopyRectangle(ABuffer,
//    ABitmap,
//    T2DIntPoint.create(SrcPoint.x, SrcPoint.y + radius),
//    T2DIntPoint.create(DstPoint.x, DstPoint.y + radius),
//    width,
//    height - 2 * radius,
//    ClipRect);
//
//  // Wype³niamy naro¿niki
//
//  if LeftTopRound then
//    TGUITools.CopyRoundCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x, SrcPoint.y),
//      T2DIntPoint.Create(DstPoint.x, DstPoint.y),
//      Radius,
//      cpLeftTop,
//      ClipRect,
//      true)
//  else
//    TGUITools.CopyCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x, SrcPoint.y),
//      T2DIntPoint.Create(DstPoint.x, DstPoint.y),
//      Radius,
//      ClipRect);
//  if RightTopRound then
//    TGUITools.CopyRoundCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y),
//      T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y),
//      Radius,
//      cpRightTop,
//      ClipRect,
//      true)
//  else
//    TGUITools.CopyCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y),
//      T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y),
//      Radius,
//      ClipRect);
//  if LeftBottomRound then
//    TGUITools.CopyRoundCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x, SrcPoint.y + Height - Radius),
//      T2DIntPoint.Create(DstPoint.x, DstPoint.y + Height - Radius),
//      Radius,
//      cpLeftBottom,
//      ClipRect,
//      true)
//  else
//    TGUITools.CopyCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x, SrcPoint.y + Height - Radius),
//      T2DIntPoint.Create(DstPoint.x, DstPoint.y + Height - Radius),
//      Radius,
//      ClipRect);
//  if RightBottomRound then
//    TGUITools.CopyRoundCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y + Height - Radius),
//      T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y + Height - Radius),
//      Radius,
//      cpRightBottom,
//      ClipRect,
//      true)
//  else
//    TGUITools.CopyCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y + Height - Radius),
//      T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y + Height - Radius),
//      Radius,
//      ClipRect);
//end;
//
//class procedure TGUITools.CopyRoundRect(ABuffer: TBitmap; ABitmap: TBitmap; SrcPoint,
//  DstPoint: T2DIntVector; Width, Height, Radius: integer; LeftTopRound,
//  RightTopRound, LeftBottomRound, RightBottomRound: boolean);
//
//begin
//  if (ABuffer.PixelFormat <> pf24bit) or (ABitmap.PixelFormat <> pf24bit) then
//    raise exception.create('TSpkGUITools.CopyBackground: Tylko 24-bitowe bitmapy s¹ akceptowane!');
//
//  // Sprawdzamy poprawnoœæ
//  if Radius < 0 then
//    exit;
//
//  if (Radius > Width div 2) or (Radius > Height div 2) then
//    exit;
//
//  if (ABuffer.width = 0) or (ABuffer.height = 0) or
//    (ABitmap.width = 0) or (ABitmap.height = 0) then
//    exit;
//
//  // Góra
//  CopyRectangle(ABuffer,
//    ABitmap,
//    T2DIntPoint.create(SrcPoint.x + radius, SrcPoint.y),
//    T2DIntPoint.create(DstPoint.x + radius, DstPoint.y),
//    width - 2 * radius,
//    radius);
//  // Dó³
//  CopyRectangle(ABuffer,
//    ABitmap,
//    T2DIntPoint.create(SrcPoint.x + radius, SrcPoint.y + height - radius),
//    T2DIntPoint.create(DstPoint.x + radius, DstPoint.y + height - radius),
//    width - 2 * radius,
//    radius);
//  // Œrodek
//  CopyRectangle(ABuffer,
//    ABitmap,
//    T2DIntPoint.create(SrcPoint.x, SrcPoint.y + radius),
//    T2DIntPoint.create(DstPoint.x, DstPoint.y + radius),
//    width,
//    height - 2 * radius);
//  if LeftTopRound then
//    TGUITools.CopyRoundCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x, SrcPoint.y),
//      T2DIntPoint.Create(DstPoint.x, DstPoint.y),
//      Radius,
//      cpLeftTop,
//      true)
//  else
//    TGUITools.CopyCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x, SrcPoint.y),
//      T2DIntPoint.Create(DstPoint.x, DstPoint.y),
//      Radius);
//  if RightTopRound then
//    TGUITools.CopyRoundCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y),
//      T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y),
//      Radius,
//      cpRightTop,
//      true)
//  else
//    TGUITools.CopyCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y),
//      T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y),
//      Radius);
//  if LeftBottomRound then
//    TGUITools.CopyRoundCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x, SrcPoint.y + Height - Radius),
//      T2DIntPoint.Create(DstPoint.x, DstPoint.y + Height - Radius),
//      Radius,
//      cpLeftBottom,
//      true)
//  else
//    TGUITools.CopyCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x, SrcPoint.y + Height - Radius),
//      T2DIntPoint.Create(DstPoint.x, DstPoint.y + Height - Radius),
//      Radius);
//  if RightBottomRound then
//    TGUITools.CopyRoundCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y + Height - Radius),
//      T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y + Height - Radius),
//      Radius,
//      cpRightBottom,
//      true)
//  else
//    TGUITools.CopyCorner(ABuffer,
//      ABitmap,
//      T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y + Height - Radius),
//      T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y + Height - Radius),
//      Radius);
//end;
//
//class procedure TGUITools.CopyRectangle(ABuffer, ABitmap: TBitmap; SrcPoint,
//  DstPoint: T2DIntVector; Width, Height: integer);
//
//var
//  BufferRect, BitmapRect, TempRect2: T2DIntRect;
//  SrcRect, DstRect: T2DIntRect;
//  ClippedSrcRect: T2DIntRect;
//  Offset: T2DIntVector;
//  y: Integer;
//  SrcLine: Pointer;
//  DstLine: Pointer;
//
//begin
//  if (ABuffer.PixelFormat <> pf24bit) or (ABitmap.PixelFormat <> pf24bit) then
//    raise exception.create('TSpkGUITools.CopyRoundCorner: Tylko 24-bitowe bitmapy s¹ akceptowane!');
//
//  // Sprawdzanie poprawnoœci
//  if (Width < 1) or (Height < 1) then
//    exit;
//
//  if (ABuffer.width = 0) or (ABuffer.height = 0) or
//    (ABitmap.width = 0) or (ABitmap.height = 0) then
//    exit;
//
//  // Przycinamy Ÿród³owy rect do obszaru Ÿród³owej bitmapy
//  BufferRect := T2DIntRect.create(0, 0, ABuffer.width - 1, ABuffer.height - 1);
//
//  if not (BufferRect.IntersectsWith(T2DIntRect.create(SrcPoint.x,
//    SrcPoint.y,
//    SrcPoint.x + Width - 1,
//    SrcPoint.y + Height - 1),
//    SrcRect)) then
//    exit;
//
//  // Przycinamy docelowy rect do obszaru docelowej bitmapy
//  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
//  if not (BitmapRect.IntersectsWith(T2DIntRect.create(DstPoint.x,
//    DstPoint.y,
//    DstPoint.x + Width - 1,
//    DstPoint.y + Height - 1),
//    DstRect)) then
//    exit;
//
//  // Liczymy offset Ÿród³owego do docelowego recta
//  //Offset:=DstPoint - SrcPoint;
//  Offset.x := DstPoint.x - SrcPoint.x;
//  Offset.y := DstPoint.y - SrcPoint.y;
//  TempRect2 := T2DIntRect.Create(DstRect.Left - Offset.x, DstRect.Top - Offset.y,
//    DstRect.Right - Offset.x, DstRect.Bottom - Offset.y);
//
//  // Sprawdzamy, czy na³o¿one na siebie recty: Ÿród³owy i docelowy przesuniêty o
//  // offset maj¹ jak¹œ czêœæ wspóln¹
//  if not (SrcRect.IntersectsWith(TempRect2, ClippedSrcRect)) then
//    exit;
//
//  // Jeœli jest cokolwiek do przetworzenia, wykonaj operacjê
//  if (ClippedSrcRect.left <= ClippedSrcRect.right) and (ClippedSrcRect.top <= ClippedSrcRect.bottom) then
//    for y := ClippedSrcRect.top to ClippedSrcRect.bottom do
//    begin
//      SrcLine := ABuffer.ScanLine[y];
//      DstLine := ABitmap.ScanLine[y + Offset.y];
//
//      Move(pointer(integer(SrcLine) + 3 * ClippedSrcRect.left)^,
//        pointer(integer(DstLine) + 3 * (ClippedSrcRect.left + Offset.x))^,
//        3 * ClippedSrcRect.Width);
//    end;
//end;
//
//class procedure TGUITools.CopyCorner(ABuffer: TBitmap; ABitmap: TBitmap;
//  SrcPoint, DstPoint: T2DIntVector; Radius: integer);
//
//begin
//  CopyRectangle(ABuffer, ABitmap, SrcPoint, DstPoint, Radius, Radius);
//end;
//
//class procedure TGUITools.CopyCorner(ABuffer, ABitmap: TBitmap; SrcPoint,
//  DstPoint: T2DIntVector; Radius: integer; ClipRect: T2DIntRect);
//begin
//  CopyRectangle(ABuffer, ABitmap, SrcPoint, DstPoint, Radius, Radius, ClipRect);
//end;
//
//class procedure TGUITools.CopyMaskRectangle(ABuffer, AMask, ABitmap: TBitmap;
//  SrcPoint, DstPoint: T2DIntVector; Width, Height: integer);
//
//var
//  BufferRect, BitmapRect, TempRect2: T2DIntRect;
//  SrcRect, DstRect: T2DIntRect;
//  ClippedSrcRect: T2DIntRect;
//  Offset: T2DIntVector;
//  y: Integer;
//  SrcLine: Pointer;
//  MaskLine: Pointer;
//  DstLine: Pointer;
//  i: Integer;
//
//begin
//  if (ABuffer.PixelFormat <> pf24bit) or (ABitmap.PixelFormat <> pf24bit) then
//    raise exception.create('TSpkGUITools.CopyRoundCorner: Tylko 24-bitowe bitmapy s¹ akceptowane!');
//
//  if (AMask.PixelFormat <> pf8bit) then
//    raise exception.create('TSpkGUITools.CopyRoundCorner: Tylko 8-bitowe maski s¹ akceptowane!');
//
//  // Sprawdzanie poprawnoœci
//  if (Width < 1) or (Height < 1) then
//    exit;
//
//  if (ABuffer.width = 0) or (ABuffer.height = 0) or
//    (ABitmap.width = 0) or (ABitmap.height = 0) then
//    exit;
//
//  if (ABuffer.Width <> AMask.Width) or
//    (ABuffer.Height <> AMask.Height) then
//    exit;
//
//  // Przycinamy Ÿród³owy rect do obszaru Ÿród³owej bitmapy
//  BufferRect := T2DIntRect.create(0, 0, ABuffer.width - 1, ABuffer.height - 1);
//
//  if not (BufferRect.IntersectsWith(T2DIntRect.create(SrcPoint.x,
//    SrcPoint.y,
//    SrcPoint.x + Width - 1,
//    SrcPoint.y + Height - 1),
//    SrcRect)) then
//    exit;
//
//  // Przycinamy docelowy rect do obszaru docelowej bitmapy
//  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
//  if not (BitmapRect.IntersectsWith(T2DIntRect.create(DstPoint.x,
//    DstPoint.y,
//    DstPoint.x + Width - 1,
//    DstPoint.y + Height - 1),
//    DstRect)) then
//    exit;
//
//  // Liczymy offset Ÿród³owego do docelowego recta
//  //Offset:=DstPoint - SrcPoint;
//
//  Offset.x := DstPoint.x - SrcPoint.x;
//  Offset.y := DstPoint.y - SrcPoint.y;
//  TempRect2 := T2DIntRect.Create(DstRect.Left - Offset.x, DstRect.Top - Offset.y,
//    DstRect.Right - Offset.x, DstRect.Bottom - Offset.y);
//
//  // Sprawdzamy, czy na³o¿one na siebie recty: Ÿród³owy i docelowy przesuniêty o
//  // offset maj¹ jak¹œ czêœæ wspóln¹
//  if not (SrcRect.IntersectsWith(TempRect2, ClippedSrcRect)) then
//    exit;
//
//  // Jeœli jest cokolwiek do przetworzenia, wykonaj operacjê
//  if (ClippedSrcRect.left <= ClippedSrcRect.right) and (ClippedSrcRect.top <= ClippedSrcRect.bottom) then
//    for y := ClippedSrcRect.top to ClippedSrcRect.bottom do
//    begin
//      SrcLine := ABuffer.ScanLine[y];
//      SrcLine := pointer(integer(SrcLine) + 3 * ClippedSrcRect.left);
//
//      MaskLine := AMask.ScanLine[y];
//      MaskLine := pointer(integer(MaskLine) + ClippedSrcRect.left);
//
//      DstLine := ABitmap.ScanLine[y + Offset.y];
//      DstLine := pointer(integer(DstLine) + 3 * (ClippedSrcRect.left + Offset.x));
//
//      for i := 0 to ClippedSrcRect.Width - 1 do
//      begin
//        if PByte(MaskLine)^ < 128 then
//          Move(SrcLine^, DstLine^, 3);
//
//        SrcLine := pointer(integer(SrcLine) + 3);
//        DstLine := pointer(integer(DstLine) + 3);
//        MaskLine := pointer(integer(MaskLine) + 1);
//      end;
//    end;
//end;
//
//class procedure TGUITools.CopyMaskRectangle(ABuffer, AMask, ABitmap: TBitmap;
//  SrcPoint, DstPoint: T2DIntVector; Width, Height: integer;
//  ClipRect: T2DIntRect);
//
//var
//  BufferRect, BitmapRect, TempRect2: T2DIntRect;
//  SrcRect, DstRect: T2DIntRect;
//  ClippedSrcRect, ClippedDstRect: T2DIntRect;
//  Offset: T2DIntVector;
//  y: Integer;
//  SrcLine: Pointer;
//  DstLine: Pointer;
//  i: Integer;
//  MaskLine: Pointer;
//
//begin
//  if (ABuffer.PixelFormat <> pf24bit) or (ABitmap.PixelFormat <> pf24bit) then
//    raise exception.create('TSpkGUITools.CopyMaskRectangle: Tylko 24-bitowe bitmapy s¹ akceptowane!');
//  if AMask.PixelFormat <> pf8bit then
//    raise exception.create('TSpkGUITools.CopyMaskRectangle: Tylko 8-bitowe maski s¹ akceptowane!');
//
//  // Sprawdzanie poprawnoœci
//  if (Width < 1) or (Height < 1) then
//    exit;
//
//  if (ABuffer.width = 0) or (ABuffer.height = 0) or
//    (ABitmap.width = 0) or (ABitmap.height = 0) then
//    exit;
//
//  if (ABuffer.Width <> AMask.Width) or
//    (ABuffer.Height <> AMask.Height) then
//    raise exception.create('TSpkGUITools.CopyMaskRectangle: Maska ma nieprawid³owe rozmiary!');
//
//  // Przycinamy Ÿród³owy rect do obszaru Ÿród³owej bitmapy
//  BufferRect := T2DIntRect.create(0, 0, ABuffer.width - 1, ABuffer.height - 1);
//  if not (BufferRect.IntersectsWith(T2DIntRect.create(SrcPoint.x,
//    SrcPoint.y,
//    SrcPoint.x + Width - 1,
//    SrcPoint.y + Height - 1),
//    SrcRect)) then
//    exit;
//
//  // Przycinamy docelowy rect do obszaru docelowej bitmapy
//  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
//  if not (BitmapRect.IntersectsWith(T2DIntRect.create(DstPoint.x,
//    DstPoint.y,
//    DstPoint.x + Width - 1,
//    DstPoint.y + Height - 1),
//    DstRect)) then
//    exit;
//
//  // Dodatkowo przycinamy docelowy rect
//  if not (DstRect.IntersectsWith(ClipRect, ClippedDstRect)) then
//    Exit;
//
//  // Liczymy offset Ÿród³owego do docelowego recta
//  //Offset:=DstPoint - SrcPoint;
//  Offset.x := DstPoint.x - SrcPoint.x;
//  Offset.y := DstPoint.y - SrcPoint.y;
//  TempRect2 := T2DIntRect.Create(DstRect.Left - Offset.x, DstRect.Top - Offset.y,
//    DstRect.Right - Offset.x, DstRect.Bottom - Offset.y);
//
//  // Sprawdzamy, czy na³o¿one na siebie recty: Ÿród³owy i docelowy przesuniêty o
//  // offset maj¹ jak¹œ czêœæ wspóln¹
//  if not (SrcRect.IntersectsWith(TempRect2, ClippedSrcRect)) then
//    exit;
//
//  // Jeœli jest cokolwiek do przetworzenia, wykonaj operacjê
//  if (ClippedSrcRect.left <= ClippedSrcRect.right) and (ClippedSrcRect.top <= ClippedSrcRect.bottom) then
//    for y := ClippedSrcRect.top to ClippedSrcRect.bottom do
//    begin
//      SrcLine := ABuffer.ScanLine[y];
//      SrcLine := pointer(integer(SrcLine) + 3 * ClippedSrcRect.left);
//
//      MaskLine := AMask.ScanLine[y];
//      MaskLine := pointer(integer(MaskLine) + ClippedSrcRect.left);
//
//      DstLine := ABitmap.ScanLine[y + Offset.y];
//      DstLine := pointer(integer(DstLine) + 3 * (ClippedSrcRect.left + Offset.x));
//
//      for i := 0 to ClippedSrcRect.width - 1 do
//      begin
//        if PByte(MaskLine)^ < 128 then
//          Move(SrcLine^, DstLine^, 3);
//
//        SrcLine := pointer(integer(SrcLine) + 3);
//        DstLine := pointer(integer(DstLine) + 3);
//        MaskLine := pointer(integer(MaskLine) + 1);
//      end;
//    end;
//end;
//
//class procedure TGUITools.CopyRectangle(ABuffer, ABitmap: TBitmap; SrcPoint,
//  DstPoint: T2DIntVector; Width, Height: integer; ClipRect: T2DIntRect);
//
//var
//  BufferRect, BitmapRect, TempRect2: T2DIntRect;
//  SrcRect, DstRect: T2DIntRect;
//  ClippedSrcRect, ClippedDstRect: T2DIntRect;
//  Offset: T2DIntVector;
//  y: Integer;
//  SrcLine: Pointer;
//  DstLine: Pointer;
//
//begin
//  if (ABuffer.PixelFormat <> pf24bit) or (ABitmap.PixelFormat <> pf24bit) then
//    raise exception.create('TSpkGUITools.CopyRoundCorner: Tylko 24-bitowe bitmapy s¹ akceptowane!');
//
//  // Sprawdzanie poprawnoœci
//  if (Width < 1) or (Height < 1) then
//    exit;
//
//  if (ABuffer.width = 0) or (ABuffer.height = 0) or
//    (ABitmap.width = 0) or (ABitmap.height = 0) then
//    exit;
//
//  // Przycinamy Ÿród³owy rect do obszaru Ÿród³owej bitmapy
//  BufferRect := T2DIntRect.create(0, 0, ABuffer.width - 1, ABuffer.height - 1);
//  if not (BufferRect.IntersectsWith(T2DIntRect.create(SrcPoint.x,
//    SrcPoint.y,
//    SrcPoint.x + Width - 1,
//    SrcPoint.y + Height - 1),
//    SrcRect)) then
//    exit;
//
//  // Przycinamy docelowy rect do obszaru docelowej bitmapy
//  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
//  if not (BitmapRect.IntersectsWith(T2DIntRect.create(DstPoint.x,
//    DstPoint.y,
//    DstPoint.x + Width - 1,
//    DstPoint.y + Height - 1),
//    DstRect)) then
//    exit;
//
//  // Dodatkowo przycinamy docelowy rect
//  if not (DstRect.IntersectsWith(ClipRect, ClippedDstRect)) then
//    Exit;
//
//  // Liczymy offset Ÿród³owego do docelowego recta
//  //Offset:=DstPoint - SrcPoint;
//  Offset.x := DstPoint.x - SrcPoint.x;
//  Offset.y := DstPoint.y - SrcPoint.y;
//  TempRect2 := T2DIntRect.Create(DstRect.Left - Offset.x, DstRect.Top - Offset.y,
//    DstRect.Right - Offset.x, DstRect.Bottom - Offset.y);
//
//  // Sprawdzamy, czy na³o¿one na siebie recty: Ÿród³owy i docelowy przesuniêty o
//  // offset maj¹ jak¹œ czêœæ wspóln¹
//  if not (SrcRect.IntersectsWith(TempRect2, ClippedSrcRect)) then
//    exit;
//
//  // Jeœli jest cokolwiek do przetworzenia, wykonaj operacjê
//  if (ClippedSrcRect.left <= ClippedSrcRect.right) and (ClippedSrcRect.top <= ClippedSrcRect.bottom) then
//    for y := ClippedSrcRect.top to ClippedSrcRect.bottom do
//    begin
//      SrcLine := ABuffer.ScanLine[y];
//      DstLine := ABitmap.ScanLine[y + Offset.y];
//
//      Move(pointer(integer(SrcLine) + 3 * ClippedSrcRect.left)^,
//        pointer(integer(DstLine) + 3 * (ClippedSrcRect.left + Offset.x))^,
//        3 * ClippedSrcRect.Width);
//    end;
//end;
//
//class procedure TGUITools.CopyRoundCorner(ABuffer: TBitmap; ABitmap: TBitmap;
//  SrcPoint, DstPoint: T2DIntVector; Radius: integer; CornerPos: TCornerPos;
//  Convex: boolean);
//
//var
//  BufferRect, BitmapRect, TempRect2: T2DIntRect;
//  OrgSrcRect, OrgDstRect: T2DIntRect;
//  SrcRect: T2DIntRect;
//  Offset: T2DIntVector;
//  Center: T2DIntVector;
//  y: Integer;
//  SrcLine: Pointer;
//  DstLine: Pointer;
//  SrcPtr, DstPtr: PByte;
//  x: Integer;
//  Dist: double;
//
//begin
//  if (ABuffer.PixelFormat <> pf24bit) or (ABitmap.PixelFormat <> pf24bit) then
//    raise exception.create('TSpkGUITools.CopyRoundCorner: Tylko 24-bitowe bitmapy s¹ akceptowane!');
//
//  // Sprawdzanie poprawnoœci
//  if Radius < 1 then
//    exit;
//
//  if (ABuffer.width = 0) or (ABuffer.height = 0) or
//    (ABitmap.width = 0) or (ABitmap.height = 0) then
//    exit;
//
//  BufferRect := T2DIntRect.create(0, 0, ABuffer.width - 1, ABuffer.height - 1);
//  if not (BufferRect.IntersectsWith(T2DIntRect.create(SrcPoint.x,
//    SrcPoint.y,
//    SrcPoint.x + Radius - 1,
//    SrcPoint.y + Radius - 1),
//    OrgSrcRect)) then
//    exit;
//
//  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
//  if not (BitmapRect.IntersectsWith(T2DIntRect.create(DstPoint.x,
//    DstPoint.y,
//    DstPoint.x + Radius - 1,
//    DstPoint.y + Radius - 1),
//    OrgDstRect)) then
//    exit;
//
//  //Offset:=DstPoint - SrcPoint;
//  Offset.x := DstPoint.x - SrcPoint.x;
//  Offset.y := DstPoint.y - SrcPoint.y;
//  TempRect2 := T2DIntRect.Create(OrgDstRect.Left - Offset.x, OrgDstRect.Top - Offset.y,
//    OrgDstRect.Right - Offset.x, OrgDstRect.Bottom - Offset.y);
//
//  if not (OrgSrcRect.IntersectsWith(TempRect2, SrcRect)) then
//    exit;
//
//  // Ustalamy pozycjê œrodka ³uku
//
//  case CornerPos of
//    cpLeftTop: Center := T2DIntVector.create(SrcPoint.x + radius - 1, SrcPoint.y + Radius - 1);
//    cpRightTop: Center := T2DIntVector.create(SrcPoint.x, SrcPoint.y + Radius - 1);
//    cpLeftBottom: Center := T2DIntVector.Create(SrcPoint.x + radius - 1, SrcPoint.y);
//    cpRightBottom: Center := T2DIntVector.Create(SrcPoint.x, SrcPoint.y);
//  end;
//
//  // Czy jest cokolwiek do przetworzenia?
//  if Convex then
//  begin
//    if (SrcRect.left <= SrcRect.right) and (SrcRect.top <= SrcRect.bottom) then
//      for y := SrcRect.top to SrcRect.bottom do
//      begin
//        SrcLine := ABuffer.ScanLine[y];
//        DstLine := ABitmap.ScanLine[y + Offset.y];
//
//        SrcPtr := pointer(integer(SrcLine) + 3 * SrcRect.left);
//        DstPtr := pointer(integer(DstLine) + 3 * (SrcRect.left + Offset.x));
//        for x := SrcRect.left to SrcRect.right do
//        begin
//          Dist := Center.DistanceTo(T2DIntVector.create(x, y));
//          if Dist <= (Radius - 1) then
//            Move(SrcPtr^, DstPtr^, 3);
//
//          inc(SrcPtr, 3);
//          inc(DstPtr, 3);
//        end;
//      end;
//  end
//  else
//  begin
//    if (SrcRect.left <= SrcRect.right) and (SrcRect.top <= SrcRect.bottom) then
//      for y := SrcRect.top to SrcRect.bottom do
//      begin
//        SrcLine := ABuffer.ScanLine[y];
//        DstLine := ABitmap.ScanLine[y + Offset.y];
//
//        SrcPtr := pointer(integer(SrcLine) + 3 * SrcRect.left);
//        DstPtr := pointer(integer(DstLine) + 3 * (SrcRect.left + Offset.x));
//        for x := SrcRect.left to SrcRect.right do
//        begin
//          Dist := Center.DistanceTo(T2DIntVector.create(x, y));
//          if Dist >= (Radius - 1) then
//            Move(SrcPtr^, DstPtr^, 3);
//
//          inc(SrcPtr, 3);
//          inc(DstPtr, 3);
//        end;
//      end;
//  end;
//end;

class procedure TGUITools.DrawAARoundCorner(ABitmap: TBitmap; Point: T2DIntVector; Radius: integer; CornerPos: TCornerPos; Color: TAlphaColor);
var
  CornerRect: T2DIntRect;
  Center: TPointF;
  Line: PByte;
  Ptr: PByte;
  colorR, colorG, colorB: byte;
  x, y: integer;
  RadiusDist: double;
  OrgCornerRect: T2DIntRect;
  BitmapRect: T2DIntRect;
  bitData: TBitmapData;
  p: PAlphaColorArray;
  tmpcolor: TAlphaColor;
  sta, swa: Single;

begin
//  if ABitmap.PixelFormat <> pf24bit then
//    raise exception.create('TSpkGUITools.DrawAARoundCorner: Bitmapa musi byæ w trybie 24-bitowym!');

  // Sprawdzamy poprawnoœæ
//  Exit;

  if Radius < 1 then
    exit;
  if (ABitmap.width = 0) or (ABitmap.height = 0) then
    exit;

  // ród³owy rect...
  OrgCornerRect := T2DIntRect.create(Point.x, Point.y, Point.x + Radius - 1, Point.y + Radius - 1);

  // ...przycinamy do rozmiarów bitmapy
  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
  if not (BitmapRect.intersectsWith(OrgCornerRect, CornerRect)) then
    exit;

  // Jeœli nie ma czego rysowaæ, wychodzimy
  if (CornerRect.left > CornerRect.right) or (CornerRect.top > CornerRect.bottom) then
    exit;

  case CornerPos of
    cpLeftTop:
    begin
      Center := PointF(Point.x + Radius , Point.y + Radius );
      Center.Offset(0.5,0.5);
      sta:= 180;
      swa:=90;
    end;
    cpRightTop:
    begin
      Center := PointF(Point.x - 1, Point.y + Radius );
      Center.Offset(0.5,0.5);
      sta:= -90;
      swa:=90;
    end;
    cpLeftBottom:
    begin
      Center := PointF(Point.x + Radius , Point.y-1);
      Center.Offset(0.5,0.5);
      sta:= 90;
      swa:=90;
    end;
    cpRightBottom:
    begin
      Center := PointF(Point.x-1, Point.y-1);
      Center.Offset(0.5,0.5);
      sta:= 0;
      swa:=90;
    end;
  end;


  ABitmap.Canvas.BeginScene();
  ABitmap.Canvas.Stroke.Color:=Color;
  ABitmap.Canvas.Stroke.Kind:= TBrushKind.Solid;
  ABitmap.Canvas.DrawArc(PointF(Center.x, Center.y), PointF(Radius, Radius), sta, swa,1);
  ABitmap.Canvas.EndScene;


//  // Szukamy œrodka ³uku - zale¿nie od rodzaju naro¿nika
//  case CornerPos of
//    cpLeftTop:
//      Center := T2DIntVector.create(Point.x + Radius - 1, Point.y + Radius - 1);
//    cpRightTop:
//      Center := T2DIntVector.create(Point.x, Point.y + Radius - 1);
//    cpLeftBottom:
//      Center := T2DIntVector.Create(Point.x + Radius - 1, Point.y);
//    cpRightBottom:
//      Center := T2DIntVector.Create(Point.x, Point.y);
//  end;
//
////  Color := ColorToRGB(Color);
////
////  colorR := GetRValue(Color);
////  colorG := GetGValue(Color);
////  ColorB := GetBValue(Color);
//
//  if ABitmap.Map(TMapAccess.ReadWrite, bitData) then
//  try
//    for y := CornerRect.top to CornerRect.bottom do
//    begin
////    Line := ABitmap.ScanLine[y];
//      for x := CornerRect.left to CornerRect.right do
//      begin
//        RadiusDist := 1 - abs((Radius - 1) - Center.DistanceTo(T2DIntVector.create(x, y)));
//        if RadiusDist > 0 then
//        begin
//          tmpcolor:=bitData.GetPixel(x, y);
//          bitData.SetPixel(x, y, TColorTools.Shade(tmpcolor, Color, RadiusDist));
////          Ptr := pointer(integer(Line) + 3 * x);
////          Ptr^ := round(Ptr^ + (ColorB - Ptr^) * RadiusDist);
////          inc(Ptr);
////          Ptr^ := round(Ptr^ + (ColorG - Ptr^) * RadiusDist);
////          inc(Ptr);
////          Ptr^ := round(Ptr^ + (ColorR - Ptr^) * RadiusDist);
//        end;
//      end;
//    end;
//  finally
//    ABitmap.Unmap(bitData);
//  end;
end;

class procedure TGUITools.DrawAARoundCorner(ABitmap: TBitmap; Point: T2DIntVector; Radius: integer; CornerPos: TCornerPos; Color: TAlphaColor; ClipRect: T2DIntRect);
var
  CornerRect: T2DIntRect;
  Center: TPointF;
  Line: PByte;
  Ptr: PByte;
  colorR, colorG, colorB: byte;
  x, y: integer;
  RadiusDist: double;
  OrgCornerRect: T2DIntRect;
  UnClippedCornerRect: T2DIntRect;
  BitmapRect: T2DIntRect;
  bitData: TBitmapData;
  p: PAlphaColorArray;
  tmpcolor: TAlphaColor;
  sta, swa: Single;

begin
//  if ABitmap.PixelFormat <> pf24bit then
//    raise exception.create('TSpkGUITools.DrawAARoundCorner: Bitmapa musi byæ w trybie 24-bitowym!');

  // Sprawdzamy poprawnoœæ
//  Exit;
  if Radius < 1 then
    exit;
  if (ABitmap.width = 0) or (ABitmap.height = 0) then
    exit;

  //Radius:= Radius div 2;
  // ród³owy rect...
  OrgCornerRect := T2DIntRect.create(Point.x, Point.y, Point.x + Radius - 1, Point.y + Radius - 1);

  // ...przycinamy do rozmiarów bitmapy
  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
  if not (BitmapRect.intersectsWith(OrgCornerRect, UnClippedCornerRect)) then
    exit;

  // ClipRect
  if not (UnClippedCornerRect.IntersectsWith(ClipRect, CornerRect)) then
    exit;

  // Jeœli nie ma czego rysowaæ, wychodzimy
  if (CornerRect.left > CornerRect.right) or (CornerRect.top > CornerRect.bottom) then
    exit;

  // Szukamy œrodka ³uku - zale¿nie od rodzaju naro¿nika

  case CornerPos of
    cpLeftTop:
    begin
      Center := PointF(Point.x + Radius , Point.y + Radius );
      Center.Offset(0.5,0.5);
      sta:= 180;
      swa:=90;
    end;
    cpRightTop:
    begin
      Center := PointF(Point.x - 1, Point.y + Radius );
      Center.Offset(0.5,0.5);
      sta:= -90;
      swa:=90;
    end;
    cpLeftBottom:
    begin
      Center := PointF(Point.x + Radius , Point.y-1);
      Center.Offset(0.5,0.5);
      sta:= 90;
      swa:=90;
    end;
    cpRightBottom:
    begin
      Center := PointF(Point.x-1, Point.y-1);
      Center.Offset(0.5,0.5);
      sta:= 0;
      swa:=90;
    end;
  end;


  ABitmap.Canvas.BeginScene();
  ABitmap.Canvas.Stroke.Color:=Color;
  ABitmap.Canvas.Stroke.Kind:= TBrushKind.Solid;
  ABitmap.Canvas.DrawArc(PointF(Center.x, Center.y), PointF(Radius, Radius), sta, swa,1);
  ABitmap.Canvas.EndScene;

//  Color := ColorToRGB(Color);
//
//  colorR := GetRValue(Color);
//  colorG := GetGValue(Color);
//  ColorB := GetBValue(Color);

//  if ABitmap.Map(TMapAccess.ReadWrite, bitData) then
//  try
//    for y := CornerRect.top to CornerRect.bottom do
//    begin
////    Line := ABitmap.ScanLine[y];
//
//      for x := CornerRect.left to CornerRect.right do
//      begin
//        RadiusDist := 1 - abs((Radius - 1) - Center.DistanceTo(T2DIntVector.create(x, y)));
//        if RadiusDist > 0 then
//        begin
//          tmpcolor:=bitData.GetPixel(x, y);
//          bitData.SetPixel(x, y, TColorTools.Shade(tmpcolor, Color, RadiusDist));
////        Ptr := pointer(integer(Line) + 3 * x);
////        Ptr^ := round(Ptr^ + (ColorB - Ptr^) * RadiusDist);
////        inc(Ptr);
////        Ptr^ := round(Ptr^ + (ColorG - Ptr^) * RadiusDist);
////        inc(Ptr);
////        Ptr^ := round(Ptr^ + (ColorR - Ptr^) * RadiusDist);
//        end;
//      end;
//    end;
//  finally
//    ABitmap.Unmap(bitData);
//  end;
end;

//class procedure TGUITools.DrawAARoundCorner(ACanvas: TCanvas; Point: T2DIntVector; Radius: integer; CornerPos: TCornerPos; Color: TAlphaColor);
//var
//  Center: T2DIntVector;
//  OrgColor: TAlphaColor;
//  x, y: integer;
//  RadiusDist: double;
//  CornerRect: T2DIntRect;
//begin
//  // Sprawdzamy poprawnoœæ
//  if Radius < 1 then
//    exit;
//
//  // ród³owy rect...
//  CornerRect := T2DIntRect.create(Point.x, Point.y, Point.x + Radius - 1, Point.y + Radius - 1);
//
//  // Szukamy œrodka ³uku - zale¿nie od rodzaju naro¿nika
//  case CornerPos of
//    cpLeftTop:
//      Center := T2DIntVector.create(Point.x + Radius - 1, Point.y + Radius - 1);
//    cpRightTop:
//      Center := T2DIntVector.create(Point.x, Point.y + Radius - 1);
//    cpLeftBottom:
//      Center := T2DIntVector.Create(Point.x + Radius - 1, Point.y);
//    cpRightBottom:
//      Center := T2DIntVector.Create(Point.x, Point.y);
//  end;
//
////  Color := ColorToRGB(Color);
//    for y := CornerRect.top to CornerRect.bottom do
//    begin
//      for x := CornerRect.left to CornerRect.right do
//      begin
//        RadiusDist := 1 - abs((Radius - 1) - Center.DistanceTo(T2DIntVector.create(x, y)));
//        if RadiusDist > 0 then
//        begin
//          OrgColor := ACanvas.Pixels[x, y];
//          ACanvas.Pixels[x, y] := TColorTools.Shade(OrgColor, Color, RadiusDist);
//        end;
//      end;
//    end;
//end;
//
//class procedure TGUITools.DrawAARoundCorner(ACanvas: TCanvas; Point: T2DIntVector; Radius: integer; CornerPos: TCornerPos; Color: TAlphaColor; ClipRect: T2DIntRect);
//var
//  UseOrgClipRgn: boolean;
//  ClipRgn: HRGN;
//  OrgRgn: HRGN;
//begin
//  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
//  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
//
//  ClipRgn := CreateRectRgn(ClipRect.left, ClipRect.Top, ClipRect.Right + 1, ClipRect.Bottom + 1);
//  if UseOrgClipRgn then
//    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);
//
//  SelectClipRgn(ACanvas.Handle, ClipRgn);
//
//  DrawAARoundCorner(ACanvas, Point, Radius, CornerPos, Color);
//
//  // Przywracanie poprzedniego ClipRgn i usuwanie wykorzystanych regionów
//  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
//  DeleteObject(ClipRgn);
//end;

class procedure TGUITools.DrawAARoundFrame(ABitmap: TBitmap; Rect: T2DIntRect; Radius: integer; Color: TAlphaColor; ClipRect: T2DIntRect; Corners: TCorners );
var
 r: TRectF;
 ss: TCanvasSaveState;
begin
//  if ABitmap.PixelFormat <> pf24bit then
//    raise exception.create('TGUITools.DrawAARoundFrame: Bitmapa musi byæ w trybie 24-bitowym!');

//  if (Radius < 1) then
//    exit;

  if (Radius > Rect.width div 2) or (Radius > Rect.height div 2) then
    exit;

  ABitmap.Canvas.BeginScene();
  try
    ss:=ABitmap.Canvas.SaveState;
    ABitmap.Canvas.IntersectClipRect(ClipRect.ForWinAPI);
    ABitmap.Canvas.Stroke.Color:= Color;
    r:= Rect.ForWinAPI;
    r.Inflate(-0.5,-0.5);
    ABitmap.Canvas.Stroke.Kind:= TBrushKind.Solid;
    ABitmap.Canvas.DrawRect(r, Radius, Radius, Corners,1);
  finally
    ABitmap.Canvas.RestoreState(ss);
    ABitmap.Canvas.EndScene;
  end;
//  // DrawAARoundCorner jest zabezpieczony przed rysowaniem poza obszarem
//  DrawAARoundCorner(ABitmap, T2DIntVector.create(Rect.left, Rect.top), Radius, cpLeftTop, Color, ClipRect);
//  DrawAARoundCorner(ABitmap, T2DIntVector.create(Rect.right - Radius + 1, Rect.top), Radius, cpRightTop, Color, ClipRect);
//  DrawAARoundCorner(ABitmap, T2DIntVector.create(Rect.left, Rect.bottom - Radius + 1), Radius, cpLeftBottom, Color, ClipRect);
//  DrawAARoundCorner(ABitmap, T2DIntVector.create(Rect.Right - Radius + 1, Rect.Bottom - Radius + 1), Radius, cpRightBottom, Color, ClipRect);
//
//  ABitmap.Canvas.Stroke.Color := Color;
//  ABitmap.Canvas.Stroke.Kind := TBrushKind.Solid;
//
//  // Draw*Line s¹ zabezpieczone przed rysowaniem poza obszarem
//  DrawVLine(ABitmap, Rect.left, Rect.top + Radius, Rect.bottom - Radius, Color, ClipRect);
//  DrawVLine(ABitmap, Rect.right, Rect.top + Radius, Rect.bottom - Radius, Color, ClipRect);
//  DrawHLine(ABitmap, Rect.left + Radius, Rect.right - Radius, Rect.top, Color, ClipRect);
//  DrawHLine(ABitmap, Rect.left + Radius, Rect.right - Radius, Rect.bottom, Color, ClipRect);

end;

class procedure TGUITools.DrawAARoundFrame(ABitmap: TBitmap; Rect: T2DIntRect; Radius: integer; Color: TAlphaColor; Corners: TCorners);
var
  r: TRectF;
begin
//  if ABitmap.PixelFormat <> pf24bit then
//    raise exception.create('TGUITools.DrawAARoundFrame: Bitmapa musi byæ w trybie 24-bitowym!');

//  if (Radius < 1) then
//    exit;

  if (Radius > Rect.width div 2) or (Radius > Rect.height div 2) then
    exit;

  ABitmap.Canvas.BeginScene();
  ABitmap.Canvas.Stroke.Color:= Color;
  r:= Rect.ForWinAPI;
  r.Inflate(-0.5,-0.5);
  ABitmap.Canvas.Stroke.Kind:= TBrushKind.Solid;
  ABitmap.Canvas.DrawRect(r, Radius, Radius, Corners,1);
  ABitmap.Canvas.EndScene;


  // DrawAARoundCorner jest zabezpieczony przed rysowaniem poza obszarem
//  DrawAARoundCorner(ABitmap, T2DIntVector.create(Rect.left, Rect.top), Radius, cpLeftTop, Color);
//  DrawAARoundCorner(ABitmap, T2DIntVector.create(Rect.right - Radius + 1, Rect.top), Radius, cpRightTop, Color);
//  DrawAARoundCorner(ABitmap, T2DIntVector.create(Rect.left, Rect.bottom - Radius + 1), Radius, cpLeftBottom, Color);
//  DrawAARoundCorner(ABitmap, T2DIntVector.create(Rect.Right - Radius + 1, Rect.Bottom - Radius + 1), Radius, cpRightBottom, Color);
//
//  ABitmap.canvas.Stroke.color := Color;
//  ABitmap.canvas.Stroke.Kind := TBrushKind.Solid;
//
//  // Draw*Line s¹ zabezpieczone przed rysowaniem poza obszarem
//  DrawVLine(ABitmap, Rect.left, Rect.top + Radius, Rect.bottom - Radius, Color);
//  DrawVLine(ABitmap, Rect.right, Rect.top + Radius, Rect.bottom - Radius, Color);
//  DrawHLine(ABitmap, Rect.left + Radius, Rect.right - Radius, Rect.top, Color);
//  DrawHLine(ABitmap, Rect.left + Radius, Rect.right - Radius, Rect.bottom, Color);
end;

class procedure TGUITools.DrawFitWText(ABitmap: TBitmap; x1, x2, y: integer; AText: string; TextColor: TAlphaColor; Align: TAlignment);
var
  tw: single;
  s: string;
begin
  with ABitmap.Canvas do
  begin
    s := AText;
    tw := TextWidth(s);
    // Jeœli tekst siê zmieœci, rysujemy
    if tw <= (x2 - x1 + 1) then
      case Align of
        taLeftJustify:
          TTextTools.TextOut(ABitmap.Canvas, x1, y, AText);
        taRightJustify:
          TTextTools.TextOut(ABitmap.Canvas, x2 - Round(tw) + 1, y, AText);
        taCenter:
          TTextTools.TextOut(ABitmap.Canvas, x1 + ((x2 - x1 - Round(tw)) div 2), y, AText);
      end
    else
    begin
      while (s <> '') and (tw > (x2 - x1 + 1)) do
      begin
        delete(s, length(s), 1);
        tw := TextWidth(s + '...');
      end;
      if tw <= (x2 - x1 + 1) then
        TTextTools.TextOut(ABitmap.Canvas, x1, y, s + '...');
    end;
  end;
end;

class procedure TGUITools.DrawHLine(ACanvas: TCanvas; x1, x2, y: integer; Color: TAlphaColor);
var
  tmp: integer;
  ss: TCanvasSaveState;
  ps, pe: TPointF;
begin
  if x2 < x1 then
  begin
    tmp := x1;
    x1 := x2;
    x2 := tmp;
  end;

  ss := ACanvas.SaveState;
  try
    ACanvas.BeginScene();
    ACanvas.Stroke.color := Color;
    ACanvas.Stroke.Kind := TBrushKind.Solid;
    ACanvas.Stroke.Thickness := 1;
    ps := PointF(x1, y);
    pe := PointF(x2 + 1, y);
    ps := ACanvas.AlignToPixel(ps);
    ps.Offset(0.5,0.5);
    pe := ACanvas.AlignToPixel(pe);
    pe.Offset(0.5,0.5);
    ACanvas.DrawLine(ps, pe, 1);
    ACanvas.EndScene;
  finally
    ACanvas.RestoreState(ss);
  end;
end;

class procedure TGUITools.DrawHLine(ACanvas: TCanvas; x1, x2, y: integer; Color: TAlphaColor; ClipRect: T2DIntRect);
var
  UseOrgClipRgn: boolean;
  ClipRgn: TRectF;
  ss: TCanvasSaveState;
begin
  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego

  ss := ACanvas.SaveState;
  try
    ACanvas.BeginScene();

    ClipRgn := RectF(ClipRect.left, ClipRect.Top, ClipRect.Right + 1, ClipRect.Bottom + 1);

    //ACanvas.IntersectClipRect(ClipRgn);
    DrawHLine(ACanvas, x1, x2, y, Color);

    ACanvas.EndScene;
  finally
    ACanvas.RestoreState(ss);

  end;

end;

class procedure TGUITools.DrawImage(ABitmap: TBitmap; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector; ClipRect: T2DIntRect);
begin
  DrawImage(ABitmap.Canvas, Imagelist, ImageIndex, Point, ClipRect);
end;

class procedure TGUITools.DrawImage(ABitmap: TBitmap; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector);
begin
  DrawImage(ABitmap.Canvas, Imagelist, ImageIndex, Point);
end;

class procedure TGUITools.DrawImage(ACanvas: TCanvas; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector; ClipRect: T2DIntRect);
var
  UseOrgClipRgn: Boolean;
  ClipRgn: TRectF;
  ImRect, DestRect: TRectF;
  ss: TCanvasSaveState;
begin
  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
  ss := ACanvas.SaveState;
  try
    ClipRgn := RectF(ClipRect.left, ClipRect.Top, ClipRect.Right + 1, ClipRect.Bottom + 1);

    //ACanvas.IntersectClipRect(ClipRgn);
    if Imagelist.BitmapExists(ImageIndex) then
    begin
      ImRect := Imagelist.Destination[ImageIndex].Layers[0].SourceRect.Rect;
      DestRect := RectF(Point.x, Point.y, Point.x + ImRect.Width, Point.y + ImRect.Height);
      ACanvas.BeginScene();
      Imagelist.Draw(ACanvas, DestRect, ImageIndex);
      ACanvas.EndScene;
    end;
  finally
    ACanvas.RestoreState(ss);

  end;
end;

class procedure TGUITools.DrawMarkedText(ACanvas: TCanvas; x, y: integer; AText, AMarkPhrase: string; TextColor: TAlphaColor; ClipRect: T2DIntRect; CaseSensitive: boolean);
var
  UseOrgClipRgn: Boolean;
  ClipRgn: TRectF;
  ss: TCanvasSaveState;
begin
  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
  ss := ACanvas.SaveState;
  try
    ClipRgn := RectF(ClipRect.left, ClipRect.Top, ClipRect.Right + 1, ClipRect.Bottom + 1);

    //ACanvas.IntersectClipRect(ClipRgn);
    ACanvas.BeginScene();
    DrawMarkedText(ACanvas, x, y, AText, AMarkPhrase, TextColor, CaseSensitive);
    ACanvas.EndScene;
  finally
    ACanvas.RestoreState(ss);
  end;
end;

class procedure TGUITools.DrawMarkedText(ACanvas: TCanvas; x, y: integer; AText, AMarkPhrase: string; TextColor: TAlphaColor; CaseSensitive: boolean);
var
  DrawText: string;
  BaseText: string;
  MarkText: string;
  MarkPos: Integer;
  x1: integer;
  s: string;
  MarkTextLength: Integer;
begin
  DrawText := AText;
  if CaseSensitive then
  begin
    BaseText := AText;
    MarkText := AMarkPhrase;
  end
  else
  begin
    BaseText := AnsiUpperCase(AText);
    MarkText := AnsiUpperCase(AMarkPhrase);
  end;

  x1 := x;
  MarkTextLength := length(MarkText);

  ACanvas.Fill.Color := TextColor;
  ACanvas.Fill.Kind := TBrushKind.None;

  MarkPos := pos(MarkText, BaseText);
  while MarkPos > 0 do
  begin
    if MarkPos > 1 then
    begin
      // Rysowanie tekstu przed wyró¿nionym
      ACanvas.Font.Style := ACanvas.Font.Style - [TFontStyle.fsBold];
      s := copy(DrawText, 1, MarkPos - 1);

      TTextTools.TextOut(ACanvas, x1, y, s);
      x1 := x1 + Round(ACanvas.TextWidth(s)) + 1;

      delete(DrawText, 1, MarkPos - 1);
      delete(BaseText, 1, MarkPos - 1);
    end;

    // Rysowanie wyró¿nionego tekstu
    ACanvas.Font.Style := ACanvas.Font.Style + [TFontStyle.fsBold];
    s := copy(DrawText, 1, MarkTextLength);

    TTextTools.TextOut(ACanvas, x1, y, s);
    x1 := x1 + round(ACanvas.TextWidth(s) + 1);

    delete(DrawText, 1, MarkTextLength);
    delete(BaseText, 1, MarkTextLength);

    MarkPos := pos(MarkText, BaseText);
  end;

  if Length(BaseText) > 0 then
  begin
    ACanvas.Font.Style := ACanvas.Font.Style - [TFontStyle.fsBold];
    TTextTools.TextOut(ACanvas, x1, y, DrawText);
  end;
end;

class procedure TGUITools.DrawImage(ACanvas: TCanvas; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector);
var
  ImRect, DestRect: TRectF;
begin
  ImRect := Imagelist.Destination[ImageIndex].Layers[0].SourceRect.Rect;
  DestRect := RectF(Point.x, Point.y, Point.x + ImRect.Width, Point.y + ImRect.Height);
  ACanvas.BeginScene();
  Imagelist.Draw(ACanvas, DestRect, ImageIndex);
  ACanvas.EndScene;
end;

class procedure TGUITools.DrawOutlinedText(ACanvas: TCanvas; x, y: integer; AText: string; TextColor, OutlineColor: TAlphaColor);
begin
  with ACanvas do
  begin
    Fill.Kind := TBrushKind.None;
    Fill.color := OutlineColor;
    TTextTools.TextOut(ACanvas, x - 1, y - 1, AText);
    TTextTools.TextOut(ACanvas, x, y - 1, AText);
    TTextTools.TextOut(ACanvas, x + 1, y - 1, AText);
    TTextTools.TextOut(ACanvas, x - 1, y, AText);
    TTextTools.TextOut(ACanvas, x + 1, y, AText);
    TTextTools.TextOut(ACanvas, x - 1, y + 1, AText);
    TTextTools.TextOut(ACanvas, x, y + 1, AText);
    TTextTools.TextOut(ACanvas, x + 1, y + 1, AText);
    Fill.color := TextColor;
    TTextTools.TextOut(ACanvas, x, y, AText);
  end;
end;

class procedure TGUITools.DrawOutlinedText(ACanvas: TCanvas; x, y: integer; AText: string; TextColor, OutlineColor: TAlphaColor; ClipRect: T2DIntRect);
var
  WinAPIClipRect: TRectF;
  ss: TCanvasSaveState;
begin
  WinAPIClipRect := ClipRect.ForWinAPI;
  ss := ACanvas.SaveState;
  try
    with ACanvas do
    begin
      Fill.Kind := TBrushKind.None;
      Fill.color := OutlineColor;
      //ACanvas.IntersectClipRect(WinAPIClipRect);
      TTextTools.TextOut(ACanvas, x - 1, y - 1, AText);
      TTextTools.TextOut(ACanvas, x, y - 1, AText);
      TTextTools.TextOut(ACanvas, x + 1, y - 1, AText);
      TTextTools.TextOut(ACanvas, x - 1, y, AText);
      TTextTools.TextOut(ACanvas, x + 1, y, AText);
      TTextTools.TextOut(ACanvas, x - 1, y + 1, AText);
      TTextTools.TextOut(ACanvas, x, y + 1, AText);
      TTextTools.TextOut(ACanvas, x + 1, y + 1, AText);

      Fill.color := TextColor;
      TTextTools.TextOut(ACanvas, x, y, AText);
    end;
  finally
    ACanvas.RestoreState(ss);
  end;
end;

class procedure TGUITools.DrawHLine(ABitmap: TBitmap; x1, x2, y: integer; Color: TAlphaColor);
var
  LineRect: T2DIntRect;
  BitmapRect: T2DIntRect;
  tmp: Integer;
  ps, pe: TPointF;
begin
//  if ABitmap.PixelFormat <> pf24bit then
//    raise exception.create('TGUITools.DrawHLine: Bitmapa musi byæ w trybie 24-bitowym!');

  if x2 < x1 then
  begin
    tmp := x1;
    x1 := x2;
    x2 := tmp;
  end;

  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
  if not (BitmapRect.IntersectsWith(T2DIntRect.create(x1, y, x2, y), LineRect)) then
    exit;
  ABitmap.Canvas.BeginScene();
  try
    ABitmap.canvas.Stroke.color := Color;
    ABitmap.canvas.Stroke.Kind := TBrushKind.Solid;
    ABitmap.canvas.Stroke.Thickness := 1;
    ps := PointF(LineRect.left, LineRect.Top);
    pe := PointF(LineRect.right + 1, LineRect.top);
    ps := ABitmap.Canvas.AlignToPixel(ps);
    ps.Offset(0.5,0.5);
    pe := ABitmap.Canvas.AlignToPixel(pe);
    pe.Offset(0.5,0.5);

    ABitmap.canvas.DrawLine(ps, pe, 1);
  finally
    ABitmap.Canvas.EndScene;
  end;

end;

class procedure TGUITools.DrawHLine(ABitmap: TBitmap; x1, x2, y: integer; Color: TAlphaColor; ClipRect: T2DIntRect);
var
  OrgLineRect: T2DIntRect;
  LineRect: T2DIntRect;
  BitmapRect: T2DIntRect;
  tmp: Integer;
  ps, pe: TPointF;
begin
//  if ABitmap.PixelFormat <> pf24bit then
//    raise exception.create('TGUITools.DrawHLine: Bitmapa musi byæ w trybie 24-bitowym!');

  if x2 < x1 then
  begin
    tmp := x1;
    x1 := x2;
    x2 := tmp;
  end;

  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
  if not (BitmapRect.IntersectsWith(T2DIntRect.create(x1, y, x2, y), OrgLineRect)) then
    exit;

  if not (OrgLineRect.IntersectsWith(ClipRect, LineRect)) then
    exit;

  ABitmap.canvas.BeginScene();
  try
    ABitmap.canvas.Stroke.color := Color;
    ABitmap.canvas.Stroke.Kind := TBrushKind.Solid;
    ABitmap.canvas.Stroke.Thickness := 1;
    ps := PointF(LineRect.left, LineRect.Top);
    pe := PointF(LineRect.right + 1, LineRect.top);
    ps := ABitmap.Canvas.AlignToPixel(ps);
    ps.Offset(0.5,0.5);
    pe := ABitmap.Canvas.AlignToPixel(pe);
    pe.Offset(0.5,0.5);
    ABitmap.canvas.DrawLine(ps, pe, 1);
  finally
    ABitmap.canvas.EndScene;
  end;

end;

class procedure TGUITools.DrawOutlinedText(ABitmap: TBitmap; x, y: integer; AText: string; TextColor, OutlineColor: TAlphaColor; ClipRect: T2DIntRect);
var
  WinAPIClipRect: TRect;
  ss: TCanvasSaveState;
begin
  WinAPIClipRect := ClipRect.ForWinAPI;
  ss := ABitmap.Canvas.SaveState;
  try
    with ABitmap.Canvas do
    begin
      Fill.Kind := TBrushKind.None;
      Fill.color := OutlineColor;
      //IntersectClipRect(WinAPIClipRect);
      TTextTools.TextOut(ABitmap.Canvas, x - 1, y - 1, AText);
      TTextTools.TextOut(ABitmap.Canvas, x, y - 1, AText);
      TTextTools.TextOut(ABitmap.Canvas, x + 1, y - 1, AText);
      TTextTools.TextOut(ABitmap.Canvas, x - 1, y, AText);
      TTextTools.TextOut(ABitmap.Canvas, x + 1, y, AText);
      TTextTools.TextOut(ABitmap.Canvas, x - 1, y + 1, AText);
      TTextTools.TextOut(ABitmap.Canvas, x, y + 1, AText);
      TTextTools.TextOut(ABitmap.Canvas, x + 1, y + 1, AText);

      Fill.color := TextColor;
      TTextTools.TextOut(ABitmap.Canvas, x, y, AText);
    end;
  finally
    ABitmap.Canvas.RestoreState(ss);
  end;
end;

class procedure TGUITools.DrawRegion(ACanvas: TCanvas; Region: TRectF; Rect: T2DIntRect; Radius: Integer; ColorFrom, ColorTo: TAlphaColor; GradientKind: TBackgroundKind; Corners: TCorners);
var
  UseOrgClipRgn: Boolean;
//  OrgRgn: HRGN;
  ss: TCanvasSaveState;
begin
  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
//  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
//  SelectClipRgn(ACanvas.Handle, Region);
  ACanvas.BeginScene();
  try
    ss := ACanvas.SaveState;
    ACanvas.IntersectClipRect(Region);
    FillGradientRectangle(ACanvas, Rect, Radius, ColorFrom, ColorTo, GradientKind, Corners);
    ACanvas.RestoreState(ss);

  finally
    ACanvas.EndScene;
  end;

//  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
end;

class procedure TGUITools.DrawRegion(ACanvas: TCanvas; Region: TRectF; Rect: T2DIntRect; Radius: Integer; ColorFrom, ColorTo: TAlphaColor; GradientKind: TBackgroundKind; ClipRect: T2DIntRect; Corners: TCorners);
var
  UseOrgClipRgn: boolean;
//  ClipRgn: HRGN;
//  OrgRgn: HRGN;
begin
  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
//  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

//  ClipRgn := CreateRectRgn(ClipRect.left, ClipRect.Top, ClipRect.Right + 1, ClipRect.Bottom + 1);
//  if UseOrgClipRgn then
//    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);
//
///  SelectClipRgn(ACanvas.Handle, ClipRgn);

  DrawRegion(ACanvas, Region, Rect, Radius, ColorFrom, ColorTo, GradientKind);

  // Przywracanie poprzedniego ClipRgn i usuwanie wykorzystanych regionów
//  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
//  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawRoundRect(ACanvas: TCanvas; Rect: T2DIntRect; Radius: integer; ColorFrom, ColorTo: TAlphaColor; GradientKind: TBackgroundKind; ClipRect: T2DIntRect; LeftTopRound, RightTopRound, LeftBottomRound, RightBottomRound: boolean);
var
  UseOrgClipRgn: boolean;
//  ClipRgn: HRGN;
//  OrgRgn: HRGN;
  ClipRgn: TRectF;
  ss: TCanvasSaveState;
begin
  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
//  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := RectF(ClipRect.left, ClipRect.Top, ClipRect.Right + 1, ClipRect.Bottom + 1);

  ss := ACanvas.SaveState;
  try
    //ACanvas.IntersectClipRect(ClipRgn);

    DrawRoundRect(ACanvas, Rect, Radius, ColorFrom, ColorTo, GradientKind, LeftTopRound, RightTopRound, LeftBottomRound, RightBottomRound);

  // Przywracanie poprzedniego ClipRgn i usuwanie wykorzystanych regionów
  finally
    ACanvas.RestoreState(ss);
  end;
end;

class procedure TGUITools.DrawText(ACanvas: TCanvas; x, y: integer; AText: string; TextColor: TAlphaColor);
begin
  with ACanvas do
  begin
    Fill.Kind := TBrushKind.None;
    Fill.color := TextColor;
    TTextTools.TextOut(ACanvas, x, y, AText);
  end;
end;

class procedure TGUITools.DrawTab(ABitmap: TBitmap; RoundTab: T2DIntRect;
  Radius: Integer; Border, ColorFrom, ColorTo: TAlphaColor);
var
      pd: TPathData;
      stp: TPointF;
      fill: TBrush;

begin
        pd := TPathData.Create;
        stp:= PointF(RoundTab.Left, RoundTab.Bottom-Radius);
        stp.Offset(0.5,0.5);
        pd.AddArc(stp,PointF(Radius,Radius),90,-90);
        stp.Offset(Radius,0);
        //pd.MoveTo(stp);
        stp.Offset(0, - (RoundTab.Height - (Radius*2)-1));
        pd.LineTo(stp);
        stp.Offset(Radius,0);
        pd.AddArc(stp,PointF(Radius,Radius),-180,90);
        stp.Offset(0, -Radius);
        //pd.MoveTo(stp);
        stp.Offset(RoundTab.Width -(Radius*4),0);
        pd.LineTo(stp);
        stp.Offset(0, Radius);
        pd.AddArc(stp,PointF(Radius,Radius),-90,90);
        stp.Offset(Radius,0);
        //pd.MoveTo(stp);
        stp.Offset(0,(RoundTab.Height - (Radius*2)-1));
        pd.LineTo(stp);
        stp.Offset(Radius,0);
        pd.AddArc(stp,PointF(Radius,Radius),-180,-90);
        stp.Offset(0,Radius);
        //pd.MoveTo(stp);
        stp.Offset(-RoundTab.Width,0);
        //pd.LineTo(stp);
        fill := TBrush.Create(TBrushKind.Gradient, TAlphaCOlorRec.Blue);


        ABitmap.Canvas.BeginScene();
        ABitmap.Canvas.Stroke.Kind:= TBrushKind.Solid;
        ABitmap.Canvas.Stroke.Color:= Border;
        Fill.Color:=ColorFrom;
        Fill.Gradient.Color:= ColorFrom;
        Fill.Gradient.Color1:= ColorTo;
        ABitmap.Canvas.FillPath(pd,1,fill);
        ABitmap.Canvas.DrawPath(pd, 1);
        ABitmap.Canvas.EndScene;

end;

class procedure TGUITools.DrawText(ACanvas: TCanvas; x, y: integer; AText: string; TextColor: TAlphaColor; ClipRect: T2DIntRect);
var
  WinAPIClipRect: TRectF;
  ss: TCanvasSaveState;
begin
  WinAPIClipRect := ClipRect.ForWinAPI;
  ss := ACanvas.SaveState;
  try
    ACanvas.BeginScene();
    //ACanvas.IntersectClipRect(WinAPIClipRect);
    with ACanvas do
    begin
      Fill.Kind := TBrushKind.None;
      Fill.color := TextColor;
      TTextTools.TextOut(ACanvas, x, y, AText);
    end;
  finally
    ACanvas.EndScene;
    ACanvas.RestoreState(ss);
  end;
end;

class procedure TGUITools.DrawRoundRect(ACanvas: TCanvas; Rect: T2DIntRect; Radius: integer; ColorFrom, ColorTo: TAlphaColor; GradientKind: TBackgroundKind; LeftTopRound, RightTopRound, LeftBottomRound, RightBottomRound: boolean);
var
  RoundRgn, TmpRgn: TRectF;
  UseOrgClipRgn: Boolean;
  ss: TCanvasSaveState;
begin
  if Radius < 1 then
    exit;

  if (Radius * 2 > Rect.width) or (Radius * 2 > Rect.height) then
    exit;

  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
  ss := ACanvas.SaveState;
  try

    if not (LeftTopRound) and not (RightTopRound) and not (LeftBottomRound) and not (RightBottomRound) then
    begin
      RoundRgn := RectF(Rect.Left, Rect.Top, Rect.Right + 1, Rect.Bottom + 1);
    end
    else
    begin
      RoundRgn := RectF(Rect.Left, Rect.Top, Rect.Right + 2, Rect.Bottom + 2);
// íåò ðåãèîíà ñ çàêðóãëåíèåì
//    RoundRgn := CreateRoundRectRgn(Rect.Left, Rect.Top, Rect.Right + 2, Rect.Bottom + 2, Radius * 2, Radius * 2);

      if not (LeftTopRound) then
      begin
        TmpRgn := RectF(Rect.left, Rect.Top, Rect.left + Radius, Rect.Top + Radius);
        RoundRgn.Union(TmpRgn);
//      CombineRgn(RoundRgn, RoundRgn, TmpRgn, RGN_OR);
//      DeleteObject(TmpRgn);
      end;

      if not (RightTopRound) then
      begin
        TmpRgn := RectF(Rect.right - Radius + 1, Rect.Top, Rect.Right + 1, Rect.Top + Radius);
        RoundRgn.Union(TmpRgn);
      end;

      if not (LeftBottomRound) then
      begin
        TmpRgn := RectF(Rect.left, Rect.Bottom - Radius + 1, Rect.Left + Radius, Rect.Bottom + 1);
        RoundRgn.Union(TmpRgn);
      end;

      if not (RightBottomRound) then
      begin
        TmpRgn := RectF(Rect.right - Radius + 1, Rect.Bottom - Radius + 1, Rect.Right + 1, Rect.Bottom + 1);
        RoundRgn.Union(TmpRgn);
      end;
    end;

//  if UseOrgClipRgn then
//    CombineRgn(RoundRgn, RoundRgn, OrgRgn, RGN_AND);

    //ACanvas.IntersectClipRect(RoundRgn);
//  ColorFrom := ColorToRGB(ColorFrom);
//  ColorTo := ColorToRGB(ColorTo);

    ACanvas.BeginScene();
    FillGradientRectangle(ACanvas, Rect, Radius, ColorFrom, ColorTo, GradientKind);
    ACanvas.EndScene;

  // Przywracanie poprzedniego ClipRgn i usuwanie wykorzystanych regionów
//  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
//  DeleteObject(RoundRgn);
  finally
    ACanvas.RestoreState(ss);
  end;
end;

class procedure TGUITools.DrawOutlinedText(ABitmap: TBitmap; x, y: integer; AText: string; TextColor, OutlineColor: TAlphaColor);
begin
  ABitmap.canvas.Fill.Kind := TBrushKind.None;
  ABitmap.canvas.Fill.color := OutlineColor;
  TTextTools.TextOut(ABitmap.canvas, x - 1, y - 1, AText);
  TTextTools.TextOut(ABitmap.canvas, x, y - 1, AText);
  TTextTools.TextOut(ABitmap.canvas, x + 1, y - 1, AText);
  TTextTools.TextOut(ABitmap.canvas, x - 1, y, AText);
  TTextTools.TextOut(ABitmap.canvas, x + 1, y, AText);
  TTextTools.TextOut(ABitmap.canvas, x - 1, y + 1, AText);
  TTextTools.TextOut(ABitmap.canvas, x, y + 1, AText);
  TTextTools.TextOut(ABitmap.canvas, x + 1, y + 1, AText);
  ABitmap.canvas.Fill.color := TextColor;
  TTextTools.TextOut(ABitmap.canvas, x, y, AText);
end;

class procedure TGUITools.DrawText(ABitmap: TBitmap; x, y: integer; AText: string; TextColor: TAlphaColor; ClipRect: T2DIntRect);
var
  WinAPIClipRect: TRect;
begin
  WinAPIClipRect := ClipRect.ForWinAPI;
  with ABitmap.canvas do
  begin
    Fill.Kind := TBrushKind.None;
    Fill.color := TextColor;
    TTextTools.TextRect(ABitmap.Canvas, WinAPIClipRect, x, y, AText);
  end;
end;

class procedure TGUITools.DrawFitWOutlinedText(ABitmap: TBitmap; x1, x2, y: integer; AText: string; TextColor, OutlineColor: TAlphaColor; Align: TAlignment);
var
  tw: integer;
  s: string;
begin
  with ABitmap.Canvas do
  begin
    s := AText;
    tw := Round(TextWidth(s)) + 2;
    // Jeœli tekst siê zmieœci, rysujemy
    if tw <= (x2 - x1 + 1) then
      case Align of
        taLeftJustify:
          TGUITools.DrawOutlinedText(ABitmap, x1, y, AText, TextColor, OutlineColor);
        taRightJustify:
          TGUITools.DrawOutlinedText(ABitmap, x2 - tw + 1, y, AText, TextColor, OutlineColor);
        taCenter:
          TGUITools.DrawOutlinedText(ABitmap, x1 + ((x2 - x1 - tw) div 2), y, AText, TextColor, OutlineColor);
      end
    else
    begin
      while (s <> '') and (tw > (x2 - x1 + 1)) do
      begin
        delete(s, length(s), 1);
        tw := round(TextWidth(s + '...')) + 2;
      end;
      if tw <= (x2 - x1 + 1) then
        TGUITools.DrawOutlinedText(ABitmap, x1, y, s + '...', TextColor, OutlineColor);
    end;
  end;
end;

class procedure TGUITools.DrawFitWOutlinedText(ACanvas: TCanvas; x1, x2, y: integer; AText: string; TextColor, OutlineColor: TAlphaColor; Align: TAlignment);
var
  tw: integer;
  s: string;
begin
  with ACanvas do
  begin
    s := AText;
    tw := round(TextWidth(s)) + 2;
    // Jeœli tekst siê zmieœci, rysujemy
    if tw <= (x2 - x1 + 1) then
      case Align of
        taLeftJustify:
          TGUITools.DrawOutlinedText(ACanvas, x1, y, AText, TextColor, OutlineColor);
        taRightJustify:
          TGUITools.DrawOutlinedText(ACanvas, x2 - tw + 1, y, AText, TextColor, OutlineColor);
        taCenter:
          TGUITools.DrawOutlinedText(ACanvas, x1 + ((x2 - x1 - tw) div 2), y, AText, TextColor, OutlineColor);
      end
    else
    begin
      while (s <> '') and (tw > (x2 - x1 + 1)) do
      begin
        delete(s, length(s), 1);
        tw := round(TextWidth(s + '...')) + 2;
      end;
      if tw <= (x2 - x1 + 1) then
        TGUITools.DrawOutlinedText(ACanvas, x1, y, s + '...', TextColor, OutlineColor);
    end;
  end;
end;

procedure GradVertical(Canvas:TCanvas; Rect:TRectF; FromColor, ToColor:TAlphaColor) ;
 var
   Y:integer;
   dr,dg,db:Extended;
   C1,C2: TAlphaColor;
   r1,r2,g1,g2,b1,b2:Byte;
   R,G,B:Byte;
   cnt:Integer;
   path:TPathData;
 begin
    C1 := FromColor;
    R1 := GetRValue(C1) ;
    G1 := GetGValue(C1) ;
    B1 := GetBValue(C1) ;

    C2 := ToColor;
    R2 := GetRValue(C2) ;
    G2 := GetGValue(C2) ;
    B2 := GetBValue(C2) ;

    dr := (R2-R1) / (Rect.Bottom-Rect.Top);
    dg := (G2-G1) / (Rect.Bottom-Rect.Top);
    db := (B2-B1) / (Rect.Bottom-Rect.Top);

    cnt := 0;
    Canvas.Stroke.Kind:= TBrushKind.Solid;
    Canvas.BeginScene();
    try
      for Y := Round(Rect.Top) to Round(Rect.Bottom-1) do
      begin
         R := R1+Ceil(dr*cnt) ;
         G := G1+Ceil(dg*cnt) ;
         B := B1+Ceil(db*cnt) ;
         Canvas.Stroke.Color := RGB(R,G,B) ;
         Canvas.DrawLine(PointF(Rect.Left,Y), PointF(Rect.Right,Y),1) ;
         Inc(cnt) ;
      end;
    finally
      Canvas.EndScene;
    end;
 end;

class procedure TGUITools.FillGradientRectangle(ACanvas: TCanvas; Rect: T2DIntRect; Radius: Integer; ColorFrom: TAlphaColor; ColorTo: TAlphaColor; GradientKind: TBackgroundKind; Corners: TCorners);
var
  Mesh: array of _GRADIENT_RECT;
  GradientVertice: array of _TRIVERTEX;
  ConcaveColor: TAlphaColor;
  cRect: TRectF;
  locGradient: TGradient;
  p: TGradientPoint;
  fill: TBrush;
begin
  cRect := Rect.ForWinAPI;
  ACanvas.BeginScene();
  try

    case GradientKind of
      bkSolid:
        begin
          ACanvas.Fill.color := ColorFrom;
          cRect:=ACanvas.AlignToPixel(cRect);
          ACanvas.fillrect(cRect, Radius, Radius, Corners, 1);
        end;
      bkVerticalGradient:
        begin
          fill:= TBrush.Create(TBrushKind.Gradient, ColorFrom);
          locGradient := TGradient.Create;
          with locGradient do
          begin
            Color := ColorFrom;
            Color1 := ColorTo;
            Fill.Gradient.StartPosition.X := 0.499999999;
            Fill.Gradient.StopPosition.X := 0.5;
            Fill.Gradient.StartPosition.Y := 1;
            Fill.Gradient.StopPosition.Y := 0;
          end;

          with Fill do
          begin
            Kind := TBrushKind.Gradient;
            Gradient := locGradient;
          end;
        //InflateRect(cRect, -0.5, -0.5);
          cRect := ACanvas.AlignToPixel(cRect);
          ACanvas.FillRect(cRect, Radius, Radius, Corners, 1.0, Fill);
        end;

      bkHorizontalGradient:
        begin
          locGradient := TGradient.Create;
          fill:= TBrush.Create(TBrushKind.Gradient, ColorFrom);
          with locGradient do
          begin
            Color := ColorFrom;
            Color1 := ColorTo;

            StartPosition.X := 0;
            StopPosition.X := 1;
            StartPosition.Y := 0;
            StopPosition.Y := 0;

          end;

          with Fill do
          begin
            Kind := TBrushKind.Gradient;
            Gradient := locGradient;
          end;
          //InflateRect(cRect, -0.5, -0.5);
          cRect := ACanvas.AlignToPixel(cRect);
          ACanvas.FillRect(cRect, Radius, Radius, Corners, 1.0, Fill);
        end;
      bkConcave:
        begin
          ConcaveColor := TColorTools.Brighten(ColorFrom, 20);

          locGradient := TGradient.Create;
          fill:= TBrush.Create(TBrushKind.Gradient, ColorTo);
          Fill.Gradient.Style := TGradientStyle.Linear;
          Fill.Gradient.Points.Clear;

          Fill.Gradient.StartPosition.X := 0.499999999;
          Fill.Gradient.StopPosition.X := 0.5;
          Fill.Gradient.StartPosition.Y := 1;
          Fill.Gradient.StopPosition.Y := 0;

//          with locGradient do
//          begin
////          Color   := ColorFrom;
////          Color1  := ColorTo;
//            StartPosition.X := 0;
//            StopPosition.X := 0;
//            StartPosition.Y := 0;
//            StopPosition.Y := 1;
//          end;

          p := TGradientPoint.Create(Fill.Gradient.Points);
          p.IntColor := ColorFrom;
          p.Offset := 0;

          p := TGradientPoint.Create(Fill.Gradient.Points);
          p.Offset := 0.75;
          p.IntColor := ColorTo;

          p := TGradientPoint.Create(Fill.Gradient.Points);
          p.IntColor := ConcaveColor;
          p.Offset := 0.75;

          p := TGradientPoint.Create(Fill.Gradient.Points);
          p.IntColor := ConcaveColor;
          p.Offset := 1;


//          p := TGradientPoint.Create(Fill.Gradient.Points);
//          p.IntColor := ColorFrom;
//          p.Offset := 1;

//          p := TGradientPoint.Create(Fill.Gradient.Points);
//          p.IntColor := $FFFEA2A2;
//          p.Offset := 0;
//
//          p := TGradientPoint.Create(Fill.Gradient.Points);
//          p.IntColor := $FFFFA1A1;
//          p.Offset := 0.118012420833110800;
//
//          p := TGradientPoint.Create(Fill.Gradient.Points);
//          p.IntColor := $FFEC0101;
//          p.Offset := 0.332298129796981800;
//
//          p := TGradientPoint.Create(Fill.Gradient.Points);
//          p.IntColor := $FFED9090;
//          p.Offset := 1.000000000000000000;


//          with Fill do
//          begin
//            Kind := TBrushKind.Gradient;
//            Gradient := locGradient;
//          end;

        //InflateRect(cRect, -0.5, -0.5);
          cRect := ACanvas.AlignToPixel(cRect);
          //cRect.Offset(-0.5,-0.5);
          ACanvas.FillRect(cRect, Radius, Radius, Corners, 1.0, Fill);
//          GradVertical(ACanvas,cRect, ColorFrom, ColorTo );


//        setlength(GradientVertice, 4);
//        with GradientVertice[0] do
//        begin
//          x := Rect.left;
//          y := Rect.top;
//          Red := Byte(GetRValue(ColorFrom) shl 8);
//          Green := Byte(GetGValue(ColorFrom) shl 8);
//          Blue := Byte(GetBValue(ColorFrom) shl 8);
//          Alpha := Byte(ShortInt(255 shl 8));
//        end;
//        with GradientVertice[1] do
//        begin
//          x := Rect.Right + 1;
//          y := Rect.Top + (Rect.height) div 4;
//          Red := Byte(GetRValue(ConcaveColor) shl 8);
//          Green := Byte(GetGValue(ConcaveColor) shl 8);
//          Blue := Byte(GetBValue(ConcaveColor) shl 8);
//          Alpha := Byte(ShortInt(255 shl 8));
//        end;
//        with GradientVertice[2] do
//        begin
//          x := Rect.left;
//          y := Rect.Top + (Rect.height) div 4;
//          Red := Byte(GetRValue(ColorTo) shl 8);
//          Green := Byte(GetGValue(ColorTo) shl 8);
//          Blue := Byte(GetBValue(ColorTo) shl 8);
//          Alpha := Byte(ShortInt(255 shl 8));
//        end;
//        with GradientVertice[3] do
//        begin
//          x := Rect.Right + 1;
//          y := Rect.bottom + 1;
//          Red := Byte(GetRValue(ColorFrom) shl 8);
//          Green := Byte(GetGValue(ColorFrom) shl 8);
//          Blue := Byte(GetBValue(ColorFrom) shl 8);
//          Alpha := Byte(ShortInt(255 shl 8));
//        end;
//        setlength(Mesh, 2);
//        Mesh[0].UpperLeft := 0;
//        Mesh[0].LowerRight := 1;
//        Mesh[1].UpperLeft := 2;
//        Mesh[1].LowerRight := 3;
//        GradientFill(ACanvas.Handle, GradientVertice[0], 4, @Mesh[0], 2, GRADIENT_FILL_RECT_V);
        end;
    end;
  finally
    ACanvas.EndScene;
  end;
end;

class procedure TGUITools.DrawFitWText(ACanvas: TCanvas; x1, x2, y: integer; AText: string; TextColor: TAlphaColor; Align: TAlignment);
var
  tw: integer;
  s: string;
begin
  with ACanvas do
  begin
    s := AText;
    tw := Round(TextWidth(s));
    // Jeœli tekst siê zmieœci, rysujemy
    if tw <= (x2 - x1 + 1) then
      case Align of
        taLeftJustify:
          TTextTools.TextOut(ACanvas, x1, y, AText);
        taRightJustify:
          TTextTools.TextOut(ACanvas, x2 - tw + 1, y, AText);
        taCenter:
          TTextTools.TextOut(ACanvas, x1 + ((x2 - x1 - tw) div 2), y, AText);
      end
    else
    begin
      while (s <> '') and (tw > (x2 - x1 + 1)) do
      begin
        delete(s, length(s), 1);
        tw := round(TextWidth(s + '...'));
      end;
      if tw <= (x2 - x1 + 1) then
        TTextTools.TextOut(ACanvas, x1, y, s + '...');
    end;
  end;
end;

class procedure TGUITools.RenderBackground(ABuffer: TBitmap; Rect: T2DIntRect; Color1, Color2: TAlphaColor; BackgroundKind: TBackgroundKind);
var
  TempRect: T2DIntRect;
begin
//  if ABuffer.PixelFormat <> pf24bit then
//    raise exception.create('TGUITools.RenderBackground: Bitmapa musi byæ w trybie 24-bitowym!');
  if (Rect.left > Rect.right) or (Rect.top > Rect.bottom) then
    exit;

  // Zarówno metoda FillRect jak i WinAPI'owe rysowanie gradientów jest
  // zabezpieczone przed rysowaniem poza obszarem p³ótna.
  case BackgroundKind of
    bkSolid:
      begin
        ABuffer.Canvas.Fill.Color := Color1;
        ABuffer.Canvas.Fill.Kind := TBrushKind.Solid;
        ABuffer.Canvas.Fillrect(Rect.ForWinAPI, 0, 0, AllCorners, 1);
      end;
    bkVerticalGradient:
      begin
        TGradientTools.VGradient(ABuffer.canvas, Color1, Color2, Rect);
      end;
    bkHorizontalGradient:
      begin
        TGradientTools.HGradient(ABuffer.canvas, Color1, Color2, Rect);
      end;
    bkConcave:
      begin
        TempRect := T2DIntRect.create(Rect.Left, Rect.top, Rect.right, Rect.Top + (Rect.bottom - Rect.top) div 4);
        TGradientTools.VGradient(ABuffer.Canvas, Color1, TColorTools.Shade(Color1, Color2, 20), TempRect);

        TempRect := T2DIntRect.create(Rect.Left, Rect.top + (Rect.bottom - Rect.top) div 4 + 1, Rect.right, Rect.bottom);
        TGradientTools.VGradient(ABuffer.Canvas, Color2, Color1, TempRect);
      end;
  end;

end;

//class procedure TGUITools.RestoreClipRgn(DC: HDC; OrgRgnExists: boolean; var OrgRgn: HRGN);
//begin
//  if OrgRgnExists then
//    SelectClipRgn(DC, OrgRgn)
//  else
//    SelectClipRgn(DC, 0);
//  DeleteObject(OrgRgn);
//end;
//
//class procedure TGUITools.SaveClipRgn(DC: HDC; var OrgRgnExists: boolean; var OrgRgn: HRGN);
//var
//  i: integer;
//begin
//  OrgRgn := CreateRectRgn(0, 0, 1, 1);
//  i := GetClipRgn(DC, OrgRgn);
//  OrgRgnExists := (i = 1);
//end;

class procedure TGUITools.DrawText(ABitmap: TBitmap; x, y: integer; AText: string; TextColor: TAlphaColor);
begin
  with ABitmap.canvas do
  begin
    Fill.Kind := TBrushKind.None;
    Fill.color := TextColor;
    TTextTools.TextOut(ABitmap.canvas, x, y, AText);
  end;
end;

class procedure TGUITools.DrawVLine(ABitmap: TBitmap; x, y1, y2: integer; Color: TAlphaColor);
var
  LineRect: T2DIntRect;
  BitmapRect: T2DIntRect;
  tmp: Integer;
  ps, pe: TPointF;
begin
//  if ABitmap.PixelFormat <> pf24bit then
//    raise exception.create('TGUITools.DrawHLine: Bitmapa musi byæ w trybie 24-bitowym!');

  if y2 < y1 then
  begin
    tmp := y1;
    y1 := y2;
    y2 := tmp;
  end;

  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
  if not (BitmapRect.IntersectsWith(T2DIntRect.create(x, y1, x, y2), LineRect)) then
    exit;

  ABitmap.canvas.BeginScene();
  ABitmap.canvas.Stroke.color := Color;
  ABitmap.canvas.Stroke.Kind := TBrushKind.Solid;
  ps := Pointf(LineRect.left, LineRect.Top);
  pe := PointF(LineRect.left, LineRect.bottom + 1);
  ps := ABitmap.canvas.AlignToPixel(ps);
  ps.Offset(0.5,0.5);
  pe := ABitmap.canvas.AlignToPixel(pe);
  pe.Offset(0.5,0.5);
  ABitmap.canvas.DrawLine(ps, pe, 1);
  ABitmap.canvas.EndScene;
end;

class procedure TGUITools.DrawVLine(ABitmap: TBitmap; x, y1, y2: integer; Color: TAlphaColor; ClipRect: T2DIntRect);
var
  OrgLineRect: T2DIntRect;
  LineRect: T2DIntRect;
  BitmapRect: T2DIntRect;
  tmp: Integer;
  ps, pe: TPointF;
begin
//  if ABitmap.PixelFormat <> pf24bit then
//    raise exception.create('TGUITools.DrawHLine: Bitmapa musi byæ w trybie 24-bitowym!');

  if y2 < y1 then
  begin
    tmp := y1;
    y1 := y2;
    y2 := tmp;
  end;

  BitmapRect := T2DIntRect.create(0, 0, ABitmap.width - 1, ABitmap.height - 1);
  if not (BitmapRect.IntersectsWith(T2DIntRect.create(x, y1, x, y2), OrgLineRect)) then
    exit;

  if not (OrgLineRect.IntersectsWith(ClipRect, LineRect)) then
    exit;
  ABitmap.canvas.BeginScene();
  ABitmap.canvas.Stroke.color := Color;
  ABitmap.canvas.Stroke.Kind := TBrushKind.Solid;
  ps := Pointf(LineRect.left, LineRect.Top);
  pe := PointF(LineRect.left, LineRect.bottom + 1);
  ps := ABitmap.canvas.AlignToPixel(ps);
  ps.Offset(0.5,0.5);
  pe := ABitmap.canvas.AlignToPixel(pe);
  pe.Offset(0.5,0.5);
  ABitmap.canvas.DrawLine(ps, pe, 1);
  ABitmap.canvas.EndScene;
end;

class procedure TGUITools.DrawVLine(ACanvas: TCanvas; x, y1, y2: integer; Color: TAlphaColor);
var
  tmp: integer;
  ps, pe: TPointF;
begin
  if y2 < y1 then
  begin
    tmp := y1;
    y1 := y2;
    y2 := tmp;
  end;
  ACanvas.BeginScene();
  ACanvas.Stroke.color := Color;
  ps := Pointf(x, y1);
  pe := PointF(x, y2 + 1);
  ps := ACanvas.AlignToPixel(ps);
  ps.Offset(0.5,0.5);
  pe := ACanvas.AlignToPixel(pe);
  pe.Offset(0.5,0.5);
  ACanvas.DrawLine(ps, pe, 1);
  ACanvas.EndScene;
end;

class procedure TGUITools.DrawVLine(ACanvas: TCanvas; x, y1, y2: integer; Color: TAlphaColor; ClipRect: T2DIntRect);
var
  UseOrgClipRgn: boolean;
  ClipRgn: TRectF;
  ss: TCanvasSaveState;
begin
  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
  ss := ACanvas.SaveState;
  try
    ClipRgn := RectF(ClipRect.left, ClipRect.Top, ClipRect.Right + 1, ClipRect.Bottom + 1);

//  if UseOrgClipRgn then
//    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

    //ACanvas.IntersectClipRect(ClipRgn);

    DrawVLine(ACanvas, x, y1, y2, Color);
  finally
    ACanvas.RestoreState(ss);
  end;

  // Przywracanie poprzedniego ClipRgn i usuwanie wykorzystanych regionów

end;

//class procedure TGUITools.DrawAARoundFrame(ACanvas: TCanvas; Rect: T2DIntRect; Radius: integer; Color: TAlphaColor);
//begin
//  if (Radius < 1) then
//    exit;
//
//  if (Radius > Rect.width div 2) or (Radius > Rect.height div 2) then
//    exit;
//
//  // DrawAARoundCorner jest zabezpieczony przed rysowaniem poza obszarem
//  DrawAARoundCorner(ACanvas, T2DIntVector.create(Rect.left, Rect.top), Radius, cpLeftTop, Color);
//  DrawAARoundCorner(ACanvas, T2DIntVector.create(Rect.right - Radius + 1, Rect.top), Radius, cpRightTop, Color);
//  DrawAARoundCorner(ACanvas, T2DIntVector.create(Rect.left, Rect.bottom - Radius + 1), Radius, cpLeftBottom, Color);
//  DrawAARoundCorner(ACanvas, T2DIntVector.create(Rect.Right - Radius + 1, Rect.Bottom - Radius + 1), Radius, cpRightBottom, Color);
//
//  ACanvas.Stroke.color := Color;
//  ACanvas.Stroke.Kind := TBrushKind.Solid;;
//
//  // Draw*Line s¹ zabezpieczone przed rysowaniem poza obszarem
//  DrawVLine(ACanvas, Rect.left, Rect.top + Radius, Rect.bottom - Radius, Color);
//  DrawVLine(ACanvas, Rect.right, Rect.top + Radius, Rect.bottom - Radius, Color);
//  DrawHLine(ACanvas, Rect.left + Radius, Rect.right - Radius, Rect.top, Color);
//  DrawHLine(ACanvas, Rect.left + Radius, Rect.right - Radius, Rect.bottom, Color);
//end;
//
//class procedure TGUITools.DrawAARoundFrame(ACanvas: TCanvas; Rect: T2DIntRect; Radius: integer; Color: TAlphaColor; ClipRect: T2DIntRect);
//var
//  UseOrgClipRgn: boolean;
//  ClipRgn: TRectF;
//  ss: TCanvasSaveState;
//begin
//  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
//  ss:= ACanvas.SaveState;
//  try
//  ClipRgn := RectF(ClipRect.left, ClipRect.Top, ClipRect.Right + 1, ClipRect.Bottom + 1);
////  if UseOrgClipRgn then
////    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);
//
//  ACanvas.IntersectClipRect(ClipRgn);
//
//  DrawAARoundFrame(ACanvas, Rect, Radius, Color);
//
//  finally
//     ACanvas.RestoreState(ss);
//  end;
//  // Przywracanie poprzedniego ClipRgn i usuwanie wykorzystanych regionów
////  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
////  DeleteObject(ClipRgn);
//end;

class procedure TGUITools.DrawDisabledImage(ABitmap: TBitmap; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector; ClipRect: T2DIntRect);
begin
  DrawDisabledImage(ABitmap.Canvas, Imagelist, ImageIndex, Point, ClipRect);
end;

class procedure TGUITools.DrawDisabledImage(ABitmap: TBitmap; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector);
begin
  DrawDisabledImage(ABitmap.Canvas, Imagelist, ImageIndex, Point);
end;

class procedure TGUITools.DrawDisabledImage(ACanvas: TCanvas; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector; ClipRect: T2DIntRect);
var
  UseOrgClipRgn: Boolean;
  ClipRgn: TRectF;
//  DCStackPos: integer;
  ss: TCanvasSaveState;
  ImRect: TRectF;
begin
  // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
  ss := ACanvas.SaveState;

  try
    ClipRgn := RectF(ClipRect.left, ClipRect.Top, ClipRect.Right + 1, ClipRect.Bottom + 1);
//  if UseOrgClipRgn then
//    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);
    //ACanvas.IntersectClipRect(ClipRgn);
//    SelectClipRgn(ACanvas.Handle, ClipRgn);

  // Hack poprawiaj¹cy b³¹d w ImageList.Draw, który nie przywraca poprzedniego
  // koloru czcionki dla p³ótna
//    DCStackPos := SaveDC(ACanvas.Handle);
//    Imagelist.Draw(ACanvas, Point.x, Point.y, ImageIndex, false);
    if Imagelist.BitmapExists(ImageIndex) then
    begin
      ImRect := Imagelist.Destination[ImageIndex].Layers.Items[0].SourceRect.Rect;
      ImRect.Offset(PointF(Point.x, Point.y));
      ACanvas.BeginScene();
      Imagelist.Draw(ACanvas, ImRect, ImageIndex, 1);
      ACanvas.EndScene;
    end;

  finally
    ACanvas.RestoreState(ss);
  end;
//  RestoreDC(ACanvas.Handle, DCStackPos);
//
//  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
//
//  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawDisabledImage(ACanvas: TCanvas; Imagelist: TImageList; ImageIndex: integer; Point: T2DIntVector);
var
  DCStackPos: integer;
  ImRect: TRectF;
begin
//  DCStackPos := SaveDC(ACanvas.Handle);
  if Imagelist.BitmapExists(ImageIndex) then
  begin
    ImRect := Imagelist.Destination[ImageIndex].Layers.Items[0].SourceRect.Rect;
    ImRect.Offset(PointF(Point.x, Point.y));
    ACanvas.BeginScene();
    Imagelist.Draw(ACanvas, ImRect, ImageIndex, 1);
    ACanvas.EndScene;
  end;
//  RestoreDC(ACanvas.Handle, DCStackPos);
end;
class procedure TGUITools.DrawCheckbox(ACanvas:TCanvas; x,y: Integer;
  AState: TCheckboxState; AButtonState:TSpkButtonState;
  AStyle: TSpkCheckboxStyle; ClipRect:T2DIntRect);
var
  UseOrgClipRgn: Boolean;
//  OrgRgn: HRGN;
//  ClipRgn: HRGN;
begin
//  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
//  ClipRgn := CreateRectRgn(ClipRect.left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
//  if UseOrgClipRgn then
//    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);
//  SelectClipRgn(ACanvas.Handle, ClipRgn);
  DrawCheckbox(ACanvas, x,y, AState, AButtonState, AStyle);
//  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
//  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawCheckbox(ACanvas: TCanvas; x,y: Integer;
  AState: TCheckboxState; AButtonState: TSpkButtonState;
  AStyle: TSpkCheckboxStyle);
//const
//  NOT_USED = tbCheckboxCheckedNormal;
//const
//  UNTHEMED_FLAGS: array [TSpkCheckboxStyle, TCheckboxState] of Integer = (
//    (DFCS_BUTTONCHECK, DFCS_BUTTONCHECK or DFCS_CHECKED, DFCS_BUTTONCHECK or DFCS_BUTTON3STATE),
//    (DFCS_BUTTONRADIO, DFCS_BUTTONRADIO or DFCS_CHECKED, DFCS_BUTTONRADIO or DFCS_BUTTON3STATE)
//  );
//  THEMED_FLAGS: array [TSpkCheckboxStyle, TCheckboxState, TSpkButtonState] of TThemedButton = (
//    ( (tbCheckboxUncheckedNormal, tbCheckboxUncheckedHot, tbCheckboxUncheckedPressed, tbCheckboxUncheckedDisabled, NOT_USED),
//      (tbCheckboxCheckedNormal, tbCheckboxCheckedHot, tbCheckboxCheckedPressed, tbCheckboxCheckedDisabled, NOT_USED),
//      (tbCheckboxMixedNormal, tbCheckboxMixedHot, tbCheckboxMixedPressed, tbCheckboxMixedDisabled, NOT_USED)
//    ),
//    ( (tbRadioButtonUncheckedNormal, tbRadioButtonUncheckedHot, tbRadioButtonUncheckedPressed, tbRadioButtonUncheckedDisabled, NOT_USED),
//      (tbRadioButtonCheckedNormal, tbRadioButtonCheckedHot, tbRadioButtonCheckedPressed, tbRadioButtonCheckedDisabled, NOT_USED),
//      (tbRadioButtonCheckedNormal, tbRadioButtonCheckedHot, tbRadioButtonCheckedPressed, tbRadioButtonCheckedDisabled, NOT_USED)
//    )
//  );
var
  R: TRect;
  w: Integer;
  sz: TSize;
//  te: TThemedElementDetails;
begin
//  if ThemeServices.ThemesEnabled then begin
//    te := ThemeServices.GetElementDetails(THEMED_FLAGS[AStyle, AState, AButtonState]);
//    sz := ThemeServices.GetDetailSize(te);
//    R := Bounds(x, y, sz.cx, sz.cy);
//    InflateRect(R, 1, 1);
//    ThemeServices.DrawElement(ACanvas.Handle, te, R);
//  end else begin
//    w := GetSystemMetrics(SM_CYMENUCHECK);
//    R := Bounds(x, y, w, w);
//    DrawFrameControl(
//      ACanvas.Handle, R, DFC_BUTTON, UNTHEMED_FLAGS[AStyle, AState]);
//  end;
    case AStyle of
       cbsCheckbox:
       begin
       end;
       cbsRadioButton:
       begin
       end;

    end;
end;

end.

