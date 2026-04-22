# Diadoc Dashboard

Дашборд мониторинга статусов документов Diadoc.

## Быстрый старт

### 1. Создайте репозиторий на GitHub

Если репозиторий ещё не создан:
```bash
cd diadoc-dashboard
git init
git add .
git commit -m "Initial dashboard"
git branch -M main
git remote add origin https://github.com/ВАШ_ЛОГИН/diadoc-dashboard.git
git push -u origin main
```

### 2. Включите GitHub Pages

1. Откройте **Settings → Pages** в репозитории
2. Source: выберите **GitHub Actions**

### 3. Обновление данных

Замените файл `Diadoc_status.xlsx` в репозитории и сделайте push:
```bash
cp "/Users/catherine/Documents/Giga Соглашения/Diadoc/Diadoc_status.xlsx" .
git add Diadoc_status.xlsx
git commit -m "Update data"
git push
```

GitHub Actions автоматически пересоберёт JSON и обновит дашборд.

## Структура

- `index.html` — интерактивный дашборд (Chart.js)
- `convert_xlsx.py` — скрипт конвертации xlsx → json
- `data/dashboard.json` — данные для дашборда
- `.github/workflows/update-dashboard.yml` — автоматизация
