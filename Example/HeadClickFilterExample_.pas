unit HeadClickFilterExample_;

// Example of use data filtering instead of search in database
// Client-side filtering on dataset is used
// Columns in TDBGrid in example must be defined
// because refresh on TClientDataset is very demanding for data source
// and, consequently, Close and Open method only works here
// On other types of datasets Refresh is enough
//
//    in DBGrid1TitleClick

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, Grids, DBGrids, ExtCtrls
  , OLMHeadClickFilter, Provider, xmldom, Xmlxform
  ;

type
  TForm1 = class(TForm)
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ClientDataSet1FilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure DBGrid1TitleClick(Column: TColumn);
  private
    fFilter:THeadClickFilter;
    procedure Populate1Execute(Sender: TObject);
    procedure SetFilter;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientDataSet1.FieldDefs.Add('ID', ftInteger, 0, True);
  ClientDataSet1.FieldDefs.Add('Name', ftString, 20, True);
  ClientDataSet1.FieldDefs.Add('Date', ftDateTime, 0, True);
  ClientDataSet1.FieldDefs.Add('Salary', ftCurrency, 0, True);
  ClientDataSet1.CreateDataSet;

  Populate1Execute(self);
  SetFilter();
end;

procedure TForm1.Populate1Execute(Sender: TObject);
const
 FirstNames: array[0 .. 19] of string = ('John', 'Sarah', 'Fred', 'Beth',
 'Eric', 'Tina', 'Thomas', 'Judy', 'Robert', 'Angela', 'Tim', 'Traci',
 'David', 'Paula', 'Bruce', 'Jessica', 'Richard', 'Carla', 'James',
 'Mary');
 LastNames: array[0 .. 11] of string = ('Parker', 'Johnson', 'Jones',
 'Thompson', 'Smith', 'Baker', 'Wallace', 'Harper', 'Parson', 'Edwards',
 'Mandel', 'Stone');
var
 Index: Integer;

begin
 RandSeed := 0;

 ClientDataSet1.DisableControls;
 try
   ClientDataSet1.EmptyDataSet;
   for Index := 1 to Length(FirstNames) do begin
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('ID').AsInteger := Index;
    ClientDataSet1.FieldByName('Name').AsString := FirstNames[Random(20)] + ' ' +
    LastNames[Random(12)];
    ClientDataSet1.FieldByName('Date').AsDateTime := Now() -10.0 +  Random(20);
    ClientDataSet1.FieldByName('Salary').AsFloat := 20000.0 + Random(600) * 100;
    ClientDataSet1.Post;
   end;
   ClientDataSet1.First;
 finally
   ClientDataSet1.EnableControls;
 end;

end;

procedure TForm1.SetFilter();
var
  aDateFields:TStringList;
begin
   if  fFilter=nil then begin
       fFilter := THeadclickFilter.Create(self);
       fFilter.Grid := DBGrid1;
       aDateFields:=TStringList.Create();
       try
         aDateFields.Add('Date');
         fFilter.FieldsOfData:= aDateFields;
       finally
          aDateFields.Free;
       end
   end;
end;

procedure TForm1.ClientDataSet1FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept:=true;
  if fFilter<>nil then begin
     fFilter.FilterRecord(DataSet,Accept);
  end;
end;

procedure TForm1.DBGrid1TitleClick(Column: TColumn);
begin
   if fFilter<>nil then begin
      fFilter.TitleClick(Column);
   end;

   // for TClientDataset fields better to be defined in TDBGrid
   ClientDataset1.Close;
   ClientDataset1.Open;


end;

end.
