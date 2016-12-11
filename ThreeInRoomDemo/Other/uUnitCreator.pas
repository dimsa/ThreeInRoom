unit uUnitCreator;

interface

uses
  uSoTypes, uGeometryClasses,
  uEngine2DClasses, uUnitManager, uWorldManager, uModel, uSoObject, uModelPerson;

type
  TGameUnitFriend = class(TGameUnit);

  TUnitCreator = class
  private
    FUnitManager: TUnitManager;
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

function TUnitCreator.NewArkadiy: TArkadiy;
begin
  Result := TArkadiy.Create(FUnitManager);
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

function TUnitCreator.NewLamp: TLamp;
begin
  Result := TLamp.Create(FUnitManager);
end;

function TUnitCreator.NewLocker: TLocker;
begin
  Result := TLocker.Create(FUnitManager);
end;

function TUnitCreator.NewOn: TGnome;
begin
  Result := TOn.Create(FUnitManager);
end;

function TUnitCreator.NewRi: TGnome;
begin
  Result := TRi.Create(FUnitManager);
end;

function TUnitCreator.NewRoom: TRoom;
begin
  Result := TRoom.Create(FUnitManager);
end;

function TUnitCreator.NewSpaghetti: TSpaghetti;
begin
  Result := TSpaghetti.Create(FUnitManager);
end;

function TUnitCreator.NewTable: TTable;
begin
  Result := TTable.Create(FUnitManager);
end;

function TUnitCreator.NewTabouret: TTabouret;
begin
  Result := TTabouret.Create(FUnitManager);
end;

function TUnitCreator.NewTy: TGnome;
begin
  Result := TTy.Create(FUnitManager);
end;

function TUnitCreator.NewWindowSill: TWindowSill;
begin
  Result := TWindowSill.Create(FUnitManager);
end;

end.
