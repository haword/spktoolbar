unit SpkToolbar;
{$O-}
{.$mode delphi}
{.$Define EnhancedRecordSupport}

(*******************************************************************************
*                                                                              *
*  Plik: SpkToolbar.pas                                                        *
*  Opis: G??wny komponent toolbara                                             *
*  Copyright: (c) 2009 by Spook. Jakiekolwiek u?ycie komponentu bez            *
*             uprzedniego uzyskania licencji od autora stanowi z?amanie        *
*             prawa autorskiego!                                               *
*                                                                              *
*******************************************************************************)

interface

uses
  FMX.Graphics, SysUtils, FMX.Controls, Classes, Math, FMX.Dialogs, FMX.Types,
  SpkGraphTools, SpkGUITools, SpkMath, FMX.ImgList, System.UITypes, System.Types,
  spkt_Appearance, spkt_BaseItem, spkt_Const, spkt_Dispatch, spkt_Tab, spkt_Pane,
  spkt_Types;

type /// <summary>Typ opisuj?cy regiony toolbara, kt?re s? u?ywane podczas
     /// obs?ugi interakcji z mysz?</summary>
  TSpkMouseToolbarElement = (teNone, teToolbarArea, teTabs, teTabContents);

  TSpkTabChangingEvent = procedure(Sender: TObject; OldIndex, NewIndex: integer; var Allowed: boolean) of object;

type
  TSpkToolbar = class;
  TColor = TAlphaColor;
     /// <summary>Klasa dyspozytora s?u??ca do bezpiecznego przyjmowania
     /// informacji oraz ??da? od pod-element?w</summary>
  TSpkToolbarDispatch = class(TSpkBaseToolbarDispatch)
  private
     /// <summary>Komponent toolbara, kt?ry przyjmuje informacje i ??dania
     /// od pod-element?w</summary>
    FToolbar: TSpkToolbar;
  protected
  public
     // *******************
     // *** Konstruktor ***
     // *******************

     /// <summary>Konstruktor</summary>
    constructor Create(AToolbar: TSpkToolbar);

     // ******************************************************************
     // *** Implementacja abstrakcyjnych metod TSpkBaseToolbarDispatch ***
     // ******************************************************************

     /// <summary>Metoda wywo?ywana, gdy zmieni si? zawarto?? obiektu wygl?du
     /// zawieraj?cego kolory i czcionki u?ywane do rysowania toolbara.
     /// </summary>
    procedure NotifyAppearanceChanged; override;
     /// <summary>Metoda wywo?ywana, gdy zmieni si? lista pod-element?w jednego
     /// z element?w toolbara</summary>
    procedure NotifyItemsChanged; override;
     /// <summary>Metoda wywo?ywana, gdy zmieni si? rozmiar lub po?o?enie
     /// (metryka) jednego z element?w toolbara</summary>
    procedure NotifyMetricsChanged; override;
     /// <summary>Metoda wywo?ywana, gdy zmieni si? wygl?d jednego z element?w
     /// toolbara, nie wymagaj?cy jednak przebudowania metryk.</summary>
    procedure NotifyVisualsChanged; override;
     /// <summary>Metoda ??da dostarczenia przez toolbar pomocniczej
     /// bitmapy u?ywanej - przyk?adowo - do obliczania rozmiar?w renderowanego
     /// tekstu</summary>
    function GetTempBitmap: TBitmap; override;
     /// <summary>Metoda przelicza wsp??rz?dne toolbara na wsp??rz?dne
     /// ekranu, co umo?liwia - na przyk?ad - rozwini?cie popup menu.</summary>
    function ClientToScreen(Point: T2DIntPoint): T2DIntPoint; override;
  end;

     /// <summary>Rozszerzony pasek narz?dzi inspirowany Microsoft Fluent
     /// UI</summary>
  TSpkToolbar = class(TControl)
  private
     /// <summary>Instancja obiektu dyspozytora przekazywanego elementom
     /// toolbara</summary>
    FToolbarDispatch: TSpkToolbarDispatch;

     /// <summary>Bufor w kt?rym rysowany jest toolbar</summary>
    FBuffer: TBitmap;
     /// <summary>Pomocnicza bitmapa przekazywana na ?yczenie elementom
     /// toolbara</summary>
    FTemporary: TBitmap;

    FColor: TAlphaColor;

     /// <summary>Tablica rect?w "uchwyt?w" zak?adek</summary>
    FTabRects: array of T2DIntRect;
     /// <summary>Cliprect obszaru "uchwyt?w" zak?adek</summary>
    FTabClipRect: T2DIntRect;
     /// <summary>Cliprect obszaru zawarto?ci zak?adki</summary>
    FTabContentsClipRect: T2DIntRect;

     /// <summary>Element toolbara znajduj?cy si? obecnie pod myszk?</summary>
    FMouseHoverElement: TSpkMouseToolbarElement;
     /// <summary>Element toolbara maj?cy obecnie wy??czno?? na otrzymywanie
     /// komunikat?w od myszy</summary>
    FMouseActiveElement: TSpkMouseToolbarElement;

     /// <summary>"Uchwyt" zak?adki, nad kt?rym znajduje si? obecnie mysz
     /// </summary>
    FTabHover: integer;

     /// <summary>Flaga informuj?ca o tym, czy metryki toolbara i jego element?w
     /// s? aktualne</summary>
    FMetricsValid: boolean;
     /// <summary>Flaga informuj?ca o tym, czy zawarto?? bufora jest aktualna
     /// </summary>
    FBufferValid: boolean;
     /// <summary>Flaga InternalUpdating pozwala na zablokowanie walidacji
     /// metryk i bufora w momencie, gdy komponent przebudowuje swoj? zawarto??.
     /// FInternalUpdating jest zapalana i gaszona wewn?trznie, przez komponent.
     /// </summary>
    FInternalUpdating: boolean;
     /// <summary>Flaga IUpdating pozwala na zablokowanie walidacji
     /// metryk i bufora w momencie, gdy u?ytkownik przebudowuje zawarto??
     /// komponentu. FUpdating jest sterowana przez u?ytkownika.</summary>
    FUpdating: boolean;

    FStyle: TSpkStyle;
    FOnTabChanging: TSpkTabChangingEvent;
    FOnTabChanged: TNotifyEvent;

   {$IFDEF DELAYRUNTIMER}
    procedure DelayRunTimer(Sender: TObject);
   {$ENDIF}

  protected
     /// <summary>Instancja obiektu wygl?du, przechowuj?cego kolory i czcionki
     /// u?ywane podczas renderowania komponentu</summary>
    FAppearance: TSpkToolbarAppearance;
     /// <summary>Zak?adki toolbara</summary>
    FTabs: TSpkTabs;
     /// <summary>Indeks wybranej zak?adki</summary>
    FTabIndex: integer;
     /// <summary>Lista ma?ych obrazk?w element?w toolbara</summary>
    FImages: TImageList;
     /// <summary>Lista ma?ych obrazk?w w stanie "disabled". Je?li nie jest
     /// przypisana, obrazki w stanie "disabled" b?d? generowane automatycznie.
     /// </summary>
    FDisabledImages: TImageList;
     /// <summary>Lista du?ych obrazk?w element?w toolbara</summary>
    FLargeImages: TImageList;
     /// <summary>Lista du?ych obrazk?w w stanie "disabled". Je?li nie jest
     /// przypisana, obrazki w stanie "disabled" b?d? generowane automatycznie.
     /// </summary>
    FDisabledLargeImages: TImageList;

     // *******************************************
     // *** Zarz?dzanie stanem metryki i bufora ***
     // *******************************************


    FImagesWidth: Integer;
    FLargeImagesWidth: Integer;
    function DoTabChanging(OldIndex, NewIndex: integer): boolean;

    procedure SetMetricsInvalid;
     /// <summary>Metoda gasi flag? FBufferValid</summary>
    procedure SetBufferInvalid;
     /// <summary>Metoda waliduje metryki toolbara i jego element?w</summary>
    procedure ValidateMetrics;
     /// <summary>Metoda waliduje zawarto?? bufora</summary>
    procedure ValidateBuffer;
     /// <summary>Metoda w??cza tryb wewn?trznej przebudowy - zapala flag?
     /// FInternalUpdating</summary>
    procedure InternalBeginUpdate;
     /// <summary>Metoda wy??cza tryb wewn?trznej przebudowy - gasi flag?
     /// FInternalUpdating</summary>
    procedure InternalEndUpdate;

     // ********************************************
     // *** Pokrycie metod z dziedziczonych klas ***
     // ********************************************

     /// <summary>Zmiana rozmiaru komponentu</summary>
    procedure Resize; override;
     /// <summary>Metoda wywo?ywana po opuszczeniu obszaru komponentu przez
     /// wska?nik myszy</summary>
    procedure DoMouseLeave; override;
     /// <summary>Metoda wywo?ywana po wci?ni?ciu przycisku myszy</summary>
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
     /// <summary>Metoda wywo?ywana, gdy nad komponentem przesunie si? wska?nik
     /// myszy</summary>
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
     /// <summary>Metoda wywo?ywana po puszczeniu przycisku myszy</summary>
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
     /// <summary>Metoda wywo?ywana, gdy ca?y komponent wczyta si? z DFMa
     /// </summary>
    procedure Loaded; override;
     /// <summary>Metoda wywo?ywana, gdy komponent staje si? Ownerem innego
     /// komponentu, b?d? gdy jeden z jego pod-komponent?w jest zwalniany
     /// </summary>
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

     // ******************************************
     // *** Obs?uga zdarze? myszy dla zak?adek ***
     // ******************************************

     /// <summary>Metoda wywo?ywana po opuszczeniu przez wska?nik myszy obszaru
     /// "uchwyt?w" zak?adek</summary>
    procedure TabMouseLeave;
     /// <summary>Metoda wywo?ywana po wci?ni?ciu przycisku myszy, gdy wska?nik
     /// jest nad obszarem zak?adek</summary>
    procedure TabMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
     /// <summary>Metoda wywo?ywana, gdy mysz przesunie si? ponad obszarem
     /// "uchwyt?w" zak?adek</summary>
    procedure TabMouseMove(Shift: TShiftState; X, Y: Integer);
     /// <summary>Metoda wywo?ywana, gdy jeden z przycisk?w myszy zostanie
     /// puszczony, gdy obszar zak?adek by? aktywnym elementem toolbara
     /// </summary>
    procedure TabMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

     // ******************
     // *** Pomocnicze ***
     // ******************

     /// <summary>Metoda sprawdza, czy cho? jedna zak?adka ma ustawion? flag?
     /// widoczno?ci (Visible)</summary>
    function AtLeastOneTabVisible: boolean;

     // ***************************
     // *** Obs?uga komunikat?w ***
     // ***************************

     /// <summary>Komunikat odbierany, gdy mysz opu?ci obszar komponentu
     /// </summary>
