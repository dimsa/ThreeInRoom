unit uModelPerson;

interface

uses
  uSoTypes,
  uModel, uModelClasses, uLogicAssets, uSoObjectDefaultProperties;

type
  TGnome = class(TGameUnit)
  private
    FDestination: TDestination;
  public
    procedure AddDestination(const APoint: TPointF);
    procedure Init; override;
  end;

implementation

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
  vName := 'Ri';
  FDestination := TDestination.Create;
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    with AddColliderObj('Ri1') do
    begin
      AddOnBeginContactHandler(TLogicAssets.OnCollideAsteroid);
    end;
    AddProperty('Destination', FDestination);
    AddMouseHandler(ByStaticRect).OnMouseDown := TLogicAssets.OnTestMouseDown;
    AddNewLogic(TLogicAssets.MovingToDestination);
  end;

  RandomizePosition(FContainer);
  FDestination.Value := FContainer.Position.XY;
end;

end.
