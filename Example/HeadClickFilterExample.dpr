program HeadClickFilterExample;

uses
  Forms,
  HeadClickFilterExample_ in 'HeadClickFilterExample_.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
