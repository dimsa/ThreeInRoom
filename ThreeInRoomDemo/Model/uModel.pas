unit uModel;

interface

uses
  uSoObject, uSoTypes, uLogicAssets, uUnitManager, System.SysUtils, uSoObjectDefaultProperties,
  FMX.Dialogs, uGeometryClasses, uSoColliderObjectTypes, uCommonClasses, uAcceleration,
  uModelClasses;

type
  TGameUnit = class
  private
    FLevel: Integer;
    procedure SetLevel(const Value: Integer);
  protected
    FContainer: TSoObject;
    FManager: TUnitManager;
    FRect: TRectObject;
    FLevels: TLevels;
    procedure Init; virtual;
    procedure RandomizePosition(const ASubject: TSoObject);
    function Margin: TPointF; virtual;
  public
    function Height: Single;
    function Width: Single;
    procedure Scale(const AScale: Single);
    procedure Resize; virtual;
    procedure MoveTo(const AX, AY: Integer);
    procedure Show;
    procedure Hide;
    function Rect: TRectF;
    procedure PreventOverlapFor(const AUnit: TGameUnit);
    function GetVisualPosition: Single;
    procedure SendToFront;
    property Level: Integer read FLevel write SetLevel;
    function IsPointIn(const AP: TPointF): Boolean;
    constructor Create(const AManager: TUnitManager); virtual;
  end;

  TRoom = class(TGameUnit)
  private
    FCell: TPointF;
    function Margin: TPointF; override;
  public
    procedure Init; override;
    property Cell: TPointF read FCell;
    procedure Resize; override;
  end;

  TRoomObject =  class(TGameUnit)
  public
    procedure Init; override;
  end;

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

uses
  uSoSprite, uUtils, uSoSound, uSoColliderObject, uE2DRendition;

{ TGameUnit }

procedure TGameUnit.SendToFront;
begin
  FContainer[Rendition].Val<TEngine2DRendition>.SendToFront;//.BringToBack;//;
end;

procedure TGameUnit.SetLevel(const Value: Integer);
begin
  FLevel := Value;
end;

procedure TGameUnit.Show;
begin
  FContainer[Rendition].Val<TEngine2DRendition>.Enabled := True;
end;

constructor TGameUnit.Create(const AManager: TUnitManager);
begin
  FManager := AManager;
  Init;
end;

function TGameUnit.GetVisualPosition: Single;
begin
  Result := FContainer.Y + (FContainer.Height / 2) * FContainer.ScaleY;
end;

function TGameUnit.Height: Single;
begin
  Result := FContainer.Height;
end;

procedure TGameUnit.Hide;
begin
  FContainer[Rendition].Val<TEngine2DRendition>.Enabled := False;
end;

procedure TGameUnit.Init;
begin
  with FManager.New do begin
    FContainer := ActiveContainer;
    AddProperty('World', FManager.ObjectByName('World'));
  end;
end;

function TGameUnit.IsPointIn(const AP: TPointF): Boolean;
begin
  Result := FLevels.IsPointIn(AP, FLevel);
end;

function TGameUnit.Margin: TPointF;
begin
  Result := TPointF.Create(0, 0);
end;

procedure TGameUnit.MoveTo(const AX, AY: Integer);
var
  vW, vH, vDw, vDh: Single;
  vWorld: TSoObject;
  vScale: Single;
  vMarg: TPointF;
begin
  vWorld := FManager.ObjectByName('World');
  vScale := vWorld.Height / 1024;
  vW := 640 * Abs(vScale);
  vH := 1024 * Abs(vScale);
  vDw := vW / 20;
  vDh := vH / 32;

  vMarg := Margin;
  FContainer.X := vMarg.X + vDw * Ax;
  FContainer.Y := vMarg.Y + vDh * 12 + vDh * Ay;
end;

procedure TGameUnit.PreventOverlapFor(const AUnit: TGameUnit);
var
  vRend1, vRend2: TEngine2DRendition;
