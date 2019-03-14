unit SpkXMLParser;

{$DEFINE SPKXMLPARSER}

interface

{TODO Uporz¹dkowaæ widocznoœæ i wirtualnoœæ metod i w³asnoœci}

// Notatki: Stosujê konsekwentnie case-insensitivity

uses
  SysUtils, Classes, ContNrs, FMX.Graphics, System.Math, System.UITypes;

//todo: use LineEnding?
const CRLF=#13#10;

type // Rodzaj ga³êzi XML
     TXMLNodeType = (xntNormal, xntControl, xntComment);
     TColor = TAlphaColor;

type // Forward dla klasy ga³êzi XML
     TSpkXMLNode = class;

     TBinaryTreeNode = class;

     // Ga³¹Ÿ drzewa binarnych przeszukiwañ
     TBinaryTreeNode = class(TObject)
     private
     // Lewe poddrzewo
       FLeft,
     // Prawe poddrzewo
       FRight,
     // Rodzic
       FParent : TBinaryTreeNode;
     // Dane zawarte w wêŸle
       FData : array of TSpkXMLNode;
     // Wysokoœæ poddrzewa
       FSubtreeSize : integer;
     protected
     // *** Metody dotycz¹ce drzewa ***

     // Setter dla lewego poddrzewa
       procedure SetLeft(ANode : TBinaryTreeNode);
     // Setter dla prawego poddrzewa
       procedure SetRight(ANode : TBinaryTreeNode);

     // *** Metody dotycz¹ce danych ***

     // Getter dla liczby danych zawartych w wêŸle
       function GetCount : integer;
     // Getter dla danych zawartych w wêŸle
       function GetData(index : integer) : TSpkXMLNode;
     public
     // Konstruktor
       constructor create;
     // Destruktor
       destructor Destroy; override;

     // *** Metody dotycz¹ce drzewa ***

     // Wymuszenie odœwie¿enia wysokoœci poddrzewa
       procedure RefreshSubtreeSize;
     // Metoda powoduje odpiêcie od obecnego parenta (wywo³ywana tylko przez
     // niego)
       procedure DetachFromParent;
     // Metoda powoduje przypiêcie do nowego parenta (wywo³ywana przez nowego
     // parenta
       procedure AttachToParent(AParent : TBinaryTreeNode);
     // Metoda wywo³ywana przez jedno z dzieci w momencie, gdy jest ono
     // przepinane do innego drzewa
       procedure DetachChild(AChild : TBinaryTreeNode);

     // *** Metody dotycz¹ce danych ***

     // Dodaje dane
       procedure Add(AData : TSpkXMLNode);
     // Usuwa dane z listy (nie zwalnia!)
       procedure Remove(AData : TSpkXMLNode);
     // Usuwa dane o zadanym indeksie (nie zwalnia!)
       procedure Delete(index : integer);
     // Usuwa wszystkie dane
       procedure Clear;

       property Data[index : integer] : TSpkXMLNode read GetData;

       property Left : TBinaryTreeNode read FLeft write SetLeft;
       property Right : TBinaryTreeNode read FRight write SetRight;
       property Parent : TBinaryTreeNode read FParent;
       property SubtreeSize : integer read FSubtreeSize;
       property Count : integer read GetCount;
     end;

     // Klasa przechowuj¹ca pojedynczy parametr ga³êzi XMLowej
     TSpkXMLParameter = class(TObject)
     private
     // Nazwa parametru
       FName,
     // Wartoœæ parametru
       FValue : string;
     protected
     // Getter dla w³asnoœci ValueAsInteger
       function GetValueAsInteger : integer;
     // Setter dla w³asnoœci ValueAsInteger
       procedure SetValueAsInteger(AValue : integer);
     // Getter dla w³asnoœci ValueAsExtended
       function GetValueAsExtended : extended;
     // Setter dla w³asnoœci ValueAsExtended
       procedure SetValueAsExtended(AValue : extended);
     // Getter dla w³asnoœci ValueAsColor
       function GetValueAsColor : TColor;
     // Setter dla w³asnoœci ValueAsColor
       procedure SetValueAsColor(AValue : TColor);
     // Getter dla w³asnoœci ValueAsBoolean
       function GetValueAsBoolean : boolean;
     // Setter dla w³asnoœci ValueAsBoolean
       procedure SetValueAsBoolean(AValue : boolean);
     public
     // Konstruktor
       constructor create; overload;
     // Konstruktor pozwalaj¹cy nadaæ pocz¹tkowe wartoœci parametrowi
       constructor create(AName : string; AValue : string); overload;
     // Destruktor
       destructor Destroy; override;

       property Name : string read FName write FName;
       property Value : string read FValue write FValue;
       property ValueAsInteger : integer read GetValueAsInteger write SetValueAsInteger;
       property ValueAsExtended : extended read GetValueAsExtended write SetValueAsExtended;
       property ValueAsColor : TColor read GetValueAsColor write SetValueAsColor;
       property ValueAsBoolean : boolean read GetValueAsBoolean write SetValueAsBoolean;
     end;

     // Lista parametrów
     TSpkXMLParameters = class(TObject)
     private
     // Wewnêtrzna lista na której przechowywane s¹ parametry ga³êzi
       FList : TObjectList;
     protected
     // Getter dla w³asnoœci ParamByName (szuka parametru po jego nazwie)
       function GetParamByName(index : string; autocreate : boolean) : TSpkXMLParameter;
     // Getter dla w³asnoœci ParamByIndex (zwraca i-ty parametr)
       function GetParamByIndex(index : integer) : TSpkXMLParameter;
     // Zwraca liczbê parametrów
       function GetCount : integer;
     public
     // Konstruktor
       constructor create;
     // Destruktor
       destructor Destroy; override;

     // Dodaje parametr na listê
       procedure Add(AParameter : TSpkXMLParameter);
     // Wstawia parametr na listê na zadane miejsce
       procedure Insert( AIndex : integer; AParameter : TSpkXMLParameter);
     // Usuwa parametr o podanym indeksie z listy
       procedure Delete(index : integer);
     // Usuwa zadany parametr z listy
       procedure Remove(AParameter : TSpkXMLParameter);
     // Zwraca indeks zadanego parametru
       function IndexOf(AParameter : TSpkXMLParameter) : integer;
     // Czyœci listê parametrów
       procedure Clear;

       property ParamByName[index : string; autocreate : boolean] : TSpkXMLParameter read GetParamByName; default;
       property ParamByIndex[index : integer] : TSpkXMLParameter read GetParamByIndex;

       property Count : integer read GetCount;
     end;

     TSpkBaseXmlNode = class;

     // Bazowa klasa dla ga³êzi XMLowych, zapewniaj¹ca przechowywanie, operacje
     // i wyszukiwanie podga³êzi.
     TSpkBaseXmlNode = class(TObject)
     private
       FList : TObjectList;
       FTree : TBinaryTreeNode;
       FParent : TSpkBaseXmlNode;
     protected
     // *** Operacje na drzewie AVL ***
     // Dodaje do drzewa ga³¹Ÿ z zadan¹ TSpkXMLNode
       procedure TreeAdd(ANode : TSpkXMLNode);
     // Usuwa z drzewa ga³¹Ÿ z zadan¹ TSpkXMLNode
       procedure TreeDelete(ANode : TSpkXMLNode);
     // Szuka ga³êzi drzewa
       function TreeFind(ANode : TSpkXMLNode) : TBinaryTreeNode;
     // Balansuje wszystkie wêz³y od zadanego do korzenia w³¹cznie.
       procedure Ballance(Leaf : TBinaryTreeNode);
     // Obraca wêze³ w lewo i zwraca wêze³, który znalaz³ siê w miejscu
     // obróconego.
       function RotateLeft(Root : TBinaryTreeNode) : TBinaryTreeNode;
     // Obraca wêze³ w prawo i zwraca wêze³, który znalaz³ siê w miejscu
     // obróconego
       function RotateRight(Root : TBinaryTreeNode) : TBinaryTreeNode;

       function GetNodeByIndex(index : integer) : TSpkXMLNode;
       function GetNodeByName(index : string; autocreate : boolean) : TSpkXMLNode;
       function GetCount : integer;
     public
     // Konstruktor
       constructor create; virtual;
     // Destruktor
       destructor Destroy; override;

     // Dodaje podga³¹Ÿ i umieszcza w odpowiednim miejscu w drzewie
       procedure Add(ANode : TSpkXMLNode);
     // Wstawia podga³¹Ÿ w podane miejsce (na drzewie ma to taki sam efekt
     // jak dodanie)
       procedure Insert(AIndex : integer; ANode : TSpkXMLNode);
     // Usuwa podga³¹Ÿ z listy i z drzewa, a nastêpnie zwalnia pamiêæ
       procedure Delete(AIndex : integer);
     // Usuwa podga³¹Ÿ z listy i z drzewa, a nastêpnie zwalnia pamiêæ
       procedure Remove(ANode : TSpkXMLNode);
     // Zwraca indeks podga³êzi
       function IndexOf(ANode : TSpkXMLNode) : integer;
     // Usuwa wszystkie podga³êzie
       procedure Clear; virtual;

     // Metoda powinna zostaæ wywo³ana przed zmian¹ nazwy przez jedn¹ z podga³êzi
       procedure BeforeChildChangeName(AChild : TSpkXmlNode);
     // Metoda powinna zostaæ wywo³ana po zmianie nazwy przez jedn¹ z podga³êzi
       procedure AfterChildChangeName(AChild : TSpkXMLNode);

       property NodeByIndex[index : integer] : TSpkXMLNode read GetNodeByIndex;
       property NodeByName[index : string; autocreate : boolean] : TSpkXMLNode read GetNodeByName; default;
       property Count : integer read GetCount;
       property Parent : TSpkBaseXmlNode read FParent write FParent;
     end;

     // Ga³¹Ÿ XMLa. Dziêki temu, ¿e dziedziczymy po TSpkBaseXMLNode mamy
     // zapewnion¹ obs³ugê podga³êzi, trzeba tylko dodaæ parametry, nazwê i
     // tekst.
     TSpkXMLNode = class(TSpkBaseXMLNode)
     private
     // Nazwa ga³êzi
       FName : string;
     // Tekst ga³êzi
       FText : string;
     // Parametry ga³êzi
       FParameters : TSpkXMLParameters;
     // Rodzaj ga³êzi
       FNodeType : TXMLNodeType;
     protected
     // Setter dla w³asnoœci name (przed i po zmianie nazwy trzeba poinformowaæ
     // parenta, by poprawnie dzia³a³o wyszukiwanie po nazwie
       procedure SetName(Value : string);
     // Getter dla TextAsInteger
       function GetTextAsInteger : integer;
     // Setter dla TextAsInteger
       procedure SetTextAsInteger(value : integer);
     // Getter dla TextAsExtended
       function GetTextAsExtended : extended;
     // Setter dla TextAsExtended
       procedure SetTextAsExtended(value : extended);
     // Getter dla TextAsColor
       function GetTextAsColor : TColor;
     // Setter dla TextAsColor
       procedure SetTextAsColor(value : TColor);
     // Getter dla TextAsBoolean
       function GetTextAsBoolean : boolean;
     // Setter dla TextAsBoolean
       procedure SetTextAsBoolean(value : boolean);
     public
     // Konstruktor
       constructor create(AName : string; ANodeType : TXMLNodeType); reintroduce;
     // Destruktor
       destructor Destroy; override;
     // Czyœci ga³¹Ÿ (tekst, parametry, podga³êzie)
       procedure Clear; override;

       property Name : string read FName write SetName;
       property Text : string read FText write FText;
       property TextAsInteger : integer read GetTextAsInteger write SetTextAsInteger;
       property TextAsExtended : extended read GetTextAsExtended write SetTextAsExtended;
       property TextAsColor : TColor read GetTextAsColor write SetTextAsColor;
       property TextAsBoolean : boolean read GetTextAsBoolean write SetTextAsBoolean;
       property Parameters : TSpkXMLParameters read FParameters;
       property NodeType : TXMLNodeType read FNodeType;
     end;

     // Dziêki temu, ¿e dziedziczymy po TSpkBaseXMLNode, mamy zapewnion¹ obs³ugê
     // podga³êzi
     TSpkXMLParser = class(TSpkBaseXMLNode)
     private
     protected
     public
     // Konstruktor
       constructor create; override;
     // Destruktor
       destructor Destroy; override;
     // Przetwarza tekst z XMLem podany jako parametr
       procedure Parse(input : PChar);
     // Generuje XML na podstawie zawartoœci komponentu
       function Generate(UseFormatting : boolean = true) : string;
     // Wczytuje plik XML z dysku
       procedure LoadFromFile(AFile : string);
     // Zapisuje plik XML na dysk
       procedure SaveToFile(AFile : string; UseFormatting : boolean = true);
     // Wczytuje plik XML ze strumienia
       procedure LoadFromStream(AStream : TStream);
     // Zapisuje plik XML do strumienia
       procedure SaveToStream(AStream : TStream; UseFormatting : boolean = true);
     end;

