unit uGame;

interface

uses
  uClasses, uSoTypes, uEngine2DClasses, uWorldManager, uUnitManager, uMapPainter, uUnitCreator, uTemplateManager,
  uUtils, uModel, uSoManager, uSoObject;

type
  TGame = class
  private
    FObjects: TList<TGameUnit>;
    FMapPainter: TMapPainter; // Some object to draw parallax or map or etc
    FUnitCreator: TUnitCreator;
    FManager: TSoManager;
    FRoom: TRoom;
    FMouseDowned: Boolean;
    FGnome: TGnome;
    FWorld: TSoObject;
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

    FObjects := TList<TGameUnit>.Create;

    WorldManager.OnResize.Add(OnResize);
    WorldManager.OnMouseDown.Add(OnMouseDown);
    WorldManager.OnMouseUp.Add(OnMouseUp);
    WorldManager.OnMouseMove.Add(OnMouseMove);

    FWorld := UnitManager.ByName('World').ActiveContainer;
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
var
  vScale: Single;
  i: Integer;
begin

  vScale := FWorld.Height / 1024;
  FRoom.Scale(vScale);
  FRoom.Resize;

  for i := 0 to FObjects.Count - 1 do
  begin
    FObjects[i].Scale(vScale);
    FObjects[i].Resize;
  end;
end;

procedure TGame.StartGame;
var
  i: Integer;
begin
  Randomize;

  FRoom :=  FUnitCreator.NewRoom;
  FRoom.Scale(FWorld.Height / 1024);

  FObjects.Add(FUnitCreator.NewBed);
  FObjects.Last.MoveTo(9, 14);
  FObjects.Add(FUnitCreator.NewTabouret);
  FObjects.Last.MoveTo(10, 6);
  FObjects.Add(FUnitCreator.NewChair);
  FObjects.Last.MoveTo(1, 12);
  FObjects.Add(FUnitCreator.NewTable);
  FObjects.Last.MoveTo(1, 10);
  FObjects.Add(FUnitCreator.NewCactus);
  FObjects.Last.MoveTo(2, 4);
  FObjects.Add(FUnitCreator.NewLocker);
  FObjects.Last.MoveTo(8, 1);
  FObjects.Add(FUnitCreator.NewLamp);
  FObjects.Last.MoveTo(4, 2);
  FGnome := FUnitCreator.NewGnome;
  FObjects.Add(FGnome);

  OnResize(nil);

end;

end.
