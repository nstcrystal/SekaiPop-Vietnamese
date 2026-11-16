# Việt hóa SekaiPop

Tài liệu này ghi lại cách bản Việt hóa hoạt động, những gì nó chạm vào trên máy,
tiến độ dịch và việc cần làm tiếp theo.

- Bản gốc đang dùng: `~/.config/quickshell/sekaipop` (SekaiPop `6fbf784`)
- Bản Việt hóa: `~/SekaiPop-Vietnamese/sekaipop`
- Ngôn ngữ mặc định: `vi`; đổi trong **Settings > General > Language**

---

## 1. Chạy thử

```sh
cd ~/SekaiPop-Vietnamese

./switch.sh vi      # chạy bản Việt hóa
./switch.sh en      # quay lại bản gốc
./switch.sh which   # đang chạy bản nào
./switch.sh log     # 80 dòng log cuối của shell đang chạy
```

Chỉ chạy **một** shell tại một thời điểm. Hai bản sẽ tranh nhau GlobalShortcut,
notification daemon, polkit, layer-shell và IPC.

### Vì sao `switch.sh` hoán đổi thư mục?

Mọi phím tắt trong `~/.config/hypr` gọi:

```sh
qs -c sekaipop ipc call <target> <function>
```

`qs -c` chỉ tìm instance theo **tên config**. Một shell chạy bằng `qs -p ...`
không nhận được các lệnh này, nên:

- Terminal và chuyển workspace vẫn chạy (bind native của Hyprland).
- `SUPER + A/N/O/I/K/M/G`, `SUPER + W`, theme, settings, screenshot… không chạy.
- `Ctrl + Super + R` sẽ khởi động lại **bản gốc**, vì lệnh restart ghi cứng `qs -c sekaipop`.
- `hypridle` gọi `qs -c sekaipop ipc call lock lock`, nên khóa theo idle cũng trỏ sai.

Vì vậy `switch.sh vi` làm như sau:

```text
~/.config/quickshell/sekaipop        đổi tên thành  sekaipop.en
~/.config/quickshell/sekaipop        symlink tới     ~/SekaiPop-Vietnamese/sekaipop
```

Cả hai bản đều chạy dưới tên `sekaipop`, nên phím tắt, hypridle, restart và
keybinds panel hoạt động giống hệt nhau. `./switch.sh en` xóa symlink và trả
thư mục gốc về chỗ cũ.

Kiểm tra nhanh sau khi chuyển:

```sh
qs -c sekaipop ipc call options get quick.flat
```

Phải trả về `quick.flat = ...`, không phải `No running instances`.

---

## 2. Kiến trúc i18n

| Tệp | Vai trò |
|---|---|
| `sekaipop/modules/common/I18n.qml` | Singleton `I18n.t()`, `I18n.lang`, `I18n.setLang()` |
| `sekaipop/modules/common/i18n/vi-common.js` | Thuật ngữ dùng chung (Settings, menu, widget) |
| `sekaipop/modules/common/i18n/vi-settings.js` | Sáu trang Settings và các thẻ plugin |
| `sekaipop/modules/common/i18n/vi-shell.js` | Phần còn lại của shell (Bar, panel, popup, keybinds…) |
| `sekaipop/services/SettingsService.qml` | Lưu `"i18n.lang"` (`vi` mặc định) |
| `tools/progress.py` | Đo tiến độ chuỗi tĩnh (`--all` gồm plugin/dialog) |

Nguyên tắc:

- **Khóa là chính chuỗi tiếng Anh gốc** (kiểu gettext). Không đánh số, không cần
  đồng bộ ID; chuỗi chưa dịch tự động giữ tiếng Anh.
- Chỉ dịch ở **lớp hiển thị**:
  ```qml
  text: I18n.t(root.label)
  ```
  Không dịch `label` / `title` gốc nếu code khác đọc chúng (`SectionCard` chọn
  icon theo `title`, `SettingsFace` dựng search index theo `label`, option giữ `id`).
- Search của Settings tìm được cả tiếng Anh gốc lẫn tiếng Việt.
- Placeholder dùng `{name}`:
  ```qml
  I18n.t("Checked {time}", { time: "20:15" })
  ```
- `I18n.t` trả về nguyên chuỗi nếu ngôn ngữ là `en` hoặc không có bản dịch.

### Giới hạn hiện tại

- Đã dịch cả **chuỗi động** trong Settings: trạng thái cài/cập nhật, tuổi cache,
  thông báo lỗi plugin, hộp thoại gỡ/cài, tiến trình clone/pull.
- Chuỗi ghép số **ngoài Settings** (Quick Panel, Apps, Lockscreen…) còn tiếng Anh.
- `tools/progress.py` mặc định quét 6 file `SettingsPage*.qml`; `--all` quét
  thêm `Plugin*.qml`, `Setting*.qml`, `DisplayLayout`, `KeyCaps`.
