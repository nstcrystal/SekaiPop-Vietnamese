pragma Singleton
import QtQuick
import qs.services
import "i18n/vi-common.js" as ViCommon
import "i18n/vi-settings.js" as ViSettings
import "i18n/vi-shell.js" as ViShell

// The shell's translation layer (Vietnamese). Every string shown on screen goes
// through `I18n.t("the original English")`: the English text itself is the
// dictionary key (gettext style), so nothing has to be numbered, a string with
// no translation simply stays English, and `grep` finds any of them.
//
//   text: I18n.t("Search settings")
//   detail: I18n.t("One dock, on {screen}", { screen: name })
//
// Only the DISPLAYED text is translated. The original `label` / `title` stays
// as it is, because other code reads it: SectionCard picks its icon from
// `title`, SettingsFace builds its search index from `label`, options keep
// their `id`. Translate where it is drawn, not where it is declared.
//
// The language lives in SettingsService ("i18n.lang", "vi" or "en"), so it is
// saved with the rest of the panel's options and every binding that calls t()
// follows it at once: Settings > General > Language.
QtObject {
    id: root

    // "vi" = translated, "en" = the shell as it shipped.
    readonly property string lang: SettingsService.get("i18n.lang") || "vi"
    readonly property bool vi: root.lang === "vi"

    // Both dictionaries merged once; settings wins on a duplicate key.
    readonly property var dict: Object.assign({}, ViCommon.dict, ViSettings.dict, ViShell.dict)

    function setLang(l) {
        if (l === "vi" || l === "en")
            SettingsService.set("i18n.lang", l)
    }


    function has(s) {
        return typeof s === "string" && root.dict[s] !== undefined
    }

    // Translate `s`, then fill {name} placeholders from `vars`. The fill also
    // happens when `s` stays English, so a function that is handed `I18n.t` (and
    // builds "{name} isn't installed" itself) reads correctly in both languages.
    //
    // `ctx` disambiguates a word that means two things in two places ("Cool" is
    // a night-light tint and a calendar star's name): the entry then lives under
    // "ctx:s" and there is no fallback to the plain word.
    function t(s, vars, ctx) {
        if (typeof s !== "string" || s === "")
            return s
        let out = ctx ? root.dict[ctx + ":" + s] : root.dict[s]
        if (!root.vi || out === undefined)
            out = s
        if (vars)
            for (const k in vars)
                out = out.split("{" + k + "}").join(String(vars[k]))
        return out
    }

    // Dates: Qt.formatDate uses the C locale here, so a long date would stay
    // English ("Sunday, November 15") in the Vietnamese shell. These helpers
    // keep both languages side by side.
    readonly property var viWeekdays: ["Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư",
        "Thứ Năm", "Thứ Sáu", "Thứ Bảy"]
    readonly property var viMonths: ["tháng 1", "tháng 2", "tháng 3", "tháng 4",
        "tháng 5", "tháng 6", "tháng 7", "tháng 8", "tháng 9", "tháng 10",
        "tháng 11", "tháng 12"]

    // "Chủ Nhật, 15 tháng 11" / "Sunday, November 15"
    function dateLong(d) {
        if (!root.vi || !(d instanceof Date))
            return Qt.formatDate(d, "dddd, MMMM d")
        return root.viWeekdays[d.getDay()] + ", " + d.getDate() + " " + root.viMonths[d.getMonth()]
    }

    readonly property var viWeekdaysShort: ["CN", "T2", "T3", "T4", "T5", "T6", "T7"]
    readonly property var viMonthsShort: ["Thg 1", "Thg 2", "Thg 3", "Thg 4",
        "Thg 5", "Thg 6", "Thg 7", "Thg 8", "Thg 9", "Thg 10", "Thg 11", "Thg 12"]

    // "CN, 15 Thg 11" / "Sun, Nov 15" — the bar's date pill.
    function dateShort(d) {
        if (!root.vi || !(d instanceof Date))
            return Qt.formatDate(d, "ddd, MMM d")
        return root.viWeekdaysShort[d.getDay()] + ", " + d.getDate() + " " + root.viMonthsShort[d.getMonth()]
    }

    // "15 Thg 11" / "15 Nov" — a file's date; the year only for older ones.
    function dateMedium(d, withYear) {
        if (!root.vi || !(d instanceof Date))
            return Qt.formatDate(d, withYear ? "d MMM yyyy" : "d MMM")
        const day = d.getDate() + " " + root.viMonthsShort[d.getMonth()]
        return withYear ? day + ", " + d.getFullYear() : day
    }

    // The standing bar splits the date into two lines: month over day.
    function datePill(d) {
        if (!root.vi || !(d instanceof Date))
            return { weekday: Qt.formatDate(d, "ddd"), month: Qt.formatDate(d, "MMM"), day: String(d.getDate()) }
        return { weekday: root.viWeekdaysShort[d.getDay()],
            month: root.viMonthsShort[d.getMonth()], day: String(d.getDate()) }
    }
}
