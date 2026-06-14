#!/usr/bin/env bash
# translate.sh — pdf2zh ラッパー
set -euo pipefail

PDF2ZH=/home/$USER/.local/bin/pdf2zh

# ── デフォルト値 ──────────────────────────────
INPUT=""
OUTPUT_DIR=""
ENGINE="google"
LANG_IN="en"
LANG_OUT="ja"

# ── 引数パース ────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    --input)    INPUT="$2";      shift 2 ;;
    --output)   OUTPUT_DIR="$2"; shift 2 ;;
    --engine)   ENGINE="$2";     shift 2 ;;
    --lang-in)  LANG_IN="$2";   shift 2 ;;
    --lang-out) LANG_OUT="$2";  shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# ── バリデーション ────────────────────────────
if [[ -z "$INPUT" ]]; then
  echo "Error: --input が指定されていません" >&2
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Error: ファイルが見つかりません: $INPUT" >&2
  exit 1
fi

if [[ ! -x "$PDF2ZH" ]]; then
  echo "Error: pdf2zh が見つかりません: $PDF2ZH" >&2
  echo "  uv tool install --python 3.12 pdf2zh でインストールしてください" >&2
  exit 1
fi

# ── APIキー確認 ───────────────────────────────
if [[ "$ENGINE" == "claude" ]] && [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
  echo "Error: ANTHROPIC_API_KEY が設定されていません" >&2
  echo "  export ANTHROPIC_API_KEY='sk-ant-...' を実行してください" >&2
  exit 1
fi

if [[ "$ENGINE" == "openai" ]] && [[ -z "${OPENAI_API_KEY:-}" ]]; then
  echo "Error: OPENAI_API_KEY が設定されていません" >&2
  echo "  export OPENAI_API_KEY='sk-...' を実行してください" >&2
  exit 1
fi

# ── 出力先ディレクトリ ────────────────────────
if [[ -z "$OUTPUT_DIR" ]]; then
  OUTPUT_DIR="$(dirname "$INPUT")"
fi
mkdir -p "$OUTPUT_DIR"

# ── 実行 ──────────────────────────────────────
echo "翻訳を開始します..."
echo "  入力: $INPUT"
echo "  出力: $OUTPUT_DIR"
echo "  エンジン: $ENGINE"
echo "  言語: $LANG_IN → $LANG_OUT"
echo ""

CMD="$PDF2ZH \"$INPUT\" --lang-in $LANG_IN --lang-out $LANG_OUT -o \"$OUTPUT_DIR\""
if [[ "$ENGINE" != "google" ]]; then
  CMD="$CMD -s $ENGINE"
fi

eval "$CMD"

# ── 完了メッセージ ────────────────────────────
BASENAME="$(basename "$INPUT" .pdf)"
echo ""
echo "完了しました:"
echo "  翻訳のみ: $OUTPUT_DIR/${BASENAME}-mono.pdf"
echo "  見開き:   $OUTPUT_DIR/${BASENAME}-dual.pdf"