- Script đo **khóa tĩnh trong file QML**; chuỗi dựng bằng biểu thức
  (`I18n.t(cond ? "a" : "b")`) không được đếm, dù đã dịch.
- `CHANGELOG.md` (thẻ “Có gì mới” trong About) **giữ tiếng Anh** có chủ đích: đó
  là ghi chú phát hành, không phải giao diện.
- Tên riêng/sản phẩm giữ nguyên: Wi-Fi, Bluetooth, Hyprland, Quickshell,
  SekaiPop, Sekai Pad, Discord, EasyEffects, Wallhaven, OCR, OSD, GTK, Qt, KDE,
  Matugen, Dock, Widget, Plugin, Quick Panel.
- Nội dung do plugin viết (tên cài đặt, lựa chọn, mô tả trong `plugin.json`)
  **không dịch**: đó là dữ liệu của bên thứ ba.

---

## 3. Ảnh hưởng tới `~/.config` và `~/.local/state`

`switch.sh` chỉ đổi tên/tạo symlink trong `~/.config/quickshell`. Bản thân shell
khi chạy sẽ ghi vào **cùng chỗ** với bản gốc — đây là thiết kế, không phải lỗi
Việt hóa.

| Đường dẫn | Khi nào bị ghi |
|---|---|
| `~/.config/sekaipop/settings.json` | Mỗi khi đổi cài đặt; thêm `"i18n.lang"` khi đổi ngôn ngữ |
| `~/.config/sekaipop/plugins/` | Khi cài/gỡ plugin |
| `~/.config/sekaipop/plugins-lock.json` | Khi cài/cập nhật plugin |
| `~/.config/sekaipop/idle.conf`, `scale.json` | Khi đổi idle / cỡ shell |
| `~/.config/sekaipop/update-url`, `update-repo` | Khi cấu hình cập nhật |
| `~/.config/hypr/sekaipop_overrides.lua` | Khi đổi cài đặt Hyprland / theme / Game Mode |
| `~/.config/hypr/hypridle.conf` | Khi dùng “Use these times” |
| `~/.local/state/sekaipop/*` | Dock layout, notification, tray, terminal prompt… |
| `~/.cache/sekaipop/*` | Matugen, thumbnail hình nền, log lỗi Hyprland |

### `"i18n.lang"` giữa hai bản

Bản gốc không có key này trong `SettingsService.defaults`, nên:

- Bản gốc đọc file và **bỏ qua** `"i18n.lang"`.
- Khi bản gốc ghi lại `settings.json`, key này biến mất.
- Lần sau quay lại bản dịch sẽ về mặc định `vi`.

Không hỏng dữ liệu; chỉ mất lựa chọn ngôn ngữ. Muốn giữ, thêm
`"i18n.lang": "vi"` vào defaults của bản gốc hoặc lưu ngôn ngữ ra file riêng.

---

## 4. Khi có lỗi

### Bản dịch không lên sau `./switch.sh vi`

`switch.sh` tự kiểm tra:

1. Chờ tối đa ~8 giây.
2. Xem shell có trong `qs list` và log có `Configuration Loaded`.
3. Nếu không: in 40 dòng log cuối, xóa symlink, trả `sekaipop.en` về, chạy lại
   bản gốc.

Nếu vẫn mất bar/desktop:

```sh
# terminal hiện có, hoặc chuyển sang TTY: Ctrl+Alt+F2
~/SekaiPop-Vietnamese/switch.sh en
```

Kiểm tra trạng thái:

```sh
ls -ld ~/.config/quickshell/sekaipop ~/.config/quickshell/sekaipop.en
readlink ~/.config/quickshell/sekaipop
```

- `sekaipop` là thư mục thật → bản gốc.
- `sekaipop` là symlink tới `~/SekaiPop-Vietnamese/sekaipop` → bản dịch.
- Có `sekaipop.en` → bản gốc đang được giữ làm backup.

Nếu script thoát giữa lúc đổi tên và tạo symlink (rất hiếm), lần chạy sau sẽ tự
khôi phục. Khôi phục tay:

```sh
rm ~/.config/quickshell/sekaipop
mv ~/.config/quickshell/sekaipop.en ~/.config/quickshell/sekaipop
```

### Xem log

```sh
./switch.sh log
qs log -c sekaipop | grep -iE 'error|is not a type|SyntaxError' | tail
```

### Phím tắt không chạy

Kiểm tra IPC:

```sh
qs -c sekaipop ipc call options get quick.flat
```

- Trả về `quick.flat = ...`: IPC ổn, lỗi nằm ở bind/QML.
- `No running instances`: shell đang chạy bằng `-p` (cách cũ) hoặc symlink bị sai.
  Chạy lại `./switch.sh vi`.

### `settings.json` hỏng hoặc muốn quay về mặc định

Tệp được ghi qua file tạm rồi `mv`, nên khó hỏng giữa chừng. Nếu cần:

```sh
cp ~/.config/sekaipop/settings.json ~/.config/sekaipop/settings.json.bak
```

