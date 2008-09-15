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
    procedure tetst1Click(Sender: TObject);
  private
//    FBackGroundBMP: TBitmap;
    FLayeredWindow: TO3LayeredWindow;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}
uses GDIPAPI, GDIPOBJ, GDIPUTIL;
const
  BackGroundImageSourceFileName = '..\images\coolBG0001.png';
  LogoImageSourceFileName = '..\images\80s-logo.png';

procedure TMainForm.Button1Click(Sender: TObject);
begin
  FLayeredWindow.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Graphics: TGPGraphics;
  BackGroundImage: TGPImage;
  LogoImage: TGPImage;
begin
  FLayeredWindow := TO3LayeredWindow.Create(Self);
  FLayeredWindow.Parent := Self;


  // Load and draw bitmap...
  BackGroundImage := nil; Graphics := nil; LogoImage := nil;
  try
    BackGroundImage := TGPImage.Create(BackGroundImageSourceFileName);
    FLayeredWindow.Surface.SetSize(
      BackGroundImage.GetWidth, BackGroundImage.GetHeight);
    LogoImage := TGPImage.Create(LogoImageSourceFileName);

    Graphics := TGPGraphics.Create(FLayeredWindow.Surface.Canvas.Handle);
    Graphics.Clear(aclTransparent);
    Graphics.DrawImage(BackGroundImage, 0, 0);
    Graphics.DrawImage(LogoImage,
      0, 0);
//      (BackGroundImage.GetWidth - LogoImage.GetWidth) / 2,
//      (BackGroundImage.GetHeight - LogoImage.GetHeight) / 2);
  finally
    FreeAndNil(LogoImage); 
    FreeAndNil(BackGroundImage); 
    FreeAndNil(Graphics);
  end;

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

procedure TMainForm.tetst1Click(Sender: TObject);
begin
  Close;
end;

end.
