unit spkt_Pane;
{$DEFINE EnhancedRecordSupport}
(*******************************************************************************
*                                                                              *
*  Plik: spkt_Pane.pas                                                         *
*  Opis: Komponent tafli toolbara                                              *
*  Copyright: (c) 2009 by Spook. Jakiekolwiek u¿ycie komponentu bez            *
*             uprzedniego uzyskania licencji od autora stanowi z³amanie        *
*             prawa autorskiego!                                               *
*                                                                              *
*******************************************************************************)

interface

uses
  FMX.Graphics, FMX.Controls, Classes, SysUtils, Math, FMX.Dialogs, FMX.Types,
  SpkGraphTools, SpkGUITools, SpkMath, FMX.ImgList, System.UITypes,
  spkt_Appearance, spkt_Const, spkt_Dispatch, spkt_Exceptions, spkt_BaseItem,
  spkt_Items, spkt_Types;

type
  TSpkPaneState = (psIdle, psHover);

type
  TSpkMousePaneElementType = (peNone, pePaneArea, peItem);

  TSpkMousePaneElement = record
    ElementType: TSpkMousePaneElementType;
    ElementIndex: integer;
  end;

  T2DIntRectArray = array of T2DIntRect;

  TSpkPaneItemsLayout = record
    Rects: T2DIntRectArray;
    Width: integer;
  end;