//       procedure CMMouseLeave(var msg : TMessage); message CM_MOUSELEAVE;

     // ********************************
     // *** Obs?uga designtime i DFM ***
     // ********************************

     /// <summary>Metoda zwraca elementy, kt?re maj? zosta? zapisane jako
     /// pod-elementy komponentu</summary>
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
     /// <summary>Metoda pozwala na zapisanie lub odczytanie dodatkowych
     /// w?asno?ci komponentu</summary>
    procedure DefineProperties(Filer: TFiler); override;

     // *************************
     // *** Gettery i settery ***
     // *************************

     /// <summary>Getter dla w?asno?ci Height</summary>
    function GetHeight: integer;
     /// <summary>Setter dla w?asno?ci Appearance</summary>
    procedure SetAppearance(const Value: TSpkToolbarAppearance);
     /// <summary>Getter dla w?asno?ci Color</summary>
    function GetColor: TColor;
     /// <summary>Setter dla w?asno?ci Color</summary>
    procedure SetColor(const Value: TColor);
     /// <summary>Setter dla w?asno?ci TabIndex</summary>
    procedure SetTabIndex(const Value: integer);
     /// <summary>Setter dla w?asno?ci Images</summary>
    procedure SetImages(const Value: TImageList);
     /// <summary>Setter dla w?asno?ci DisabledImages</summary>
    procedure SetDisabledImages(const Value: TImageList);
     /// <summary>Setter dla w?asno?ci LargeImages</summary>
    procedure SetLargeImages(const Value: TImageList);
     /// <summary>Setter dla w?asno?ci DisabledLargeImages</summary>
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetStyle(const Value: TSpkStyle);

  public

     // ***********************************
     // *** Obs?uga zdarze? dyspozytora ***
     // ***********************************

     /// <summary>Reakcja na zmian? struktury element?w toolbara</summary>
    procedure NotifyItemsChanged;
     /// <summary>Reakcja na zmian? metryki element?w toolbara</summary>
    procedure NotifyMetricsChanged;
     /// <summary>Reakcja na zmian? wygl?du element?w toolbara</summary>
    procedure NotifyVisualsChanged;
     /// <summary>Reakcja na zmian? zawarto?ci klasy wygl?du toolbara</summary>
    procedure NotifyAppearanceChanged;
     /// <summary>Metoda zwraca instancj? pomocniczej bitmapy</summary>
    function GetTempBitmap: TBitmap;

     // ********************************
     // *** Konstruktor i destruktor ***
     // ********************************

     /// <summary>Konstruktor</summary>
    constructor Create(AOwner: TComponent); override;
     /// <summary>Destruktor</summary>
    destructor Destroy; override;

     // *****************
     // *** Rysowanie ***
     // *****************

     /// <summary>Metoda odrysowuje zawarto?? komponentu</summary>
    procedure Paint; override;
     /// <summary>Metoda wymusza przebudowanie metryk i bufora</summary>
    procedure ForceRepaint;
     /// <summary>Metoda prze??cza komponent w tryb aktualizacji zawarto?ci
     /// poprzez zapalenie flagi FUpdating</summary>
    procedure BeginUpdate;
     /// <summary>Metoda wy??cza tryb aktualizacji zawarto?ci poprzez zgaszenie
     /// flagi FUpdating</summary>
    procedure EndUpdate;

     // *************************
     // *** Obs?uga element?w ***
     // *************************

     /// <summary>Metoda wywo?ywana w momencie, gdy jedna z zak?adek
     /// jest zwalniana</summary>
     /// <remarks>Nie nale?y wywo?ywa? metody FreeingTab z kodu! Jest ona
     /// wywo?ywana wewn?trznie, a jej zadaniem jest zaktualizowanie wewn?trznej
     /// listy zak?adek.</remarks>
    procedure FreeingTab(ATab: TSpkTab);

     // **************************
     // *** Dost?p do zak?adek ***
     // **************************

     /// <summary>W?asno?? daje dost? do zak?adek w trybie runtime. Do edycji
     /// zak?adek w trybie designtime s?u?y odpowiedni edytor, za? zapisywanie
     /// i odczytywanie z DFMa jest zrealizowane manualnie.</summary>
    property Tabs: TSpkTabs read FTabs;
  published
     /// <summary>Kolor t?a komponentu</summary>
    property Color: TColor read GetColor write SetColor default $FFDEE8F5;
     /// <summary>Obiekt zawieraj?cy atrybuty wygl?du toolbara</summary>
    property Style: TSpkStyle read FStyle write SetStyle default spkOffice2007Blue;

    property Appearance: TSpkToolbarAppearance read FAppearance write SetAppearance;
     /// <summary>Wysoko?? toolbara (tylko do odczytu)</summary>
    property Height: integer read GetHeight;
     /// <summary>Aktywna zak?adka</summary>
    property TabIndex: integer read FTabIndex write SetTabIndex;
     /// <summary>Lista ma?ych obrazk?w</summary>
    property Images: TImageList read FImages write SetImages;
     /// <summary>Lista ma?ych obrazk?w w stanie "disabled"</summary>
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
     /// <summary>Lista du?ych obrazk?w</summary>
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
     /// <summary>Lista du?ych obrazk?w w stanie "disabled"</summary>
    property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;

    property Position;
    property Width;
    property Align;
    property Margins;
    property Cursor;


  end;

