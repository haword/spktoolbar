unit SpkXMLTools;

{$H+}

interface

uses
  FMX.Graphics, SysUtils, SpkXMLParser, System.UITypes;

type
  TSpkXMLTools = class
  private
  protected
  public
    class procedure Save(Node: TSpkXMLNode; Font: TFont); overload;
    class procedure Load(Node: TSpkXMLNode; Font: TFont); overload;
  end;

implementation

{ TXMLTools }

class procedure TSpkXMLTools.Load(Node: TSpkXMLNode; Font: TFont);
var
  Subnode, Subnode2: TSpkXMLNode;
begin
  if not (assigned(Node)) then
    raise exception.create('TSpkXMLTools.Load: Nieprawid³owa ga³¹Ÿ XML!');
  if not (assigned(Font)) then
    raise exception.create('TSpkXMLTools.Load: Brak obiektu czcionki do wczytania!');

  Subnode := Node['Charset', false];

//  if assigned(Subnode) then
//    Font.Charset := TFontCharset(Subnode.TextAsInteger);

  Subnode := Node['Color', false];

//  if assigned(Subnode) then
//    Font.Color := Subnode.TextAsInteger;

  Subnode := Node['Name', false];
  if assigned(Subnode) then
    Font.Family := Subnode.Text;

  Subnode := Node['Orientation', false];
//if assigned(Subnode) then
//   Font.Orientation:=Subnode.TextAsInteger;

  Subnode := Node['Pitch', false];
//  if assigned(Subnode) then
//    Font.Pitch := TFontPitch(Subnode.TextAsInteger);

  Subnode := Node['Size', false];
  if assigned(Subnode) then
    Font.Size := Subnode.TextAsInteger;

  Subnode := Node['Style', false];
  if assigned(Subnode) then
  begin
    Subnode2 := Subnode['Bold', false];
    if assigned(Subnode2) then
      if Subnode2.TextAsBoolean then
        Font.Style := Font.Style + [TFontStyle.fsBold]
      else
        Font.Style := Font.Style - [TFontStyle.fsBold];

    Subnode2 := Subnode['Italic', false];
    if assigned(Subnode2) then
      if Subnode2.TextAsBoolean then
        Font.Style := Font.Style + [TFontStyle.fsItalic]
      else
        Font.Style := Font.Style - [TFontStyle.fsItalic];

    Subnode2 := Subnode['Underline', false];
    if assigned(Subnode2) then
      if Subnode2.TextAsBoolean then
        Font.Style := Font.Style + [TFontStyle.fsUnderline]
      else
        Font.Style := Font.Style - [TFontStyle.fsUnderline];
  end;
end;

class procedure TSpkXMLTools.Save(Node: TSpkXMLNode; Font: TFont);
var
  Subnode, Subnode2: TSpkXMLNode;
begin
  if not (assigned(Node)) then
    raise exception.create('TSpkXMLTools.Save: Nieprawid³owa ga³¹Ÿ XML!');
  if not (assigned(Font)) then
    raise exception.create('TSpkXMLTools.Save: Brak obiektu czcionki do zapisania!');

//  Subnode := Node['Charset', true];
//  Subnode.TextAsInteger := Font.Charset;

//  Subnode := Node['Color', true];
//  Subnode.TextAsInteger := Font.Color;

  Subnode := Node['Name', true];
  Subnode.Text := Font.Family;

  Subnode := Node['Orientation', true];
//Subnode.TextAsInteger:=Font.Orientation;

//  Subnode := Node['Pitch', true];
//  Subnode.TextAsInteger := ord(Font.Pitch);

  Subnode := Node['Size', true];
  Subnode.TextAsInteger := Round(Font.Size);

  Subnode := Node['Style', true];
  Subnode2 := Subnode['Bold', true];
  Subnode2.TextAsBoolean := TFontStyle.fsBold in Font.Style;

  Subnode2 := Subnode['Italic', true];
  Subnode2.TextAsBoolean := TFontStyle.fsItalic in Font.Style;

  Subnode2 := Subnode['Underline', true];
  Subnode2.TextAsBoolean := TFontStyle.fsUnderline in Font.Style;
end;

end.

