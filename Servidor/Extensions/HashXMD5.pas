unit HashXMD5;

interface

uses
  IdHashMessageDigest,
  Classes,
  SysUtils;

const
    SALT = 'j5*k.9S8W6*(/OG5#1O1Dfp5z9/3U5dls5y9s6hU49Z95FQyn7ab9r5j6k3';

function MD2(const Value: string): string;
function MD4(const Value: string): string;
function MD5(const Value: string): string;
function SaltPassword(pass: string): string;

implementation

{$REGION ' MD2 '}
function MD2(const Value: string): string;
var
    xMD2: TIdHashMessageDigest2;
begin
    xMD2 := TIdHashMessageDigest2.Create;
    Result := Value;

    try
        Result := xMD2.HashStringAsHex(Result);
    finally
        xMD2.Free;
    end;
end;
{$ENDREGION}

{$REGION ' MD4 '}
function MD4(const Value: string): string;
var
    xMD4: TIdHashMessageDigest4;
begin
    xMD4 := TIdHashMessageDigest4.Create;
    Result := Value;

    try
        Result := xMD4.HashStringAsHex(Result);
    finally
        xMD4.Free;
    end;
end;
{$ENDREGION}

{$REGION ' MD5 '}
function MD5(const Value: string): string;
var
    xMD5: TIdHashMessageDigest5;
begin
    xMD5 := TIdHashMessageDigest5.Create;
    Result := Value;

    try
        Result := xMD5.HashStringAsHex(Result);
    finally
        xMD5.Free;
    end;
end;
{$ENDREGION}

{$REGION ' SaltPassword '}
function SaltPassword(pass: string): string;
var
    xMD5: TIdHashMessageDigest5;
    randomStr: string;
    x : integer;
begin
    xMD5 := TIdHashMessageDigest5.Create;
    Result := '';

    try
        for x := 1 to Length(pass) do
            Result := Result + Copy(SALT, x, 1) + Copy(pass, x, 1);

        Result := LowerCase(xMD5.HashStringAsHex(Result));  // 1x
        Result := LowerCase(xMD5.HashStringAsHex(Result));  // 2x
    finally
        xMD5.Free;
    end;
end;
{$ENDREGION}

end.