Sau đó xóa `settings.json` để shell dùng defaults.

---

## 5. Tiến độ dịch

Đo bằng:

```sh
python3 tools/progress.py
python3 tools/progress.py --all
python3 tools/progress.py --missing
```

Kết quả hiện tại: **596/596 (100%)** trên 6 trang Settings; **651/651 (100%)**
khi quét thêm component plugin và dialog.

| Hạng mục | Chuỗi | Trạng thái | Commit |
|---|---:|---|---|
| Hạ tầng i18n, nút Language | — | 100% | `b0fffe1` |
| Settings > General | 97/97 | 100% | `ec790a3` |
| Settings > Quick | 48/48 | 100% | `1133ea1` |
| Settings > Bar | 68/68 | 100% | `1133ea1` |
| Settings > Desktop | 255/255 | 100% | `6271da3` |
| Settings > Hyprland | 117/117 | 100% | `200eeb0` |
| Settings > About | 11/11 | 100% | `200eeb0` |
| Component plugin (phần tĩnh) | — | đã dịch | `200eeb0` |
| Chuỗi động trong Settings | ~160 khóa | 100% | `65849df` |
| Quick Panel: tile, dialog, power menu | ~110 khóa | đã dịch | `622541f` |
| Apps/Launcher + 5 thẻ phụ | ~60 khóa | đã dịch | `2e1701a` |
| Lockscreen (2 bố cục) | ~25 khóa | đã dịch | `be3a13e` |
| Bar: chỉ báo, tooltip, 4 popup | ~140 khóa | đã dịch | `45a0c7a` |
| OSD + nhãn ghi màn hình | 7 khóa | đã dịch | `fafdc49` |
| Wallpapers: thư viện, Wallhaven | ~130 khóa | đã dịch | `f2b7a81` |
| Welcome tour (5 slide) | 15 khóa | đã dịch | `642b65e` |
| Keybinds panel + cheatsheet | ~140 khóa | đã dịch | `9fa9477` |
| Notification popup + popup còn lại của Bar | ~110 khóa | đã dịch | `4ff7bf0` |
| Dock: menu chuột phải, timer, clipboard, shelf | ~50 khóa | đang làm (9a xong) | `3d75082` |

Component plugin đã dịch phần hiển thị tĩnh: `PluginRepoHead`, `PluginNote`,
`PluginSourceRow`, `PluginSourcePanel`, `PluginUpdateBox`, `PluginListEntry`,
`PluginField`, `PluginBadge`, `PluginChip` (qua `SettingChip`).

Cụm 2a đã dịch thêm:

- `PluginRepos.js`: `failure`, `namesText`, `ageText`, `whereText`,
  `updatesTitle`, `kindText`, `sourceLine` nhận tham số `t`.
- `PluginForm.js`: `plural`, `countText`, `warnText`, `skipInfo` nhận `t`.
- Trạng thái tải plugin (offline, đang tìm, tìm thấy, không tải được), tiến
  trình `Cloning` / `Linking` / `Pulling` / `Removing`, thông báo sau khi cài.
- `PluginEditor`, `PluginRemoveAsk`, `PluginSecretRow`, `PluginRow`,
  `SettingsPluginsUpdate`, `SettingsGetPlugins`.
- `SegmentSwitch` dịch nhãn (dùng chung cho mọi switch trong shell).
- `DisplayLayout`, `KeyCaps` (`or` → “hoặc”, `No key` → “Không có phím”),
  `KeyRoundButton` tooltip.

Cụm 2b-1 (Quick Panel) dùng từ điển riêng
`modules/common/i18n/vi-shell.js`, nối vào `I18n.qml` sau `vi-settings.js`:

- `QuickPanelFace`: tên/trạng thái tile (Wi-Fi, Bluetooth, Micrô, Loa, Alerts,
  Night Light, Game Mode, Dark Mode…), banner (`Change`, `Frame`, `Remove?`),
  thẻ thông báo (`{n} notifications`, `Swipe to clear them all`, các câu trống),
  khay sửa (`Columns`, `Add buttons`, thông báo đầy/trống), audio flyout.
- `QuickToggle`, `SekaiTile`, `SekaiHubTile`: dịch tại nơi gọi (chúng vẽ thẳng
  `label`/`subtitle`); `VolumeSlider` (`MUTE`).
- `NetworkDialog`: `Scanning…`, `Scan`, `Advanced`, `Password`, `Connect`,
  `No networks found`, `Connected — tap to disconnect`, `Secured`, `Open`.
- `BluetoothDialog`: `Refreshing…`, `Refresh`, `Advanced`, `Paired — tap to
  connect`, `Connected — tap to disconnect`, `No paired devices`, ghi chú ghép nối.
- `NightLightDialog`: `Intensity`, `Cool`, `Warm`, `Automatic`, `From`/`Until`,
  câu giải thích, `ON`/`OFF`.