implementation


{ TSpkToolbarDispatch }

function TSpkToolbarDispatch.ClientToScreen(Point: T2DIntPoint): T2DIntPoint;
var
  p: TPoint;
  pf: TPointF;
begin
  if FToolbar <> nil then
  begin
    pf :=  FToolbar.LocalToScreen(PointF(Point.x, Point.y));
    Result.x:= Round(pf.X);
    Result.y:= Round(pf.Y);
  end
  else
    result := T2DIntPoint.Create(-1, -1);
end;

constructor TSpkToolbarDispatch.Create(AToolbar: TSpkToolbar);
begin
  inherited Create;
  FToolbar := AToolbar;
end;

function TSpkToolbarDispatch.GetTempBitmap: TBitmap;
begin
  if FToolbar <> nil then
    result := FToolbar.GetTempBitmap
  else
    result := nil;
end;

procedure TSpkToolbarDispatch.NotifyAppearanceChanged;
begin
  if FToolbar <> nil then
    FToolbar.NotifyAppearanceChanged;
end;

procedure TSpkToolbarDispatch.NotifyMetricsChanged;
begin
  if FToolbar <> nil then
    FToolbar.NotifyMetricsChanged;
end;

procedure TSpkToolbarDispatch.NotifyItemsChanged;
begin
  if FToolbar <> nil then
    FToolbar.NotifyItemsChanged;
end;

procedure TSpkToolbarDispatch.NotifyVisualsChanged;
begin
  if FToolbar <> nil then
    FToolbar.NotifyVisualsChanged;
end;

{ TSpkToolbar }

function TSpkToolbar.AtLeastOneTabVisible: boolean;
var
  i: integer;
  TabVisible: boolean;
begin
  result := FTabs.count > 0;
  if result then
  begin
    TabVisible := false;
    i := FTabs.count - 1;
    while (i >= 0) and not (TabVisible) do
    begin
      TabVisible := FTabs[i].Visible;
      dec(i);
    end;
    result := result and TabVisible;
  end;
end;

procedure TSpkToolbar.BeginUpdate;
begin
  FUpdating := true;
end;

//procedure TSpkToolbar.CMMouseLeave(var msg: TMessage);
//begin
//  inherited;
//  MouseLeave;
//end;

constructor TSpkToolbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Inicjacja dziedziczonych w?asno?ci
  inherited Align := TAlignLayout.Top;
  //todo: not found in lcl
  //inherited AlignWithMargins:=true;
  inherited Height := TOOLBAR_HEIGHT;
//  inherited Doublebuffered:=true;

  // Inicjacja wewn?trznych p?l danych
  FToolbarDispatch := TSpkToolbarDispatch.Create(self);

  FBuffer := TBitmap.create;
//  FBuffer.PixelFormat:=pf24bit;

  FTemporary := TBitmap.create;
//  FTemporary.Pixelformat:=pf24bit;

  setlength(FTabRects, 0);
  FTabClipRect := T2DIntRect.create(0, 0, 0, 0);
  FTabContentsClipRect := T2DIntRect.create(0, 0, 0, 0);

  FMouseHoverElement := teNone;
  FMouseActiveElement := teNone;

  FTabHover := -1;

  FMetricsValid := false;
  FBufferValid := false;
  FInternalUpdating := false;
  FUpdating := false;

  // Inicjacja p?l
  FAppearance := TSpkToolbarAppearance.Create(FToolbarDispatch);

  FTabs := TSpkTabs.Create(self);
  FTabs.ToolbarDispatch := FToolbarDispatch;
  FTabs.Appearance := FAppearance;

  FTabIndex := -1;

  FImages := nil;
  FDisabledImages := nil;
  FLargeImages := nil;
  FDisabledLargeImages := nil;
  FColor:= TAlphaColorRec.White;
//  FDesignInteractive:= true;

end;

procedure TSpkToolbar.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);

  Filer.DefineProperty('Tabs', FTabs.ReadNames, FTabs.WriteNames, true);
end;

destructor TSpkToolbar.Destroy;
begin
  // Zwalniamy pola
  FTabs.Clear;
  FreeAndNil(FTabs);

  FreeAndNil(FAppearance);

  // Zwalniamy wewn?trzne pola
  FreeAndNil(FTemporary);
  FreeAndNil(FBuffer);

  FreeAndNil(FToolbarDispatch);

  inherited Destroy;
end;

procedure TSpkToolbar.EndUpdate;
begin
  FUpdating := false;

  ValidateMetrics;
  ValidateBuffer;
  Repaint;
end;

procedure TSpkToolbar.ForceRepaint;
begin
  SetMetricsInvalid;
  SetBufferInvalid;
  Repaint;
end;

procedure TSpkToolbar.FreeingTab(ATab: TSpkTab);
begin
  if FTabs <> nil then
    FTabs.RemoveReference(ATab);
end;

procedure TSpkToolbar.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: integer;
begin
  inherited;

  if FTabs.Count > 0 then
    for i := 0 to FTabs.Count - 1 do
      Proc(FTabs.Items[i]);
end;

function TSpkToolbar.GetColor: TColor;
begin
  result := FColor;
end;

function TSpkToolbar.GetHeight: integer;
begin
  result := round(inherited Height);
end;

function TSpkToolbar.GetTempBitmap: TBitmap;
begin
  result := FTemporary;
end;

procedure TSpkToolbar.InternalBeginUpdate;
begin
  FInternalUpdating := true;
