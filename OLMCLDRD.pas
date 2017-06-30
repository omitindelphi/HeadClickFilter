unit OLMCLDRD;

interface

uses Windows, Messages, SysUtils, Classes,Math
     ,DB
     //,DBTables,
     //DsgnIntf, // This is D5 stuff
     ,DesignIntf ,DesignEditors,
     OLM_Cldr
     ;

type
TDateProperty = class(TFloatProperty)
private
    function AlignDateFormat(sdf:string):string;
    function SetProperDate(S:string; var Ier:integer):TDateTime;
public
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
end;

(*
TQLookFieldProperty = class(TStringProperty)
  private
   FAt:TPropertyAttributes;
  public
    procedure Activate;override;
    function GetAttributes: TPropertyAttributes; override;
    function GetEditLimit: Integer; override;
    procedure GetValues(Proc: TGetStrProc);override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
end;
*)

procedure Register;

implementation
{TDateProperty}
function TDateProperty.AlignDateFormat(sdf:string):string;
var i,ybeg,ylen:integer;
begin
ybeg:=0;ylen:=0;
for i:=1 to length(sdf) do
  begin
    if (ybeg=0)and(UpperCase(sdf[i])='Y')then ybeg:=i;
    if i>1 then
      if (ybeg<>0)and (UpperCase(sdf[i])<>'Y')and(UpperCase(sdf[i-1])='Y')then Ylen:=i-ybeg;
  end;
Delete(Sdf,ybeg,ylen);
insert('yyyy',Sdf,ybeg);
Result:=sdf;
end;

function TDateProperty.GetValue: string;
var u:double;Z:TdateTime;
begin

 u:=GetFloatValue;
 Z:=u;
 {$IFNDEF VER150}
 Result:=FormatDateTime(AlignDateFormat(TformatSettings.Create.ShortDateFormat),Z);
 {$ELSE}
 Result:=FormatDateTime(AlignDateFormat(ShortDateFormat),Z);
 {$ENDIF}
end;

function TDateProperty.SetProperDate(S:string; var Ier:integer):TDateTime;
var Sf,sy:string;ipl,isep,ibeg,iend,i,yrem:integer;y,m,d:word;
    DateSep:Char;
begin
 {$IFNDEF VER150}
 DateSep:=TFormatSettings.Create.DateSeparator;
 sf:=TFormatSettings.Create.ShortDateFormat;
 {$ELSE}
 DateSep:=DateSeparator;
 sf:=ShortDateFormat;
 {$ENDIF}
 ier:=-1;
 ipl:=0; isep:=0;
 for i:=1 to Length(sf) do
   begin
     if (UpperCase(sf[i])='Y')and (ipl=0) then ipl:=isep+1;
     if (sf[i]=DateSep)then inc(isep);
   end;  // ipl - the place of years
 ibeg:=0;iend:=0;isep:=0;
 for i:=1 to Length(S) do
   begin
     if (isep=ipl-1)and(ibeg=0)then ibeg:=i;
     if S[i]=DateSep then
       begin
         Inc(isep);
         if (isep=ipl) then iend:=i-1;
       end;
   end;
   if (ipl=3)and(iend=0) then iend:=length(S);
   sy:=Copy(s,ibeg, iend-ibeg+1);
   DecodeDate(Date,y,m,d);
   yrem:=y mod 100;
   if length(sy)<=2 then
     begin
        if (yRem>80)and(StrToInt(sy)<50) then
          begin
            Delete(S,ibeg,iend-ibeg+1);
            Insert( IntToStr(((y div 100)+1)*100+StrToInt(sy)),s,ibeg);
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

procedure TDateProperty.SetValue(const Value: string);
var  u0,u:double; Ok:Boolean; ier:integer;
begin
 u:=0;
 u0:=GetFloatValue;
 Ok:=False;
 try
   u:=SetProperDate(Value,ier);
   OK:=True;
 except;
 end;
 if Ok then SetFloatValue(u) else SetFloatValue(u0);
 SetFloatValue(u);
end;

(*
{TQLookFieldProperty}
procedure TQLookFieldProperty.Activate;
var FQ:TDBQFullCalendarLight;
begin
  FQ:=(GetComponent(0) as TDBQFullCalendarLight);
  if (FQ.LookUpTable=nil) or (FQ.LookUpTable.State=dsInactive) then Fat:=[]
  else FAt:=[paValueList];
end;

function TQLookFieldProperty.GetAttributes: TPropertyAttributes;
begin
  Result:=Fat;
end;

function TQLookFieldProperty.GetEditLimit: Integer;
begin
 Result:=60;
end;

procedure TQLookFieldProperty.GetValues(Proc: TGetStrProc);
var
  FQ:TDBQFullCalendarLight;
  I: Integer;
begin
FQ:=(GetComponent(0) as TDBQFullCalendarLight);
if NOT((FQ.LookUpTable=nil) or (FQ.LookUpTable.State=dsInactive)) then
  begin
    for i:=0 to FQ.LookUpTable.FieldCount-1 do
      begin
        if (FQ.LookUpTable.Fields[i] is TDateTimeField) then
          begin
            Proc(FQ.LookUpTable.Fields[i].FieldName);
          end;
      end;
  end;
end;

function TQLookFieldProperty.GetValue: string;
begin
 Result:=inherited GetValue;
end;

procedure TQLookFieldProperty.SetValue(const Value: string);
begin
 inherited;
end;
*)

procedure Register;
begin
//  RegisterComponents('OLMComps', [TCalendarLighted]);
//  RegisterComponents('OLMComps', [TFullCalendarLight]);
//  RegisterComponents('OLMComps', [TDBFullCalendarLight]);
//  RegisterComponents('OLMComps', [TDBQFullCalendarLight]);

  RegisterPropertyEditor(TypeInfo(TDateTime),
                  TFullCalendarLight, 'Date',
                 TDateProperty);
//  RegisterPropertyEditor(TypeInfo(String),
//                  TDBQFullCalendarLight, 'LookUpField',
//                 TQLookFieldProperty);
end;

end.