- `VolumeMixerDialog`: `Refresh`, `Input`/`Output`, `No device`, `Switching…`,
  `App volumes`, `paused`, hai câu “không có gì đang phát/ghi”.
- `PowerMenu`: 8 nhãn pill dịch tại chỗ vẽ; `PowerBusyService.noteText(t)` cho
  câu cảnh báo “đang chạy (cài đặt/cập nhật/tải xuống)”, tên tiến trình giữ nguyên.
- `QuickPanel.qml`: mô tả phím tắt `Shell: Toggle search`.

Tên riêng không dịch: `Wi-Fi`, `Bluetooth`, `Ethernet`, `Easy Effects`,
`Cloudflare WARP`; tên thiết bị/SSID/tên ứng dụng trong thông báo là dữ liệu
bên ngoài, giữ nguyên.

Cụm 2b-2 (Apps/Launcher):

- `LauncherFace`: `Search apps`, `No apps match`.
- `LauncherExtras`: hàng hệ thống (`Search the web for “…”`, `Opens in your
  browser`), xác nhận hai lần Enter.
- `ExtrasSource`: hàng lệnh `>` / `$` (`Run a command`, `Runs in the
  background; …`).
- `Extras.js` `ACTIONS`: 20 hành động hệ thống (khóa, ngủ, khởi động lại, tắt
  máy, đăng xuất, quick panel, hình nền, chụp màn hình, hút màu, tắt tiếng
  loa/mic, chế độ tối/sáng, Wi-Fi, Bluetooth, xóa clipboard) — dịch tại chỗ vẽ,
  dữ liệu gốc giữ nguyên để tìm kiếm bằng tiếng Anh vẫn chạy.
- Thẻ Clipboard: tiêu đề, `Matching “…”`, `Copy`, `Loading…`, `Pick something
  above`, `Pinned ·`, `{n} characters · {m} line(s)`, thông báo thiếu
  cliphist/wl-clipboard.
- Thẻ Màu: gợi ý `Type a colour …`, tooltip `Pick from screen`.
- Thẻ Emoji: 9 nhóm + `Recent`, `Pick one`, `Enter copies · Shift types`.
- Thẻ Web: `Go to <b>…</b>`, `Search <b>…</b> for <b>…</b>`, câu hướng dẫn.
- `GallerySortCard`: `SORT BY`.
- Tên emoji (`grinning face`…) là dữ liệu trong `Emoji.js`, **giữ tiếng Anh**;
  tương tự tên ứng dụng, tên thiết bị, nội dung clipboard.

Cụm 2b-3 (Lockscreen):

- `LockCalendar` (bố cục đang dùng): chip `LOCKED`/`NAME`, `PASSWORD`,
  `CHECKING…`, `LOCKED SINCE …`, `UNLOCK`/`SLEEP`, dòng trạng thái nguồn
  (`RESTART`, `SHUT DOWN`, `PRESS AGAIN TO …`, `ENTER OR CLICK TO SLEEP`,
  `HOLD CTRL FOR SLEEP`).
- Lịch: thứ/ngày/tháng viết tắt tiếng Việt (`CN 15 THG 11`).
- `LockSurface` (bố cục kia): `Screen locked`, `Locked since …`, `Unlock`,
  `Enter`, ngày dài.
- `I18n.dateLong()` mới: `Thứ …, 15 tháng 11` khi ở tiếng Việt, trả lại
  `Qt.formatDate` khi ở tiếng Anh (Qt ở đây dùng locale C).
- Lỗi PAM (`Wrong password`, `Fingerprint not recognized`, quá số lần, lỗi
  PAM) dịch tại chỗ hiển thị; **thông điệp PAM thô vẫn tiếng Anh** (đầu ra hệ
  thống), tương tự lỗi git/terminal.

Cụm 2b-4 (Bar):

- Chỉ báo: `ActiveWindowKey` (`Workspace {n}`), `MediaPill` (`Nothing Playing`),
  `TrayCollection` (`Nothing here`), `KeyboardLayoutIndicator`, tooltip
  `ResourceIndicator` (`CPU {cpu}% · RAM {ram}%`), `BatteryIndicator`,
  `NotificationBadge` (`{n} notifications`, `· do not disturb`),
  `WeatherIndicator` (`Weather: {text}`), `DateIndicator` (`Calendar: {date}`).
- `Bar.qml`: tooltip Discord, `privacyDetail` (`Screen shared with: …`),
  `updatesTip`; `formatDate` chuyển sang `I18n.dateShort()`.
- `PackageUpdatesService.breakdownText(t)` cho câu “3 repo · 1 AUR”, các trạng
  thái `checking…`/`up to date`/lỗi; `repo`/`AUR` giữ nguyên.
- `CalendarMath.js`: thêm tham số `vi` cho `weekdayLabels`, `monthTitle`,
  `monthName`, `monthShort`, `weekdayShort/Long`, `relative`, `longDay`
  (`Tháng 11`, `Thg 11`, `T2`, `Ngày mai`, `5 ngày nữa`, `Thứ Sáu, 20 Thg 11`).
