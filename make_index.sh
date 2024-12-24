#!/bin/bash

# 出力先を決める（例: markdown_output.md）
OUTPUT_FILE="tree_output.md"

# ベースURL（GitHubリポジトリのURL。適宜変更）
BASE_URL="https://github.com/TetsuakiBaba/syllabus/main"

# 出力ファイルを初期化
echo "" > "$OUTPUT_FILE"

# treeコマンドの出力を加工
tree -fi -I "README.md" -I "make_index.sh" -I "tree_output.md" ./ | while read -r line; do
    if [ -d "$line" ]; then
        # ディレクトリの場合はそのまま表示
        # echo "- ${line}" >> "$OUTPUT_FILE"
        :
    elif [ -f "$line" ]; then
        # ファイルの場合はリンクを作成
        RELATIVE_PATH="${line#./}" # "./"を取り除く
        echo "- [${RELATIVE_PATH}](${BASE_URL}/${RELATIVE_PATH})" >> "$OUTPUT_FILE"
    fi
done

echo "Markdown形式の出力が $OUTPUT_FILE に保存されました。"
