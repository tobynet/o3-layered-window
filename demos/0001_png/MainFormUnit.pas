unit MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, O3LayeredWindowUnit, StdCtrls, pngimage, ExtCtrls;

type
  TMainForm = class(TForm)
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Private êÈåæ }
    FLayeredWindow: TO3LayeredWindow;
  public
    { Public êÈåæ }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses SubClassTestUnit;
const
  ImageSourceFileName = '..\images\coolBG0001.png';



procedure TMainForm.Button1Click(Sender: TObject);
begin
  FLayeredWindow.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);

  procedure LoadPNG();
    procedure PNGBitmapToSurface(PNGBitmap: TPNGObject);
    var x, y: Integer;
      pDest, pSrc, pAlpha: PByteArray;
      Alpha: Byte;
    begin
      FLayeredWindow.Surface.SetSize(PNGBitmap.Width, PNGBitmap.Height);

      with FLayeredWindow.Surface do
        for y := 0 to Height - 1 do begin
          pSrc := PNGBitmap.Scanline[y];
          pAlpha := PNGBitmap.AlphaScanline[y];
          pDest := ScanLine[y];
          for x := 0 to Width - 1 do begin
            if pAlpha = nil then
              Alpha := 255
            else
              Alpha := pAlpha[x];

//            Alpha := 255;
            pDest[x * 4 + 0] := pSrc[x * 3 + 0] * Alpha div 255;
            pDest[x * 4 + 1] := pSrc[x * 3 + 1] * Alpha div 255;
            pDest[x * 4 + 2] := pSrc[x * 3 + 2] * Alpha div 255;
            pDest[x * 4 + 3] := Alpha;
          end;
        end;
    end;
  var PNGBitmap: TPNGObject;
  begin
    PNGBitmap := TPNGObject.Create;
    try
      PNGBitmap.LoadFromFile(ImageSourceFileName);
      PNGBitmapToSurface(PNGBitmap);
    finally
      FreeAndNil(PNGBitmap);
    end;
  end;
begin
  TMouseHook.Create(Self);

{
  FLayeredWindow := TO3LayeredWindow.Create(Self);
  FLayeredWindow.Parent := Self;

  LoadPNG;
  FLayeredWindow.UpdateLayer;
}

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

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
{
  if ssLeft in Shift then begin
    ReleaseCapture;
    SendMessage(Handle, WM_SYSCOMMAND, SC_MOVE or 2, MakeLong(X, Y));
  end;
}
end;

end.
