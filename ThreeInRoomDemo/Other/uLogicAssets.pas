unit uLogicAssets;

interface

uses
  uSoObject, uSoTypes, uGeometryClasses, System.Math, uIntersectorMethods, uSoObjectDefaultProperties,
  uSoColliderObjectTypes, uAcceleration, uModelClasses, uUtils;

type
  TFireKoef = record
    Left, Right: Single;
  end;

  TLogicAssets = class
  private
    class procedure LevelSolving(const ALevelMap: TLevelMap; const ALevelController: TLevelController; const ASubject: TSoObject; const DX: Single = 0; DY: Single = 0);
    class procedure CarryItem(ASoObject: TSoObject);
  public
    class procedure OnTestMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    class procedure OnGnomeLongPress(Sender: TObject);
    class procedure MovingToDestination(ASoObject: TSoObject);
    class procedure FollowTheShip(ASoObject: TSoObject);
    class procedure OnCollide(ASender: TObject; AEvent: TObjectCollidedEventArgs);
  end;

implementation

uses
  uModel, uSoSprite, uSoSound, uSoColliderObject, uSoMouseHandler, uModelItem;

class procedure TLogicAssets.LevelSolving(const ALevelMap: TLevelMap; const ALevelController: TLevelController; const ASubject: TSoObject; const DX: Single = 0; DY: Single = 0);
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

class procedure TLogicAssets.CarryItem(ASoObject: TSoObject);
var
  vItem: TModelItem;
begin
  vItem := ASoObject['CarryingItem'].Val<TModelItem>;
  vItem.SetPosition(ASoObject.Center);
end;

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

class procedure TLogicAssets.MovingToDestination(ASoObject: TSoObject);
var
  vDest: TDestination;
  vDx, vDy: Single;
  vIsHere: Boolean;
  vRend: TSoSprite;
  vLevelMap: TLevelMap;
  vLevelController: TLevelController;
  vNewLevel: Integer;
begin
  vDx := 2;
  vDy := 2;
  with ASoObject do begin
    vDest := ASoObject['Destination'].Val<TDestination>;
    vLevelMap := ASoObject['LevelMap'].Val<TLevelMap>;
    vLevelController := ASoObject['LevelController'].Val<TLevelController>;

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
     vDy := -Abs(vDy);

  vNewLevel := vLevelMap.LevelInPoint(vLevelController.Level, TPointF.Create(X + vDx, Y + vDy));
  LevelSolving(vLevelMap, vLevelController, ASoObject, vDx, vDy);

  if (vNewLevel > vLevelController.Level + 1) or (vNewLevel <  vLevelController.Level - 1) or (vNewLevel = -1) then
    Exit;

   X := X + vDx;
   Y := Y + vDy;

   vRend := ASoObject[Rendition].Val<TSoSprite>;
   vRend.NextFrame;

  end;
end;

class procedure TLogicAssets.OnCollide(ASender: TObject;
  AEvent: TObjectCollidedEventArgs);
begin

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
