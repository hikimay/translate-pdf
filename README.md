# translate-pdf

PDF 論文を日本語に翻訳する Claude Code スキルです。[pdf2zh](https://github.com/Byaidu/PDFMathTranslate) を使ってレイアウトを保ったまま翻訳します。

## セットアップ

### pdf2zh のインストール

```bash
uv tool install --python 3.12 pdf2zh
```

### スキルのインストール

```bash
git clone https://github.com/hikimay/translate-pdf.git ~/.claude/skills/translate-pdf
```

### APIキーの設定（Claude / OpenAI エンジンを使う場合）

```bash
export ANTHROPIC_API_KEY='sk-ant-...'
export OPENAI_API_KEY='sk-...'
```

## 使い方

### Claude Code スキルとして使う

Claude Code 上で以下のように依頼するだけで翻訳が実行されます：

```
論文.pdf を日本語に翻訳して
output/ フォルダに claude で翻訳して
claude-sonnet-4-6 モデルを指定して翻訳して
```

### スクリプトを直接実行する

```bash
bash translate.sh \
  --input <INPUT> \
  [--output <OUTPUT_DIR>] \
  [--engine <ENGINE>] \
  [--model <MODEL>] \
  [--lang-in <LANG_IN>] \
  [--lang-out <LANG_OUT>]
```

## オプション

| オプション | デフォルト | 説明 |
|---|---|---|
| `--input` | （必須） | 翻訳対象の PDF ファイルパス |
| `--output` | INPUT と同じディレクトリ | 出力先ディレクトリ |
| `--engine` | `google` | 翻訳エンジン（`google` / `claude` / `openai`） |
| `--model` | エンジンのデフォルト | 使用するモデル名（例：`claude-sonnet-4-6`、`gpt-4o`） |
| `--lang-in` | `en` | 入力言語 |
| `--lang-out` | `ja` | 出力言語 |

## 実行例

```bash
# Google 翻訳（APIキー不要）
bash translate.sh --input paper.pdf

# Claude で翻訳（モデル指定あり）
bash translate.sh --input paper.pdf --engine claude --model claude-sonnet-4-6

# 出力先を指定して OpenAI で翻訳
bash translate.sh --input paper.pdf --output ./output --engine openai --model gpt-4o

# フランス語→日本語
bash translate.sh --input paper.pdf --lang-in fr --lang-out ja
```

## 出力ファイル

翻訳が完了すると OUTPUT_DIR に以下の2ファイルが生成されます：

- `<ファイル名>-mono.pdf`：翻訳後のみ
- `<ファイル名>-dual.pdf`：原文と翻訳の見開き（推奨）