- `CalendarPopup`: `Tháng này/Tháng sau/Tháng trước`, `Week {n}`,
  `Last day of …`, `1 day left in …`, tên 5 kiểu sao (`Ngầu`, `Dễ thương`,
  `Vui`, `Bí ẩn`, `Thuần khiết`), chip `TODAY`.
- `BatteryPopup`: trạng thái pin (`Đang sạc`, `Đã đầy pin`, `Đang dùng pin`),
  `Thước pin`, `đến khi đầy`/`còn lại`, các câu ước tính, `Chế độ nguồn`
  (`Tiết kiệm`/`Cân bằng`/`Tăng tốc`). Hạng `GREAT`, `ALL PERFECT`… giữ tiếng
  Anh (thuật ngữ game).
- `WeatherPopup`: `Cảm giác như`, `Áp suất`, `Tầm nhìn`, `ĐỘ ẨM`, `GIÓ`,
  `CHỈ SỐ UV`, `Dự báo`, `Theo giờ`/`Theo ngày`, `Cập nhật {time}`; 30 mã thời
  tiết WMO (`Trời quang`, `Ít mây`, `Mưa rào`…) dịch tại chỗ hiển thị.
- `WeatherSource`: nhãn thứ trong dự báo theo ngôn ngữ (`T2`…), tên lỗi có
  `updatedTextFor(t)`/`problemTextFor(t)`; `updatedText` gốc vẫn tiếng Anh.
- `DiscordPill`/`DiscordPopup`/`DiscordMemberRow`: `Link Discord`,
  `{channel} — {n} in call`, `VOICE CONNECTED`, `{n} IN CALL`, `In the room`,
  `just you`, `{n} people`; tên kênh/người dùng là dữ liệu, giữ nguyên.
- `UtilKeys`/`UtilPopup`/`UtilButtons`: tên 8 phím tiện ích, `phím tiện ích`.

Cụm 2b-5 (Wallpapers):

- Khung chọn ảnh: `Hình nền`, `Thư mục của tôi`, `Màn hình chính`/`Màn hình khóa`,
  `Chỉ màn hình chính`/`Chỉ màn hình khóa`, `{shown}/{total} khớp`,
  `{n} hình nền`, `Tìm hình nền`, `Mới nhất`/`Cũ nhất`, `Lưới`/`Vòng`.
- Thư viện: `Trang {n}/{total}`, `Chưa có hình nền`,
  `Không có hình nền nào khớp “…”`, `Bỏ ảnh hoặc video vào …, hoặc chọn thư mục khác`.
- Trình xem: `Xem trước`, `Đặt làm hình nền`/`Đặt làm hình khóa`,
  `Đang đặt cho màn hình chính`/`… màn hình khóa`, `Đã lưu`, `Lưu vào thư mục`,
  `Đang tải · {done}/{total}`, các dòng ghi chú dưới hai phím, `Trước`/`Sau`.
- Wallhaven: bảng lọc (`DANH MỤC`, `HÌNH DẠNG`, `TỐI THIỂU`, `MÀU SẮC`,
  `Đặt lại bộ lọc`, `Áp dụng ngay khi chọn`), bảng sắp xếp
  (`SẮP XẾP WALLHAVEN THEO`, `Hàng đầu · {range}`, `cần từ khóa`), thẻ báo lỗi
  (`Wallhaven đang cần nghỉ một chút`, `Bạn đang ngoại tuyến`,
  `Wallhaven không phản hồi`, `Thử lại sau {time}`).
- `WallhavenMath.js`: `sortLabel`/`describe`/`filtersSentence` nhận thêm `t`
  tùy chọn; `WallhavenService.sortLabelFor(t)`/`descriptionFor(t)` để câu
  “Hàng đầu tháng này trên Wallhaven · từ 2560×1440 trở lên · ngang” đổi ngôn
  ngữ tại chỗ hiển thị.
- `I18n.t(s, vars, ctx)` có thêm ngữ cảnh cho từ đa nghĩa: `wallhaven:Top`
  (`Hàng đầu`, không phải `Trên`), `wallpaper:Desktop`, `calendar:Cool`,
  `notify:now`.

Cụm 2b-6 (Welcome tour):

- `WelcomeSlides.js` giữ dữ liệu tiếng Anh; `WelcomePage` dịch `title`, từng
  dòng `lines` của slide credits và `sub` tại chỗ hiển thị.
- Thanh góc: `SEKAIPOP · THAM QUAN CHÀO MỪNG`; gợi ý cuối trang
  (`NHẤN HOẶC BẤM ENTER ĐỂ KẾT THÚC`, `NHẤN HOẶC BẤM → ĐỂ TIẾP TỤC`,
  `ESC ĐỂ BỎ QUA`) qua `WelcomeMath.hintFor(index, count, t)`.
