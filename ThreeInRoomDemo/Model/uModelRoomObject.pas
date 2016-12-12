unit uModelRoomObject;

interface

uses
  uSoTypes,
  uModel, uModelClasses, uLogicAssets, uSoObjectDefaultProperties, uSoObject;

type
  TLeftTopRoomObject = class(TRoomObject)
  private
    function Margin: TPointF; override;
  end;

  TLeftBottomRoomObject = class(TRoomObject)
  private
    function Margin: TPointF; override;
  end;

  TBed =  class(TLeftTopRoomObject)
  public
    procedure Init; override;
  end;

  TChair =  class(TLeftBottomRoomObject)
  public
    procedure Init; override;
  end;

  TTabouret =  class(TLeftBottomRoomObject)
  public
    procedure Init; override;
  end;

  TCactus =  class(TLeftBottomRoomObject)
  public
    procedure Init; override;
  end;

  TTable =  class(TLeftBottomRoomObject)
  public
    procedure Init; override;
  end;

  TLocker = class(TLeftBottomRoomObject)
  private
    FIsOpened: Boolean;
    procedure SetIsOpened(const Value: Boolean);
  public
    procedure Init; override;
    property IsOpened: Boolean read FIsOpened write SetIsOpened;
  end;

  TLamp = class(TLeftBottomRoomObject)
  public
    procedure Init; override;
  end;

  TArkadiy = class(TLeftBottomRoomObject)
  public
    procedure Init; override;
  end;

  TSpaghetti = class(TLeftBottomRoomObject)
  public
    procedure Init; override;
  end;

  TWindowSill = class(TLeftTopRoomObject)
  public
    procedure Init; override;
  end;

implementation

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

  FLevels := TLevels.Create(
    FContainer,
    TRectF.Empty,
    TRectF.Create(6, 33, 308, 107).Move(TPointF.Create(-FContainer.Width * 0.5 * FContainer.ScaleX, -FContainer.Height * 0.5 * FContainer.ScaleY)),
    TRectF.Empty);
  FContainer['LevelMap'].Val<TLevelMap>.AddLevels(FLevels);

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

  FLevels := TLevels.Create(
    FContainer,
    TRectF.Empty,
    TRectF.Create(24, 52, 87, 80).Move(TPointF.Create(-FContainer.Width * 0.5 * FContainer.ScaleX, -FContainer.Height * 0.5 * FContainer.ScaleY)),
    TRectF.Empty);
  FContainer['LevelMap'].Val<TLevelMap>.AddLevels(FLevels);

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

  FLevels := TLevels.Create(
    FContainer,
    TRectF.Create(5, 6, 90, 56).Move(TPointF.Create(-FContainer.Width * 0.5 * FContainer.ScaleX, -FContainer.Height * 0.5 * FContainer.ScaleY)),
    TRectF.Empty,
    TRectF.Empty);
  FContainer['LevelMap'].Val<TLevelMap>.AddLevels(FLevels);

  RandomizePosition(FContainer);
end;

{ TCactus }

procedure TCactus.Init;
var
  vName: string;
begin
  inherited;

  FLevels := TLevels.Create(FContainer, TRectF.Empty, TRectF.Empty, TRectF.Empty);
  FContainer['LevelMap'].Val<TLevelMap>.AddLevels(FLevels);

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

  FLevels := TLevels.Create(
    FContainer, TRectF.Empty,
    TRectF.Create(2, 2, 188, 133).Move(TPointF.Create(-FContainer.Width * 0.5 * FContainer.ScaleX, -FContainer.Height * 0.5 * FContainer.ScaleY)),
    TRectF.Empty);
  FContainer['LevelMap'].Val<TLevelMap>.AddLevels(FLevels);

  RandomizePosition(FContainer);
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

{ TLeftTopRoomObject }

function TLeftTopRoomObject.Margin: TPointF;
var
  vRoom: TSoObject;
begin
  vRoom := FContainer['Room'].Val<TSoObject>;
  Result := TPointF.Create(FContainer.Width * vRoom.ScaleX * 0.5, FContainer.Height * vRoom.ScaleY * 0.5);
end;

{ TLeftBottomRoomObject }

function TLeftBottomRoomObject.Margin: TPointF;
var
  vRoom: TSoObject;
  vD: Single;
begin
  vRoom := FContainer['Room'].Val<TSoObject>;
  vD := (vRoom.Height * vRoom.ScaleX) / 32;
  Result := TPointF.Create(
    FContainer.Width * vRoom.ScaleX * 0.5,
    -FContainer.Height * vRoom.ScaleY * 0.5);
end;

{ TArkadiy }

procedure TArkadiy.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Arkadiy';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;
end;

{ TSpaghetti }

procedure TSpaghetti.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Spaghetti';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;
end;

{ TWindowSill }

procedure TWindowSill.Init;
var
  vName: string;
begin
  inherited;

  vName := 'Windowsill';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  FLevels := TLevels.Create(
    FContainer,
    TRectF.Empty,
    TRectF.Empty,
    TRectF.Create(7, 6, 120, 200).Move(TPointF.Create(-FContainer.Width * 0.5 * FContainer.ScaleX, -FContainer.Height * 0.5 * FContainer.ScaleY)));
  FContainer['LevelMap'].Val<TLevelMap>.AddLevels(FLevels);

end;

end.
