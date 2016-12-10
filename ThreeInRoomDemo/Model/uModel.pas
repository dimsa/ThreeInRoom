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
    procedure Init; virtual; abstract;
    procedure RandomizePosition(const ASubject: TSoObject);
  public
    constructor Create(const AManager: TUnitManager); virtual;
  end;

  TRoomObject =  class(TGameUnit)
  public

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

procedure TGameUnit.RandomizePosition(const ASubject: TSoObject);
begin
  ASubject.X := Random(Round(FManager.ObjectByName('World').Width));
  ASubject.Y := Random(Round(FManager.ObjectByName('World').Height));
//  ASubject.Rotate := Random(360);
end;

procedure TBed.Init;
var
  vName: string;
begin
  vName := 'Bed';
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
    AddProperty('World', FManager.ObjectByName('World'));
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TChair }

procedure TChair.Init;
var
  vName: string;
begin
  vName := 'Chair';
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
    AddProperty('World', FManager.ObjectByName('World'));
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TTabouret }

procedure TTabouret.Init;
var
  vName: string;
begin
  vName := 'Tabouret';
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
    AddProperty('World', FManager.ObjectByName('World'));
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TCactus }

procedure TCactus.Init;
var
  vName: string;
begin
  vName := 'Cactus';
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
    AddProperty('World', FManager.ObjectByName('World'));
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TTable }

procedure TTable.Init;
var
  vName: string;
begin
  vName := 'Table';
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
    AddProperty('World', FManager.ObjectByName('World'));
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
  vName := 'Gnome';
  FDestination := TDestination.Create;
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    with AddColliderObj('Gnome1') do
    begin
      AddOnBeginContactHandler(TLogicAssets.OnCollideAsteroid);
    end;
    AddProperty('World', FManager.ObjectByName('World'));
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
  vName := 'Locker';
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
    AddProperty('World', FManager.ObjectByName('World'));
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
  vName := 'LampYellow';
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
    AddProperty('World', FManager.ObjectByName('World'));
    AddNewLogic(TLogicAssets.MovingThroughSides);
    AddMouseHandler(ByCollider).OnMouseDown := TLogicAssets.OnTestMouseDown;
  end;

  RandomizePosition(FContainer);
end;

end.
