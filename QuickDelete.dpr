program QuickDelete;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Quick Delete';
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