- Tên nhóm (`VS`, `L/N`, `MMJ`, `VBS`, `WxS`, `25:00`) và logo `Sekai`/`Pop`
  giữ nguyên.

Cụm 2b-7 (Keybinds panel + cheatsheet):

- `KeybindsPanel`: `PHÍM TẮT`, thanh chọn `Bàn phím`/`Danh sách`, ô tìm
  (`Tìm hành động, hoặc một phím như “super v”`), nút `Đặt phím`, `Xóa`,
  `Đặt lại`, `Hủy`, `Lấy phím này`, `Phím khác`, trạng thái ghi
  (`Bấm phím mới`, `Nhấn riêng Super, Alt hoặc Ctrl`), câu từ chối và câu hỏi
  trùng phím, phần setup niri/Hyprland, `Sao chép dòng`, `Đặt lại tất cả (… đã đổi)`.
- `KeybindsList`: tiêu đề `HÀNH ĐỘNG`/`PHÍM`, nhãn `đã đổi`, tooltip
  `Quay về {keys}`/`Quay về không phím`, trạng thái trống; tên action dịch tại
  chỗ hiển thị.
- `KeybindsBoard`: hai nhãn `MEDIA · MỌI LỚP` / `CHUỘT · THEO LỚP`; tên ngắn
  dưới phím qua ngữ cảnh `keybinds:*` (vd. `keybinds:Apps` → `Ứng dụng`).
- Tên 36 action trong `KeyBinds.js` dịch tại chỗ hiển thị; **4 nhóm
  Shell / Utilities / Media / Session và 8 mục cheatsheet vẫn tiếng Anh** (theo
  lựa chọn giữ thuật ngữ của người dùng). Tên phím (`Super`, `Ctrl`, `Bksp`…)
  và chữ `tap` giữ nguyên.
- Cheatsheet: `Tìm phím tắt`, chip `Chỉ mục cần thiết`/`+{n} nữa`,
  `{hit}/{total} phím tắt`, các câu trống (`Đang đọc phím tắt…`,
  `Không có gì khớp.`, `Không tìm thấy phím tắt…`), nhãn `TRÙNG!`.
- 61 câu mô tả từ `hyprctl -j binds` (`Brightness Up`, `Send to workspace #
  (1-10)`, `Terminal`…) dịch tại `CheatNote`; câu nào chưa có khóa thì giữ
  tiếng Anh. Tìm kiếm trong cheatsheet vẫn so với dữ liệu tiếng Anh.

Cụm 2b-8 (Notification popup + các popup còn lại của Bar):

- Thông báo do shell tự gửi nhận ra qua icon `material:<glyph>` (screenshot,
  ghi màn hình, timer, pin, cập nhật…). Chúng được dịch **lúc hiển thị** ở cả
  ba nơi vẽ: `NotificationPopupCard`, `NotificationCard` (list trong Quick
  Panel) và thẻ alert của `QuickPanelFace`. Nhờ vậy đổi ngôn ngữ runtime áp
  dụng cho cả thông báo cũ, và câu gửi từ script `.sh` lẫn QML đều dịch được.
- Thông báo từ ứng dụng ngoài (Firefox, Discord…) và thông báo có dữ liệu động
  (đường dẫn, log) không khớp khóa thì giữ nguyên tiếng Anh.
- Chuỗi có placeholder/nối động dịch **tại nơi gửi** để câu đã ghép sẵn đúng
  ngữ pháp:
  - `BatteryAlertMath.message(level, pct, time, t)` (fallback tiếng Anh khi
    test chạy dưới node); `BatteryAlertService` truyền `I18n.t`.
  - `PackageUpdatesService` (`{n} updates are waiting`), `PluginService`
    (`A plugin was not loaded` / `{n} plugins were not loaded`),
    `UpdateService` (số commit, `Version {v} is out.`, `{what} Open Settings →
    About…`), `TimerService` (`Timer finished`, `{time} is up`, `Focus done`,
    `Break over`, `Next: {phase}`), `ScrollOverviewService` (2 câu plugin,
    `hyprpm said: {log}`, gợi ý cài).
- Popup Bar: `ResourcePopup` (`CPU`, `RAM`, `Processor`, `Memory`, `of`),
  `TrayMenu` (`Back`, `Pin`/`Unpin`), `PluginPopup`
  (`{name}'s popup did not load`), `DiscordPopup` (`Mute`/`Muted`,
  `Deafen`/`Deafened`). `DiscordPill`/`DiscordMemberRow` dùng chung các khóa
  đã có (`You`, `Talking`, `In call`, `VOICE CONNECTED`…).
- Popup media (`mediaControls/MediaPopup`): `Nothing playing`,
  `Start a song or a video`, `PLAYING`/`PAUSED`/`IDLE`, `Pause`/`Play`.