end;

procedure TSpkToolbar.InternalEndUpdate;
begin
  FInternalUpdating := false;

  // Po wewn?trznych zmianach od?wie?amy metryki i bufor
  ValidateMetrics;
  ValidateBuffer;
  Repaint;
end;

procedure TSpkToolbar.Loaded;
begin
  inherited;

  InternalBeginUpdate;

  if FTabs.ListState = lsNeedsProcessing then
  begin
    FTabs.ProcessNames(self.Owner);
  end;

  InternalEndUpdate;

// Proces wewn?trznego update'u zawsze od?wie?a na ko?cu metryki i bufor oraz
// odrysowuje komponent.
end;

procedure TSpkToolbar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  // Podczas procesu przebudowy mysz jest ignorowana.
  if FInternalUpdating or FUpdating then
    exit;

  inherited MouseDown(Button, Shift, X, Y);

  // Mo?liwe, ?e zosta? wci?ni?ty kolejny przycisk myszy. W takiej sytuacji
  // aktywny obiekt otrzymuje kolejn? notyfikacj?.
  if FMouseActiveElement = teTabs then
  begin
    TabMouseDown(Button, Shift, round(X), round(Y));
  end
  else if FMouseActiveElement = teTabContents then
  begin
    if FTabIndex <> -1 then
      FTabs[FTabIndex].MouseDown(Button, Shift, round(X), round(Y));
  end
  else if FMouseActiveElement = teToolbarArea then
  begin
     // Placeholder, je?li zajdzie potrzeba obs?ugi tego zdarzenia
  end
  else
  // Je?li nie ma aktywnego elementu, aktywnym staje si? ten, kt?ry obecnie
  // jest pod mysz?.
if FMouseActiveElement = teNone then
  begin
    if FMouseHoverElement = teTabs then
    begin
      FMouseActiveElement := teTabs;
      TabMouseDown(Button, Shift, round(X), round(Y));
    end
    else if FMouseHoverElement = teTabContents then
    begin
      FMouseActiveElement := teTabContents;
      if FTabIndex <> -1 then
        FTabs[FTabIndex].MouseDown(Button, Shift, round(X), round(Y));
    end
    else if FMouseHoverElement = teToolbarArea then
    begin
      FMouseActiveElement := teToolbarArea;

        // Placeholder, je?li zajdzie potrzeba obs?ugi tego zdarzenia
    end;
  end;
end;

procedure TSpkToolbar.DoMouseLeave;
begin
  inherited;
  // Podczas procesu przebudowy mysz jest ignorowana.
  if FInternalUpdating or FUpdating then
    exit;

  // MouseLeave nie ma szans by? zawo?ane dla obiektu aktywnego, bo po
  // wci?ni?ciu przycisku myszy ka?dy jej ruch jest przekazywany jako
  // MouseMove. Je?li mysz wyjedzie za obszar komponentu, MouseLeave
  // zostanie zawo?any zaraz po MouseUp - ale MouseUp czy?ci aktywny
  // obiekt.
  if FMouseActiveElement = teNone then
  begin
     // Je?li nie ma obiektu aktywnego, obs?ugujemy elementy pod mysz?
    if FMouseHoverElement = teTabs then
    begin
      TabMouseLeave;
    end
    else if FMouseHoverElement = teTabContents then
    begin
      if FTabIndex <> -1 then
        FTabs[FTabIndex].MouseLeave;
    end
    else if FMouseHoverElement = teToolbarArea then
    begin
        // Placeholder, je?li b?dzie potrzeba obs?ugi tego zdarzenia
    end;
  end;

  FMouseHoverElement := teNone;
end;

procedure TSpkToolbar.MouseMove(Shift: TShiftState; X, Y: Single);
var
  NewMouseHoverElement: TSpkMouseToolbarElement;
  MousePoint: T2DIntVector;
begin
  // Podczas procesu przebudowy mysz jest ignorowana.
  if FInternalUpdating or FUpdating then
    exit;

  inherited MouseMove(Shift, X, Y);

  // Sprawdzamy, kt?ry obiekt jest pod mysz?
  MousePoint := T2DIntVector.create(round(X), round(Y));

  if FTabClipRect.contains(MousePoint) then
    NewMouseHoverElement := teTabs
  else if FTabContentsClipRect.contains(MousePoint) then
    NewMouseHoverElement := teTabContents
  else if (X >= 0) and (Y >= 0) and (X < self.width) and (Y < self.height) then
    NewMouseHoverElement := teToolbarArea
  else
    NewMouseHoverElement := teNone;

  // Je?li jest jaki? aktywny obiekt, to on ma wy??czno?? na komunikaty
  if FMouseActiveElement = teTabs then
  begin
    TabMouseMove(Shift, round(X), round(Y));
  end
  else if FMouseActiveElement = teTabContents then
  begin
    if FTabIndex <> -1 then
      FTabs[FTabIndex].MouseMove(Shift, round(X), round(Y));
  end
  else if FMouseActiveElement = teToolbarArea then
  begin
     // Placeholder, je?li zajdzie potrzeba obs?ugi tego zdarzenia
  end
  else if FMouseActiveElement = teNone then
  begin
     // Je?li element pod mysz? si? zmienia, informujemy poprzedni element o
     // tym, ?e mysz opuszcza jego obszar
    if NewMouseHoverElement <> FMouseHoverElement then
    begin
      if FMouseHoverElement = teTabs then
      begin
        TabMouseLeave;
      end
      else if FMouseHoverElement = teTabContents then
      begin
        if FTabIndex <> -1 then
          FTabs[FTabIndex].MouseLeave;
      end
      else if FMouseHoverElement = teToolbarArea then
      begin
           // Placeholder, je?li zajdzie potrzeba obs?ugi tego zdarzenia
      end;
    end;

     // Element pod mysz? otrzymuje MouseMove
    if NewMouseHoverElement = teTabs then
    begin
      TabMouseMove(Shift, round(X), round(Y));
    end
    else if NewMouseHoverElement = teTabContents then
    begin
      if FTabIndex <> -1 then
        FTabs[FTabIndex].MouseMove(Shift, round(X), round(Y));
    end
    else if NewMouseHoverElement = teToolbarArea then
    begin
        // Placeholder, je?li zajdzie potrzeba obs?ugi tego zdarzenia
    end;
  end;

  FMouseHoverElement := NewMouseHoverElement;
end;

