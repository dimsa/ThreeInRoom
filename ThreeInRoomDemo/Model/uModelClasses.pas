unit uModelClasses;

interface

uses
  System.Math,
  uSoTypes, uSoObject, uGeometryClasses;

type
  TDestination = class
  private
    FValue: TPointF;
    procedure SetValue(const Value: TPointF);
    function GetX: Single;
    function GetY: Single;
    procedure SetX(const Value: Single);
    procedure SetY(const Value: Single);
  public
    property Value: TPointF read FValue write SetValue;
    property X: Single read GetX write SetX;
    property Y: Single read GetY write SetY;
  end;

  TActivator = class
  private
    FOnActivate: TNotifyEvent;
  //  FSender: TObject;
  public
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
    procedure Activate;
    constructor Create;//(ASender: Tobject);
  end;

  TLevels = class
  private
    FLevels, FOriginalLevels: array[0..3] of TRectF;
    function GetLevel(AIndex: Integer): TRectF;
    procedure OnPositionChanged(ASender: TObject; APosition: TPosition);
  public
    property Level[AIndex: Integer]: TRectF read GetLevel; default;
    function IsPointIn(APoint: TPointF; ALevel: Integer): Boolean;
    constructor Create(const ASoObject: TSoObject; const ALevel1, ALevel2, ALevel3: TRectF);
    constructor CreateZeroLevel(const ASoObject: TSoObject; const ALevel0: TRectF);
  end;

  TLevelMap = class
  private
    FMap: TList<TLevels>;
  public
    procedure AddLevels(const ALevels: TLevels);
    function LevelInPoint(const ALevel: Integer; const APoint: TPointF): Integer;
    function CanStep(const AMyLevel: Integer): Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  THeightZone = class
  private
    FOriginRect, FRect: TRectF;
    FHeight: Single;
    FCenter: TPointF;
    FIsPositive: Boolean;
    procedure SetHeight(const Value: Single);
    procedure SetCenter(const Value: TPointF);
    procedure SetIsPositive(const Value: Boolean);
  public
    property Height: Single read FHeight write SetHeight;
    property Rect: TRectF read FRect;// write SetRect;
    property Center: TPointF read FCenter write SetCenter;
    property IsPositive: Boolean read FIsPositive write SetIsPositive;
    constructor Create(const ARect: TRectF; const AHeight: Single; const AIsPositive: Boolean = True); overload;
    constructor Create(const AX1, AY1, AX2, AY2: Single; const AHeight: Single; const AIsPositive: Boolean = True); overload;
  end;

  THeightTree = class
  private
    FNodes: TList<THeightTree>;
    FZones: TList<THeightZone>;
    FParent: THeightTree;
    procedure SetParent(const Value: THeightTree);
    property Parent: THeightTree read FParent write SetParent;
    procedure RemoveNode(const ANode: THeightTree);
  public
    function GetHeightIn(const APoint: TPointF): Single;
    function IsInTree(const APoint: TPointF): Boolean;
    procedure AddZone(const AZone: THeightZone);
    function GetZones: TList<THeightZone>;
    procedure AddNode(const ANode: THeightTree);
    constructor Create;
    destructor Destroy; override;
  end;

  TLevelController = class
  private
    FLevel: Integer;
    FHeight: Single;
    procedure SetLevel(const Value: Integer);
    procedure SetHeight(const Value: Single);
  public
    property Level: Integer read FLevel write SetLevel;
    property Height: Single read FHeight write SetHeight;
    procedure Jump(const ALevel: Integer);
  end;

implementation

{ TDestination }

function TDestination.GetX: Single;
begin
  Result := FValue.X;
end;

function TDestination.GetY: Single;
begin
  Result := FValue.Y;
end;

procedure TDestination.SetValue(const Value: TPointF);
begin
  FValue := Value;
end;

procedure TDestination.SetX(const Value: Single);
begin
  FValue.X := Value;
end;

procedure TDestination.SetY(const Value: Single);
begin
  FValue.Y := Value;
end;

{ TActivator }

procedure TActivator.Activate;
begin
  if Assigned(FOnActivate) then
    FOnActivate(Self);
end;

{constructor TActivator.Create(ASender: Tobject);
begin
  FSender := ASender;
end;  }

constructor TActivator.Create;
begin

end;

{ TLevels }

constructor TLevels.Create(const ASoObject: TSoObject; const ALevel1, ALevel2, ALevel3: TRectF);
begin
  ASoObject.AddChangePositionHandler(OnPositionChanged);

  FOriginalLevels[1] := ALevel1;
  FOriginalLevels[2] := ALevel2;
  FOriginalLevels[3] := ALevel3;

  OnPositionChanged(ASoObject, ASoObject.Position);
end;

