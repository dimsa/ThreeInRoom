unit uUtils;

interface

uses
  uEasyDevice;

function ResourcePath(const AFileName: string): string;
function MySign(const AValue: Single): Integer;

implementation

function ResourcePath(const AFileName: string): string;
begin
  Result := UniPath('/' + AFileName);
end;

function MySign(const AValue: Single): Integer;
begin
  if AValue > 0 then
    Exit(1);
  if AValue < 0 then
    Exit(-1);

  Result := 0;
end;

end.
