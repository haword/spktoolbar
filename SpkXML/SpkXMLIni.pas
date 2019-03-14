unit SpkXMLIni;

{.$mode ObjFpc}
{$H+}

{$DEFINE SPKXMLINI}

interface

uses SpkXMLParser, classes, sysutils;

type TSpkXMLIni = class(TObject)
     private
       FParser : TSpkXMLParser;
       FAutoConvert : boolean;
     protected
     public
       constructor Create; overload;
       constructor Create(filename : string); overload;
       destructor Destroy; override;
       procedure LoadFromFile(filename : string);
       procedure SaveToFile(filename : string);
       procedure SaveToStream(AStream : TStream);
       procedure LoadFromStream(AStream : TStream);
       procedure Clear;
       procedure DeleteKey(const Section, Ident: string);
       procedure EraseSection(const Section: string);
       function ReadString(const Section, Ident, Default: string): string;
       procedure WriteString(const Section, Ident, Value: string);
       function ReadBool (const Section, Ident: String; Default: Boolean): Boolean;
       function ReadDate (const Section, Ident: string; Default: TDateTime): TDateTime;
       function ReadDateTime (const Section, Ident: String; Default: TDateTime): TDateTime;
       function ReadFloat (const Section, Ident: String; Default: Double): Double;
       function ReadInteger(const Section, Ident: String; Default: Longint): Longint;
       function ReadTime (const Section, Ident: String; Default: TDateTime): TDateTime;
       function SectionExists (const Section: String): Boolean;
       procedure WriteBool(const Section, Ident: String; Value: Boolean);
       procedure WriteDate(const Section, Ident: String; Value: TDateTime);
       procedure WriteDateTime(const Section, Ident: String; Value: TDateTime);
       procedure WriteFloat(const Section, Ident: String; Value: Double);
       procedure WriteInteger(const Section, Ident: String; Value: Longint);
       procedure WriteTime(const Section, Ident: String; Value: TDateTime);
       function ValueExists(const section, ident : string) : boolean;
       procedure WriteStrings(const Section, Ident : String; Value : TStrings);
       procedure ReadStrings(const Section, Ident : String; Target : TStrings);
       procedure ReadSection (const Section: string; Strings: TStrings);
       procedure ReadSections(Strings: TStrings);
       procedure ReadSectionValues(const Section: string; Strings: TStrings);

       property AutoConvert : boolean read FAutoConvert write FAutoConvert;
     end;

implementation

{ TSpkXMLIni }

constructor TSpkXMLIni.create;

begin
  inherited create;
  FParser:=TSpkXMLParser.create;
  FAutoConvert:=true;
end;

constructor TSpkXMLIni.create(filename : string);

begin
inherited create;
self.LoadFromFile(filename);
end;

destructor TSpkXMLIni.destroy;

begin
  FParser.free;
  inherited;
end;

procedure TSpkXMLIni.LoadFromFile(filename : string);

begin
try
FParser.LoadFromFile(filename);
except
self.clear;
end;
end;

procedure TSpkXMLIni.LoadFromStream(AStream: TStream);
begin
FParser.LoadFromStream(AStream);
end;

procedure TSpkXMLIni.SaveToFile(filename : string);

begin
FParser.SaveToFile(filename);
end;

procedure TSpkXMLIni.SaveToStream(AStream: TStream);
begin
FParser.SaveToStream(AStream);
end;

procedure TSpkXMLIni.Clear;

begin
FParser.Clear;
end;

procedure TSpkXMLIni.DeleteKey(const Section, Ident: string);

var node : TSpkXMLNode;
    subnode : TSpkXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node<>nil then
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode<>nil then
      begin
      node.delete(node.IndexOf(subnode));
      end;
   end;
end;

procedure TSpkXMLIni.EraseSection(const Section: string);

var node : TSpkXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node<>nil then
   Fparser.Delete(FParser.IndexOf(node));
