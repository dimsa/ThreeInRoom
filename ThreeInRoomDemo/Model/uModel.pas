unit uModel;

interface

uses
  uSoObject, uSoTypes, uLogicAssets, uUnitManager, System.SysUtils, uSoObjectDefaultProperties,
  FMX.Dialogs, uGeometryClasses, uSoColliderObjectTypes, uCommonClasses, uAcceleration,
  uModelClasses;

type
  TGameUnit = class
  protected
    FContainer: TSoObject;
    FManager: TUnitManager;
    FRect: TRectObject;
    FLevels: TLevels;
    FLevel: Integer;
    procedure Init; virtual;
    procedure RandomizePosition(const ASubject: TSoObject);
    function Margin: TPointF; virtual;
    function GetLevel: Integer; virtual;
    procedure SetLevel(const Value: Integer); virtual;
  public
    function Height: Single;
    function Width: Single;
    procedure Scale(const AScale: Single);
    procedure Resize; virtual;
    procedure MoveTo(const AX, AY: Integer); virtual;
    procedure Show;
    procedure Hide;
    function Rect: TRectF;
    procedure PreventOverlapFor(const AUnit: TGameUnit);
    function GetVisualPosition: Single;
    procedure SendToFront;
    property Level: Integer read GetLevel write SetLevel;
    function IsPointIn(const AP: TPointF): Boolean;
    constructor Create(const AManager: TUnitManager); virtual;
  end;

  TRoom = class(TGameUnit)
  private
    FLevelMap: TLevelMap;
    FLevels0: TLevels;
    FHeightTree: THeightTree;
    FCell: TPointF;
    function Margin: TPointF; override;
  public
    procedure Init; override;
    property Cell: TPointF read FCell;
    procedure Resize; override;
    constructor Create(const AManager: TUnitManager; const ALevelMap: TLevelMap; const AHeightTree: THeightTree); virtual;
  end;

  TRoomObject = class(TGameUnit)
  protected
    FLevelMap: TLevelMap;
    FMyHeightTree: THeightTree;
    FParentHeightTree: THeightTree;
  public
    procedure Init; override;
    constructor Create(const AManager: TUnitManager; const ALevelMap: TLevelMap; const AHeightTree: THeightTree); virtual;
  end;

  TLeftTopRoomObject = class(TRoomObject)
  private
    function Margin: TPointF; override;
  end;

  TLeftBottomRoomObject = class(TRoomObject)
  private
    function Margin: TPointF; override;
  end;

implementation

uses
  uSoSprite, uUtils, uSoSound, uSoColliderObject, uE2DRendition;

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

function TGameUnit.GetLevel: Integer;
begin
  Result := FLevel;
end;

function TGameUnit.GetVisualPosition: Single;
begin
  Result := FContainer.Y + (FContainer.Height / 2) * FContainer.ScaleY + {(FContainer.Height / 2)}100 * GetLevel * FContainer.ScaleY;
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

function TGameUnit.Width: Single;
begin
  Result := FContainer.Width;
end;

{ TRoom }

constructor TRoom.Create(const AManager: TUnitManager;
  const ALevelMap: TLevelMap; const AHeightTree: THeightTree);
begin
  FLevelMap := ALevelMap;
  FHeightTree := AHeightTree;
  inherited Create(AManager);
end;

procedure TRoom.Init;
var
  vName: string;
  vZone: THeightZone;
begin
  vName := 'Room';

  with FManager.New(vName) do begin
    FContainer := ActiveContainer;
    AddRendition(vName);
    AddColliderObj(vName);
  end;

  FLevels0 := TLevels.CreateZeroLevel(
    FContainer,
    TRectF.Create(0, {384}364, 640, 1024).Move(TPointF.Create(-FContainer.Width * 0.5 * FContainer.ScaleX, -FContainer.Height * 0.5 * FContainer.ScaleY))
  );

  vZone := THeightZone.Create(TRectF.Create(0, 0, 640, 640), 0);
  FHeightTree.AddZone(vZone);

  FLevelMap.AddLevels(FLevels0);

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

constructor TRoomObject.Create(const AManager: TUnitManager; const ALevelMap: TLevelMap; const AHeightTree: THeightTree);
begin
  FLevelMap := ALevelMap;
  FParentHeightTree := AHeightTree;
  FMyHeightTree := THeightTree.Create;
  inherited Create(AManager);
end;

procedure TRoomObject.Init;
var
  vRoom: TSoObject;
begin
  inherited;
  vRoom := FManager.ByName('Room').ActiveContainer;
  with FManager.ByObject(FContainer) do
  begin
    AddProperty('Room', vRoom);
    AddProperty('LevelMap', FLevelMap);
    AddProperty('HeightTree', FParentHeightTree);
  end;
end;

end.
