unit uLogicAssets;

interface

uses
  uSoObject, uSoTypes, uGeometryClasses, System.Math, uIntersectorMethods, uSoObjectDefaultProperties,
  uSoColliderObjectTypes, uAcceleration, uModelClasses;

type
  TFireKoef = record
    Left, Right: Single;
  end;

  TLogicAssets = class
  private
    class function MakeTurnToDestination(const AShip: TSoObject; const ADir, ATurnRate: Single): TFireKoef;
    class procedure MovingThroughSidesInner(ASoObject, AWorld: TSoObject);
  public
    class procedure OnTestMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    class procedure OnGnomeLongPress(Sender: TObject);
    class procedure MovingThroughSides(ASoObject: TSoObject);
    class procedure MovingByAcceleration(ASoObject: TSoObject);
    class procedure MovingToDestination(ASoObject: TSoObject);
    class procedure FollowTheShip(ASoObject: TSoObject);
    class procedure OnCollideAsteroid(ASender: TObject; AEvent: TObjectCollidedEventArgs);
    class procedure OnCollideShip(ASender: TObject; AEvent: TObjectCollidedEventArgs);
  end;

implementation

uses
  uModel, uSoSprite, uSoSound, uSoColliderObject, uSoMouseHandler;

function MySign(const AValue: Single): Integer;
begin
  if AValue > 0 then
    Exit(1);
  if AValue < 0 then
    Exit(-1);

  Result := 0;
end;

procedure LevelSolving(const ALevelMap: TLevelMap; const ALevelController: TLevelController; const ASubject: TSoObject; const DX: Single = 0; DY: Single = 0);
var
  vNewLevel: Integer;
begin
  with ASubject do begin
    vNewLevel := ALevelMap.LevelInPoint(ALevelController.Level, TPointF.Create(X + Dx, Y + Dy));

    if vNewLevel = ALevelController.Level + 1 then
    begin
      ALevelController.Jump(ALevelController.Level + 1);
      ScaleY := Abs(ScaleY) + 0.1;
      ScaleX := MySign(ScaleX) * (Abs(ScaleX) + 0.1);
    end;

    if (vNewLevel = ALevelController.Level - 1) and (ALevelController.Level - 1 > -1) then
    begin
      ALevelController.Jump(ALevelController.Level - 1);
      ScaleY := Abs(ScaleY) - 0.1;
      ScaleX := MySign(ScaleX) * (Abs(ScaleX) - 0.1);
    end;
  end;
end;

{ TLogicAssets }

class procedure TLogicAssets.FollowTheShip(ASoObject: TSoObject);
var
  vShip: TSoObject;
begin
  vShip := ASoObject['Ship'].Val<TSoObject>;
  ASoObject.Center := vShip.Position.XY;
  ASoObject.Rotate := vShip.Position.Rotate;

  ASoObject[Rendition].Val<TSoSprite>.NextFrame;
  ASoObject[Rendition].Val<TSoSprite>.Opacity := 0.6 + Random(40) / 100;
end;

class function TLogicAssets.MakeTurnToDestination(const AShip: TSoObject;
  const ADir, ATurnRate: Single): TFireKoef;
var
  vTurnRate: Single;
begin
    vTurnRate := Min(Abs(ADir), ATurnRate);
    if (ADir < 0)  then
    begin
      AShip.Rotate := NormalizeAngle(AShip.Rotate - vTurnRate);
      Result.Left := 1;
      Result.Right := 0.4;
    end
    else begin
      AShip.Rotate := NormalizeAngle(AShip.Rotate + vTurnRate);
      Result.Left := 0.4;
      Result.Right := 1;
    end;

    if ((Abs(ADir) > 165) and (Abs(ADir) < 180)) or ((Abs(ADir) > 0) and (Abs(ADir) < 15)) then
    begin
      Result.Left := 1;
      Result.Right := 1;
    end;
end;

class procedure TLogicAssets.MovingByAcceleration(ASoObject: TSoObject);
var
  vAcceleration: TAcceleration;
begin
  with ASoObject do begin
    vAcceleration := ASoObject['Acceleration'].Val<TAcceleration>;
    X := X + vAcceleration.Dx;
    Y := Y + vAcceleration.Dy;
    Rotate := Rotate + vAcceleration.Da;
  end;
  MovingThroughSidesInner(ASoObject, ASoObject['World'].Val<TSoObject>);
