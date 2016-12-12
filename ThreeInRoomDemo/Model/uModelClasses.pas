unit uModelClasses;

interface

uses
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
    FLevels[i] := FOriginalLevels[i].Multiply(APosition.Scale).Move(APosition.XY);
end;

end.
