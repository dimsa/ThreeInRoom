unit uUnitCreator;

interface

uses
  System.SysUtils,
  uSoTypes, uGeometryClasses,
  uEngine2DClasses, uUnitManager, uWorldManager, uModel, uSoObject, uModelPerson,
  uModelHero, uModelClasses, uModelRoomObject, uModelItem;

type
  TGameUnitFriend = class(TGameUnit);

  TUnitCreator = class
  private
    FUnitManager: TUnitManager;
    FLevelMap: TLevelMap;
    function NewGnome: TGnome;
  public
    function NewRoom: TRoom;
    function NewBed: TBed;
    function NewCactus: TCactus;
    function NewChair: TChair;
    function NewTabouret: TTabouret;
    function NewTable: TTable;
    function NewLocker: TLocker;
    function NewLamp: TLamp;
    function NewTy: TGnome;
    function NewRi: TGnome;
    function NewOn: TGnome;
    function NewWindowSill: TWindowSill;
    function NewSpaghetti: TSpaghetti;
    function NewArkadiy: TArkadiy;

    function NewKey: TKeyItem;
    function NewCoat: TCoatItem;
    function NewHat: THatItem;
    function NewBoots: TBootsItem;

    function NewHero(const AName: string): THeroIcon; overload;
    function NewHero(const ANumber: Integer): THeroIcon; overload;

    constructor Create(const AUnitManager: TUnitManager; const ALevelMap: TLevelMap);
  end;

implementation

uses
  uLogicAssets;

{ TUnitCreator }

constructor TUnitCreator.Create(const AUnitManager: TUnitManager; const ALevelMap: TLevelMap);
begin
  FUnitManager := AUnitManager;
  FLevelMap := ALevelMap;
end;

function TUnitCreator.NewArkadiy: TArkadiy;
begin
  Result := TArkadiy.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewBed: TBed;
begin
  Result := TBed.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewBoots: TBootsItem;
begin
  Result := TBootsItem.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewCactus: TCactus;
begin
  Result := TCactus.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewChair: TChair;
begin
  Result := TChair.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewCoat: TCoatItem;
begin
  Result := TCoatItem.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewGnome: TGnome;
begin
  Result := TGnome.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewHat: THatItem;
begin
  Result := THatItem.Create(FUnitManager, FLevelMap);
  Result.Level := 3;
end;

function TUnitCreator.NewHero(const ANumber: Integer): THeroIcon;
begin
  case ANumber of
    0: Result := NewHero('Ty');
    1: Result := NewHero('Ri');
    2: Result := NewHero('On');
  end;
end;

function TUnitCreator.NewKey: TKeyItem;
begin
  Result := TKeyItem.Create(FUnitManager, FLevelMap);
  Result.Level := 3;
end;

function TUnitCreator.NewHero(const AName: string): THeroIcon;
begin
  if LowerCase(AName) = 'ty' then
    Result := TTyHero.Create(FUnitManager);

  if LowerCase(AName) = 'ri' then
    Result := TRiHero.Create(FUnitManager);

  if LowerCase(AName) = 'on' then
    Result := TOnHero.Create(FUnitManager);

  if LowerCase(AName) = 'arkadiy' then
    Result := TArkadiyHero.Create(FUnitManager);
end;

function TUnitCreator.NewLamp: TLamp;
begin
  Result := TLamp.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewLocker: TLocker;
begin
  Result := TLocker.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewOn: TGnome;
begin
  Result := TOn.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewRi: TGnome;
begin
  Result := TRi.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewRoom: TRoom;
begin
  Result := TRoom.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewSpaghetti: TSpaghetti;
begin
  Result := TSpaghetti.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewTable: TTable;
begin
  Result := TTable.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewTabouret: TTabouret;
begin
  Result := TTabouret.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewTy: TGnome;
begin
  Result := TTy.Create(FUnitManager, FLevelMap);
end;

function TUnitCreator.NewWindowSill: TWindowSill;
begin
  Result := TWindowSill.Create(FUnitManager, FLevelMap);
end;

end.
