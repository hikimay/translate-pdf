# translate-pdf

論文PDFを日本語に翻訳するスキルです。pdf2zh を使ってレイアウトを保ったまま翻訳します。

## 使い方

ユーザーが PDF の翻訳を依頼したとき，以下の手順で実行してください。

### 1. 引数の確認

ユーザーの指示から以下を読み取ります：

- `INPUT`：翻訳対象の PDF ファイルパス（必須）
- `OUTPUT_DIR`：出力先ディレクトリ（省略時は INPUT と同じディレクトリ）
- `ENGINE`：翻訳エンジン（省略時は `google`）
  - `google`：APIキー不要
  - `claude`：環境変数 `ANTHROPIC_API_KEY` が必要
  - `openai`：環境変数 `OPENAI_API_KEY` が必要
- `LANG_IN`：入力言語（省略時は `en`）
- `LANG_OUT`：出力言語（省略時は `ja`）

### 2. スクリプトの実行

```bash
bash ~/.claude/skills/translate-pdf/translate.sh \
  --input <INPUT> \
  --output <OUTPUT_DIR> \
  --engine <ENGINE> \
  --lang-in <LANG_IN> \
  --lang-out <LANG_OUT>
```

### 3. 出力の確認

正常終了した場合，以下の2ファイルが OUTPUT_DIR に生成されます：

- `<ファイル名>-mono.pdf`：翻訳後のみ
- `<ファイル名>-dual.pdf`：原文と翻訳の見開き（推奨）

ユーザーに出力ファイルのパスを伝えてください。

### 4. エラー処理

- `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` が未設定の場合，ユーザーに設定方法を案内する
- PDF が存在しない場合，パスを確認するよう伝える
- それ以外のエラーはスクリプトの stderr をそのまま報告する

## 使用例

```
論文.pdf を日本語に翻訳して
→ bash translate.sh --input 論文.pdf

output/ フォルダに claude で翻訳して
→ bash translate.sh --input 論文.pdf --output output/ --engine claude

英語以外の論文（フランス語→日本語）
→ bash translate.sh --input 論文.pdf --lang-in fr --lang-out ja
```
