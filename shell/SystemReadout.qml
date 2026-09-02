// SystemReadout — CPU %, RAM %/usage, and uptime read from /proc via
// Quickshell.Io.Process.
//
// NOTE: written for quickshell 0.2.1 (the Fedora-packaged version):
//   - `command` is a LIST (program + args), not a string
//   - output is captured via `stdout: StdioCollector { onStreamFinished: ... }`
//   - the captured stream is available as `this.text`
import QtQuick
import Quickshell.Io

Item {
    id: root

    property int cpuPercent: 0
    property int ramPercent: 0
    property string ramText: "-- / -- MB"
    property string uptimeText: "--"

    property var prevTotal: 0
    property var prevIdle: 0

    // Re-run each sampler every 2 seconds
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
            upProc.running = true
        }
    }

    // ---- CPU: first line of /proc/stat ----
    Process {
        id: cpuProc
        command: ["sh", "-c", "head -n 1 /proc/stat"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.cpuSample(this.text)
        }
    }

    // ---- RAM: /proc/meminfo ----
    Process {
        id: memProc
        command: ["sh", "-c", "cat /proc/meminfo"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.memSample(this.text)
        }
    }

    // ---- Uptime: /proc/uptime (seconds) ----
    Process {
        id: upProc
        command: ["sh", "-c", "cat /proc/uptime"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.upSample(this.text)
        }
    }

    function cpuSample(text) {
        const parts = text.trim().split(/\s+/).map(Number);
        if (parts.length < 5) return;

        const idle = parts[4] + (parts[5] || 0);
        const total = parts.slice(1, 9).reduce((a, b) => a + b, 0);

        if (root.prevTotal > 0 && total > root.prevTotal) {
            const dTotal = total - root.prevTotal;
            const dIdle = idle - root.prevIdle;
            const pct = Math.round((1 - dIdle / dTotal) * 100);
            root.cpuPercent = Math.max(0, Math.min(100, pct));
        }

        root.prevTotal = total;
        root.prevIdle = idle;
    }

    function memSample(text) {
        const mem = {};
        text.split("\n").forEach(line => {
            const m = /^(\w+):\s+(\d+)/.exec(line);
            if (m) mem[m[1]] = parseInt(m[2], 10);
        });

        const total = mem.MemTotal || 0;
        const avail = mem.MemAvailable || mem.MemFree || 0;
        if (total > 0) {
            root.ramPercent = Math.round((1 - avail / total) * 100);
            root.ramText = Math.round((total - avail) / 1024) + " / "
                         + Math.round(total / 1024) + " MB";
        }
    }

    function upSample(text) {
        const secs = Math.floor(parseFloat(text.trim().split(/\s+/)[0]) || 0);
        const h = Math.floor(secs / 3600);
        const m = Math.floor((secs % 3600) / 60);
        root.uptimeText = h + "h" + String(m).padStart(2, "0") + "m";
    }
}
