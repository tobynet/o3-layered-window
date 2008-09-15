unit MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, O3LayeredWindowUnit;

type
  TMainForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FLayeredWindow: TO3LayeredWindow;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FLayeredWindow := TO3LayeredWindow.Create(Self);
  FLayeredWindow.Parent := Self;
  FLayeredWindow.Enabled := False;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Close;
  end;
end;

end.
