#!/bin/bash
# Обновление дашборда в один шаг
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="/Users/catherine/Documents/Giga Соглашения/Diadoc/Diadoc_status.xlsx"

cd "$SCRIPT_DIR"

# Подтягиваем изменения с сервера (авторазрешение конфликтов в JSON)
git pull origin main --rebase -X ours 2>/dev/null || {
  # Если конфликт — принимаем нашу версию и продолжаем
  git checkout --ours data/dashboard.json 2>/dev/null
  git add data/dashboard.json 2>/dev/null
  GIT_EDITOR=true git rebase --continue 2>/dev/null
}

# Копируем свежий xlsx
cp "$SOURCE" "$SCRIPT_DIR/Diadoc_status.xlsx"

# Генерируем JSON
python3 "$SCRIPT_DIR/convert_xlsx.py"

# Коммитим и пушим
git add -A
git diff --cached --quiet || git commit -m "Update dashboard $(date '+%d.%m.%Y %H:%M')"
git push || {
  git pull origin main --rebase -X ours 2>/dev/null || {
    git checkout --ours data/dashboard.json 2>/dev/null
    git add data/dashboard.json 2>/dev/null
    GIT_EDITOR=true git rebase --continue 2>/dev/null
  }
  git push
}

echo ""
echo "Готово! Дашборд обновится через 1-2 минуты:"
echo "https://caterinesav.github.io/diadoc-dashboard/"
