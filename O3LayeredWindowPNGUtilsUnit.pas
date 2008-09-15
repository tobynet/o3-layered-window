{-----------------------------------------------------------------------------
 Unit Name: O3LayeredWindowUnit
 Author:    TOBY (http://tobysoft.net/)
 Date:      16-9-2008
 Purpose:   PNG(pngimage) support utils for TO3LayeredWindow
 History:
 License:
  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/MPL-1.1.html

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the
  License.

  Alternatively, the contents of this file may be used under the terms of
  the GNU Lesser General Public License (the  "LGPL License"), in which case
  the provisions of the LGPL License are applicable instead of those above.
  If you wish to allow use of your version of this file only under the terms
  of the LGPL License and not to allow others to use your version of this
  file under the MPL, indicate your decision by deleting the provisions
  above and replace them with the notice and other provisions required by
  the LGPL License. If you do not delete the provisions above, a recipient
  may use your version of this file under either the MPL or the LGPL License.

  For more information about the LGPL:
  http://www.gnu.org/copyleft/lesser.html
-----------------------------------------------------------------------------}
unit O3LayeredWindowPNGUtilsUnit;

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