implementation

{ TBinaryTreeNode }

procedure TBinaryTreeNode.SetLeft(ANode : TBinaryTreeNode);

begin
// Odpinamy poprzedni¹ lew¹ ga³¹Ÿ (o ile istnia³a)
if FLeft<>nil then
   begin
   FLeft.DetachFromParent;
   FLeft:=nil;
   end;

// Przypinamy now¹ ga³¹Ÿ
FLeft:=ANode;

// Aktualizujemy jej parenta
if FLeft<>nil then
   FLeft.AttachToParent(self);

// Odœwie¿amy wysokoœæ poddrzewa
RefreshSubtreeSize;
end;

procedure TBinaryTreeNode.SetRight(ANode : TBinaryTreeNode);

begin
// Odpinamy poprzedni¹ praw¹ ga³¹Ÿ (o ile istnia³a)
if FRight<>nil then
   begin
   FRight.DetachFromParent;
   FRight:=nil;
   end;

// Przypinamy now¹ ga³¹Ÿ
FRight:=ANode;

// Aktualizujemy jej parnenta
if FRight<>nil then
   FRight.AttachToParent(self);

// Odœwie¿amy wysokoœæ poddrzewa
RefreshSubtreeSize;
end;

function TBinaryTreeNode.GetCount : integer;

begin
result:=length(FData);
end;

function TBinaryTreeNode.GetData(index : integer) : TSpkXMLNode;

begin
if (index<0) or (index>high(FData)) then
   raise exception.create('Nieprawid³owy indeks!');

result:=FData[index];
end;

constructor TBinaryTreeNode.create;

begin
inherited create;
FLeft:=nil;
FRight:=nil;
FParent:=nil;
setlength(FData,0);
FSubtreeSize:=0;
end;

destructor TBinaryTreeNode.destroy;

begin
// Odpinamy siê od parenta
if FParent<>nil then
   FParent.DetachChild(self);

// Zwalniamy poddrzewa
if FLeft<>nil then
   FLeft.free;
if FRight<>nil then
   FRight.free;

inherited destroy;
end;

procedure TBinaryTreeNode.RefreshSubtreeSize;

  function LeftSubtreeSize : integer;

  begin
  if FLeft=nil then result:=0 else result:=1+FLeft.SubTreeSize;
  end;

  function RightSubtreeSize : integer;

  begin
  if FRight=nil then result:=0 else result:=1+FRight.SubTreeSize;
  end;

begin
FSubtreeSize:=max(LeftSubtreeSize,RightSubtreeSize);
if Parent<>nil then
   Parent.RefreshSubtreeSize;
end;

procedure TBinaryTreeNode.DetachFromParent;

begin
// Zgodnie z za³o¿eniami, metodê t¹ mo¿e zawo³aæ tylko obecny parent.
FParent:=nil;
end;

procedure TBinaryTreeNode.AttachToParent(AParent : TBinaryTreeNode);

begin
// Zgodnie z za³o¿eniami, t¹ metod¹ wywo³uje nowy parent elementu. Element
// musi zadbaæ o to, by poinformowaæ poprzedniego parenta o tym, ¿e jest on
// odpinany.
if AParent<>FParent then
   begin
   if FParent<>nil then
      FParent.DetachChild(self);

   FParent:=AParent;
   end;
