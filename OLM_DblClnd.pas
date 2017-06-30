unit OLM_DblClnd;
//------------------------------------------//
//      Oleg Mitine (Oleg Meeting)          //
//      June 2001                           //
//------------------------------------------//
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
   Forms,
   Dialogs,
  stdCtrls,
  ExtCtrls,Math,OLM_Cldr;

const
  STARTCLDRSIZE=209;
  COLOR_ILL=$00A2A4CC;
type
  TSpunChange=procedure(Sender:TObject; DateFirst,DateLast:TDateTime)of object;


  TFullCalendarLightParentFont=class(TFullCalendarLight)
  public
    constructor Create(AOwner:TComponent); override;
  published
  property ParentFont;
  property OnChange;
  end;

  TDoubleCalendar = class(TCustomPanel)
  private
    { Private declarations }
    fColorIll:TColor;
    C1,C2:TFullCalendarLightParentFont;
    Lbl:TLabel;
    fOnChange:TSpunChange;
    function  GetDateFirst:TDateTime;
    function  GetDateLast:TDateTime;
    procedure SetDateFirst(Value:TDateTime);
    procedure SetDateLast(Value:TDateTime);
    procedure setElems;
    procedure LblCapt;
    procedure Change(Sender:TObject); virtual;
//    function  SpellDays(n:integer):string;
    procedure ShowLightedCells(dd1,dd2:TDateTime);
    function  DateToLocalString(D:TDateTime):string;
  protected
    { Protected declarations }
    procedure   WMSize(var Message: TWMSize); message WM_SIZE;
    procedure Loaded;override;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy; override;
    function GetLabel:String;
  published
    { Published declarations }
    property Align;
    property ColorIll:TColor read fColorIll write fColorIll default COLOR_ILL;
    property Font;
    property ParentFont;
    property DateFirst:TDateTime read GetDateFirst write SetDateFirst;
    property DateLast:TDateTime read GetDateLast write SetDateLast;
    property OnChange:TSpunChange read fOnChange write fOnChange;
  end;

//procedure Register;

implementation

constructor TFullCalendarLightParentFont.Create(AOwner:TComponent);
begin
  inherited;
  ParentFont:=true;
end;

constructor TDoubleCalendar.Create(AOwner:TComponent);
begin
inherited;
Self.Caption:='';
fColorIll:=COLOR_ILL;
Height:=220;
Width:=430;

C1:=TFullCalendarLightParentFont.Create(Self);
with C1 do
  begin
    Parent:=Self;
    Height:=209;
    Width:=209;
    C1.OnChange:=Self.Change;
  end;
C2:=TFullCalendarLightParentFont.Create(Self);
with C2 do
  begin
    Parent:=Self;
    Height:=209;
    Width:=209;
    OnChange:=Self.Change;
  end;
Lbl:=Tlabel.Create(Self);
 with Lbl do
   begin
     Parent:=Self;
     AutoSize:=False;
     Alignment:=taCenter;
   end;
 SetElems;
end;

function TDoubleCalendar.DateToLocalString(D:TDateTime):string;
var
  dstim:TSystemTime;
  dastr:array[0..100] of char;
  chBuff:array[0..100] of char;
