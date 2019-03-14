unit spkt_BaseItem;

(*******************************************************************************
*                                                                              *
*  Plik: spkt_BaseItem.pas                                                     *
*  Opis: Modu³ zawieraj¹cy bazow¹ klasê dla elementu tafli.                    *
*  Copyright: (c) 2009 by Spook. Jakiekolwiek u¿ycie komponentu bez            *
*             uprzedniego uzyskania licencji od autora stanowi z³amanie        *
*             prawa autorskiego!                                               *
*                                                                              *
*******************************************************************************)

{.$Define EnhancedRecordSupport}

interface

uses
  FMX.Graphics, Classes, FMX.Controls, SpkMath, spkt_Appearance, spkt_Dispatch,
  spkt_Types, FMX.ImgList, System.UITypes, System.Types;

type
  TSpkItemSize = (isLarge, isNormal);

  TSpkItemTableBehaviour = (tbBeginsRow, tbBeginsColumn, tbContinuesRow);

  TSpkItemGroupBehaviour = (gbSingleItem, gbBeginsGroup, gbContinuesGroup, gbEndsGroup);

  TImageListHelper = class helper for TImageList
    function GetWidth: Integer;
    procedure SetWidth(const Value: Integer);
    function GetHeight: Integer;
    procedure SetHeight(const Value: Integer);
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
  end;

  TSpkBaseItem = class(TSpkComponent)
  private
  protected
    FRect: T2DIntRect;
    FToolbarDispatch: TSpkBaseToolbarDispatch;
    FAppearance: TSpkToolbarAppearance;
    FImages: TImageList;
    FDisabledImages: TImageList;
    FLargeImages: TImageList;
    FDisabledLargeImages: TImageList;
    FImagesWidth: Integer;
    FLargeImagesWidth: Integer;
    FVisible: boolean;
    FEnabled: boolean;
    procedure SetVisible(const Value: boolean); virtual;
    procedure SetEnabled(const Value: boolean); virtual;
    procedure SetRect(const Value: T2DIntRect); virtual;
    procedure SetImages(const Value: TImageList); virtual;
    procedure SetDisabledImages(const Value: TImageList); virtual;
    procedure SetLargeImages(const Value: TImageList); virtual;
    procedure SetDisabledLargeImages(const Value: TImageList); virtual;
    procedure SetAppearance(const Value: TSpkToolbarAppearance);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MouseLeave; virtual; abstract;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; abstract;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual; abstract;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; abstract;
    function GetWidth: integer; virtual; abstract;
    function GetTableBehaviour: TSpkItemTableBehaviour; virtual; abstract;
    function GetGroupBehaviour: TSpkItemGroupBehaviour; virtual; abstract;
    function GetSize: TSpkItemSize; virtual; abstract;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect); virtual; abstract;
    property ToolbarDispatch: TSpkBaseToolbarDispatch read FToolbarDispatch write FToolbarDispatch;
    property Appearance: TSpkToolbarAppearance read FAppearance write SetAppearance;
    property Images: TImageList read FImages write SetImages;
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read FImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth;
    property Rect: T2DIntRect read FRect write SetRect;
  published
    property Visible: boolean read FVisible write SetVisible default true;
    property Enabled: boolean read FEnabled write SetEnabled default true;
  end;

  TSpkBaseItemClass = class of TSpkBaseItem;

implementation

{ TSpkBaseItem }

constructor TSpkBaseItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

//  {$IFDEF EnhancedRecordSupport}
  FRect := T2DIntRect.create(0, 0, 0, 0);
//  {$ELSE}
//  FRect.create(0, 0, 0, 0);
//  {$ENDIF}

  FToolbarDispatch := nil;
  FAppearance := nil;
  FImages := nil;
  FDisabledImages := nil;
  FLargeImages := nil;
  FDisabledLargeImages := nil;
  FVisible := true;
  FEnabled := true;
end;

destructor TSpkBaseItem.Destroy;
begin
  { Pozosta³e operacje }
  inherited Destroy;
end;

procedure TSpkBaseItem.SetAppearance(const Value: TSpkToolbarAppearance);
begin
  FAppearance := Value;

  if assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TSpkBaseItem.SetDisabledImages(const Value: TImageList);
begin
  FDisabledImages := Value;
end;

procedure TSpkBaseItem.SetDisabledLargeImages(const Value: TImageList);
begin
  FDisabledLargeImages := Value;
end;

procedure TSpkBaseItem.SetEnabled(const Value: boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    if FToolbarDispatch <> nil then
      FToolbarDispatch.NotifyVisualsChanged;
  end;
end;

procedure TSpkBaseItem.SetImages(const Value: TImageList);
begin
  FImages := Value;
end;

procedure TSpkBaseItem.SetImagesWidth(const Value: Integer);
begin
  FImagesWidth := Value;
end;

procedure TSpkBaseItem.SetLargeImages(const Value: TImageList);
begin
  FLargeImages := Value;
end;

procedure TSpkBaseItem.SetLargeImagesWidth(const Value: Integer);
begin
  FLargeImagesWidth := Value;
end;

procedure TSpkBaseItem.SetRect(const Value: T2DIntRect);
begin
  FRect := Value;
end;

procedure TSpkBaseItem.SetVisible(const Value: boolean);
begin
  if Value <> FVisible then
  begin
    FVisible := Value;
    if FToolbarDispatch <> nil then
      FToolbarDispatch.NotifyMetricsChanged;
  end;
end;

{ TImageListHelper }

function TImageListHelper.GetWidth: Integer;
var
  ImRect: TRectF;
begin
//  DCStackPos := SaveDC(ACanvas.Handle);
  Result := 0;
  if BitmapExists(0) then
  begin
    ImRect := Destination[0].Layers.Items[0].SourceRect.Rect;
    Result := Round(ImRect.Width)
  end;

end;

procedure TImageListHelper.SetWidth(const Value: Integer);
begin
//
end;

function TImageListHelper.GetHeight: Integer;
var
  ImRect: TRectF;
begin
//  DCStackPos := SaveDC(ACanvas.Handle);
  Result := 0;
  if BitmapExists(0) then
  begin
    ImRect := Destination[0].Layers.Items[0].SourceRect.Rect;
    Result := Round(ImRect.Height)
  end;

end;

procedure TImageListHelper.SetHeight(const Value: Integer);
begin
//
end;

end.

