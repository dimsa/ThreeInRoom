unit uModel;

interface

uses
  uSoObject, uSoTypes, uLogicAssets, uUnitManager, System.SysUtils, uSoObjectDefaultProperties,
  FMX.Dialogs, uGeometryClasses, uSoColliderObjectTypes, uCommonClasses, uAcceleration;

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
  ASubject.Rotate := Random(360);
end;

procedure TBed.Init;
var
  vName: string;
begin
  vName := 'Bed';
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj('Bed');
    AddProperty('World', FManager.ObjectByName('World'));
    AddNewLogic(TLogicAssets.MovingThroughSides);
    FContainer[Rendition].Val<TSoSprite>.BringToBack;
  end;

  RandomizePosition(FContainer);

end;

end.