type
  TSpkPane = class;

  TSpkPane = class(TSpkComponent)
  private
    FPaneState: TSpkPaneState;
    FMouseHoverElement: TSpkMousePaneElement;
    FMouseActiveElement: TSpkMousePaneElement;
  protected
    FCaption: string;
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
    FItems: TSpkItems;

    // *** Generating a layout of elements ***
    function GenerateLayout: TSpkPaneItemsLayout;

    // *** Designtime and LFM support ***
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;

    // *** Getters and setters ***
    procedure SetCaption(const Value: string);
    procedure SetVisible(const Value: boolean);
    procedure SetAppearance(const Value: TSpkToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
    procedure SetRect(ARect: T2DIntRect);
    procedure SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
  public
    // *** Constructor, destructor ***
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // *** Mouse support ***
    procedure MouseLeave;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    // *** Geometry and drawing ***
    function GetWidth: integer;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
    function FindItemAt(x, y: integer): integer;

    // *** Support for elements ***
    procedure FreeingItem(AItem: TSpkBaseItem);
    property ToolbarDispatch: TSpkBaseToolbarDispatch read FToolbarDispatch write SetToolbarDispatch;
    property Appearance: TSpkToolbarAppearance read FAppearance write SetAppearance;
    property Rect: T2DIntRect read FRect write SetRect;
    property Images: TImageList read FImages write SetImages;
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read FImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth;
    property Items: TSpkItems read FItems;
  published
    property Caption: string read FCaption write SetCaption;
    property Visible: boolean read FVisible write SetVisible default true;
  end;

type
  TSpkPanes = class(TSpkCollection)
  private
  protected
    FToolbarDispatch: TSpkBaseToolbarDispatch;
    FAppearance: TSpkToolbarAppearance;
    FImages: TImageList;
    FDisabledImages: TImageList;
    FLargeImages: TImageList;
    FDisabledLargeImages: TImageList;
    FImagesWidth: Integer;
    FLargeImagesWidth: Integer;

    // *** Getters and setters ***
    procedure SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
    function GetItems(AIndex: integer): TSpkPane; reintroduce;
    procedure SetAppearance(const Value: TSpkToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
    
  public
     // *** Konstruktor, destruktor ***
    constructor Create(RootComponent: TComponent); override;
    destructor Destroy; override;

    // *** Adding and inserting elements ***
    function Add: TSpkPane;
    function Insert(AIndex: integer): TSpkPane;

    // *** Reaction to changes in the list ***
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    procedure Delete(index: integer); override;
    procedure Update; override;
    property Items[index: integer]: TSpkPane read GetItems; default;
    property ToolbarDispatch: TSpkBaseToolbarDispatch read FToolbarDispatch write SetToolbarDispatch;
    property Appearance: TSpkToolbarAppearance read FAppearance write SetAppearance;
    property Images: TImageList read FImages write SetImages;
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read FImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth;
  end;

implementation

{ TSpkPane }


constructor TSpkPane.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPaneState := psIdle;
  FMouseHoverElement.ElementType := peNone;
  FMouseHoverElement.ElementIndex := -1;
  FMouseActiveElement.ElementType := peNone;
  FMouseActiveElement.ElementIndex := -1;

  FCaption := 'Pane';
  FRect := T2DIntRect.create(0, 0, 0, 0);

  FToolbarDispatch := nil;
  FAppearance := nil;
  FImages := nil;
  FDisabledImages := nil;
  FLargeImages := nil;
  FDisabledLargeImages := nil;

  FVisible := true;

  FItems := TSpkItems.Create(self);
  FItems.ToolbarDispatch := FToolbarDispatch;
  FItems.Appearance := FAppearance;
  FItems.ImagesWidth := FImagesWidth;
  FItems.LargeImagesWidth := FLargeImagesWidth;
end;


destructor TSpkPane.Destroy;
begin
  FItems.Free;

  inherited Destroy;
end;

procedure TSpkPane.SetRect(ARect: T2DIntRect);
var
  Pt: T2DIntPoint;
  i: integer;
  Layout: TSpkPaneItemsLayout;
begin
  FRect := ARect;

// Obliczamy layout
  Layout := GenerateLayout;

  Pt := T2DIntPoint.create(ARect.left + PANE_BORDER_SIZE + PANE_LEFT_PADDING, ARect.top + PANE_BORDER_SIZE);
  if length(Layout.Rects) > 0 then
  begin
    for i := 0 to high(Layout.Rects) do
    begin
      FItems[i].Rect := Layout.Rects[i] + Pt;
    end;
  end;
end;

procedure TSpkPane.SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
begin
  FToolbarDispatch := Value;
  FItems.ToolbarDispatch := FToolbarDispatch;
end;


procedure TSpkPane.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);

  Filer.DefineProperty('Items', FItems.ReadNames, FItems.WriteNames, true);
end;
procedure TSpkPane.Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
var
  x: Integer;
  y: Integer;
  c, BgFromColor, BgToColor, CaptionColor, FontColor, BorderLightColor, BorderDarkColor: TAlphaColor;
  i: Integer;
  R: T2DIntRect;
  delta: Integer;

begin
  // Under some conditions, we are not able to draw::
  // * No dispatcher
  if FToolbarDispatch = nil then
    exit;
  // * No appearance
  if FAppearance = nil then
    exit;

  if FPaneState = psIdle then
  begin
   // psIdle
    BgFromColor := FAppearance.Pane.GradientFromColor;
    BgToColor := FAppearance.Pane.GradientToColor;
    CaptionColor := FAppearance.Pane.CaptionBgColor;
    FontColor := FAppearance.Pane.CaptionFontColor;
    BorderLightColor := FAppearance.Pane.BorderLightColor;
    BorderDarkColor := FAppearance.Pane.BorderDarkColor;
  end
  else
  begin
       // psHover
    delta := FAppearance.Pane.HotTrackBrightnessChange;
    BgFromColor := TColorTools.Brighten(FAppearance.Pane.GradientFromColor, delta);
    BgToColor := TColorTools.Brighten(FAppearance.Pane.GradientToColor, delta);
    CaptionColor := TColorTools.Brighten(FAppearance.Pane.CaptionBgColor, delta);
    FontColor := TColorTools.Brighten(FAppearance.Pane.CaptionFontColor, delta);
    BorderLightColor := TColorTools.Brighten(FAppearance.Pane.BorderLightColor, delta);
    BorderDarkColor := TColorTools.Brighten(FAppearance.Pane.BorderDarkColor, delta);
  end;

  // The background
  {$IFDEF EnhancedRecordSupport}
  R := T2DIntRect.Create(
  {$ELSE}
  R := Create2DIntRect(
  {$ENDIF}
    FRect.Left,
    FRect.Top,
    FRect.Right - PANE_BORDER_HALF_SIZE,
    FRect.Bottom - PANE_BORDER_HALF_SIZE
  );
  TGuiTools.DrawRoundRect(
    ABuffer.Canvas,
    R,
    PANE_CORNER_RADIUS,
    BgFromColor,
    BgToColor,
    FAppearance.Pane.GradientType,
    ClipRect
  );

  // Label background
  {$IFDEF EnhancedRecordSupport}
  R := T2DIntRect.Create(
  {$ELSE}
  R := Create2DIntRect(
  {$ENDIF}
    FRect.Left,
    FRect.Bottom - PANE_CAPTION_HEIGHT - PANE_BORDER_HALF_SIZE,
    FRect.Right - PANE_BORDER_HALF_SIZE,
    FRect.Bottom - PANE_BORDER_HALF_SIZE
  );
  TGuiTools.DrawRoundRect(
    ABuffer.Canvas,
    R,
    PANE_CORNER_RADIUS,
    CaptionColor,
    clNone,
    bkSolid,
    ClipRect,
    false,
    false,
    true,
    true
  );

  // Pane label
  ABuffer.Canvas.Font.Assign(FAppearance.Pane.CaptionFont);
  ABuffer.Canvas.Fill.Color:=FAppearance.Pane.CaptionFontColor;

  x := FRect.Left + (FRect.Width - Round(ABuffer.Canvas.TextWidth(FCaption))) div 2;
  y := FRect.Bottom - PANE_BORDER_SIZE - PANE_CAPTION_HEIGHT + 1 +
        (PANE_CAPTION_HEIGHT - Round(ABuffer.Canvas.TextHeight('Wy'))) div 2;

  TGUITools.DrawText(
    ABuffer.Canvas,
    x,
    y,
    FCaption,
    FontColor,
    ClipRect
  );

  // Frames
  case FAppearance.Pane.Style of
    psRectangleFlat:
      begin
        {$IFDEF EnhancedRecordSupport}
        R := T2DIntRect.Create(
        {$ELSE}
        R := Create2DIntRect(
        {$ENDIF}
          FRect.Left,
          FRect.Top,
          FRect.Right,
          FRect.bottom
        );
        TGUITools.DrawAARoundFrame(
          ABuffer,
          R,
          PANE_CORNER_RADIUS,
          BorderDarkColor,
          ClipRect
        );
     end;

   psRectangleEtched, psRectangleRaised:
     begin
       {$IFDEF EnhancedRecordSupport}
       R := T2DIntRect.Create(
       {$ELSE}
       R := Create2DIntRect(
       {$ENDIF}
         FRect.Left + 1,
         FRect.Top + 1,
         FRect.Right,
         FRect.bottom
       );
       if FAppearance.Pane.Style = psRectangleEtched then
         c := BorderLightColor else
         c := BorderDarkColor;
       TGUITools.DrawAARoundFrame(
         ABuffer,
         R,
         PANE_CORNER_RADIUS,
         c,
         ClipRect
       );

       {$IFDEF EnhancedRecordSupport}
       R := T2DIntRect.Create(
       {$ELSE}
       R := Create2DIntRect(
       {$ENDIF}
         FRect.Left,
         FRect.Top,
         FRect.Right-1,
         FRect.Bottom-1
       );
       if FAppearance.Pane.Style = psRectangleEtched then
         c := BorderDarkColor
       else
         c := BorderLightColor;
       TGUITools.DrawAARoundFrame(
         ABuffer,
         R,
         PANE_CORNER_RADIUS,
         c,
         ClipRect
       );
     end;

   psDividerRaised, psDividerEtched:
     begin
       if FAppearance.Pane.Style = psDividerRaised then
         c := BorderLightColor else
         c := BorderDarkColor;
       TGUITools.DrawVLine(
         ABuffer,
         FRect.Right + PANE_BORDER_HALF_SIZE - 1,
         FRect.Top,
         FRect.Bottom,
         c
       );
       if FAppearance.Pane.Style = psDividerRaised then
         c := BorderDarkColor
       else
         c := BorderLightColor;
       TGUITools.DrawVLine(
         ABuffer,
         FRect.Right + PANE_BORDER_HALF_SIZE,
         FRect.Top,
         FRect.Bottom,
         c
       );
     end;

   psDividerFlat:
     TGUITools.DrawVLine(
       ABuffer,
       FRect.Right + PANE_BORDER_HALF_SIZE,
       FRect.Top,
       FRect.Bottom,
       BorderDarkColor
     );
  end;

  // Elements
    for i := 0 to FItems.Count - 1 do
      if FItems[i].Visible then
        Fitems[i].Draw(ABuffer, ClipRect);
end;

function TSpkPane.FindItemAt(x, y: integer): integer;
var
  i: integer;
begin
  result := -1;
  i := FItems.count - 1;
  while (i >= 0) and (result = -1) do
  begin
    if FItems[i].Visible then
    begin
      if FItems[i].Rect.contains(T2DIntVector.create(x, y)) then
        result := i;
    end;
    dec(i);
  end;
end;

procedure TSpkPane.FreeingItem(AItem: TSpkBaseItem);
begin
  FItems.RemoveReference(AItem);
end;

function TSpkPane.GenerateLayout: TSpkPaneItemsLayout;
type
  TLayoutRow = array of integer;

  TLayoutColumn = array of TLayoutRow;

  TLayout = array of TLayoutColumn;
var
  Layout: TLayout;
  CurrentColumn: integer;
  CurrentRow: integer;
  CurrentItem: integer;
  c, r, i: Integer;
  ItemTableBehaviour: TSpkItemTableBehaviour;
  ItemGroupBehaviour: TSpkItemGroupBehaviour;
  ItemSize: TSpkItemSize;
  ForceNewColumn: boolean;
  LastX: integer;
  MaxRowX: integer;
  ColumnX: integer;
  rows: Integer;
  ItemWidth: Integer;
  tmpRect: T2DIntRect;
begin
  setlength(result.Rects, FItems.count);
  result.Width := 0;

  if FItems.count = 0 then
    exit;

  // Note: the algorithm is structured in such a way that three of them,
  // CurrentColumn, CurrentRow and CurrentItem, point to an element that
  // is not yet present (just after the recently added element).

  setlength(Layout, 1);
  CurrentColumn := 0;

  setlength(Layout[CurrentColumn], 1);
  CurrentRow := 0;

  setlength(Layout[CurrentColumn][CurrentRow], 0);
  CurrentItem := 0;

  ForceNewColumn := false;

  for i := 0 to FItems.count - 1 do
  begin
    ItemTableBehaviour := FItems[i].GetTableBehaviour;
    ItemSize := FItems[i].GetSize;

    // Starting a new column?
    if (i=0) or
       (ItemSize = isLarge) or
       (ItemTableBehaviour = tbBeginsColumn) or
       ((ItemTableBehaviour = tbBeginsRow) and (CurrentRow = 2)) or
       (ForceNewColumn) then
    begin
      // If we are already at the beginning of the new column, there is nothing to do.
      if (CurrentRow <> 0) or (CurrentItem <> 0) then
      begin
        setlength(Layout, length(Layout) + 1);
        CurrentColumn := high(Layout);

        setlength(Layout[CurrentColumn], 1);
        CurrentRow := 0;

        setlength(Layout[CurrentColumn][CurrentRow], 0);
        CurrentItem := 0;
      end;
    end else
    // Starting a new row?
if (ItemTableBehaviour = tbBeginsRow) then
    begin
      // If we are already at the beginning of a new poem, there is nothing to do.
      if CurrentItem <> 0 then
      begin
        setlength(Layout[CurrentColumn], length(Layout[CurrentColumn]) + 1);
        inc(CurrentRow);
        CurrentItem := 0;
      end;
    end;

    ForceNewColumn := (ItemSize = isLarge);

    // If the item is visible, we add it in the current column and the current row.
    if FItems[i].Visible then
    begin
      setlength(Layout[CurrentColumn][CurrentRow], length(Layout[CurrentColumn][CurrentRow]) + 1);
      Layout[CurrentColumn][CurrentRow][CurrentItem] := i;

      inc(CurrentItem);
    end;
  end;

  // We have a ready layout here. Now you have to calculate the positions
  // and sizes of the Rects.

  // First, fill them with empty data that will fill the place of invisible elements.
  for i := 0 to FItems.count - 1 do
    result.Rects[i] := T2DIntRect.create(-1, -1, -1, -1);

  MaxRowX := 0;

  // Now, we iterate through the layout, fixing the recit.
  if length(Layout) > 0 then
    for c := 0 to high(Layout) do
    begin
      if c > 0 then
      begin
        LastX := MaxRowX + PANE_COLUMN_SPACER;
        MaxRowX := LastX;
      end
      else
      begin
        LastX := MaxRowX;
      end;

      ColumnX := LastX;

      rows := length(Layout[c]);
      if rows > 0 then
        for r := 0 to rows - 1 do
        begin
          LastX := ColumnX;

          if length(Layout[c][r]) > 0 then
            for i := 0 to high(Layout[c][r]) do
            begin
              ItemGroupBehaviour := FItems[Layout[c][r][i]].GetGroupBehaviour;
              ItemSize := FItems[Layout[c][r][i]].GetSize;
              ItemWidth := FItems[Layout[c][r][i]].GetWidth;
              if ItemSize = isLarge then
              begin
                tmpRect.top := PANE_FULL_ROW_TOPPADDING;
                tmpRect.bottom := tmpRect.top + PANE_FULL_ROW_HEIGHT - 1;
                tmpRect.left := LastX;
                tmpRect.right := LastX + ItemWidth - 1;

                LastX := tmpRect.right + 1;
                if LastX > MaxRowX then
                  MaxRowX := LastX;
              end
              else
              begin
                if ItemGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
                begin
                  tmpRect.Left := LastX;
                  tmpRect.right := tmpRect.Left + ItemWidth - 1;
                end
                else
                begin
            // If the element is not the first one, it must be offset by
            // the margin from the previous one
                  if i > 0 then
                    tmpRect.Left := LastX + PANE_GROUP_SPACER
                  else
                    tmpRect.Left := LastX;
                  tmpRect.right := tmpRect.Left + ItemWidth - 1;
                end;

          {$REGION 'Calculation of tmpRect.top and bottom'}
                case rows of
            1 : begin
                  tmpRect.Top := PANE_ONE_ROW_TOPPADDING;
                  tmpRect.Bottom := tmpRect.Top + PANE_ROW_HEIGHT - 1;
                          end;
            2 : case r of
                  0 : begin
                        tmpRect.Top := PANE_TWO_ROWS_TOPPADDING;
                        tmpRect.Bottom := tmpRect.top + PANE_ROW_HEIGHT - 1;
                          end;
                  1 : begin
                        tmpRect.Top := PANE_TWO_ROWS_TOPPADDING + PANE_ROW_HEIGHT + PANE_TWO_ROWS_VSPACER;
                        tmpRect.Bottom := tmpRect.top + PANE_ROW_HEIGHT - 1;
                      end;
                    end;
            3 : case r of
                  0 : begin
                        tmpRect.Top := PANE_THREE_ROWS_TOPPADDING;
                        tmpRect.Bottom := tmpRect.Top + PANE_ROW_HEIGHT - 1;
                          end;
                  1 : begin
                        tmpRect.Top := PANE_THREE_ROWS_TOPPADDING + PANE_ROW_HEIGHT + PANE_THREE_ROWS_VSPACER;
                        tmpRect.Bottom := tmpRect.Top + PANE_ROW_HEIGHT - 1;
                          end;
                  2 : begin
                        tmpRect.Top := PANE_THREE_ROWS_TOPPADDING + 2 * PANE_ROW_HEIGHT + 2 * PANE_THREE_ROWS_VSPACER;
                        tmpRect.Bottom := tmpRect.Top + Pane_Row_Height - 1;
                          end;
                      end;
                    end;
          {$ENDREGION}

                LastX := tmpRect.right + 1;
                if LastX > MaxRowX then
                  MaxRowX := LastX;
              end;

              Result.Rects[Layout[c][r][i]] := tmpRect;
            end;
        end;
    end;
  // At this point, MaxRowX points to the first pixel behind the most
  // right-hand element - ergo is equal to the width of the entire layout.
  Result.Width := MaxRowX;
end;

procedure TSpkPane.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  inherited;

  if FItems.Count > 0 then
    for i := 0 to FItems.Count - 1 do
      Proc(FItems.Items[i]);
end;

function TSpkPane.GetWidth: integer;
var
  tmpBitmap: TBitmap;
  PaneCaptionWidth, PaneElementsWidth: integer;
  TextW: integer;
  ElementsW: integer;
  Layout: TSpkPaneItemsLayout;
begin
  // Preparing...
  result := -1;
  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;

  tmpBitmap := FToolbarDispatch.GetTempBitmap;
  if tmpBitmap = nil then
    exit;
  tmpBitmap.Canvas.font.assign(FAppearance.Pane.CaptionFont);

  // *** The minimum width of the sheet (text) ***
  TextW := round(tmpBitmap.Canvas.TextWidth(FCaption));
  PaneCaptionWidth := 2 * PANE_BORDER_SIZE + 2 * PANE_CAPTION_HMARGIN + TextW;

  // *** The width of the elements of the sheet ***
  Layout := GenerateLayout;
  ElementsW := Layout.Width;
  PaneElementsWidth := PANE_BORDER_SIZE + PANE_LEFT_PADDING + ElementsW + PANE_RIGHT_PADDING + PANE_BORDER_SIZE;

  // *** Setting the width of the pane ***
  result := max(PaneCaptionWidth, PaneElementsWidth);
end;

procedure TSpkPane.Loaded;
begin
  inherited;
  if FItems.ListState = lsNeedsProcessing then
    FItems.ProcessNames(self.Owner);
end;

procedure TSpkPane.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FMouseActiveElement.ElementType = peItem then
  begin
    if FMouseActiveElement.ElementIndex <> -1 then
      FItems[FMouseActiveElement.ElementIndex].MouseDown(Button, Shift, X, Y);
  end
  else if FMouseActiveElement.ElementType = pePaneArea then
  begin
    FPaneState := psHover;
  end
  else if FMouseActiveElement.ElementType = peNone then
  begin
    if FMouseHoverElement.ElementType = peItem then
    begin
      if FMouseHoverElement.ElementIndex <> -1 then
      begin
        FMouseActiveElement.ElementType := peItem;
        FMouseActiveElement.ElementIndex := FMouseHoverElement.ElementIndex;

        FItems[FMouseHoverElement.ElementIndex].MouseDown(Button, Shift, X, Y);
      end
      else
      begin
        FMouseActiveElement.ElementType := pePaneArea;
        FMouseActiveElement.ElementIndex := -1;
      end;
    end
    else if FMouseHoverElement.ElementType = pePaneArea then
    begin
      FMouseActiveElement.ElementType := pePaneArea;
      FMouseActiveElement.ElementIndex := -1;

      // Placeholder, if there is a need to handle this event.
    end;
  end;
end;

procedure TSpkPane.MouseLeave;
begin
  if FMouseActiveElement.ElementType = peNone then
  begin
    if FMouseHoverElement.ElementType = peItem then
    begin
      if FMouseHoverElement.ElementIndex <> -1 then
        FItems[FMouseHoverElement.ElementIndex].MouseLeave;
    end
    else if FMouseHoverElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event.
    end;
  end;

  FMouseHoverElement.ElementType := peNone;
  FMouseHoverElement.ElementIndex := -1;

  // Regardless of which item was active / under the mouse, you need to
  // expire HotTrack.
  if FPaneState <> psIdle then
  begin
    FPaneState := psIdle;
    if assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
  end;
end;

procedure TSpkPane.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  NewMouseHoverElement: TSpkMousePaneElement;
begin
  // MouseMove is only called when the tile is active, or when the mouse moves
  // inside its area. Therefore, it is always necessary to ignite HotTrack
  // in this situation.

  if FPaneState = psIdle then
  begin
    FPaneState := psHover;
    if assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
  end;

  // We're looking for an object under the mouse
  i := FindItemAt(X, Y);
  if i <> -1 then
  begin
    NewMouseHoverElement.ElementType := peItem;
    NewMouseHoverElement.ElementIndex := i;
  end
  else if (X >= FRect.left) and (Y >= FRect.top) and (X <= FRect.right) and (Y <= FRect.bottom) then
  begin
    NewMouseHoverElement.ElementType := pePaneArea;
    NewMouseHoverElement.ElementIndex := -1;
  end
  else
  begin
    NewMouseHoverElement.ElementType := peNone;
    NewMouseHoverElement.ElementIndex := -1;
  end;

  if FMouseActiveElement.ElementType = peItem then
  begin
    if FMouseActiveElement.ElementIndex <> -1 then
      FItems[FMouseActiveElement.ElementIndex].MouseMove(Shift, X, Y);
  end
  else if FMouseActiveElement.ElementType = pePaneArea then
  begin
    // Placeholder, if there is a need to handle this event
  end
  else if FMouseActiveElement.ElementType = peNone then
  begin
    // If the item under the mouse changes, we inform the previous element
    // that the mouse leaves its area

    if (NewMouseHoverElement.ElementType <> FMouseHoverElement.ELementType) or (NewMouseHoverElement.ElementIndex <> FMouseHoverElement.ElementIndex) then
    begin
      if FMouseHoverElement.ElementType = peItem then
      begin
        if FMouseHoverElement.ElementIndex <> -1 then
          FItems[FMouseHoverElement.ElementIndex].MouseLeave;
      end
      else if FMouseHoverElement.ElementType = pePaneArea then
      begin
        // Placeholder, if there is a need to handle this event
      end;
    end;

    if NewMouseHoverElement.ElementType = peItem then
    begin
      if NewMouseHoverElement.ElementIndex <> -1 then
        FItems[NewMouseHoverElement.ElementIndex].MouseMove(Shift, X, Y);
    end
    else if NewMouseHoverElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event
    end;
  end;

  FMouseHoverElement := NewMouseHoverElement;
end;

procedure TSpkPane.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ClearActive: boolean;
begin
  ClearActive := not (ssLeft in Shift) and not (ssMiddle in Shift) and not (ssRight in Shift);

  if FMouseActiveElement.ElementType = peItem then
  begin
    if FMouseActiveElement.ElementIndex <> -1 then
      FItems[FMouseActiveElement.ElementIndex].MouseUp(Button, Shift, X, Y);
  end
  else if FMouseActiveElement.ElementType = pePaneArea then
  begin
    // Placeholder, if there is a need to handle this event
  end;

  if ClearActive and (FMouseActiveElement.ElementType <> FMouseHoverElement.ElementType) or (FMouseActiveElement.ElementIndex <> FMouseHoverElement.ElementIndex) then
  begin
    if FMouseActiveElement.ElementType = peItem then
    begin
      if FMouseActiveElement.ElementIndex <> -1 then
        FItems[FMouseActiveElement.ElementIndex].MouseLeave;
    end
    else if FMouseActiveElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event
    end;

    if FMouseHoverElement.ElementType = peItem then
    begin
      if FMouseActiveElement.ElementIndex <> -1 then
        FItems[FMouseActiveElement.ElementIndex].MouseMove(Shift, X, Y);
    end
    else if FMouseHoverElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event
    end
    else if FMouseHoverElement.ElementType = peNone then
    begin
      if FPaneState <> psIdle then
      begin
        FPaneState := psIdle;
        if assigned(FToolbarDispatch) then
          FToolbarDispatch.NotifyVisualsChanged;
      end;
    end;
  end;

  if ClearActive then
  begin
    FMouseActiveElement.ElementType := peNone;
    FMouseActiveElement.ElementIndex := -1;
  end;
end;

procedure TSpkPane.SetAppearance(const Value: TSpkToolbarAppearance);
begin
  FAppearance := Value;
  FItems.Appearance := Value;
end;

procedure TSpkPane.SetCaption(const Value: string);
begin
  FCaption := Value;
  if assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TSpkPane.SetDisabledImages(const Value: TImageList);
begin
  FDisabledImages := Value;
  FItems.DisabledImages := FDisabledImages;
end;

procedure TSpkPane.SetDisabledLargeImages(const Value: TImageList);
begin
  FDisabledLargeImages := Value;
  FItems.DisabledLargeImages := FDisabledLargeImages;
end;

procedure TSpkPane.SetImages(const Value: TImageList);
begin
  FImages := Value;
  FItems.Images := FImages;
end;

procedure TSpkPane.SetImagesWidth(const Value: Integer);
begin
  FImagesWidth := Value;
  FItems.ImagesWidth := FImagesWidth;
end;

procedure TSpkPane.SetLargeImages(const Value: TImageList);
begin
  FLargeImages := Value;
  FItems.LargeImages := FLargeImages;
end;

procedure TSpkPane.SetLargeImagesWidth(const Value: Integer);
begin
  FLargeImagesWidth := Value;
  FItems.LargeImagesWidth := FLargeImagesWidth;
end;

procedure TSpkPane.SetVisible(const Value: boolean);
begin
  FVisible := Value;

  if assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyItemsChanged;
end;

{ TSpkPanes }

function TSpkPanes.Add: TSpkPane;
var
  i: Integer;
begin
if FRootComponent = nil then
  Exit;

  Result := TSpkPane.Create(FRootComponent.Owner);
  Result.Parent := FRootComponent;

  if FRootComponent <> nil then
  begin
    i := 1;
    while FRootComponent.Owner.FindComponent('SpkPane' + inttostr(i)) <> nil do
      inc(i);

    result.Name := 'SpkPane' + inttostr(i);
  end;

  AddItem(result);
end;

constructor TSpkPanes.Create(RootComponent: TComponent);
begin
  inherited Create(RootComponent);
  FToolbarDispatch := nil;
  FAppearance := nil;
  FImages := nil;
  FDisabledImages := nil;
  FLargeImages := nil;
  FDisabledLargeImages := nil;
end;

procedure TSpkPanes.Delete(index: Integer);
var
  i: Integer;
  pn: TSpkPane;
begin

  pn:= Items[index];
//  for I := pn.Items.Count  - 1 downto 0 do
//  begin
//    pn.Items.Delete(i);
//  end;

  inherited Delete(index);
end;

destructor TSpkPanes.Destroy;
begin
  inherited Destroy;
end;

function TSpkPanes.GetItems(Aindex: integer): TSpkPane;
begin
  result := TSpkPane(inherited Items[Aindex]);
end;

function TSpkPanes.Insert(AIndex: integer): TSpkPane;
var
  Owner, Parent: TComponent;
  i: Integer;
begin
  if (AIndex < 0) or (AIndex > self.Count) then
    raise InternalException.Create('TSpkPanes.Insert: Invalid index!');

  if FRootComponent <> nil then
  begin
    Owner := FRootComponent.Owner;
    Parent := FRootComponent;
  end
  else
  begin
    Owner := nil;
    Parent := nil;
  end;

  result := TSpkPane.Create(Parent);
  result.Parent := Parent;

  if FRootComponent <> nil then
  begin
    i := 0;
    while FRootComponent.FindComponent('SpkPane' + inttostr(i)) <> nil do
      inc(i);

    result.Name := 'SpkPane' + inttostr(i);
  end;

  InsertItem(AIndex, Result);
end;

procedure TSpkPanes.Notify(Item: TComponent; Operation: TOperation);
begin
  inherited Notify(Item, Operation);

  case Operation of
    opInsert:
      begin
        // Setting the dispatcher to nil will cause that during the
        // ownership assignment, the Notify method will not be called
        TSpkPane(Item).ToolbarDispatch := nil;

        TSpkPane(Item).Appearance := FAppearance;
        TSpkPane(Item).Images := FImages;
        TSpkPane(Item).DisabledImages := FDisabledImages;
        TSpkPane(Item).LargeImages := FLargeImages;
        TSpkPane(Item).DisabledLargeImages := FDisabledLargeImages;
        TSpkPane(Item).ImagesWidth := FImagesWidth;
        TSpkPane(Item).LargeImagesWidth := FLargeImagesWidth;
        TSpkPane(Item).ToolbarDispatch := FToolbarDispatch;
      end;
    opRemove:
      begin
        if not (csDestroying in Item.ComponentState) then
        begin
          TSpkPane(Item).ToolbarDispatch := nil;
          TSpkPane(Item).Appearance := nil;
          TSpkPane(Item).Images := nil;
          TSpkPane(Item).DisabledImages := nil;
          TSpkPane(Item).LargeImages := nil;
          TSpkPane(Item).DisabledLargeImages := nil;

//          FreeAndNil(TSpkPane(Item));
        end;
      end;
  end;
end;

procedure TSpkPanes.SetImages(const Value: TImageList);
var
  I: Integer;
begin
  FImages := Value;
  if self.Count > 0 then
    for I := 0 to self.count - 1 do
      Items[I].Images := Value;
end;

procedure TSpkPanes.SetImagesWidth(const Value: Integer);
var
  I: Integer;
begin
  FImagesWidth := Value;
  for I := 0 to Count - 1 do
    Items[i].ImagesWidth := Value;
end;

procedure TSpkPanes.SetLargeImages(const Value: TImageList);
var
  I: Integer;
begin
  FLargeImages := Value;
  if self.Count > 0 then
    for I := 0 to self.count - 1 do
      Items[I].LargeImages := Value;
end;

procedure TSpkPanes.SetLargeImagesWidth(const Value: Integer);
var
  I: Integer;
begin
  FLargeImagesWidth := Value;
  for I := 0 to Count - 1 do
    Items[i].LargeImagesWidth := Value;
end;

procedure TSpkPanes.SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
var
  i: integer;
begin
  FToolbarDispatch := Value;
  if self.Count > 0 then
    for i := 0 to self.count - 1 do
      Items[i].ToolbarDispatch := FToolbarDispatch;
end;

procedure TSpkPanes.SetAppearance(const Value: TSpkToolbarAppearance);
var
  i: Integer;
begin
  FAppearance := Value;
  if self.Count > 0 then
    for i := 0 to self.count - 1 do
      Items[i].Appearance := FAppearance;

  if FToolbarDispatch <> nil then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TSpkPanes.SetDisabledImages(const Value: TImageList);
var
  I: Integer;
begin
  FDisabledImages := Value;
  if self.Count > 0 then
    for I := 0 to self.count - 1 do
      Items[I].DisabledImages := Value;
end;

procedure TSpkPanes.SetDisabledLargeImages(const Value: TImageList);
var
  I: Integer;
begin
  FDisabledLargeImages := Value;
  if self.Count > 0 then
    for I := 0 to self.count - 1 do
      Items[I].DisabledLargeImages := Value;
end;

procedure TSpkPanes.Update;
begin
  inherited Update;

  if assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyItemsChanged;
end;

initialization
  RegisterFMXClasses([TSpkPane]);

finalization
//  UnregisterClass(TSpkPane);

end.