procedure TSpkToolbar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  ClearActive: Boolean;
begin
  // Podczas procesu przebudowy mysz jest ignorowana.
  if FInternalUpdating or FUpdating then
    exit;

  Shift:= Shift - [ssLeft];

  inherited MouseUp(Button, Shift, X, Y);

  ClearActive := not (ssLeft in Shift) and not (ssMiddle in Shift) and not (ssRight in Shift);

  // Je?li jest jaki? aktywny obiekt, to on ma wy??czno?? na otrzymywanie
  // komunikat?w
  if FMouseActiveElement = teTabs then
  begin
    TabMouseUp(Button, Shift, round(X), round(Y));
  end
  else if FMouseActiveElement = teTabContents then
  begin
    if FTabIndex <> -1 then
      FTabs[FTabIndex].MouseUp(Button, Shift, round(X), round(Y));
  end
  else if FMouseActiveElement = teToolbarArea then
  begin
     // Placeholder, je?li zajdzie potrzeba obs?ugi tego zdarzenia
  end;

  // Je?li puszczono ostatni przycisk i mysz nie znajduje si? nad aktywnym
  // obiektem, trzeba dodatkowo wywo?a? MouseLeave dla aktywnego i MouseMove
  // dla obiektu pod mysz?.
  if ClearActive and (FMouseActiveElement <> FMouseHoverElement) then
  begin
    if FMouseActiveElement = teTabs then
      TabMouseLeave
    else if FMouseActiveElement = teTabContents then
    begin
      if FTabIndex <> -1 then
        FTabs[FTabIndex].MouseLeave;
    end
    else if FMouseActiveElement = teToolbarArea then
    begin
        // Placeholder, je?li zajdzie potrzeba obs?ugi tego zdarzenia
    end;

    if FMouseHoverElement = teTabs then
      TabMouseMove(Shift, round(X), round(Y))
    else if FMouseHoverElement = teTabContents then
    begin
      if FTabIndex <> -1 then
        FTabs[FTabIndex].MouseMove(Shift, round(X), round(Y));
    end
    else if FMouseHoverElement = teToolbarArea then
    begin
        // Placeholder, je?li zajdzie potrzeba obs?ugi tego zdarzenia
    end;
  end;

  // MouseUp gasi aktywny obiekt, o ile zosta?y puszczone wszystkie
  // przyciski
  if ClearActive then
    FMouseActiveElement := teNone;

end;

procedure TSpkToolbar.Notification(AComponent: TComponent; Operation: TOperation);
var
  Tab: TSpkTab;
  Pane: TSpkPane;
  Item: TSpkBaseItem;
begin
  inherited;

  if AComponent is TSpkTab then
  begin
    FreeingTab(AComponent as TSpkTab);
  end
  else if AComponent is TSpkPane then
  begin
    Pane := AComponent as TSpkPane;
    if (Pane.Parent <> nil) and (Pane.Parent is TSpkTab) then
    begin
      Tab := Pane.Parent as TSpkTab;
      Tab.FreeingPane(Pane);
    end;
  end
  else if AComponent is TSpkBaseItem then
  begin
    Item := AComponent as TSpkBaseItem;
    if (Item.Parent <> nil) and (Item.Parent is TSpkPane) then
    begin
      Pane := Item.Parent as TSpkPane;
      Pane.FreeingItem(Item);
    end;
  end;
end;

procedure TSpkToolbar.NotifyAppearanceChanged;
begin
  SetMetricsInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TSpkToolbar.NotifyMetricsChanged;
begin
  SetMetricsInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TSpkToolbar.NotifyItemsChanged;
var
  OldTabIndex: integer;
begin
  OldTabIndex := FTabIndex;

  if not (AtLeastOneTabVisible) then
    FTabIndex := -1
  else
  begin
    FTabIndex := max(0, min(FTabs.count - 1, FTabIndex));

    // Wiem, ?e przynajmniej jedna zak?adka jest widoczna (z wcze?niejszego
    // warunku), wi?c poni?sza p?tla na pewno si? zako?czy.
    while not (FTabs[FTabIndex].Visible) do
      FTabIndex := (FTabIndex + 1) mod FTabs.count;
  end;
  FTabHover := -1;

  SetMetricsInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TSpkToolbar.NotifyVisualsChanged;
begin
  SetBufferInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TSpkToolbar.Paint;
var
  rf: TRectF;
begin
// Je?li trwa proces przebudowy (wewn?trznej lub u?ytkownika), walidacja metryk
// i bufora nie jest przeprowadzana, jednak bufor jest rysowany w takiej
// postaci, w jakiej zosta? zapami?tany przed rozpocz?ciem procesu przebudowy.

  if not (FInternalUpdating or FUpdating) then
  begin
    if not (FMetricsValid) then
      ValidateMetrics;
    if not (FBufferValid) then
      ValidateBuffer;
  end;

  self.canvas.DrawBitmap(FBuffer, LocalRect, LocalRect, 1, true);

end;

procedure TSpkToolbar.Resize;
begin
  inherited Height := TOOLBAR_HEIGHT;

  SetMetricsInvalid;
  SetBufferInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;

  inherited;
end;

procedure TSpkToolbar.SetBufferInvalid;
begin
  FBufferValid := false;
end;

procedure TSpkToolbar.SetColor(const Value: TColor);
begin

  FColor := Value;
  SetBufferInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TSpkToolbar.SetDisabledImages(const Value: TImageList);
begin
  FDisabledImages := Value;
  FTabs.DisabledImages := Value;
  SetMetricsInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TSpkToolbar.SetDisabledLargeImages(const Value: TImageList);
begin
  FDisabledLargeImages := Value;
  FTabs.DisabledLargeImages := Value;
  SetMetricsInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TSpkToolbar.SetImages(const Value: TImageList);
begin
  FImages := Value;
  FTabs.Images := Value;
  SetMetricsInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TSpkToolbar.SetLargeImages(const Value: TImageList);
begin
  FLargeImages := Value;
  FTabs.LargeImages := Value;
  SetMetricsInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TSpkToolbar.SetStyle(const Value: TSpkStyle);
begin
  FStyle := Value;
  FAppearance.Reset(FStyle);
  ForceRepaint;
end;

function TSpkToolbar.DoTabChanging(OldIndex, NewIndex: integer): boolean;
begin
  Result := True;
  if Assigned(FOnTabChanging) then
    FOnTabChanging(Self, OldIndex, NewIndex, Result);
end;

procedure TSpkToolbar.SetMetricsInvalid;
begin
  FMetricsValid := false;
  FBufferValid := false;
end;

procedure TSpkToolbar.SetTabIndex(const Value: integer);
var
  OldTabIndex: integer;
begin
  OldTabIndex := FTabIndex;

  if not (AtLeastOneTabVisible) then
    FTabIndex := -1
  else
  begin
    FTabIndex := max(0, min(FTabs.count - 1, Value));

    // Wiem, ?e przynajmniej jedna zak?adka jest widoczna (z wcze?niejszego
    // warunku), wi?c poni?sza p?tla na pewno si? zako?czy.
    while not (FTabs[FTabIndex].Visible) do
      FTabIndex := (FTabIndex + 1) mod FTabs.count;
  end;
  FTabHover := -1;

  if DoTabChanging(OldTabIndex, FTabIndex) then
  begin
  SetMetricsInvalid;

  if not (FInternalUpdating or FUpdating) then
    Repaint;
    if Assigned(FOnTabChanged) then
      FOnTabChanged(self);
  end
  else
    FTabIndex := OldTabIndex;
end;

procedure TSpkToolbar.TabMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  SelTab: Integer;
  TabRect: T2DIntRect;
  i: Integer;
begin
// Podczas procesu przebudowy mysz jest ignorowana.
  if FInternalUpdating or FUpdating then
    exit;

  SelTab := -1;
  if AtLeastOneTabVisible then
    for i := 0 to FTabs.count - 1 do
      if FTabs[i].visible then
      begin
        if FTabClipRect.IntersectsWith(FTabRects[i], TabRect) then
          if TabRect.contains(T2DIntPoint.Create(X, Y)) then
            SelTab := i;
      end;

