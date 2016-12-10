unit uUnitCreator;

interface

uses
  uSoTypes, uGeometryClasses,
  uEngine2DClasses, uUnitManager, uWorldManager, uModel, uSoObject;

type
  TGameUnitFriend = class(TGameUnit);

  TUnitCreator = class
  private
    FUnitManager: TUnitManager;
  public
    function NewBed: TBed;
    function NewCactus: TCactus;
    function NewChair: TChair;
    function NewTabouret: TTabouret;
    function NewTable: TTable;
    function NewGnome: TGnome;
    constructor Create(const AUnitManager: TUnitManager);
  end;

implementation

uses
  uLogicAssets;

{ TUnitCreator }

constructor TUnitCreator.Create(const AUnitManager: TUnitManager);
begin
  FUnitManager := AUnitManager;
end;

function TUnitCreator.NewBed: TBed;
begin
  Result := TBed.Create(FUnitManager);
end;

function TUnitCreator.NewCactus: TCactus;
begin
  Result := TCactus.Create(FUnitManager);
end;

function TUnitCreator.NewChair: TChair;
begin
  Result := TChair.Create(FUnitManager);
end;

function TUnitCreator.NewGnome: TGnome;
begin
  Result := TGnome.Create(FUnitManager);
end;

function TUnitCreator.NewTable: TTable;
begin
  Result := TTable.Create(FUnitManager);
end;

function TUnitCreator.NewTabouret: TTabouret;
begin
  Result := TTabouret.Create(FUnitManager);
end;

end.