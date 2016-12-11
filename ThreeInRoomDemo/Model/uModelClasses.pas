unit uModelClasses;

interface

uses
  uSoTypes;

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

end.
