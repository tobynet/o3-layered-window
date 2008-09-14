unit O3LayeredWindowPNGUtilsUnit;

{
  PNG support utils for TO3LayeredWindow
}

interface

uses Graphics, SysUtils, pngimage;

procedure PNGBitmapToSurface(Surface: TBitmap; PNGBitmap: TPNGObject);
procedure LoadPNGToSurface(Surface: TBitmap; FileName: string);

implementation

procedure PNGBitmapToSurface(Surface: TBitmap; PNGBitmap: TPNGObject);
var x, y: Integer;
  pDest, pSrc, pAlpha: PByteArray;
  Alpha: Byte;
begin
  Surface.SetSize(PNGBitmap.Width, PNGBitmap.Height);

  with Surface do
    for y := 0 to Height - 1 do begin
      pSrc := PNGBitmap.Scanline[y];
      pAlpha := PNGBitmap.AlphaScanline[y];
      pDest := ScanLine[y];
      for x := 0 to Width - 1 do begin
        if pAlpha = nil then
          Alpha := 255
        else
          Alpha := pAlpha[x];

        pDest[x * 4 + 0] := pSrc[x * 3 + 0] * Alpha div 255;
        pDest[x * 4 + 1] := pSrc[x * 3 + 1] * Alpha div 255;
        pDest[x * 4 + 2] := pSrc[x * 3 + 2] * Alpha div 255;
        pDest[x * 4 + 3] := Alpha;
      end;
    end;
end;

procedure LoadPNGToSurface(Surface: TBitmap; FileName: string);
var PNGBitmap: TPNGObject;
begin
  PNGBitmap := TPNGObject.Create;
  try
    PNGBitmap.LoadFromFile(FileName);
    PNGBitmapToSurface(Surface, PNGBitmap);
  finally
    FreeAndNil(PNGBitmap);
  end;
end;


end.
