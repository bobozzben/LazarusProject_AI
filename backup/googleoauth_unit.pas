unit GoogleOAuth_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, WinInet, ShellAPI, Forms, Dialogs, StrUtils;

function GoogleDeviceLogin(const ClientId, ExpectedEmail: string; out AuthEmail, DisplayName, AccessToken: string): Boolean;

implementation

function UrlEncode(const Value: string): string;
var
  Index: Integer;
begin
  Result := '';
  for Index := 1 to Length(Value) do
  begin
    if Value[Index] in ['A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.', '~'] then
      Result := Result + Value[Index]
    else if Value[Index] = ' ' then
      Result := Result + '+'
    else
      Result := Result + '%' + IntToHex(Ord(Value[Index]), 2);
  end;
end;

function JsonUnescape(const Value: string): string;
var
  Index: Integer;
  HexValue: string;
  CodePoint: Integer;
begin
  Result := '';
  Index := 1;
  while Index <= Length(Value) do
  begin
    if Value[Index] <> '\' then
    begin
      Result := Result + Value[Index];
      Inc(Index);
      Continue;
    end;

    Inc(Index);
    if Index > Length(Value) then
      Break;

    case Value[Index] of
      '"': Result := Result + '"';
      '\': Result := Result + '\';
      '/': Result := Result + '/';
      'b': Result := Result + #8;
      'f': Result := Result + #12;
      'n': Result := Result + #10;
      'r': Result := Result + #13;
      't': Result := Result + #9;
      'u':
        begin
          if Index + 4 <= Length(Value) then
          begin
            HexValue := Copy(Value, Index + 1, 4);
            CodePoint := StrToIntDef('$' + HexValue, Ord('?'));
            Result := Result + WideChar(CodePoint);
            Inc(Index, 4);
          end;
        end;
    else
      Result := Result + Value[Index];
    end;

    Inc(Index);
  end;
end;

function JsonValue(const JsonText, Key: string): string;
var
  KeyPos, ValueStart, ValueEnd: Integer;
