#!/usr/bin/env python3
"""Конвертирует Diadoc_status.xlsx → data/dashboard.json для GitHub Pages."""

import json, re, os
from openpyxl import load_workbook
from datetime import datetime

XLSX_PATH = os.path.join(os.path.dirname(__file__), "Diadoc_status.xlsx")
OUT_PATH = os.path.join(os.path.dirname(__file__), "data", "dashboard.json")


def clean(val):
    if val is None:
        return ""
    s = str(val).strip()
    m = re.match(r'^="(.+)"$', s)
    return m.group(1) if m else s


def doc_type(doc_num):
    s = str(doc_num) if doc_num else ""
    if "LBO" in s:
        return "PAYG"
    if "LBS" in s:
        return "Пакеты"
    return "Другое"


def main():
    wb = load_workbook(XLSX_PATH, data_only=True)
    ws = wb.active

    statuses = {}
    types = {"PAYG": 0, "Пакеты": 0}
    status_by_type = {}
    rows_data = []

    total = 0
    for row in range(2, ws.max_row + 1):
        org = clean(ws.cell(row=row, column=3).value)
        doc_num = clean(ws.cell(row=row, column=5).value)
        status = clean(ws.cell(row=row, column=14).value)

        if not org:
            continue

        total += 1
        dtype = doc_type(doc_num)

        statuses[status] = statuses.get(status, 0) + 1
        if dtype in types:
            types[dtype] = types.get(dtype, 0) + 1

        key = f"{dtype}|{status}"
        status_by_type[key] = status_by_type.get(key, 0) + 1

    # Для cross-table: статус × тип
    all_statuses = sorted(statuses.keys())
    all_types = sorted(types.keys())
    cross = []
    for s in all_statuses:
        row = {"status": s}
        for t in all_types:
            row[t] = status_by_type.get(f"{t}|{s}", 0)
        cross.append(row)

    result = {
        "updated": datetime.now().strftime("%d.%m.%Y %H:%M"),
        "total": total,
        "statuses": statuses,
        "types": types,
        "cross": cross,
    }

    os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)
    with open(OUT_PATH, "w", encoding="utf-8") as f:
        json.dump(result, f, ensure_ascii=False, indent=2)

    print(f"OK: {total} строк → {OUT_PATH}")


if __name__ == "__main__":
    main()
