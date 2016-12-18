unit uModelRoomObject;

interface

uses
  uSoTypes,
  uModel, uModelClasses, uLogicAssets, uSoObjectDefaultProperties, uSoObject;

type
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
    TRectF.Create(6, 32, 308, 107).Move(TPointF.Create(-FContainer.Width * 0.5 * FContainer.ScaleX, -FContainer.Height * 0.5 * FContainer.ScaleY)),
    TRectF.Empty);
  FContainer['LevelMap'].Val<TLevelMap>.AddLevels(FLevels);

  FMyHeightTree.AddZone(THeightZone.Create(6, 32, 308, 107, 64));
  FMyHeightTree.AddZone(THeightZone.Create(6, 152, 60, 166, 0, False));
  FMyHeightTree.AddZone(THeightZone.Create(258, 152, 312, 166, 0, False));
  FMyHeightTree.AddZone(THeightZone.Create(6, 68, 60, 82, 0, False));
  FMyHeightTree.AddZone(THeightZone.Create(258, 68, 312, 82, 0, False));
  FParentHeightTree.AddNode(FMyHeightTree);

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
    TRectF.Create(24, 54, 88, 79).Move(TPointF.Create(-FContainer.Width * 0.5 * FContainer.ScaleX, -FContainer.Height * 0.5 * FContainer.ScaleY)),
    TRectF.Empty);
  FContainer['LevelMap'].Val<TLevelMap>.AddLevels(FLevels);

  FMyHeightTree.AddZone(THeightZone.Create(24, 54, 88, 79, 32));
  FParentHeightTree.AddNode(FMyHeightTree);

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
    TRectF.Create(0, 0, 96, 64).Move(TPointF.Create(-FContainer.Width * 0.5 * FContainer.ScaleX, -FContainer.Height * 0.5 * FContainer.ScaleY)),
    TRectF.Empty,
    TRectF.Empty);

  FContainer['LevelMap'].Val<TLevelMap>.AddLevels(FLevels);

  FMyHeightTree.AddZone(THeightZone.Create(4, 3, 90, 55, 32));
  FMyHeightTree.AddZone(THeightZone.Create(4, 38, 93, 93, 0, False));
  FParentHeightTree.AddNode(FMyHeightTree);

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

  FMyHeightTree.AddZone(THeightZone.Create(4, 67, 28, 84, 0, False));
  FParentHeightTree.AddNode(FMyHeightTree);

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

  FMyHeightTree.AddZone(THeightZone.Create(4, 4, 187, 130, 0));
  FMyHeightTree.AddZone(THeightZone.Create(20, 175, 35, 190, 0, False));
  FMyHeightTree.AddZone(THeightZone.Create(157, 175, 172, 190, 0, False));
  FMyHeightTree.AddZone(THeightZone.Create(20, 50, 35, 65, 0, False));
  FMyHeightTree.AddZone(THeightZone.Create(157, 50, 172, 65, 0, False));
  FParentHeightTree.AddNode(FMyHeightTree);

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

  FMyHeightTree.AddZone(THeightZone.Create(10, 262, 150, 287, 0, False));
  FParentHeightTree.AddNode(FMyHeightTree);

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

  FMyHeightTree.AddZone(THeightZone.Create(20, 200, 80, 232, 0, False));
  FParentHeightTree.AddNode(FMyHeightTree);

  RandomizePosition(FContainer);
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

  FMyHeightTree.AddZone(THeightZone.Create(23, 237, 75, 267, 0, False));
  FParentHeightTree.AddNode(FMyHeightTree);
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
  FLevel := 2;
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

  FMyHeightTree.AddZone(THeightZone.Create(7, 7, 118, 197, 128));
  FParentHeightTree.AddNode(FMyHeightTree);

end;

end.
