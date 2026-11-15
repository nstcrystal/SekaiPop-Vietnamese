.pragma library

// Pure date math for CalendarPopup.qml — no QML, no Quickshell, so it can
// be checked on its own. Everything leans on JavaScript's own Date, which
// already knows month lengths and leap years (new Date(2026, 1, 29) is
// simply March 1st), so there are no month-length tables to get wrong.

// Sunday-first names; weekdayLabels() rotates them to the week's start.
var DAY_NAMES = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
var DAY_LONG = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

// firstDay: 1 = the week starts on Monday, 0 = on Sunday.
function weekdayLabels(firstDay, vi) {
    var out = [];
    var names = vi ? VI_DAY_NAMES : DAY_NAMES;
    for (var i = 0; i < 7; i++)
        out.push(names[(firstDay + i) % 7]);
    return out;
}

function pad2(n) {
    return (n < 10 ? "0" : "") + n;
}

// "2026-10-07" (month is 0-based, like Date). The key a marked day is
// remembered under.
function dayKey(y, m, d) {
    return y + "-" + pad2(m + 1) + "-" + pad2(d);
}

// The month `shift` months away from `today` (0 = this month), always
// pinned to the 1st so a shift from the 31st can never skip a month.
function monthStart(today, shift) {
    return new Date(today.getFullYear(), today.getMonth() + shift, 1);
}

// How many months to shift from `today` to land on (year, month).
function shiftFor(today, year, month) {
    return (year - today.getFullYear()) * 12 + (month - today.getMonth());
}

// The six-week grid (42 cells) for the month containing `viewDate`.
// Days that belong to the neighbouring months fill the gaps and are
// flagged inMonth: false, so the view can dim them. A fixed six rows
// means the popup never changes height while you page through months.
function monthGrid(viewDate, today, firstDay) {
    var y = viewDate.getFullYear();
    var m = viewDate.getMonth();
    var lead = (new Date(y, m, 1).getDay() - firstDay + 7) % 7;
    var cells = [];
    for (var i = 0; i < 42; i++) {
        var d = new Date(y, m, 1 - lead + i);
        var dow = d.getDay();
        cells.push({
            y: d.getFullYear(),
            m: d.getMonth(),
            d: d.getDate(),
            dow: dow,
            row: Math.floor(i / 7),
            col: i % 7,
            key: dayKey(d.getFullYear(), d.getMonth(), d.getDate()),
            day: d.getDate(),
            inMonth: d.getMonth() === m,
            isToday: d.getFullYear() === today.getFullYear()
                && d.getMonth() === today.getMonth()
                && d.getDate() === today.getDate(),
            isWeekend: dow === 0 || dow === 6
        });
    }
    return cells;
}

var MONTHS = ["January", "February", "March", "April", "May", "June", "July",
    "August", "September", "October", "November", "December"];

// Vietnamese names, used when the caller passes `vi` (I18n.vi). The short
// forms are the ones a Vietnamese calendar prints: "Thg 11", "T2", "CN".
var VI_DAY_NAMES = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"];
var VI_DAY_LONG = ["Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư",
    "Thứ Năm", "Thứ Sáu", "Thứ Bảy"];
var VI_MONTHS = ["Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5",
    "Tháng 6", "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11",
    "Tháng 12"];
var VI_MONTHS_SHORT = ["Thg 1", "Thg 2", "Thg 3", "Thg 4", "Thg 5", "Thg 6",
    "Thg 7", "Thg 8", "Thg 9", "Thg 10", "Thg 11", "Thg 12"];

function mod12(month) {
    return ((month % 12) + 12) % 12;
}

function monthTitle(viewDate, vi) {
    if (vi)
        return VI_MONTHS[viewDate.getMonth()] + " " + viewDate.getFullYear();
    return MONTHS[viewDate.getMonth()] + " " + viewDate.getFullYear();
}

function monthName(month, vi) {
    if (vi)
        return VI_MONTHS[mod12(month)];
    return MONTHS[mod12(month)];
}

