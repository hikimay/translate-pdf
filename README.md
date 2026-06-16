# translate-pdf

PDF 論文を日本語に翻訳する Claude Code スキルです．[pdf2zh](https://github.com/Byaidu/PDFMathTranslate) を使ってレイアウトを保ったまま翻訳します．

## 動作環境

- `Python >= 3.11`
- Claude Code（version >= 2.1.177）

## セットアップ

### uv のインストール

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env
```

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

Claude Code 上で，例えば以下のように依頼すると翻訳が実行されます：

```markdown
sample_paper.pdf を日本語に翻訳して
```

```markdown
openai の gpt-4o-mini モデルで翻訳し，output/ フォルダに出力して
```

```markdown
claude-sonnet-4-6 モデルを使用して翻訳して
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

## 翻訳エンジンとモデル

| エンジン | `--engine` | 必要な環境変数 | モデル指定例 |
|---|---|---|---|
| Google 翻訳 | `google` | なし（不要） | — |
| Anthropic Claude | `claude` | `ANTHROPIC_API_KEY` | `claude-sonnet-4-6`, `claude-opus-4-8`, `claude-haiku-4-5` |
| OpenAI | `openai` | `OPENAI_API_KEY` | `gpt-4o`, `gpt-4o-mini` |

`--model` を省略した場合は pdf2zh のエンジンごとのデフォルトモデルが使われます。Google 翻訳はモデル指定不要です。

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

# フランス語 -> 日本語
bash translate.sh --input paper.pdf --lang-in fr --lang-out ja
```

## 出力ファイル

翻訳が完了すると `OUTPUT_DIR` に以下の 2 ファイルが生成されます：

- `<ファイル名>-mono.pdf`：翻訳後のみ
- `<ファイル名>-dual.pdf`：原文と翻訳の見開き

## ライセンス

[MIT License](LICENSE)
