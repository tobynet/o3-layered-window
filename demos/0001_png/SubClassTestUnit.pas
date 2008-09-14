unit SubClassTestUnit;

{
SubClass Test...

ウィンドウハンドルを大捏造
http://www.psn.ne.jp/~nagayama/program/0017.html
}

interface
uses
  classes, windows, messages, controls, shellapi, forms, sysutils;

type
  TMouseHook = class(TComponent)
    private
      FOldWndProc: Pointer;
      FNewWndProc: Pointer;
      FWndHandle : HWND;
      FEnabled   : Boolean;

      procedure WndProc( var Msg:TMessage ); virtual;

    public
      constructor Create(AOwner:TComponent); override;
      destructor Destroy; override;
      procedure DoubleClick( KeyFlag:Integer; X,Y:LongInt);

    published
      property Enabled:Boolean read FEnabled write FEnabled default True;
  end;


implementation

{ TMouseHook }

constructor TMouseHook.Create(AOwner: TComponent);
begin
  inherited;
  FEnabled := True;

  FWndHandle  := (AOwner as TWinControl).Handle;
  FNewWndProc := Classes.MakeObjectInstance(WndProc);
  FOldWndProc := Pointer(SetWindowLong(FWndHandle, GWL_WNDPROC,LongInt(FNewWndProc)));
end;

destructor TMouseHook.Destroy;
begin
  SetWindowLong(FWndHandle, GWL_WNDPROC, LongInt(FOldWndProc));

  inherited;
end;

procedure TMouseHook.DoubleClick(KeyFlag: Integer; X,Y:LongInt);
var
  Str: String;
begin
  Str := '('+IntToStr(X)+','+IntToStr(Y)+')';
  Application.MessageBox(PChar(Str),'',MB_ICONINFORMATION);
end;

procedure TMouseHook.WndProc( var Msg:TMessage );
begin
  with Msg do begin
    if (Msg=WM_LBUTTONDBLCLK) and (Enabled) then begin
      try
        DoubleClick(wParam, Loword(lParam), HiWord(lParam));
      except
        Application.HandleException(Self);
      end;
    end else
      Result := CallWindowProc(FOldWndProc, FWndHandle, Msg, wParam, lParam);
  end;
end;

end.

