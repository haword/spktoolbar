unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, SpkToolbar,
  spkt_Tab, spkt_Pane, spkt_Buttons, FMX.Menus, spkt_Types, FMX.Controls.Presentation,
  FMX.StdCtrls, spkt_BaseItem, FMX.Objects, System.ImageList, FMX.ImgList, FMX.TabControl,
  FMX.ScrollBox, FMX.Memo, FMX.TextLayout, System.Actions, FMX.ActnList,
  FMX.Layouts, spkt_Checkboxes;

type
  TSimpleEditor = class(TForm)
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Images: TImageList;
    LargeImages: TImageList;
    SpkToolbar1: TSpkToolbar;
    SpkTab1: TSpkTab;
    FilePanel: TSpkPane;
    OpenButton: TSpkSmallButton;
    SaveButton: TSpkSmallButton;
    SaveAsButton: TSpkSmallButton;
    NewButton: TSpkLargeButton;
    EditPanel: TSpkPane;
    btnUndo: TSpkSmallButton;
    btnRedo: TSpkSmallButton;
    btnCut: TSpkSmallButton;
    btnPaste: TSpkSmallButton;
    btnCopy: TSpkSmallButton;
    Search: TSpkPane;
    btnReplace: TSpkSmallButton;
    btnSearch: TSpkLargeButton;
    btnSearchNext: TSpkSmallButton;
    Memo: TMemo;
    ActionList1: TActionList;
    NewFile: TAction;
    OpenFile: TAction;
    SaveFile: TAction;
    SaveAsFile: TAction;
    EditUndo: TAction;
    Copy: TAction;
    Paste: TAction;
    Cut: TAction;
    SearchAct: TAction;
    SearchNext: TAction;
    Replace: TAction;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Layout1: TLayout;
    procedure Button2Click(Sender: TObject);
    procedure EditUndoExecute(Sender: TObject);
    procedure CopyExecute(Sender: TObject);
    procedure PasteExecute(Sender: TObject);
    procedure CutExecute(Sender: TObject);
    procedure NewFileExecute(Sender: TObject);
    procedure OpenFileExecute(Sender: TObject);
    procedure SaveFileExecute(Sender: TObject);
    procedure SaveAsFileExecute(Sender: TObject);
    procedure OpenDialog1TypeChange(Sender: TObject);
  private
    filterindex: Integer;
    filename: string;
    procedure OnClick(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TTextAccess = class(TText);

var
  SimpleEditor: TSimpleEditor;
  spk: TSpkToolbar;

implementation
//uses spkte_EditWindow;

uses
  Unit2; {$R *.fmx}

procedure ClearTextAttribute(Text: TText);
begin
  TTextAccess(Text).Layout.ClearAttributes;
end;

procedure AddTextAttribute(Text: TText; Pos, Length: Integer; FontStyles: TFontStyles; FontColor: TAlphaColor);
var
  Font: TFont;
begin
  Font := TFont.Create;
  Font.Assign(Text.Font);
  Font.Style := FontStyles;
  TTextAccess(Text).Layout.AddAttribute(TTextRange.Create(Pos, Length), TTextAttribute.Create(Font, FontColor));
end;

procedure TSimpleEditor.Button2Click(Sender: TObject);
begin
//  AddTextAttribute(Memo1,10,17,[TFontStyle.fsBold],TAlphaColorRec.claRed);
//  AddTextAttribute(Memo1,34,8,[TFontStyle.fsUnderline],TAlphaColorRec.claBlue);
//  AddTextAttribute(Memo1,47,8,[TFontStyle.fsStrikeOut],TAlphaColorRec.claGreen);
end;

procedure TSimpleEditor.CopyExecute(Sender: TObject);
begin
  Memo.CopyToClipboard;
end;

procedure TSimpleEditor.CutExecute(Sender: TObject);
begin
  Memo.CutToClipboard;
end;

procedure TSimpleEditor.EditUndoExecute(Sender: TObject);
begin
  Memo.UnDo;
end;

procedure TSimpleEditor.NewFileExecute(Sender: TObject);
begin
  Memo.Lines.Clear;
end;

procedure TSimpleEditor.OnClick(Sender: TObject);
begin
  ShowMessage('ok');
end;

procedure TSimpleEditor.OpenDialog1TypeChange(Sender: TObject);
begin
  filterindex := OpenDialog1.FilterIndex;
end;

procedure TSimpleEditor.OpenFileExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    CodeForm.ShowModal(
      procedure(ModalResult: TModalResult)
      begin
        if ModalResult <> mrOk then
          Exit;
        FilterIndex:= CodeForm.ComboBox1.ItemIndex;
        case CodeForm.ComboBox1.ItemIndex of
          1:
            Memo.Lines.LoadFromFile(OpenDialog1.FileName, TEncoding.ANSI);
          2:
            Memo.Lines.LoadFromFile(OpenDialog1.FileName, TEncoding.UTF8);
          3:
            Memo.Lines.LoadFromFile(OpenDialog1.FileName, TEncoding.Unicode);
        else
          begin
            Memo.Lines.LoadFromFile(OpenDialog1.FileName, TEncoding.ASCII);
          end;
        end;

      end);
end;

procedure TSimpleEditor.PasteExecute(Sender: TObject);
begin
  Memo.PasteFromClipboard;
end;

procedure TSimpleEditor.SaveAsFileExecute(Sender: TObject);
begin
  SaveDialog1.FileName := filename;
  SaveDialog1.FilterIndex := filterindex;
  if SaveDialog1.Execute then
    CodeForm.ShowModal(
      procedure(ModalResult: TModalResult)
      begin
        if ModalResult <> mrOk then
          Exit;
        case CodeForm.ComboBox1.ItemIndex of
          1:
            Memo.Lines.SaveToFile(SaveDialog1.FileName, TEncoding.ANSI);
          2:
            Memo.Lines.SaveToFile(SaveDialog1.FileName, TEncoding.UTF8);
          3:
            Memo.Lines.SaveToFile(SaveDialog1.FileName, TEncoding.Unicode);
        else
          begin
            Memo.Lines.SaveToFile(SaveDialog1.FileName, TEncoding.ASCII);
          end;
        end;

      end);

end;

procedure TSimpleEditor.SaveFileExecute(Sender: TObject);
begin
  if filename = '' then
    Exit;

  case FilterIndex of
    1:
      Memo.Lines.SaveToFile(FileName, TEncoding.ANSI);
    2:
      Memo.Lines.SaveToFile(FileName, TEncoding.UTF8);
    3:
      Memo.Lines.SaveToFile(FileName, TEncoding.Unicode);
  else
    begin
      Memo.Lines.SaveToFile(FileName, TEncoding.ASCII);
    end;

  end;

end;

end.

