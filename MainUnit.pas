unit MainUnit;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.ShellAPI,
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.Controls, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Shape1: TShape;
    Label1: TLabel;
  private
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure DoDeleteFolder(const FolderName: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

{ TForm2 }

constructor TForm2.Create(AOwner: TComponent);
begin
  inherited;
  // Enable drag-and-drop from Explorer
  DragAcceptFiles(Handle, True);
end;

destructor TForm2.Destroy;
begin
  // Disable drag-and-drop
  DragAcceptFiles(Handle, False);
  inherited;
end;

procedure TForm2.DoDeleteFolder(const FolderName: string);
begin
  ShellExecute(0, 'open', 'cmd.exe', PWideChar('/C ' +  // Command
    'del /f /s /q "' + FolderName + '" > nul ' +
    '&& rmdir /s /q "' + FolderName + '"'), nil, SW_SHOWNORMAL);
end;

procedure TForm2.WMDropFiles(var Msg: TWMDropFiles);
var
  Count: Integer;
  FileName: array[0..MAX_PATH] of Char;
begin
  try
    Count := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);

    if Count > 0 then
    begin
      // Get the first dropped item
      DragQueryFile(Msg.Drop, 0, FileName, MAX_PATH);

      // Check if it's a folder
      if DirectoryExists(FileName) then
      begin
        if MessageDlg('Delete folder ' + FileName + ' and all files and subfolders in it? This cannot be undone.',
                      mtWarning, [mbYes, mbCancel], 0) = mrYes then
          DoDeleteFolder(FileName);
      end;
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

end.