- Equalizer (console cầm tay): nhãn preset, `AUTO`, `PRESETS`, `SAVE AS`,
  `NAME THIS CURVE`, `EASYEFFECTS PRESET`, `LAST.FM KEY (for AUTO)`,
  `10-BAND`, hai câu mô tả preset, placeholder ô nhập; `PRESET` giữ nguyên
  thuật ngữ, `EasyEffects`/`Last.fm` giữ tên riêng.
- `vi-shell.js` sau cụm này có 725 khóa, không trùng khóa trong cùng tệp.
- Lưu ý: câu dịch **tại nơi gửi** (timer, cập nhật, pin…) được lưu vào thông
  báo bằng tiếng Việt; đổi sang tiếng Anh sau đó không dịch ngược lại được
  (thông báo cũ vẫn là câu tiếng Việt cho tới khi bị xoá). Các câu chỉ dịch
  **lúc hiển thị** thì đổi ngôn ngữ runtime được.

Lưu ý: 100% ở trên là **trên các chuỗi mà script quét được**, không phải toàn bộ
shell.

---

## 6. Việc cần làm

### Giai đoạn 2a — chuỗi động trong Settings (đã xong)

- [x] `1 waiting` ở nút “Xóa tất cả” (General).
- [x] `SettingsGetPlugins`: trạng thái offline, số plugin, kết quả tìm kiếm.
- [x] `PluginListEntry`: tiến trình cài, `Needs SekaiPop …`, thông báo sau cài.
- [x] `PluginUpdateBox`: `Go back to …`.
- [x] `PluginSourcePanel`: `Nothing yet…`, trạng thái Pin, `Go back`.
- [x] `PluginEditor`, `PluginRemoveAsk`, `PluginSecretRow`, `PluginRow`.
- [x] `DisplayLayout` (`No screen is on`), `KeyCaps` (`or`).
- [x] About: `updateMessage`, `UpdateService.reason`.
- [x] `tools/progress.py --all` quét component plugin và dialog.

### Giai đoạn 2b — ngoài Settings

- [x] Quick Panel: tile, banner/avatar, thẻ thông báo, khay sửa, 4 dialog
      (Wi-Fi, Bluetooth, Night Light, Volume), power menu.
- [x] Apps/Launcher: ô tìm kiếm, hành động hệ thống, 5 thẻ phụ (máy tính,
      clipboard, màu, emoji, web).
- [x] Lockscreen: cả hai bố cục, lịch, dòng trạng thái nguồn, lỗi mật khẩu.
- [x] Bar: chỉ báo, tooltip, lịch, pin, thời tiết, Discord, phím tiện ích.
- [x] OSD (âm lượng, micrô, độ sáng, gamma), nhãn ghi màn hình.
- [x] Wallpaper picker: thư viện, trình xem, Wallhaven (lọc, sắp xếp, báo lỗi).
- [x] Welcome tour: 5 slide, thanh góc, gợi ý điều hướng.
- [x] Keybinds panel: board/list, ghi phím, hộp thoại trùng phím, setup; cheatsheet.
- [x] Notification popup, popup còn lại của Bar (media, equalizer, plugin).

Cụm 2b-9 — Dock (làm từng phần, tick khi xong phần đó; chờ test trước khi sang phần sau):

- [x] 2b-9a `Dock.qml`: menu chuột phải, flag (`click to open`, `Paused · click to open`, `release to remove`), tên tool trong `toolMeta` — `3d75082`, rút gọn nhãn cho vừa khung ở `ff50fe1`. Menu dịch tại `buildMenu`; flag và tên tool dịch tại chỗ. Ba khóa shelf (`Add what is on the clipboard`, `Copy everything on the shelf`, `Clear the shelf`) đã thêm sẵn cho 2b-9d.
- [ ] 2b-9b `DockTimerCard.qml`: tab Timer/Stopwatch/Pomodoro, nút điều khiển, `Lap`, footer Pomodoro.
- [ ] 2b-9c `DockClipboardCard.qml` + `Extras.imageLabel` (dùng chung với launcher).
- [ ] 2b-9d `DockShelfCard.qml` + `DockMediaCard.qml`.

Các cụm còn lại (sau Dock):

- [ ] `DockFilesCard` + `FilesStackService` (~30 khóa: Home/Trash, loại file, sắp xếp, lọc, xác nhận dọn Trash).
- [ ] `editMode` (~104 chuỗi): `EditGuides`, `PicturesRow`, `EditChrome`.
- [ ] `desktopWidgets` (~99 chuỗi): `StickyNote`, `LyricsWidget` và widget khác.
- [ ] Mảng còn lại: `palette`, `polkit`, `overview`, `regionSelector`, `framing`, `ScalePopup`.

Rà soát:

- [ ] Cân nhắc dịch `CHANGELOG.md` nếu người dùng muốn thẻ “Có gì mới” tiếng Việt.
- [ ] Rà layout tiếng Việt dài: wrap, elide, tràn thẻ, header.
- [ ] Kiểm thử chuyển ngôn ngữ runtime (Anh ↔ Việt) trên cả 6 trang.
- [ ] Kiểm thử `./switch.sh vi` / `en` / `log` sau mỗi cụm dịch.
- [ ] Bổ sung glossary khi gặp thuật ngữ mới.

