unit spkt_Appearance;

interface

uses
  FMX.Graphics, Classes, FMX.Forms, SysUtils, System.UITypes, SpkGUITools,
  SpkXMLParser, SpkXMLTools, spkt_Dispatch, spkt_Exceptions;

type
  TSpkPaneStyle = (psRectangleFlat, psRectangleEtched, psRectangleRaised, psDividerFlat, psDividerEtched, psDividerRaised);

  TSpkElementStyle = (esRounded, esRectangle);

  TSpkStyle = (spkOffice2007Blue, spkOffice2007Silver, spkOffice2007SilverTurquoise, spkMetroLight, spkMetroDark);

  TSpkTabAppearance = class(TPersistent)
  private
    FDispatch: TSpkBaseAppearanceDispatch;
    FTabHeaderFontColor: TAlphaColor;
    FInactiveHeaderFontColor: TAlphaColor;
    FTabHeaderFont: TFont;
    FTabHeaderColor: TAlphaColor;
    FBorderColor: TAlphaColor;
    FGradientFromColor: TAlphaColor;
    FGradientToColor: TAlphaColor;
    FGradientType: TBackgroundKind;
    procedure SetHeaderFontColor(const Value: TAlphaColor);
  protected
    procedure SetHeaderColor(const Value: TAlphaColor);
    procedure SetHeaderFont(const Value: TFont);
    procedure SetBorderColor(const Value: TAlphaColor);
    procedure SetGradientFromColor(const Value: TAlphaColor);
    procedure SetGradientToColor(const Value: TAlphaColor);
    procedure SetGradientType(const Value: TBackgroundKind);
    procedure SetInactiveHeaderFontColor(const Value: TAlphaColor);
    procedure TabHeaderFontChange(Sender: TObject);
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(ADispatch: TSpkBaseAppearanceDispatch);
    procedure SaveToXML(Node: TSpkXMLNode);
    procedure LoadFromXML(Node: TSpkXMLNode);
    destructor Destroy; override;
    procedure SaveToPascal(AList: TStrings);
    procedure Reset(AStyle: TSpkStyle = spkOffice2007Blue);
  published
    property TabHeaderFont: TFont read FTabHeaderFont write SetHeaderFont;
    property TabHeaderFontColor: TAlphaColor read FTabHeaderFontColor write SetHeaderFontColor;
    property TabHeaderColor: TAlphaColor read FTabHeaderColor write SetHeaderColor;
    property BorderColor: TAlphaColor read FBorderColor write SetBorderColor;
    property GradientFromColor: TAlphaColor read FGradientFromColor write SetGradientFromColor;
    property GradientToColor: TAlphaColor read FGradientToColor write SetGradientToColor;
    property GradientType: TBackgroundKind read FGradientType write SetGradientType;
    property InactiveTabHeaderFontColor: TAlphaColor read FInactiveHeaderFontColor write SetInactiveHeaderFontColor;
  end;

type
  TSpkPaneAppearance = class(TPersistent)
  private
    FDispatch: TSpkBaseAppearanceDispatch;
    FCaptionFontColor: TAlphaColor;
    FCaptionFont: TFont;
    FBorderDarkColor: TAlphaColor;
    FBorderLightColor: TAlphaColor;
    FCaptionBgColor: TAlphaColor;
    FGradientFromColor: TAlphaColor;
    FGradientToColor: TAlphaColor;
    FGradientType: TBackgroundKind;
    FHotTrackBrightnessChange: Integer;
    FStyle: TSpkPaneStyle;
  protected
    procedure SetCaptionFontColor(const Value: TAlphaColor);
    procedure SetCaptionBgColor(const Value: TAlphaColor);
    procedure SetCaptionFont(const Value: TFont);
    procedure SetBorderDarkColor(const Value: TAlphaColor);
    procedure SetBorderLightColor(const Value: TAlphaColor);
    procedure SetGradientFromColor(const Value: TAlphaColor);
    procedure SetGradientToColor(const Value: TAlphaColor);
    procedure SetGradientType(const Value: TBackgroundKind);
    procedure SetHotTrackBrightnessChange(const Value: Integer);
    procedure SetStyle(const Value: TSpkPaneStyle);
    procedure CaptionFontChange(Sender: TObject);
  public
    constructor Create(ADispatch: TSpkBaseAppearanceDispatch);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromXML(Node: TSpkXMLNode);
    procedure SaveToPascal(AList: TStrings);
    procedure SaveToXML(Node: TSpkXMLNode);
    procedure Reset(AStyle: TSpkStyle = spkOffice2007Blue);
  published
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property CaptionFontColor: TAlphaColor read FCaptionFontColor write SetCaptionFontColor;
    property BorderDarkColor: TAlphaColor read FBorderDarkColor write SetBorderDarkColor;
    property BorderLightColor: TAlphaColor read FBorderLightColor write SetBorderLightColor;
    property GradientFromColor: TAlphaColor read FGradientFromColor write SetGradientFromColor;
    property GradientToColor: TAlphaColor read FGradientToColor write SetGradientToColor;
    property GradientType: TBackgroundKind read FGradientType write SetGradientType;
    property CaptionBgColor: TAlphaColor read FCaptionBgColor write SetCaptionBgColor;
    property HotTrackBrightnessChange: Integer read FHotTrackBrightnessChange write SetHotTrackBrightnessChange default 20;
    property Style: TSpkPaneStyle read FStyle write SetStyle default psRectangleEtched;
  end;

