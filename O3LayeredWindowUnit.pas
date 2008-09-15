{-----------------------------------------------------------------------------
 Unit Name: O3LayeredWindowUnit
 Author:    TOBY (http://tobysoft.net/)
 Date:      16-9-2008
 Purpose:   Layered Window Library for Delphi
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


unit O3LayeredWindowUnit;

interface

uses
  Windows, Messages, SysUtils, Graphics, Classes, Controls, Forms;

const
  MaxAlpha = 255;
type
  EO3LayeredWindow = class(Exception);

  TO3LayeredWindow = class(TGraphicControl)
  protected
    FAlpha: Byte;
    FSurface: TBitmap;  // 32bit bitmap
    FNewWndProc,
    FOrgWndProc: Pointer;
    FOwner: TWinControl;
    FOwnerHandle: THandle;

    procedure WndMethod(var Msg: TMessage);

    procedure SetSurface(const Value: TBitmap);
    procedure SetAlpha(const Value: Byte);
    procedure SetEnabled(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure UpdateLayer; virtual;
  published
    property Surface: TBitmap read FSurface write SetSurface;
    property Alpha: Byte read FAlpha write SetAlpha default MaxAlpha;
    property Enabled: Boolean read GetEnabled write SetEnabled default True;
  end;

implementation

{ TO3LayeredWindow }

constructor TO3LayeredWindow.Create(AOwner: TComponent);
begin
  inherited;

  FSurface := TBitmap.Create;
  FSurface.HandleType := bmDIB;
  FSurface.PixelFormat := pf32bit;

  FAlpha := MaxAlpha;

  FOwner := (AOwner as TWinControl);
  FOwnerHandle := FOwner.Handle;

  FNewWndProc := Classes.MakeObjectInstance(WndMethod);
  if FNewWndProc <> nil then
    FOrgWndProc := Pointer(SetWindowLong(FOwnerHandle,
      GWL_WNDPROC, Longint(FNewWndProc)));
end;

destructor TO3LayeredWindow.Destroy;
begin
  if (FOrgWndProc <> nil) and (FOwner <> nil) then begin
    SetWindowLong(FOwnerHandle, GWL_WNDPROC, Longint(FOrgWndProc));
    Classes.FreeObjectInstance(FNewWndProc);
  end;
  FreeAndNil(FSurface);
  inherited;
end;

procedure TO3LayeredWindow.SetAlpha(const Value: Byte);
begin
  FAlpha := Value;
//  UpdateLayer;
end;

procedure TO3LayeredWindow.SetEnabled(Value: Boolean);
begin
  inherited;
  if GetEnabled then
    UpdateLayer
  else
    SetWindowLong(FOwner.Handle, GWL_EXSTYLE,
      GetWindowLong(FOwner.Handle, GWL_EXSTYLE) and (not WS_EX_LAYERED));
end;

procedure TO3LayeredWindow.SetSurface(const Value: TBitmap);
begin
  FSurface.Assign(Value);
end;

procedure TO3LayeredWindow.UpdateLayer;
var
  BlendFunction: TBlendFunction;
  ZeroPosition: TPoint;
  FormSize: TSize;
begin
  if FOwner is TForm then begin
    with TForm(FOwner) do begin
      BorderStyle := bsNone;
    end;
  end;

  SetWindowLong(FOwner.Handle, GWL_EXSTYLE,
    GetWindowLong(FOwner.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);

  with BlendFunction do begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    SourceConstantAlpha := FAlpha;
    AlphaFormat := AC_SRC_ALPHA;
  end;

  ZeroPosition.x := 0;
  ZeroPosition.y := 0;
  FormSize.cx := FSurface.Width;
  FormSize.cy := FSurface.Height;

  Visible := False;

  if not UpdateLayeredWindow(
      FOwner.Handle, 0,
      nil,                      // if pallet is uncared, it's nil.
      @FormSize,                // form size
      FSurface.Canvas.Handle,   // DC of surface
      @ZeroPosition,            // start position for surface
      0, @BlendFunction, ULW_ALPHA) then begin
    raise EO3LayeredWindow.CreateFmt(
      'Error: Failed to UpdateLayeredWindow. Reason: "%s" at MakeLayer',
      [SysErrorMessage(GetLastError)]);
  end;

  inherited SetEnabled(True);
end;

procedure TO3LayeredWindow.WndMethod(var Msg: TMessage);

  procedure OnMouseMove(Shift: TShiftState; X, Y: Integer);
  begin
    if ssLeft in Shift then begin
      ReleaseCapture;
      SendMessage(FOwnerHandle, WM_SYSCOMMAND, SC_MOVE or 2, MakeLong(X, Y));
    end;
  end;
begin
  if Enabled and (Msg.Msg = WM_MOUSEMOVE) then begin
    with CalcCursorPos do
      OnMouseMove(KeysToShiftState(TWMMouseMove(Msg).Keys), X, Y);
  end;

  Msg.Result := CallWindowProc(
    FOrgWndProc, FOwnerHandle,
    Msg.Msg, Msg.WParam, Msg.LParam);
end;


end.

