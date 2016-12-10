unit uStaticMethodWrapper;

interface

uses
  uCommonClasses;

type
  IStaticEventWrapper<T> = interface
    procedure Execute(ASender: TObject; AEventArgs: T);
  end;

  TStaticEventWrapper<T> = class(TInterfacedObject, IStaticEventWrapper<T>)
  private
    FStaticEvent: TStaticEvent<T>;
  public
    procedure Execute(ASender: TObject; AEventArgs: T);
    constructor Create(AEvent: TStaticEvent<T>);
  end;

implementation

{ TStaticEventWrapper<T> }

constructor TStaticEventWrapper<T>.Create(AEvent: TStaticEvent<T>);
begin
  FStaticEvent := AEvent;
end;

procedure TStaticEventWrapper<T>.Execute(ASender: TObject; AEventArgs: T);
begin
  FStaticEvent(ASender, AEventArgs);
end;

end.