type
  TSpkElementAppearance = class(TPersistent)
  private
    FDispatch: TSpkBaseAppearanceDispatch;
    procedure GetActiveColors(IsChecked: Boolean; out AFrameColor, AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor: TAlphaColor; out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
    procedure GetHotTrackColors(IsChecked: Boolean; out AFrameColor, AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor: TAlphaColor; out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
    procedure GetIdleColors(IsChecked: Boolean; out AFrameColor, AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor: TAlphaColor; out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
    procedure SetHotTrackBrightnessChange(const Value: Integer);
    procedure SetStyle(const Value: TSpkElementStyle);
  protected
    FCaptionFont: TFont;
    FCaptionFontColor: TAlphaColor;
    FIdleFrameColor: TAlphaColor;
    FIdleGradientFromColor: TAlphaColor;
    FIdleGradientToColor: TAlphaColor;
    FIdleGradientType: TBackgroundKind;
    FIdleInnerLightColor: TAlphaColor;
    FIdleInnerDarkColor: TAlphaColor;
    FIdleCaptionColor: TAlphaColor;
    FHotTrackFrameColor: TAlphaColor;
    FHotTrackGradientFromColor: TAlphaColor;
    FHotTrackGradientToColor: TAlphaColor;
    FHotTrackGradientType: TBackgroundKind;
    FHotTrackInnerLightColor: TAlphaColor;
    FHotTrackInnerDarkColor: TAlphaColor;
    FHotTrackCaptionColor: TAlphaColor;
    FActiveFrameColor: TAlphaColor;
    FActiveGradientFromColor: TAlphaColor;
    FActiveGradientToColor: TAlphaColor;
    FActiveGradientType: TBackgroundKind;
    FActiveInnerLightColor: TAlphaColor;
    FActiveInnerDarkColor: TAlphaColor;
    FActiveCaptionColor: TAlphaColor;
    FHotTrackBrightnessChange: Integer;
    FStyle: TSpkElementStyle;
    procedure SetActiveCaptionColor(const Value: TAlphaColor);
    procedure SetActiveFrameColor(const Value: TAlphaColor);
    procedure SetActiveGradientFromColor(const Value: TAlphaColor);
    procedure SetActiveGradientToColor(const Value: TAlphaColor);
    procedure SetActiveGradientType(const Value: TBackgroundKind);
    procedure SetActiveInnerDarkColor(const Value: TAlphaColor);
    procedure SetActiveInnerLightColor(const Value: TAlphaColor);
    procedure SetCaptionFont(const Value: TFont);
    procedure SetHotTrackCaptionColor(const Value: TAlphaColor);
    procedure SetHotTrackFrameColor(const Value: TAlphaColor);
    procedure SetHotTrackGradientFromColor(const Value: TAlphaColor);
    procedure SetHotTrackGradientToColor(const Value: TAlphaColor);
    procedure SetHotTrackGradientType(const Value: TBackgroundKind);
    procedure SetHotTrackInnerDarkColor(const Value: TAlphaColor);
    procedure SetHotTrackInnerLightColor(const Value: TAlphaColor);
    procedure SetIdleCaptionColor(const Value: TAlphaColor);
    procedure SetIdleFrameColor(const Value: TAlphaColor);
    procedure SetIdleGradientFromColor(const Value: TAlphaColor);
    procedure SetIdleGradientToColor(const Value: TAlphaColor);
    procedure SetIdleGradientType(const Value: TBackgroundKind);
    procedure SetIdleInnerDarkColor(const Value: TAlphaColor);
    procedure SetIdleInnerLightColor(const Value: TAlphaColor);
    procedure SetCaptionFontColor(const Value: TAlphaColor);
    procedure FontChanged(Sender: TObject);
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(ADispatch: TSpkBaseAppearanceDispatch);
    procedure SaveToXML(Node: TSpkXMLNode);
    procedure LoadFromXML(Node: TSpkXMLNode);
    destructor Destroy; override;
    procedure SaveToPascal(AList: TStrings);
    procedure Reset(AStyle: TSpkStyle = spkOffice2007Blue);
    procedure CaptionFontChange(Sender: TObject);
  published
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property CaptionFontColor: TAlphaColor read FCaptionFontColor write SetCaptionFontColor;
    property IdleFrameColor: TAlphaColor read FIdleFrameColor write SetIdleFrameColor;
    property IdleGradientFromColor: TAlphaColor read FIdleGradientFromColor write SetIdleGradientFromColor;
    property IdleGradientToColor: TAlphaColor read FIdleGradientToColor write SetIdleGradientToColor;
    property IdleGradientType: TBackgroundKind read FIdleGradientType write SetIdleGradientType;
    property IdleInnerLightColor: TAlphaColor read FIdleInnerLightColor write SetIdleInnerLightColor;
    property IdleInnerDarkColor: TAlphaColor read FIdleInnerDarkColor write SetIdleInnerDarkColor;
    property IdleCaptionColor: TAlphaColor read FIdleCaptionColor write SetIdleCaptionColor;
    property HotTrackFrameColor: TAlphaColor read FHotTrackFrameColor write SetHotTrackFrameColor;
    property HotTrackGradientFromColor: TAlphaColor read FHotTrackGradientFromColor write SetHotTrackGradientFromColor;
    property HotTrackGradientToColor: TAlphaColor read FHotTrackGradientToColor write SetHotTrackGradientToColor;
    property HotTrackGradientType: TBackgroundKind read FHotTrackGradientType write SetHotTrackGradientType;
    property HotTrackInnerLightColor: TAlphaColor read FHotTrackInnerLightColor write SetHotTrackInnerLightColor;
    property HotTrackInnerDarkColor: TAlphaColor read FHotTrackInnerDarkColor write SetHotTrackInnerDarkColor;
    property HotTrackCaptionColor: TAlphaColor read FHotTrackCaptionColor write SetHotTrackCaptionColor;
    property ActiveFrameColor: TAlphaColor read FActiveFrameColor write SetActiveFrameColor;
    property ActiveGradientFromColor: TAlphaColor read FActiveGradientFromColor write SetActiveGradientFromColor;
    property ActiveGradientToColor: TAlphaColor read FActiveGradientToColor write SetActiveGradientToColor;
    property ActiveGradientType: TBackgroundKind read FActiveGradientType write SetActiveGradientType;
    property ActiveInnerLightColor: TAlphaColor read FActiveInnerLightColor write SetActiveInnerLightColor;
    property ActiveInnerDarkColor: TAlphaColor read FActiveInnerDarkColor write SetActiveInnerDarkColor;
    property ActiveCaptionColor: TAlphaColor read FActiveCaptionColor write SetActiveCaptionColor;
    property HotTrackBrightnessChange: Integer read FHotTrackBrightnessChange write SetHotTrackBrightnessChange default 20;
    property Style: TSpkElementStyle read FStyle write SetStyle;
  end;

type
  TSpkToolbarAppearance = class;

  TSpkToolbarAppearanceDispatch = class(TSpkBaseAppearanceDispatch)
  private
    FToolbarAppearance: TSpkToolbarAppearance;
  protected
  public
    constructor Create(AToolbarAppearance: TSpkToolbarAppearance);
    procedure NotifyAppearanceChanged; override;
  end;

  TSpkToolbarAppearance = class(TPersistent)
  private
    FAppearanceDispatch: TSpkToolbarAppearanceDispatch;
  protected
    FTab: TSpkTabAppearance;
    FPane: TSpkPaneAppearance;
    FElement: TSpkElementAppearance;
    FDispatch: TSpkBaseAppearanceDispatch;
    procedure SetElementAppearance(const Value: TSpkElementAppearance);
    procedure SetPaneAppearance(const Value: TSpkPaneAppearance);
    procedure SetTabAppearance(const Value: TSpkTabAppearance);
  public
    constructor Create(ADispatch: TSpkBaseAppearanceDispatch); reintroduce;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure NotifyAppearanceChanged;
    procedure Reset(AStyle: TSpkStyle = spkOffice2007Blue);
    procedure SaveToPascal(AList: TStrings);
    procedure SaveToXML(Node: TSpkXMLNode);
    procedure LoadFromXML(Node: TSpkXMLNode);
  published
    property Tab: TSpkTabAppearance read FTab write SetTabAppearance;
    property Pane: TSpkPaneAppearance read FPane write SetPaneAppearance;
    property Element: TSpkElementAppearance read FElement write SetElementAppearance;
  end;

implementation

uses
  SpkGraphTools, FMX.platform;

procedure SaveFontToPascal(AList: TStrings; AFont: TFont; AName: string);
var
  sty: string;
begin
  sty := '';
  if TFontStyle.fsBold in AFont.Style then
    sty := sty + 'fsBold,';
  if TFontStyle.fsItalic in AFont.Style then
    sty := sty + 'fsItalic,';
  if TFontStyle.fsUnderline in AFont.Style then
    sty := sty + 'fsUnderline,';
  if TFontStyle.fsStrikeout in AFont.Style then
    sty := sty + 'fsStrikeout,';
  if sty <> '' then
    Delete(sty, Length(sty), 1);
  with AList do
  begin
    Add(AName + '.Name := ''' + AFont.Family + ''';');
    Add(AName + '.Size := ' + FloatToStr(AFont.Size) + ';');
    Add(AName + '.Style := [' + sty + '];');
//    Add(AName + '.Color := $' + IntToHex(AFont.Color, 8) + ';');
  end;
end;

constructor TSpkTabAppearance.Create(ADispatch: TSpkBaseAppearanceDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
  FTabHeaderFont := TFont.Create;
  FTabHeaderFont.OnChanged := TabHeaderFontChange;
  Reset;
end;

destructor TSpkTabAppearance.Destroy;
begin
  FTabHeaderFont.Free;
  inherited;
end;

procedure TSpkTabAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TSpkTabAppearance;
begin
  if Source is TSpkTabAppearance then
  begin
    SrcAppearance := TSpkTabAppearance(Source);

    FTabHeaderFont.assign(SrcAppearance.TabHeaderFont);
    FTabHeaderFontColor := SrcAppearance.TabHeaderFontColor;
    FBorderColor := SrcAppearance.BorderColor;
    FGradientFromColor := SrcAppearance.GradientFromColor;
    FGradientToColor := SrcAppearance.GradientToColor;
    FGradientType := SrcAppearance.GradientType;
    FInactiveHeaderFontColor := SrcAppearance.InactiveTabHeaderFontColor;

    if FDispatch <> nil then
      FDispatch.NotifyAppearanceChanged;
  end
  else
    raise AssignException.create('TSpkToolbarAppearance.Assign: Nie moge przypisa? obiektu ' + Source.ClassName + ' do TSpkToolbarAppearance!');
end;

procedure TSpkTabAppearance.LoadFromXML(Node: TSpkXMLNode);
var
  Subnode: TSpkXMLNode;
begin
  if not (assigned(Node)) then
    exit;

  Subnode := Node['TabHeaderFont', false];
  if assigned(Subnode) then
    TSpkXMLTools.Load(Subnode, FTabHeaderFont);

  Subnode := Node['BorderColor', false];
  if assigned(Subnode) then
    FBorderColor := Subnode.TextAsColor;

  Subnode := Node['GradientFromColor', false];
  if assigned(Subnode) then
    FGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['GradientToColor', false];
  if assigned(Subnode) then
    FGradientToColor := Subnode.TextAsColor;

  Subnode := Node['GradientType', false];
  if assigned(Subnode) then
    FGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['InactiveTabHeaderFontColor', false];
  if Assigned(Subnode) then
    FInactiveHeaderFontColor := Subnode.TextAsColor;
end;

procedure TSpkTabAppearance.Reset(AStyle: TSpkStyle);
var
  FFontSvc: IFMXSystemFontService;
begin

  if FFontSvc = nil then
    TPlatformServices.Current.SupportsPlatformService(IFMXSystemFontService, FFontSvc);
  if FFontSvc <> nil then
    FTabHeaderFont.Family := FFontSvc.GetDefaultFontFamilyName
  else
    FTabHeaderFont.Family := 'Arial';

  if FFontSvc <> nil then
    FTabHeaderFont.Size := FFontSvc.GetDefaultFontSize
  else
    FTabHeaderFont.Size := 10;

  case AStyle of
    spkOffice2007Blue:
      begin
        FTabHeaderFont.Style := [];
        FTabHeaderFontColor := rgb(21, 66, 139);
        FBorderColor := rgb(141, 178, 227);
        FGradientFromColor := rgb(222, 232, 245);
        FGradientToColor := rgb(199, 216, 237);
        FGradientType := bkConcave;
        FInactiveHeaderFontColor := FTabHeaderFontColor;
      end;

    spkOffice2007Silver, spkOffice2007SilverTurquoise:
      begin
        FTabHeaderFont.Style := [];
        FTabHeaderFontColor := $ff7A534C;
        FBorderColor := $ffBEBEBE;
        FGradientFromColor := $ffF4F2F2;
        FGradientToColor := $ffEFE6E1;
        FGradientType := bkConcave;
        FInactiveHeaderFontColor := $ff7A534C;
      end;

    spkMetroLight:
      begin
        FTabHeaderFont.Style := [];
        FTabHeaderFontColor := $ff95572A;
        FBorderColor := $ffD2D0CF;
        FGradientFromColor := $ffF1F1F1;
        FGradientToColor := $ffF1F1F1;
        FGradientType := bkSolid;
        FInactiveHeaderFontColor := $ff696969;
      end;

    spkMetroDark:
      begin
        FTabHeaderFont.Style := [];
        FTabHeaderFontColor := $ffFFFFFF;
        FBorderColor := $ff000000;
        FGradientFromColor := $ff464646;
        FGradientToColor := $ff464646;
        FGradientType := bkSolid;
        FInactiveHeaderFontColor := $ff787878;
      end;
  end;
end;

procedure TSpkTabAppearance.SaveToPascal(AList: TStrings);
begin
  with AList do
  begin
    Add('  with Tab do begin');
    SaveFontToPascal(AList, FTabHeaderFont, '    TabHeaderFont');
    Add('    BorderColor := $' + IntToHex(FBorderColor, 8) + ';');
    Add('    GradientFromColor := $' + IntToHex(FGradientFromColor, 8) + ';');
    Add('    GradientToColor := $' + IntToHex(FGradientToColor, 8) + ';');
    //Add('    GradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FGradientType)) + ';');
    Add('    InactiveHeaderFontColor := $' + IntToHex(FInactiveHeaderFontColor, 8) + ';');
    Add('  end;');
  end;
end;

procedure TSpkTabAppearance.SaveToXML(Node: TSpkXMLNode);
var
  Subnode: TSpkXMLNode;
begin
  if not (assigned(Node)) then
    exit;

  Subnode := Node['TabHeaderFont', true];
  TSpkXMLTools.Save(Subnode, FTabHeaderFont);

  Subnode := Node['BorderColor', true];
  Subnode.TextAsColor := FBorderColor;

  Subnode := Node['GradientFromColor', true];
  Subnode.TextAsColor := FGradientFromColor;

  Subnode := Node['GradientToColor', true];
  Subnode.TextAsColor := FGradientToColor;

  Subnode := Node['GradientType', true];
  Subnode.TextAsInteger := integer(FGradientType);

  Subnode := Node['InactiveTabHeaderFontColor', true];
  Subnode.TextAsColor := FInactiveHeaderFontColor;
end;

procedure TSpkTabAppearance.SetBorderColor(const Value: TAlphaColor);
begin
  FBorderColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetGradientFromColor(const Value: TAlphaColor);
begin
  FGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetGradientToColor(const Value: TAlphaColor);
begin
  FGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetGradientType(const Value: TBackgroundKind);
begin
  FGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetHeaderColor(const Value: TAlphaColor);
begin
  FTabHeaderColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetHeaderFont(const Value: TFont);
begin
  FTabHeaderFont.assign(Value);
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetInactiveHeaderFontColor(const Value: TAlphaColor);
begin
  FInactiveHeaderFontColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.TabHeaderFontChange(Sender: TObject);
begin
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetHeaderFontColor(const Value: TAlphaColor);
begin
  FTabHeaderFontColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

constructor TSpkPaneAppearance.Create(ADispatch: TSpkBaseAppearanceDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
  FCaptionFont := TFont.Create;
  FCaptionFont.OnChanged := CaptionFontChange;
  FHotTrackBrightnessChange := 20;
  FStyle := psRectangleEtched;
  Reset;
end;

destructor TSpkPaneAppearance.Destroy;
begin
  FCaptionFont.Free;
  inherited Destroy;
end;

procedure TSpkPaneAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TSpkPaneAppearance;
begin
  if Source is TSpkPaneAppearance then
  begin
    SrcAppearance := TSpkPaneAppearance(Source);

    FCaptionFont.assign(SrcAppearance.CaptionFont);
    FCaptionFontColor := (SrcAppearance.CaptionFontColor);
    FBorderDarkColor := SrcAppearance.BorderDarkColor;
    FBorderLightColor := SrcAppearance.BorderLightColor;
    FCaptionBgColor := SrcAppearance.CaptionBgColor;
    FGradientFromColor := SrcAppearance.GradientFromColor;
    FGradientToColor := SrcAppearance.GradientToColor;
    FGradientType := SrcAppearance.GradientType;
    FHotTrackBrightnessChange := SrcAppearance.HotTrackBrightnessChange;
    FStyle := SrcAppearance.Style;

    if FDispatch <> nil then
      FDispatch.NotifyAppearanceChanged;
  end
  else
    raise AssignException.create('TSpkPaneAppearance.Assign: Nie moge przypisa? obiektu ' + Source.ClassName + ' do TSpkPaneAppearance!');
end;

procedure TSpkPaneAppearance.CaptionFontChange(Sender: TObject);
begin
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.LoadFromXML(Node: TSpkXMLNode);
var
  Subnode: TSpkXMLNode;
begin
  if not (assigned(Node)) then
    exit;

  Subnode := Node['CaptionFont', false];
  if assigned(Subnode) then
    TSpkXMLTools.Load(Subnode, FCaptionFont);

  Subnode := Node['BorderDarkColor', false];
  if assigned(Subnode) then
    FBorderDarkColor := Subnode.TextAsColor;

  Subnode := Node['BorderLightColor', false];
  if assigned(Subnode) then
    FBorderLightColor := Subnode.TextAsColor;

  Subnode := Node['CaptionBgColor', false];
  if assigned(Subnode) then
    FCaptionBgColor := Subnode.TextAsColor;

  Subnode := Node['GradientFromColor', false];
  if assigned(Subnode) then
    FGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['GradientToColor', false];
  if assigned(Subnode) then
    FGradientToColor := Subnode.TextAsColor;

  Subnode := Node['GradientType', false];
  if assigned(Subnode) then
    FGradientType := TBackgroundKind(Subnode.TextAsInteger);
  Subnode := Node['HotTrackBrightnessChange', false];
  if Assigned(Subnode) then
    FHotTrackBrightnessChange := Subnode.TextAsInteger;

  Subnode := Node['Style', false];
  if Assigned(Subnode) then
    FStyle := TSpkPaneStyle(Subnode.TextAsInteger);
end;

procedure TSpkPaneAppearance.Reset(AStyle: TSpkStyle = spkOffice2007Blue);
var
  FFontSvc: IFMXSystemFontService;
begin
  if FFontSvc = nil then
    TPlatformServices.Current.SupportsPlatformService(IFMXSystemFontService, FFontSvc);
  if FFontSvc <> nil then
    FCaptionFont.Family := FFontSvc.GetDefaultFontFamilyName
  else
    FCaptionFont.Family := 'Arial';

  if FFontSvc <> nil then
    FCaptionFont.Size := FFontSvc.GetDefaultFontSize
  else
    FCaptionFont.Size := 10;

  case AStyle of
    spkOffice2007Blue:
      begin
        FCaptionFont.Style := [];
        FCaptionFontcolor := rgb(62, 106, 170);
        FBorderDarkColor := rgb(158, 190, 218);
        FBorderLightColor := rgb(237, 242, 248);
        FCaptionBgColor := rgb(194, 217, 241);
        FGradientFromColor := rgb(222, 232, 245);
        FGradientToColor := rgb(199, 216, 237);
        FHotTrackBrightnessChange := 20;
        FStyle := psRectangleEtched;
      end;

    spkOffice2007Silver, spkOffice2007SilverTurquoise:
      begin
        FCaptionFont.Style := [];
        FCaptionFontColor := $ff363636;
        FBorderDarkColor := $ffA6A6A6;
        FBorderLightColor := $ffFFFFFF;
        FCaptionBgColor := $ffE4E4E4;
        FGradientFromColor := $ffF8F8F8;
        FGradientToColor := $ffE9E9E9;
        FGradientType := bkConcave;
        FHotTrackBrightnessChange := 20;
        FStyle := psRectangleEtched;
      end;

    spkMetroLight:
      begin
        FCaptionFont.Style := [];
        FCaptionFontColor := $ff696969;
        FBorderDarkColor := $ffD2D0CF;
        FBorderLightColor := $ffF8F2ED;
        FCaptionBgColor := $ffF1F1F1;
        FGradientFromColor := $ffF1F1F1;
        FGradientToColor := $ffF1F1F1;
        FGradientType := bkSolid;
        FHotTrackBrightnessChange := 0;
        FStyle := psDividerFlat;
      end;

    spkMetroDark:
      begin
        FCaptionFont.Style := [];
        FCaptionFontColor := $ffFFFFFF;
        FBorderDarkColor := $ff8C8482;
        FBorderLightColor := $ffA29D9B;
        FCaptionBgColor := $ff464646;
        FGradientFromColor := $ff464646;
        FGradientToColor := $ffF1F1F1;
        FGradientType := bkSolid;
        FHotTrackBrightnessChange := 0;
        FStyle := psDividerFlat;
      end;
  end;
end;

procedure TSpkPaneAppearance.SaveToPascal(AList: TStrings);
begin
  with AList do
  begin
    Add('  with Pane do begin');
    SaveFontToPascal(AList, FCaptionFont, '    CaptionFont');
    Add('    BorderDarkColor := $' + IntToHex(FBorderDarkColor, 8) + ';');
    Add('    BorderLightColor := $' + IntToHex(FBorderLightColor, 8) + ';');
    Add('    CaptionBgColor := $' + IntToHex(FcaptionBgColor, 8) + ';');
    Add('    GradientFromColor := $' + IntToHex(FGradientFromColor, 8) + ';');
    Add('    GradientToColor := $' + IntToHex(FGradientToColor, 8) + ';');
    //Add('    GradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FGradientType)) + ';');
    Add('    HotTrackBrightnessChange = ' + IntToStr(FHotTrackBrightnessChange) + ';');
    //Add('    Style := ' + GetEnumName(TypeInfo(TSpkPaneStyle), ord(FStyle)) + ';');
    Add('  end;');
  end;

end;

procedure TSpkPaneAppearance.SaveToXML(Node: TSpkXMLNode);
var
  Subnode: TSpkXMLNode;
begin
  if not (assigned(Node)) then
    exit;

  Subnode := Node['CaptionFont', true];
  TSpkXMLTools.Save(Subnode, FCaptionFont);

  Subnode := Node['BorderDarkColor', true];
  Subnode.TextAsColor := FBorderDarkColor;

  Subnode := Node['BorderLightColor', true];
  Subnode.TextAsColor := FBorderLightColor;

  Subnode := Node['CaptionBgColor', true];
  Subnode.TextAsColor := FCaptionBgColor;

  Subnode := Node['GradientFromColor', true];
  Subnode.TextAsColor := FGradientFromColor;

  Subnode := Node['GradientToColor', true];
  Subnode.TextAsColor := FGradientToColor;

  Subnode := Node['GradientType', true];
  Subnode.TextAsInteger := integer(FGradientType);

  Subnode := Node['HotTrackBrightnessChange', true];
  Subnode.TextAsInteger := FHotTrackBrightnessChange;

  Subnode := Node['Style', true];
  Subnode.TextAsInteger := integer(FStyle);
end;

procedure TSpkPaneAppearance.SetBorderDarkColor(const Value: TAlphaColor);
begin
  FBorderDarkColor := Value;
  if assigned(FDispatch) then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetBorderLightColor(const Value: TAlphaColor);
begin
  FBorderLightColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetCaptionBgColor(const Value: TAlphaColor);
begin
  FCaptionBgColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetCaptionFont(const Value: TFont);
begin
  FCaptionFont.Assign(Value);
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetGradientFromColor(const Value: TAlphaColor);
begin
  FGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetGradientToColor(const Value: TAlphaColor);
begin
  FGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetGradientType(const Value: TBackgroundKind);
begin
  FGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetCaptionFontColor(const Value: TAlphaColor);
begin
  FCaptionFontColor := Value;
  if assigned(FDispatch) then
    FDispatch.NotifyAppearanceChanged;

end;

procedure TSpkPaneAppearance.SetHotTrackBrightnessChange(const Value: Integer);
begin
  FHotTrackBrightnessChange := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackBrightnessChange(const Value: Integer);
begin
  FHotTrackBrightnessChange := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetStyle(const Value: TSpkPaneStyle);
begin
  FStyle := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.CaptionFontChange(Sender: TObject);
begin
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

constructor TSpkElementAppearance.Create(ADispatch: TSpkBaseAppearanceDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
  FCaptionFont := TFont.Create;
  FCaptionFont.OnChanged := CaptionFontChange;
  FHotTrackBrightnessChange := 40;
  Reset;
  FCaptionFont.OnChanged := FontChanged;

end;

destructor TSpkElementAppearance.Destroy;
begin
  FCaptionFont.Free;
  inherited Destroy;
end;

procedure TSpkElementAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TSpkElementAppearance;
begin
  if Source is TSpkElementAppearance then
  begin
    SrcAppearance := TSpkElementAppearance(Source);

    FCaptionFont.assign(SrcAppearance.CaptionFont);
    FCaptionFontColor := SrcAppearance.CaptionFontColor;
    FIdleFrameColor := SrcAppearance.IdleFrameColor;
    FIdleGradientFromColor := SrcAppearance.IdleGradientFromColor;
    FIdleGradientToColor := SrcAppearance.IdleGradientToColor;
    FIdleGradientType := SrcAppearance.IdleGradientType;
    FIdleInnerLightColor := SrcAppearance.IdleInnerLightColor;
    FIdleInnerDarkColor := SrcAppearance.IdleInnerDarkColor;
    FIdleCaptionColor := SrcAppearance.IdleCaptionColor;
    FHotTrackFrameColor := SrcAppearance.HotTrackFrameColor;
    FHotTrackGradientFromColor := SrcAppearance.HotTrackGradientFromColor;
    FHotTrackGradientToColor := SrcAppearance.HotTrackGradientToColor;
    FHotTrackGradientType := SrcAppearance.HotTrackGradientType;
    FHotTrackInnerLightColor := SrcAppearance.HotTrackInnerLightColor;
    FHotTrackInnerDarkColor := SrcAppearance.HotTrackInnerDarkColor;
    FHotTrackCaptionColor := SrcAppearance.HotTrackCaptionColor;
    FHotTrackBrightnessChange := SrcAppearance.HotTrackBrightnessChange;
    FActiveFrameColor := SrcAppearance.ActiveFrameColor;
    FActiveGradientFromColor := SrcAppearance.ActiveGradientFromColor;
    FActiveGradientToColor := SrcAppearance.ActiveGradientToColor;
    FActiveGradientType := SrcAppearance.ActiveGradientType;
    FActiveInnerLightColor := SrcAppearance.ActiveInnerLightColor;
    FActiveInnerDarkColor := SrcAppearance.ActiveInnerDarkColor;
    FActiveCaptionColor := SrcAppearance.ActiveCaptionColor;
    FStyle := SrcAppearance.Style;

    if FDispatch <> nil then
      FDispatch.NotifyAppearanceChanged;
  end
  else
    raise AssignException.Create('TSpkElementAppearance.Assign: Cannot assign the objecct ' + Source.ClassName + ' to TSpkElementAppearance!');
end;

procedure TSpkElementAppearance.FontChanged(Sender: TObject);
begin

  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.GetActiveColors(IsChecked: Boolean; out AFrameColor, AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor: TAlphaColor; out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
const
  DELTA = -20;
begin
  AFrameColor := FActiveFrameColor;
  AInnerLightColor := FActiveInnerLightColor;
  AInnerDarkColor := FActiveInnerDarkColor;
  AGradientFromColor := FActiveGradientFromColor;
  AGradientToColor := FActiveGradientToColor;
  AGradientKind := FActiveGradientType;

  if IsChecked then
    ABrightenBy := DELTA + ABrightenBy;

  if ABrightenBy <> 0 then
  begin
    AFrameColor := TColorTools.Brighten(AFrameColor, ABrightenBy);
    AInnerLightColor := TColorTools.Brighten(AInnerLightColor, ABrightenBy);
    AInnerDarkColor := TColortools.Brighten(AInnerDarkColor, ABrightenBy);
    AGradientFromColor := TColorTools.Brighten(AGradientFromColor, ABrightenBy);
    AGradientToColor := TColorTools.Brighten(AGradientToColor, ABrightenBy);
  end;
end;

procedure TSpkElementAppearance.GetIdleColors(IsChecked: Boolean; out AFrameColor, AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor: TAlphaColor; out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
const
  DELTA = 10;
begin
  if IsChecked then
  begin
    ABrightenBy := DELTA + ABrightenBy;
    AFrameColor := FActiveFrameColor;
    AInnerLightColor := FActiveInnerLightColor;
    AInnerDarkColor := FActiveInnerDarkColor;
    AGradientFromColor := FActiveGradientFromColor;
    AGradientToColor := FActiveGradientToColor;
    AGradientKind := FActiveGradientType;
  end
  else
  begin
    AFrameColor := FIdleFrameColor;
    AInnerLightColor := FIdleInnerLightColor;
    AInnerDarkColor := FIdleInnerDarkColor;
    AGradientFromColor := FIdleGradientFromColor;
    AGradientToColor := FIdleGradientToColor;
    AGradientKind := FIdleGradientType;
  end;

  if ABrightenBy <> 0 then
  begin
    AFrameColor := TColorTools.Brighten(AFrameColor, ABrightenBy);
    AInnerLightColor := TColorTools.Brighten(AInnerLightColor, ABrightenBy);
    AInnerDarkColor := TColorTools.Brighten(AInnerLightColor, ABrightenBy);
    AGradientFromColor := TColorTools.Brighten(AGradientFromColor, ABrightenBy);
    AGradientToColor := TColorTools.Brighten(AGradientToColor, ABrightenBy);
  end;
end;

procedure TSpkElementAppearance.GetHotTrackColors(IsChecked: Boolean; out AFrameColor, AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor: TAlphaColor; out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
const
  DELTA = 20;
begin
  if IsChecked then
  begin
    ABrightenBy := ABrightenBy + DELTA;
    AFrameColor := FActiveFrameColor;
    AInnerLightColor := FActiveInnerLightColor;
    AInnerDarkColor := FActiveInnerDarkColor;
    AGradientFromColor := FActiveGradientFromColor;
    AGradientToColor := FActiveGradientToColor;
    AGradientKind := FActiveGradientType;
  end
  else
  begin
    AFrameColor := FHotTrackFrameColor;
    AInnerLightColor := FHotTrackInnerLightColor;
    AInnerDarkColor := FHotTrackInnerDarkColor;
    AGradientFromColor := FHotTrackGradientFromColor;
    AGradientToColor := FHotTrackGradientToColor;
    AGradientKind := FHotTrackGradientType;
  end;
  if ABrightenBy <> 0 then
  begin
    AFrameColor := TColorTools.Brighten(AFrameColor, ABrightenBy);
    AInnerLightColor := TColorTools.Brighten(AInnerLightColor, ABrightenBy);
    AInnerDarkColor := TColortools.Brighten(AInnerDarkColor, ABrightenBy);
    AGradientFromColor := TColorTools.Brighten(AGradientFromColor, ABrightenBy);
    AGradientToColor := TColorTools.Brighten(AGradientToColor, ABrightenBy);
  end;
end;

procedure TSpkElementAppearance.LoadFromXML(Node: TSpkXMLNode);
var
  Subnode: TSpkXMLNode;
begin
  if not (assigned(Node)) then
    exit;

  Subnode := Node['CaptionFont', false];
  if assigned(Subnode) then
    TSpkXMLTools.Load(Subnode, FCaptionFont);

  Subnode := Node['IdleFrameColor', false];
  if assigned(Subnode) then
    FIdleFrameColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientFromColor', false];
  if assigned(Subnode) then
    FIdleGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientToColor', false];
  if assigned(Subnode) then
    FIdleGradientToColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientType', false];
  if assigned(Subnode) then
    FIdleGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['IdleInnerLightColor', false];
  if assigned(Subnode) then
    FIdleInnerLightColor := Subnode.TextAsColor;

  Subnode := Node['IdleInnerDarkColor', false];
  if assigned(Subnode) then
    FIdleInnerDarkColor := Subnode.TextAsColor;

  Subnode := Node['IdleCaptionColor', false];
  if assigned(Subnode) then
    FIdleCaptionColor := Subnode.TextAsColor;

  Subnode := Node['HottrackFrameColor', false];
  if assigned(Subnode) then
    FHottrackFrameColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientFromColor', false];
  if assigned(Subnode) then
    FHottrackGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientToColor', false];
  if assigned(Subnode) then
    FHottrackGradientToColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientType', false];
  if assigned(Subnode) then
    FHottrackGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['HottrackInnerLightColor', false];
  if assigned(Subnode) then
    FHottrackInnerLightColor := Subnode.TextAsColor;

  Subnode := Node['HottrackInnerDarkColor', false];
  if assigned(Subnode) then
    FHottrackInnerDarkColor := Subnode.TextAsColor;

  Subnode := Node['HottrackCaptionColor', false];
  if assigned(Subnode) then
    FHottrackCaptionColor := Subnode.TextAsColor;

  Subnode := Node['HottrackBrightnessChange', false];
  if Assigned(Subnode) then
    FHottrackBrightnessChange := Subnode.TextAsInteger;

  Subnode := Node['ActiveFrameColor', false];
  if assigned(Subnode) then
    FActiveFrameColor := Subnode.TextAsColor;

  Subnode := Node['ActiveGradientFromColor', false];
  if assigned(Subnode) then
    FActiveGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['ActiveGradientToColor', false];
  if assigned(Subnode) then
    FActiveGradientToColor := Subnode.TextAsColor;

  Subnode := Node['ActiveGradientType', false];
  if assigned(Subnode) then
    FActiveGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['ActiveInnerLightColor', false];
  if assigned(Subnode) then
    FActiveInnerLightColor := Subnode.TextAsColor;

  Subnode := Node['ActiveInnerDarkColor', false];
  if assigned(Subnode) then
    FActiveInnerDarkColor := Subnode.TextAsColor;

  Subnode := Node['ActiveCaptionColor', false];
  if assigned(Subnode) then
    FActiveCaptionColor := Subnode.TextAsColor;

  Subnode := Node['Style', false];
  if Assigned(Subnode) then
    FStyle := TSpkElementStyle(Subnode.TextAsInteger);
end;

procedure TSpkElementAppearance.Reset(AStyle: TSpkStyle = spkOffice2007Blue);
var
  FFontSvc: IFMXSystemFontService;
begin

  if FFontSvc = nil then
    TPlatformServices.Current.SupportsPlatformService(IFMXSystemFontService, FFontSvc);
  if FFontSvc <> nil then
    FCaptionFont.Family := FFontSvc.GetDefaultFontFamilyName
  else
    FCaptionFont.Family := 'Arial';

  if FFontSvc <> nil then
    FCaptionFont.Size := FFontSvc.GetDefaultFontSize
  else
    FCaptionFont.Size := 10;

  case AStyle of
    spkOffice2007Blue:
      begin
        FCaptionFont.Style := [];
        FCaptionFontColor := rgb(21, 66, 139);
        FIdleFrameColor := rgb(155, 183, 224);
        FIdleGradientFromColor := rgb(200, 219, 238);
        FIdleGradientToColor := rgb(188, 208, 233);
        FIdleGradientType := bkConcave;
        FIdleInnerLightColor := rgb(213, 227, 241);
        FIdleInnerDarkColor := rgb(190, 211, 236);
        FIdleCaptionColor := rgb(86, 125, 177);
        FHotTrackFrameColor := rgb(221, 207, 155);
        FHotTrackGradientFromColor := rgb(255, 252, 218);
        FHotTrackGradientToColor := rgb(255, 215, 77);
        FHotTrackGradientType := bkConcave;
        FHotTrackInnerLightColor := rgb(255, 241, 197);
        FHotTrackInnerDarkColor := rgb(216, 194, 122);
        FHotTrackCaptionColor := rgb(111, 66, 135);
        FHotTrackBrightnessChange := 40;
        FActiveFrameColor := rgb(139, 118, 84);
        FActiveGradientFromColor := rgb(254, 187, 108);
        FActiveGradientToColor := rgb(252, 146, 61);
        FActiveGradientType := bkConcave;
        FActiveInnerLightColor := rgb(252, 169, 14);
        FActiveInnerDarkColor := rgb(252, 169, 14);
        FActiveCaptionColor := rgb(110, 66, 128);
        FStyle := esRounded;
      end;

    spkOffice2007Silver, spkOffice2007SilverTurquoise:
      begin
        FCaptionFont.Style := [];
        FCaptionFontColor := $ff8B4215;
        FIdleFrameColor := $ffB8B1A9;
        FIdleGradientFromColor := $ffF4F4F2;
        FIdleGradientToColor := $ffE6E5E3;
        FIdleGradientType := bkConcave;
        FIdleInnerDarkColor := $ffC7C0BA;
        FIdleInnerLightColor := $ffF6F2F0;
        FIdleCaptionColor := $ff60655F;
        FHotTrackBrightnessChange := 40;
        FHotTrackFrameColor := $ff9BCFDD;
        FHotTrackGradientFromColor := $ffDAFCFF;
        FHotTrackGradientToColor := $ff4DD7FF;
        FHotTrackGradientType := bkConcave;
        FHotTrackInnerDarkColor := $ff7AC2D8;
        FHotTrackInnerLightColor := $ffC5F1FF;
        FHotTrackCaptionColor := $ff87426F;
        if AStyle = spkOffice2007SilverTurquoise then
        begin
          FHotTrackFrameColor := $ff9E7D0E;
          FHotTrackGradientFromColor := $ffFBF1D0;
          FHotTrackGradientToColor := $ffF4DD8A;
          FHotTrackInnerDarkColor := $ffC19A11;
          FHotTrackInnerLightColor := $ffFAEFC9;
        end;
        FActiveFrameColor := $ff54768B;
        FActiveGradientFromColor := $ff6CBBFE;
        FActiveGradientToColor := $ff3D92FC;
        FActiveGradientType := bkConcave;
        FActiveInnerDarkColor := $ff0EA9FC;
        FActiveInnerLightColor := $ff0EA9FC;
        FActiveCaptionColor := $ff80426E;
        if AStyle = spkOffice2007SilverTurquoise then
        begin
          FActiveFrameColor := $ff77620B;
          FActiveGradientFromColor := $ffF4DB82;
          FActiveGradientToColor := $ffECC53E;
          FActiveInnerDarkColor := $ff735B0B;
          FActiveInnerLightColor := $ffF3D87A;
        end;
        FStyle := esRounded;
      end;

    spkMetroLight:
      begin
        FCaptionFont.Style := [];
        FCaptionFontColor := $ff3F3F3F;
        FIdleFrameColor := $ffCDCDCD;
        FIdleGradientFromColor := $ffDFDFDF;
        FIdleGradientToColor := $ffDFDFDF;
        FIdleGradientType := bkSolid;
        FIdleInnerDarkColor := $ffCDCDCD;
        FIdleInnerLightColor := $ffEBEBEB;
        FIdleCaptionColor := $ff696969;
        FHotTrackFrameColor := $ffF9CEA4;
        FHotTrackGradientFromColor := $ffF7EFE8;
        FHotTrackGradientToColor := $ffF7EFE8;
        FHotTrackGradientType := bkSolid;
        FHotTrackInnerDarkColor := $ffF7EFE8;
        FHotTrackInnerLightColor := $ffF7EFE8;
        FHotTrackCaptionColor := $ff3F3F3F;
        FHotTrackBrightnessChange := 20;
        FActiveFrameColor := $ffE4A262;
        FActiveGradientFromColor := $ffF7E0C9;
        FActiveGradientToColor := $ffF7E0C9;
        FActiveGradientType := bkSolid;
        FActiveInnerDarkColor := $ffF7E0C9;
        FActiveInnerLightColor := $ffF7E0C9;
        FActiveCaptionColor := $ff2C2C2C;
        FStyle := esRectangle;
      end;

    spkMetroDark:
      begin
        FCaptionFont.Style := [];
        FCaptionFontColor := $ff3F3F3F;
        FIdleFrameColor := $ff8C8482;
        FIdleGradientFromColor := $ff444444;
        FIdleGradientToColor := $ff444444;
        FIdleGradientType := bkSolid;
        FIdleInnerDarkColor := $ff8C8482;
        FIdleInnerLightColor := $ff444444;
        FIdleCaptionColor := $ffB6B6B6;
        FHotTrackFrameColor := $ffC4793C;
        FHotTrackGradientFromColor := $ff805B3D;
        FHotTrackGradientToColor := $ff805B3D;
        FHotTrackGradientType := bkSolid;
        FHotTrackInnerDarkColor := $ff805B3D;
        FHotTrackInnerLightColor := $ff805B3D;
        FHotTrackCaptionColor := $ffF2F2F2;
        FHotTrackBrightnessChange := 10;
        FActiveFrameColor := $ff000000;
        FActiveGradientFromColor := $ff000000;
        FActiveGradientToColor := $ff000000;
        FActiveGradientType := bkSolid;
        FActiveInnerDarkColor := $ff000000;
        FActiveInnerLightColor := $ff000000;
        FActiveCaptionColor := $ffE4E4E4;
        FStyle := esRectangle;
      end;
  end;
end;

procedure TSpkElementAppearance.SaveToPascal(AList: TStrings);
begin
  with AList do
  begin
    Add('  with Element do begin');
    SaveFontToPascal(AList, FCaptionFont, '    CaptionFont');

    Add('    IdleFrameColor := $' + IntToHex(FIdleFrameColor, 8) + ';');
    Add('    IdleGradientFromColor := $' + IntToHex(FIdleGradientFromColor, 8) + ';');
    Add('    IdleGradientToColor := $' + IntToHex(FIdleGradientToColor, 8) + ';');
//    Add('    IdleGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FIdleGradientType)) + ';');
    Add('    IdleInnerDarkColor := $' + IntToHex(FIdleInnerDarkColor, 8) + ';');
    Add('    IdleInnerLightColor := $' + IntToHex(FIdleInnerLightColor, 8) + ';');
    Add('    IdleCaptionColor := $' + IntToHex(FIdleCaptionColor, 8) + ';');

    Add('    HotTrackFrameColor := $' + IntToHex(FHotTrackFrameColor, 8) + ';');
    Add('    HotTrackGradientFromColor := $' + IntToHex(FHotTrackGradientFromColor, 8) + ';');
    Add('    HotTrackGradientToColor := $' + IntToHex(FHotTrackGradientToColor, 8) + ';');
//    Add('    HotTrackGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FHotTrackGradientType)) + ';');
    Add('    HotTrackInnerDarkColor := $' + IntToHex(FHotTrackInnerDarkColor, 8) + ';');
    Add('    HotTrackInnerLightColor := $' + IntToHex(FHotTrackInnerLightColor, 8) + ';');
    Add('    HotTrackCaptionColor := $' + IntToHex(FHotTrackCaptionColor, 8) + ';');
    Add('    HotTrackBrightnessChange := ' + IntToStr(FHotTrackBrightnessChange) + ';');

    Add('    ActiveFrameColor := $' + IntToHex(FActiveFrameColor, 8) + ';');
    Add('    ActiveGradientFromColor := $' + IntToHex(FActiveGradientFromColor, 8) + ';');
    Add('    ActiveGradientToColor := $' + IntToHex(FActiveGradientToColor, 8) + ';');
//    Add('    ActiveGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FActiveGradientType)) + ';');
    Add('    ActiveInnerDarkColor := $' + IntToHex(FActiveInnerDarkColor, 8) + ';');
    Add('    ActiveInnerLightColor := $' + IntToHex(FActiveInnerLightColor, 8) + ';');
    Add('    ActiveCaptionColor := $' + IntToHex(FActiveCaptionColor, 8) + ';');

//    Add('    Style := ' + GetEnumName(TypeInfo(TSpkElementStyle), ord(FStyle)) + ';');
    Add('  end;');
  end;
end;

procedure TSpkElementAppearance.SaveToXML(Node: TSpkXMLNode);
var
  Subnode: TSpkXMLNode;
begin
  if not (assigned(Node)) then
    exit;

  Subnode := Node['CaptionFont', true];
  TSpkXMLTools.Save(Subnode, FCaptionFont);

  Subnode := Node['IdleFrameColor', true];
  Subnode.TextAsColor := FIdleFrameColor;

  Subnode := Node['IdleGradientFromColor', true];
  Subnode.TextAsColor := FIdleGradientFromColor;

  Subnode := Node['IdleGradientToColor', true];
  Subnode.TextAsColor := FIdleGradientToColor;

  Subnode := Node['IdleGradientType', true];
  Subnode.TextAsInteger := integer(FIdleGradientType);

  Subnode := Node['IdleInnerLightColor', true];
  Subnode.TextAsColor := FIdleInnerLightColor;

  Subnode := Node['IdleInnerDarkColor', true];
  Subnode.TextAsColor := FIdleInnerDarkColor;

  Subnode := Node['IdleCaptionColor', true];
  Subnode.TextAsColor := FIdleCaptionColor;

  Subnode := Node['HottrackFrameColor', true];
  Subnode.TextAsColor := FHottrackFrameColor;

  Subnode := Node['HottrackGradientFromColor', true];
  Subnode.TextAsColor := FHottrackGradientFromColor;

  Subnode := Node['HottrackGradientToColor', true];
  Subnode.TextAsColor := FHottrackGradientToColor;

  Subnode := Node['HottrackGradientType', true];
  Subnode.TextAsInteger := integer(FHottrackGradientType);

  Subnode := Node['HottrackInnerLightColor', true];
  Subnode.TextAsColor := FHottrackInnerLightColor;

  Subnode := Node['HottrackInnerDarkColor', true];
  Subnode.TextAsColor := FHottrackInnerDarkColor;

  Subnode := Node['HottrackCaptionColor', true];
  Subnode.TextAsColor := FHottrackCaptionColor;

  Subnode := Node['HottrackBrightnessChange', true];
  Subnode.TextAsInteger := FHotTrackBrightnessChange;

  Subnode := Node['ActiveFrameColor', true];
  Subnode.TextAsColor := FActiveFrameColor;

  Subnode := Node['ActiveGradientFromColor', true];
  Subnode.TextAsColor := FActiveGradientFromColor;

  Subnode := Node['ActiveGradientToColor', true];
  Subnode.TextAsColor := FActiveGradientToColor;

  Subnode := Node['ActiveGradientType', true];
  Subnode.TextAsInteger := integer(FActiveGradientType);

  Subnode := Node['ActiveInnerLightColor', true];
  Subnode.TextAsColor := FActiveInnerLightColor;

  Subnode := Node['ActiveInnerDarkColor', true];
  Subnode.TextAsColor := FActiveInnerDarkColor;

  Subnode := Node['ActiveCaptionColor', true];
  Subnode.TextAsColor := FActiveCaptionColor;

  Subnode := Node['Style', true];
  Subnode.TextAsInteger := integer(FStyle);
end;

procedure TSpkElementAppearance.SetActiveCaptionColor(const Value: TAlphaColor);
begin
  FActiveCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveFrameColor(const Value: TAlphaColor);
begin
  FActiveFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveGradientFromColor(const Value: TAlphaColor);
begin
  FActiveGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveGradientToColor(const Value: TAlphaColor);
begin
  FActiveGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveGradientType(const Value: TBackgroundKind);
begin
  FActiveGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveInnerDarkColor(const Value: TAlphaColor);
begin
  FActiveInnerDarkColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveInnerLightColor(const Value: TAlphaColor);
begin
  FActiveInnerLightColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetCaptionFont(const Value: TFont);
begin
  FCaptionFont := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetCaptionFontColor(const Value: TAlphaColor);
begin
  FCaptionFontColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;

end;

procedure TSpkElementAppearance.SetHotTrackCaptionColor(const Value: TAlphaColor);
begin
  FHotTrackCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackFrameColor(const Value: TAlphaColor);
begin
  FHotTrackFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackGradientFromColor(const Value: TAlphaColor);
begin
  FHotTrackGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackGradientToColor(const Value: TAlphaColor);
begin
  FHotTrackGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackGradientType(const Value: TBackgroundKind);
begin
  FHotTrackGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackInnerDarkColor(const Value: TAlphaColor);
begin
  FHotTrackInnerDarkColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackInnerLightColor(const Value: TAlphaColor);
begin

  FHotTrackInnerLightColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleCaptionColor(const Value: TAlphaColor);
begin
  FIdleCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleFrameColor(const Value: TAlphaColor);
begin
  FIdleFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleGradientFromColor(const Value: TAlphaColor);
begin
  FIdleGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleGradientToColor(const Value: TAlphaColor);
begin
  FIdleGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleGradientType(const Value: TBackgroundKind);
begin
  FIdleGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleInnerDarkColor(const Value: TAlphaColor);
begin
  FIdleInnerDarkColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleInnerLightColor(const Value: TAlphaColor);
begin
  FIdleInnerLightColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetStyle(const Value: TSpkElementStyle);
begin
  FStyle := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

constructor TSpkToolbarAppearanceDispatch.Create(AToolbarAppearance: TSpkToolbarAppearance);
begin
  inherited Create;
  FToolbarAppearance := AToolbarAppearance;
end;

procedure TSpkToolbarAppearanceDispatch.NotifyAppearanceChanged;
begin
  if FToolbarAppearance <> nil then
    FToolbarAppearance.NotifyAppearanceChanged;
end;

constructor TSpkToolbarAppearance.Create(ADispatch: TSpkBaseAppearanceDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
  FAppearanceDispatch := TSpkToolbarAppearanceDispatch.Create(self);
  FTab := TSpkTabAppearance.Create(FAppearanceDispatch);
  FPane := TSpkPaneAppearance.create(FAppearanceDispatch);
  FElement := TSpkElementAppearance.create(FAppearanceDispatch);
end;

destructor TSpkToolbarAppearance.Destroy;
begin
  FElement.Free;
  FPane.Free;
  FTab.Free;
  FAppearanceDispatch.Free;
  inherited;
end;

procedure TSpkToolbarAppearance.Assign(Source: TPersistent);
var
  Src: TSpkToolbarAppearance;
begin
  if Source is TSpkToolbarAppearance then
  begin
    Src := TSpkToolbarAppearance(Source);

    self.FTab.assign(Src.Tab);
    self.FPane.assign(Src.Pane);
    self.FElement.Assign(Src.Element);

    if FDispatch <> nil then
      FDispatch.NotifyAppearanceChanged;
  end
  else
    raise AssignException.Create('TSpkToolbarAppearance.Assign: Cannot assign the object ' + Source.ClassName + ' to TSpkToolbarAppearance!');
end;

procedure TSpkToolbarAppearance.LoadFromXML(Node: TSpkXMLNode);
var
  Subnode: TSpkXMLNode;
begin
  Tab.Reset;
  Pane.Reset;
  Element.Reset;

  if not (assigned(Node)) then
    exit;

  Subnode := Node['Tab', false];
  if assigned(Subnode) then
    Tab.LoadFromXML(Subnode);

  Subnode := Node['Pane', false];
  if assigned(Subnode) then
    Pane.LoadFromXML(Subnode);

  Subnode := Node['Element', false];
  if assigned(Subnode) then
    Element.LoadFromXML(Subnode);
end;

procedure TSpkToolbarAppearance.NotifyAppearanceChanged;
begin
  if assigned(FDispatch) then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TSpkToolbarAppearance.Reset(AStyle: TSpkStyle = spkOffice2007Blue);
begin
  FTab.Reset(AStyle);
  FPane.Reset(AStyle);
  FElement.Reset(AStyle);
  if assigned(FAppearanceDispatch) then
    FAppearanceDispatch.NotifyAppearanceChanged;
end;

procedure TSpkToolbarAppearance.SaveToPascal(AList: TStrings);
begin
  AList.Add('with Appearance do begin');
  FTab.SaveToPascal(AList);
  FPane.SaveToPascal(AList);
  FElement.SaveToPascal(AList);
  AList.Add('end;');
end;

procedure TSpkToolbarAppearance.SaveToXML(Node: TSpkXMLNode);
var
  Subnode: TSpkXMLNode;
begin
  Subnode := Node['Tab', true];
  FTab.SaveToXML(Subnode);

  Subnode := Node['Pane', true];
  FPane.SaveToXML(Subnode);

  Subnode := Node['Element', true];
  FElement.SaveToXML(Subnode);
end;

procedure TSpkToolbarAppearance.SetElementAppearance(const Value: TSpkElementAppearance);
begin
  FElement.assign(Value);
end;

procedure TSpkToolbarAppearance.SetPaneAppearance(const Value: TSpkPaneAppearance);
begin
  FPane.assign(Value);
end;

procedure TSpkToolbarAppearance.SetTabAppearance(const Value: TSpkTabAppearance);
begin
  FTab.assign(Value);
end;

end.