end;

class procedure TLogicAssets.MovingThroughSidesInner(ASoObject, AWorld: TSoObject);
begin
  with ASoObject do begin
   if X < - Width then
     X := AWorld.Width + Width;

   if Y  < - Height then
     Y := AWorld.Height + Height;

   if X > AWorld.Width + Width  then
     X := - Width;

   if Y > AWorld.Height + Height then
     Y := - Height;
  end;
end;

class procedure TLogicAssets.MovingThroughSides(ASoObject: TSoObject);
begin
exit;
  ASoObject.X := ASoObject.X + Random * 3;
  ASoObject.Y := ASoObject.Y + Random * 3;
  ASoObject.Rotate := ASoObject.Rotate + Random * 2;
  MovingThroughSidesInner(ASoObject, ASoObject['World'].Val<TSoObject>);
end;

class procedure TLogicAssets.MovingToDestination(ASoObject: TSoObject);
var
  vDest: TDestination;
  vDx, vDy: Single;
  vIsHere: Boolean;
  vRend: TSoSprite;
  vLevelMap: TLevelMap;
  vHeightTree: THeightTree;
  vLevelController: TLevelController;
  vNewLevel: Integer;
  vP: TPointF;
begin
  vDx := 2;
  vDy := 2;
  with ASoObject do begin
    vDest := ASoObject['Destination'].Val<TDestination>;
    vLevelMap := ASoObject['LevelMap'].Val<TLevelMap>;
    vLevelController := ASoObject['LevelController'].Val<TLevelController>;
    vHeightTree := ASoObject['HeightTree'].Val<THeightTree>;

    vIsHere := True;
    if (X <= vDest.X + vDx) and (X >= vDest.X - vDx) then
    begin
      X := vDest.X;
    end else
      vIsHere := False;

    if (Y <= vDest.Y + vDy) and (Y >= vDest.Y - vDy) then
    begin
      Y := vDest.Y
    end else
      vIsHere := False;

    if vIsHere then
    begin
      // Обработка падений
      LevelSolving(vLevelMap, vLevelController, ASoObject);
      Exit;
    end;

   if (X > vDest.X) then
   begin
     vDx := -Abs(vDx);
     ScaleX := -Abs(ScaleX);
   end else
    ScaleX := Abs(ScaleX);

   if (Y > vDest.Y) then
   begin
     vDy := -Abs(vDy);
   end;

   vP := TPointF.Create(X / Abs(ScaleX) + vDx, (Y) / Abs(ScaleY) - 384 + 32 + vDy);

  if vHeightTree.IsInTree(vP) then
  begin
    if Abs(vLevelController.Height - vHeightTree.GetHeightIn(vP)) < 32 then
      vLevelController.Height := vHeightTree.GetHeightIn(vP);
  end else
    Exit; // Выходим, если не попадаем в зону


  vNewLevel := vLevelMap.LevelInPoint(vLevelController.Level, vP);

  LevelSolving(vLevelMap, vLevelController, ASoObject, vDx, vDy);

 { if (vNewLevel > vLevelController.Level + 1) or (vNewLevel <  vLevelController.Level - 1) or (vNewLevel = -1) then
    Exit; }

   X := X + vDx;
   Y := Y + vDy;

   vRend := ASoObject[Rendition].Val<TSoSprite>;
   vRend.NextFrame;

  end;
end;

class procedure TLogicAssets.OnCollideAsteroid(ASender: TObject; AEvent: TObjectCollidedEventArgs);
begin
//  TSoColliderObj(ASender).Subject[Sound].Val<TSoSound>.Play;
end;

class procedure TLogicAssets.OnCollideShip(ASender: TObject; AEvent: TObjectCollidedEventArgs);
begin
 // TSoColliderObj(ASender).Subject[Sound].Val<TSoSound>.Play;
end;

class procedure TLogicAssets.OnGnomeLongPress(Sender: TObject);
var
  vObj: TSoObject;
begin
  vObj := TSoMouseHandler(Sender).Subject;
  vObj['Activator'].Val<TActivator>.Activate;
end;

class procedure TLogicAssets.OnTestMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  vObj: TSoObject;
begin
  vObj := TSoMouseHandler(Sender).Subject;
 // vObj['Activator'].Val<TActivator>.Activate;
end;

end.
