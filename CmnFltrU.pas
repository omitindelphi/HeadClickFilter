unit CmnFltrU;
//------------------------------------------//
//      Oleg Mitine (Oleg Meeting)          //
//      June 2001                           //
//------------------------------------------//

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfCmnFltr = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    bbNo: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCmnFltr: TfCmnFltr;

implementation

{$R *.DFM}

procedure TfCmnFltr.FormResize(Sender: TObject);
begin
 bbOk.Width:=(ClientWidth-16)div 3;
 bbNo.Width:=(ClientWidth-16)div 3;
 bbCancel.Width:=(ClientWidth-16)div 3;
 bbOk.Left:=4;
 bbNo.Left:=8+bbOk.Width;
 bbCancel.Left:=12+bbOk.Width+bbNo.Width;
 Edit1.Width:=ClientWidth-8;
 Edit1.Left:=4;
end;

end.
