program ThreeInRoomGame;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {ThreeInRoom},
  uModel in 'Model\uModel.pas',
  uGame in 'Model\uGame.pas',
  uMapPainter in 'Other\uMapPainter.pas',
  uUnitCreator in 'Other\uUnitCreator.pas',
  uUtils in 'Common\uUtils.pas',
  uLogicAssets in 'Other\uLogicAssets.pas',
  uAcceleration in 'Other\uAcceleration.pas',
  uModelClasses in 'Model\uModelClasses.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TThreeInRoom, ThreeInRoom);
  Application.Run;
end.
