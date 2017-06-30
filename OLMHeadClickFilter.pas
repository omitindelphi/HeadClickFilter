unit OLMHeadClickFilter;
//------------------------------------------//
//      Oleg Mitine (Oleg Meeting)          //
//      June 2001                           //
//------------------------------------------//
interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB,DBGrids,
  Variants,
  LstFltrU,
  CldFltrU,
  CmnFltrU
  ;

type

  TFilterListSetFunc=procedure(Sender:TObject; Column:TColumn;
                               ListToChoose:TStrings) of object;

  THeadClickFilter = class(TComponent)
  private
    { Private declarations }
    fGrid:TDBGrid;
    fFieldList:TStrings;
    fFieldsOfData:TStrings;
    fFieldsOflist:TStrings;
    fOnFilterListSet:TFilterListSetFunc;
    procedure SetFieldList(Value:TStrings);
    procedure SetFieldsOfData(Value:TStrings);
    procedure SetFieldsOfList(Value:TStrings);
    function  GetF( index: integer):String;
    procedure PutF( index: integer; Value:String);
    function  ymdStrToDate(s:String):TDateTime;
    function  DateToymdStr(D:TDateTime):String;
    procedure UpperList(A:TStrings);

    procedure PushFreshString(A:TStrings; i:integer; var sSelected:string);
    // Restore filtered expression sSelected from i-th elem. of list of filter A
    // (if empty then creates it)
    procedure FiList(Column:TColumn; var sSelected:string);
    // User dialog : query of sSelected value from the list
    procedure FiDat(Column:TColumn; var sSelected:string);
    // User dialog : query of sSelected value for the data span
    procedure FiCmn(Column:TColumn; var sSelected:string);
    // User dialog : query of sSelected value for the substring
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy; override;
    procedure   TitleClick(Column: TColumn);
    procedure   FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    property    AllFields[Index:integer]:string read GetF write PutF ;default;
    procedure   Clear;
  published
    { Published declarations }
    property Grid:TDBGrid read fGrid write fGrid;
    property FieldList:TStrings read fFieldList write SetFieldList;
    property FieldsOfData:TStrings read fFieldsOfData write SetFieldsOfData;
    property FieldsOfList:TStrings read fFieldsOfList write SetFieldsOfList;
    property OnFilterListSet:TFilterListSetFunc read fOnFilterListSet
                                               write fOnFilterListSet;
  end;

implementation
uses OLM_FltrConst;

type
PStrObject=^TStrObject;
TStrObject=class(TObject)
public
  S:string;
end;

TStrStringList=class(TStringList)
public
  procedure Clear; override;
  procedure Delete(i:integer);override;
  destructor Destroy; override;
end;

procedure  TStrStringList.Delete(i:integer);
begin
  if Objects[i]<>nil then Objects[i].Free;
  inherited;
end;

procedure  TStrStringList.Clear;
begin
  while Count>0 do delete(0);
  inherited;
end;

destructor TStrStringList.Destroy;
begin
  Clear;
  inherited;
end;

constructor THeadClickFilter.Create(AOwner:TComponent);
begin
  inherited;
    fFieldList:=TStrStringList.Create;
    fFieldsOfData:=TStringList.Create;
    fFieldsOflist:=TStringList.Create;
end;

destructor  THeadClickFilter.Destroy;
begin

  fFieldList.Free;
  fFieldsOfData.Free;
  fFieldsOflist.Free;
  inherited;
end;

function  THeadClickFilter.ymdStrToDate(s:String):TDateTime;
var y,m,d:word; Z:TDateTime;
begin
  y:=StrToInt(copy(s,1,4));
  m:=StrToInt(copy(s,6,2));
  d:=StrToInt(copy(s,9,2));
  Z:=EncodeDate(y,m,d);
  Result:=Z;
end;

function  THeadClickFilter.DateToymdStr(D:TDateTime):String;
begin
 Result:=FormatDateTime('yyyy/mm/dd',D);
