object fListFltr: TfListFltr
  Left = 786
  Top = 94
  Width = 267
  Height = 106
  Caption = 'fListFltr'
  Color = clBtnFace
  Constraints.MaxHeight = 106
  Constraints.MinHeight = 106
  Constraints.MinWidth = 267
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 259
    Height = 13
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label1'
  end
  object ComboBox1: TComboBox
    Left = 0
    Top = 16
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'ComboBox1'
  end
  object bbOK: TBitBtn
    Left = 8
    Top = 48
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object bbCancel: TBitBtn
    Left = 184
    Top = 48
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object bbNo: TBitBtn
    Left = 88
    Top = 48
    Width = 89
    Height = 25
    TabOrder = 3
    Kind = bkAll
  end
end
