unit uModelHero;

interface

uses
  uSoTypes,
  uModel, uModelClasses, uLogicAssets, uSoObjectDefaultProperties;

type
  THeroIcon = class(TGameUnit)
  protected
    FName: string;
  public
    procedure Init; override;
  end;

  TTyHero = class(THeroIcon)
  public
    procedure Init; override;
  end;

  TRiHero = class(THeroIcon)
  public
    procedure Init; override;
  end;

  TOnHero = class(THeroIcon)
  public
    procedure Init; override;
  end;

  TArkadiyHero = class(THeroIcon)
  public
    procedure Init; override;
  end;

implementation

{ THeroIcon }

procedure THeroIcon.Init;
begin
  inherited;

   with FManager.ByObject(FContainer) do begin
      AddRendition(FName);
      AddColliderObj(FName);
   end;
end;

{ TTyHero }

procedure TTyHero.Init;
begin
  FName := 'TyHero';
  inherited;
end;

{ TRiHero }

procedure TRiHero.Init;
begin
  FName := 'RiHero';
  inherited;
end;

{ TOnHero }

procedure TOnHero.Init;
begin
  FName := 'OnHero';
  inherited;
end;

{ TArkadiyHero }

procedure TArkadiyHero.Init;
begin
  FName := 'ArkadiyHero';
  inherited;
end;

end.
