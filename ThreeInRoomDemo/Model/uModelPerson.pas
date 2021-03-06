unit uModelPerson;

interface

uses
  uSoTypes,
  uModel, uModelClasses, uLogicAssets, uSoObjectDefaultProperties;

type
  TGnome = class(TRoomObject)
  private
    FDestination: TDestination;
    FActivated: TNotifyEvent;
    FLevelController: TLevelController;
    procedure OnActivate(ASender: TObject);
  protected
    FActivator: TActivator;
    FName: string;
    function GetLevel: Integer; override;
    procedure SetLevel(const Value: Integer); override;
  public
    property Activated: TNotifyEvent read FActivated write FActivated;
    procedure AddDestination(const APoint: TPointF);
    procedure MoveTo(const AX, AY: Integer); override;
    procedure JumpTo(const APoint: TPointF);
    procedure Init; override;
  end;

  TTy = class(TGnome)
  private
    procedure Init; override;
  end;

  TRi = class(TGnome)
  private
    procedure Init; override;
  end;

  TOn = class(TGnome)
  private
    procedure Init; override;
  end;

implementation

{ TGnome }

procedure TGnome.AddDestination(const APoint: TPointF);
var
  vLevelCorrect: TPointF;
begin
  vLevelCorrect := TPointF.Create(
    0,
    (-FContainer[RenditionRect].Val<TRectObject>.Height * 0.5 + FLevel * 32)  * FContainer.ScaleY
  );
  FDestination.Value := APoint + vLevelCorrect;
end;

function TGnome.GetLevel: Integer;
begin
  Result := FLevelController.Level;
end;

procedure TGnome.Init;
var
  vName: string;
begin
  inherited;
  vName := FName;

  FLevelController := TLevelController.Create;

  FLevels := TLevels.Create(FContainer, TRectF.Create(17, 7, 53, 18), TRectF.Empty, TRectF.Empty);
  FContainer['LevelMap'].Val<TLevelMap>.AddLevels(FLevels);

  FDestination := TDestination.Create;
  FActivator := TActivator.Create;//(Self);
  FActivator.OnActivate := OnActivate;
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    with AddColliderObj('Ri1') do
    begin
      AddOnBeginContactHandler(TLogicAssets.OnCollideAsteroid);
    end;
    AddProperty('Destination', FDestination);
    AddProperty('Activator', FActivator);
    AddProperty('LevelController', FLevelController);
    AddMouseHandler(ByStaticRect).OnMouseLongPress := TLogicAssets.OnGnomeLongPress;
    AddNewLogic(TLogicAssets.MovingToDestination);
  end;
end;

procedure TGnome.JumpTo(const APoint: TPointF);
begin

end;

procedure TGnome.MoveTo(const AX, AY: Integer);
begin
  inherited;
  FDestination.Value := FContainer.Position.XY;
end;

procedure TGnome.OnActivate(ASender: TObject);
begin
  if Assigned(FActivated) then
    FActivated(Self);
end;

procedure TGnome.SetLevel(const Value: Integer);
begin
  inherited;
  FLevelController.Level := Value;
end;

{ TTy }

procedure TTy.Init;
begin
  FName := 'Ty';
  inherited;
end;

{ TRi }

procedure TRi.Init;
begin
  FName := 'Ri';
  inherited;
end;

{ TOn }

procedure TOn.Init;
begin
  FName := 'On';
  inherited;
end;

end.