// Je?li klikni?ta zosta?a kt?ra? zak?adka, r??na od obecnie zaznaczonej,
// zmie? zaznaczenie.
  if (Button = TMouseButton.mbLeft) and (SelTab <> -1) and (SelTab <> FTabIndex) then
  begin
    if DoTabChanging(FTabIndex, SelTab) then
  begin
    FTabIndex := SelTab;
    SetMetricsInvalid;
    Repaint;
      if Assigned(FOnTabChanged) then
        FOnTabChanged(self);
    end;
  end;
end;

procedure TSpkToolbar.TabMouseLeave;
begin
// Podczas procesu przebudowy mysz jest ignorowana.
  if FInternalUpdating or FUpdating then
    exit;

  if FTabHover <> -1 then
  begin
    FTabHover := -1;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TSpkToolbar.TabMouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewTabHover: integer;
  TabRect: T2DIntRect;
  i: integer;
begin
// Podczas procesu przebudowy mysz jest ignorowana.
  if FInternalUpdating or FUpdating then
    exit;

  NewTabHover := -1;
  if AtLeastOneTabVisible then
    for i := 0 to FTabs.count - 1 do
      if FTabs[i].Visible then
      begin
        if FTabClipRect.IntersectsWith(FTabRects[i], TabRect) then
          if TabRect.contains(T2DIntPoint.Create(X, Y)) then
            NewTabHover := i;
      end;

  if NewTabHover <> FTabHover then
  begin
    FTabHover := NewTabHover;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TSpkToolbar.TabMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
// Podczas procesu przebudowy mysz jest ignorowana.
  if FInternalUpdating or FUpdating then
    exit;

  if (FTabIndex > -1) then
    FTabs[FTabIndex].ExecOnClick;

end;

procedure TSpkToolbar.SetAppearance(const Value: TSpkToolbarAppearance);
begin
  FAppearance.assign(Value);

  SetBufferInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TSpkToolbar.ValidateBuffer;

  procedure DrawBackgroundColor;
  var
    r: TRectF;
  begin
    r:=RectF(0, 0, self.width, self.height);
//    InflateRect(R, -0.5, -0.5);
    FBuffer.canvas.BeginScene();
    FBuffer.canvas.AlignToPixel(R);
    FBuffer.canvas.Fill.color := Color;
    FBuffer.canvas.Fill.Kind := TBrushKind.Solid;
    FBuffer.canvas.fillrect(r,0,0, AllCorners,1);
    FBuffer.canvas.EndScene;
  end;

  procedure DrawBody;
  var
    FocusedAppearance: TSpkToolbarAppearance;
    i: Integer;
  begin
  // Pobieramy appearance aktualnie zaznaczonej zak?adki (b?d?
  // FToolbarAppearance, je?li zaznaczona zak?adka nie ma ustawionego
  // OverrideAppearance
    if (FTabIndex <> -1) and (FTabs <> nil) and (FTabs.Count>0) and
      (FTabs[FTabIndex].OverrideAppearance) then
      FocusedAppearance := FTabs[FTabIndex].CustomAppearance
    else
      FocusedAppearance := FAppearance;

    TGuiTools.DrawRoundRect(FBuffer.Canvas, T2DIntRect.Create(0, TOOLBAR_TAB_CAPTIONS_HEIGHT, Round(self.width) - 1, round(self.Height) - 1), TOOLBAR_CORNER_RADIUS, FocusedAppearance.Tab.GradientFromColor, FocusedAppearance.Tab.GradientToColor, FocusedAppearance.Tab.GradientType);
    TGuiTools.DrawAARoundCorner(FBuffer, T2DIntPoint.Create(0, TOOLBAR_TAB_CAPTIONS_HEIGHT),      TOOLBAR_CORNER_RADIUS, cpLeftTop, FocusedAppearance.Tab.BorderColor);
    TGuiTools.DrawAARoundCorner(FBuffer, T2DIntPoint.Create(round(self.width) - TOOLBAR_CORNER_RADIUS, TOOLBAR_TAB_CAPTIONS_HEIGHT), TOOLBAR_CORNER_RADIUS, cpRightTop, FocusedAppearance.Tab.BorderColor);
    TGuiTools.DrawAARoundCorner(FBuffer, T2DIntPoint.Create(0, self.height - TOOLBAR_CORNER_RADIUS),      TOOLBAR_CORNER_RADIUS, cpLeftBottom, FocusedAppearance.Tab.BorderColor);
    TGuiTools.DrawAARoundCorner(FBuffer, T2DIntPoint.Create(round(self.width) - TOOLBAR_CORNER_RADIUS, self.height - TOOLBAR_CORNER_RADIUS), TOOLBAR_CORNER_RADIUS, cpRightBottom, FocusedAppearance.Tab.BorderColor);
    TGuiTools.DrawVLine(FBuffer, 0, TOOLBAR_TAB_CAPTIONS_HEIGHT + TOOLBAR_CORNER_RADIUS, self.height - TOOLBAR_CORNER_RADIUS, FocusedAppearance.Tab.BorderColor);
    TGuiTools.DrawHLine(FBuffer, TOOLBAR_CORNER_RADIUS, round(self.Width) - TOOLBAR_CORNER_RADIUS, round(self.height) - 1, FocusedAppearance.Tab.BorderColor);
    TGuiTools.DrawVLine(FBuffer, round(self.width) - 1, TOOLBAR_TAB_CAPTIONS_HEIGHT + TOOLBAR_CORNER_RADIUS, self.height - TOOLBAR_CORNER_RADIUS, FocusedAppearance.Tab.BorderColor);

    if not (AtLeastOneTabVisible) then
    begin
     // Je?li nie ma zak?adek, rysujemy poziom? lini?
      TGuiTools.DrawHLine(FBuffer, TOOLBAR_CORNER_RADIUS, round(self.width) - TOOLBAR_CORNER_RADIUS, TOOLBAR_TAB_CAPTIONS_HEIGHT, FocusedAppearance.Tab.BorderColor);
    end
    else
    begin
     // Je?li s?, pozostawiamy miejsce na zak?adki
     // Szukamy ostatniej widocznej
      i := FTabs.count - 1;
      while not (FTabs[i].Visible) do
        dec(i);

     // Tylko prawa cz???, reszta b?dzie narysowana wraz z zak?adkami
      if FTabRects[i].Right < self.width - TOOLBAR_CORNER_RADIUS - 1 then
        TGuiTools.DrawHLine(FBuffer, FTabRects[i].Right + 1, Round(self.width) - TOOLBAR_CORNER_RADIUS, TOOLBAR_TAB_CAPTIONS_HEIGHT, FocusedAppearance.Tab.BorderColor);
    end;
  end;

  procedure DrawTabs;
  var
    i: Integer;
    TabRect: T2DIntRect;
    CurrentAppearance: TSpkToolbarAppearance;
    FocusedAppearance: TSpkToolbarAppearance;

    procedure DrawTabText(index: integer; AFont: TFont; FontColor: TAlphaColor);
    var
      x, y: integer;
      TabRect: T2DIntRect;
      clr: TColor;
    begin
      TabRect := FTabRects[index];

      FBuffer.canvas.font.assign(AFont);
      FBuffer.canvas.Fill.Kind:= TBrushKind.None;
      FBuffer.canvas.Fill.Color:=  FontColor;

      x := TabRect.left + (TabRect.Width - round(FBuffer.Canvas.textwidth(FTabs[index].caption))) div 2;
      y := TabRect.top + (TabRect.Height - round(FBuffer.Canvas.Textheight('Wy'))) div 2;

      TGuiTools.DrawText(FBuffer.Canvas, x, y, FTabs[index].Caption, FBuffer.Canvas.Fill.Color, FTabClipRect);
    end;

    procedure DrawTab(index: integer; Border, GradientFrom, GradientTo, TextColor: TAlphaColor);
    var
      TabRect: T2DIntRect;
      TabRegion: T2DIntRect;
    //  TmpRegion, TmpRegion2: TRectF;
    begin
    // * Notatka! * Zak?adki zachodz? jednym pikslem na obszar toolbara,
    // poniewa? musz? narysowa? kraw?d?, kt?ra zgra si? z kraw?dzi? obszaru.
      TabRegion := FTabRects[index];
      TabRect:= T2DIntRect.Create(TabRegion.Left + TAB_CORNER_RADIUS - 1, TabRegion.Top, TabRegion.Right - TAB_CORNER_RADIUS + 1, TabRegion.Bottom+1);