### Giai đoạn 3 — mở rộng

- [ ] Dịch thông báo hệ thống/OSD còn lại.
- [ ] Dịch tài liệu dành cho người dùng (nếu cần).
- [ ] Cân nhắc lưu `i18n.lang` ra file riêng để bản gốc không xóa mất.

---

## 7. Glossary

| English | Tiếng Việt |
|---|---|
| Settings | Cài đặt |
| Wallpaper | Hình nền |
| Lockscreen | Màn hình khóa |
| Workspace | Không gian làm việc |
| Keybind / shortcut | Phím tắt |
| Launcher | Trình khởi chạy |
| File manager | Trình quản lý tệp |
| Theme | Giao diện |
| Palette | Bảng màu |
| Notification | Thông báo |
| Update | Cập nhật |
| Install | Cài đặt |
| Remove | Gỡ |
| Reload | Tải lại |
| Restart | Khởi động lại |
| Toggle | Bật/Tắt |
| ON / OFF | BẬT / TẮT |
| Screen | Màn hình |
| Display | Màn hình |
| Resolution | Độ phân giải |
| Refresh rate | Tần số quét |
| Scale | Tỉ lệ |
| Keybind layer | Lớp phím |
| Cheatsheet | Bảng phím tắt |
| Scratchpad | scratchpad (giữ nguyên) |
| Tap (a modifier) | nhấn riêng |

Giữ nguyên: Wi-Fi, Bluetooth, Hyprland, Quickshell, SekaiPop, Sekai Pad,
Discord, EasyEffects, Wallhaven, OCR, OSD, GTK, Qt, KDE, Matugen, Dock,
Widget, Plugin, Quick Panel, Popups, Game Mode (dịch là “Chế độ chơi game” khi
cần câu tiếng Việt).

Tên nhóm dịch vụ (Shell, Utilities, Media, Session, Windows, Workspaces, Apps,
Screen, Other) và 6 mục Settings (Quick, General, Bar, Desktop, Hyprland,
About) **giữ tiếng Anh**; câu mô tả và tên action bên trong vẫn dịch.

---

## 8. Quy trình dịch và commit

1. Đọc trang/component cần dịch, xác định chuỗi tĩnh.
2. Thêm khóa vào `vi-settings.js` hoặc `vi-common.js`.
3. Bọc chỗ hiển thị bằng `I18n.t(...)`; không đổi `label`/`title` gốc.
4. Chạy:
   ```sh
   python3 tools/progress.py
   python3 tools/progress.py --all
   python3 tools/progress.py --missing
   ```
5. Kiểm tra QML:
   ```sh
   qs log -c sekaipop | grep -iE 'error|is not a type|SyntaxError' | tail
   ```
6. Chuyển shell và xem trực quan:
   ```sh
   ./switch.sh vi
   ```
7. Commit theo cụm:
   ```sh
   git add -A
   git commit -m "i18n: Settings > <Tên trang>"
   ```

Commit hiện có:

```text
bcc6c47  base: SekaiPop 6fbf784, chưa Việt hóa
b0fffe1  i18n: hạ tầng, nút chuyển ngôn ngữ, lớp dịch component
ec790a3  i18n: Settings > General
1133ea1  i18n: Settings > Quick, Bar
6271da3  i18n: Settings > Desktop
200eeb0  i18n: Settings > About, thẻ Plugins và Get plugins
119f807  docs: TRANSLATION.md; switch.sh dùng symlink để phím tắt hoạt động
65849df  i18n: Settings > chuỗi động và hộp thoại plugin
d1a42ae  docs: ghi đúng commit cho cụm 2a
622541f  i18n: Quick Panel > tile, dialog, power menu
2e1701a  i18n: Apps/Launcher > tìm kiếm, hành động hệ thống, 5 thẻ phụ
be3a13e  i18n: Lockscreen > hai bố cục, lịch, lỗi mật khẩu
45a0c7a  i18n: Bar > chỉ báo, tooltip, lịch, pin, thời tiết, Discord
fafdc49  i18n: OSD > âm lượng, micrô, độ sáng, nhãn ghi màn hình
f2b7a81  i18n: Wallpapers > thư viện, trình xem, Wallhaven
642b65e  i18n: Welcome tour > 5 slide, gợi ý điều hướng
49551fa  i18n: giữ tiếng Anh cho menu Settings
9929c13  i18n: giữ tiếng Anh cho "Settings" và "General"
9fa9477  i18n: Keybinds panel và cheatsheet
39ce418  docs: ghi commit cho cụm Keybinds + cheatsheet
4ff7bf0  i18n: Notification popup và các popup còn lại của Bar
1c6efc7  docs: ghi cụm Notification popup + popup Bar
```
