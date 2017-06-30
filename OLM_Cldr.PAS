unit OLM_Cldr;
///////////////////////////////////////////////////////////
//                     OLM_Cldr.pas                       /
//       Source file for OLM_Calendar component set       /
//                                                        /
//        CopyRight (c) 1999-2000 by Oleg Mitin           /
//                                                        /
///////////////////////////////////////////////////////////.
interface
uses Windows, Messages, SysUtils, Classes,Math,
 //    DsgnIntf,
     Graphics, Controls, Forms, Dialogs, Grids,Calendar,
     ExtCtrls,stdctrls,Spin,Buttons,TypInfo,DB,//DBTables,
     DBCtrls;
const
  SUNDAYCOLOR=$00CE89FC;

type

TResizeState=(rsMinimal,rsNormal,rsMaximal);
TDayOfWeek=(SunDay,Monday,TuesDay,WednesDay,ThursDay,FriDay,SaturDay);
TLightDay = set of TDayOfWeek;// Sunday is 0, Saturday 6;
TCalSizes=record GridWidth,EditWidth,FullHeight,EditHeight:word; end;

TDateNotifyEvent=procedure (Sender:TObject; CldrDate:TDateTime) of object;
TDateMouseNotifyEvent=procedure (Sender:TObject; CldrDate:TDateTime;
                                 But:TMouseButton) of object;

TButPanel = class(TCustomPanel)
  private
    { Private declarations }
    FGlyph: TBitMap;
    FautoRepeat:integer;
    FDown:Boolean;
    FExternalState:Boolean;
    FHtim:integer;
    FOnTick:TNotifyEvent;
    procedure SetDown(value:Boolean);
    function GetDown:boolean;
    function GetGlyph: TBitmap;
    procedure SetGlyph(Value: TBitmap);
   protected
    { Protected declarations }
    function MDisp(M:TMessage):Hwnd;
    procedure WndProc(var Message: TMessage); override;
    procedure Paint; override;
    property Caption;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
  published
    { Published declarations }
    property AutoRepeat:integer read FautoRepeat write FAutoRepeat default 300;
    property Down:boolean read GetDown write SetDown;
    property ExternalState:boolean read FExternalState write FExternalState;
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property OnTick:TNotifyEvent read FOntick write FOnTick;
end;


TListDates = class(Tlist)
protected
function GetDate(Index: Integer): TDateTime;
procedure PutDate(Index: Integer; Item: TDateTime);
public
procedure AddDate(D:TDateTime);
procedure RemoveDate(D:TDateTime);
procedure AddDateFast(D:TDateTime);
function DateIsInList(D:TDateTime):boolean;
procedure SortAsDate;
property Items[Index: Integer]:TDateTime read GetDate write PutDate; default;
end;

TCalendarLighted = class(TCalendar)
  private
    FOnDateClick:TDateMouseNotifyEvent;
    FOnDateDblClick:TDateNotifyEvent;
    FMClickX:integer;
    FMClickY:integer;
    FMClickState:TShiftState;
    FMClickButton:TMouseButton;
    FWeekEnd:TLightDay;
    FLightList:TListDates;
    FLightColor:TColor;
    FLightSelectColor:TColor;
    FLightSundayColor:TColor;
    FSunDayColor:TColor;
    function GetWeekEnd:TLightDay;
    procedure SetWeekEnd(Value:TLightDay);
    function GetDateFromList(i:integer):TDateTime;
    procedure DbClick(Sender:Tobject);
    { Private declarations }
  protected
    { Protected declarations }
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure Change; override;
    property LightDataList:TListDates read FLightList ;//write  SetLightList;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer); override;
    property OnClick;
    property OnDblClick;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;Override;
    function StringIsDataVal(sd:string;var D:TDateTime):Boolean;
    procedure AddDate(D:TDateTime);
    procedure RemoveDate(D:TDateTime);
    procedure Clear;
    function DateIsInList(D:TDateTime):Boolean;
    function CountDate:integer;
    procedure GetLastClick(var Button: TMouseButton;
              var Shift: TShiftState;   var X, Y: Integer);
    property DatesLighted[Index:integer]:TdateTime read GetDatefromList; default;

  published
    { Published declarations }
    property ColorLight:TColor read FLightColor write FLightColor default clYellow;
    property ColorLightSelect:TColor read FLightSelectColor write FLightSelectColor default clLime;
    property ColorLightSunday:TColor read FLightSundayColor write FLightSundayColor default clRed;
    property ColorSunday:TColor read FSundayColor write FSundayColor default SUNDAYCOLOR;
    property StartOfWeek default 1;
    property DefaultRowHeight;
    property WeekEnd:TLightDay read GetWeekEnd write SetWeekEnd ;
    property Font;

    property OnDateClick:TDateMouseNotifyEvent read FOndateClick write FOnDateClick;
    property OnDateDblClick:TDateNotifyEvent read FOnDateDblClick write FOnDateDblClick;
  end;

  TFullCalendarAncestor = class(TCustomPanel)
  private
    { Private declarations }

    FOnClear:TNotifyEvent;
    FDateDblClick:TDateNotifyEvent;
    FOnDateClick:TDateMouseNotifyEvent;
    FCountAutoRep:integer;
    FButtonPressed:Boolean;
    FAutoRepEnabled:Boolean;
    FResultWidth:integer;
    FResultHeight:integer;
    FCountResize:integer;
    FFlagListChange:Boolean;
    FOnListChange:TNotifyEvent;
    FCalendarEnabled:Boolean;
    FHasFocus:Boolean;
    FStartOfWeek:integer;
    FWeekEnd:TLightDay;
    FLightColor:TColor;
    FLightSelectColor:TColor;
    FLightSundayColor:TColor;
    FSunDayColor:TColor;
    FOnCreaChangeCall:integer;
    FOnChange:TNotifyEvent;
    FOnPaint:TNotifyEvent;
    FOnEnter:TNotifyEvent;
    FOnExit :TNotifyEvent;
    FInternalResize:Boolean;
    FArrowSize:integer;
    FSpeedButton1: TButPanel;
    FSpeedButton2: TButPanel;
    FSpeedButton3: TButPanel;
    FSpeedButton4: TButPanel;
    FSpeedButton5: TButPanel;
    FSpeedButton6: TButPanel;
    FEdit:TEdit;
    FSpinYear:TSpinEdit;
    FCLight:TCalendarLighted;
    FDate:TDateTime;
    FComb:TComboBox;
    FYearRange:word;
    FAutoRepeat:word;
    FTimAutoRep:TTimer;
    function  FullHeight(editH,DigitH:integer) :integer;
    procedure SetSpinYear(y:integer);
    function  CorrectString_toDate(ComponentDate:TDateTime;S:string; var ier:integer):TDateTime;
    procedure SetColorLight(Value:TColor);
    procedure SetColorLightSelect(Value:TColor);
    procedure SetColorLightSunday(Value:TColor);
    procedure SetSundayColor(Value:TColor);
    function  GetStartOfWeek:integer;
    procedure SetStartOfWeek(Value:integer);
    procedure SetWeekEnd(Value:TLightDay);

    procedure SetAutoRepEnabled(Value:Boolean);
    function GetDateFromList(i:integer):TDateTime;
    procedure CldrMouseClick(Sender:TObject; CldrDate:TDateTime;
                             Button:TMouseButton);