end;

procedure THeadClickFilter.UpperList(A:TStrings);
var i:integer;
begin
for i:=0 to A.Count-1 do
  begin
    A[i]:=AnsiUpperCase(A[i]);
  end;
end;

procedure THeadClickFilter.FiCmn(Column:TColumn; var sSelected:string);
var
    FiaName:String;
    fFlt:TfCmnFltr;
begin
  FiaName:=AnsiUpperCase(Column.Field.FieldName);
  fFlt:=TfCmnFltr.Create(Self);
  try
    fFlt.Edit1.Text:=sSelected;
    fFlt.Caption:=Format(sOLM_FilterFormCaption,[Column.Title.Caption]);
    fFlt.bbNo.Caption:=sOLM_AllButtonCaption;
    fFlt.bbCancel.Caption:=sOLM_CancelButtonCaption;
    case fFlt.ShowModal of
      mrOK: sSelected:=fFlt.Edit1.Text;
      mrAll: sSelected:='';
    end;
  finally
    fFlt.Free;
  end;
end;

procedure THeadClickFilter.FiDat(Column:TColumn; var sSelected:string);
var
    FiaName:String;
    D1,D2:TDateTime;
    fFlt:TfCldFltr;
begin
  UpperList(fFieldsOfData);
  D1:=0; D2:=0;
  FiaName:=AnsiUpperCase(Column.Field.FieldName);
  if sSelected<>'' then
    begin
      D1:=ymdStrToDate(copy(sSelected,1,10));
      D2:=ymdStrToDate(copy(sSelected,12,10));
    end;
  if (D1=0)or(D2=0) then
    begin
      D1:=Date; D2:=Date;
    end;
  fFlt:=TfCldFltr.Create(Self);
  try
    fFlt.Font:=fGrid.Font;
    fFlt.Dou.DateFirst:=D1;
    fFlt.Dou.DateLast:=D2;
    fFlt.Caption:=Format(sOLM_FilterFormCaption,[Column.Title.Caption]);
    fFlt.bbNo.Caption:=sOLM_AllButtonCaption;
    fFlt.bbCancel.Caption:=sOLM_CancelButtonCaption;
    case fFlt.ShowModal of
      mrOK: sSelected:=Format('%s %s',[DateToymdStr(fFlt.Dou.DateFirst),
                                       DateToymdStr(fFlt.Dou.DateLast)]);
      mrAll: sSelected:='';
    end;
  finally
    fFlt.Free;
  end;
end;

procedure THeadClickFilter.FiList(Column:TColumn; var sSelected:string);
var
    A:TStringList;
    FlsForm:TfListFltr;
    FiaName:String;
    ShowRslt:integer;
begin
  FiaName:=AnsiUpperCase(Column.Field.FieldName);
  A:=TStringList.Create;
  try
    if Assigned(fOnFilterListSet) then
      fOnFilterListSet(fGrid,Column,A);//Have to return the list of search values
    if A.Count>0 then
      begin
        FlsForm:=TfListFltr.Create(Self);
        try
          flsForm.Caption:=Format(sOLM_FilterFormCaption,[Column.Title.Caption]);
          FlsForm.Label1.Caption:=sOLM_FilterListLabel;
          FlsForm.bbNo.Caption:=sOLM_AllButtonCaption;
          FlsForm.bbCancel.Caption:=sOLM_CancelButtonCaption;

          with FlsForm.ComboBox1.Items do
            begin
              Clear;
              AddStrings(A);
              if sSelected<>'' then
                begin
                  FlsForm.ComboBox1.ItemIndex:=IndexOf(sSelected);
                  FlsForm.ComboBox1.Text:=FlsForm.ComboBox1.Items
                                            [FlsForm.ComboBox1.ItemIndex];
                end;
              if (sSelected='')
                 or
                 (FlsForm.ComboBox1.ItemIndex<0)
              then
                begin
                 FlsForm.ComboBox1.ItemIndex:=-1;//0;
                 FlsForm.ComboBox1.Text:='';
                end;
            end;
            ShowRslt:=FlsForm.ShowModal;
          if ShowRslt=mrOK then
            begin
               if FlsForm.ComboBox1.ItemIndex>=0 then
                    sSelected:=FlsForm.ComboBox1.Items
                                [FlsForm.ComboBox1.ItemIndex]
               else sSelected:='';
            end;
          if ShowRslt=mrAll then sSelected:='';

          (fFieldList.Objects[fFieldList.IndexOf(FiaName)] as TStrObject).S:=sSelected;
        finally
          FlsForm.Free;
        end;
      end;
  finally
    A.Free;
  end;
