unit spkt_Checkboxes;

{.$mode objfpc}{$H+}
{$DEFINE EnhancedRecordSupport}
interface

uses
  FMX.Graphics, FMX.Types, Classes, SysUtils, FMX.Controls, FMX.StdCtrls, FMX.ActnList,
  SpkMath, SpkGUITools, spkt_BaseItem, spkt_Buttons;

type
  TSpkCustomCheckBox = class(TSPkBaseButton)
  private
    FState: TCheckboxState;              // unchecked, checked, grayed
    FHideFrameWhenIdle : boolean;
    FTableBehaviour : TSpkItemTableBehaviour;
    FGroupBehaviour : TSPkItemGroupBehaviour;
    FCheckboxStyle: TSpkCheckboxStyle;
    procedure SetTableBehaviour(const Value: TSpkItemTableBehaviour);
  protected
    procedure CalcRects; override;
    procedure ConstructRect(out BtnRect: T2DIntRect);
    function  GetChecked: Boolean; override;
    function GetDefaultCaption: String; override;
    function GetDropdownPoint: T2DIntPoint; override;
    procedure SetChecked(const AValue: Boolean); override;
    procedure SetState(AValue: TCheckboxState); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect); override;
    function GetGroupBehaviour : TSpkItemGroupBehaviour; override;
    function GetSize: TSpkItemSize; override;
    function GetTableBehaviour : TSpkItemTableBehaviour; override;
    function GetWidth: integer; override;
  published
    property Checked;
    property State: TCheckboxState read FState write SetState default cbUnchecked;
    property TableBehaviour: TSpkItemTableBehaviour read FTableBehaviour write SetTableBehaviour default tbContinuesRow;
  end;

  TSpkCheckbox = class(TSpkCustomCheckbox)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TSpkRadioButton = class(TSpkCustomCheckbox)
  protected
    function GetDefaultCaption: String; override;
    procedure SetState(AValue: TCheckboxState); override;
    procedure UncheckSiblings; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AllowAllUp;
    property GroupIndex;
  end;


implementation

uses
  System.Math,
  SpkGraphTools, spkt_Const, spkt_Tools, spkt_Pane, spkt_Appearance;


{ TSpkCustomCheckbox }

constructor TSpkCustomCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ButtonKind := bkToggle;
  FHideFrameWhenIdle := true;
  FTableBehaviour := tbContinuesRow;
  FGroupBehaviour := gbSingleItem;
  FCheckboxStyle := cbsCheckbox;
  FState := cbUnchecked;
end;

procedure TSpkCustomCheckbox.CalcRects;
var
  RectVector: T2DIntVector;
begin
  ConstructRect(FButtonRect);
 {$IFDEF EnhancedRecordSupport}
  FDropdownRect := T2DIntRect.Create(0, 0, 0, 0);
  RectVector := T2DIntVector.Create(FRect.Left, FRect.Top);
 {$ELSE}
  FDropdownRect.Create(0, 0, 0, 0);
  RectVector.Create(FRect.Left, FRect.Top);
 {$ENDIF}
  FButtonRect := FButtonRect + RectVector;
end;

procedure TSpkCustomCheckbox.ConstructRect(out BtnRect: T2DIntRect);
var
  BtnWidth: integer;
  Bitmap: TBitmap;
  TextWidth: Integer;
begin
 {$IFDEF EnhancedRecordSupport}
  BtnRect := T2DIntRect.Create(0, 0, 0, 0);
 {$ELSE}
  BtnRect.Create(0, 0, 0, 0);
 {$ENDIF}

  if not(Assigned(FToolbarDispatch)) then
    exit;
  if not(Assigned(FAppearance)) then
    exit;

  Bitmap := FToolbarDispatch.GetTempBitmap;
  if not Assigned(Bitmap) then
    exit;

  Bitmap.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
  TextWidth := Round(Bitmap.Canvas.TextWidth(FCaption));

  BtnWidth := SMALLBUTTON_PADDING + SMALLBUTTON_GLYPH_WIDTH +
    SmallButton_Padding + TextWidth + SmallButton_Padding;
  BtnWidth := Max(SMALLBUTTON_MIN_WIDTH, BtnWidth);

  if FGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
    BtnWidth := BtnWidth + SMALLBUTTON_HALF_BORDER_WIDTH
  else
    BtnWidth := BtnWidth + SMALLBUTTON_BORDER_WIDTH;

  // Prawa krawêdŸ przycisku
  if (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) then
    BtnWidth := BtnWidth + SMALLBUTTON_HALF_BORDER_WIDTH
  else
    BtnWidth := BtnWidth + SMALLBUTTON_BORDER_WIDTH;

 {$IFDEF EnhancedRecordSupport}
  BtnRect := T2DIntRect.Create(0, 0, BtnWidth - 1, PANE_ROW_HEIGHT - 1);
 {$ELSE}
  BtnRect.Create(0, 0, BtnWidth - 1, PaneRowHeight - 1);
 {$ENDIF}