end;

function TSpkXMLIni.ReadString(const Section, Ident, Default: string): string;

var node, subnode : TSpkXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='STRING' then
            result:=subnode.text else
            begin
            if FAutoConvert then
               try
               result:=subnode.text;
               except
               result:=Default;
               end else raise exception.create('Invalid object type!');
            end;
         end else result:=subnode.Text;
      end;
   end;
end;

procedure TSpkXMLIni.WriteString(const Section, Ident, Value: string);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].value:='string';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=Value;
end;

function TSpkXMLIni.ReadBool (const Section, Ident: String; Default: Boolean): Boolean;

var node, subnode : TSpkXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='BOOLEAN' then
            begin
            if (uppercase(subnode.text)='TRUE') or (subnode.text='1') then result:=true else result:=false;
            end else
                begin
                if FAutoConvert then
                   try
                   if (uppercase(subnode.text)='TRUE') or (subnode.text='1') then result:=true else result:=false;
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             if (uppercase(subnode.text)='TRUE') or (subnode.text='1') then result:=true else result:=false;
             except
             result:=Default;
             end;
      end;
   end;
end;

function TSpkXMLIni.ReadDate (const Section, Ident: string; Default: TDateTime): TDateTime;

var node, subnode : TSpkXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='DATE' then
            begin
            try
            result:=StrToDate(subnode.text);
            except
            result:=Default;
            end;
            end else
                begin
                if FAutoConvert then
                   try
                   result:=StrToDate(subnode.text);
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             result:=StrToDate(subnode.text);
             except
             result:=Default;
             end;
      end;
   end;
end;

function TSpkXMLIni.ReadDateTime (const Section, Ident: String; Default: TDateTime): TDateTime;

var node, subnode : TSpkXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='DATETIME' then
            begin
            try
            result:=StrToDateTime(subnode.text);
            except
            result:=Default;
            end;
            end else
                begin
                if FAutoConvert then
                   try
                   result:=StrToDateTime(subnode.text);
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             result:=StrToDateTime(subnode.text);
             except
             result:=Default;
             end;
      end;
   end;
end;

function TSpkXMLIni.ReadFloat (const Section, Ident: String; Default: Double): Double;

var node, subnode : TSpkXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='FLOAT' then
            begin
            try
            result:=StrToFloat(subnode.text);
            except
            result:=Default;
            end;
            end else
                begin
                if FAutoConvert then
                   try
                   result:=StrToFloat(subnode.text);
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             result:=StrToFloat(subnode.text);
             except
             result:=Default;
             end;
      end;
   end;
end;

function TSpkXMLIni.ReadInteger(const Section, Ident: String; Default: Longint): Longint;

var node, subnode : TSpkXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='FLOAT' then
            begin
            try
            result:=StrToInt(subnode.text);
            except
            result:=Default;
            end;
            end else
                begin
                if FAutoConvert then
                   try
                   result:=StrToInt(subnode.text);
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             result:=StrToInt(subnode.text);
             except
             result:=Default;
             end;
      end;
   end;
end;

function TSpkXMLIni.ReadTime (const Section, Ident: String; Default: TDateTime): TDateTime;

var node, subnode : TSpkXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='TIME' then
            begin
            try
            result:=StrToTime(subnode.text);
            except
            result:=Default;
            end;
            end else
                begin
                if FAutoConvert then
                   try
                   result:=StrToTime(subnode.text);
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             result:=StrToTime(subnode.text);
             except
             result:=Default;
             end;
      end;
   end;
end;

function TSpkXMLIni.SectionExists (const Section: String): Boolean;

begin
result:=FParser.NodeByName[Section,false]<>nil;
end;

procedure TSpkXMLIni.WriteBool(const Section, Ident: String; Value: Boolean);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='boolean';
if Value then FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:='true' else
   FParser.NodeByName[Section,true].NodeByName[Ident,true].text:='false';
