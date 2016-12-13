unit uModelItem;

interface

uses
  uSoTypes,
  uModel, uModelClasses, uLogicAssets, uSoObjectDefaultProperties, uSoObject;

type
  TModelItem = class(TRoomObject)

  end;

  TKeyItem = class(TModelItem)
  public
    procedure Init; override;
  end;

  THatItem = class(TModelItem)
  public
    procedure Init; override;
  end;

  TCoatItem = class(TModelItem)
  public
    procedure Init; override;
  end;

  TBootsItem = class(TModelItem)
  public
    procedure Init; override;
  end;

implementation

{ TKeyItem }

procedure TKeyItem.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Key';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
  end;

  RandomizePosition(FContainer);
end;

{ THatItem }

procedure THatItem.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Hat';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
  end;
end;

{ TCoatItem }

procedure TCoatItem.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Coat';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
  end;
end;

{ TBootsItem }

procedure TBootsItem.Init;
var
  vName: string;
begin
  inherited;
  vName := 'Boots';
  with FManager.ByObject(FContainer) do begin
    AddRendition(vName);
  end;
end;

end.