end;

procedure TBinaryTreeNode.DetachChild(AChild : TBinaryTreeNode);

begin
// Zgodnie z za³o¿eniami, metodê t¹ mo¿e wywo³aæ tylko jeden z podelementów
// - lewy lub prawy, podczas zmiany parenta.
if AChild=FLeft then FLeft:=nil;
if AChild=FRight then FRight:=nil;

// Przeliczamy ponownie wysokoœæ poddrzewa
RefreshSubtreeSize;
end;

procedure TBinaryTreeNode.Add(AData : TSpkXMLNode);

begin
{$B-}
if (length(FData)=0) or ((length(FData)>0) and (uppercase(FData[0].Name)=uppercase(AData.Name))) then
   begin
   setlength(FData,length(FData)+1);
   FData[high(FData)]:=AData;
   end else
       raise exception.create('Pojedyncza ga³¹Ÿ przechowuje dane o jednakowych nazwach!');
end;

procedure TBinaryTreeNode.Remove(AData : TSpkXMLNode);

var i : integer;

begin
i:=0;
{$B-}
while (i<=high(FData)) and (FData[i]<>AData) do
      inc(i);

if i<high(FData) then
   self.Delete(i);
end;

procedure TBinaryTreeNode.Delete(index : integer);

var i : integer;

begin
if (index<0) or (index>high(FData)) then
   raise exception.create('Nieprawid³owy indeks.');

if index<high(FData) then
   for i:=index to high(FData)-1 do
       FData[i]:=FData[i+1];

setlength(FData,length(FData)-1);
end;

procedure TBinaryTreeNode.Clear;

begin
setlength(FData,0);
end;

{ TSpkXMLParameter }

constructor TSpkXMLParameter.create;
begin
inherited create;
FName:='';
FValue:='';
end;

constructor TSpkXMLParameter.create(AName, AValue: string);
begin
inherited create;
FName:=AName;
FValue:=AValue;
end;

destructor TSpkXMLParameter.destroy;
begin
inherited destroy;
end;

function TSpkXMLParameter.GetValueAsBoolean: boolean;
begin
if (uppercase(FValue)='TRUE') or (uppercase(FValue)='T') or
   (uppercase(FValue)='YES') or (uppercase(FValue)='Y') then result:=true else
if (uppercase(FValue)='FALSE') or (uppercase(FValue)='F') or
   (uppercase(FValue)='NO') or (uppercase(FValue)='N') then result:=false else
   raise exception.create('Nie mogê przekonwertowaæ wartoœci.');
end;

function TSpkXMLParameter.GetValueAsColor: TColor;

begin
try
result:=StrToInt(FValue);
except
raise exception.create('Nie mogê przekonwertowaæ wartoœci.');
end;
end;

function TSpkXMLParameter.GetValueAsExtended: extended;
begin
try
result:=StrToFloat(FValue);
except
raise exception.create('Nie mogê przekonwertowaæ wartoœci.');
end;
end;

function TSpkXMLParameter.GetValueAsInteger: integer;
begin
try
result:=StrToInt(FValue);
except
raise exception.create('Nie mogê przekonwertowaæ wartoœci.');
end;
end;

procedure TSpkXMLParameter.SetValueAsBoolean(AValue: boolean);
begin
if AValue then FValue:='True' else FValue:='False';
end;

procedure TSpkXMLParameter.SetValueAsColor(AValue: TColor);
begin
FValue:=IntToStr(AValue);
end;

procedure TSpkXMLParameter.SetValueAsExtended(AValue: extended);
begin
FValue:=FloatToStr(AValue);
end;

procedure TSpkXMLParameter.SetValueAsInteger(AValue: integer);
begin
FValue:=IntToStr(AValue);
end;

{ TSpkXMLParameters }

procedure TSpkXMLParameters.Add(AParameter: TSpkXMLParameter);
begin
FList.add(AParameter);
end;

procedure TSpkXMLParameters.Insert(AIndex : integer; AParameter : TSpkXMLParameter);

begin
if (AIndex<0) or (AIndex>FList.count-1) then
   raise exception.create('Nieprawid³owy indeks.');

FList.Insert(AIndex, AParameter);
end;

procedure TSpkXMLParameters.Clear;
begin
FList.clear;
end;

constructor TSpkXMLParameters.create;
begin
inherited create;
FList:=TObjectList.create;
FList.OwnsObjects:=true;
end;

procedure TSpkXMLParameters.Delete(index: integer);
begin
if (index<0) or (index>FList.count-1) then
   raise exception.create('Nieprawid³owy indeks parametru.');

FList.delete(index);
end;

procedure TSpkXMLParameters.Remove(AParameter : TSpkXMLParameter);

begin
FList.Remove(AParameter);
end;

destructor TSpkXMLParameters.destroy;
begin
FList.Free;
inherited destroy;
end;

function TSpkXMLParameters.GetCount: integer;
begin
result:=FList.count;
end;

function TSpkXMLParameters.GetParamByIndex(index: integer): TSpkXMLParameter;
begin
if (index<0) or (index>Flist.count-1) then
   raise exception.create('Nieprawid³owy indeks elementu.');

result:=TSpkXMLParameter(FList[index]);
end;

function TSpkXMLParameters.GetParamByName(index: string;
  autocreate: boolean): TSpkXMLParameter;

var i : integer;
    AParameter : TSpkXMLParameter;

begin
// Szukamy elementu
i:=0;
while (i<=FList.count-1) and (uppercase(TSpkXMLParameter(FList[i]).Name)<>uppercase(index)) do inc(i);

if i<=FList.count-1 then
   result:=TSpkXMLParameter(FList[i]) else
   begin
   if autocreate then
      begin
      AParameter:=TSpkXMLParameter.create(index,'');
      FList.add(AParameter);
      result:=AParameter;
      end else
          result:=nil;
   end;
end;

function TSpkXMLParameters.IndexOf(AParameter: TSpkXMLParameter): integer;
begin
result:=FList.IndexOf(AParameter);
end;

{ TSpkBaseXMLNode }

procedure TSpkBaseXMLNode.TreeAdd(ANode : TSpkXMLNode);

var Tree, Parent : TBinaryTreeNode;

begin
// Szukam miejsca do dodania nowej ga³êzi drzewa
if Ftree=nil then
   begin
   // Nie mamy czego szukaæ, tworzymy korzeñ
   FTree:=TBinaryTreeNode.create;
   FTree.Add(ANode);

   // Nie ma potrzeby balansowania drzewa
   end else
       begin
       Tree:=FTree;
       Parent:=nil;
       {$B-}
       while (Tree<>nil) and (uppercase(Tree.Data[0].Name)<>uppercase(ANode.Name)) do
             begin
             Parent:=Tree;
             if uppercase(ANode.Name)<uppercase(Tree.Data[0].Name) then Tree:=Tree.Left else Tree:=Tree.Right;
             end;

       if Tree<>nil then
          begin
          // Znalaz³em ga³¹Ÿ z takim samym identyfikatorem
          Tree.Add(ANode);

          // Nie ma potrzeby balansowania drzewa, bo faktycznie nie zosta³a
          // dodana ¿adna ga³¹Ÿ
          end else
              begin
              Tree:=TBinaryTreeNode.create;
              Tree.Add(ANode);

              if uppercase(ANode.Name)<uppercase(Parent.Data[0].Name) then
                 Parent.Left:=Tree else
                 Parent.Right:=Tree;

              // Zosta³a dodana nowa ga³¹Ÿ, wiêc balansujemy drzewo (o ile jest
              // taka potrzeba)
              self.Ballance(Tree);
              end;
       end;
end;