//    // ?rodkowy prostok?t
//      TabRegion := RectF(TabRect.Left + TAB_CORNER_RADIUS - 1, TabRect.Top + TAB_CORNER_RADIUS, TabRect.Right - TAB_CORNER_RADIUS + 1 + 1, TabRect.Bottom + 1);
//      TabRegion := RectF(TabRect.Left, TabRect.Top, TabRect.Right, TabRect.Bottom);


//    // G?rna cz??? z g?rnymi zaokr?gleniami wypuk?ymi
//      TmpRegion := RectF(TabRect.Left + 2 * TAB_CORNER_RADIUS - 1, TabRect.Top, TabRect.Right - 2 * TAB_CORNER_RADIUS + 1 + 1, TabRect.Top + TAB_CORNER_RADIUS);
//      CombineRgn(TabRegion, TabRegion, TmpRegion, RGN_OR);
//      DeleteObject(TmpRegion);
//
//      TmpRegion := CreateEllipticRgn(TabRect.Left + TAB_CORNER_RADIUS - 1, TabRect.Top, TabRect.Left + 3 * TAB_CORNER_RADIUS, TabRect.Top + 2 * TAB_CORNER_RADIUS + 1);
//      CombineRgn(TabRegion, TabRegion, TmpRegion, RGN_OR);
//      DeleteObject(TmpRegion);
//
//      TmpRegion := CreateEllipticRgn(TabRect.Right - 3 * TAB_CORNER_RADIUS + 2, TabRect.Top, TabRect.Right - TAB_CORNER_RADIUS + 3, TabRect.Top + 2 * TAB_CORNER_RADIUS + 1);
//      CombineRgn(TabRegion, TabRegion, TmpRegion, RGN_OR);
//      DeleteObject(TmpRegion);
//
//    // Dolna cz??? z dolnymi zaokr?gleniami wkl?s?ymi
//
//      TmpRegion := CreateRectRgn(TabRect.Left, TabRect.Bottom - TAB_CORNER_RADIUS, TabRect.Right + 1, TabRect.Bottom + 1);
//
//      TmpRegion2 := CreateEllipticRgn(TabRect.Left - TAB_CORNER_RADIUS, TabRect.Bottom - 2 * TAB_CORNER_RADIUS + 1, TabRect.Left + TAB_CORNER_RADIUS + 1, TabRect.Bottom + 2);
//      CombineRgn(TmpRegion, TmpRegion, TmpRegion2, RGN_DIFF);
//      DeleteObject(TmpRegion2);
//
//      TmpRegion2 := CreateEllipticRgn(TabRect.Right - TAB_CORNER_RADIUS + 1, TabRect.Bottom - 2 * TAB_CORNER_RADIUS + 1, TabRect.Right + TAB_CORNER_RADIUS + 2, TabRect.Bottom + 2);
//      CombineRgn(TmpRegion, TmpRegion, TmpRegion2, RGN_DIFF);
//      DeleteObject(TmpRegion2);
//
//      CombineRgn(TabRegion, TabRegion, TmpRegion, RGN_OR);
//      DeleteObject(TmpRegion);

//      TGUITools.DrawRegion(FBuffer.Canvas, TabRegion.ForWinAPI, TabRect, TAB_CORNER_RADIUS, GradientFrom,
//          GradientTo, bkVerticalGradient, [TCorner.TopLeft, TCorner.TopRight]);

//      TGUITools.DrawRegion(FBuffer.Canvas, TmpRegion, TabRect, TAB_CORNER_RADIUS, GradientFrom, GradientTo, bkVerticalGradient);

//      TGUITools.DrawAARoundFrame(FBuffer, TabRect, TAB_CORNER_RADIUS, Border, TabRegion, [TCorner.TopLeft, TCorner.TopRight]);

//      DeleteObject(TabRegion);

    // Ramka

        TGUITools.DrawTab(FBuffer, TabRegion, TAB_CORNER_RADIUS, Border, GradientFrom, GradientTo);
