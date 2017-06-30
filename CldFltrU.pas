unit CldFltrU;
//------------------------------------------//
//      Oleg Mitine (Oleg Meeting)          //
//      June 2001                           //
//------------------------------------------//
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, math, OLM_DblClnd;

type
  TfCldFltr = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    bbNO: TBitBtn;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fDou:TDoubleCalendar;
  public
    { Public declarations }
    property Dou:TDoublecalendar read fDou write fDou;
  end;

var
  fCldFltr: TfCldFltr;

implementation

{$R *.DFM}

procedure TfCldFltr.FormResize(Sender: TObject);
begin
  bbOK.Width:= min(105,((ClientWidth - bbNO.Width -20) div 2));
  bbCancel.Width:=bbOK.Width;
  bbOK.Left:=((ClientWidth - bbNo.Width)div 4 )-(bbOK.Width div 2);
  bbNO.Left:=(ClientWidth div 2)-(bbNO.Width div 2);
  bbCancel.Left:=((ClientWidth+(ClientWidth div 2)+(bbNo.Width div 2))div 2)-(bbCancel.Width div 2);
end;

procedure TfCldFltr.FormCreate(Sender: TObject);
begin
   fDou:=TDoubleCalendar.Create(Self);
   fDou.Align:=alClient;
   fDou.Parent:=Self;

end;

end.
