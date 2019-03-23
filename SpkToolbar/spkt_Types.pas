unit spkt_Types;
{O-}

(*******************************************************************************
*                                                                              *
*  Plik: spkt_Types.pas                                                        *
*  Opis: Definicje typów u¿ywanych podczas pracy toolbara                      *
*  Copyright: (c) 2009 by Spook. Jakiekolwiek u¿ycie komponentu bez            *
*             uprzedniego uzyskania licencji od autora stanowi z³amanie        *
*             prawa autorskiego!                                               *
*                                                                              *
*******************************************************************************)

interface

uses
  FMX.Controls, Classes, {ContNrs,} SysUtils, FMX.Dialogs, spkt_Exceptions
  , System.Generics.Collections;

type
  TSpkListState = (lsNeedsProcessing, lsReady);

type
  TSpkComponent = class(TComponent)
  private
  protected
    FParent: TComponent;

     // *** Gettery i settery ***
    function GetParent: TComponent;
    procedure SetParent(const Value: TComponent);
  public
     // *** Konstruktor ***
    constructor Create(AOwner: TComponent); override;

     // *** Obs³uga parenta ***
    function HasParent: boolean; override;
    function GetParentComponent: TComponent; override;
    procedure SetParentComponent(Value: TComponent); override;
    property Parent: TComponent read GetParent write SetParent;
  end;

type
  TSpkCollection = class(TPersistent)
  private
  protected
    FList: TObjectList<TComponent>;
    FNames: TStringList;
    FListState: TSpkListState;
    FRootComponent: TComponent;

     // *** Metody reakcji na zmiany w liœcie ***
    procedure Notify(Item: TComponent; Operation: TOperation); virtual;
    procedure Update; virtual;

     // *** Wewnêtrzne metody dodawania i wstawiania elementów ***
    procedure AddItem(AItem: TComponent);
    procedure InsertItem(index: integer; AItem: TComponent);

     // *** Gettery i settery ***
    function GetItems(index: integer): TComponent; virtual;
  public
     // *** Konstruktor, destruktor ***
    constructor Create(RootComponent: TComponent); reintroduce; virtual;
    destructor Destroy; override;

     // *** Obs³uga listy ***
    procedure Clear;
    function Count: integer;
    procedure Delete(index: integer); virtual;
    function IndexOf(Item: TComponent): integer;
    procedure Remove(Item: TComponent); virtual;
    procedure RemoveReference(Item: TComponent);
    procedure Exchange(item1, item2: integer);
    procedure Move(IndexFrom, IndexTo: integer);

     // *** Reader, writer i obs³uga designtime i DFM ***
    procedure WriteNames(Writer: TWriter); virtual;
    procedure ReadNames(Reader: TReader); virtual;
    procedure ProcessNames(Owner: TComponent); virtual;
    property ListState: TSpkListState read FListState;
    property Items[index: integer]: TComponent read GetItems; default;
  end;

implementation

{ TSpkCollection }

procedure TSpkCollection.AddItem(AItem: TComponent);
begin
// Ta metoda mo¿e byæ wywo³ywana bez przetworzenia nazw (w szczególnoœci, metoda
// przetwarzaj¹ca nazwy korzysta z AddItem)
  if FList = nil then
    Exit;

  Notify(AItem, opInsert);
  FList.Add(AItem);

  Update;
end;

procedure TSpkCollection.Clear;
begin
  if FList = nil then
    Exit;

  FList.Clear;

  Update;
end;

function TSpkCollection.Count: integer;
begin
  Result:=0;
  if FList = nil then
    Exit;
  result := FList.Count;
end;

constructor TSpkCollection.Create(RootComponent: TComponent);
begin
  inherited Create;
  FRootComponent := RootComponent;

  FNames := TStringList.create;

  FList := TObjectList<TComponent>.create(True);

  FListState := lsReady;
end;

procedure TSpkCollection.Delete(index: integer);
begin
  if FList = nil then
    Exit;

  if (index < 0) or (index >= FList.count) then
    raise InternalException.Create('TSpkCollection.Delete: Nieprawid³owy indeks!');

  Notify(TComponent(FList[index]), opRemove);

  FList.Delete(index);

  Update;
