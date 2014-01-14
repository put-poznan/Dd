unit Image1;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls;

type
  TImage1 = class(TImage)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(AOwner : TComponent); override;
    procedure SetDefaultImage;
  published
    { Published declarations }
  end;

procedure Register;

implementation


constructor TImage1.Create(AOwner : TComponent);
begin
     inherited Create(AOwner);
     Picture.Bitmap.LoadFromResourceName(HInstance ,'DEFAULT_IMAGE');
end;

procedure TImage1.SetDefaultImage;
begin
     Picture.Bitmap.LoadFromResourceName(HInstance ,'DEFAULT_IMAGE');
end;

procedure Register;
begin
  RegisterComponents('Samples', [TImage1]);
end;

end.