end;

procedure THeadClickFilter.PushFreshString(A:TStrings; i:integer; var sSelected:string);
var   p:PStrObject;
begin
  if A.Objects[i]<>nil then
      sSelected:=TStrObject(A.Objects[i]).S
  else
    begin
      sSelected:='';
      New(P);
      P^:=TStrObject.Create;
      P^.S:='';
      A.Objects[i]:=TObject(P^);
    end;
end;

procedure   THeadClickFilter.TitleClick(Column: TColumn);
var i,iList,iDat:Integer;
    FiaName:String;
    sSelected:string; // filtered value
    BooMark:TBookMark;
begin
  if fFieldList.Count=0 then
    for i:=0 to fGrid.Columns.Count-1 do
      begin
         fFieldList.Add(AnsiUpperCase(fGrid.Columns[i].Field.FieldName));
      end;
  if fFieldsOfData.Count=0 then
    for i:=0 to fGrid.Columns.Count-1 do
      begin
         if (fGrid.Columns[i].Field is tDateTimeField)then
           fFieldsOfData.Add(AnsiUpperCase(fGrid.Columns[i].Field.FieldName));
      end;

  FiaName:=AnsiUpperCase(Column.Field.FieldName);

  BooMark:=fGrid.DataSource.dataSet.GetBookMark;
  i:=fFieldList.IndexOf(FiaName);
  if i>=0 then
    begin
      PushFreshString(fFieldList, i, sSelected);
      iList:=fFieldsOfList.IndexOf(FiaName);
      if iList>=0 then // Choose from list
        FiList(Column,sSelected)
      else
       begin
         iDat:=fFieldsOfData.IndexOf(FiaName);
         if iDat>=0 then
           FiDat(Column,sSelected)
         else
           FiCmn(Column,sSelected);
       end;
    end;

 (fFieldList.Objects[fFieldList.IndexOf(FiaName)] as TStrObject).S:=sSelected;

 fGrid.DataSource.DataSet.Filtered:=True;
 fGrid.DataSource.DataSet.First;
 //try
 //  fGrid.DataSource.DataSet.Refresh;
 //except
 //end;
 fGrid.DataSource.DataSet.Last;

 try
   fGrid.DataSource.DataSet.GotoBookMark(BooMark);
 except
 end;

 fGrid.DataSource.DataSet.FreeBookMark(BooMark);

 if sSelected<>'' then
   begin
     Column.Title.Font.Style:= Column.Title.Font.Style+[fsBold];
   end
 else Column.Title.Font.Style:= Column.Title.Font.Style-[fsBold];
end;

procedure   THeadClickFilter.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
var j:integer;
    jList,jDat:integer;
    jObj:integer;
    FiaN:string;
    sSelected:String;
    Lokdd:TDataSet; LokFName, KeyFInLook, SrcKeyLook:String;
    D1,D2,Dx:TDateTime; Fx:Double; vx:Variant;
    LokV:Variant;
