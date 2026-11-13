#!/bin/sh
# Chạy bản Việt hóa (trong thư mục này) hoặc quay lại bản đang dùng.
#
#   ./switch.sh vi    bản dịch   (qs -p ~/SekaiPop-Vietnamese/sekaipop)
#   ./switch.sh en    bản gốc    (qs -c sekaipop)
#   ./switch.sh which bản nào đang chạy
#
# Chỉ một shell chạy tại một thời điểm: hai bản sẽ tranh GlobalShortcut,
# notification daemon, polkit, layer-shell và IPC.
set -u

VI="$HOME/SekaiPop-Vietnamese/sekaipop"
QS_DIR="$HOME/.config/quickshell/sekaipop"

running_vi() { qs list --all 2>/dev/null | grep -q "Config path: $VI/shell.qml"; }
running_en() { qs list --all 2>/dev/null | grep -q "Config path: $QS_DIR/shell.qml"; }

stop_all() {
    qs kill -p "$VI" >/dev/null 2>&1 || true
    qs kill -c sekaipop >/dev/null 2>&1 || true
    i=0
    while [ "$i" -lt 50 ]; do
        if ! running_vi && ! running_en; then
            break
        fi
        sleep 0.1
        i=$((i + 1))
    done
}

case "${1:-}" in
    vi)
        stop_all
        qs -p "$VI" -n -d
        echo "Đang chạy bản Việt hóa: $VI"
        ;;
    en)
        stop_all
        qs -c sekaipop -n -d
        echo "Đang chạy bản gốc: $QS_DIR"
        ;;
    which)
        if running_vi; then
            echo "vi  ($VI)"
        elif running_en; then
            echo "en  ($QS_DIR)"
        else
            echo "không có shell nào đang chạy"
        fi
        ;;
    *)
        echo "dùng: $0 vi|en|which" >&2
        exit 1
        ;;
esac
