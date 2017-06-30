object fCldFltr: TfCldFltr
  Left = 704
  Top = 176
  Width = 384
  Height = 269
  Caption = 'fCldFltr'
  Color = clBtnFace
  Constraints.MinHeight = 269
  Constraints.MinWidth = 384
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 199
    Width = 376
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Panel1: TPanel
    Left = 0
    Top = 202
    Width = 376
    Height = 33
    Align = alBottom
    TabOrder = 0
    object bbOK: TBitBtn
      Left = 8
      Top = 4
      Width = 105
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Kind = bkOK
    end
    object bbCancel: TBitBtn
      Left = 240
      Top = 4
      Width = 105
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Kind = bkCancel
    end
    object bbNO: TBitBtn
      Left = 128
      Top = 4
      Width = 105
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Kind = bkAll
    end
  end
end
