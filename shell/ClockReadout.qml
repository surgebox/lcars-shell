// ClockReadout — LCARS clock: big time + date + a (fake) stardate.
// Pure QML + JS Date, no external modules needed.
import QtQuick

Item {
    id: root

    property string time: "--:--:--"
    property string date: ""
    property string stardate: "SD ----.--"

    readonly property var dayNames: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    readonly property var monthNames: ["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                                       "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.update()
    }

    Component.onCompleted: root.update()

    function update() {
        const d = new Date();
        const p = n => String(n).padStart(2, "0");

        root.time = p(d.getHours()) + ":" + p(d.getMinutes()) + ":" + p(d.getSeconds());
        root.date = dayNames[d.getDay()] + " " + p(d.getDate()) + " "
                  + monthNames[d.getMonth()] + " " + d.getFullYear();

        // Fake stardate: SD 41000 at 2000-01-01, +10 units/year.
        const base = Date.UTC(2000, 0, 1);
        const sd = 41000 + (d.getTime() - base) / (365.25 * 24 * 3600 * 1000) * 10;
        root.stardate = "SD " + sd.toFixed(2);
    }

    // right-aligned column: time big, date + stardate small
    Column {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        LcarsLabel {
            anchors.right: parent.right
            text: root.time
            size: LcarsStyle.fontSizeLarge
            ink: LcarsStyle.fg
        }

        LcarsLabel {
            anchors.right: parent.right
            text: root.date + "   " + root.stardate
            size: LcarsStyle.fontSizeSmall
            spacing: 2
            ink: LcarsStyle.fgDim
        }
    }
}