protected
    { Protected declarations }
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    function  SetSizesVsFont(ifs:integer):TCalSizes;
    procedure ArrowImage(BitMap:TBitMap;Left:Boolean);
    procedure WMPaint(var Message: TMessage);message WM_PAINT;
    procedure SetDate(Val:TDateTime);
    procedure DateShow;virtual;
    procedure Edit1Exit(Sender: TObject); virtual;
    function  DayInMonth(Date:TDateTime):integer;
    procedure DateTexts(Date:TDateTime);
    procedure SetYearRange(Value:Word);
    procedure SetAutoRepeat(Val:Word);
    procedure AutoRep(Sender:TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure LoseFocus(Sender:TObject);
    procedure ObtainFocus(Sender:TObject);
    procedure Change; virtual;
    procedure CldrDoubleClick(Sender:TObject);
    procedure CldrDateDoubleClick(Sender:TObject; CldrDate:TDateTime);
    property AutoRepEnabled:boolean read FAutoRepEnabled write SetAutoRepEnabled default true;
    property ButtonPressed:Boolean read FButtonPressed;

    function GetEnabled:Boolean;
    {$IFNDEF VER90}    override; {$ELSE} virtual;{$ENDIF}

    procedure SetEnabled(Value:Boolean);
    {$IFNDEF VER90}    override; {$ELSE} virtual;{$ENDIF}

  public
     { Public declarations }
    function CountDate:integer;
    procedure SetElems;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure AddDate(D:TDateTime);
    procedure RemoveDate(D:TDateTime);

    procedure Clear; virtual;
    procedure SetFocus;override;
    function DateIsInList(D:TDateTime):Boolean;
    function Focused:boolean;
    {$IFNDEF VER90}    override; {$ELSE} virtual;{$ENDIF}

    property ResultHeight:integer read FResultHeight write FResultHeight;
    property ResultWidth:integer  read FREsultWidth write FResultWidth;
    property Edit:TEdit read FEdit write FEdit;
    property Calendar:TCalendarLighted read FCLight write FCLight;
    property SpinEdit:TSpinEdit read FSpinYear write FSpinYear;
    property ComboBox:TComboBox read FComb write FComb;
    property Button1:TButPanel read FSpeedButton1 write FSpeedButton1;
    property Button2:TButPanel read FSpeedButton2 write FSpeedButton2;
    property Button3:TButPanel read FSpeedButton3 write FSpeedButton3;
    property Button4:TButPanel read FSpeedButton4 write FSpeedButton4;
    property Button5:TButPanel read FSpeedButton5 write FSpeedButton5;
    property Button6:TButPanel read FSpeedButton6 write FSpeedButton6;

    property DatesLighted[Index:integer]:TdateTime read GetDatefromList; default;

  published
    { Published declarations }
     property Font;
     property BevelOuter;
     property BevelWidth;
     property Color;
     property Date:TDateTime read Fdate write SetDate;
     property YearRange:word read FYearRange write SetYearRange default 5;
     property AutoRepeat:word read FAutoRepeat write SetAutoRepeat default 300;
     property Enabled:boolean read GetEnabled write SetEnabled default True;

    property ColorLight:TColor read FLightColor write SetColorLight default clYellow;
    property ColorLightSelect:TColor read FLightSelectColor write SetColorLightSelect default clLime;
    property ColorLightSunday:TColor read FLightSundayColor write SetColorLightSunday default clRed;
    property ColorSunday:TColor read FSundayColor write SetSundayColor default SUNDAYCOLOR;
    property StartOfWeek:integer read GetStartOfWeek write SetStartOfWeek default 1;
    property WeekEnd:TLightDay read FWeekEnd write SetWeekEnd ;

    property PopUpMenu;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDateClick : TDateMouseNotifyEvent read FOnDateClick write FOnDateClick;
    property OnDateDblClick :TDateNotifyEvent read FDateDblClick write  FDateDblClick;
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnExit : TNotifyEvent read FOnExit  write FOnExit ;
    property OnListChange:TNotifyEvent read FOnListChange write FOnlistChange;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    Property OnClear:TNotifyEvent read FOnClear write FOnClear;
 end;

TFullCalendarLight = class(TFullCalendarAncestor)
private
FInternalResizeCount:integer;
protected
  function  YSize(Size:integer):integer;
  procedure WMSize(var Message: TWMSize); message WM_SIZE;
  function  SetSizesVsFont(ifs:integer):TCalSizes;
  procedure SetElems;
  procedure FineElemAlign;
  function  OptimalFontSize(var ResState:TResizeState):integer;
  procedure Loaded; override;
  procedure WMPaint(var Message: TMessage);message WM_PAINT;
public
  constructor Create(AOwner:TComponent);override;
published
  property Align;
end;

TDBFullCalendarLight = class(TFullCalendarLight)
  private
    { Private declarations }
    fDataLink: TFieldDataLink;
    fUpdatingData: Boolean;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(ReadOnly: Boolean);
    procedure SetDataField(const Field: string);
    procedure SetDataSource(DataSource: TDataSource);
    procedure UpdateData(Sender: TObject);
  protected
    { Protected declarations }
    procedure DataChange(Sender: TObject);
    procedure Change; override;
    procedure DateShow; override;
    procedure Notification(Component: TComponent; Operation: TOperation); override;
    procedure KeyPress(var Key: Char); override;
    procedure CmGetDataLink(var Msg: TMessage); message Cm_GetDataLink;
    procedure CmExit(var Msg: TCMExit); message Cm_Exit;
    property UpdatingData: Boolean read fUpdatingData;
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    property Field: TField read GetField;
  published
    { Published declarations }
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;

TMonArDay = array[1..31] of boolean;
   PCacheDates = ^TCacheDates;
   TCacheDates = record
     D:TDateTime;
     A:TMonArDay;
end;

TCacheMonths = class(TList)
   public
     procedure Clear; //virtual;
     {$IFNDEF VER90}    override; {$ELSE} virtual;{$ENDIF}

     procedure AddDate(D:TDateTime;var ArrDays:TMonArDay);
     function DateIsInList(D:TDateTime):Boolean;
     procedure SortDates;
     function DateState(D:TDateTime;var A:TMonArDay):Boolean;
     destructor Destroy; override;
end;

(*
TDBQFullCalendarLight = class(TDBFullCalendarLight)
  private
    { Private declarations }
 //    FFullDates:TListDates;
     FErCount:integer;
     FQuoted:Boolean;
     FCache:TCacheMonths;
     Q:Tquery;
     FTimRedraw:TTimer;
     QueryFlag:Boolean;
     FM:integer;
     FY:integer;
     FLUField:string;
     fT:TTable;
  protected
    { Protected declarations }
   procedure Notification(AComponent:TComponent;Operation:TOperation);override;
   procedure CreaQuery;
   procedure Change; override;
   procedure Loaded; override;
   procedure Redraw(A:TObject);
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy; override;
    procedure Refresh; virtual;
    procedure Clear; override;
  published
    { Published declarations }
    property LookUpTable:TTable read fT write FT;
    property LookUpField:String read FLUField write FLUField;
    property Quoted:boolean read FQuoted write FQuoted default False;
end;
*)

//procedure Register; // - transferred into OLM_TabClickReg.pas for D7


implementation

const
  SP=2;
  STARTCLDRWIDTH=122;
  STARTCLDRHEIGHT=115;
  MINBUTTONWIDTH=30;

{TButPanel}
constructor TButPanel.Create(AOwner:TComponent);
begin
  inherited;
  FGlyph:=TBitMap.Create;
  Caption:='';
  ParentColor:=True;
  BevelOuter:=bvRaised;
  BevelInner:=bvNone;
  FHTim:=0;
  FAutoRepeat:=300;
end;

destructor TButPanel.Destroy;
begin
            if FHTim<>0 then
              begin
                KillTimer(0,FHTim);
                FHtim:=0;
              end;
  FGlyph.Free;
  inherited;
end;


function HitBut(b:TButPanel; xo,yo:integer):Boolean;
begin
Result:=false;
    if (xo>B.Left)and(xo<B.Left+B.Width)and
       (yo>B.Top)and(xo<B.Top+B.Height)
    then Result:=True;
end;

function TButPanel.MDisp(M:TMessage):Hwnd;
var x,y,xo,yo:integer; B:TButPanel;  MS:TMessage;
begin
Result:=Hwnd(0);
if NOT((M.Msg=WM_LBUTTONDOWN)or(M.Msg=WM_LBUTTONUP)) then Exit;
if Owner=Nil then exit;
x:=M.LParamLo; Y:=M.LParamHi;


xo:=x+Self.Left; yo:=y+Self.Top;

B:=nil;
with (Owner as TFullCalendarAncestor) do
  begin
    if HitBut(Button1,xo,yo)then B:=Button1;
    if HitBut(Button2,xo,yo)then B:=Button2;
    if HitBut(Button3,xo,yo)then B:=Button3;
    if HitBut(Button4,xo,yo)then B:=Button4;
    if HitBut(Button5,xo,yo)then B:=Button5;
    if HitBut(Button6,xo,yo)then B:=Button6;
  end;
if (B<>nil)and(B<>Self) then
  begin
    MS.LParamLo:=xo-B.Left; Ms.LParamHi:=yo-B.Top;
    PostMessage(B.Handle,M.Msg,M.WParam,Ms.LParam);
    Result:=B.Handle;
  end;
end;

procedure TButPanel.WndProc(var Message: TMessage);
begin
 case Message.Msg of
        WM_LBUTTONDOWN:
          begin

            if NOT( (Message.LParamLo<Width)and(Message.LParamLo>0)
            and(Message.LParamHi<Height)and(Message.LParamHi>0) )
            then  // Other Window
              begin
                KillTimer(Handle,1);
                Down:=False;
 //               Mdisp(Message);
                Exit;
              end;
            if Not Down and (NOT( csDesigning in ComponentState)) then
              begin
                FHTim:= SetTimer(
                  Handle,	// handle of window for timer messages
                  1,	        // timer identifier
                  FAutoRepeat,	// time-out value
                  nil           //@TimerProc
                  );
                Down:=True;
                if Assigned(FOnTick) then FOnTick(Self);
              end;
          end;
        WM_LBUTTONUP,WM_NCLBUTTONUP:
          begin
            Down:=False;
            if FHTim<>0 then
              begin
                KillTimer(0,FHTim);
                FHtim:=0;
              end;
          end;
         WM_TIMER:
           begin
            if Int64(Message.WParam)=Int64(FHTim) then  if Assigned(FOnTick) then FOnTick(Self);
           end;
 end;
 inherited;
end;

procedure TButPanel.SetGlyph(Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Invalidate;
end;

function TButPanel.GetGlyph: TBitMap;
begin
  Result := FGlyph;
end;

procedure TButPanel.Paint;
var DestDC:HDC; //i:integer;
begin
  inherited;
  if (FGlyph<>nil) then
    begin
     DestDC:=GetDC(Handle);
     BitBlt(DestDC, (Width div 2) - (FGlyph.Width div 2), (Height div 2)-(FGlyph.Height div 2){0}, FGlyph.Width, FGlyph.Height, FGLyph.Canvas.Handle,
            0, 0, SRCCOPY);
     ReleaseDc(Handle,DestDC);
    end;
end;

procedure TButPanel.SetDown(Value:boolean);
begin
  Fdown:=Value;
  if Value then
    begin
        BevelInner:=bvLowered;
    end
  else
    begin
      BevelInner:=bvNone;
    end;
end;

function  TButPanel.GetDown;
begin
  Result:=FDown;
end;

{TListDates}
function CompDat(P1,P2:Pointer):integer;
begin
Result:=0;
 if Integer(P1)<Integer(P2) then Result:=-1
 else
    if Integer(P1)>Integer(P2) then Result:=1;
end;

procedure TListDates.AddDate(D:TDateTime);
begin
if NOT DateIsInList(D) then
   Add(Pointer(Floor(D)));
   Sort(CompDat);
end;

procedure TListDates.RemoveDate(D:TDateTime);
begin
if  DateIsInList(D) then
   Delete(IndexOf(Pointer(Floor(D))));
end;

procedure TListDates.AddDateFast(D:TDateTime);
begin
if NOT DateIsInList(D) then
   Add(Pointer(Floor(D)));
end;

function TListDates.DateIsInList(D:TDateTime):boolean;
begin
    Result:=( IndexOf(Pointer(Floor(D)))>=0 );
end;

procedure TListDates.SortAsDate;
begin
   Sort(CompDat);
end;

function TListDates.GetDate(Index: Integer): TDateTime ;
var Z:TdateTime;
begin
Z:=Integer(Get(Index));
Result:=TDateTime(Z);
end;

procedure TListDates.PutDate(Index: Integer; Item: TDateTime);
var i:integer;
begin
 i:=Floor(Item);
 Put(Index,Pointer(i));
end;


{TCalendarLighted}
constructor TCalendarLighted.Create(AOwner:TComponent);
begin
inherited;
FLightList:=TListDates.Create;
if FLightColor=clBlack then FLightColor:=clYellow;
if FLightSelectColor=clBlack then FLightSelectColor:=clLime;
if FLightSundayColor=clBlack then FLightSundayColor:=clRed;
if FSundayColor=clBlack then FSundayColor:=SUNDAYCOLOR;
if FWeekEnd=[] then FWeekEnd:=[SunDay]+[SaturDay];
if StartOfWeek=0 then StartOfWeek:=1;
Width:=STARTCLDRWIDTH;
Height:=STARTCLDRHEIGHT;
OnDblClick:=DbClick;
end;

destructor TCalendarLighted.Destroy;
begin
     FLightList.Free;
inherited;
end;

function TCalendarLighted.CountDate:integer;
begin
  Result:=FLightList.Count;
end;

function TCalendarLighted.GetWeekEnd:TLightDay;
begin
  Result:=FWeekEnd;
end;

procedure TCalendarLighted.SetWeekEnd(Value:TLightDay);
begin
  FWeekEnd:=Value;
end;

procedure TCalendarLighted.Clear;
begin
  FlightList.Clear;
end;

procedure TCalendarLighted.DbClick(Sender:Tobject);
var But:TMouseButton; Ax,Ay,Lx,Ly:integer; Sh:TShiftState;
begin
  Self.GetLastClick(But,Sh,LX, LY);
  Ax:=LX div (Self.Width div 7);
  Ay:=LY div (Self.DefaultRowHeight+self.GridLineWidth);
  if (Self.CellText[Ax,Ay]<>'') and ( Ay<>0) then
    if Assigned( FOnDateDblClick) then
      FOnDateDblClick(Self, Self.CalendarDate);
end;

procedure TCalendarLighted.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var Ax,AY:integer; Yw,Mw,Dw:Word;
begin
 FMClickX:=X; FMClickY:=Y;
 FMClickState:=Shift; FMClickButton:=Button;
 inherited;
   Ax:=X div (Self.Width div 7);
   Ay:=Y div (Self.DefaultRowHeight+Self.GridLineWidth);
  if (Trim(Self.CellText[Ax,Ay])<>'')
     and ( Ay<>0) then
    begin
      DecodeDate(Self.CalendarDate,Yw,Mw,Dw);
      if Assigned( FOnDateClick) then
             FOnDateClick(self,
                          EncodeDate( Yw,Mw,StrToInt(Trim(Self.CellText[Ax,Ay]))),
                          Button
                         );
        Self.Invalidate;
    end;
end;

procedure TCalendarLighted.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
  D:TDateTime;DW:TDayOfWeek;TheText:String;iEr:integer;
  DM:word; InList:Boolean;
begin
  inherited;

  TheText:=CellText[ACol, ARow];
  Val(TheText,dm,ier);
  if ier=0 then
    begin
      D:=EncodeDate(Word(Year),Word(Month),dm);
      DW:=TDayOfWeek(DayOfWeek(D)-1);
      inList:=DateIsInList(D);
      if DW in FWeekEnd then
        begin
          if Enabled then
            begin
              if Not(gdSelected in AState) then
                begin
                  if Not InList then Canvas.Brush.Color:=FSunDayColor // Sunday;Not listed; Not selected;
                  else Canvas.Brush.Color:=ColorLightSunday;   // Sunday; Listed; Not selected;
                end
              else
                if Inlist then
                  Canvas.Brush.Color:=ColorLightSelect;   // Sunday; Listed; Selected;
            end;
        end
      else
       if Not(gdSelected in AState) then
          begin
            if Not InList then Canvas.Brush.Color:=Color // Workday; Not listed; Not selected;
            else Canvas.Brush.Color:=ColorLight; // WorkDay; Listed; Not Selected;
          end
       else if Inlist then
             Canvas.Brush.Color:=ColorLightSelect;   // Workday; Listed; selected;
    with Canvas, Arect do
      begin
        FillRect(Arect);
        TextRect(ARect, Left + (Right - Left - TextWidth(TheText)) div 2,
                    Top + (Bottom - Top - TextHeight(TheText)) div 2, TheText);
      end;
    end;

end;

procedure TCalendarLighted.Change;
begin
 inherited;
end;

function TCalendarLighted.StringIsDataVal(sd:string;var D:TDateTime):Boolean;
begin
 Result:=True;D:=0.0;
 try
   D:=StrToDate(Sd);
 except
   Result:=False;D:=0.0;
 end;
end;

procedure TCalendarLighted.AddDate(D:TDateTime);
begin
FLightList.AddDate(D);
FLightList.SortAsDate;
Change;
end;

procedure TCalendarLighted.RemoveDate(D:TDateTime);
begin
FLightList.RemoveDate(D);
Change;
end;

procedure TCalendarLighted.GetLastClick(var Button: TMouseButton;
var Shift: TShiftState;   var X, Y: Integer);
begin
Button:=FMClickButton; Shift:=FMClickState; X:=FMClickX; Y:=FMClickY;
end;

function TCalendarLighted.DateIsInList(D:TDatetime):Boolean;
begin
if D<1.0 then begin Result:=False;Exit;end;
Result:=FLightList.DateIsInList(D);
end;

function TCalendarLighted.GetDateFromList(i:integer):TDateTime;
begin
 Result:=LightDataList[i];
end;

{TFullCalendarAncestor}
constructor TFullCalendarAncestor.Create(AOwner:TComponent);
begin
inherited;
FAutoRepEnabled:=true;
FCountResize:=0;
FFlagListChange:=False;
if FLightColor=clBlack then FLightColor:=clYellow;
if FLightSelectColor=clBlack then FLightSelectColor:=clLime;
if FLightSundayColor=clBlack then FLightSundayColor:=clRed;
if FSundayColor=clBlack then FSundayColor:=SUNDAYCOLOR;
if FWeekEnd=[] then FWeekEnd:=[SunDay]+[SaturDay];
if FStartOfWeek=0 then FStartOfWeek:=1;

 FHasFocus:=False;
 FCalendarEnabled:=True;

 FInternalResize:=False;
 FarrowSize:=16;
 Caption:='';
 Height:= 209;
 Width:=  209;
 FAutoRepeat:=300;
 if FDate=0 then FDate:=Now;
 if FYearRange=0 then FYearRange:=5;
 FComb:=TCombOBox.Create(self); Fcomb.Parent:=Self;
 FClight:=TCalendarLighted.Create(Self);FClight.Parent:=Self;
 FSpinYear:=TSpinEdit.Create(Self);FSpinYear.Parent:=Self;
 FEdit:=TEdit.Create(self);FEdit.Parent:=Self;
 FSpeedButton1:= TButPanel.Create(Self); FspeedButton1.Parent:=Self;FspeedButton1.Tag:=1;
 FSpeedButton2:= TButPanel.Create(Self); FspeedButton2.Parent:=Self;FspeedButton2.Tag:=2;
 FSpeedButton3:= TButPanel.Create(Self); FspeedButton3.Parent:=Self;FspeedButton3.Tag:=3;
 FSpeedButton4:= TButPanel.Create(Self); FspeedButton4.Parent:=Self;FspeedButton4.Tag:=4;
 FSpeedButton5:= TButPanel.Create(Self); FspeedButton5.Parent:=Self;FspeedButton5.Tag:=5;
 FSpeedButton6:= TButPanel.Create(Self); FspeedButton6.Parent:=Self;FspeedButton6.Tag:=6;
 FTimAutoRep:=TTimer.Create(Self); FTimAutoRep.Enabled:=False;FtimAutoRep.Interval:=FAutoRepeat;
 FtimAutoRep.OnTimer:=AutoRep;
 FResultHeight:=Height;

 SetElems;

end;

destructor  TFullCalendarAncestor.Destroy;
begin
 FSpeedButton6.Free;FSpeedButton5.Free;  FSpeedButton4.Free;
 FSpeedButton3.Free; FSpeedButton2.Free; FSpeedButton1.Free;
 FEdit.Free;
 FSpinYear.Free;
 FCLight.Free;
 FComb.Free;
 FTimAutoRep.Enabled:=False;FTimAutoRep.Free;
inherited;
end;

function TFullCalendarAncestor.CountDate:integer;
begin
  Result:=FCLight.CountDate;
end;


procedure TFullCalendarAncestor.WMSize(var Message: TWMSize);
begin
  inherited;
  SetElems;
end;

procedure TFullCalendarAncestor.AutoRep(Sender:TObject);
var Sb:TButPanel;
begin
  Inc(FCountAutoRep);

  if FCountAutoRep>1 then begin Dec(FCountAutoRep);Exit; end;
  if FCountAutoRep=1 then
  begin
  end;
  if Not FAutoRepEnabled then  FTimAutoRep.Enabled:=False;
  case FTimAutoRep.Tag of
   1:Sb:=FSpeedButton1;
   2:Sb:=FSpeedButton2;
   3:Sb:=FSpeedButton3;
   4:Sb:=FSpeedButton4;
   5:Sb:=FSpeedButton5;
   6:Sb:=FSpeedButton6;
   else Exit;
  end;
  if (Sb<>nil){and(Sb.FState=bsDown)} then
    begin
        if (FAutoRepeat>0) and (FAutoRepEnabled) {and (Sb.Fstate=bsDown) }then
         begin
           Edit1Exit(Sb);
           Dec(FCountAutoRep);
         end;
    end;
  Application.Processmessages;

end;

procedure TFullCalendarAncestor.SetAutoRepeat(Val:word);
begin
FAutoRepeat:=Val;
if FTimAutoRep<>nil then
  begin
    FTimAutoRep.Interval:=Val;
  end;
end;


procedure TFullCalendarAncestor.SetDate(Val:TDateTime);
var f:boolean;
begin
f:=(Val<>Fdate);
if Not(csLoading in ComponentState) then
   Fdate:=Val
else Fdate:=Floor(Now);

DateShow;
if f then Change;
end;

procedure TFullCalendarAncestor.SetYearRange(Value:Word);
var Y,M,D:Word;
begin
FYearRange:=Value;
if FSpinYear<>nil then
  begin
    DecodeDate(Now,Y,M,D);
    FSpinYear.MaxValue:=Y+Value;
    FSpinYear.MinValue:=Y-Value;
  end;
end;

procedure TFullCalendarAncestor.ArrowImage(BitMap:TBitMap;Left:Boolean);
begin
  with Bitmap do
    begin
      Width:=FArrowSize; Height:=FArrowSize;
      with BitMap.Canvas do
        begin
          Brush.Color:=Color;
          Polygon( [Point(-1,-1),Point(BitMap.Width,-1),Point(BitMap.Width,BitMap.Height),Point(-1,BitMap.Height)]);
          Pen.Color:=clGray;
          Brush.Color:=clBlue;
          if Left then Polygon( [Point(3,(FArrowSize div 2)-1),Point(10,0),Point(10,FArrowSize-2)])
          else         Polygon( [Point(10,(FArrowSize div 2)-1),Point(3,0),Point(3,FArrowSize-2)]);
         end;
    end;
end;

procedure TFullCalendarAncestor.SetElems;
var LBm,RBm:TBitMap;WrkG:TCalSizes;
begin
LBm:=TBitMap.Create;
try
RBm:=TBitMap.Create;
try
WrkG:=SetSizesVsFont(Font.Size);

if WrkG.EditHeight<20 then FarrowSize:=((WrkG.EditHeight-6)div 2)*2 else FArrowSize:=16;
ArrowImage(LBm,True); ArrowImage(RBm,False);

With FEdit do
  begin
        Font:=Self.Font;
        Width:=WrkG.EditWidth; Top:=SP;Left:=(((Self.Width-2*SP)div 7)*7-4+SP*2-Width)div 2;
        OnExit:=Edit1Exit;OnKeyPress:=EditKeyPress; OnEnter:=ObtainFocus;
  end;
with FSpeedbutton1 do
  begin
    Top:=FEdit.Top;Left:=FEdit.Left+FEdit.Width+SP; Glyph:=RBm;
    Width:=((Self.Width-2*SP)div 7)*7-2-Left+SP;Height:=FEdit.Height;
    OnTick:=Edit1Exit;
    Show;
  end;
with FSpeedbutton2 do
  begin
    Top:=FEdit.Top;Left:=SP+2;Glyph:=LBm; Width:=FEdit.Left-2*SP;Height:=FEdit.Height;//GroupIndex:=0;NumGlyphs:=2;OnClick:=Edit1Exit;Show; OnMouseDown:=SbDown;OnMouseUp:=SbUp;
    OnTick:=Edit1Exit;    Show;
  end;
with FCLight do
  begin
        Font:=Self.Font;
        Top:=FSpeedButton1.Top+FSpeedButton1.Height+SP;
        Left:=SP+2;Width:= ((Self.Width-2*SP)div 7)*7-4;
        Height:=6*(WrkG.EditHeight-1);
        StartOfWeek:=1;OnChange:=Edit1Exit;
        OnDateDblClick:=CldrDateDoubleClick;
        OnDateClick:=CldrMouseClick;
        OnExit:=LoseFocus; OnEnter:=ObtainFocus;
  end;
try
with FComb do
  begin
    Font:=Self.Font;
    Top:=FCLight.Top+FCLight.Height+SP;Width:=FEDit.Width;
    Left:=FEdit.Left;Style:=csDropDownList; DropDownCount:=12;
    OnChange:=Edit1Exit; OnEnter:=ObtainFocus; OnExit:=LoseFocus;
  end;
except
end;
with FSpeedbutton3 do
  begin Top:=FComb.Top;Left:=FSpeedButton1.Left; Glyph:=RBm;Width:=FSpeedButton1.Width;
        Height:=FSpeedButton1.Height;
        OnTick:=Edit1Exit;    Show;
  end;
with FSpeedbutton4 do
  begin Top:=FComb.Top;Left:=FSpeedButton2.Left;Glyph:=LBm; Width:=FSpeedButton2.Width;
        Height:=FSpeedButton2.Height;
        OnTick:=Edit1Exit;    Show;
  end;
with FSpinYear do
  begin
    Font:=Self.Font;
    Top:=FSpeedButton3.Top+FSpeedButton3.Height+SP; width:=FEdit.Width;Left:=FEdit.Left;
    OnChange:=Edit1Exit; OnEnter:=ObtainFocus; OnExit:=LoseFocus;
  end;
with FSpeedbutton5 do
  begin Top:=FSpinYear.Top;Left:=FSpeedButton3.Left; Glyph:=RBm;
        Width:=FSpeedButton3.Width;Height:=FSpinYear.Height;
        OnTick:=Edit1Exit;    Show;
  end;
with FSpeedbutton6 do
  begin Top:=FSpeedButton5.Top;Glyph:=LBm;Left:=FSpeedButton4.Left; Width:=FSpeedButton4.Width;
        Height:=FSpeedButton5.Height;
        OnTick:=Edit1Exit;    Show;
  end;

finally
RBm.Free;
end;
finally
LBm.Free;
end;
FResultHeight:=FSpeedButton6.Top+FSpeedButton6.Height+SP;
FResultWidth:=Wrkg.EditWidth+(MINBUTTONWIDTH+2*SP)*2;
if FResultWidth<Wrkg.GridWidth+2*SP then FResultWidth:=Wrkg.GridWidth+2*SP
end;

procedure TFullCalendarAncestor.DateShow;
var i:integer;y,m,d:Word;
begin
  Fedit.OnChange:=Nil;
  FClight.OnChange:=Nil;
  FComb.OnChange:=Nil;
  FSpinYear.OnChange:=Nil;

// For use in data-aware descendants : converts null to now;
  if FDate=0 then FDate:=Floor(Now);

        if FCLight.ColorLight<>FLightColor then begin FCLight.ColorLight:=FLightColor; FCLight.Invalidate; end;
        if FCLight.ColorLightSelect<>FLightSelectColor then begin FCLight.ColorLightSelect:=FLightSelectColor; FCLight.Invalidate; end;
        if FCLight.ColorLightSunday<>FLightSundayColor then begin FCLight.ColorLightSunday:=FLightSundayColor; FCLight.Invalidate; end;
        if FCLight.ColorSunday<>FSundayColor then begin FCLight.ColorSunday:=FSundayColor; FCLight.Invalidate; end;
        if FCLight.StartOfWeek<>FStartOfWeek then begin FCLight.StartOfWeek:=FStartOfWeek; FCLight.Invalidate; end;
        if FCLight.WeekEnd<>FWeekEnd then begin FCLight.WeekEnd:=FWeekEnd; FCLight.Invalidate; end;


  if FComb.Items.Count<2 then
  begin
     FComb.Items.Clear;
     for i:=1 to 12 do
     {$IFNDEF VER150}
     begin
        FComb.Items.Add(TFormatSettings.Create.LongMonthNames[i]);
     end;
     {$ELSE}
        FComb.Items.Add(LongMonthNames[i]);
     {$ENDIF}
  end;
DecodeDate(FDate,Y,M,d);
FComb.ItemIndex:=M-1;FComb.Text:=FComb.Items[M-1];
if FSpinYear.MinValue=0 then
  begin
    FSpinYear.MinValue:=y-FYearRange-1;
    FSpinYear.MaxValue:=y+FYearRange+1;
  end;

SetSpinYear(y);
Fedit.Text:=DateToStr(FDate);
FCLight.CalendarDate:=FDate;

  if Assigned(FOnChange)
    and(FOnCreaChangeCall=0)
    and (NOT(csDesigning in ComponentState))
  then begin FOnCreaChangeCall:=-1; Change; end;;
  Fedit.OnChange:=Edit1Exit;
  FClight.OnChange:=Edit1Exit;
  FComb.OnChange:=Edit1Exit;
  FSpinYear.OnChange:=Edit1Exit;

end;

procedure TFullCalendarAncestor.WMPaint(var Message: TMessage);
begin
DateShow;
inherited;
if Assigned(FOnPaint) then fOnPaint(Self);
end;

procedure TFullCalendarAncestor.Edit1Exit(Sender: TObject);
var y,m,d,oldd,y0,m0,d0:Word; EndOfMonth:Boolean; ier:integer;
begin
Fedit.OnChange:=nil;
FClight.OnChange:=nil;
FComb.OnChange:=nil;
FSpinYear.OnChange:=nil;

DecodeDate(Now,Y0,M0,D0);
if (sender is TButPanel) then
  begin
    DecodeDate(FDate,y,m,d);
    EndOfMonth:=(d=DayInMonth(Fdate));
    Case (sender as TButPanel).Tag of
      1:Fdate:=Fdate+1.0;
      2:Fdate:=FDate-1.0;
      3:begin
         if m=12 then FDate:=EncodeDate(y+1,1,d)
         else
           if d>DayInMonth(EncodeDate(y,m+1,1))then
            FDate:=EncodeDate(y,m+1,DayInMonth(EncodeDate(y,m+1,1)))
           else FDate:=Encodedate(y,m+1,d);
         DecodeDate(Fdate,y,m,d); if EndOfMonth then Fdate:=EncodeDate(y,m,DayinMonth(FDate));
        end;
      4:begin
         if m=1 then FDate:=EncodeDate(y-1,12,d)
         else
           if d>DayInMonth(EncodeDate(y,m-1,1))then
            FDate:=EncodeDate(y,m-1,DayInMonth(EncodeDate(y,m-1,1)))
           else FDate:=Encodedate(y,m-1,d);
         DecodeDate(Fdate,y,m,d); if EndOfMonth then Fdate:=EncodeDate(y,m,DayinMonth(FDate));
        end;
      5: begin
           if Abs(y+1-y0)>YearRange then YearRange:=Abs(y+1-y0);
           if (m=2) and EndOfMonth then
            Fdate:=EncodeDate(y+1,m,DayInMonth(EncodeDate(y+1,2,1)))
           else Fdate:=EncodeDate(y+1,m,d);
         end;
      6:begin
           if Abs(y-1-y0)>5 then YearRange:=Abs(y-1-y0+1);
           if (m=2) and EndOfMonth then
            Fdate:=EncodeDate(y-1,m,DayInMonth(EncodeDate(y-1,2,1)))
           else Fdate:=EncodeDate(y-1,m,d);
         end;
    end;
    DecodeDate(FDate,y,m,d);
      with FCLight do
        begin
          oldD:=Day;
          Year:=y;
          if OldD>DayInMonth(Fdate) then
            begin
              Day:=d;
              Month:=M;
            end
          else
            begin
              Month:=m;
              Day:=d;
            end;
        end;
    SetSpinYear(y);
    FComb.ItemIndex:=m-1;
    DateTexts(FDate);
  end;
if Sender is TCalendarLighted then
  begin
   with (Sender as TCalendarLighted) do
      Fdate:=EncodeDate(Word(Year),word(Month),Word(Day));
   DateTexts(Fdate);
  end;
if  ( Sender is TEdit ) then
  begin
    try
      Fdate:=CorrectString_ToDate(FDate,FEdit.Text,ier);
      if ier<>0 then Exit;
      DecodeDate(Fdate,y,m,d);
      if y<1910 then y:=Y+100;
      Fdate:=EncodeDate(y,m,d);
      with FCLight do
        begin Year:=y;Month:=m;Day:=d;
        end;
      with FComb do
        begin
          ItemIndex:=m-1;Text:=Items[m-1];
        end;
      SetSpinYear(y);
      DateTexts(Fdate);
      LoseFocus(Fedit);
    except;
     Exit;
    end;
  end;
if Sender is TSpinEdit then
  begin
   With FCLight do
    begin
      Fdate:=EncodeDate(FSpinYear.Value,Month,Day);
      Year:=FSpinYear.Value;
    end;
   DateTexts(Fdate);
  end;
if (Sender is TComboBox) then
  begin
    m:=FComb.ItemIndex+1;
    With FCLight do
      begin
       if Day>DayInMonth(EncodeDate(Year,m,1)) then Day:=DayInMonth(EncodeDate(Year,m,1));
       Fdate:=EncodeDate(Year,m,Day);
       Month:=m;
      end;
    DateTexts(Fdate);
  end;

  Fedit.OnChange:=Edit1Exit;
  FClight.OnChange:=Edit1Exit;
  FComb.OnChange:=Edit1Exit;
  FSpinYear.OnChange:=Edit1Exit;

  if Sender is TButPanel then
    begin
      if (Sender as TButPanel).Down then Change;
    end
  else
  Change;
end;

function TFullCalendarAncestor.DayInMonth(Date:TDateTime):integer;
var y,m,d:word;
begin
 Decodedate(Date,y,m,d);
 case m of
  1,3,5,7,8,10,12:Result:=31;
  4,6,9,11:Result:=30;
  2: if ((y mod 4)=0) then Result:=29 else Result:=28;
  else Result:=30;// This string removes compilator warning
 end;
end;

procedure TFullCalendarAncestor.DateTexts(Date:TDateTime);
var y,m,d:word;
begin
DecodeDate(Date,y,m,d);
FEdit.Text:=DateToStr(Date);
try
  {$IFNDEF VER150}
  FComb.Text:=TFormatSettings.Create.LongMonthNames[m];
  {$ELSE}
  FComb.Text:=LongMonthNames[m];
  {$ENDIF}
except;
end;
end;

procedure TFullCalendarAncestor.EditKeyPress(Sender: TObject; var Key: Char);
begin
if (Key=#13) then Edit1Exit(FEdit);
end;

procedure TFullCalendarAncestor.AddDate(D:TDateTime);
var F:boolean;
begin
 F:=DateIsInList(D);
 FCLight.OnChange:=Nil;
 FCLight.AddDate(D);
 FCLight.OnChange:=Edit1Exit;
 if NOT F and Assigned(FonListChange) then FOnListChange(Self);
end;

procedure TFullCalendarAncestor.RemoveDate(D:TDateTime);
var F:boolean;
begin
 F:=DateIsInList(D);
 FCLight.OnChange:=Nil;
 FCLight.RemoveDate(D);
 FCLight.OnChange:=Edit1Exit;
 if F and Assigned(FonListChange) then FOnListChange(Self);
end;

procedure TFullCalendarAncestor.Clear;
begin
 FCLight.Clear;
 if Assigned(FOnClear) then FOnClear(Self);
end;

function TFullCalendarAncestor.FullHeight(editH,DigitH:integer) :integer;
begin
    Result:=7*(DigitH+1)+ 3*(editH+SP)+2*SP;
end;

function  TFullCalendarAncestor.SetSizesVsFont(ifs:integer{InitFontSize}):TCalSizes;
Const MARGSPACE=2; MINBUTT=15;
var i,j,k, maxdigw,maxH,maxMonW, CldrW,MonW,CldrH,eH:integer; Bm:TBitMap;
    e:TEdit;
    Clsz:TCalSizes;
    dz:TDateTime;
begin
   Dz:=EncodeDate(2000,12,31);
   Bm:=TBitMap.Create;
   MaxH:=0;MaxMonW:=0;MaxDigW:=0;
   try
     with Bm.Canvas do
       begin
         Font:=Self.Font;
         for i:=1 to 7 do
           begin
             j:=i;
             {$IFNDEF VER150}
             k:=TextWidth(TFormatSettings.Create.ShortDayNames[j]);
             {$ELSE}
             k:=TextWidth(ShortDayNames[j]);
             {$ENDIF}
             if MaxDigW<k then MaxDigW:=k; 
           end;
         for i:=1 to 12 do
           begin
             {$IFNDEF VER150}
             k:=TextWidth(TFormatSettings.Create.LongMonthNames[i]);
             {$ELSE}
             k:=TextWidth(LongMonthNames[i]);
             {$ENDIF}
             if MaxMonW<k then MaxMonW:=k;
             if MaxH<k then MaxH:=k;
           end;
          K:=TextWidth(DateToStr(Dz));
          if K>MaxMonW then MaxMonW:=k;
       end;
   finally
    Bm.Free;
   end;
   e:=TEdit.Create(Application);
   try
           e.Font.Name:=Self.Font.Name;
           e.Font.Size:=ifs;
           eH:=e.Height;
   finally
     e.Free;
   end;
   CldrW:=7*(MARGSPACE+MaxDigW)-3;
   MonW:=MaxMonW+4*MARGSPACE+MINBUTT;
   CldrH:=FullHeight(eH,eH);
   Clsz.GridWidth:=CldrW;
   Clsz.EditWidth:=MonW;
   Clsz.EditHeight:=eH;
   Clsz.FullHeight:=CldrH;
   Result:=Clsz;
end;

procedure TFullCalendarAncestor.SetSpinYear(y:integer);
begin
if (FSpinYear.MinValue<=y)and(FSpinYear.MaxValue>=y)then
    begin
       FSpinYear.Value:=y;
    end
else
    begin
      if FSpinYear.MinValue>y then
        begin
           FSpinYear.MinValue:=y; FYearRange:=Ceil(Abs(y-Now))+1;
           FSpinYear.Text:=IntToStr(y);
        end;
      if FSpinYear.MaxValue<y then
        begin
           FSpinYear.MaxValue:=y; FYearRange:=Ceil(Abs(y-Now))+1;
           FSpinYear.Text:=IntToStr(y);
        end;
    end;
end;

function TFullCalendarAncestor.CorrectString_toDate(ComponentDate:TDateTime;S:string; var ier:integer):TDateTime;
  var
    Sf, sy,sM,sD:string;
     ipl,iplm,ipld,  isep,
     ibeg,iend, ibegM,ibegD, iendM,iendD,
     i,yrem, ierint:integer;
    y,m,d, ycurr,mcurr,dcurr :word;
    DateSep: Char;
begin
 ier:=-1;
 {$IFNDEF VER150}
  DateSep:=TFormatSettings.Create.DateSeparator;
  sf:=TFormatSettings.Create.ShortDateFormat;
 {$ELSE}
  DateSep:=DateSeparator;
  sf:=ShortDateFormat;
 {$ENDIF}
 ipl:=0; isep:=0; iplm:=0; ipld:=0;
 for i:=1 to Length(sf) do
   begin
     if (UpperCase(sf[i])='Y')and (ipl=0) then ipl:=isep+1;
     if (UpperCase(sf[i])='D')and (ipld=0) then ipld:=isep+1;
     if (UpperCase(sf[i])='M')and (iplm=0) then iplm:=isep+1;
     if (sf[i]=DateSep)then inc(isep);
   end;  // ipl - the place of years
 isep:=0; ibeg:=0;iend:=0;  ibegM:=0;iendM:=0;  ibegD:=0;iendD:=0;
 for i:=1 to Length(S) do
   begin
     if (isep=ipl-1)and(ibeg=0)then ibeg:=i;
     if (isep=iplM-1)and(ibegM=0)then ibegM:=i;
     if (isep=iplD-1)and(ibegD=0)then ibegD:=i;
     if S[i]=DateSep then
       begin
         Inc(isep);
         if (isep=ipl) then iend:=i-1;
         if (isep=iplM) then iendM:=i-1;
         if (isep=iplD) then iendD:=i-1;
       end;
   end;
   if isep<>2 then begin ier:=-1; Result:=ComponentDate; Exit; end;
   if (ipl=3)and(iend=0) then iend:=length(S);
   if (ipl=3)and(iendM=0) then iendM:=length(S);
   if (ipl=3)and(iendD=0) then iendD:=length(S);
   sy:=Copy(s,ibeg, iend-ibeg+1);
   sm:=Copy(s,ibegM, iendM-ibegM+1);
   sd:=Copy(s,ibegD, iendD-ibegD+1);
   Val(sy,ycurr,ierint);
   if (ierInt<>0) then begin Result:=ComponentDate; ier:=-1; Exit; end;
   Val(sm,mcurr,ierint);
   if (ierInt<>0)or (mcurr<=0) or(mcurr>12) then begin Result:=ComponentDate; ier:=-1; Exit; end;
   Val(sd,dcurr,ierint);
   if (ierInt<>0)or (dcurr<=0) or(dcurr>31)  then begin Result:=ComponentDate; ier:=-1; Exit;end;

   DecodeDate(Date,y,m,d);
   yrem:=y mod 100;
   if length(sy)<=2 then
     begin
        if ((yRem mod 100)>80)and((ycurr mod 100)<50) then
          begin
            Delete(S,ibeg,iend-ibeg+1);
            Insert( IntToStr(((y div 100)+1)*100+StrToInt(sy)),s,ibeg);
            Delete(S,ibegM,iendM-ibegM+1);
            Insert( IntToStr(MCurr),s,ibegM);
            Delete(S,ibegD,iendD-ibegD+1);
            Insert( IntToStr(DCurr),s,ibegD);
            Result:=StrToDate(s);
            Ier:=0;
          end
        else
          begin
            Result:=StrToDate(s);
            Ier:=0;
          end;
     end
   else
     begin
       result:=StrToDate(S); ier:=0;
     end;
end;

function TFullCalendarAncestor.DateIsInList(D:TDateTime):Boolean;
begin
Result:=False;
if FCLight<>nil then
  Result:=FCLight.DateIsInList(D);
end;

procedure TFullCalendarAncestor.SetColorLight(Value:TColor);
begin
FLightColor:=Value;
if FCLight<>nil then
  begin
    FCLight.ColorLight:=Value;
    FCLight.InValidate;
  end;
end;

procedure TFullCalendarAncestor.SetColorLightSelect(Value:TColor);
begin
FLightSelectColor:=Value;
if FCLight<>nil then
  begin
    FCLight.ColorLightSelect:=Value;
    FCLight.InValidate;
  end;
end;

procedure TFullCalendarAncestor.SetColorLightSunday(Value:TColor);
begin
FLightSunDayColor:=Value;
if FCLight<>nil then
  begin
    FCLight.ColorLightSunday:=Value;
    FCLight.InValidate;
  end;
end;

procedure TFullCalendarAncestor.SetSundayColor(Value:TColor);
begin
FSunDayColor:=Value;
if FCLight<>nil then
  begin
    FCLight.ColorSunday:=Value;
    FCLight.Invalidate;
  end;
end;

function  TFullCalendarAncestor.GetStartOfWeek:integer;
begin
Result:=1;
if FCLight<>nil then
  Result:=FCLight.StartOfWeek;
end;

procedure TFullCalendarAncestor.SetStartOfWeek(Value:integer);
begin
FStartOfWeek:=(Value mod 7);
if FCLight<>nil then
  begin
    FCLight.StartOfWeek:=FStartOfWeek;
    FCLight.Invalidate;
  end;
end;

procedure TFullCalendarAncestor.SetWeekEnd(Value:TLightDay);
begin
FWeekEnd:=Value;
if FCLight<>nil then
  begin
    FCLight.WeekEnd:=Value;
    FCLight.Invalidate;
  end;
end;

procedure TFullCalendarAncestor.LoseFocus(Sender:TObject);
begin
 if NOT(Fedit.Focused or FCLight.Focused or FSpinYear.Focused or FComb.Focused )
 then
   begin
     FHasFocus:=False;
     if Assigned(FOnExit) then FonExit(Self);
   end;
end;

procedure TFullCalendarAncestor.ObtainFocus(Sender:TObject);
begin
     if (NOT FHasFocus) and Assigned(FOnEnter) then
       begin
         FHasFocus:=True;
         FOnEnter(Self);
       end;
end;

procedure TFullCalendarAncestor.CldrDoubleClick(Sender:TObject);
begin
  if Assigned(FDateDblClick) then FDateDblClick(Sender,Self.Date);
end;

procedure TFullCalendarAncestor.CldrDateDoubleClick(Sender:TObject;
                                CldrDate:TDateTime);
begin
  if Assigned(FDateDblClick) then FDateDblClick(Self,Self.Date);
end;

procedure TFullCalendarAncestor.CldrMouseClick(Sender:TObject; CldrDate:TDateTime;
                                               Button:TMouseButton);
begin
 if Assigned(FOnDateClick) then
     FOnDateClick(Self,CldrDate,Button);
end;

procedure TFullCalendarAncestor.SetFocus;
begin
 FEdit.SetFocus;
end;

function TFullCalendarAncestor.Focused:boolean;
begin
  result:=FHasFocus;
end;

function TFullCalendarAncestor.GetEnabled:Boolean;
begin
  Result:=FCalendarEnabled;
end;

procedure TFullCalendarAncestor.SetEnabled(Value:Boolean);
begin
FCLight.Enabled:=Value;
FEdit.Enabled:=Value;
FSpinYear.Enabled:=Value;
FComb.Enabled:=Value;
FCalendarEnabled:=Value;
Invalidate;
end;

procedure TFullCalendarAncestor.SetAutoRepEnabled(Value:Boolean);
begin
 FAutoRepEnabled:=Value;
 FTimAutoRep.Enabled:=Value;
end;

procedure TFullCalendarAncestor.Change;
begin
 if Assigned(fOnChange) then FOnChange(Self);
end;

function TFullCalendarAncestor.GetDateFromList(i:integer):TDateTime;
begin
  Result:=FCLight[i];
end;

{TFullCalendarLight}
constructor TFullCalendarLight.Create(AOwner:TComponent);
begin
 inherited;
 FInternalResizeCount:=0;
end;

function TFullCalendarLight.SetSizesVsFont(ifs:integer{InitFontSize}):TCalSizes;
var C:TFullCalendarAncestor; u:TCalSizes;
begin
  u.GridWidth:=0;u.EditWidth:=0;u.FullHeight:=0;u.EditHeight:=0;
 C:=TFullCalendarAncestor.Create(Self);
  try
    C.Font:=Font;
    C.Font.Size:=ifs;
    u:=C.SetSizesVsFont(ifs);
    C.SetElems;
    u.FullHeight:=C.ResultHeight;
    result:=u;
  finally
    C.Free;
  end;
end;

function TFullCalendarLight.YSize(Size:integer):integer;
var C:TFullCalendarAncestor;
begin
 C:=TFullCalendarAncestor.Create(Self);
  try
    C.Visible:=False;
    C.Font:=Font;
    C.ParentFont:=False;
    C.Font.Size:=Size;
    C.SetElems;
    Result:=C.ResultHeight;
  finally
    C.Free;
//    C:=nil;
  end;
end;


procedure TFullCalendarLight.SetElems;
begin
  inherited;
end;

procedure TFullCalendarLight.WMSize(var Message: TWMSize);
var U:TResizeState; iFs:integer;
begin
  iFs:=OptimalFontSize(U);
  Font.Size:=ifs;

  case U of
    rsNormal: begin
              end;
    rsMinimal,
    rsMaximal:begin
                    SetElems;
                    Height:=ResultHeight;
              end;
  end;
  if Width<ResultWidth then Width:=ResultWidth;
  inherited;
  FineElemAlign;
  Invalidate;
end;

procedure TFullCalendarLight.FineElemAlign;
var     AllVSpace,AllVRemain,AllVSHift:integer;
begin
          Calendar.Height:=(Calendar.Height div 7)*7+3;
          AllVSpace:=Height-Calendar.Height-Edit.Height-ComboBox.Height-SpinEdit.Height-SP*2-2;
          while AllVSpace<0 do
            begin
              Calendar.Height:=Calendar.Height-7;
              AllVSpace:=Height-Calendar.Height-Edit.Height-ComboBox.Height-SpinEdit.Height-SP*2-2;
            end;
          AllVRemain:=AllVSpace mod 5;
          AllVShift:= AllVSpace div 5;

          case AllVRemain of
               1:  begin
                    Edit.Top:=SP+AllVShift; Button1.Top:=Edit.Top;Button2.Top:=Edit.Top;
                    Calendar.Top:=Edit.Top+Edit.Height+AllVShift;
                    ComboBox.Top:=Calendar.Top+Calendar.Height+AllVShift; Button4.Top:=ComboBox.Top;Button3.Top:=ComboBox.Top;
                    SpinEdit.Top:=ComboBox.Top+ComboBox.Height+AllVShift+2; Button5.Top:=SpinEdit.Top; Button6.Top:=SpinEdit.Top;
                   end;
            0,2: begin
                    Edit.Top:=SP+AllVShift; Button1.Top:=Edit.Top;Button2.Top:=Edit.Top;
                    Calendar.Top:=Edit.Top+Edit.Height+AllVShift;
                    ComboBox.Top:=Calendar.Top+Calendar.Height+AllVShift+1; Button4.Top:=ComboBox.Top;Button3.Top:=ComboBox.Top;
                    SpinEdit.Top:=ComboBox.Top+ComboBox.Height+AllVShift+1; Button5.Top:=SpinEdit.Top; Button6.Top:=SpinEdit.Top;
                   end;
                3: begin
                    Edit.Top:=SP+AllVShift; Button1.Top:=Edit.Top;Button2.Top:=Edit.Top;
                    Calendar.Top:=Edit.Top+Edit.Height+AllVShift;
                    ComboBox.Top:=Calendar.Top+Calendar.Height+AllVShift+2; Button4.Top:=ComboBox.Top;Button3.Top:=ComboBox.Top;
                    SpinEdit.Top:=ComboBox.Top+ComboBox.Height+AllVShift+1; Button5.Top:=SpinEdit.Top; Button6.Top:=SpinEdit.Top;
                   end;
                4: begin
                    Edit.Top:=SP+AllVShift; Button1.Top:=Edit.Top;Button2.Top:=Edit.Top;
                    Calendar.Top:=Edit.Top+Edit.Height+AllVShift;
                    ComboBox.Top:=Calendar.Top+Calendar.Height+AllVShift+2; Button4.Top:=ComboBox.Top;Button3.Top:=ComboBox.Top;
                    SpinEdit.Top:=ComboBox.Top+ComboBox.Height+AllVShift+2; Button5.Top:=SpinEdit.Top; Button6.Top:=SpinEdit.Top;
                   end;
          end;

            if Width>=(((Calendar.Width-3) div 7)+1)*7+3+2*SP then
              Calendar.Width:=(((Width-2*SP)-3) div 7)*7+3;
            Calendar.Left:=(Width-Calendar.Width) div 2;
            Button2.Left:=Calendar.Left; Button1.Left:=Calendar.Left+Calendar.Width-Button1.Width;
            Button4.Left:=Calendar.Left; Button3.Left:=Button1.Left;
            Button6.Left:=Calendar.Left; Button5.Left:=Button1.Left;
            Edit.Left:=   (Width-Edit.Width) div 2-2;
            ComboBox.Left:=Edit.Left;
            SpinEdit.Left:=Edit.Left;
        end;

function TFullCalendarLight.OptimalFontSize(var ResState:TResizeState):integer;
var ifs,i: integer; OptFind:boolean;
    ArH:array [6..51] of integer;
begin
        for i:=6 to 51 do ArH[i]:=0;
        ifs:=6;  OptFind:=False;
      while (ifs<=50) and ( Not OptFind) do
        begin
          if Arh[ifs]=0 then begin ArH[ifs]:=YSize(ifs); end;
          if ArH[ifs+1]=0 then  begin ArH[ifs+1]:=YSize(ifs+1); end;
          if  (ifs=6) and (ArH[6]>Height) then OptFind:=True
            else
              if (ifs=50) and (ArH[50]<Height)then begin  Inc(ifs);end
                else
                  if (ArH[ifs]<=Height)and(ArH[ifs+1]>=Height) then
                   begin
                     OptFind:=True;
                   end
                    else Inc(Ifs);
        end;
  case ifs of
  6:ResState:=rsMinimal;
  51:ResState:=rsMaximal;
  else ResState:=rsNormal;
  end;
  Result:=ifs;
end;

procedure TFullCalendarLight.Loaded;
begin
 setElems;
 if Width<ResultWidth then Width:=ResultWidth;
 Invalidate;
 Application.Processmessages;
inherited;
end;

procedure TFullCalendarLight.WMPaint(var Message: TMessage);
var Ms:TWMSize;
begin
if FInternalResizeCount=0 then // First appear;
 begin
   Ms.Msg:=WM_SIZE;
   Ms.SizeType:=SIZE_RESTORED;
   ms.Width:=Width;
    ms.Height:=Height;
   Inc(FInternalResizeCount,1000);
   WMSize(Ms);
 end;
inherited;
end;

{TDBFullCalendarLight}
constructor TDBFullCalendarLight.Create(Owner: TComponent);
begin
inherited;
fDataLink:=TFieldDataLink.Create;
fDataLink.Control:=Self;
fDataLink.OnDataChange:=DataChange;
fDataLink.OnUpdateData:=UpdateData;
end;

destructor TDBFullCalendarLight.Destroy;
begin
fDataLink.Free;
fDataLink:=nil;
inherited;
end;

procedure TDBFullCalendarLight.DateShow;
begin
 inherited;
end;

procedure TDBFullCalendarLight.CmGetDataLink(var Msg: TMessage);
begin
  Msg.Result:=LongInt(fDataLink);
end;


function TDBFullCalendarLight.GetDataField: string;
begin
  Result:= fDataLink.FieldName;
end;

function TDBFullCalendarLight.GetDataSource: TDataSource;
begin
    Result:= fDataLink.DataSource;
end;

function TDBFullCalendarLight.GetField: TField;
begin
    Result:= fDataLink.Field;
end;

function TDBFullCalendarLight.GetReadOnly: Boolean;
begin
   Result:= fDataLink.ReadOnly;
end;

procedure TDBFullCalendarLight.Notification(Component: TComponent;
  Operation: TOperation);
begin
  inherited Notification(Component,Operation);
  if (fDataLink <> nil) and
     (Component = DataSource) and
     (Operation = opRemove)
  then DataSource:= nil;
end;

procedure TDBFullCalendarLight.SetDataField(const Field: string);
begin
    fDataLink.FieldName:= Field
end;

procedure TDBFullCalendarLight.SetDataSource(DataSource: TDataSource);
begin
   if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := DataSource;
  if DataSource <> nil then DataSource.FreeNotification(Self);
end;

procedure TDBFullCalendarLight.SetReadOnly(ReadOnly: Boolean);
begin
    fDataLink.ReadOnly:= ReadOnly;
end;

procedure TDBFullCalendarLight.UpdateData(Sender: TObject);
begin
  if fUpdatingData then   FDataLink.Field.asDateTime := Date;
end;

procedure TDBFullCalendarLight.DataChange(Sender: TObject);
begin
if (fDataLink.Field<>nil) and (NOT fUpdatingData )then
  if Floor(Self.Date)<>fDataLink.Field.asDateTime then Date:=fDataLink.Field.asDateTime;
  fUpdatingData:=False;
end;

procedure TDBFullCalendarLight.KeyPress(var Key: Char);
var
  DateSep: Char;
begin
   {$IFNDEF VER150}
   DateSep := TFormatSettings.Create.DateSeparator;
   {$ELSE}
   DateSep := DateSeparator;
   {$ENDIF}
   if (fDataLink.Field <> nil) then
    begin
      if Key = #27 then
        begin
          fDataLink.Reset;
          SetFocus;
          Key:= #0;
        end
      else

       case Key of
       '0'..'9' : fDataLink.Edit;
       else
         if Key=DateSep then fDataLink.Edit;
       end;
    end;
  inherited KeyPress(Key);
end;

procedure TDBFullCalendarLight.CmExit(var Msg: TCMExit);
begin
  try
   if FDataLink.Field<>nil then
   if FDataLink.Field.AsDateTime<>Date then
      begin
         FDataLink.Edit;
         fDataLink.ModiFied;
         fDataLink.Field.AsDateTime:=Date;
         fDataLink.UpdateRecord;
      end;
  except
   SetFocus;
   Raise;
  end;
  inherited;
end;

procedure TDBFullCalendarLight.Change;
begin
 inherited;
 if FDataLink.Field<>nil then
   if FDataLink.Field.AsDateTime<>Date then
     begin
      fUpdatingData:=True;
      fDataLink.Edit;
      fDataLink.Modified;
      fDataLink.Field.AsDateTime:=Date;
     end;
end;

{TCacheMonths}
function SdaP(P1,P2:Pointer):integer;
begin
if PCacheDates(P1)^.D<PCacheDates(P2)^.D then begin Result:=-1 end
else
   if PCacheDates(P1)^.D>PCacheDates(P2)^.D then begin Result:=1 end
   else
     Result:=0;
end;

destructor TCacheMonths.Destroy;
begin
Clear;
inherited;
end;

procedure TCacheMonths.SortDates;
begin
  Sort(SdaP);
end;

procedure TCacheMonths.Clear;
var i:integer; P:PCacheDates;
begin
  for i:=0 to count-1 do
    begin
      P:=PCacheDates(Items[i]);
      Dispose(P);
    end;
 inherited;
end;

function TCacheMonths.DateIsInList(D:TDateTime):Boolean;
var y,m,e:word; i:integer; d1:TDateTime; P,P1:PCacheDates;
begin
  if Count=0 then begin Result:=False; exit; end;
  DecodeDate(D,y,m,e);
  D1:=EncodeDate(y,m,1);
  P:=PCacheDates(Items[0]);
  P1:=PCacheDates(Items[Count-1]);
  if (D1<P^.D) or (D1>P1^.D)then begin Result:=False; exit; end;
  Result:=False;
  for i:=0 to Count-1 do
    begin
      P:=PCacheDates(Items[i]);
      if D1=P^.D then begin Result:=true; Break; end;
    end;
end;

procedure TCacheMonths.AddDate(D:TDateTime;var ArrDays:TMonArDay);
var y,m,e:word; P:PCacheDates; i:integer;
begin
  DecodeDate(D,y,m,e);
  if Not DateIsInList(D) then
    begin
       New(P);
       P^.D:=EncodeDate(y,m,1);
       for i:=1 to 31 do P^.A[i]:=ArrDays[i];
       Add(Pointer(P));
       SortDates;
    end;
end;

function TCacheMonths.DateState(D:TDateTime;var A:TMonArDay):Boolean;
var i,j:integer; y,m,e:word; P:PCacheDates; D0:TDateTime;
begin
  if Not DateIsInList(D) then begin Result:=False; Exit; end;
  DecodeDate(D,y,m,e);
  D0:=EnCodeDate(y,m,1);
  Result:=False;
  for i:=0 to count-1 do
    begin
       P:=PCacheDates(Items[i]);
       if (P^.D>=D0)then
         begin
           for j:=1 to 31 do  A[j]:=P^.A[j];
           Result:=True;
           Break;
         end;
    end;
end;

(*
{TDBQFullCalendarLight}
constructor TDBQFullCalendarLight.Create(AOwner:TComponent);
begin
 inherited;
 FCache:=TCacheMonths.Create;
 Q:=TQuery.Create(Self);
  FTimRedraw:=TTimer.Create(Self);
  FTimRedraw.Interval:=2*AutoRepeat;
  FTimRedraw.OnTimer:=Redraw;
  FTimRedraw.Enabled:=True;
  FQuoted:=False;
end;

destructor  TDBQFullCalendarLight.Destroy;
begin
 FTimRedraw.Enabled:=False; FTimRedraw.OnTimer:=Nil;
 FTimRedraw.Free;
 Q.Close; Q.Free;
 Fcache.Free;
 inherited;
end;

procedure TDBQFullCalendarLight.Redraw(A:TObject);
var y,m,d:word;
begin

     if FTimRedraw=nil then exit;
     DecodeDate(Date,y,m,d);
     if (NOT ((Fm=m) and (Fy=y)))and(Q.State=dsInactive)
     then
       begin
          if (csDesigning in ComponentState)
              and NOT(csLoading in ComponentState)
          then
             CreaQuery;
         Fm:=m; Fy:=y;
       end;
end;

procedure TDBQFullCalendarLight.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FT <> nil) and (AComponent = FT) then FT := nil;
  end;
end;

procedure TDBQFullCalendarLight.CreaQuery;
var  y,m,d,y1,m1:word; C:TMemo; A:TMonArDay; id:integer; D0:TDateTime;
begin

if (Q.State<>dsInactive) then Exit;
 try

 DecodeDate(Date,y,m,d);
 D0:=EncodeDate(y,m,1);
 m1:=m+1; y1:=y;
 if M1=13 then begin m1:=1; y1:=y+1 end;
 if (FT<>nil)and (FLUFIeld<>'')and(NOT (csDesigning in ComponentState))
    and (NOT (csLoading in ComponentState))
 then
   begin
    if Not FCache.DateIsInList(D0) then
     begin
     try
       if Q.State<>dsInactive then Q.Close;
       while Q.State<>dsInactive do Application.ProcessMessages;

       Q.DataBaseName:=FT.DataBasename;
       Q.SessionName:=FT.SessionName;
       Q.SQL.Clear;

               Q.SQL.Add(Format('select distinct w.%s from %s w where (w.%s>="%d/%d/%d")and((w.%s<"%d/%d/%d"))',
                         [FLUField,FT.TableName,FLUField,m,1,y,FLUField,m1,1,y1]));
       C:=TMemo.create(Self);
       try
         C.Text:='';
         C.Top:=Calendar.Top;
         C.Left:=Calendar.Left;
         C.Width:=Calendar.Width;
         C.Height:=Calendar.Height;
         C.Parent:=self;
         C.Show;
         if NOT FQuoted then
           begin

             try
              if (FErCount<3)or FT.Active then
                Q.Open;
             except
               Inc (FErCount);
               FQuoted:=True;
             end;
           end
         else
           begin
              Q.Close;
              Q.SQL.Clear;
       Q.SQL.Add(Format('select distinct w."%s" from "%s" w where (w."%s">="%d/%d/%d")and((w."%s"<"%d/%d/%d"))',
                         [FLUField,FT.TableName,FLUField,m,1,y,FLUField,m1,1,y1]));
             try
               if  (FErCount<3)or FT.Active then
                 Q.Open;
             except
               Inc(FErCount);
               FQuoted:=False;
             end;
           end;
//          Clear;
          for id:=1 to 31 do a[id]:=False;

        while Not Q.EOF do
          begin
            AddDate(Q.Fields[0].AsDateTime);
            A[Floor(Q.Fields[0].AsDateTime-D0+1.0001)]:=true;
            Q.Next;
          end;

         Fcache.AddDate(D0,A);
       finally
          C.Visible:=False;
        C.Free;
       end;

     finally
       Q.Close;
     end;
     end
     else
       begin
//         Clear;
         if FCache.DateState(D0,A) then
           begin
             for id:=1 to 31 do
               if A[id] then AddDate(D0+id-1);
           end;
       end;
   end;
finally
QueryFlag:=False;

end;

end;

procedure TDBQFullCalendarLight.Change;
var y,m,d:word;
begin
 if Ft<>nil then
   begin
     DecodeDate(Self.Date,y,m,d);
     if NOT ((Fm=m) and (Fy=y)) then
       begin
         CreaQuery;
         Fm:=m; Fy:=y;
       end;
   end;
 inherited;
 Invalidate;
end;

procedure TDBQFullCalendarLight.Loaded;
begin
  inherited;
  CreaQuery;
  DataChange(Self);
end;

procedure TDBQFullCalendarLight.Refresh;
begin
  Clear;
  CreaQuery;
  inherited;
end;

procedure TDBQFullCalendarLight.Clear;
begin
 FCache.Clear;
 inherited;
end;
*)
end.
