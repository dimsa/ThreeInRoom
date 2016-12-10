unit uSoSimpleManager;

interface

uses
  uWorldManager, uUnitManager, uSoObject;

type
  TSoSimpleManager = class
  private
    FUnitManager: TUnitManager;
    FWorldManager: TWorldManager;
  public
    function New(const AName: string = ''): TUnitManager;
    function ByName(const AContainerName: string): TUnitManager;
    function ByObject(const AContainer: TSoObject): TUnitManager;
    function ObjectByName(const AObjectName: string): TSoObject;
    constructor Create(const AUnitManager: TUnitManager; const AWorldManager: TWorldManager);
  end;

implementation

{ TSoSimpleManager }

function TSoSimpleManager.ByName(const AContainerName: string): TUnitManager;
begin
  Result := FUnitManager.Manage(AContainerName);
end;

function TSoSimpleManager.ByObject(const AContainer: TSoObject): TUnitManager;
begin
  Result := FUnitManager.Manage(AContainer);
end;

constructor TSoSimpleManager.Create(const AUnitManager: TUnitManager; const AWorldManager: TWorldManager);
begin
  FUnitManager := AUnitManager;
  FWorldManager := AWorldManager;
end;

function TSoSimpleManager.New(const AName: string): TUnitManager;
begin
  Result := FUnitManager.ManageNew(AName);
end;

function TSoSimpleManager.ObjectByName(const AObjectName: string): TSoObject;
begin
  Result := FUnitManager.ObjectByName(AObjectName);
end;

end.

