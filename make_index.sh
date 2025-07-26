#!/bin/bash

# UTF-8環境設定（日本語ディレクトリ名対応）
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# 出力先を決める（例: markdown_output.md）
OUTPUT_FILE="tree_output.md"

# ベースURL（GitHubリポジトリのURL。適宜変更）
# BASE_URL="https://github.com/TetsuakiBaba/syllabus/blob/main"
# BASE_URL="tetsuakibaba.github.io/syllabus"
BASE_URL="./?file=."

# 現在の年度を取得
CURRENT_YEAR=$(date +%Y)
NEXT_YEAR=$((CURRENT_YEAR + 1))

# 出力ファイルを初期化
echo "" > "$OUTPUT_FILE"

# 年度順にファイルを表示する関数
output_files_by_year() {
    local year=$1
    local pattern="*/${year}.md"
    find . -path "$pattern" -type f | LC_ALL=C sort | while IFS= read -r file; do
        RELATIVE_PATH="${file#./}" # "./"を取り除く
        # URLエンコードが必要な場合はここで処理
        ENCODED_PATH=$(printf '%s\n' "$RELATIVE_PATH" | sed 's/ /%20/g')
        echo "- [${RELATIVE_PATH}](${BASE_URL}/${ENCODED_PATH})" >> "$OUTPUT_FILE"
    done
    
    pattern="*/${year}.txt"
    find . -path "$pattern" -type f | LC_ALL=C sort | while IFS= read -r file; do
        RELATIVE_PATH="${file#./}" # "./"を取り除く
        # URLエンコードが必要な場合はここで処理
        ENCODED_PATH=$(printf '%s\n' "$RELATIVE_PATH" | sed 's/ /%20/g')
        echo "- [${RELATIVE_PATH}](${BASE_URL}/${ENCODED_PATH})" >> "$OUTPUT_FILE"
    done
}

# 現在の年度と翌年度のファイルを最初に表示
output_files_by_year $NEXT_YEAR
output_files_by_year $CURRENT_YEAR

# その他のファイルを年度降順で表示
for year in $(seq $((CURRENT_YEAR - 1)) -1 2020); do
    output_files_by_year $year
done

# 年度パターンに該当しないその他のファイルを表示
tree -fi -I "README.md" -I "make_index.sh" -I "tree_output.md" -I "index.html" ./ | while IFS= read -r line; do
    if [ -f "$line" ]; then
        RELATIVE_PATH="${line#./}"
        # 年度パターン（4桁数字.md または 4桁数字.txt）でないファイルのみ表示
        if [[ ! "$RELATIVE_PATH" =~ [0-9]{4}\.(md|txt)$ ]]; then
            # URLエンコードが必要な場合はここで処理
            ENCODED_PATH=$(printf '%s\n' "$RELATIVE_PATH" | sed 's/ /%20/g')
            echo "- [${RELATIVE_PATH}](${BASE_URL}/${ENCODED_PATH})" >> "$OUTPUT_FILE"
        fi
    fi
done

echo "Markdown形式の出力が $OUTPUT_FILE に保存されました。"
