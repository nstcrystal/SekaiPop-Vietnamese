#!/bin/sh
# Chạy bản Việt hóa (trong thư mục này) hoặc quay lại bản đang dùng.
#
#   ./switch.sh vi    bản dịch
#   ./switch.sh en    bản gốc
#   ./switch.sh which bản nào đang chạy
#   ./switch.sh log   xem log của shell đang chạy
#
# Vì sao phải hoán đổi thư mục thay vì chạy `qs -p`:
# mọi phím tắt trong ~/.config/hypr gọi `qs -c sekaipop ipc call ...`, và
# `qs -c` chỉ tìm instance theo tên config. Một shell chạy bằng `-p` không
# nhận được các lệnh đó, nên phím tắt shell (SUPER + A, N, I, ...) chết, còn
# terminal và chuyển workspace (bind native của Hyprland) vẫn chạy.
#
# Cách làm: đổi tên bản gốc thành sekaipop.en rồi đặt symlink
# ~/.config/quickshell/sekaipop -> ~/SekaiPop-Vietnamese/sekaipop. Cả hai bản
# đều chạy dưới tên `sekaipop`, nên phím tắt, hypridle, Ctrl+Super+R và
# keybinds panel hoạt động giống hệt nhau. `en` xóa symlink và trả thư mục cũ.
#
# Chỉ một shell chạy tại một thời điểm: hai bản sẽ tranh GlobalShortcut,
# notification daemon, polkit, layer-shell và IPC.
set -u

VI="$HOME/SekaiPop-Vietnamese/sekaipop"
QS_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"
LINK="$QS_ROOT/sekaipop"
BAK="$QS_ROOT/sekaipop.en"

# Symlink do script này tạo luôn trỏ tuyệt đối tới $VI.
is_vi() { [ -L "$LINK" ] && [ "$(readlink "$LINK" 2>/dev/null)" = "$VI" ]; }
running() {
    qs list --all 2>/dev/null | grep -Fq -e "Config path: $LINK/shell.qml" \
        -e "Config path: $VI/shell.qml"
}

stop_all() {
    qs kill -c sekaipop >/dev/null 2>&1 || true
    qs kill -p "$VI" >/dev/null 2>&1 || true
    i=0
    while [ "$i" -lt 50 ]; do
        if ! running; then
            break
        fi
        sleep 0.1
        i=$((i + 1))
    done
}

# Nếu lần chạy trước thoát giữa lúc đổi tên và tạo symlink, trả thư mục gốc về.
recover() {
    if [ ! -L "$LINK" ] && [ ! -e "$LINK" ] && [ -d "$BAK" ]; then
        mv "$BAK" "$LINK"
    fi
}

use_vi() {
    if is_vi; then
        return 0
    fi
    if [ -L "$LINK" ]; then
        echo "LỖI: $LINK đang là symlink lạ ($(readlink "$LINK" 2>/dev/null))." >&2
        return 1
    fi
    if [ ! -d "$VI" ]; then
        echo "LỖI: không thấy bản dịch ở $VI." >&2
        return 1
    fi
    if [ -e "$BAK" ]; then
        echo "LỖI: $BAK đã tồn tại; không ghi đè." >&2
        return 1
    fi
    if [ ! -d "$LINK" ]; then
        echo "LỖI: không thấy bản gốc ở $LINK." >&2
        return 1
    fi

    mv "$LINK" "$BAK" || return 1
    if ! ln -s "$VI" "$LINK"; then
        mv "$BAK" "$LINK"
        return 1
    fi
}

use_en() {
    if [ -L "$LINK" ]; then
        if ! is_vi; then
            echo "LỖI: $LINK là symlink lạ ($(readlink "$LINK" 2>/dev/null))." >&2
            return 1
        fi
        rm -f "$LINK" || return 1
        if [ -d "$BAK" ]; then
            mv "$BAK" "$LINK" || return 1
        else
            echo "CẢNH BÁO: không thấy $BAK; bản gốc cần được cài lại." >&2
            return 1
        fi
    elif [ ! -e "$LINK" ] && [ -d "$BAK" ]; then
        mv "$BAK" "$LINK" || return 1
    fi
}

# Khởi động rồi chờ tới khi Quickshell báo đã nạp xong config. Trả về 1 nếu
# không lên trong khoảng 8 giây (QML lỗi, thiếu file, hoặc bị instance khác chặn).
start_shell() {
    qs -c sekaipop -n -d >/dev/null 2>&1 || return 1
    i=0
    while [ "$i" -lt 40 ]; do
        if running && qs log -c sekaipop 2>/dev/null | grep -q "Configuration Loaded"; then
            return 0
        fi
        sleep 0.2
        i=$((i + 1))
    done
    return 1
}

show_log() {
    if ! running; then
        echo "Không có shell nào đang chạy." >&2
        return 1
    fi
    qs log -c sekaipop 2>&1 | tail -n 80
}

case "${1:-}" in
    vi)
        recover
        stop_all
        if ! use_vi; then
            exit 1
        fi
        if start_shell; then
            echo "Đang chạy bản Việt hóa: $VI"
            echo "  (qua $LINK, nên phím tắt dùng tên sekaipop vẫn hoạt động)"
            exit 0
        fi

        echo "Bản Việt hóa không khởi động được. 40 dòng log cuối:" >&2
        qs log -c sekaipop 2>&1 | tail -n 40 >&2 || true
        echo "Đang quay lại bản gốc..." >&2
        stop_all
        if use_en; then
            start_shell && echo "Đã quay lại bản gốc: $LINK" >&2
        fi
        exit 1
        ;;
    en)
        recover
        stop_all
        if ! use_en; then
            exit 1
        fi
        if start_shell; then
            echo "Đang chạy bản gốc: $LINK"
            exit 0
        fi
        echo "Bản gốc cũng không khởi động được. 40 dòng log cuối:" >&2
        qs log -c sekaipop 2>&1 | tail -n 40 >&2 || true
        exit 1
        ;;
    which)
        if is_vi; then
            if running; then
                echo "vi  ($LINK -> $VI)"
            else
                echo "vi  (đã chọn, chưa chạy)"
            fi
        elif [ -L "$LINK" ]; then
            echo "symlink lạ: $LINK -> $(readlink "$LINK" 2>/dev/null)"
        elif [ -d "$LINK" ]; then
            if running; then
                echo "en  ($LINK)"
            else
                echo "en  (đã chọn, chưa chạy)"
            fi
        else
            echo "không có shell nào đang chạy"
        fi
        echo "Cấu hình dùng chung: ~/.config/sekaipop và ~/.local/state/sekaipop"
        ;;
    log)
        show_log
        ;;
    *)
        echo "dùng: $0 vi|en|which|log" >&2
        exit 1
        ;;
esac
