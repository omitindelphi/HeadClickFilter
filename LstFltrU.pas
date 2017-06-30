unit LstFltrU;
//------------------------------------------//
//      Oleg Mitine (Oleg Meeting)          //
//      June 2001                           //
//------------------------------------------//

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfListFltr = class(TForm)
    ComboBox1: TComboBox;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    Label1: TLabel;
    bbNo: TBitBtn;
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fListFltr: TfListFltr;

implementation

{$R *.DFM}

procedure TfListFltr.FormResize(Sender: TObject);
begin
 ComboBox1.Width:=ClientWidth-8;
 ComboBox1.Left:=4;
 bbOk.Width:=(ClientWidth-16)div 3;
 bbNo.Width:=(ClientWidth-16)div 3;
 bbCancel.Width:=(ClientWidth-16)div 3;
 bbOk.Left:=4;
 bbNo.Left:=8+bbOk.Width;
 bbCancel.Left:=12+bbOk.Width+bbNo.Width;
end;

end.
