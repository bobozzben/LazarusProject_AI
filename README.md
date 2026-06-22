# Lazarus 轉換專案

這個目錄包含一個 Lazarus 版本的專案，已經把原始 C++Builder 專案的主要表單和邏輯轉換成 Lazarus Object Pascal。

## 已轉換的模組

- ✅ `project1.lpr` - 專案入口
- ✅ `unit1.pas` / `unit1.lfm` - 主表單
- ✅ `floginunit.pas` / `floginunit.lfm` - Google OAuth 登入表單
- ✅ `mainback_uint.pas` / `mainback_uint.lfm` - 主備份操作
- ✅ `choiceunit.pas` / `choiceunit.lfm` - 客戶選擇與備份執行
- ✅ `advunit.pas` / `advunit.lfm` - 進階選項 (檔案瀏覽)
- ✅ `stateunit.pas` / `stateunit.lfm` - 狀態與進度顯示
- ✅ `s3000unit.pas` / `s3000unit.lfm` - S3000 操作介面
- ⏳ `stubs.pas` - S5000、刪除對話等占位表單

## 功能摘要

| 模組 | 功能 |
|------|------|
| 登入 | Google OAuth 2.0 驗證、登入帳號比對 |
| 備份 | 備份/還原選擇、VBS 腳本執行、客戶選擇 |
| 進階 | 備份檔案瀏覽、磁碟選擇、檔案篩選 |
| S3000 | 機構操作介面 |
| 狀態 | 進度顯示、燒錄控制 |

## 編譯與執行

1. 在 Lazarus IDE 中開啟 `project1.lpr`
2. 點選 `Run > Build All` 或 `Run > Compile` 進行編譯
3. 如編譯成功，執行 `Run > Run` 啟動應用

## Google 登入設定

這個版本的登入流程改成 Google OAuth 2.0 device flow。請先在 Google Cloud Console 建立一個 OAuth 2.0 public client，然後把 Client ID 寫入 `wbackup.ini`：

```ini
[GoogleOAuth]
ClientId=你的ClientID
LastEmail=使用者常用的Google Email
```

登入時會要求輸入 Google 帳號 Email，並在瀏覽器完成授權後才會進入主程式。

## 已知限制

- **Nero SDK**: 燒錄功能尚未整合，需要手動補充 Nero API 的 Pascal 介面
- **資料庫**: 原始程式使用 BDE/TTable，已改為 TFPDbf，須調整資料檔路徑
- **VBS 腳本**: 備份邏輯仍依賴原始的 VBS 腳本 (`s1.vbs`, `s2.vbs`)
- **Google OAuth**: 需要自行建立 OAuth Client ID，並將其寫入 `wbackup.ini`
- **S5000、刪除表單**: 尚為占位 stub，可按需補實作

## 對應原始表單

| 原始 (.h/.cpp) | Lazarus (pas) | 狀態 |
|---|---|---|
| Unit1.h | unit1.pas | ✅ |
| fLoginUnit.h | floginunit.pas | ✅ |
| mainback_uint.h | mainback_uint.pas | ✅ |
| choiceunit.h | choiceunit.pas | ✅ |
| advunit.h | advunit.pas | ✅ |
| stateunit.h | stateunit.pas | ✅ |
| s3000Unit.h | s3000unit.pas | ✅ |
| S5000.h | S5000.pas | ⏳ stub |
| frDelete.h | frDelete.pas | ⏳ stub |

## 下一步改進

1. **補充 S5000 表單** - 建立完整的 S5000 操作介面
2. **補充刪除對話** - 建立 `frDelete` 確認對話
3. **整合 Nero API** - 補充燒錄功能的 Pascal 外部宣告
4. **調整資料路徑** - 根據實際環境修改 DBF 檔案路徑
5. **增強 UI** - 改進表單佈局與視覺效果

## 編譯提示

如遇到編譯錯誤，請檢查：
- Lazarus 單元搜尋路徑是否包含 LCL 核心庫
- FCL-DB 或 dbf 套件是否正確安裝
- 所有依賴的標準單元 (Forms, StdCtrls, Dialogs 等) 是否可用