begin
  if GetVisualPosition > AUnit.GetVisualPosition then
  begin
    if Self.Rect.IntersectsWith(AUnit.Rect) then
    begin
      FContainer[Rendition].Val<TEngine2DRendition>.Opacity := 0.6;
      Exit;
    end;
  end;
  FContainer[Rendition].Val<TEngine2DRendition>.Opacity := 1;//.BringToBack;//;
end;

procedure TGameUnit.RandomizePosition(const ASubject: TSoObject);
begin
  ASubject.X := Random(Round(FManager.ObjectByName('World').Width));
  ASubject.Y := Random(Round(FManager.ObjectByName('World').Height));
end;

function TGameUnit.Rect: TRectF;
begin
  if FRect = nil then
    FRect := FContainer[Rendition].Val<TEngine2DRendition>.Rect;

  Result := FRect.Rect.Multiply(FContainer.ScalePoint);
  Result.Offset(FContainer.Center);
end;

procedure TGameUnit.Resize;
begin

end;

procedure TGameUnit.Scale(const AScale: Single);
begin
  FContainer.Scale := AScale;
end;

{rocedure TGameUnit.Scale(const AScale: Single);
begin
  FContainer.Scale := AScale;
//  FContainer.X := FContainer.X * AScale;
//  FContainer.Y := FContainer.Y * AScale;
end;  }

function TGameUnit.Width: Single;
begin
  Result := FContainer.Width;
end;

procedure TBed.Init;
var
  vName: string;
begin
  inherited;

  FLevels := TLevels.Create(FContainer, TRectF.Empty, TRectF.Create(6, 33, 308, 107), TRectF.Empty);

  vName := 'Bed';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TChair }

procedure TChair.Init;
var
  vName: string;
begin
  inherited;

  FLevels := TLevels.Create(FContainer, TRectF.Empty, TRectF.Create(24, 52, 87, 80), TRectF.Empty);

  vName := 'Chair';
  with FManager.ByObject(FContainer) do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TTabouret }

procedure TTabouret.Init;
var
  vName: string;
begin
  inherited;

  FLevels := TLevels.Create(FContainer, TRectF.Create(5, 6, 90, 56), TRectF.Empty, TRectF.Empty);

  vName := 'Tabouret';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

  RandomizePosition(FContainer);
end;

{ TCactus }

procedure TCactus.Init;
var
  vName: string;
begin
  inherited;

  FLevels := TLevels.Create(FContainer, TRectF.Empty, TRectF.Empty, TRectF.Empty);

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

  FLevels := TLevels.Create(FContainer, TRectF.Empty, TRectF.Create(2, 2, 188, 133), TRectF.Empty);

  vName := 'Table';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddColliderObj(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;

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

{ TRoom }

procedure TRoom.Init;
var
  vName: string;
begin
  vName := 'Room';

  with FManager.New(vName) do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
  end;

  FContainer.X := 0;
  FContainer.Y := 0;
end;

function TRoom.Margin: TPointF;
begin
  Result := TPointF.Create(FContainer.Width * FContainer.ScaleX * 0.5, FContainer.Height * FContainer.ScaleY * 0.5);
end;

procedure TRoom.Resize;
begin
  inherited;

  {vWorld := FManager.ObjectByName('World');
  vScale := vWorld.Height / 1024;
  vW := 640 * Abs(vScale);
  vH := 1024 * Abs(vScale);
  FCell.X := vW / 20;
  FCell.Y := vH / 32;   }

  FContainer.Center := Margin;
end;


{ TRoomObject }

procedure TRoomObject.Init;
var
  vRoom: TSoObject;
begin
  inherited;
  vRoom := FManager.ByName('Room').ActiveContainer;
  with FManager.ByObject(FContainer) do
    AddProperty('Room', vRoom);
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

  FLevels := TLevels.Create(FContainer, TRectF.Empty, TRectF.Empty, TRectF.Create(7, 6, 120, 200));

  vName := 'Windowsill';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
    AddNewLogic(TLogicAssets.MovingThroughSides);
  end;
end;

end.
