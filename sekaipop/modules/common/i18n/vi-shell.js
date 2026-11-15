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

    // ----- Quick Panel: keybind descriptions -----
    "Shell: Toggle search": "Shell: Bật/tắt tìm kiếm"
}
