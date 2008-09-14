object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'png demo'
  ClientHeight = 283
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 40
    Top = 24
    Width = 75
    Height = 25
    Caption = 'ON!!'
    TabOrder = 0
    OnClick = Button1Click
  end
  object RadioGroup1: TRadioGroup
    Left = 40
    Top = 72
    Width = 137
    Height = 105
    Caption = 'RadioGroup1'
    Items.Strings = (
      'test'
      'mgoe'
      'mage')
    TabOrder = 1
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 48
    object tetst1: TMenuItem
      Caption = 'tset'
    end
    object mag1: TMenuItem
      Caption = 'mag'
    end
    object foobar1: TMenuItem
      Caption = 'foobar'
    end
  end
end
