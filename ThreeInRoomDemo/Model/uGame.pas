unit uGame;

interface

uses
  uClasses, uSoTypes, uEngine2DClasses, uWorldManager, uUnitManager, uMapPainter, uUnitCreator, uTemplateManager,
  uUtils, uModel, uSoManager;

type
  TGame = class
  private
    FObjects: TList<TRoomObject>;
    FMapPainter: TMapPainter; // Some object to draw parallax or map or etc
    FUnitCreator: TUnitCreator;
    FManager: TSoManager;
    FMouseDowned: Boolean;
    FGnome: TGnome;
    procedure StartGame;
    procedure OnResize(ASender: TObject);
    procedure OnMouseDown(Sender: TObject; AEventArgs: TMouseEventArgs);
    procedure OnMouseUp(Sender: TObject; AEventArgs: TMouseEventArgs);
    procedure OnMouseMove(Sender: TObject; AEventArgs: TMouseMoveEventArgs);
  public
    constructor Create(const AManager: TSoManager);
    destructor Destroy; override;
  end;

implementation

{ TGame }

constructor TGame.Create(const AManager: TSoManager);
begin
  FManager := AManager;

  with FManager do begin
    FMapPainter := TMapPainter.Create(WorldManager, ResourcePath('RoomBack.png'));
    FUnitCreator := TUnitCreator.Create(UnitManager);

    TemplateManager.LoadSeJson(ResourcePath('ThreeInRoom.sejson'));
    TemplateManager.LoadSeCss( ResourcePath('Formatters.secss'));

    FObjects := TList<TRoomObject>.Create;

    WorldManager.OnResize.Add(OnResize);
    WorldManager.OnMouseDown.Add(OnMouseDown);
    WorldManager.OnMouseUp.Add(OnMouseUp);
    WorldManager.OnMouseMove.Add(OnMouseMove);

    StartGame;
  end;
end;

destructor TGame.Destroy;
begin

  inherited;
end;

procedure TGame.OnMouseDown(Sender: TObject; AEventArgs: TMouseEventArgs);
begin
  FMouseDowned := True;
  FGnome.AddDestination(TPointF.Create(AEventArgs.X, AEventArgs.Y));
end;

procedure TGame.OnMouseMove(Sender: TObject; AEventArgs: TMouseMoveEventArgs);
begin
  if FMouseDowned then
    FGnome.AddDestination(TPointF.Create(AEventArgs.X, AEventArgs.Y));
end;

procedure TGame.OnMouseUp(Sender: TObject; AEventArgs: TMouseEventArgs);
begin
  FMouseDowned := False;
end;

procedure TGame.OnResize(ASender: TObject);
begin

end;

procedure TGame.StartGame;
var
  i: Integer;
begin
  Randomize;
  FUnitCreator.NewBed;
  FUnitCreator.NewCactus;
  FUnitCreator.NewTabouret;
  FUnitCreator.NewChair;
  FUnitCreator.NewTable;
  FGnome := FUnitCreator.NewGnome;
end;

end.
