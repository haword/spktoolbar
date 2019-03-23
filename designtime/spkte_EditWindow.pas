unit spkte_EditWindow;

interface

//** Converted with Mida BASIC 277     http://www.midaconverter.com

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IniFiles, Data.DB, FMX.Types, FMX.Controls,
  FMX.Forms,
  FMX.Menus, FMX.ExtCtrls, FMX.TreeView, FMX.platform,
  System.Rtti, FMX.ActnList, Fmx.StdCtrls, FMX.Header, FMX.Graphics,
//  ToolsAPI, DesignIntf, DesignEditors, DesignMenus, DesignWindows,
//**   Original VCL Uses section :


//**    SysUtils, Variants, Classes, FMX.Graphics, FMX.Controls, FMX.Forms,
  DesignIntf,
  DesignEditors,
  FmxDesignWindows,
  FMX.ImgList,
//**   FMX.ActnList, FMX.Menus,
  spkToolbar, spkt_Tab, spkt_Pane, spkt_BaseItem, spkt_Buttons, spkt_Types,
  spkt_Checkboxes,
  System.ImageList, FMX.Controls.Presentation, System.Actions, FMX.Layouts;
//**   FMX.Types, System.Actions, System.ImageList, FMX.Controls.Presentation,
//**   FMX.Layouts, FMX.TreeView;

type
  TCreateItemFunc = function(Pane: TSpkPane): TSpkBaseItem;

//  IDesigner = class (TFmxObject)
//   procedure Modified;
////   procedure SelectComponent(Component: TComponent); overload;
//   procedure SelectComponent(Component: IDesignObject); overload;
//  end;