begin
if Accept then
  for j:=0 to DataSet.FieldCount-1 do
    begin
      FiaN:=AnsiUpperCase(DataSet.Fields[j].FieldName);
      jObj:=fFieldList.IndexOf(FiaN);
      if jObj>=0 then
        begin
          jList:=fFieldsOfList.IndexOf(Fian);
          if jList>=0 then // Filtering in accord with list of values
            begin
              PushFreshString(fFieldList,jObj,sSelected);
              if Not DataSet.Fields[j].Lookup then
                begin
                  if (sSelected<>'')and(sSelected<>DataSet.Fields[j].asString) then
                   begin
                     Accept:=False;
                     Exit;
                   end;
                end
              else
                begin
                  Lokdd:=DataSet.Fields[j].LookupDataSet;
                  LokFName:=DataSet.Fields[j].LookuPResultField;
                  KeyfInLook:=DataSet.Fields[j].LookupKeyFields;
                  SrcKeyLook:=DataSet.Fields[j].KeyFields;
                  if (sSelected<>'') then
                     begin
                       Lokv:=Lokdd.Lookup(KeyFInLook,DataSet.FieldByName(SrcKeyLook).asVariant,LokfName);
                       Accept:=(LokV<>Null)and(Lokv=sSelected);
                       Exit;
                     end;
                end;
            end
          else
            begin
              jDat:=fFieldsOfData.IndexOf(FiAn);
              if jDat>=0 then // Filtering in accord with date span.
                begin
                  PushFreshString(fFieldList,jObj,sSelected);
                  if sSelected<>'' then
                    begin
                      Dx:=0;
                      Vx:=dataSet.Fields[j].asVariant;
                      try
                        Fx:=Vx;
                        Dx:=Fx;
                      except
                      end;
                      if Dx<>0 then
                        begin
                          try
                            D1:=ymdStrToDate(Copy(sSelected,1,10));
                            D2:=ymdStrToDate(Copy(sSelected,12,10));
                            if (D1<>0)and(D2<>0) and( (Dx<D1)or(Dx>D2) )then
                              begin
                                Accept:=False;
                                Exit;
                              end;
                          except
                          end;
                        end;
                    end;
                end
              else  // Substring filtration
                begin
                  PushFreshString(fFieldList,jObj,sSelected);
                  if sSelected<>'' then
                    begin
                      if pos(AnsiUpperCase(sSelected),
                             AnsiUpperCase(Dataset.Fields[j].asString))=0
                      then
                        begin
                          Accept:=False;
                          Exit;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

procedure   THeadClickFilter.SetFieldList(Value:TStrings);
begin
  fFieldList.Assign(Value);
end;

procedure   THeadClickFilter.SetFieldsOfData(Value:TStrings);
begin
 fFieldsOfData.Assign(Value);
end;

procedure   THeadClickFilter.SetFieldsOfList(Value:TStrings);
begin
fFieldsOfList.Assign(Value);
end;

function THeadClickFilter.GetF( index: integer):String;
begin
 Result:='';
 if (Index<FFieldList.Count)and(Index>=0) then
   Result:=fFieldList[index];
end;

procedure THeadClickFilter.PutF( index: integer; Value:String);
begin
fFieldList[index]:=Value;
end;

procedure   THeadClickFilter.Clear;
var i:integer; B:TbookMark;
begin
  B:=fGrid.DataSource.DataSet.GetBookmark;
  try
    for i:=0 to fFieldList.Count-1 do
        begin
         if (fFieldList.Objects[i]<>nil) and (fFieldList.Objects[i] is TStrObject) then
         (fFieldList.Objects[i] as TStrObject).s:='';
        end;
    for i:=0 to fGrid.Columns.Count-1 do
        fGrid.Columns[i].Title.Font.Style:=fGrid.Columns[i].Title.Font.Style-[fsBold];
    try
      fGrid.DataSource.DataSet.GotoBookMark(B);
    except
    end;
  finally
    fGrid.DataSource.DataSet.FreeBookMark(B);
  end;
end;

end.
