#!/usr/bin/env python3
"""Đo tiến độ Việt hóa.

Quét các chuỗi hiển thị tĩnh trong 6 trang Settings rồi so với các khóa trong
modules/common/i18n/*.js. Chỉ đếm chuỗi tĩnh: chuỗi ghép số/ngày tháng và
trạng thái cập nhật nằm ngoài phạm vi giai đoạn 1.

    python3 tools/progress.py            # tổng quan
    python3 tools/progress.py --missing  # kèm danh sách chuỗi còn thiếu
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SHELL = ROOT / "sekaipop"
SETTINGS = SHELL / "modules" / "sekai" / "settings"
I18N = SHELL / "modules" / "common" / "i18n"

PAGES = [
    ("Quick", "SettingsPageQuick.qml"),
    ("General", "SettingsPageGeneral.qml"),
    ("Bar", "SettingsPageBar.qml"),
    ("Desktop", "SettingsPageDesktop.qml"),
    ("Hyprland", "SettingsPageHyprland.qml"),
    ("About", "SettingsPageAbout.qml"),
]

# label: "..."  /  detail: "..."  /  { id: "x", label: "..." }  ...
PROP = re.compile(
    r"\b(label|sublabel|subtitle|detail|title|placeholder|specialText|text)\s*:\s*\"((?:[^\"\\]|\\.)*)\""
)
KEY = re.compile(r"^\s*\"((?:[^\"\\]|\\.)*)\"\s*:", re.MULTILINE)

# Không phải chữ hiển thị: tên icon, khóa, đường dẫn, màu, biểu thức.
NOT_TEXT = re.compile(r"^(?:[a-z][a-z0-9_]*|[a-z0-9_.\-/]+)$")


def is_text(s: str) -> bool:
    if not s or len(s) < 2:
        return False
    if NOT_TEXT.match(s):
        return False
    if s.startswith(("#", "/", "~", "$", "http", "qs.", "SettingsService", "Theme.", "mt.")):
        return False
    if any(t in s for t in ("${", " + ", "%1", "\\n")):
        return False
    return True


def dict_keys() -> set[str]:
    keys: set[str] = set()
    for f in sorted(I18N.glob("*.js")):
        keys.update(KEY.findall(f.read_text(encoding="utf-8")))
    return keys


def page_strings(path: Path) -> list[str]:
    out: list[str] = []
    seen: set[str] = set()
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.lstrip()
        if stripped.startswith("//"):
            continue
        for _, s in PROP.findall(line):
            if is_text(s) and s not in seen:
                seen.add(s)
                out.append(s)
    return out


def main() -> int:
    show_missing = "--missing" in sys.argv
    keys = dict_keys()

    grand_total = grand_done = 0
    rows = []
    for name, filename in PAGES:
        path = SETTINGS / filename
        if not path.exists():
            rows.append((name, 0, 0, []))
            continue
        strings = page_strings(path)
        missing = [s for s in strings if s not in keys]
        done = len(strings) - len(missing)
        rows.append((name, done, len(strings), missing))
        grand_total += len(strings)
        grand_done += done

    width = max(len(r[0]) for r in rows)
    for name, done, total, missing in rows:
        pct = (100 * done / total) if total else 100.0
        bar = "#" * int(pct / 5) + "." * (20 - int(pct / 5))
        print(f"{name:<{width}}  {done:>4}/{total:<4} {pct:5.1f}%  [{bar}]")

    pct = (100 * grand_done / grand_total) if grand_total else 100.0
    print("-" * (width + 34))
    print(f"{'Tổng':<{width}}  {grand_done:>4}/{grand_total:<4} {pct:5.1f}%")

    if show_missing:
        for name, _, _, missing in rows:
            if missing:
                print(f"\n== {name} ==")
                for s in missing:
                    print(f'  "{s}"')
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
