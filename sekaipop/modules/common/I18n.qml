pragma Singleton
import QtQuick
import qs.services
import "i18n/vi-common.js" as ViCommon
import "i18n/vi-settings.js" as ViSettings

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
    readonly property var dict: Object.assign({}, ViCommon.dict, ViSettings.dict)

    function setLang(l) {
        if (l === "vi" || l === "en")
            SettingsService.set("i18n.lang", l)
    }

    function has(s) {
        return typeof s === "string" && root.dict[s] !== undefined
    }

    // Translate `s`, then fill {name} placeholders from `vars`.
    function t(s, vars) {
        if (!root.vi || typeof s !== "string" || s === "")
            return s
        let out = root.dict[s]
        if (out === undefined)
            return s
        if (vars)
            for (const k in vars)
                out = out.split("{" + k + "}").join(String(vars[k]))
        return out
    }
}