end;

procedure TSpkCustomCheckbox.Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
var
  fontColor: TColor;
  x, y: Integer;
  h: Integer;
//  te: TThemedElementDetails;
  cornerRadius: Integer;
begin
  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;
  if (FRect.Width < 2* LARGEBUTTON_RADIUS) or (FRect.Height < 2* LargeButton_Radius) then
    exit;

  case FAppearance.Element.Style of
    esRounded:
      cornerRadius := SmallButton_Radius;
    esRectangle:
      cornerRadius := 0;
  end;

  // Border
  if (FButtonState = bsIdle) and (not(FHideFrameWhenIdle)) then
  begin
    with FAppearance.Element do
      TButtonTools.DrawButton(
        ABuffer,
        FButtonRect,
        IdleFrameColor,
        IdleInnerLightColor,
        IdleInnerDarkColor,
        IdleGradientFromColor,
        IdleGradientToColor,
        IdleGradientType,
        (FGroupBehaviour in [gbContinuesGroup, gbEndsGroup]),
        (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) or (FButtonKind = bkButtonDropdown),
        false,
        false,
        cornerRadius,
        ClipRect
      );
  end else
  if (FButtonState=bsBtnHottrack) then
  begin
    with FAppearance.Element do
      TButtonTools.DrawButton(
        ABuffer,
        FButtonRect,
        HotTrackFrameColor,
        HotTrackInnerLightColor,
        HotTrackInnerDarkColor,
        HotTrackGradientFromColor,
        HotTrackGradientToColor,
        HotTrackGradientType,
        (FGroupBehaviour in [gbContinuesGroup, gbEndsGroup]),
        (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) or (FButtonKind = bkButtonDropdown),
        false,
        false,
        cornerRadius,
        ClipRect
      );
  end else
  if (FButtonState = bsBtnPressed) then
  begin
    with FAppearance.Element do
      TButtonTools.DrawButton(
        ABuffer,
        FButtonRect,
        ActiveFrameColor,
        ActiveInnerLightColor,
        ActiveInnerDarkColor,
        ActiveGradientFromColor,
        ActiveGradientToColor,
        ActiveGradientType,
        (FGroupBehaviour in [gbContinuesGroup, gbEndsGroup]),
        (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) or (FButtonKind = bkButtonDropdown),
        false,
        false,
        cornerRadius,
        ClipRect
      );
  end;

  // Checkbox