type
  TMyTreeViewItem = class;

  TfrmEditWindow = class(TForm)
    tvStructure: TTreeView;
    ilTreeImages: TImageList;
    tbToolBar: TToolBar;
    tbAddTab: TButton;
    ilActionImages: TImageList;
    tbRemoveTab: TButton;
    ToolButton3: TButton;
    tbAddPane: TButton;
    tbRemovePane: TButton;
    ActionList1: TActionList;
    aAddTab: TAction;
    aRemoveTab: TAction;
    aAddPane: TAction;
    aRemovePane: TAction;
    ToolButton6: TButton;
    aMoveUp: TAction;
    aMoveDown: TAction;
    tbMoveUp: TButton;
    tbMoveDown: TButton;
    tbAddItem: TButton;
    tbRemoveItem: TButton;
    pmAddItem: TPopupMenu;
    SpkLargeButton1: TMenuItem;
    aAddLargeButton: TAction;
    aRemoveItem: TAction;
    aAddSmallButton: TAction;
    SpkSmallButton1: TMenuItem;
    pmStructure: TPopupMenu;
    Addtab1: TMenuItem;
    Removetab1: TMenuItem;
    N1: TMenuItem;
    Addpane1: TMenuItem;
    Removepane1: TMenuItem;
    N2: TMenuItem;
    Additem1: TMenuItem;
    SpkLargeButton2: TMenuItem;
    SpkSmallButton2: TMenuItem;
    Removeitem1: TMenuItem;
    N3: TMenuItem;
    Moveup1: TMenuItem;
    Movedown1: TMenuItem;
    ToolButton9: TButton;
    aAddCheckbox: TAction;
    aAddRadioButton: TAction;
    spkCheckbox: TMenuItem;
    spkRadioButton: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    procedure tvStructureChange(Sender: TObject);
    procedure aAddTabExecute(Sender: TObject);
    procedure aRemoveTabExecute(Sender: TObject);
    procedure aAddPaneExecute(Sender: TObject);
    procedure aRemovePaneExecute(Sender: TObject);
    procedure aMoveUpExecute(Sender: TObject);
    procedure aMoveDownExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure aAddLargeButtonExecute(Sender: TObject);
    procedure aRemoveItemExecute(Sender: TObject);
    procedure aAddSmallButtonExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure tvStructureEdited(Sender: TObject; Node: TTreeViewItem; var S: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tvStructureKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure ToolButton9Click(Sender: TObject);
    procedure aAddCheckboxExecute(Sender: TObject);
    procedure aAddRadioButtonExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    FToolbar: TSpkToolbar;
    FDesigner: IDesigner;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CheckActionsAvailability;
    procedure AddItem(CreateItemFunc: TCreateItemFunc);
    function GetItemCaption(Item: TSpkBaseItem): string;
    procedure SetItemCaption(Item: TSpkBaseItem; const Value: string);
    procedure DoRemoveTab;
    procedure DoRemovePane;
    procedure DoRemoveItem;
    function CheckValidTabNode(Node: TMyTreeViewItem): boolean;
    function CheckValidPaneNode(Node: TMyTreeViewItem): boolean;
    function CheckValidItemNode(Node: TMyTreeViewItem): boolean;
  public
    { Public declarations }
    function ValidateTreeData: boolean;
    procedure BuildTreeData;
    procedure RefreshNames;
    procedure SetData(AToolbar: TSpkToolbar; ADesigner: IDesigner);
    property Toolbar: TSpkToolbar read FToolbar;
//    procedure DesignerClosed(const Designer: IDesigner; AGoingDormant: Boolean); override;
    procedure SelectionChanged(const ADesigner: IDesigner; const ASelection: IDesignerSelections);
  end;

  TMyTreeViewItem = class(TTreeViewItem)
  private
    FData: TValue;
  public
    function GetFirstNode: TMyTreeViewItem;
    function getFirstChild: TMyTreeViewItem;
    function getNextSibling: TMyTreeViewItem;
    function GetPrevSibling: TMyTreeViewItem;
    property Data: TValue read GetData write SetData;
  private
    function GetData: TValue; override;
    procedure SetData(const Value: TValue); override;
  end;

type
  TCloseWatcher = class
    procedure DesignerClosed(Sender: TObject; var Action: TCloseAction);
  end;

var
  Watcher: TCloseWatcher;
  frmEditWindow: TfrmEditWindow;

implementation

{$R *.FMX}

procedure TCloseWatcher.DesignerClosed(Sender: TObject; var Action: TCloseAction);
begin
  if Sender = frmEditWindow then
  begin
    Action := TCloseAction.caHide;
//    frmEditWindow := nil;
  end;
end;

{ TfrmEditWindow }

procedure TfrmEditWindow.aAddCheckboxExecute(Sender: TObject);

  function CreateLargeButton(Pane: TSpkPane): TSpkBaseItem;
  begin
    result := Pane.Items.AddCheckbox;
  end;

begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  AddItem(@CreateLargeButton);

end;

procedure TfrmEditWindow.aAddLargeButtonExecute(Sender: TObject);

  function CreateLargeButton(Pane: TSpkPane): TSpkBaseItem;
  begin
    result := Pane.Items.AddLargeButton;
  end;

begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  AddItem(@CreateLargeButton);
end;

procedure TfrmEditWindow.aAddPaneExecute(Sender: TObject);
var
  Obj: TObject;
  Node: TMyTreeViewItem;
  NewNode: TMyTreeViewItem;
  Tab: TSpkTab;
  Pane: TSpkPane;
  DesignObj : IDesignObject;

begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := TMyTreeViewItem(tvStructure.Selected);
  if Node = nil then
    raise Exception.create('TfrmEditWindow.aAddPaneExecute: Brak zaznaczonego obiektu!');

//if Node.Data = nil then
//   raise Exception.create('TfrmEditWindow.aAddPaneExecute: Uszkodzona struktura drzewa!');
  tvStructure.BeginUpdate;
  try
    Obj := Node.Data.AsObject;
    if Obj is TSpkTab then
    begin
      Tab := Obj as TSpkTab;
      Pane := Tab.Panes.Add;
//      Pane.Name:= FDesigner.UniqueName('SpkPane');
      NewNode := TMyTreeViewItem.Create(nil);
      NewNode.Text := Pane.Name;
      Node.AddObject(NewNode);
      NewNode.Parent := Node;
      NewNode.Data := Pane;
      NewNode.ImageIndex := 1;
      NewNode.Select; //    SelectedIndex:=1;
//   NewNode.Selected:=true;
      CheckActionsAvailability;

      DesignObj:=PersistentToDesignObject(Pane);
      FDesigner.Modified;
      FDesigner.SelectComponent(DesignObj);
    end
    else if Obj is TSpkPane then
    begin
      if not (CheckValidPaneNode(Node)) then
        raise exception.create('TfrmEditWindow.aAddPaneExecute: Uszkodzona struktura drzewa!');

      Tab := TSpkTab(Node.ParentItem.Data.AsObject);
      Pane := Tab.Panes.Add;
//      Pane.Name:= FDesigner.UniqueName('SpkPane');
      NewNode := TMyTreeViewItem.Create(nil);
      NewNode.Text := Pane.Name;
      Node.ParentItem.AddObject(NewNode);
      NewNode.Parent := Node.ParentItem;
      NewNode.Data := Pane;
      NewNode.ImageIndex := 1;
//   NewNode.SelectedIndex:=1;
      NewNode.Select; //:=true;
      CheckActionsAvailability;

      DesignObj:=PersistentToDesignObject(Pane);
      FDesigner.Modified;
      FDesigner.SelectComponent(DesignObj);
    end
    else if Obj is TSpkBaseItem then
    begin
      if not (CheckValidItemNode(Node)) then
        raise exception.create('TfrmEditWindow.aAddPaneExecute: Uszkodzona struktura drzewa!');

      Tab := TSpkTab(Node.ParentItem.ParentItem.Data.AsObject);
      Pane := Tab.Panes.Add;
//      Pane.Name:= FDesigner.UniqueName('SpkPane');
      NewNode := TMyTreeViewItem.Create(nil);
      NewNode.Text := Pane.Name;
//   NewNode:=tvStructure.Items.AddChild(Node.Parent.Parent, Pane.Caption);
      Node.ParentItem.ParentItem.AddObject(NewNode);
      NewNode.Data := Pane;
      NewNode.ImageIndex := 1;
//   NewNode.SelectedIndex:=1;
//   NewNode.Selected:=true;
      NewNode.Select;
      CheckActionsAvailability;

       DesignObj:=PersistentToDesignObject(Pane);
      FDesigner.Modified;
      FDesigner.SelectComponent(DesignObj);
    end
    else
      raise exception.create('TfrmEditWindow.aAddPaneExecute: Nieprawid³owy obiekt podwieszony pod ga³êzi¹!');
  finally
    tvStructure.EndUpdate;
  end;
end;

procedure TfrmEditWindow.aAddRadioButtonExecute(Sender: TObject);

  function CreateLargeButton(Pane: TSpkPane): TSpkBaseItem;
  begin
    result := Pane.Items.AddRadioButton;
  end;

begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  AddItem(@CreateLargeButton);

end;

procedure TfrmEditWindow.aAddSmallButtonExecute(Sender: TObject);

  function CreateSmallButton(Pane: TSpkPane): TSpkBaseItem;
  begin
    result := Pane.Items.AddSmallButton;
  end;

begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  AddItem(@CreateSmallButton);
end;

procedure TfrmEditWindow.aAddTabExecute(Sender: TObject);
var
  Node: TMyTreeViewItem;
  Tab: TSpkTab;
  DesignObj : IDesignObject;
  v: TValue;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  tvStructure.BeginUpdate;
  Tab := FToolbar.Tabs.Add;
  //Tab.Name:= FDesigner.UniqueName('SpkTab');
  Node := TMyTreeViewItem.Create(tvStructure);
  Node.Text := Tab.Name;
  tvStructure.AddObject(Node);
//  Node.Parent:=tvStructure;
  Node.data := Tab;
  Node.ImageIndex := 0;
//Node.SelectedIndex:=0;
//Node.Selected:=true;
  Node.Select;
  tvStructure.EndUpdate;
  CheckActionsAvailability;

  DesignObj:=PersistentToDesignObject(Tab);
  FDesigner.Modified;
  FDesigner.SelectComponent(DesignObj);
end;

procedure TfrmEditWindow.AddItem(CreateItemFunc: TCreateItemFunc);
var
  Node: TMyTreeViewItem;
  Obj: TObject;
  Pane: TSpkPane;
  Item: TSpkBaseItem;
  NewNode: TMyTreeViewItem;
  DesignObj: IDesignObject;
  s: string;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := TMyTreeViewItem(tvStructure.Selected);
  if Node = nil then
    raise Exception.Create('TfrmEditWindow.AddItem: Brak zaznaczonego obiektu!');
//if Node.Data = nil then
//   raise Exception.Create('TfrmEditWindow.AddItem: Uszkodzona struktura drzewa!');
  tvStructure.BeginUpdate;
  try
    Obj := Node.Data.AsObject;
    if Obj is TSpkPane then
    begin
      Pane := Obj as TSpkPane;
      Item := CreateItemFunc(Pane);
      s := GetItemCaption(Item);//Item.Name;
//      Item.Name:= FDesigner.UniqueName(s);
      NewNode := TMyTreeViewItem.Create(nil);
      NewNode.Text := s;
      Node.AddObject(NewNode);
      NewNode.Data := Item;
      NewNode.ImageIndex := 2;
//    NewNode.SelectedIndex := 2;
//    NewNode.Selected := true;
      NewNode.Select;
      CheckActionsAvailability;

      DesignObj:=PersistentToDesignObject(Item);
      FDesigner.Modified;
      FDesigner.SelectComponent(DesignObj);

    end
    else if Obj is TSpkBaseItem then
    begin
      if not (CheckValidItemNode(Node)) then
        raise exception.create('TfrmEditWindow.AddItem: Uszkodzona struktura drzewa!');

      Pane := TSpkPane(Node.ParentItem.Data.AsObject);
      Item := CreateItemFunc(Pane);
      s := GetItemCaption(Item);// Item.Name;
//      Item.Name:= FDesigner.UniqueName(s);
      NewNode := TMyTreeViewItem.Create(nil);
      NewNode.Text := s;
      Node.ParentItem.AddObject(NewNode);
      NewNode.Data := Item;
      if Item is TSpkLargeButton then
        NewNode.ImageIndex := 2
      else if Item is TSpkSmallButton then
        NewNode.ImageIndex := 3
      else if Item is TSpkCheckbox then
        NewNode.ImageIndex := 4
      else if Item is TSpkRadioButton then
        NewNode.ImageIndex := 5
      else
        raise Exception.Create('Item class not supported');

//      NewNode.ImageIndex := 2;
//    NewNode.SelectedIndex := 2;
//    NewNode.Selected := true;
      NewNode.Select;
      CheckActionsAvailability;

      DesignObj:=PersistentToDesignObject(Item);
      FDesigner.Modified;
      FDesigner.SelectComponent(DesignObj);
    end
    else
      raise exception.create('TfrmEditWindow.AddItem: Nieprawid³owy obiekt podwieszony pod ga³êzi¹!');
  finally
    tvStructure.EndUpdate;
  end;
end;

procedure TfrmEditWindow.aMoveDownExecute(Sender: TObject);
var
  Node, NodeP: TMyTreeViewItem;
  Tab: TSpkTab;
  Pane: TSpkPane;
  Obj: TObject;
  index: Integer;
  Item: TSpkBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := TMyTreeViewItem(tvStructure.Selected);
  if Node = nil then
    raise exception.create('TfrmEditWindow.aMoveDownExecute: Nie zaznaczono obiektu do przesuniêcia!');

//  if Node.Data = nil then
//    raise exception.create('TfrmEditWindow.aMoveDownExecute: Uszkodzona struktura drzewa!');

  Obj := Node.Data.AsObject;

  if Obj is TSpkTab then
  begin
    if not (CheckValidTabNode(Node)) then
      raise exception.create('TfrmEditWindow.aMoveDownExecute: Uszkodzona struktura drzewa!');

    Tab := TSpkTab(Node.Data.AsObject);
    index := FToolbar.Tabs.IndexOf(Tab);
    if (index = -1) then
      raise exception.create('TfrmEditWindow.aMoveDownExecute: Uszkodzona struktura drzewa!');
    if (index = FToolbar.Tabs.Count - 1) then
      raise exception.create('TfrmEditWindow.aMoveDownExecute: Nie mo¿na przesun¹æ w dó³ ostatniego elementu!');

    FToolbar.Tabs.Exchange(index, index + 1);
    FToolbar.TabIndex := index + 1;

//    Node.Parent.InsertObject(index + 1, Node);
    Node.Index := index + 1;
//    Node.GetNextSibling.InsertObject(index, Node);
    Node.Select;
    CheckActionsAvailability;
  end
  else if Obj is TSpkPane then
  begin
    if not (CheckValidPaneNode(Node)) then
      raise exception.create('TfrmEditWindow.aMoveDownExecute: Uszkodzona struktura drzewa!');

    Pane := TSpkPane(Node.Data.AsObject);
    Tab := TSpkTab(Node.ParentItem.Data.AsObject);

    index := Tab.Panes.IndexOf(Pane);
    if (index = -1) then
      raise exception.create('TfrmEditWindow.aMoveDownExecute: Uszkodzona struktura drzewa!');
    if (index = Tab.Panes.Count - 1) then
      raise exception.create('TfrmEditWindow.aMoveDownExecute: Nie mo¿na przesun¹æ w dó³ ostatniego elementu!');

    Tab.Panes.Exchange(index, index + 1);

//    NodeP:= TMyTreeViewItem(Node.ParentItem);
//    NodeP.InsertObject(index + 1, Node);
    Node.Index := index + 1;
//    Node.GetNextSibling.InsertObject(index,Node);
    Node.Select;
    CheckActionsAvailability;
  end
  else if Obj is TSpkBaseItem then
  begin
    if not (CheckValidItemNode(Node)) then
      raise exception.create('TfrmEditWindow.aMoveDown.Execute: Uszkodzona struktura drzewa!');

    Item := TSpkBaseItem(Node.Data.AsObject);
    Pane := TSpkPane(Node.ParentItem.Data.AsObject);

    index := Pane.Items.IndexOf(Item);
    if (index = -1) then
      raise exception.create('TfrmEditWindow.aMoveDownExecute: Uszkodzona struktura drzewa!');
    if (index = Pane.Items.Count - 1) then
      raise exception.create('TfrmEditWindow.aMoveDownExecute: Nie mo¿na przesun¹æ w dó³ ostatniego elementu!');

    Pane.Items.Exchange(index, index + 1);
//    NodeP:= TMyTreeViewItem(Node.ParentItem);
//    NodeP.InsertObject(index + 1, Node);
//    Node.GetNextSibling.InsertObject(index, Node);
    Node.Index := index + 1;

    Node.Select;
    CheckActionsAvailability;
  end
  else
    raise exception.create('TfrmEditWindow.aMoveDownExecute: Nieprawid³owy obiekt podwieszony pod ga³êzi¹!');
end;

procedure TfrmEditWindow.aMoveUpExecute(Sender: TObject);
var
  Node: TMyTreeViewItem;
  Tab: TSpkTab;
  Pane: TSpkPane;
  Obj: TObject;
  index: Integer;
  Item: TSpkBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := TMyTreeViewItem(tvStructure.Selected);
  if Node = nil then
    raise exception.create('TfrmEditWindow.aMoveUpExecute: Nie zaznaczono obiektu do przesuniêcia!');
  if Node.Data.IsEmpty then
    raise exception.create('TfrmEditWindow.aMoveUpExecute: Uszkodzona struktura drzewa!');

  Obj := Node.Data.AsObject;

  if Obj is TSpkTab then
  begin
    if not (CheckValidTabNode(Node)) then
      raise exception.create('TfrmEditWindow.aMoveUpExecute: Uszkodzona struktura drzewa!');

    Tab := TSpkTab(Node.Data.AsObject);
    index := FToolbar.Tabs.IndexOf(Tab);
    if (index = -1) then
      raise exception.create('TfrmEditWindow.aMoveUpExecute: Uszkodzona struktura drzewa!');
    if (index = 0) then
      raise exception.create('TfrmEditWindow.aMoveUpExecute: Nie mo¿na przesun¹æ do góry pierwszego elementu!');

    FToolbar.Tabs.Exchange(index, index - 1);
    FToolbar.TabIndex := index - 1;

    Node.Index := index - 1;
    Node.Select;
    CheckActionsAvailability;
  end
  else if Obj is TSpkPane then
  begin
    if not (CheckValidPaneNode(Node)) then
      raise exception.create('TfrmEditWindow.aMoveUpExecute: Uszkodzona struktura drzewa!');

    Pane := TSpkPane(Node.Data.AsObject);
    Tab := TSpkTab(Node.ParentItem.Data.AsObject);

    index := Tab.Panes.IndexOf(Pane);
    if (index = -1) then
      raise exception.create('TfrmEditWindow.aMoveUpExecute: Uszkodzona struktura drzewa!');
    if (index = 0) then
      raise exception.create('TfrmEditWindow.aMoveUpExecute: Nie mo¿na przesun¹æ do góry pierwszego elementu!');

    Tab.Panes.Exchange(index, index - 1);

    Node.Index := index - 1;
    Node.Select;
    CheckActionsAvailability;
  end
  else if Obj is TSpkBaseItem then
  begin
    if not (CheckValidItemNode(Node)) then
      raise exception.create('TfrmEditWindow.aMoveUpExecute: Uszkodzona struktura drzewa!');

    Item := TSpkBaseItem(Node.Data.AsObject);
    Pane := TSpkPane(Node.ParentItem.Data.AsObject);

    index := Pane.Items.IndexOf(Item);
    if (index = -1) then
      raise exception.create('TfrmEditWindow.aMoveUpExecute: Uszkodzona struktura drzewa!');
    if (index = 0) then
      raise exception.create('TfrmEditWindow.aMoveUpExecute: Nie mo¿na przesun¹æ do góry pierwszego elementu!');

    Pane.Items.Exchange(index, index - 1);

    Node.Index := index - 1;
    Node.Select;
    CheckActionsAvailability;
  end
  else
    raise exception.create('TfrmEditWindow.aMoveUpExecute: Nieprawid³owy obiekt podwieszony pod ga³êzi¹!');
end;

procedure TfrmEditWindow.aRemoveItemExecute(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  DoRemoveItem;
end;

procedure TfrmEditWindow.aRemovePaneExecute(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  DoRemovePane;
end;

procedure TfrmEditWindow.aRemoveTabExecute(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  DoRemoveTab;
end;

procedure TfrmEditWindow.CheckActionsAvailability;
var
  Node, NodeP: TMyTreeViewItem;
  Obj: TObject;
  Tab: TSpkTab;
  Pane: TSpkPane;
  index: integer;
  Item: TSpkBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
  begin
   // Brak toolbara lub designera

    aAddTab.Enabled := false;
    aRemoveTab.Enabled := false;
    aAddPane.Enabled := false;
    aRemovePane.Enabled := false;
    aAddLargeButton.Enabled := false;
    aAddSmallButton.Enabled := false;
    aRemoveItem.Enabled := false;
    aMoveUp.Enabled := false;
    aMoveDown.Enabled := false;
  end
  else
  begin
    Node := TMyTreeViewItem(tvStructure.Selected);

    if (Node = nil) then
    begin
      // Pusty toolbar
      aAddTab.Enabled := true;
      aRemoveTab.Enabled := false;
      aAddPane.Enabled := false;
      aRemovePane.Enabled := false;
      aAddLargeButton.Enabled := false;
      aAddSmallButton.Enabled := false;
      aRemoveItem.Enabled := false;
      aMoveUp.Enabled := false;
      aMoveDown.Enabled := false;
    end
    else
    begin
      if not Node.IsSelected then
        Exit;

      Obj := TObject(Node.Data.AsObject);
      if Obj = nil then
        raise exception.create('TfrmEditWindow.CheckActionsAvailability: Nieprawid³owe dane w ga³êzi!');

      if Obj is TSpkTab then
      begin
        Tab := Obj as TSpkTab;

        if not (CheckValidTabNode(Node)) then
          raise exception.create('TfrmEditWindow.CheckActionsAvailability: Uszkodzona struktura drzewa!');

        aAddTab.Enabled := true;
        aRemoveTab.Enabled := true;
        aAddPane.Enabled := true;
        aRemovePane.Enabled := false;
        aAddLargeButton.Enabled := false;
        aAddSmallButton.Enabled := false;
        aRemoveItem.Enabled := false;

        index := FToolbar.Tabs.IndexOf(Tab);
        if index = -1 then
          raise exception.create('TfrmEditWindow.CheckActionsAvailability: Uszkodzona struktura drzewa!');

        aMoveUp.enabled := (index > 0);
        aMoveDown.enabled := (index < FToolbar.Tabs.Count - 1);
      end
      else if Obj is TSpkPane then
      begin
        Pane := Obj as TSpkPane;
        NodeP := TMyTreeViewItem(Node.ParentItem);
        if not (CheckValidPaneNode(Node)) then
          raise exception.create('TfrmEditWindow.CheckActionsAvailability: Uszkodzona struktura drzewa!');

        Tab := TSpkTab(Node.ParentItem.Data.AsObject);

        aAddTab.Enabled := true;
        aRemoveTab.enabled := false;
        aAddPane.Enabled := true;
        aRemovePane.Enabled := true;
        aAddLargeButton.Enabled := true;
        aAddSmallButton.Enabled := true;
        aRemoveItem.Enabled := false;

        index := Tab.Panes.IndexOf(Pane);

        if index = -1 then
          raise exception.create('TfrmEditWindow.CheckActionsAvailability: Uszkodzona struktura drzewa!');

        aMoveUp.Enabled := (index > 0);
        aMoveDown.Enabled := (index < Tab.Panes.Count - 1);
      end
      else if Obj is TSpkBaseItem then
      begin
        Item := Obj as TSpkBaseItem;

        if not (CheckValidItemNode(Node)) then
          raise exception.create('TfrmEditWindow.CheckActionsAvailability: Uszkodzona struktura drzewa!');

        Pane := TSpkPane(Node.ParentItem.Data.AsObject);

        aAddTab.Enabled := true;
        aRemoveTab.Enabled := false;
        aAddPane.Enabled := true;
        aRemovePane.Enabled := false;
        aAddLargeButton.Enabled := true;
        aAddSmallButton.Enabled := true;
        aRemoveItem.Enabled := true;

        index := Pane.Items.IndexOf(Item);

        if index = -1 then
          raise exception.create('TfrmEditWindow.CheckActionsAvailability: Uszkodzona struktura drzewa!');

        aMoveUp.Enabled := (index > 0);
        aMoveDown.Enabled := (index < Pane.Items.Count - 1);
      end
      else
        raise exception.create('TfrmEditWindow.CheckActionsAvailability: Nieprawid³owy obiekt podwieszony pod ga³êzi¹!');
    end;
  end;

end;

function TfrmEditWindow.CheckValidItemNode(Node: TMyTreeViewItem): boolean;
begin
  result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

{$B-}
  result := (Node <> nil) and (Node.Data.AsObject <> nil) and (TObject(Node.Data.AsObject) is TSpkBaseItem) and CheckValidPaneNode(TMyTreeViewItem(Node.ParentItem));
end;

function TfrmEditWindow.CheckValidPaneNode(Node: TMyTreeViewItem): boolean;
begin
  result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

{$B-}
  result := (Node <> nil) and (Node.Data.AsObject <> nil) and (TObject(Node.Data.AsObject) is TSpkPane) and CheckValidTabNode(TMyTreeViewItem(Node.ParentItem));
end;

function TfrmEditWindow.CheckValidTabNode(Node: TMyTreeViewItem): boolean;
begin
  result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

{$B-}
  result := (Node <> nil) and (Node.Data.IsObject) and (Node.Data.AsObject is TSpkTab);
end;

procedure TfrmEditWindow.FormActivate(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if not (ValidateTreeData) then
    BuildTreeData;
end;

procedure TfrmEditWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
end;

procedure TfrmEditWindow.FormCreate(Sender: TObject);
begin
  FToolbar := nil;
  FDesigner := nil;
  if not Assigned(Watcher) then
    Watcher := TCloseWatcher.Create;
  OnClose := Watcher.DesignerClosed;

end;

procedure TfrmEditWindow.FormDestroy(Sender: TObject);
begin
  if FToolbar <> nil then
    FToolbar.RemoveFreeNotification(self);
end;

procedure TfrmEditWindow.FormShow(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  BuildTreeData;
end;

function TfrmEditWindow.GetItemCaption(Item: TSpkBaseItem): string;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Item is TSpkBaseButton then
  begin
    result := TSpkBaseButton(Item).Caption;
  end
  else
    result := '<Unknown caption>';
end;

procedure TfrmEditWindow.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (AComponent = FToolbar) and (Operation = opRemove) then
  begin
     // W³aœnie zwalniany jest toolbar, którego zawartoœæ wyœwietla okno
     // edytora. Trzeba posprz¹taæ zawartoœæ - w przeciwnym wypadku okno
     // bêdzie mia³o referencje do ju¿ usuniêtych elementów toolbara, co
     // skoñczy siê AVami...

    SetData(nil, nil);
  end;
end;

procedure TfrmEditWindow.SetItemCaption(Item: TSpkBaseItem; const Value: string);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Item is TSpkBaseButton then
    TSpkBaseButton(Item).Caption := Value;
end;

procedure TfrmEditWindow.ToolButton9Click(Sender: TObject);
var
  pt: TPointF;
begin
  pt.X := 0;
  pt.Y := TButton(Sender).Height;
  pt := TButton(Sender).LocalToAbsolute(pt);
  pt := ClientToScreen(pt);
  if Assigned(TButton(Sender).PopupMenu) then
    TButton(Sender).PopupMenu.Popup(pt.X, pt.y);
end;

procedure TfrmEditWindow.SelectionChanged(const ADesigner: IDesigner;
  const ASelection: IDesignerSelections);
begin
  if ASelection.Count > 0 then
  begin
    if (aSelection[0] is TControl) then
    begin

    end;
  end;

end;

procedure TfrmEditWindow.SetData(AToolbar: TSpkToolbar; ADesigner: IDesigner);
begin
  if FToolbar <> nil then
    FToolbar.RemoveFreeNotification(self);

  FToolbar := AToolbar;
  FDesigner := ADesigner;

  if FToolbar <> nil then
    FToolbar.FreeNotification(self);

  BuildTreeData;
end;

//procedure TfrmEditWindow.DesignerClosed(const Designer: IDesigner;
//  AGoingDormant: Boolean);
//begin
//  inherited;
//  Close;
//end;

procedure TfrmEditWindow.DoRemoveItem;
var
  Item: TSpkBaseItem;
  index: Integer;
  Node: TMyTreeViewItem;
  Pane: TSpkPane;
  NextNode: TMyTreeViewItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := TMyTreeViewItem(tvStructure.Selected);
  if not (CheckValidItemNode(Node)) then
    raise Exception.Create('TfrmEditWindow.aRemoveItemExecute: Uszkodzona struktura drzewa!');
  Item := TSpkBaseItem(Node.Data.AsObject);
  Pane := TSpkPane(Node.ParentItem.Data.AsObject);
  index := Pane.Items.IndexOf(Item);
  if index = -1 then
    raise exception.create('TfrmEditWindow.aRemoveItemExecute: Uszkodzona struktura drzewa!');

  if Node.getPrevSibling <> nil then
    NextNode := Node.getPrevSibling
  else if Node.GetNextSibling <> nil then
    NextNode := Node.getNextSibling
  else
    NextNode := TMyTreeViewItem(Node.ParentItem);

  Pane.Items.Delete(index);

//  FDesigner.DeleteSelection(True);
  FDesigner.Modified;


  tvStructure.RemoveObject(Node);
  NextNode.Select;//ed := true;
  CheckActionsAvailability;
end;

procedure TfrmEditWindow.DoRemovePane;
var
  Pane: TSpkPane;
  NextNode: TMyTreeViewItem;
  index: Integer;
  Node: TMyTreeViewItem;
  Tab: TSpkTab;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := TMyTreeViewItem(tvStructure.Selected);
  if not (CheckValidPaneNode(Node)) then
    raise exception.create('TfrmEditWindow.aRemovePaneExecute: Uszkodzona struktura drzewa!');
  Pane := TSpkPane(Node.Data.AsObject);
  Tab := TSpkTab(Node.ParentItem.Data.AsObject);
  index := Tab.Panes.IndexOf(Pane);
  if index = -1 then
    raise Exception.create('TfrmEditWindow.aRemovePaneExecute: Uszkodzona struktura drzewa!');

  if Node.GetPrevSibling <> nil then
    NextNode := Node.GetPrevSibling
  else if Node.GetNextSibling <> nil then
    NextNode := Node.GetNextSibling
  else
    NextNode := TMyTreeViewItem(Node.ParentItem);

  Tab.Panes.Delete(index);

//  FDesigner.DeleteSelection(True);
  FDesigner.Modified;

  tvStructure.RemoveObject(Node);
  NextNode.Select;
  CheckActionsAvailability;
end;

procedure TfrmEditWindow.DoRemoveTab;
var
  Node: TMyTreeViewItem;
  Tab: TSpkTab;
  index: Integer;
  NextNode: TMyTreeViewItem;
  DesignObj: IDesignObject;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := TMyTreeViewItem(tvStructure.Selected);
  if not (CheckValidTabNode(Node)) then
    raise exception.create('TfrmEditWindow.aRemoveTabExecute: Uszkodzona struktura drzewa!');
  Tab := TSpkTab(Node.Data.AsObject);
  index := FToolbar.Tabs.IndexOf(Tab);
  if index = -1 then
    raise exception.create('TfrmEditWindow.aRemoveTabExecute: Uszkodzona struktura drzewa!');

//  if Node.GetPrevSibling <> nil then
//    NextNode := Node.GetPrevSibling
//  else if Node.GetNextSibling <> nil then
//    NextNode := Node.GetNextSibling
//  else
//    NextNode := nil;

  FToolbar.Tabs.Delete(index);

//  FDesigner.DeleteSelection(True);
  FDesigner.Modified;

  tvStructure.RemoveObject(Node);
  Dec(index);
  if index >= 0 then
    if (tvStructure.Count > 0) and (tvStructure.Count - 1 > index) then
      tvStructure.Items[index].Select
    else if (tvStructure.Count > 0) then
      tvStructure.Items[0].Select;

  CheckActionsAvailability;

//  if assigned(NextNode) then
//  begin
//    // Zdarzenie OnChange wyzwoli aktualizacjê zaznaczonego obiektu w
//    // Object Inspectorze
////    NextNode.Selected := true;
//    NextNode.Select;
//    CheckActionsAvailability;
//  end
//  else
//  begin
//    // Nie ma ju¿ ¿adnych obiektów na liœcie, ale coœ musi zostaæ wyœwietlone w
//    // Object Inspectorze - wyœwietlamy wiêc samego toolbara (w przeciwnym
//    // wypadku IDE bêdzie próbowa³o wyœwietliæ w Object Inspectorze w³aœciwoœci
//    // w³aœnie zwolnionego obiektu, co skoñczy siê, powiedzmy, niezbyt mi³o)
////    DesignObj := PersistentToDesignObject(FToolbar);
////    FDesigner.SelectComponent(FToolbar);
//    CheckActionsAvailability;
//  end;
end;

procedure TfrmEditWindow.BuildTreeData;
var
  i: Integer;
  panenode: TMyTreeViewItem;
  j: Integer;
  tabnode: TMyTreeViewItem;
  k: Integer;
  itemnode: TMyTreeViewItem;
  Obj: TSpkBaseItem;
  s: string;
begin
  Caption := 'Editing TSpkToolbar contents';
  tvStructure.Clear;

  if (FToolbar <> nil) and (FDesigner <> nil) then
  begin
    if FToolbar.Tabs.Count > 0 then
      for i := 0 to FToolbar.Tabs.Count - 1 do
      begin
        tabnode := TMyTreeViewItem.Create(nil);
        tabnode.Text := FToolbar.Tabs[i].Caption;
        tvStructure.AddObject(tabnode);
        tabnode.ImageIndex := 0;
//        tabnode.SelectedIndex := 0;
        tabnode.Data := FToolbar.Tabs[i];
        if FToolbar.Tabs[i].Panes.Count > 0 then
          for j := 0 to FToolbar.Tabs.Items[i].Panes.Count - 1 do
          begin
            panenode := TMyTreeViewItem.Create(nil);
            panenode.Text := FToolbar.Tabs[i].Panes[j].Caption;
            tabnode.AddObject(panenode);
            panenode.ImageIndex := 1;
//            panenode.SelectedIndex := 1;
            panenode.Data := FToolbar.Tabs[i].Panes[j];
            if FToolbar.Tabs[i].Panes[j].Items.Count > 0 then
              for k := 0 to FToolbar.Tabs[i].Panes[j].Items.Count - 1 do
              begin
                Obj := FToolbar.Tabs[i].Panes[j].Items[k];
                s := GetItemCaption(Obj);
                itemnode := TMyTreeViewItem.Create(nil);
                itemnode.Text := s;
                panenode.AddObject(itemnode);
                itemnode.Imageindex := 2;
//                itemnode.Selectedindex := 2;
                itemnode.Data := Obj;
              end;
          end;
      end;
  end;

//  if tvStructure.Count > 0 then
//    tvStructure.Items[0].Selected := true;
  CheckActionsAvailability;
end;

procedure TfrmEditWindow.RefreshNames;
var
  tabnode, panenode, itemnode: TMyTreeViewItem;
  Obj: TSpkBaseItem;
  s: string;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  if tvStructure.Count > 0 then
    tabnode := TMyTreeViewItem(tvStructure.Items[0]);
  while tabnode <> nil do
  begin
    if not (CheckValidTabNode(tabnode)) then
      raise exception.create('TfrmEditWindow.RefreshNames: Uszkodzona struktura drzewa!');

    tabnode.Text := TSpkTab(tabnode.Data.AsObject).Caption;

    panenode := tabnode.getFirstChild;
    while panenode <> nil do
    begin
      if not (CheckValidPaneNode(panenode)) then
        raise exception.create('TfrmEditWindow.RefreshNames: Uszkodzona struktura drzewa!');

      panenode.Text := TSpkPane(panenode.Data.AsObject).Caption;

      itemnode := panenode.getFirstChild;
      while itemnode <> nil do
      begin
        if not (CheckValidItemNode(itemnode)) then
          raise exception.create('TfrmEditWindow.RefreshNames: Uszkodzona struktura drzewa!');

        Obj := TSpkBaseItem(itemnode.Data.AsObject);
        s := GetItemCaption(Obj);

        itemnode.Text := s;

        itemnode := itemnode.getNextSibling;
      end;

      panenode := panenode.getNextSibling;
    end;

    tabnode := tabnode.getNextSibling;
  end;
end;

procedure TfrmEditWindow.tvStructureChange(Sender: TObject);
var
  Obj: TObject;
  Tab: TSpkTab;
  Pane: TSpkPane;
  Item: TSpkBaseItem;
  DesignObj : IDesignObject;
  index: integer;
  node: TMyTreeViewItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  node := TMyTreeViewItem(tvStructure.Selected);

  if assigned(node) and (node.Data.IsObject) then
  begin
    Obj := TObject(node.Data.AsObject);

    if Obj = nil then
      raise exception.create('TfrmEditWindow.tvStructureChange: Nieprawid³owe dane w ga³êzi!');

    if Obj is TSpkTab then
    begin
      Tab := Obj as TSpkTab;
      DesignObj:=PersistentToDesignObject(Tab);
      FDesigner.SelectComponent(DesignObj);

      index := FToolbar.Tabs.IndexOf(Tab);
      if index = -1 then
        raise exception.create('TfrmEditWindow.tvStructureChange: Uszkodzona struktura drzewa!');
      FToolbar.TabIndex := index;
    end
    else if Obj is TSpkPane then
    begin
      Pane := Obj as TSpkPane;
      DesignObj:=PersistentToDesignObject(Pane);
      FDesigner.SelectComponent(DesignObj);

      if not (CheckValidPaneNode(node)) then
        raise exception.create('TfrmEditWindow.tvStructureChange: Uszkodzona struktura drzewa!');

      Tab := TSpkTab(node.ParentItem.Data.AsObject);

      index := FToolbar.Tabs.IndexOf(Tab);
      if index = -1 then
        raise exception.create('TfrmEditWindow.tvStructureChange: Uszkodzona struktura drzewa!');
      FToolbar.TabIndex := index;
    end
    else if Obj is TSpkBaseItem then
    begin
      Item := Obj as TSpkBaseItem;
      DesignObj:=PersistentToDesignObject(Item);
      FDesigner.SelectComponent(DesignObj);

      if not (CheckValidItemNode(node)) then
        raise exception.create('TfrmEditWindow.tvStructureChange: Uszkodzona struktura drzewa!');

      Tab := TSpkTab(node.ParentItem.ParentItem.Data.AsObject);

      index := FToolbar.Tabs.IndexOf(Tab);
      if index = -1 then
        raise exception.create('TfrmEditWindow.tvStructureChange: Uszkodzona struktura drzewa!');
      FToolbar.TabIndex := index;
    end
    else
      raise exception.create('TfrmEditWindow.tvStructureChange: Nieprawid³owy obiekt podwieszony pod ga³êzi¹!');
  end
  else
  begin
    DesignObj:=PersistentToDesignObject(FToolbar);
    FDesigner.SelectComponent(DesignObj);
  end;

  CheckActionsAvailability;
end;

procedure TfrmEditWindow.tvStructureEdited(Sender: TObject; Node: TTreeViewItem; var S: string);
var
  Tab: TSpkTab;
  Pane: TSpkPane;
  Item: TSpkBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Node.Data.AsObject = nil then
    raise exception.create('TfrmEditWindow.tvStructureEdited: Uszkodzona struktura drzewa!');

  if TObject(Node.Data.AsObject) is TSpkTab then
  begin
    Tab := TObject(Node.Data.AsObject) as TSpkTab;
    Tab.Caption := S;

    FDesigner.Modified;
  end
  else if TObject(Node.Data.AsObject) is TSpkPane then
  begin
    Pane := TObject(Node.Data.AsObject) as TSpkPane;
    Pane.Caption := S;

    FDesigner.Modified;
  end
  else if TObject(Node.Data.AsObject) is TSpkBaseItem then
  begin
    Item := TObject(Node.Data.AsObject) as TSpkBaseItem;
    SetItemCaption(Item, S);

    FDesigner.Modified;
  end
  else
    raise exception.create('TfrmEditWindow.tvStructureEdited: Uszkodzona struktura drzewa!');
end;

procedure TfrmEditWindow.tvStructureKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin

  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Key = VKDELETE then
  begin
    if tvStructure.Selected <> nil then
    begin
      // Sprawdzamy, jakiego rodzaju obiekt jest zaznaczony - wystarczy
      // przetestowaæ typ podwieszonego obiektu.
      if TObject(tvStructure.Selected.Data.AsObject) is TSpkTab then
      begin
        DoRemoveTab;
      end
      else if TObject(tvStructure.Selected.Data.AsObject) is TSpkPane then
      begin
        DoRemovePane;
      end
      else if TObject(tvStructure.Selected.Data.AsObject) is TSpkBaseItem then
      begin
        DoRemoveItem;
      end
      else
        raise exception.create('TfrmEditWindow.tvStructureKeyDown: Uszkodzona struktura drzewa!');
    end;
  end;
end;

function TfrmEditWindow.ValidateTreeData: boolean;
var
  i: Integer;
  TabsValid: Boolean;
  TabNode: TMyTreeViewItem;
  j: Integer;
  PanesValid: Boolean;
  PaneNode: TMyTreeViewItem;
  k: Integer;
  ItemsValid: Boolean;
  ItemNode: TMyTreeViewItem;
begin
  result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  i := 0;
  TabsValid := true;
  if tvStructure.Count > 0 then
    TabNode := TMyTreeViewItem(tvStructure.Items[0]);

  if not TabNode.Data.IsObject then
    Exit;

  while (i < FToolbar.Tabs.Count) and TabsValid do
  begin
    TabsValid := TabsValid and (TabNode <> nil);

    if TabsValid then
      TabsValid := TabsValid and (TabNode.Data.AsObject = FToolbar.Tabs[i]);

    if TabsValid then
    begin
      j := 0;
      PanesValid := true;
      PaneNode := TabNode.GetFirstChild;

      while (j < FToolbar.Tabs[i].Panes.Count) and PanesValid do
      begin
        PanesValid := PanesValid and (PaneNode <> nil);

        if PanesValid then
          PanesValid := PanesValid and (PaneNode.Data.AsObject = FToolbar.Tabs[i].Panes[j]);

        if PanesValid then
        begin
          k := 0;
          ItemsValid := true;
          ItemNode := PaneNode.GetFirstChild;

          while (k < FToolbar.Tabs[i].Panes[j].Items.Count) and ItemsValid do
          begin
            ItemsValid := ItemsValid and (ItemNode <> nil);

            if ItemsValid then
              ItemsValid := ItemsValid and (ItemNode.Data.AsObject = FToolbar.Tabs[i].Panes[j].Items[k]);

            if ItemsValid then
            begin
              inc(k);
              ItemNode := ItemNode.GetNextSibling;
            end;
          end;

                  // Wa¿ne! Trzeba sprawdziæ, czy w drzewie nie ma dodatkowych
                  // elementów!
          ItemsValid := ItemsValid and (ItemNode = nil);

          PanesValid := PanesValid and ItemsValid;
        end;

        if PanesValid then
        begin
          inc(j);
          PaneNode := PaneNode.GetNextSibling;
        end;
      end;

         // Wa¿ne! Trzeba sprawdziæ, czy w drzewie nie ma dodatkowych
         // elementów!
      PanesValid := PanesValid and (PaneNode = nil);

      TabsValid := TabsValid and PanesValid;
    end;

    if TabsValid then
    begin
      inc(i);
      if i < tvStructure.Count then
        TabNode := TMyTreeViewItem(tvStructure.Items[i])
      else
        TabNode := nil;
    end;
  end;

// Wa¿ne! Trzeba sprawdziæ, czy w drzewie nie ma dodatkowych
// elementów!
  TabsValid := TabsValid and (TabNode = nil);

  result := TabsValid;
end;

{ TMyTreeViewItem }

function TMyTreeViewItem.GetData: TValue;
begin
  Result := FData;
end;

function TMyTreeViewItem.getFirstChild: TMyTreeViewItem;
begin
  if Count > 0 then
    Result := TMyTreeViewItem(Items[0])
  else
    Result := nil;
end;

function TMyTreeViewItem.GetFirstNode: TMyTreeViewItem;
var
  pi: TMyTreeViewItem;
  idx: Integer;
begin
//   Idx := Self.GlobalIndex;
//   if TreeView.GlobalCount > 0 then
//    if idx > 0 then
//        Result := TreeView.ItemByGlobalIndex(Idx - 1)
//      else
//        Result := TreeView.ItemByGlobalIndex(0);
  Result := nil;

  if ParentItem = nil then
    Exit;

  if ParentItem <> nil then
    if ParentItem.Count > 0 then
      Result := TMyTreeViewItem(ParentItem.Items[0]);

end;

function TMyTreeViewItem.getNextSibling: TMyTreeViewItem;
begin
  Result := nil;
  if ParentItem = nil then
    Exit;

  if ParentItem.Count - 1 > index then
    Result := TMyTreeViewItem(ParentItem.Items[index + 1]);

end;

function TMyTreeViewItem.GetPrevSibling: TMyTreeViewItem;
begin
  Result := nil;
  if ParentItem = nil then
    Exit;

  if (index > 0) and (index <= ParentItem.Count - 1) then
    Result := TMyTreeViewItem(ParentItem.Items[index - 1]);
end;

procedure TMyTreeViewItem.SetData(const Value: TValue);
begin
  FData := Value;
end;

{ IDesigner }

//procedure IDesigner.Modified;
//begin
////
//end;
//
//procedure IDesigner.SelectComponent(Component: TComponent);
//begin
////
//end;

{ IDesigner }

//procedure IDesigner.Modified;
//begin
////
//end;
//
////procedure IDesigner.SelectComponent(Component: TComponent);
////begin
//////
////end;
//
//procedure IDesigner.SelectComponent(Component: IDesignObject);
//begin
////
//end;

initialization

finalization

  if Assigned(frmEditWindow) then
    frmEditWindow.Free;

  if Assigned(Watcher) then
    Watcher.Free;

end.