end;

procedure TSpkXMLIni.WriteDate(const Section, Ident: String; Value: TDateTime);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='date';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=DateToStr(Value);
end;

procedure TSpkXMLIni.WriteDateTime(const Section, Ident: String; Value: TDateTime);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='datetime';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=DateTimeToStr(Value);
end;

procedure TSpkXMLIni.WriteFloat(const Section, Ident: String; Value: Double);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='float';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=FloatToStr(Value);
end;

procedure TSpkXMLIni.WriteInteger(const Section, Ident: String; Value: Longint);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='integer';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=IntToStr(Value);
end;

procedure TSpkXMLIni.WriteTime(const Section, Ident: String; Value: TDateTime);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='time';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=TimeToStr(Value);
end;

function TSpkXMLIni.ValueExists(const section, ident : string) : boolean;

begin
result:=FParser.NodeByName[section,false]<>nil;
if result then
   result:=result and (FParser.NodeByName[section,false].NodeByName[ident,false]<>nil);
end;

procedure TSpkXMLIni.WriteStrings(const Section, Ident : String; Value : TStrings);

var node,subnode : TSpkXMLNode;
    i : integer;

begin
self.DeleteKey(Section,Ident);
node:=FParser.NodeByName[Section,true];
subnode:=node.NodeByName[ident,true];
subnode.Parameters.ParamByName['type',true].value:='strings';
subnode.parameters.parambyname['count',true].value:=IntToStr(Value.count);
for i:=0 to value.count-1 do
    begin
    subnode.NodeByName['line'+IntToStr(i),true].text:=Value[i];
    end;
end;

procedure TSpkXMLIni.ReadStrings(const Section, Ident : String; Target : TStrings);

var node, subnode, line : TSpkXMLNode;
    i,count : integer;

begin
target.clear;

node:=FParser.NodeByName[Section,false];
if node=nil then exit;

subnode:=node.NodeByName[ident,false];
if subnode=nil then exit;

if subnode.Parameters.ParamByName['type',false]=nil then exit;
if uppercase(subnode.Parameters.ParamByName['type',false].value)<>'STRINGS' then exit;

if subnode.parameters.parambyname['count',false]=nil then exit;

try
count:=StrToInt(subnode.parameters.parambyname['count',false].Value);
except
exit
end;

for i:=0 to count-1 do
    begin
    line:=subnode.NodeByName['line'+IntToStr(i),false];
    if line=nil then
       begin
       target.Clear;
       exit;
       end;
    target.Add(line.Text);
    end;
end;

procedure TSpkXMLIni.ReadSection(const Section: string; Strings: TStrings);

var i : integer;
    node : TSpkXMLNode;

begin
if FParser.NodeByName[Section,false]=nil then exit;
node:=FParser.NodeByName[Section,false];
if node.Count=0 then exit;
for i:=0 to node.Count-1 do
    Strings.Add(node.NodeByIndex[i].Name);
end;

procedure TSpkXMLIni.ReadSections(Strings: TStrings);

var i : integer;

begin
if FParser.count=0 then exit;
for i:=0 to FParser.count-1 do
    Strings.add(FParser.NodeByIndex[i].Name);
end;

procedure TSpkXMLIni.ReadSectionValues(const Section: string; Strings: TStrings);

var i : integer;
    node : TSpkXMLNode;

begin
if FParser.NodeByName[Section,false]=nil then exit;
node:=FParser.NodeByName[Section,false];
if node.Count=0 then exit;
for i:=0 to node.count-1 do
    begin
    {$I-}
    if (node.NodeByIndex[i].Parameters.ParamByName['type',false]<>nil) and
       (uppercase(node.NodeByIndex[i].Parameters.ParamByName['type',false].Value)='STRINGS') then
       Strings.add('[TStrings]')
       else
       Strings.add(node.NodeByIndex[i].Text);
    end;
end;

end.