//  if ThemeServices.ThemesEnabled then
//  begin
//    te := ThemeServices.GetElementDetails(tbCheckboxCheckedNormal);
//    h := ThemeServices.GetDetailSize(te).cy;
//  end else
//    h := GetSystemMetrics(SM_CYMENUCHECK);
  h:=20;


  if (FGroupBehaviour in [gbContinuesGroup, gbEndsGroup]) then
    x := FButtonRect.Left + SMALLBUTTON_HALF_BORDER_WIDTH + SMALLBUTTON_PADDING
  else
    x := FButtonRect.Left + SMALLBUTTON_BORDER_WIDTH + SmallButton_Padding;
  y := FButtonRect.Top + (FButtonRect.Height - h) div 2;

  TGUITools.DrawCheckbox(
    ABuffer.Canvas,
    TFmxObject(Self.Owner),
    x,y,
    FState,
    FButtonState,
    FCheckboxStyle,
    ClipRect
  );

  // Text
  ABuffer.Canvas.Font.Assign(FAppearance.Element.CaptionFont);

  case FButtonState of
    bsIdle             : fontColor := FAppearance.Element.IdleCaptionColor;
    bsBtnHottrack,
    bsDropdownHottrack : fontColor := FAppearance.Element.HotTrackCaptionColor;
    bsBtnPressed,
    bsDropdownPressed  : fontColor := FAppearance.ELement.ActiveCaptionColor;
  end;
  if not(FEnabled) then
    fontColor := TColorTools.ColorToGrayscale(fontColor);

  if (FGroupBehaviour in [gbContinuesGroup, gbEndsGroup]) then
    x := FButtonRect.Left + SMALLBUTTON_HALF_BORDER_WIDTH
  else
    x := FButtonRect.Left + SMALLBUTTON_BORDER_WIDTH;
  x := x + 2 * SmallButton_Padding + SMALLBUTTON_GLYPH_WIDTH;
  y := FButtonRect.Top + (FButtonRect.Height - Round(ABuffer.Canvas.TextHeight('Wy'))) div 2;

  TGUITools.DrawText(ABuffer.Canvas, x, y, FCaption, fontColor, ClipRect);
end;

function TSpkCustomCheckbox.GetChecked: Boolean;
begin
  Result := (FState = cbChecked);
end;

function TSpkCustomCheckbox.GetDefaultCaption: String;
begin
  Result := 'Checkbox';
end;

function TSpkCustomCheckbox.GetDropdownPoint: T2DIntPoint;
begin
 {$IFDEF EnhancedRecordSupport}
  Result := T2DIntPoint.Create(0,0);
 {$ELSE}
  Result.Create(0,0);
 {$ENDIF}
end;

function TSpkCustomCheckbox.GetGroupBehaviour: TSpkItemGroupBehaviour;
begin
  Result := gbSingleitem; //FGroupBehaviour;
end;

function TSpkCustomCheckbox.GetSize: TSpkItemSize;
begin
  Result := isNormal;
end;

function TSpkCustomCheckbox.GetTableBehaviour: TSpkItemTableBehaviour;
begin
  Result := FTableBehaviour;
end;

function TSpkCustomCheckbox.GetWidth: integer;
var
  BtnRect: T2DIntRect;
begin
  Result := -1;
  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;
  ConstructRect(BtnRect);
  Result := BtnRect.Right + 1;
end;

procedure TSpkCustomCheckbox.SetChecked(const AValue: Boolean);
begin
  inherited SetChecked(AValue);
  if FChecked then
    SetState(cbChecked)
  else
    SetState(cbUnchecked);
end;

procedure TSpkCustomCheckbox.SetState(AValue:TCheckboxState);
begin
  if AValue <> FState then
  begin
    FState := AValue;
    inherited SetChecked(Checked);
    if Assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
  end;
end;

procedure TSpkCustomCheckbox.SetTableBehaviour(const Value: TSpkItemTableBehaviour);
begin
  FTableBehaviour := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;


{ TSpkCheckbox }

constructor TSpkCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='CheckBox';
  FCheckboxStyle := cbsCheckbox;
end;


{ TSpkRadioButton }

constructor TSpkRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='RadioButton';
  FCheckboxStyle := cbsRadioButton;
end;

function TSpkRadioButton.GetDefaultCaption: string;
begin
  Result := 'RadioButton';
end;

procedure TSpkRadioButton.SetState(AValue: TCheckboxState);
begin
  inherited SetState(AValue);
  if (AValue = cbChecked) then
    UncheckSiblings;
end;

procedure TSpkRadioButton.UncheckSiblings;
var
  i: Integer;
  pane: TSpkPane;
  rb: TSpkRadioButton;
begin
  if (Parent is TSpkPane) then begin
    pane := TSpkPane(Parent);
    for i := 0 to pane.Items.Count-1 do
      if (pane.Items[i] is TSpkRadioButton) then
      begin
        rb := TSpkRadioButton(pane.Items[i]);
        if (rb <> self) and (rb.GroupIndex = GroupIndex) then begin
          rb.FChecked := false;
          rb.FState := cbUnchecked;
        end;
      end;
  end;
end;

initialization
  RegisterFMXClasses([TSpkRadioButton, TSpkCheckbox]);

end.

