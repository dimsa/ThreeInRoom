unit uGame;

interface

uses
  System.Generics.Collections,
  uClasses, uSoTypes, uEngine2DClasses, uWorldManager, uUnitManager, uMapPainter, uUnitCreator, uTemplateManager,
  uUtils, uModel, uSoManager, uSoObject, uModelPerson, uModelHero, uModelClasses;

type
  TGame = class
  private
    FObjects: TList<TGameUnit>;
    FMapPainter: TMapPainter; // Some object to draw parallax or map or etc
    FUnitCreator: TUnitCreator;
    FManager: TSoManager;
    FRoom: TRoom;
    FMouseDowned: Boolean;
    FGnomes: TList<TGnome>;
    FActiveGnome: TGnome;
    FWorld: TSoObject;
    FLevelMap: TLevelMap;
    FIcons: TDict<TGameUnit, THeroIcon>;
    procedure StartGame;
    procedure OnResize(ASender: TObject);
    procedure OnMouseDown(Sender: TObject; AEventArgs: TMouseEventArgs);
    procedure OnMouseUp(Sender: TObject; AEventArgs: TMouseEventArgs);
    procedure OnMouseMove(Sender: TObject; AEventArgs: TMouseMoveEventArgs);
    procedure OnActivateGnome(ASender: TObject);
    procedure SortSprites(ASoObject: TSoObject);
  public
    constructor Create(const AManager: TSoManager);
    destructor Destroy; override;
  end;

implementation

{ TGame }

constructor TGame.Create(const AManager: TSoManager);
begin

  FGnomes := TList<TGnome>.Create;
  FIcons := TDict<TGameUnit, THeroIcon>.Create;
  FLevelMap := TLevelMap.Create;

  FManager := AManager;

  with FManager do begin
    FMapPainter := TMapPainter.Create(WorldManager, ResourcePath('RoomBack.png'));
    FUnitCreator := TUnitCreator.Create(UnitManager, FLevelMap);

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

  with FManager.UnitManager.ByObject(FWorld) do
  begin
    AddNewLogic(SortSprites);
  end;
end;

destructor TGame.Destroy;
begin
  FLevelMap.Free;
  FGnomes.Free;
  FIcons.Free;
  inherited;
end;

procedure TGame.OnActivateGnome(ASender: TObject);
var
  vUnit: TGameUnit;
begin
  FActiveGnome := TGnome(ASender);

  for vUnit in FIcons.Keys  do
  begin
    if vUnit <> FActiveGnome then
      FIcons[vUnit].Hide
    else
      FIcons[vUnit].Show;
  end;

end;

procedure TGame.OnMouseDown(Sender: TObject; AEventArgs: TMouseEventArgs);
begin
  FMouseDowned := True;
end;

procedure TGame.OnMouseMove(Sender: TObject; AEventArgs: TMouseMoveEventArgs);
begin
{  if FMouseDowned then
    if FActiveGnome <> nil then
      FActiveGnome.AddDestination(TPointF.Create(AEventArgs.X, AEventArgs.Y)); }
end;

procedure TGame.OnMouseUp(Sender: TObject; AEventArgs: TMouseEventArgs);
begin
  if FActiveGnome <> nil then
    FActiveGnome.AddDestination(TPointF.Create(AEventArgs.X, AEventArgs.Y));
  FMouseDowned := False;
end;

procedure TGame.OnResize(ASender: TObject);
var
  vScale: Single;
  i: Integer;
  vUnit: TGameUnit;
begin

  vScale := FWorld.Height / 1024;
  FRoom.Scale(vScale);
  FRoom.Resize;

  for i := 0 to FObjects.Count - 1 do
  begin
    FObjects[i].Scale(vScale);
    FObjects[i].Resize;
  end;

  for vUnit in FIcons.Values do
  begin
    vUnit.Scale(vScale);
  end;
end;

procedure TGame.SortSprites(ASoObject: TSoObject);
var
  i, j, iMax: Integer;

//  vIndArr: TArray<Integer>;
  vMax: Single;
  iOld: Integer;
  vPair: TPair<Integer,Single>;
  vArr: TArray<TPair<Integer,Single>>;
begin
  SetLength(vArr, FObjects.Count);

  for i := 0 to FObjects.Count - 1 do
  begin
    vArr[i].Key := i;
    vArr[i].Value := FObjects[i].GetVisualPosition;
  end;

  for i := 0 to High(vArr) do
  begin
    vMax := vArr[i].Value;
    iMax := i;//vArr[i].Key;
    for j := i + 1 to High(vArr) do
      if vArr[j].Value > vMax then
      begin
        iMax := j;
        vMax := vArr[j].Value;
      end;

    vPair := vArr[i];
    vArr[i] := vArr[iMax];
    vArr[iMax] := vPair;
  end;

  for i := High(vArr) downto 0 do
  begin
    FObjects[vArr[i].Key].SendToFront;

    if (not (FObjects[vArr[i].Key] is TGnome)) and (FActiveGnome <> nil) then
      FObjects[vArr[i].Key].PreventOverlapFor(FActiveGnome);
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

  FObjects.Add(FUnitCreator.NewWindowSill);
  FObjects.Last.MoveTo(17, 4);
  FObjects.Add(FUnitCreator.NewSpaghetti);
  FObjects.Last.MoveTo(4, 6);
  FObjects.Add(FUnitCreator.NewArkadiy);
  FObjects.Last.MoveTo(16, 1);


  FGnomes.Add(FUnitCreator.NewTy);
  FGnomes.Add(FUnitCreator.NewRi);
  FGnomes.Add(FUnitCreator.NewOn);

  for i := 0 to FGnomes.Count - 1 do
  begin
    FObjects.Add(FGnomes[i]);
    FGnomes[i].Activated := OnActivateGnome;
    FIcons.Add(FGnomes[i], FUnitCreator.NewHero(i));
    FIcons[FGnomes[i]].MoveTo(3, -9);
    FIcons[FGnomes[i]].Hide;
  end;
  OnResize(nil);

end;

end.
