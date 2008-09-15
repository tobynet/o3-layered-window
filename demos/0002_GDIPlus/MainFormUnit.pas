unit MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, O3LayeredWindowUnit, StdCtrls, pngimage, ExtCtrls, Menus;

type
  TMainForm = class(TForm)
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    PopupMenu1: TPopupMenu;
    tetst1: TMenuItem;
    mag1: TMenuItem;
    foobar1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private êÈåæ }
//    FBackGroundBMP: TBitmap;
    FLayeredWindow: TO3LayeredWindow;
  public
    { Public êÈåæ }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}
const
  ImageSourceFileName = '..\images\coolBG0001.png';

procedure TMainForm.Button1Click(Sender: TObject);
begin
  FLayeredWindow.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FLayeredWindow := TO3LayeredWindow.Create(Self);
  FLayeredWindow.Parent := Self;

{
  Load and draw bitmap...
}

  FLayeredWindow.UpdateLayer;
end;

procedure TMainForm.FormDblClick(Sender: TObject);
begin
  ShowMessage('double clicked!!');
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
    Ord('E'): begin
      if FLayeredWindow.Enabled then begin
        FLayeredWindow.Enabled := False;
        BorderStyle := bsSizeable;
        Brush.Style := bsSolid;
        RedrawWindow(Self.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN);
      end
      else begin
        FLayeredWindow.Enabled := True;
      end;

    end;
  end;
end;

end.
