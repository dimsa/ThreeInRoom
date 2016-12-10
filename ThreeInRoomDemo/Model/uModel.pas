unit uModel;

interface

uses
  uSoObject, uSoTypes, uLogicAssets, uUnitManager, System.SysUtils, uSoObjectDefaultProperties,
  FMX.Dialogs, uGeometryClasses, uSoColliderObjectTypes, uCommonClasses, uAcceleration,
  uModelClasses;

type
  TGameUnit = class
  protected
    FContainer: TSoObject;
    FManager: TUnitManager;
    procedure Init; virtual;
    procedure RandomizePosition(const ASubject: TSoObject);
  public
    procedure Scale(const AScale: Single);
    procedure MoveTo(const AX, AY: Integer);
    constructor Create(const AManager: TUnitManager); virtual;
  end;

  TRoomObject =  class(TGameUnit)
  public

  end;

  TRoom = class(TGameUnit)
  public
    procedure Init; override;
  end;

  TBed =  class(TRoomObject)
  public
    procedure Init; override;
  end;

  TChair =  class(TRoomObject)
  public
    procedure Init; override;
  end;

  TTabouret =  class(TRoomObject)
  public
    procedure Init; override;
  end;

  TCactus =  class(TRoomObject)
  public
    procedure Init; override;
  end;

  TTable =  class(TRoomObject)
  public
    procedure Init; override;
  end;

  TLocker = class(TRoomObject)
  private
    FIsOpened: Boolean;
    procedure SetIsOpened(const Value: Boolean);
  public
    procedure Init; override;
    property IsOpened: Boolean read FIsOpened write SetIsOpened;
  end;

  TLamp = class(TRoomObject)
  public
    procedure Init; override;
  end;

  TGnome =  class(TGameUnit)
  private
    FDestination: TDestination;
  public
    procedure AddDestination(const APoint: TPointF);
    procedure Init; override;
  end;

implementation

uses
  uSoSprite, uUtils, uSoSound, uSoColliderObject;

{ TGameUnit }

constructor TGameUnit.Create(const AManager: TUnitManager);
begin
  FManager := AManager;
  Init;
end;

procedure TGameUnit.Init;
begin
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddProperty('World', FManager.ObjectByName('World'));
  end;
end;

procedure TGameUnit.MoveTo(const AX, AY: Integer);
var
  vW, vH, vDw, vDh: Single;
  vWorld: TSoObject;
  vScale: Single;
begin
  vWorld := FManager.ObjectByName('World');
  vScale := vWorld.Height / 1024;
  vW := 640 * Abs(vScale);
  vH := 1024 * Abs(vScale);
  vDw := vW / 20;
  vDh := vH / 32;

  FContainer.X := vDw * Ax;
  FContainer.Y := vDh * 12 + vDh * Ay;
end;

procedure TGameUnit.RandomizePosition(const ASubject: TSoObject);
begin
  ASubject.X := Random(Round(FManager.ObjectByName('World').Width));
  ASubject.Y := Random(Round(FManager.ObjectByName('World').Height));
end;

procedure TGameUnit.Scale(const AScale: Single);
begin
  FContainer.Scale := AScale;
//  FContainer.X := FContainer.X * AScale;
//  FContainer.Y := FContainer.Y * AScale;
end;

procedure TBed.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Bed';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TChair }

procedure TChair.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Chair';
  with FManager.ByObject(FContainer) do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TTabouret }

procedure TTabouret.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Tabouret';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TCactus }

procedure TCactus.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Cactus';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TTable }

procedure TTable.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Table';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TGnome }

procedure TGnome.AddDestination(const APoint: TPointF);
begin
  FDestination.Value := APoint;
end;

procedure TGnome.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Gnome';
  FDestination := TDestination.Create;
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    with AddColliderObj('Gnome1') do
    begin
      AddOnBeginContactHandler(TLogicAssets.OnCollideAsteroid);
    end;
    AddProperty('Destination', FDestination);
    AddNewLogic(TLogicAssets.MovingToDestination);
  end;

  RandomizePosition(FContainer);
  FDestination.Value := FContainer.Position.XY;
end;

{ TLocker }

procedure TLocker.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Locker';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
    AddMouseHandler(ByCollider).OnMouseDown := TLogicAssets.OnTestMouseDown;
  end;

  RandomizePosition(FContainer);
end;

procedure TLocker.SetIsOpened(const Value: Boolean);
begin
  FIsOpened := Value;
end;

{ TLamp }

procedure TLamp.Init;
var
  vName: string;
begin
  inherited;
  vName := 'LampYellow';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
    AddMouseHandler(ByCollider).OnMouseDown := TLogicAssets.OnTestMouseDown;
  end;

  RandomizePosition(FContainer);
end;

{ TRoom }

procedure TRoom.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Room';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
  end;

  FContainer.X := 0;
  FContainer.Y := 0;
end;

end.
