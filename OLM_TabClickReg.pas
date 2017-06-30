unit OLM_TabClickReg;
//-----------------------------------------//
//      Oleg Mitin (Oleg Meeting)          //
//      June 2004-June 2013                //
//-----------------------------------------//
interface
uses
  Classes,
  OLM_Cldr,
  OLM_DblClnd,
  OLMHeadClickFilter
  ;
procedure Register;

implementation
procedure Register;
begin
  RegisterComponents('OLMComps', [TCalendarLighted]);
  RegisterComponents('OLMComps', [TFullCalendarLight]);
  RegisterComponents('OLMComps', [TDBFullCalendarLight]);
 // RegisterComponents('OLMComps', [TDBQFullCalendarLight]);

//  RegisterPropertyEditor(TypeInfo(TDateTime),
//                  TFullCalendarLight, 'Date',
//                 TDateProperty);
//  RegisterPropertyEditor(TypeInfo(String),
//                  TDBQFullCalendarLight, 'LookUpField',
//                 TQLookFieldProperty);

  RegisterComponents('OLMComps', [TDoubleCalendar]);
  RegisterComponents('OLMComps', [THeadClickFilter]);
end;

end.
