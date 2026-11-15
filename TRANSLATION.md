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
| Chuỗi động trong Settings | ~160 khóa | 100% | `2a` |
| Ngoài Settings | — | 0% | — |

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

- [ ] Quick Panel, Apps/Launcher, Lockscreen, Wallpaper picker, Welcome, OSD,
      notification, cheatsheet, keybinds panel.
- [ ] Các màn hình dùng chung (`SegmentSwitch` đã xong; còn popup của Bar).
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

Giữ nguyên: Wi-Fi, Bluetooth, Hyprland, Quickshell, SekaiPop, Sekai Pad,
Discord, EasyEffects, Wallhaven, OCR, OSD, GTK, Qt, KDE, Matugen, Dock,
Widget, Plugin, Quick Panel, Popups, Game Mode (dịch là “Chế độ chơi game” khi
cần câu tiếng Việt).

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
```