procedure TSpkBaseXMLNode.TreeDelete(ANode : TSpkXMLNode);

  procedure InternalTreeDelete(DelNode : TBinaryTreeNode);

  var DelParent : TBinaryTreeNode;
      Successor : TBinaryTreeNode;
      SuccessorParent : TBinaryTreeNode;
      DeletingRoot : boolean;
      i : integer;

  begin
  // Najpierw sprawdzamy, czy bêdziemy usuwaæ korzeñ. Jeœli tak, po usuniêciu
  // mo¿e byæ potrzebna aktualizacja korzenia.
  DeletingRoot:=DelNode=FTree;

  // Kilka przypadków.
  // 0. Mo¿e elementu nie ma w drzewku?
  if DelNode=nil then
     raise exception.create('Takiego elementu nie ma w drzewie AVL!') else
  // 1. Jeœli ga³¹Ÿ ta przechowuje wiêcej ni¿ tylko ten element, to usuwamy go
  //    z listy i koñczymy dzia³anie.
  if DelNode.Count>1 then
     begin
     i:=0;
     while (i<DelNode.Count) and (DelNode.Data[i]<>ANode) do inc(i);

     DelNode.Delete(i);
     end else
  // 2. Jeœli jest to liœæ, po prostu usuwamy go.
  if (DelNode.Left=nil) and (DelNode.Right=nil) then
     begin
     DelParent:=DelNode.Parent;

     // Odpinamy od parenta
     if DelParent<>nil then
        begin
        if DelParent.Left=DelNode then DelParent.Left:=nil;
        if DelParent.Right=DelNode then DelParent.Right:=nil;
        end;

     // Ga³¹Ÿ automatycznie odpina wszystkie swoje podga³êzie, ale zak³adamy
     // tu, ¿e jest to liœæ.
     DelNode.free;

     // Jeœli zachodzi taka potrzeba, balansujemy drzewo od ojca usuwanego
     // elementu
     if DelParent<>nil then
        self.Ballance(DelParent);

     // Jeœli usuwaliœmy root, ustawiamy go na nil (bo by³ to jedyny element)
     if DeletingRoot then FTree:=nil;
     end else
  // 3. Je¿eli element ma tylko jedno dziecko, usuwamy je, poprawiamy powi¹zania
  //    i balansujemy drzewo
  if (DelNode.Left=nil) xor (DelNode.Right=nil) then
     begin
     DelParent:=DelNode.Parent;

     if DelParent=nil then
        begin
        // Usuwamy korzeñ
        if DelNode.Left<>nil then
           begin
           FTree:=DelNode.Left;
           // Mechanizmy drzewa odepn¹ automatycznie ga³¹Ÿ od DelNode, dziêki
           // czemu nie zostanie usuniête ca³e poddrzewo
           end else
        if DelNode.Right<>nil then
           begin
           FTree:=DelNode.Right;
           // Mechanizmy drzewa odepn¹ automatycznie ga³¹Ÿ od DelNode, dziêki
           // czemu nie zostanie usuniête ca³e poddrzewo
           end;

        // Usuwamy element
        DelNode.Free;

        // Nie ma potrzeby balansowaæ drzewa, z za³o¿enie poddrzewo jest
        // zbalansowane.
        end else
     if DelParent<>nil then
        begin
        // Cztery przypadki
        if DelParent.Left=DelNode then
           begin
           if DelNode.Left<>nil then
              begin
              DelParent.Left:=DelNode.Left;
              end else
           if DelNode.Right<>nil then
              begin
              DelParent.Left:=DelNode.Right;
              end;
           end else
        if DelParent.Right=DelNode then
           begin
           if DelNode.Left<>nil then
              begin
              DelParent.Right:=DelNode.Left;
              end else
           if DelNode.Right<>nil then
              begin
              DelParent.Right:=DelNode.Right;
              end;
           end;

        DelNode.Free;

        self.Ballance(DelParent);
        end;
     end else
  // 4. Zamieniamy zawartoœæ "usuwanego" poddrzewa z jego nastêpnikiem, który
  //    ma tylko jedno dziecko, a nastêpnie usuwamy nastêpnik.
  if (DelNode.Left<>nil) and (DelNode.Right<>nil) then
     begin
     // Szukamy nastêpnika
     Successor:=DelNode.Right;
     while Successor.Left<>nil do Successor:=Successor.Left;
     SuccessorParent:=Successor.Parent;

     // Przepinamy dane z nastêpnika do "usuwanego" elementu
     DelNode.Clear;
     if Successor.Count>0 then
        for i:=0 to Successor.Count-1 do
            begin
            DelNode.Add(Successor.Data[i]);
            end;

     // Teraz usuwamy nastêpnik
     InternalTreeDelete(Successor);

     // Odœwie¿amy dane dotycz¹ce poddrzew
     self.Ballance(SuccessorParent);
     end;
  end;

begin
InternalTreeDelete(self.TreeFind(ANode));
end;

function TSpkBaseXMLNode.TreeFind(ANode : TSpkXMLNode) : TBinaryTreeNode;

var Tree : TBinaryTreeNode;
    i : integer;

begin
Tree:=FTree;

while (Tree<>nil) and (uppercase(Tree.Data[0].Name)<>uppercase(ANode.Name)) do
      begin
      if uppercase(ANode.Name)<uppercase(Tree.Data[0].Name) then
         Tree:=Tree.Left else
         Tree:=Tree.Right;
      end;

if Tree<>nil then
   begin
   i:=0;
   {$B-}
   while (i<Tree.Count) and (Tree.Data[i]<>ANode) do inc(i);
   if i=Tree.Count then result:=nil else result:=Tree;
   end else result:=nil;
end;

procedure TSpkBaseXMLNode.Ballance(Leaf : TBinaryTreeNode);

  function CalcLeft(Node : TBinaryTreeNode) : integer;

  begin
  if Node.Left=nil then result:=0 else result:=1+Node.Left.SubtreeSize;
  end;

  function CalcRight(Node : TBinaryTreeNode) : integer;

  begin
  if Node.Right=nil then result:=0 else result:=1+Node.Right.SubtreeSize;
  end;

begin
if Leaf<>nil then
   begin
   while CalcLeft(Leaf)-CalcRight(Leaf)>=2 do
         Leaf:=RotateRight(Leaf);
   while CalcRight(Leaf)-CalcLeft(Leaf)>=2 do
         Leaf:=RotateLeft(Leaf);
   self.Ballance(Leaf.Parent);
   end;
end;

{  RootParent
      \ /                      \ /
       1  Root                  2
      / \                      / \
     A   2  RotNode    ~>     1   C
        / \                  / \
       B   C                A   B
}
function TSpkBaseXMLNode.RotateLeft(Root : TBinaryTreeNode) : TBinaryTreeNode;

var RootParent : TBinaryTreeNode;
    RotNode : TBinaryTreeNode;

begin
result:=nil;
if Root.Right=nil then
   raise exception.create('Prawa podga³¹Ÿ jest pusta!');

RootParent:=Root.Parent;
RotNode:=Root.Right;

if RootParent<>nil then
   begin
   if Root=RootParent.Left then
      begin
      Root.Right:=RotNode.Left;
      RotNode.Left:=Root;
      RootParent.Left:=RotNode;

      result:=RotNode;
      end else
   if Root=RootParent.Right then
      begin
      Root.Right:=RotNode.Left;
      RotNode.Left:=Root;
      RootParent.Right:=RotNode;

      result:=RotNode;
      end;
   end else
if RootParent=nil then
   begin
   // Obracamy korzeñ
   Root.Right:=RotNode.Left;
   RotNode.Left:=Root;
   FTree:=RotNode;

   result:=RotNode;
   end;
end;

{      RootParent
          \ /              \ /
     Root  1                2
          / \              / \
 RotNode 2   C     ~>     A   1
        / \                  / \
       A   B                B   C
}
function TSpkBaseXMLNode.RotateRight(Root : TBinaryTreeNode) : TBinaryTreeNode;

var RootParent : TBinaryTreeNode;
    RotNode : TBinaryTreeNode;

begin
result:=nil;
if Root.Left=nil then
   raise exception.create('Lewa podga³¹Ÿ jest pusta!');

RootParent:=Root.Parent;
RotNode:=Root.Left;

if RootParent<>nil then
   begin
   if Root=RootParent.Left then
      begin
      Root.Left:=RotNode.Right;
      RotNode.Right:=Root;
      RootParent.Left:=RotNode;

      result:=RotNode;
      end else
   if Root=RootParent.Right then
      begin
      Root.Left:=RotNode.Right;
      RotNode.Right:=Root;
      RootParent.Right:=RotNode;

      result:=RotNode;
      end;
   end else
