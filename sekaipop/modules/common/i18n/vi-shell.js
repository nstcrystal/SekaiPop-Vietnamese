// Vietnamese for the shell outside Settings: the Quick Panel (tiles, dialogs,
// power menu, notifications), and later the launcher, bar popups, lock screen.
// Keys are the original English string, gettext style; see I18n.qml.
.pragma library

var dict = {
    // ----- Quick Panel: tile names -----
    "Speaker": "Loa",
    "Alerts": "Thông báo",
    "Dark Mode": "Chế độ tối",
    "Screen Snip": "Chụp vùng màn hình",
    "Color Picker": "Chọn màu",
    "On-Screen Keyboard": "Bàn phím ảo",
    "Power Profile": "Hồ sơ năng lượng",
    "Music Recognition": "Nhận diện nhạc",

    // ----- Quick Panel: tile subtitles -----
    "Muted": "Đã tắt",
    "MUTE": "TẮT TIẾNG",
    "AUTO": "TỰ ĐỘNG",
    "Connecting…": "Đang kết nối…",
    "Disconnecting…": "Đang ngắt kết nối…",
    "Tap": "Nhấn",
    "Saver": "Tiết kiệm",
    "Listening…": "Đang nghe…",

    // ----- Quick Panel: banner, avatar, edit tray -----
    "Change": "Đổi",
    "Frame": "Khung",
    "Remove?": "Gỡ?",
    "Columns": "Số cột",
    "Add buttons": "Thêm nút",
    "Every button is on the panel. Remove one to see it here.":
        "Mọi nút đều đang ở trên bảng. Gỡ một nút để thấy nó ở đây.",
    "The panel is full. Remove a button to make room.":
        "Bảng đã đầy. Gỡ một nút để lấy chỗ.",

    // ----- Quick Panel: notifications card -----
    "now": "vừa xong",
    "{n} notifications": "{n} thông báo",
    "Swipe to clear them all": "Vuốt để xóa tất cả",
    "Nothing here. Suspiciously quiet.": "Không có gì ở đây. Yên ắng đến đáng ngờ.",
    "All caught up. Go touch some grass.": "Xong hết rồi. Ra ngoài hít thở chút đi.",
    "No notifications. Even the group chat is asleep.":
        "Không có thông báo. Đến nhóm chat cũng đang ngủ.",
    "Inbox zero. The phone is proud of you.": "Hộp thư trống. Chiếc điện thoại tự hào về bạn.",
    "Nothing new. Miku says hi anyway.": "Không có gì mới. Dù sao Miku vẫn chào bạn.",
    "Silence. Enjoy it while it lasts.": "Im lặng. Tận hưởng khi còn được.",

    // ----- Quick Panel: audio flyout -----
    "Input": "Đầu vào",
    "Output": "Đầu ra",
    "No device": "Không có thiết bị",
    "Switching…": "Đang chuyển…",
    "App volumes": "Âm lượng ứng dụng",
    "paused": "tạm dừng",
    "Nothing's recording right now": "Hiện không có gì đang ghi âm",
    "Nothing's playing right now": "Hiện không có gì đang phát",

    // ----- Quick Panel: network dialog -----
    "Scanning…": "Đang quét…",
    "Scan": "Quét",
    "Advanced": "Nâng cao",
    "Password": "Mật khẩu",
    "Connect": "Kết nối",
    "No networks found": "Không tìm thấy mạng nào",
    "Connected — tap to disconnect": "Đã kết nối — nhấn để ngắt",
    "Secured": "Có mật khẩu",
    "Open": "Mở",

    // ----- Quick Panel: Bluetooth dialog -----
    "Refreshing…": "Đang làm mới…",
    "Refresh": "Làm mới",
    "Devices paired elsewhere show up here. New pairing isn't done from this panel.":
        "Thiết bị đã ghép nối ở nơi khác sẽ hiện ở đây. Không ghép nối mới từ bảng này.",
    "No paired devices": "Chưa có thiết bị ghép nối",
    "Paired — tap to connect": "Đã ghép nối — nhấn để kết nối",

    // ----- Quick Panel: night light dialog -----
    "Intensity": "Cường độ",
    "Cool": "Mát",
    "Warm": "Ấm",
    "Automatic": "Tự động",
    "Turn on by itself between two times": "Tự bật giữa hai mốc giờ",
    "Until": "Đến",
    "A click on the tile overrides Automatic until the next start or end time.":
        "Nhấn vào ô sẽ ghi đè chế độ Tự động cho tới mốc bắt đầu hoặc kết thúc kế tiếp.",

    // ----- Quick Panel: power menu -----
    "Shut down": "Tắt máy",
    "Reboot": "Khởi động lại",
    "Log out": "Đăng xuất",
    "Lock": "Khóa",
    "Sleep": "Ngủ",
    "Reboot to firmware": "Khởi động lại vào firmware",
    "System monitor": "Theo dõi hệ thống",
    "{label} will cut it off: {note}": "{label} sẽ cắt ngang: {note}",
    "{names} is running ({kind})": "{names} đang chạy ({kind})",
    "an install or update": "cài đặt hoặc cập nhật",
    "an install and a download": "cài đặt và tải xuống",
    "a download": "tải xuống",

    // ----- Apps / Launcher: search, rows, system actions -----
    "Search apps": "Tìm ứng dụng",
    "No apps match": "Không có ứng dụng nào khớp",
    "Press Enter again to confirm": "Nhấn Enter lần nữa để xác nhận",
    "Search the web for \u201c{q}\u201d": "Tìm trên web \u201c{q}\u201d",
    "Opens in your browser": "Mở trong trình duyệt",
    "Run in a terminal": "Chạy trong terminal",
    "Run a command": "Chạy một lệnh",
    "Type a command \u2014 > runs in the background, $ opens a terminal":
        "Nhập một lệnh \u2014 > chạy nền, $ mở terminal",
    "Runs in a terminal that stays open": "Chạy trong terminal giữ mở",
    "Runs in the background; output comes back as a notification":
        "Chạy nền; kết quả trả về dưới dạng thông báo",

    "Lock screen": "Khóa màn hình",
    "Lock with the shell's lockscreen": "Khóa bằng màn hình khóa của shell",
    "Sleep": "Ngủ",
    "Suspend to RAM": "Tạm ngưng vào RAM",
    "Suspend to disk": "Tạm ngưng vào đĩa",
    "Restart": "Khởi động lại",
    "Reboot the computer": "Khởi động lại máy",
    "Power the computer off": "Tắt nguồn máy",
    "End the Hyprland session": "Kết thúc phiên Hyprland",
    "Restart into BIOS / UEFI setup": "Khởi động lại vào BIOS / UEFI",
    "Open or close the phone panel": "Mở hoặc đóng bảng điện thoại",
    "Wallpapers": "Hình nền",
    "Open the wallpaper board": "Mở bảng hình nền",
    "Select an area; saved and copied": "Chọn một vùng; lưu và sao chép",
    "Pick a colour": "Chọn màu",
    "Eyedropper anywhere on screen": "Hút màu ở bất kỳ đâu trên màn hình",
    "Mute / unmute speakers": "Tắt/bật tiếng loa",
    "Toggle the default output": "Bật/tắt đầu ra mặc định",
    "Mute / unmute microphone": "Tắt/bật micrô",
    "Toggle the default input": "Bật/tắt đầu vào mặc định",
    "Dark / light mode": "Chế độ tối / sáng",
    "Flip the system colour scheme": "Đổi bảng màu hệ thống",
    "Wi-Fi on / off": "Bật/tắt Wi-Fi",
    "Toggle the Wi-Fi radio": "Bật/tắt sóng Wi-Fi",
    "Bluetooth on / off": "Bật/tắt Bluetooth",
    "Toggle the Bluetooth adapter": "Bật/tắt bộ điều hợp Bluetooth",
    "Clear clipboard history": "Xóa lịch sử clipboard",
    "Delete everything cliphist saved": "Xóa mọi thứ cliphist đã lưu",

    // ----- Launcher: clipboard card -----
    "Matching \u201c{q}\u201d": "Khớp \u201c{q}\u201d",
    "Copy": "Sao chép",
    "Loading\u2026": "Đang tải\u2026",
    "Pick something above": "Chọn một mục ở trên",
    "This picture can\u2019t be shown here (its format is not supported).\nCopy still puts it back on the clipboard.":
        "Không hiển thị được ảnh này ở đây (định dạng không được hỗ trợ).\nSao chép vẫn đưa nó trở lại clipboard.",
    "Could not load this picture": "Không tải được ảnh này",
    "Pinned \u00b7 ": "Đã ghim \u00b7 ",
    "Preview only \u2014 the whole entry could not be loaded":
        "Chỉ xem trước \u2014 không tải được toàn bộ mục",
    "{n} characters \u00b7 {m} line": "{n} ký tự \u00b7 {m} dòng",
    "{n} characters \u00b7 {m} lines": "{n} ký tự \u00b7 {m} dòng",
    "Clipboard history needs cliphist and wl-clipboard. Install both and restart the shell \u2014 it fills as you copy.":
        "Lịch sử clipboard cần cliphist và wl-clipboard. Cài cả hai rồi khởi động lại shell \u2014 nó sẽ đầy dần khi bạn sao chép.",
    "Nothing in your history matches that.": "Không có mục nào trong lịch sử khớp.",
    "Nothing copied yet.\nCopy something and it will show up here.":
        "Chưa sao chép gì.\nSao chép thứ gì đó và nó sẽ hiện ở đây.",

    // ----- Launcher: colour, emoji, gallery, web cards -----
    "Pick from screen": "Chọn từ màn hình",
    "Type a colour \u2014 #ff8800, rgb(255, 136, 0), hsl(32 100% 50%) or a name like coral":
        "Nhập một màu \u2014 #ff8800, rgb(255, 136, 0), hsl(32 100% 50%) hoặc tên như coral",
    "Pick one": "Chọn một cái",
    "Recent": "Gần đây",
    "Smileys & emotion": "Mặt cười & cảm xúc",
    "People & body": "Người & cơ thể",
    "Animals & nature": "Động vật & thiên nhiên",
    "Food & drink": "Đồ ăn & thức uống",
    "Travel & places": "Du lịch & địa điểm",
    "Activities": "Hoạt động",
    "Objects": "Đồ vật",
    "Symbols": "Ký hiệu",
    "Flags": "Cờ",
    "Enter copies \u00b7 Shift types": "Enter sao chép \u00b7 Shift gõ",
    "SORT BY": "SẮP XẾP THEO",
    "Go to <b>{q}</b>": "Đi tới <b>{q}</b>",
    "Search <b>{engine}</b> for <b>{q}</b>": "Tìm <b>{q}</b> trên <b>{engine}</b>",
    "Type what to search for.\nTab switches search engine \u00b7 a web address opens directly.":
        "Nhập nội dung cần tìm.\nTab đổi công cụ tìm kiếm \u00b7 địa chỉ web sẽ mở trực tiếp.",

    // ----- Lockscreen -----
    "LOCKED": "ĐÃ KHÓA",
    "NAME": "TÊN",
    "PASSWORD": "MẬT KHẨU",
    "CHECKING\u2026": "ĐANG KIỂM TRA\u2026",
    "LOCKED SINCE {time}": "ĐÃ KHÓA LÚC {time}",
    "Locked since {time}": "Đã khóa từ {time}",
    "Screen locked": "Đã khóa màn hình",
    "SLEEP": "NGỦ",
    "UNLOCK": "MỞ KHÓA",
    "Unlock": "Mở khóa",
    "Enter": "Mở khóa",
    "RESTART": "KHỞI ĐỘNG LẠI",
    "SHUT DOWN": "TẮT MÁY",
    "PRESS AGAIN TO {what}": "NHẤN LẦN NỮA ĐỂ {what}",
    "ENTER OR CLICK TO SLEEP": "ENTER HOẶC NHẤN ĐỂ NGỦ",
    "HOLD CTRL FOR SLEEP": "GIỮ CTRL ĐỂ NGỦ",
    "Fingerprint not recognized": "Không nhận ra vân tay",
    "Couldn't check the password (PAM error)": "Không kiểm tra được mật khẩu (lỗi PAM)",
    "Too many tries \u2014 wait a moment": "Sai quá nhiều lần \u2014 chờ chút",
    "Wrong password": "Sai mật khẩu",

    // ----- Quick Panel: keybind descriptions -----
    "Shell: Toggle search": "Shell: Bật/tắt tìm kiếm"
}
