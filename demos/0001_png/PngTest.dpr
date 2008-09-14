program PngTest;

uses
  Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  O3LayeredWindowUnit in '..\..\O3LayeredWindowUnit.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
