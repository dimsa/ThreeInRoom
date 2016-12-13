unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  System.Math.Vectors,
  uSoEngine, uGame, uSoEngineOptions;

type
  TThreeInRoom = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  published
    MainImg: TImage;
    procedure FormCreate(Sender: TObject);
  private
    FEngine: TSoEngine;
    FGame: TGame;
    procedure OnEndPaintDefault(ASender: TObject; AImage: TImage);
    { Private declarations }
  public
    FOptions: TSoEngineOptions;
    { Public declarations }
  end;

var
  ThreeInRoom: TThreeInRoom;

implementation

{$R *.fmx}

procedure TThreeInRoom.FormCreate(Sender: TObject);
begin
  FOptions := TSoEngineOptions.Create;
  FOptions.ColliderOptions.IsActive := False;
  FEngine := TSoEngine.Create(MainImg, FOptions);
  FEngine.Manager.WorldManager.OnEndPaint := OnEndPaintDefault;

  FGame := TGame.Create(FEngine.Manager, FOptions);
  FEngine.Start;
end;

procedure TThreeInRoom.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  FOptions.ColliderOptions.IsActive := True;
end;

procedure TThreeInRoom.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  FOptions.ColliderOptions.IsActive := False;
end;

procedure TThreeInRoom.OnEndPaintDefault(ASender: TObject;
  AImage: TImage);
begin
{$IFDEF RELEASE}
  Exit;
{$ENDIF}
  with AImage do
  begin
    //Bitmap.Canvas.Blending:=true;
    Bitmap.Canvas.SetMatrix(tMatrix.Identity);
    Bitmap.Canvas.Fill.Color := TAlphaColorRec.Brown;
    Bitmap.Canvas.Font.Size := 12;
    Bitmap.Canvas.Font.Style := [TFontStyle.fsBold];
    Bitmap.Canvas.Font.Family := 'arial';
{$IFDEF CONDITIONALEXPRESSIONS}
{$IF CompilerVersion >= 19.0}
    Bitmap.Canvas.FillText(RectF(15, 15, 165, 125),
      'FPS=' + floattostr(FEngine.Fps), false, 1, [], TTextAlign.Leading);
{$ENDIF}{$ENDIF}
{$IFDEF VER260}
    Bitmap.Canvas.FillText(RectF(15, 15, 165, 125),
      'FPS=' + floattostr(FEngine.Fps), false, 1, [], TTextAlign.taLeading);
{$ENDIF}
  end;
end;

end.