begin
  Result := '';
  KeyPos := Pos('"' + Key + '"', JsonText);
  if KeyPos = 0 then
    Exit;

  ValueStart := PosEx(':', JsonText, KeyPos);
  if ValueStart = 0 then
    Exit;

  Inc(ValueStart);
  while (ValueStart <= Length(JsonText)) and (JsonText[ValueStart] in [' ', #9, #10, #13]) do
    Inc(ValueStart);

  if (ValueStart <= Length(JsonText)) and (JsonText[ValueStart] = '"') then
  begin
    Inc(ValueStart);
    ValueEnd := ValueStart;
    while ValueEnd <= Length(JsonText) do
    begin
      if (JsonText[ValueEnd] = '"') and ((ValueEnd = ValueStart) or (JsonText[ValueEnd - 1] <> '\')) then
        Break;
      Inc(ValueEnd);
    end;
    Result := JsonUnescape(Copy(JsonText, ValueStart, ValueEnd - ValueStart));
  end
  else
  begin
    ValueEnd := ValueStart;
    while (ValueEnd <= Length(JsonText)) and not (JsonText[ValueEnd] in [',', '}']) do
      Inc(ValueEnd);
    Result := Trim(Copy(JsonText, ValueStart, ValueEnd - ValueStart));
  end;
end;

function SplitUrl(const Url: string; out Host, Path: string; out Port: INTERNET_PORT; out Secure: Boolean): Boolean;
var
  SchemePos, PathPos: Integer;
begin
  Result := False;
  Host := '';
  Path := '/';
  Port := 443;
  Secure := True;

  SchemePos := Pos('://', Url);
  if SchemePos = 0 then
    Exit;

  Secure := LowerCase(Copy(Url, 1, SchemePos - 1)) = 'https';
  if Secure then
    Port := 443
  else
    Port := 80;

  PathPos := PosEx('/', Url, SchemePos + 3);
  if PathPos = 0 then
  begin
    Host := Copy(Url, SchemePos + 3, Length(Url));
    Path := '/';
  end
  else
  begin
    Host := Copy(Url, SchemePos + 3, PathPos - (SchemePos + 3));
    Path := Copy(Url, PathPos, Length(Url) - PathPos + 1);
  end;

  Result := Host <> '';
end;

function HttpRequest(const Method, Url, Headers, Body: string; out StatusCode: Integer; out ResponseText: string): Boolean;
var
  SessionHandle, ConnectHandle, RequestHandle: HINTERNET;
  HostName, RequestPath: string;
  Port: INTERNET_PORT;
  Secure: Boolean;
  Flags: DWORD;
  HeaderBytes: AnsiString;
  BodyBytes: AnsiString;
  ReadBuffer: array[0..4095] of AnsiChar;
  BytesRead: DWORD;
  Chunk: AnsiString;
  StatusSize: DWORD;
begin
  Result := False;
  ResponseText := '';
  StatusCode := 0;

  if not SplitUrl(Url, HostName, RequestPath, Port, Secure) then
    Exit;

  SessionHandle := InternetOpen(PChar('wbackup-google-oauth'), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if SessionHandle = nil then
    Exit;
  try
    ConnectHandle := InternetConnect(SessionHandle, PChar(HostName), Port, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
    if ConnectHandle = nil then
      Exit;
    try
      Flags := INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE or INTERNET_FLAG_KEEP_CONNECTION;
      if Secure then
        Flags := Flags or INTERNET_FLAG_SECURE;

      RequestHandle := HttpOpenRequest(ConnectHandle, PChar(Method), PChar(RequestPath), nil, nil, nil, Flags, 0);
      if RequestHandle = nil then
        Exit;
      try
        HeaderBytes := AnsiString(Headers);
        BodyBytes := AnsiString(Body);

        if BodyBytes <> '' then
        begin
          if not HttpSendRequest(RequestHandle, PChar(HeaderBytes), Length(HeaderBytes), PAnsiChar(BodyBytes), Length(BodyBytes)) then
            Exit;
        end
        else
        begin
          if not HttpSendRequest(RequestHandle, PChar(HeaderBytes), Length(HeaderBytes), nil, 0) then
            Exit;
        end;

        StatusSize := SizeOf(StatusCode);
        HttpQueryInfo(RequestHandle, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @StatusCode, StatusSize, nil);

        repeat
          FillChar(ReadBuffer, SizeOf(ReadBuffer), 0);
          BytesRead := 0;
          if not InternetReadFile(RequestHandle, @ReadBuffer[0], SizeOf(ReadBuffer) - 1, BytesRead) then
            Break;
          if BytesRead > 0 then
          begin
            SetString(Chunk, PAnsiChar(@ReadBuffer[0]), BytesRead);
            ResponseText := ResponseText + string(Chunk);
          end;
        until BytesRead = 0;

        Result := True;
      finally
        InternetCloseHandle(RequestHandle);
      end;
    finally
      InternetCloseHandle(ConnectHandle);
    end;
  finally
    InternetCloseHandle(SessionHandle);
  end;
end;

function GoogleDeviceLogin(const ClientId, ExpectedEmail: string; out AuthEmail, DisplayName, AccessToken: string): Boolean;
const
  DeviceCodeUrl = 'https://oauth2.googleapis.com/device/code';
  TokenUrl = 'https://oauth2.googleapis.com/token';
  UserInfoUrl = 'https://www.googleapis.com/oauth2/v2/userinfo';
var
  StatusCode: Integer;
  ResponseText: string;
  DeviceCode: string;
  UserCode: string;
  VerificationUrl: string;
  VerificationUrlComplete: string;
  PollInterval: Integer;
  ExpiresIn: Integer;
  Elapsed: Integer;
  WaitSeconds: Integer;
  PostBody: string;
  Headers: string;
begin
  Result := False;
  AuthEmail := '';
  DisplayName := '';
  AccessToken := '';

  if Trim(ClientId) = '' then
  begin
    ShowMessage('缺少 Google OAuth Client ID。請先在 wbackup.ini 設定 [GoogleOAuth] ClientId。');
    Exit;
  end;

  PostBody := 'client_id=' + UrlEncode(Trim(ClientId)) + '&scope=' + UrlEncode('openid email profile');
  Headers := 'Content-Type: application/x-www-form-urlencoded' + #13#10 + 'Accept: application/json' + #13#10;

  if not HttpRequest('POST', DeviceCodeUrl, Headers, PostBody, StatusCode, ResponseText) then
  begin
    ShowMessage('無法連線到 Google 驗證服務。');
    Exit;
  end;

  DeviceCode := JsonValue(ResponseText, 'device_code');
  UserCode := JsonValue(ResponseText, 'user_code');
  VerificationUrl := JsonValue(ResponseText, 'verification_url');
  if VerificationUrl = '' then
    VerificationUrl := JsonValue(ResponseText, 'verification_uri');
  VerificationUrlComplete := JsonValue(ResponseText, 'verification_url_complete');
  if VerificationUrlComplete = '' then
    VerificationUrlComplete := JsonValue(ResponseText, 'verification_uri_complete');
  PollInterval := StrToIntDef(JsonValue(ResponseText, 'interval'), 5);
  ExpiresIn := StrToIntDef(JsonValue(ResponseText, 'expires_in'), 600);

  if (DeviceCode = '') or (UserCode = '') or ((VerificationUrl = '') and (VerificationUrlComplete = '')) then
  begin
    ShowMessage('Google 驗證流程初始化失敗。請確認 Client ID 與 Google OAuth 設定。');
    Exit;
  end;

  if VerificationUrlComplete <> '' then
    ShellExecute(0, 'open', PChar(VerificationUrlComplete), nil, nil, SW_SHOWNORMAL)
  else
    ShellExecute(0, 'open', PChar(VerificationUrl), nil, nil, SW_SHOWNORMAL);

  ShowMessage('請在瀏覽器完成 Google 登入，並輸入顯示的驗證碼：' + LineEnding + UserCode);

  Headers := 'Content-Type: application/x-www-form-urlencoded' + #13#10 + 'Accept: application/json' + #13#10;
  Elapsed := 0;
  while Elapsed < ExpiresIn do
  begin
    PostBody := 'client_id=' + UrlEncode(Trim(ClientId)) +
      '&device_code=' + UrlEncode(DeviceCode) +
      '&grant_type=' + UrlEncode('urn:ietf:params:oauth:grant-type:device_code');

    if not HttpRequest('POST', TokenUrl, Headers, PostBody, StatusCode, ResponseText) then
    begin
      ShowMessage('Google 驗證過程發生網路錯誤。');
      Exit;
    end;

    if (StatusCode >= 200) and (StatusCode < 300) then
    begin
      AccessToken := JsonValue(ResponseText, 'access_token');
      if AccessToken = '' then
      begin
        ShowMessage('Google 回傳了無效的存取權杖。');
        Exit;
      end;
      Break;
    end;

    if Pos('authorization_pending', ResponseText) > 0 then
      WaitSeconds := PollInterval
    else if Pos('slow_down', ResponseText) > 0 then
    begin
      Inc(PollInterval);
      WaitSeconds := PollInterval;
    end
    else if Pos('access_denied', ResponseText) > 0 then
    begin
      ShowMessage('Google 登入已被拒絕。');
      Exit;
    end
    else if Pos('expired_token', ResponseText) > 0 then
    begin
      ShowMessage('Google 登入驗證逾時，請重新執行。');
      Exit;
    end
    else
    begin
      ShowMessage('Google 驗證失敗：' + ResponseText);
      Exit;
    end;

    Inc(Elapsed, WaitSeconds);
    Sleep(WaitSeconds * 1000);
    Application.ProcessMessages;
  end;

  if AccessToken = '' then
  begin
    ShowMessage('Google 登入驗證逾時，請重新執行。');
    Exit;
  end;

  Headers := 'Authorization: Bearer ' + AccessToken + #13#10 + 'Accept: application/json' + #13#10;
  if not HttpRequest('GET', UserInfoUrl, Headers, '', StatusCode, ResponseText) then
  begin
    ShowMessage('無法取得 Google 帳號資訊。');
    Exit;
  end;

  if (StatusCode < 200) or (StatusCode >= 300) then
  begin
    ShowMessage('取得 Google 帳號資訊失敗：' + ResponseText);
    Exit;
  end;

  AuthEmail := LowerCase(Trim(JsonValue(ResponseText, 'email')));
  DisplayName := Trim(JsonValue(ResponseText, 'name'));

  if (Trim(ExpectedEmail) <> '') and (LowerCase(Trim(ExpectedEmail)) <> AuthEmail) then
  begin
    ShowMessage('登入的 Google 帳號與輸入的 Email 不一致。');
    Exit;
  end;

  Result := AuthEmail <> '';
end;

end.