end;

destructor TSpkCollection.Destroy;
begin
  FreeAndNil(FNames);
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TSpkCollection.Exchange(item1, item2: integer);
begin
  if FList = nil then
    Exit;

  FList.Exchange(item1, item2);
  Update;
end;

function TSpkCollection.GetItems(index: integer): TComponent;
begin
  if FList = nil then
    Exit;

  if (index < 0) or (index >= FList.Count) then
    raise InternalException.create('TSpkCollection.GetItems: Nieprawid³owy indeks!');

  result := TComponent(FList[index]);
end;

function TSpkCollection.IndexOf(Item: TComponent): integer;
begin
  Result:=-1;
  if FList = nil then
    Exit;
  result := FList.IndexOf(Item);
end;

procedure TSpkCollection.InsertItem(index: integer; AItem: TComponent);
begin
  if FList = nil then
    Exit;

  if (index < 0) or (index > FList.Count) then
    raise InternalException.Create('TSpkCollection.Insert: Nieprawid³owy indeks!');

  Notify(AItem, opInsert);

  FList.Insert(index, AItem);

  Update;
end;

procedure TSpkCollection.Move(IndexFrom, IndexTo: integer);
begin
  if FList = nil then
    Exit;

  if (IndexFrom < 0) or (IndexFrom >= FList.Count) or (IndexTo < 0) or (IndexTo >= FList.Count) then
    raise InternalException.Create('TSpkCollection.Move: Nieprawid³owy indeks!');

  FList.Move(IndexFrom, IndexTo);

  Update;
end;

procedure TSpkCollection.Notify(Item: TComponent; Operation: TOperation);
begin
//
end;

procedure TSpkCollection.ProcessNames(Owner: TComponent);
var
  s: string;
  i: Integer;
begin
  if FList = nil then
    Exit;

  FList.Clear;

  if Owner <> nil then
    for i := 0 to FNames.Count - 1 do
      AddItem(Owner.FindComponent(FNames[i]));

  FNames.Clear;
  FListState := lsReady;
end;

procedure TSpkCollection.ReadNames(Reader: TReader);
begin
  Reader.ReadListBegin;

  FNames.Clear;
  while not (Reader.EndOfList) do
    FNames.Add(Reader.ReadString);

  Reader.ReadListEnd;

  FListState := lsNeedsProcessing;
end;

procedure TSpkCollection.Remove(Item: TComponent);
var
  i: integer;
begin
  if FList = nil then
    Exit;

  i := FList.IndexOf(Item);

  if i >= 0 then
  begin
    Notify(Item, opRemove);

    FList.Delete(i);

    Update;
  end;
end;

procedure TSpkCollection.RemoveReference(Item: TComponent);
var
  i: integer;
begin
  if not Assigned(FList) or (FList = nil) then
    Exit;

  i := FList.IndexOf(Item);

  if i >= 0 then
  begin
    Notify(Item, opRemove);

    FList.Extract(Item);

    Update;
  end;
end;

procedure TSpkCollection.Update;
begin
//
end;

procedure TSpkCollection.WriteNames(Writer: TWriter);
var
  Item: pointer;
  i: Integer;
begin
  if FList = nil then
    Exit;

  Writer.WriteListBegin;

  for i := 0 to FList.Count - 1 do
    Writer.WriteString(TComponent(FList[i]).Name);

  Writer.WriteListEnd;
end;

{ TSpkComponent }

constructor TSpkComponent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParent := nil;
end;

function TSpkComponent.GetParent: TComponent;
begin
  result := GetParentComponent;
end;

function TSpkComponent.GetParentComponent: TComponent;
begin
  result := FParent;
end;

function TSpkComponent.HasParent: boolean;
begin
  result := FParent <> nil;
end;

procedure TSpkComponent.SetParent(const Value: TComponent);
begin
  SetParentComponent(Value);
end;

procedure TSpkComponent.SetParentComponent(Value: TComponent);
begin
  FParent := Value;
end;

end.