if RootParent=nil then
   begin
   // Obracamy korzeñ
   Root.Left:=RotNode.Right;
   RotNode.Right:=Root;
   FTree:=RotNode;

   result:=RotNode;
   end;
end;

function TSpkBaseXMLNode.GetNodeByIndex(index : integer) : TSpkXMLNode;

begin
if (index<0) or (index>FList.count-1) then
   raise exception.create('Nieprawid³owy indeks!');

result:=TSpkXMLNode(FList[index]);
end;

function TSpkBaseXMLNode.GetNodeByName(index : string; autocreate : boolean) : TSpkXMLNode;

var Tree : TBinaryTreeNode;
    XmlNode : TSpkXMLNode;

begin
Tree:=FTree;
{$B-}
while (Tree<>nil) and (uppercase(Tree.Data[0].Name)<>uppercase(index)) do
      begin
      if uppercase(index)<uppercase(Tree.Data[0].Name) then
         Tree:=Tree.Left else
         Tree:=Tree.Right;
      end;

if Tree<>nil then result:=Tree.Data[0] else
   begin
   if not(autocreate) then
      result:=nil else
      begin
      XmlNode:=TSpkXMLNode.create(index,xntNormal);
      TreeAdd(XmlNode);
      FList.add(XmlNode);
      result:=XmlNode;
      end;
   end;
end;

function TSpkBaseXMLNode.GetCount : integer;

begin
result:=FList.Count;
end;

constructor TSpkBaseXMLNode.create;

begin
inherited create;
FList:=TObjectList.create;
FList.OwnsObjects:=true;
FTree:=nil;
FParent:=nil;
end;

destructor TSpkBaseXMLNode.destroy;

begin
// Drzewko zadba o rekurencyjne wyczyszczenie
FTree.free;

// Lista zadba o zwolnienie podga³êzi
FList.free;

inherited destroy;
end;

procedure TSpkBaseXMLNode.Add(ANode : TSpkXMLNode);

begin
if ANode = self then
   raise exception.create('Nie mogê dodaæ siebie do w³asnej listy!');
if ANode.NodeType=xntNormal then
   TreeAdd(ANode);
FList.add(ANode);
ANode.Parent:=self;
end;

procedure TSpkBaseXMLNode.Insert(AIndex : integer; ANode : TSpkXMLNode);

begin
if (AIndex<0) or (AIndex>FList.count-1) then
   raise exception.create('Nieprawid³owy indeks!');

FList.Insert(AIndex, ANode);
TreeAdd(ANode);
ANode.Parent:=self;
end;

procedure TSpkBaseXMLNode.Delete(AIndex : integer);

begin
if (AIndex<0) or (AIndex>FList.count-1) then
   raise exception.create('Nieprawid³owy indeks!');

TreeDelete(TSpkXMLNode(FList[AIndex]));

// Poniewa¿ FList.OwnsObjects, automatycznie zwolni usuwany element.
FList.delete(AIndex);
end;

procedure TSpkBaseXMLNode.Remove(ANode : TSpkXMLNode);

begin
TreeDelete(ANode);

// Poniewa¿ FList.OwnsObjects, automatycznie zwolni usuwany element.
FList.Remove(ANode);
end;

function TSpkBaseXMLNode.IndexOf(ANode : TSpkXMLNode) : integer;

begin
result:=FList.IndexOf(ANode);
end;

procedure TSpkBaseXMLNode.Clear;

begin
FTree.Free;
FTree:=nil;

// Poniewa¿ FList.OwnsObjects, automatycznie zwolni usuwany element.
FList.clear;
end;

procedure TSpkBaseXMLNode.BeforeChildChangeName(AChild : TSpkXmlNode);

begin
TreeDelete(AChild);
end;

procedure TSpkBaseXMLNode.AfterChildChangeName(AChild : TSpkXMLNode);

begin
TreeAdd(AChild);
end;

{ TSpkXMLNode }

procedure TSpkXMLNode.SetName(Value : string);

begin
if Parent<>nil then
   Parent.BeforeChildChangeName(self);

FName:=Value;

if Parent<>nil then
   Parent.AfterChildChangeName(self);
end;

function TSpkXMLNode.GetTextAsInteger : integer;

begin
try
result:=StrToInt(FText);
except
raise exception.create('Nie mogê przekonwertowaæ wartoœci.');
end;
end;

procedure TSpkXMLNode.SetTextAsInteger(value : integer);

begin
FText:=IntToStr(value);
end;

function TSpkXMLNode.GetTextAsExtended : extended;

begin
try
result:=StrToFloat(FText);
except
raise exception.create('Nie mogê przekonwertowaæ wartoœci.');
end;
end;

procedure TSpkXMLNode.SetTextAsExtended(value : extended);

begin
FText:=FloatToStr(value);
end;

function TSpkXMLNode.GetTextAsColor : TColor;

begin
try
result:=StrToInt(FText);
except
raise exception.create('Nie mogê przekonwertowaæ wartoœci.');
end;
end;

procedure TSpkXMLNode.SetTextAsColor(value : TColor);

begin
FText:=IntToStr(value);
end;

function TSpkXMLNode.GetTextAsBoolean : boolean;

begin
if (uppercase(FText)='TRUE') or (uppercase(FText)='T') or
   (uppercase(FText)='YES') or (uppercase(FText)='Y') then result:=true else
if (uppercase(FText)='FALSE') or (uppercase(FText)='F') or
   (uppercase(FText)='NO') or (uppercase(FText)='N') then result:=false else
   raise exception.create('Nie mogê przekonwertowaæ wartoœci.');
end;

procedure TSpkXMLNode.SetTextAsBoolean(value : boolean);

begin
if value then FText:='True' else FText:='False';
end;

constructor TSpkXMLNode.create(AName : string; ANodeType : TXMLNodeType);

begin
inherited create;
FName:=AName;
FText:='';
FNodeType:=ANodeType;
FParameters:=TSpkXMLParameters.create;
end;

destructor TSpkXMLNode.destroy;

begin
FParameters.free;
inherited destroy;
end;

procedure TSpkXMLNode.Clear;

begin
inherited Clear;
FParameters.Clear;
FText:='';
end;

{ TSpkXMLParser }

constructor TSpkXMLParser.create;

begin
inherited create;
end;

destructor TSpkXMLParser.destroy;

begin
inherited destroy;
end;

procedure TSpkXMLParser.Parse(input : PChar);

type // Operacja, któr¹ aktualnie wykonuje parser.
     TParseOperation = (poNodes,           //< Przetwarzanie (pod)ga³êzi
                        poTagInterior,     //< Przetwarzanie wnêtrza zwyk³ego tagu (< > lub < />)
                        poTagText,         //< Tekst taga, który przetwarzamy
                        poControlInterior, //< Przetwarzanie kontrolnego taga (<? ?>)
                        poCommentInterior, //< Przetwarzanie komentarza (<!-- -->)
                        poClosingInterior  //< Przetwarzanie taga domykaj¹cego.
                       );