function monthShort(month, vi) {
    if (vi)
        return VI_MONTHS_SHORT[mod12(month)];
    return monthName(month).slice(0, 3);
}

function weekdayShort(dow, vi) {
    if (vi)
        return VI_DAY_NAMES[dow];
    return DAY_LONG[dow].slice(0, 3);
}

function weekdayLong(dow, vi) {
    if (vi)
        return VI_DAY_LONG[dow];
    return DAY_LONG[dow];
}

function daysInMonth(y, m) {
    return new Date(y, m + 1, 0).getDate();
}

// Whole calendar days from `today` to (y, m, d): 0 = today, 1 = tomorrow,
// -1 = yesterday. Done in UTC so a daylight-saving change can't make a day
// 23 or 25 hours long.
function dayDiff(today, y, m, d) {
    var a = Date.UTC(today.getFullYear(), today.getMonth(), today.getDate());
    var b = Date.UTC(y, m, d);
    return Math.round((b - a) / 86400000);
}

// "Today", "Tomorrow", "in 16 days", "3 days ago", "in 9 weeks" ...
// Vietnamese has no plural, and puts the count after the noun.
function relative(diff, vi) {
    if (diff === 0) return vi ? "Hôm nay" : "Today";
    if (diff === 1) return vi ? "Ngày mai" : "Tomorrow";
    if (diff === -1) return vi ? "Hôm qua" : "Yesterday";
    var n = Math.abs(diff);
    var text;
    if (n < 21)
        text = n + (vi ? " ngày" : " days");
    else if (n < 120)
        text = Math.round(n / 7) + (vi ? " tuần" : " weeks");
    else
        text = Math.round(n / 30.44) + (vi ? " tháng" : " months");
    if (vi)
        return diff > 0 ? text + " nữa" : text + " trước";
    return diff > 0 ? "in " + text : text + " ago";
}

// ISO 8601 week number (weeks start on Monday, week 1 holds the first Thursday).
function isoWeek(y, m, d) {
    var date = new Date(Date.UTC(y, m, d));
    var dayNum = date.getUTCDay() || 7;
    date.setUTCDate(date.getUTCDate() + 4 - dayNum);
    var yearStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
    return Math.ceil(((date - yearStart) / 86400000 + 1) / 7);
}

// "Friday, 23 Oct" / "Thứ Sáu, 23 Thg 10"
function longDay(y, m, d, vi) {
    var dow = new Date(y, m, d).getDay();
    return weekdayLong(dow, vi) + ", " + d + " " + monthShort(m, vi);
}

// ===== marks =====

function parseMarks(text) {
    var out = {};
    if (!text)
        return out;
    var parts = String(text).split(",");
    for (var i = 0; i < parts.length; i++) {
        var m = /^(\d{4}-\d{2}-\d{2}):([1-5])$/.exec(parts[i]);
        if (m)
            out[m[1]] = parseInt(m[2], 10);
    }
    return out;
}

// Back to a string. Marks more than a year in the past are let go and the
// list is capped, so the settings file can never grow without end.
function serializeMarks(marks, today) {
    var keys = Object.keys(marks).filter(function (k) {
        if (!(marks[k] >= 1 && marks[k] <= 5))
            return false;
        var p = k.split("-");
        return dayDiff(today, parseInt(p[0], 10), parseInt(p[1], 10) - 1, parseInt(p[2], 10)) > -400;
    });
    keys.sort();
    if (keys.length > 300)
        keys = keys.slice(keys.length - 300);
    return keys.map(function (k) { return k + ":" + marks[k]; }).join(",");
}

// The "out-back" easing curve (a little overshoot), t in 0..1, so a whole
// grid of cells can pop on one shared clock instead of 42 animations.
function outBack(t, s) {
    if (t <= 0) return 0;
    if (t >= 1) return 1;
    var c = (s === undefined ? 1.8 : s);
    var u = t - 1;
    return 1 + (c + 1) * u * u * u + c * u * u;
}
