program SimpleTextEdit;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Types,
  Unit1 in 'Unit1.pas' {SimpleEditor},
  Unit2 in 'Unit2.pas' {CodeForm};

{$R *.res}

begin
//  GlobalUseDirect2D:=false;
//  GlobalUseGDIPlusClearType := true;
  Application.Initialize;
  Application.CreateForm(TSimpleEditor, SimpleEditor);
  Application.CreateForm(TCodeForm, CodeForm);
  Application.Run;
end.
