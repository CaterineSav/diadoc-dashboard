#!/bin/bash
# Обновление дашборда в один шаг:
# 1. Копирует свежий xlsx
# 2. Генерирует JSON
# 3. Коммитит и пушит в GitHub
# GitHub Actions автоматически обновит страницу

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="/Users/catherine/Documents/Giga Соглашения/Diadoc/Diadoc_status.xlsx"

cd "$SCRIPT_DIR"

# Копируем свежий xlsx
cp "$SOURCE" "$SCRIPT_DIR/Diadoc_status.xlsx"

# Генерируем JSON
python3 "$SCRIPT_DIR/convert_xlsx.py"

# Коммитим и пушим
git add -A
git commit -m "Update dashboard data $(date '+%d.%m.%Y %H:%M')"
git push

echo ""
echo "Готово! Дашборд обновится через 1-2 минуты."
echo "https://caterinesav.github.io/diadoc-dashboard/"