//      TGuiTools.DrawAARoundCorner(FBuffer, T2DIntPoint.create(TabRect.left, TabRect.bottom - TAB_CORNER_RADIUS + 1), TAB_CORNER_RADIUS, cpRightBottom, Border, FTabClipRect);
//      TGuiTools.DrawAARoundCorner(FBuffer, T2DIntPoint.create(TabRect.right - TAB_CORNER_RADIUS + 1, TabRect.bottom - TAB_CORNER_RADIUS + 1), TAB_CORNER_RADIUS, cpLeftBottom, Border, FTabClipRect);
//
//      TGuiTools.DrawVLine(FBuffer, TabRect.left + TAB_CORNER_RADIUS - 1, TabRect.top + TAB_CORNER_RADIUS, TabRect.Bottom - TAB_CORNER_RADIUS + 1, Border, FTabClipRect);
//      TGuiTools.DrawVLine(FBuffer, TabRect.Right - TAB_CORNER_RADIUS + 1, TabRect.top + TAB_CORNER_RADIUS, TabRect.Bottom - TAB_CORNER_RADIUS + 1, Border, FTabClipRect);
//
//      TGuiTools.DrawAARoundCorner(FBuffer, T2DIntPoint.create(TabRect.left + TAB_CORNER_RADIUS - 1, 0), TAB_CORNER_RADIUS, cpLeftTop, Border, FTabClipRect);
//      TGuiTools.DrawAARoundCorner(FBuffer, T2DIntPoint.Create(TabRect.right - 2 * TAB_CORNER_RADIUS + 2, 0), TAB_CORNER_RADIUS, cpRightTop, Border, FTabClipRect);
//
//      TGuiTools.DrawHLine(FBuffer, TabRect.left + 2 * TAB_CORNER_RADIUS - 1, TabRect.right - 2 * TAB_CORNER_RADIUS + 2, 0, Border, FTabClipRect);
    end;

    procedure DrawBottomLine(index: integer; Border: TColor);
    var
      TabRect: T2DIntRect;
    begin
      TabRect := FTabRects[index];

      TGUITools.DrawHLine(FBuffer, TabRect.left, TabRect.right, TabRect.bottom, Border, FTabClipRect);
    end;

  var
    delta: byte;
  begin
  // Zak?adam, ?e zak?adki maj? rozs?dne rozmiary

  // Pobieramy appearance aktualnie zaznaczonej zak?adki (jej appearance, je?li
  // ma zapalon? flag? OverrideAppearance, FToolbarAppearance w przeciwnym
  // wypadku)
    if (FTabIndex <> -1) and (FTabs[FTabIndex].OverrideAppearance) then
      FocusedAppearance := FTabs[FTabIndex].CustomAppearance
    else
      FocusedAppearance := FAppearance;

    if FTabs.count > 0 then
      for i := 0 to FTabs.count - 1 do
        if FTabs[i].Visible then
        begin
            // Jest sens rysowa??
          if not (FTabClipRect.IntersectsWith(FTabRects[i])) then
            continue;

            // Pobieramy appearance rysowanej w?a?nie zak?adki
          if (FTabs[i].OverrideAppearance) then
            CurrentAppearance := FTabs[i].CustomAppearance
          else
            CurrentAppearance := FAppearance;

          if CurrentAppearance.Tab.GradientType = bkSolid then
            delta := 0
          else
            delta := 50;

            // Rysujemy zak?adk?
          if i = FTabIndex then
          begin
            if i = FTabHover then
            begin
              DrawTab(i, CurrentAppearance.Tab.BorderColor, TColorTools.Brighten(TColorTools.Brighten(CurrentAppearance.Tab.GradientFromColor, delta), delta), CurrentAppearance.Tab.GradientFromColor, CurrentAppearance.Tab.TabHeaderColor);
            end
            else
            begin
              DrawTab(i, CurrentAppearance.Tab.BorderColor, TColorTools.Brighten(CurrentAppearance.Tab.GradientFromColor, delta), CurrentAppearance.Tab.GradientFromColor, CurrentAppearance.Tab.TabHeaderColor);
            end;

            DrawTabText(i, CurrentAppearance.Tab.TabHeaderFont, CurrentAppearance.Tab.TabHeaderFontColor);
          end
          else
          begin
            if i = FTabHover then
            begin
              DrawTab(i,
                  TColorTools.Shade(self.Color, CurrentAppearance.Tab.BorderColor, delta),
                  TColorTools.Shade(self.color, TColorTools.brighten(CurrentAppearance.Tab.GradientFromColor, delta), delta),
                  TColorTools.Shade(self.color, CurrentAppearance.Tab.GradientFromColor, delta), CurrentAppearance.Tab.TabHeaderColor);
            end;

               // Dolna kreska
               // Uwaga: Niezale?nie od zak?adki rysowana kolorem appearance
               // aktualnie zaznaczonej zak?adki!
            DrawBottomLine(i, FocusedAppearance.Tab.BorderColor);

               // Tekst
            DrawTabText(i, CurrentAppearance.Tab.TabHeaderFont, CurrentAppearance.Tab.TabHeaderFontColor);
          end;
        end;
  end;

  procedure DrawTabContents;
  begin
    if FTabIndex <> -1 then
      FTabs[FTabIndex].Draw(FBuffer, FTabContentsClipRect);
  end;

begin
  if FInternalUpdating or FUpdating then
    exit;
  if FBufferValid then
    exit;

// ValidateBuffer mo?e by? wywo?ane tylko wtedy, gdy metrics zosta?y obliczone.
// Metoda zak?ada, ?e bufor ma ju? odpowiednie rozmiary oraz ?e wszystkie
// recty, zar?wno toolbara jak i element?w podrz?dnych, zosta?y poprawnie
// obliczone.

// *** T?o komponentu ***
  DrawBackgroundColor;

// *** Generowanie t?a dla toolbara ***
  DrawBody;

// *** Zak?adki ***
  DrawTabs;

// *** Zawarto?? zak?adek ***
  DrawTabContents;

// Bufor jest poprawny
  FBufferValid := true;
end;

procedure TSpkToolbar.ValidateMetrics;
var
  i: integer;
  x: integer;
  TabWidth: Integer;
  TabAppearance: TSpkToolbarAppearance;
begin
  if FInternalUpdating or FUpdating then
    exit;
  if FMetricsValid then
    exit;

  FBuffer.SetSize(round(self.width), round(self.height));

// *** Zak?adki ***

// Cliprect zak?adek (zawg?rn? ramk? komponentu)
  FTabClipRect := T2DIntRect.Create(TOOLBAR_CORNER_RADIUS, 0, round(self.width) - TOOLBAR_CORNER_RADIUS - 1, TOOLBAR_TAB_CAPTIONS_HEIGHT);

// Recty nag??wk?w zak?adek (zawieraj? g?rn? ramk? komponentu)
  setlength(FTabRects, FTabs.Count);
  if FTabs.count > 0 then
  begin
    x := TOOLBAR_CORNER_RADIUS;
    for i := 0 to FTabs.count - 1 do
      if FTabs[i].Visible then
      begin
          // Pobieramy appearance zak?adki
        if FTabs[i].OverrideAppearance then
          TabAppearance := FTabs[i].CustomAppearance
        else
          TabAppearance := FAppearance;
        FBuffer.Canvas.font.assign(TabAppearance.Tab.TabHeaderFont);

        TabWidth := 2 +                                                          // Ramka
          2 * TAB_CORNER_RADIUS +                                        // Zaokr?glenia
          2 * TOOLBAR_TAB_CAPTIONS_TEXT_HPADDING +                       // Wewn?trzne marginesy
          max(TOOLBAR_MIN_TAB_CAPTION_WIDTH, round(FBuffer.Canvas.TextWidth(FTabs.Items[i].Caption)));       // Szeroko?? tekstu

        FTabRects[i].Left := x;
        FTabRects[i].Right := x + TabWidth - 1;
        FTabRects[i].Top := 0;
        FTabRects[i].Bottom := TOOLBAR_TAB_CAPTIONS_HEIGHT;

        x := FTabRects[i].right + 1;
      end
      else
      begin
        FTabRects[i] := T2DIntRect.Create(-1, -1, -1, -1);
      end;
  end;

// *** Tafle ***

  if FTabIndex <> -1 then
  begin
   // Rect obszaru zak?adki
    FTabContentsClipRect := T2DIntRect.Create(TOOLBAR_BORDER_WIDTH + TAB_PANE_LEFTPADDING, TOOLBAR_TAB_CAPTIONS_HEIGHT + TOOLBAR_BORDER_WIDTH + TAB_PANE_TOPPADDING, round(self.width) - 1 - TOOLBAR_BORDER_WIDTH - TAB_PANE_RIGHTPADDING, self.Height - 1 - TOOLBAR_BORDER_WIDTH - TAB_PANE_BOTTOMPADDING);

    FTabs[FTabIndex].Rect := FTabContentsClipRect;
  end;

  FMetricsValid := true;
end;

initialization
  RegisterFMXClasses([TSpkToolbar]);

finalization
//  UnRegisterClass(TSpkToolbar);

end.