var // Stos przetwarzanych ga³êzi (niejawna rekurencja)
    NodeStack : TObjectStack;
    // Aktualna operacja. Podczas wychodzenia z operacji przetwarzaj¹cych
    // tagi, domyœlnymi operacjami s¹ poSubNodes b¹dŸ poOuter.
    CurrentOperation : TParseOperation;
    // WskaŸnik na pocz¹tek tokena
    TokenStart : PChar;
    // Przetwarzana ga³¹Ÿ XMLa
    Node : TSpkXMLNode;
    // Pomocnicze ci¹gi znaków
    s,s1 : string;
    // Pozycja w pliku - linia i znak
    ParseLine, ParseChar : integer;

  // Funkcja inkrementuje wskaŸnik wejœcia, pilnuj¹c jednoczeœnie, by uaktualniæ
  // pozycjê w pliku
  procedure increment(var input : PChar; count : integer = 1);

  var i : integer;

  begin
  for i:=1 to count do
      begin
      if input^=#10 then
         begin
         inc(ParseLine);
         ParseChar:=1;
         end else
      if input^<>#13 then
         begin
         inc(ParseChar);
         end;
      inc(input);
      end;
  end;

  // Funkcja przetwarza tekst (wraz z <![CDATA[ ... ]]>) a¿ do napotkanego
  // delimitera. Dodatkowo zamienia encje na zwyk³e znaki.
  // Niestety, natura poni¿szej funkcji powoduje, ¿e muszê doklejaæ znaki
  // do ci¹gu, trac¹c na wydajnoœci.
  // DoTrim powoduje, ¿e wycinane s¹ pocz¹tkowe i koñcowe bia³e znaki (chyba,
  // ¿e zosta³y wpisane jako encje albo w sekcji CDATA)
  function ParseText(var input : PChar; TextDelimiter : char; DoTrim : boolean = false) : string;

  var Finish : boolean;
      Entity : string;
      i : integer;
      WhiteChars : string;

    // Funkcja robi dok³adnie to, na co wygl¹da ;]
    function HexToInt(s : string) : integer;

    var i : integer;

    begin
    result:=0;
    for i:=1 to length(s) do
        begin
        result:=result*16;
        if s[i] in ['0'..'9'] then result:=result+ord(s[i])-ord('0') else
           if UpCase(s[i]) in ['A'..'F'] then result:=result+ord(s[i])-ord('A')+10 else
              raise exception.create('Nieprawid³owa liczba heksadecymalna!');
        end;
    end;

  begin
  result:='';

  // Wycinamy pocz¹tkowe bia³e znaki
  if DoTrim then
     while input^ in [#32,#9,#13,#10] do increment(input);

  while (input^<>TextDelimiter) or ((input^='<') and (StrLComp(input,'<![CDATA[',9)=0)) do
        begin
        {$B-}

        // Nie mo¿e wyst¹piæ tu koniec pliku
        if input^=#0 then
           raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku.') else

        // Jeœli napotkaliœmy nawias k¹towy, mo¿e to byæ sekcja CDATA
        if (input^='<') and (StrLComp(input,'<![CDATA[',9)=0) then
           begin
           // Wczytujemy blok CDATA a¿ do znacznika zamkniêcia "]]>"
           // Pomijamy tag rozpoczynaj¹cy CDATA
           increment(input,9);

           Finish:=false;
           repeat
           {$B-}
           if input^=#0 then
              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku.');
           if (input^=']') and (StrLComp(input,']]>',3)=0) then Finish:=true else
              begin
              result:=result+input^;
              increment(input);
              end;
           until Finish;

           // Pomijamy tag zamykaj¹cy CDATA
           increment(input,3);
           end else

        // Obs³uga encji - np. &nbsp;
        if input^='&' then
           begin
           // Encja
           // Pomijamy znak ampersanda
           increment(input);

           Entity:='';
           while input^<>';' do
                 begin
                 if input^=#0 then
                    raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku - nie dokoñczona encja.');
                 Entity:=Entity+input^;
                 increment(input);
                 end;

           // Pomijamy znak œrednika
           increment(input);

           // Analizujemy encjê
           Entity:=uppercase(entity);
           if Entity='AMP' then result:=result+'&' else
           if Entity='LT' then result:=result+'<' else
           if Entity='GT' then result:=result+'>' else
           if Entity='QUOT' then result:=result+'"' else
           if Entity='NBSP' then result:=result+' ' else
           if copy(Entity,1,2)='#x' then
              begin
              // Kod ASCII zapisany heksadecymalnie
              i:=HexToInt(copy(Entity,2,length(Entity)-1));
              if not(i in [0..255]) then
                 raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owa wartoœæ heksadecymalna encji (dopuszczalne: 0..255)');
              result:=result+chr(i);
              end else
           if Entity[1]='#' then
              begin
              i:=StrToInt(copy(Entity,2,length(Entity)-1));
              if not(i in [0..255]) then
                 raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owa wartoœæ dziesiêtna encji (dopuszczalne: 0..255)');
              result:=result+chr(i);
              end else
                  raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owa (nie obs³ugiwana) encja!');
           end else
        if (DoTrim) and (input^ in [#32,#9,#10,#13]) then
           begin
           // Zbieramy bia³e znaki a¿ do pierwszego niebia³ego; je¿eli bêdzie
           // nim delimiter, bia³a sekwencja zostanie pominiêta.
           WhiteChars:='';
           repeat
           WhiteChars:=input^;
           increment(input);
           until not(input^ in [#32,#9,#10,#13]);

           // Sprawdzamy, czy dodaæ sekwencjê bia³ych znaków (ostro¿nie z CDATA!)
           if (input^<>TextDelimiter) or ((input^='<') and (StrLComp(input,'<![CDATA[',9)=0)) then
              result:=result+WhiteChars;
           end else
        // Zwyk³y znak (nie bêd¹cy delimiterem!)
        if input^<>TextDelimiter then
           begin
           result:=result+input^;
           increment(input);
           end;
        end;
  end;

begin
// Czyœcimy wszystkie ga³êzie
self.Clear;

// Na wszelki wypadek...
if input^=#0 then exit;

// Zerujemy parsowan¹ pozycjê
ParseLine:=1;
ParseChar:=1;

// Inicjujemy stos ga³êzi
NodeStack:=TObjectStack.Create;
CurrentOperation:=poNodes;

try

  while input^<>#0 do
  case CurrentOperation of
       poNodes : begin
                 // Pomijamy bia³e znaki
                 while input^ in [#32,#9,#10,#13] do increment(input);

                 // Wejœcie mo¿e siê tu koñczyæ tylko wtedy, gdy jesteœmy
                 // maksymalnie na zewn¹trz
                 if (input^=#0) and (NodeStack.count>0) then
                    raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku.');

                 if (input^<>#0) and (input^<>'<') then
                    raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owy znak podczas przetwarzania pliku.');

                 if input^<>#0 then
                    if StrLComp(input,'<?',2)=0 then
                       CurrentOperation:=poControlInterior else
                    if StrLComp(input,'<!--',4)=0 then
                       CurrentOperation:=poCommentInterior else
                    if StrLComp(input,'</',2)=0 then
                       CurrentOperation:=poClosingInterior else
                    if StrLComp(input,'<',1)=0 then
                       CurrentOperation:=poTagInterior else
                       raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owy znak podczas przetwarzania pliku.');
                 end;

       poTagInterior,
       poControlInterior : begin
                           Node:=nil;
                           try

                           if CurrentOperation=poTagInterior then
                              begin
                              Node:=TSpkXMLNode.create('',xntNormal);

                              // Pomijamy znak otwarcia taga
                              increment(input);
                              end else
                                  begin
                                  Node:=TSpkXMLNode.create('',xntControl);

                                  // Pomijamy znaki otwarcia taga
                                  increment(input,2);
                                  end;

                           // Plik nie mo¿e siê tu koñczyæ
                           if input^=#0 then
                              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku!');

                           // Oczekujemy nazwy taga, która jest postaci
                           // [a-zA-Z]([a-zA-Z0-9_]|([\-:][a-zA-Z0-9_]))*
                           if not(input^ in ['a'..'z','A'..'Z']) then
                              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owa nazwa taga!');

                           TokenStart:=input;
                           repeat
                           increment(input);
                           if input^ in ['-',':'] then
                              begin
                              increment(input);
                              if not(input^ in ['a'..'z','A'..'Z','0'..'9','_']) then
                                 raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owa nazwa taga!');
                              increment(input);
                              end;
                           until not(input^ in ['a'..'z','A'..'Z','0'..'9','_']);

                           setlength(s,integer(input)-integer(TokenStart));
                           StrLCopy(PChar(s),TokenStart,integer(input)-integer(TokenStart));
                           Node.Name:=s;

                           // Plik nie mo¿e siê tu koñczyæ.
                           if input^=#0 then
                              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku!');

                           // Teraz bêdziemy wczytywaæ parametry (o ile takowe s¹).
                           repeat
                           // Wymagamy bia³ego znaku przed ka¿dym parametrem.
                           if input^ in [#32,#9,#10,#13] then
                              begin
                              // Zjadamy bia³e znaki
                              while input^ in [#32,#9,#10,#13] do increment(input);

                              // Plik nie mo¿e siê tu koñczyæ.
                              if input^=#0 then
                                 raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku!');

                              // Je¿eli po bia³ych znakach jest litera,
                              // zaczynamy wczytywaæ parametr
                              if input^ in ['a'..'z','A'..'Z'] then
                                 begin
                                 // Przetwarzamy parametr
                                 TokenStart:=input;

                                 repeat
                                 increment(input)
                                 until not(input^ in ['a'..'z','A'..'Z','0'..'9','_']);

                                 setlength(s,integer(input)-integer(TokenStart));
                                 StrLCopy(PChar(s),TokenStart,integer(input)-integer(TokenStart));

                                 // Pomijamy bia³e znaki
                                 while input^ in [#32,#9,#13,#10] do increment(input);

                                 // Plik nie mo¿e siê tu koñczyæ
                                 if input^=#0 then
                                    raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku!');

                                 // Oczekujemy znaku '='
                                 if input^<>'=' then
                                    raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Oczekiwany znak równoœci (prawdopodobnie nieprawid³owa nazwa parametru)');

                                 increment(input);

                                 // Pomijamy bia³e znaki
                                 while input^ in [#32,#9,#13,#10] do increment(input);

                                 // Plik nie mo¿e siê tu koñczyæ
                                 if input^=#0 then
                                    raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku!');

                                 // Oczekujemy ' lub "
                                 if input^='''' then
                                    begin
                                    // Pomijamy znak apostrofu
                                    increment(input);
                                    s1:=ParseText(input,'''',false);
                                    // Pomijamy koñcz¹cy znak apostrofu
                                    increment(input);
                                    end else
                                 if input^='"' then
                                    begin
                                    // Pomijamy znak cudzys³owu
                                    increment(input);
                                    s1:=ParseText(input,'"',false);
                                    // Pomijamy koñcz¹cy znak cudzys³owu
                                    increment(input);
                                    end else
                                    raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owy znak, oczekiwano '' lub "');

                                 // Dodajemy parametr o nazwie s i zawartoœci s1
                                 Node.Parameters[s,true].Value:=s1;
                                 end;
                              end;

                           // Pêtla koñczy siê, gdy na wejœciu nie ma ju¿
                           // bia³ego znaku, który jest wymagany przed i
                           // pomiêdzy parametrami. Sekwencja bia³ych znaków
                           // po ostatnim parametrze zostanie pominiêta wewn¹trz
                           // pêtli.
                           until not(input^ in [#32,#9,#10,#13]);

                           // Plik nie mo¿e siê tu koñczyæ.
                           if input^=#0 then
                              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku!');

                           if CurrentOperation=poControlInterior then
                              begin
                              if StrLComp(input,'?>',2)<>0 then
                                 raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owe domkniêcie taga kontrolnego (powinno byæ: ?>)');

                              // Pomijamy znaki zamkniêcia taga kontrolnego
                              increment(input,2);

                              if NodeStack.count>0 then
                                 TSpkXMLNode(NodeStack.Peek).Add(Node) else
                                 Self.Add(Node);

                              CurrentOperation:=poNodes;
                              end else
                           if CurrentOperation=poTagInterior then
                              begin
                              if StrLComp(input,'/>',2)=0 then
                                 begin
                                 // Pomijamy znaki zamkniêcia taga
                                 increment(input,2);

                                 if NodeStack.count>0 then
                                    TSpkXMLNode(NodeStack.Peek).add(Node) else
                                    Self.add(Node);

                                 CurrentOperation:=poNodes;
                                 end else
                              if StrLComp(input,'>',1)=0 then
                                 begin
                                 // Pomijamy znak zamkniêcia taga
                                 increment(input);

                                 NodeStack.Push(Node);

                                 CurrentOperation:=poTagText;
                                 end else
                                     raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owe domkniêcie taga XML (powinno byæ: > lub />)');
                              end;

                           except
                           // Jeœli coœ pójdzie nie tak, ga³¹Ÿ wisi w pamiêci i
                           // nie jest wrzucona na stos, trzeba j¹ zwolniæ.

                           // Notatka jest taka, ¿e wszystkie wyj¹tki, które
                           // mog¹ siê pojawiæ, s¹ *przed* wrzuceniem taga na
                           // stos lub do ga³êzi na szczycie stosu.
                           if Node<>nil then Node.Free;
                           raise;
                           end;

                           end;

       poCommentInterior : begin
                           Node:=nil;

                           try

                           Node:=TSpkXMLNode.create('',xntComment);

                           // Pomijamy znaki otwarcia taga
                           increment(input,4);

                           // Wczytujemy komentarz
                           TokenStart:=input;
                           repeat
                             repeat
                             increment(input);
                             if input^=#0 then
                                raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku!');
                             until input^='-';
                           until StrLComp(input,'-->',3)=0;

                           setlength(s,integer(input)-integer(TokenStart));
                           StrLCopy(PChar(s),TokenStart,integer(input)-integer(TokenStart));
                           Node.Text:=s;

                           // Pomijamy znaki zakoñczenia komentarza
                           increment(input,3);

                           if NodeStack.count>0 then
                              TSpkXMLNode(NodeStack.Peek).add(Node) else
                              Self.add(Node);

                           except
                           // Zarz¹dzanie pamiêci¹ - zobacz poprzedni przypadek
                           if Node<>nil then Node.free;
                           raise
                           end;

                           CurrentOperation:=poNodes;
                           end;

       poClosingInterior : begin
                           // Pomijamy znaki otwieraj¹ce zamykaj¹cy tag
                           increment(input,2);

                           // Plik nie mo¿e siê tu koñczyæ
                           if input^=#0 then
                              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku!');

                           // Wczytujemy nazwê zamykanego taga postaci
                           // [a-zA-Z]([a-zA-Z0-9_]|([\-:][a-zA-Z0-9_]))*
                           if not(input^ in ['a'..'z','A'..'Z']) then
                              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owa nazwa taga!');

                           TokenStart:=input;
                           repeat
                           increment(input);
                           if input^ in ['-',':'] then
                              begin
                              increment(input);
                              if not(input^ in ['a'..'z','A'..'Z','0'..'9','_']) then
                                 raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieprawid³owa nazwa taga!');
                              increment(input);
                              end;
                           until not(input^ in ['a'..'z','A'..'Z','0'..'9','_']);

                           setlength(s,integer(input)-integer(TokenStart));
                           StrLCopy(PChar(s),TokenStart,integer(input)-integer(TokenStart));

                           // Pomijamy zbêdne znaki bia³e
                           while input^ in [#32,#9,#10,#13] do increment(input);

                           // Plik nie mo¿e siê tu koñczyæ
                           if input^=#0 then
                              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku!');

                           // Oczekujemy znaku '>'
                           if input^<>'>' then
                              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Oczekiwany znak zamkniêcia taga (>)');

                           // Pomijamy znak zamkniêcia taga
                           increment(input);

                           // Sprawdzamy, czy uppercase nazwa taga na stosie i
                           // wczytana pasuj¹ do siebie
                           if NodeStack.Count=0 then
                              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Brakuje taga otwieraj¹cego do zamykaj¹cego!');

                           if uppercase(s)<>uppercase(TSpkXMLNode(NodeStack.Peek).Name) then
                              raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Tag zamykaj¹cy ('+s+') nie pasuje do taga otwieraj¹cego ('+TSpkXMLNode(NodeStack.Peek).Name+') !');

                           // Wszystko OK, zdejmujemy tag ze stosu i dodajemy go do taga pod nim
                           Node:=TSpkXMLNode(NodeStack.Pop);

                           if NodeStack.count>0 then
                              TSpkXMLNode(NodeStack.Peek).add(Node) else
                              Self.add(Node);

                           CurrentOperation:=poNodes;
                           end;

       poTagText : begin
                   // Wczytujemy tekst i przypisujemy go do taga znajduj¹cego
                   // siê na szczycie stosu
                   s:=ParseText(input,'<',true);

                   if NodeStack.Count=0 then
                      raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Tekst mo¿e wystêpowaæ tylko wewn¹trz tagów!');

                   TSpkXMLNode(NodeStack.Peek).Text:=s;

                   CurrentOperation:=poNodes;
                   end;
  end;

  // Jeœli na stosie pozosta³y jakieœ ga³êzie - oznacza to b³¹d (nie zosta³y
  // domkniête)

  if NodeStack.Count>0 then
     raise exception.create('B³¹d w sk³adni XML (linia '+IntToStr(ParseLine)+', znak '+IntToStr(ParseChar)+') : Nieoczekiwany koniec pliku (istniej¹ nie domkniête tagi, pierwszy z nich: '+TSpkXMLNode(NodeStack.Peek).Name+')');

  // Wszystko w porz¹dku, XML zosta³ wczytany.
finally

  // Czyœcimy nie przetworzone ga³êzie
  while NodeStack.Count>0 do
        NodeStack.Pop.Free;
  NodeStack.Free;

end;

end;

function TSpkXMLParser.Generate(UseFormatting : boolean) : string;

  function InternalGenerate(RootNode : TSpkXMLNode; indent : integer; UseFormatting : boolean) : string;

  var i : integer;

    function MkIndent(i : integer) : string;

    begin
    result:='';
    if indent<=0 then exit;
    setlength(result,i);
    if i>0 then
       FillChar(result[1],i,32);
    end;

    function MkText(AText : string; CheckWhitespace : boolean = false) : string;

    var s : string;
        prefix,postfix : string;

    begin
    s:=AText;
    s:=StringReplace(s,'&','&amp;',[rfReplaceAll]);
    s:=StringReplace(s,'<','&lt;',[rfReplaceAll]);
    s:=StringReplace(s,'>','&gt;',[rfReplaceAll]);
    s:=StringReplace(s,'"','&quot;',[rfReplaceAll]);
    s:=StringReplace(s,'''','&#39;',[rfReplaceAll]);

    prefix:='';
    postfix:='';

    if CheckWhitespace then
       begin
       // Jeœli pierwszy znak jest bia³y, zamieñ go na encjê
       if s[1]=#32 then
          begin
          System.delete(s,1,1);
          prefix:='&#32;';
          end else
       if s[1]=#9 then
          begin
          System.delete(s,1,1);
          prefix:='&#9;';
          end else
       if s[1]=#10 then
          begin
          System.delete(s,1,1);
          prefix:='&#10;';
          {$B-}
          if (length(s)>0) and (s[1]=#13) then
             begin
             System.delete(s,1,1);
             prefix:=prefix+'&#13;';
             end;
          end else
       if s[1]=#13 then
          begin
          System.delete(s,1,1);
          prefix:='&#13;';
          {$B-}
          if (length(s)>0) and (s[1]=#10) then
             begin
             System.delete(s,1,1);
             prefix:=prefix+'&#10;';
             end;
          end;

       // Jeœli ostatni znak jest bia³y, zamieñ go na encjê
       if length(s)>0 then
          begin
          if s[length(s)]=#32 then
             begin
             System.delete(s,length(s),1);
             postfix:='&#32;';
             end else
          if s[length(s)]=#9 then
             begin
             System.delete(s,length(s),1);
             postfix:='&#32;';
             end else
          if s[length(s)]=#10 then
             begin
             System.Delete(s,length(s),1);
             postfix:='&#10;';
             if (length(s)>0) and (s[length(s)]=#13) then
                begin
                System.Delete(s,length(s),1);
                postfix:='&#13;'+postfix;
                end;
             end else
          if s[length(s)]=#13 then
             begin
             System.Delete(s,length(s),1);
             postfix:='&#13;';
             if (length(s)>0) and (s[length(s)]=#10) then
                begin
                System.Delete(s,length(s),1);
                postfix:='&#10;'+postfix;
                end;
             end;
          end;
       end;
    result:=prefix+s+postfix;
    end;

  begin
  result:='';
  if RootNode=nil then
     begin
     if FList.count>0 then
        for i:=0 to FList.count-1 do
            result:=result+InternalGenerate(TSpkXMLNode(FList[i]),0,UseFormatting);
     end else
         begin
         // Generowanie XMLa dla pojedynczej ga³êzi
         case RootNode.NodeType of
              xntNormal : begin
                          if UseFormatting then
                             result:=MkIndent(indent)+'<'+RootNode.name else
                             result:='<'+RootNode.name;

                          if RootNode.Parameters.count>0 then
                              for i:=0 to RootNode.Parameters.count-1 do
                                  result:=result+' '+RootNode.Parameters.ParamByIndex[i].name+'="'+MkText(RootNode.Parameters.ParamByIndex[i].value,false)+'"';

                          if (RootNode.Count=0) and (RootNode.Text='') then
                             begin
                             if UseFormatting then
                                result:=result+'/>'+CRLF else
                                result:=result+'/>';
                             end else
                          if (RootNode.Count=0) and (RootNode.Text<>'') then
                             begin
                             result:=result+'>';
                             result:=result+MkText(RootNode.Text,true);
                             if UseFormatting then
                                result:=result+'</'+RootNode.Name+'>'+CRLF else
                                result:=result+'</'+RootNode.Name+'>';
                             end else
                          if (RootNode.Count>0) and (RootNode.Text='') then
                             begin
                             if UseFormatting then
                                result:=result+'>'+CRLF else
                                result:=result+'>';
                             for i:=0 to RootNode.count-1 do
                                 result:=result+InternalGenerate(RootNode.NodeByIndex[i],indent+2,UseFormatting);

                             if UseFormatting then
                                result:=result+MkIndent(indent)+'</'+RootNode.name+'>'+CRLF else
                                result:=result+'</'+RootNode.name+'>';
                             end else
                          if (RootNode.Count>0) and (RootNode.Text<>'') then
                             begin
                             result:=result+'>';
                             if UseFormatting then
                                result:=result+MkText(RootNode.Text,true)+CRLF else
                                result:=result+MkText(RootNode.Text,true);

                             for i:=0 to RootNode.count-1 do
                                 result:=result+InternalGenerate(RootNode.NodeByIndex[i],indent+2,UseFormatting);

                             if UseFormatting then
                                result:=result+MkIndent(indent)+'</'+RootNode.Name+'>'+CRLF else
                                result:=result+'</'+RootNode.Name+'>';
                             end;
                          end;
              xntControl : begin
                           if UseFormatting then
                              result:=MkIndent(indent)+'<?'+RootNode.Name else
                              result:='<?'+RootNode.Name;
                           if RootNode.Parameters.count>0 then
                              for i:=0 to RootNode.Parameters.count-1 do
                                  result:=result+' '+RootNode.Parameters.ParamByIndex[i].name+'="'+MkText(RootNode.Parameters.ParamByIndex[i].value,false)+'"';

                           if UseFormatting then
                              result:=result+'?>'+CRLF else
                              result:=result+'?>';
                           end;
              xntComment : begin
                           if UseFormatting then
                              result:=MkIndent(indent)+'<!--'+RootNode.text+'-->'+CRLF else
                              result:='<!--'+RootNode.text+'-->';
                           end;
         end;
         end;
  end;

begin
result:=InternalGenerate(nil,0,UseFormatting);
end;

procedure TSpkXMLParser.LoadFromFile(AFile : string);

var sl : TStringList;

begin
sl:=nil;
try
sl:=TStringList.create;
sl.LoadFromFile(AFile);

if length(sl.text)>0 then
   self.Parse(PChar(sl.text));

finally
if sl<>nil then sl.free;
end;
end;

procedure TSpkXMLParser.SaveToFile(AFile : string; UseFormatting : boolean);

var sl : TStringList;

begin
sl:=nil;
try
sl:=TStringList.create;

sl.text:=self.Generate(UseFormatting);

sl.savetofile(AFile);

finally
if sl<>nil then sl.free;
end;
end;

procedure TSpkXMLParser.LoadFromStream(AStream : TStream);

var sl : TStringList;

begin
sl:=nil;
try
sl:=TStringList.create;
sl.LoadFromStream(AStream);

self.Parse(PChar(sl.text));

finally
if sl<>nil then sl.free;
end;
end;

procedure TSpkXMLParser.SaveToStream(AStream : TStream; UseFormatting : boolean);

var sl : TStringList;

begin
sl:=nil;
try
sl:=TStringList.create;

sl.text:=self.Generate(UseFormatting);

sl.savetostream(AStream);

finally
if sl<>nil then sl.free;
end;
end;

end.
