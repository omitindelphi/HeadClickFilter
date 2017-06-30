# HeadClickFilter

HeadclickFilter - permits search by substring in any column of dataset

DoubleCalendar - very convenient to mark interval between two calendar dates

CalendarLight  - marks certain data on calendar


All of calendars designed for visual presentation of day's conditions, 
all of calendars represent the month grid of colored days, all of them resizeable. 
Every day in month grid  can be marked (enlighhtened).

To show the set of enlightened days in calendar best use the family of FullCalendarLight components.

TCalendarLighted - direct descendant of TCalendar, 
inherits its resizeability in union with additional methods of FullCalendarLight family. 
This component is designed for creating other components, but you can use it as well.

TFullCalendarLight component - common month calendar with the autorepeatable increment/decrement buttons 
for year, month and day. Main features - resizeability in couple with the authomatic fitting of font size.

TDBFullCalendarLight - data-aware descendant of TFullCalendarLighted componeht, 
have the common Dataset and DataField properties. Display the value in DataField.
(Null values will be replaced by today date)

( excluded from D10 package as dependent on specific table vendors
TDBQFullCalendarLight - descendant of TDBFullCalendarLight. 
Automatically marks the days in accordance with data presence in other table. 
Designed specially for slow tables!
)

Attention: days have to be marked through program, not manually!

I tried make the properties and methods of component most obvious, 
so i don't think Help is neccecary. Here are main properties and methods:

in TCalendarLighted and in TFullCalendarLight:
ColorLight - Enlighted days painted with. 
ColorLightSunday - If enlighted day belongs to weekend, painted with this background.
ColorLightSelect - color of selected enlighted day (one cell only).
ColorSunday - ordinary (not enlightened) weekend days painted with this background.
WeekEnd property - set of days of week.

AddDate(D:TDateTime) method adds date to the list of enlightened days,
RemoveDate(D:TDateTime) removes this date.
Clear method erases all the enlighted data.
DateIsInlist(D:TDateTime) method returns true, if argument date is enlightened.
CountDate:integer - quantity of enlightened data
DatesLighted[i:integer] - list of them

in TDBFullCalendarLight:
added DataSource and DataField properties, common for all data-aware components.

(*in TDBQFullCalendarLight:
added LookUpTable and LookUpField properties. The days in this field of this table will be 
enlightened in TDBQFullCalendarLight. Data requests through SQL, so LookUp table can be not opened.
SQL requests only limited dataset (by month, hence count of records <=31), and internal caching permits
to avoid  query repeating. Works fine at PARADOX and INTERBASE.
*)

Questions and requests mail to olegregen@gmail.com

Mitin Oleg.
