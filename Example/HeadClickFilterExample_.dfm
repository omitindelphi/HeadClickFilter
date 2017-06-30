object Form1: TForm1
  Left = 192
  Top = 114
  Width = 621
  Height = 413
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 613
    Height = 338
    Align = alClient
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnTitleClick = DBGrid1TitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Date'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Salary'
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 338
    Width = 613
    Height = 41
    Align = alBottom
    Caption = 'Click on header permits filtering by substring or date'
    TabOrder = 1
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    OnFilterRecord = ClientDataSet1FilterRecord
    Left = 144
    Top = 80
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 168
    Top = 56
  end
end
