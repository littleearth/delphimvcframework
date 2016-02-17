unit MVCFramework.Tests.AppController;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Classes,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Server;

type

  TAppUser = class
  strict private
    FCod: Integer;
    FName: string;
    FPass: string;
  public
    property Cod: Integer read FCod write FCod;
    property Name: string read FName write FName;
    property Pass: string read FPass write FPass;
  end;

  [MVCPath('/')]
  TAppController = class(TMVCController)
  public
    [MVCPath('/hello')]
    [MVCHTTPMethod([httpGET])]
    procedure HelloWorld(ctx: TWebContext);

    [MVCPath('/user')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUser(ctx: TWebContext);

    [MVCPath('/user/save')]
    [MVCHTTPMethod([httpPOST])]
    procedure PostUser(ctx: TWebContext);

    [MVCPath('/users')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUsers(ctx: TWebContext);

    [MVCPath('/users/save')]
    [MVCHTTPMethod([httpPOST])]
    procedure PostUsers(ctx: TWebContext);
  end;

implementation

{ TAppController }

procedure TAppController.GetUser(ctx: TWebContext);
var
  vUser: TAppUser;
begin
  vUser := TAppUser.Create;
  vUser.Cod := 1;
  vUser.Name := 'Ezequiel';
  vUser.Pass := '123';

  Render(vUser);
end;

procedure TAppController.GetUsers(ctx: TWebContext);
var
  vUsers: TObjectList<TAppUser>;
  vUser: TAppUser;
  I: Integer;
begin
  vUsers := TObjectList<TAppUser>.Create(True);

  for I := 0 to 10 do
  begin
    vUser := TAppUser.Create;
    vUser.Cod := I;
    vUser.Name := 'Ezequiel ' + IntToStr(I);
    vUser.Pass := IntToStr(I);

    vUsers.Add(vUser);
  end;

  Self.Render<TAppUser>(vUsers);
end;

procedure TAppController.HelloWorld(ctx: TWebContext);
begin
  Render('Hello World called with GET');
end;

procedure TAppController.PostUser(ctx: TWebContext);
var
  vUser: TAppUser;
begin
  vUser := ctx.Request.BodyAs<TAppUser>();

  if (vUser.Cod > 0) then
    Render('Sucess!')
  else
    Render('Error!');

  FreeAndNil(vUser);
end;

procedure TAppController.PostUsers(ctx: TWebContext);
var
  vUsers: TObjectList<TAppUser>;
begin
  vUsers := ctx.Request.BodyAsListOf<TAppUser>();
  vUsers.OwnsObjects := True;

  if (vUsers.Count > 0) then
    Render('Sucess!')
  else
    Render('Error!');

  FreeAndNil(vUsers);
end;

end.