begin
fillchar(dastr,101,#0);
fillchar(chBuff,101,#0);

GetLocaleInfo(	LOCALE_USER_DEFAULT,      // locale identifier
					LOCALE_SLONGDATE,    // type of information
					chbuff,  // address of buffer for information
					100       // size of buffer
				 );

DateTimeToSystemTime(D,dsTim);
GetDateFormat(
						LOCALE_SYSTEM_DEFAULT,               // locale
						0,             // options
						@dsTim,  // date
						chbuff,//adafo,          // date format
						dastr,          // formatted string buffer
						100                // size of buffer
                   );
Result:=string(dastr);
end;

procedure TDoubleCalendar.setElems;
begin
try
  C1.SetBounds(0, 0, Width div 2, Height-Lbl.Height-6);
  C2.SetBounds(C1.Width+1, 0, Width-C1.Width-2, C1.Height);
  Lbl.SetBounds(4,C1.Height+2, Width-8, Lbl.Height);
except
end;
try
  LblCapt;
except
end;
end;

destructor  TDoubleCalendar.Destroy;
begin
Lbl.Free;
C2.Free;
C1.Free;
inherited;
end;

procedure   TDoubleCalendar.LblCapt;
var //d1,m1,y1,d2,m2,y2:word;
    dd1,dd2,Z:TDateTime;
 //   u:integer;
begin
  dd1:=C1.Date; dd2:=C2.Date;
//  u:=abs(Floor(dd2)-Floor(dd1))+1;
//  decodeDate(dd1,y1,m1,d1);
//  DecodeDate(dd2,y2,m2,d2);
  if dd2<dd1 then
    begin
       Z:=dd2;
       dd2:=dd1;
       dd1:=Z;
       C1.Date:=dd1;
       C2.Date:=dd2;
    end;

   if dd1<=dd2 then
      begin
        ShowLightedCells(dd1,dd2);
        Lbl.Caption:=Format( '%s - %s',
        [DateToLocalString(dd1),DateToLocalString(Dd2)]);
      end;
end;

procedure TDoubleCalendar.ShowLightedCells( dd1,dd2:TDateTime);
var d1,m1,y1,d2,m2,y2:word; Z, U:TDateTime; i :integer;
begin
  C1.Clear; C2.Clear;
  if dd1>dd2 then
    begin
      Z:=dd2; dd2:=dd1; dd1:=Z;
    end;
  DecodeDate(dd1,y1,m1,d1);
  DecodeDate(dd2,y2,m2,d2);
  if(y1=y2)and(m1=m2)then
    for i:=Floor(dd1) to Floor(dd2) do
      begin
        z:=i;
        C1.AddDate(Z); C2.AddDate(Z);
      end
  else
    begin
       if m1=12 then begin Inc(Y1); m1:=1; end
       else Inc(m1);
       U:=EncodeDate(y1,m1,1)-1;
       for i:=Floor(dd1) to Floor(U) do
          begin
            z:=i;
            C1.AddDate(Z);
          end;
       U:=EncodeDate(y2,m2,1);
       for i:=Floor(U) to Floor(dd2) do
          begin
            z:=i;
            C2.AddDate(Z);
          end;
    end;
  C1.Invalidate;
  C2.Invalidate;
end;

procedure   TDoubleCalendar.WMSize(var Message: TWMSize);
begin
inherited;
 SetElems;
end;

function TDoubleCalendar.GetDateFirst:TDateTime;
begin
  Result:=C1.Date;
end;

function TDoubleCalendar.GetDateLast:TDateTime;
begin
  Result:=C2.Date;
end;

procedure TDoubleCalendar.SetDateFirst(Value:TDateTime);
var Z:integer;
begin
 Z:=Floor(Value+0.00001);
 if Z<=Floor(C2.Date) then
   C1.Date:=Z
 else
   begin
     C1.Date:=C2.Date;
     C2.Date:=Z;
   end;
LblCapt;
end;

procedure TDoubleCalendar.SetDateLast(Value:TDateTime);
var Z:integer;
begin
 Z:=Floor(Value+0.00001);
 if Z<=Floor(C1.Date) then
   C2.Date:=Z
 else
   begin
     C2.Date:=C1.Date;
     C2.Date:=Z;
   end;
LblCapt;
end;

procedure TDoubleCalendar.Change(Sender:TObject);
var Z:integer;
begin
if (Sender=C1)or(sender=C2) then
  begin
    C1.OnChange:=Nil; C2.OnChange:=Nil;
    if Floor(C1.Date)>Floor(C2.Date) then
      begin
        Z:=Floor(C2.Date);
        C2.Date:=C1.Date;
        C1.Date:=Z;
      end;
    LblCapt;
    C1.OnChange:=Change; C2.OnChange:=Change;
    if Assigned(fOnChange) then
      fOnChange(Self, C1.Date,C2.Date);
  end;
end;

function TDoubleCalendar.GetLabel:string;
begin
Result:=Lbl.Caption;
end;

procedure TDoubleCalendar.Loaded;
begin
  inherited;
  C1.Date:=Now;
  C2.Date:=Now;
end;

{
procedure Register;
begin
  RegisterComponents('OLMComps', [TDoubleCalendar]);
end;
}
end.