constructor TLevels.CreateZeroLevel(const ASoObject: TSoObject; const ALevel0: TRectF);
begin
  ASoObject.AddChangePositionHandler(OnPositionChanged);
  FOriginalLevels[0] := ALevel0;
  OnPositionChanged(ASoObject, ASoObject.Position);
end;

function TLevels.GetLevel(AIndex: Integer): TRectF;
begin
  Result := FLevels[AIndex];
end;

function TLevels.IsPointIn(APoint: TPointF; ALevel: Integer): Boolean;
begin
  Result := FLevels[ALevel].Contains(APoint);
end;

procedure TLevels.OnPositionChanged(ASender: TObject; APosition: TPosition);
var
  i: Integer;
begin
  for i := 0 to 3 do
    FLevels[i] := FOriginalLevels[i].Move(APosition.XY);
end;

{ TLevelMap }

procedure TLevelMap.AddLevels(const ALevels: TLevels);
begin
  FMap.Add(ALevels);
end;

function TLevelMap.CanStep(const AMyLevel: Integer): Boolean;
begin

end;

constructor TLevelMap.Create;
begin
  FMap := TList<TLevels>.Create;
end;

destructor TLevelMap.Destroy;
begin
  FMAp.Free;
  inherited;
end;

function TLevelMap.LevelInPoint(const ALevel: Integer; const APoint: TPointF): Integer;
var
  vMin, vMax: Integer;
  i, j: Integer;
begin
  vMin := Max(0, ALevel - 1);
  vMax := Min(3, ALevel + 1);

  Result := -1;

  for j := vMin to vMax do
     for i := 0 to FMap.Count - 1 do
      if FMap[i].FLevels[j].Contains(APoint) then
        Result := j;
end;

{ TLevelController }

procedure TLevelController.Jump(const ALevel: Integer);
begin
  FLevel := ALevel;
end;

procedure TLevelController.SetHeight(const Value: Single);
begin
  FHeight := Value;
end;

procedure TLevelController.SetLevel(const Value: Integer);
begin
  FLevel := Value;
end;

{ THeightTree }

procedure THeightTree.AddNode(const ANode: THeightTree);
begin
  FNodes.Add(ANode);
  ANode.Parent := Self;
end;

procedure THeightTree.AddZone(const AZone: THeightZone);
begin
  FZones.Add(AZone);
end;

constructor THeightTree.Create;
begin
  FNodes := TList<THeightTree>.Create;
  FZones := TList<THeightZone>.Create;
end;

destructor THeightTree.Destroy;
var
  i: Integer;
begin
  for i := 0 to FNodes.Count - 1 do
    FNodes[i].Free;
  FNodes.Free;
  FZones.Free;
  inherited;
end;

function THeightTree.GetHeightIn(const APoint: TPointF): Single;
var
  i: Integer;
  vHeight: Single;
begin
  vHeight := 0;
  for i := 0 to FZones.Count - 1 do
    if FZones[i].Rect.Contains(APoint) then
    begin
      vHeight := vHeight + FZones[i].Height;
    end;

  for i := 0 to FNodes.Count - 1 do
  begin
    vHeight := vHeight + FNodes[i].GetHeightIn(APoint);
  end;

  Result := vHeight;
end;

function THeightTree.GetZones: TList<THeightZone>;
begin
  Result := FZones;
end;

function THeightTree.IsInTree(const APoint: TPointF): Boolean;
var
  i: Integer;
begin
  for i := 0 to FZones.Count - 1 do
    if FZones[i].Rect.Contains(APoint) then
      Exit(True);

  for i := 0 to FNodes.Count - 1 do
    if FNodes[i].IsInTree(APoint) then
      Exit(True);

  Result := False;
end;

procedure THeightTree.RemoveNode(const ANode: THeightTree);
begin
  FNodes.Remove(ANode);
end;

procedure THeightTree.SetParent(const Value: THeightTree);
begin
  if FParent <> nil then
    FParent.RemoveNode(Self);

  FParent := Value;
end;

{ THeightZone }

constructor THeightZone.Create(const ARect: TRectF; const AHeight: Single; const AIsPositive: Boolean);
begin
  FOriginRect := ARect;
  FHeight := AHeight;
  Center := TPointF.Create(0, 0);
end;

procedure THeightZone.SetHeight(const Value: Single);
begin
  FHeight := Value;
end;

procedure THeightZone.SetIsPositive(const Value: Boolean);
begin
  FIsPositive := Value;
end;

constructor THeightZone.Create(const AX1, AY1, AX2, AY2, AHeight: Single; const AIsPositive: Boolean);
begin
  Create(TRectF.Create(AX1, AY1, AX2, AY2), Height, AIsPositive);
end;

procedure THeightZone.SetCenter(const Value: TPointF);
begin
  FCenter := Value;

  FRect := FOriginRect.Move(Value);
end;

{procedure THeightZone.SetRect(const Value: TRectF);
begin
  FRect := Value;
end;  }

end.
