import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Item {
    id: root

    property var pluginApi: null

    property var blurEnabled: null
    property var blurPasses: null
    property var blurSize: null
    property var blurXray: null
    property var blurIgnoreOpacity: null
    property var blurNoise: null
    property var blurContrast: null
    property var blurBrightness: null
    property var blurVibrancy: null

    property var shadowEnabled: null
    property var shadowRange: null
    property var shadowPower: null
    property var shadowScale: null

    property var rounding: null
    property var activeOpacity: null
    property var inactiveOpacity: null
    property var fullscreenOpacity: null
    property var dimInactive: null
    property var dimStrength: null
    property var dimSpecial: null
    property var dimAround: null
    property var gapsIn: null
    property var gapsOut: null
    property var pendingApplyValues: ({})
    property int localGeneration: 0
    property int readGeneration: 0
    property bool refreshQueued: false
    property bool loaded: false
    property bool hasBaseline: false
    property var baselineValues: ({})
    property int readRequestSerial: 0
    property int activeReadSerial: 0
    property int queuedReadSerial: 0
    property bool queuedForceRefresh: false
    property bool resetQueued: false
    property int resetReadSerial: 0

    signal optionChanged(string key, var value)
    signal baselineChanged
    signal readCompleted(int serial)

    readonly property var optionKeys: ["decoration:blur:enabled", "decoration:blur:passes", "decoration:blur:size", "decoration:blur:xray", "decoration:blur:ignore_opacity", "decoration:blur:noise", "decoration:blur:contrast", "decoration:blur:brightness", "decoration:blur:vibrancy", "decoration:shadow:enabled", "decoration:shadow:range", "decoration:shadow:render_power", "decoration:shadow:scale", "decoration:rounding", "decoration:active_opacity", "decoration:inactive_opacity", "decoration:fullscreen_opacity", "decoration:dim_inactive", "decoration:dim_strength", "decoration:dim_special", "decoration:dim_around", "general:gaps_in", "general:gaps_out"]

    readonly property var optionProperties: ({
            "decoration:blur:enabled": "blurEnabled",
            "decoration:blur:passes": "blurPasses",
            "decoration:blur:size": "blurSize",
            "decoration:blur:xray": "blurXray",
            "decoration:blur:ignore_opacity": "blurIgnoreOpacity",
            "decoration:blur:noise": "blurNoise",
            "decoration:blur:contrast": "blurContrast",
            "decoration:blur:brightness": "blurBrightness",
            "decoration:blur:vibrancy": "blurVibrancy",
            "decoration:shadow:enabled": "shadowEnabled",
            "decoration:shadow:range": "shadowRange",
            "decoration:shadow:render_power": "shadowPower",
            "decoration:shadow:scale": "shadowScale",
            "decoration:rounding": "rounding",
            "decoration:active_opacity": "activeOpacity",
            "decoration:inactive_opacity": "inactiveOpacity",
            "decoration:fullscreen_opacity": "fullscreenOpacity",
            "decoration:dim_inactive": "dimInactive",
            "decoration:dim_strength": "dimStrength",
            "decoration:dim_special": "dimSpecial",
            "decoration:dim_around": "dimAround",
            "general:gaps_in": "gapsIn",
            "general:gaps_out": "gapsOut"
        })

    readonly property var boolOptions: ({
            "decoration:blur:enabled": true,
            "decoration:blur:xray": true,
            "decoration:blur:ignore_opacity": true,
            "decoration:shadow:enabled": true,
            "decoration:dim_inactive": true
        })

    IpcHandler {
        target: "plugin:hyprlandvisuals"

        function toggle() {
            if (root.pluginApi) {
                root.pluginApi.withCurrentScreen(screen => {
                    if (!root.loaded)
                        root.refresh();
                    root.pluginApi.togglePanel(screen);
                });
            }
        }

        function openPanel() {
            if (root.pluginApi) {
                root.pluginApi.withCurrentScreen(screen => {
                    if (!root.loaded)
                        root.refresh();
                    root.pluginApi.openPanel(screen);
                });
            }
        }

        function reset() {
            root.resetDefaults();
        }
    }

    function numeric(value) {
        const parsed = Number(value);
        return Number.isFinite(parsed) ? parsed : null;
    }

    function boolValue(value) {
        if (value === undefined || value === null || value === "")
            return null;
        return Number(value) !== 0;
    }

    function copyValues(values) {
        const copy = {};
        for (const key in values)
            copy[key] = values[key];
        return copy;
    }

    function commandValue(value) {
        if (value === true)
            return true;
        if (value === false)
            return false;
        return value;
    }

    function runtimeOptionKey(key) {
        return String(key).replace(/:/g, ".");
    }

    function luaKey(name) {
        return /^[A-Za-z_][A-Za-z0-9_]*$/.test(name) ? name : JSON.stringify(name);
    }

    function luaValue(value) {
        if (value === true)
            return "true";
        if (value === false)
            return "false";
        const parsed = numeric(value);
        return parsed !== null ? String(parsed) : JSON.stringify(String(value));
    }

    function shellQuote(value) {
        return "'" + String(value).replace(/'/g, "'\"'\"'") + "'";
    }

    function normalizeConfigValue(key, value) {
        const trimmed = String(value).trim();
        const lowered = trimmed.toLowerCase();
        if (boolOptions[key]) {
            if (lowered === "true" || lowered === "on" || lowered === "yes")
                return true;
            if (lowered === "false" || lowered === "off" || lowered === "no")
                return false;
        }
        return numeric(trimmed);
    }

    function optionValue(key) {
        const propertyName = optionProperties[key];
        return propertyName ? root[propertyName] : null;
    }

    function baselineValue(key) {
        return hasBaseline ? baselineValues[key] : undefined;
    }

    function setLocalOption(key, value) {
        const propertyName = optionProperties[key];
        if (!propertyName)
            return;

        localGeneration += 1;
        root[propertyName] = boolOptions[key] ? boolValue(value) : numeric(value);
        root.optionChanged(key, root[propertyName]);
    }

    function refreshForPanelOpen() {
        loadConfigBaseline();
        return refreshRuntime();
    }

    function refreshRuntime() {
        readRequestSerial += 1;
        refresh(true, readRequestSerial);
        return readRequestSerial;
    }

    function refresh(force, serial) {
        const readSerial = serial || 0;

        if (loaded && !force) {
            if (readSerial !== 0)
                readCompleted(readSerial);
            return;
        }

        if (applyProcess.running || hasPendingApply()) {
            refreshQueued = true;
            queuedForceRefresh = force === true;
            queuedReadSerial = readSerial;
            return;
        }

        if (readProcess.running) {
            refreshQueued = true;
            queuedForceRefresh = force === true;
            queuedReadSerial = readSerial;
            return;
        }

        activeReadSerial = readSerial;
        readGeneration = localGeneration;
        readProcess.command = ["hyprctl", "--batch", readRuntimeBatch()];
        readProcess.running = true;
    }

    function readRuntimeBatch() {
        const commands = [];
        for (let i = 0; i < optionKeys.length; i++)
            commands.push("getoption " + runtimeOptionKey(optionKeys[i]));
        return commands.join("; ");
    }

    function parseValues(text) {
        const parts = optionValuesFromOutput(text);
        if (parts.length < optionKeys.length)
            return;

        const values = {};
        for (let i = 0; i < optionKeys.length; i++) {
            const key = optionKeys[i];
            values[key] = boolOptions[key] ? boolValue(parts[i]) : numeric(parts[i]);
            const propertyName = optionProperties[key];
            if (propertyName) {
                root[propertyName] = values[key];
                root.optionChanged(key, values[key]);
            }
        }

        loaded = true;
    }

    function optionValuesFromOutput(text) {
        const values = [];
        const lines = String(text).split("\n");

        for (let i = 0; i < lines.length && values.length < optionKeys.length; i++) {
            const line = lines[i].trim();
            if (line === "" || line.indexOf("set:") === 0)
                continue;
            values.push(lastOptionToken(line));
        }

        return values;
    }

    function lastOptionToken(line) {
        const fields = String(line).trim().split(/\s+/);
        for (let i = fields.length - 1; i >= 0; i--) {
            const lowered = fields[i].toLowerCase();
            if (lowered === "true" || lowered === "false" || lowered === "on" || lowered === "off" || lowered === "yes" || lowered === "no")
                return fields[i];
            const value = numeric(fields[i]);
            if (value !== null)
                return fields[i];
        }
        return "";
    }

    function lastNumericToken(line) {
        const fields = String(line).trim().split(/\s+/);
        for (let i = fields.length - 1; i >= 0; i--) {
            const value = numeric(fields[i]);
            if (value !== null)
                return fields[i];
        }
        return "";
    }

    function applyOption(key, value) {
        setLocalOption(key, value);
        applyScript(`${key} ${commandValue(value)}`);
    }

    function applyMany(values, replacePending) {
        const commands = [];
        for (const key in values) {
            if (values[key] === undefined || values[key] === null)
                continue;
            setLocalOption(key, values[key]);
            commands.push(`${key} ${commandValue(values[key])}`);
        }
        applyScript(commands.join("\n"), replacePending);
    }

    function applyScript(lines, replacePending) {
        const values = applyValuesFromLines(lines);
        const command = applyCommandFromValues(values);
        if (command === "")
            return;

        if (applyProcess.running) {
            queuePendingApply(values, replacePending);
            return;
        }

        applyProcess.command = ["sh", "-c", command];
        applyProcess.running = true;
    }

    function hasPendingApply() {
        for (const key in pendingApplyValues)
            return true;
        return false;
    }

    function applyValuesFromLines(lines) {
        const values = {};
        String(lines).split("\n").forEach(line => {
            const trimmed = String(line).trim();
            if (trimmed === "")
                return;

            const separator = trimmed.indexOf(" ");
            if (separator === -1)
                return;

            values[trimmed.slice(0, separator)] = trimmed.slice(separator + 1).trim();
        });
        return values;
    }

    function applyCommandFromValues(values) {
        const table = {};

        function assign(key, value) {
            const parts = String(key).split(":");
            let cursor = table;
            for (let i = 0; i < parts.length - 1; i++) {
                const part = parts[i];
                if (cursor[part] === undefined)
                    cursor[part] = {};
                cursor = cursor[part];
            }
            cursor[parts[parts.length - 1]] = commandValue(value);
        }

        optionKeys.forEach(key => {
            if (values[key] !== undefined && values[key] !== null)
                assign(key, values[key]);
        });

        for (const key in values) {
            if (values[key] !== undefined && values[key] !== null)
                assign(key, values[key]);
        }

        const luaTable = luaTableFromObject(table);
        return luaTable === "{}" ? "" : "hyprctl eval " + shellQuote("hl.config(" + luaTable + ")");
    }

    function luaTableFromObject(object) {
        const parts = [];
        for (const key in object) {
            const value = object[key];
            if (value && typeof value === "object" && !Array.isArray(value))
                parts.push(luaKey(key) + " = " + luaTableFromObject(value));
            else
                parts.push(luaKey(key) + " = " + luaValue(value));
        }
        if (parts.length === 0)
            return "{}";
        return "{ " + parts.join(", ") + " }";
    }

    function queuePendingApply(values, replacePending) {
        const pending = replacePending ? {} : copyValues(pendingApplyValues);
        for (const key in values)
            pending[key] = values[key];
        pendingApplyValues = pending;
    }

    function takePendingApplyCommand() {
        const command = applyCommandFromValues(pendingApplyValues);
        pendingApplyValues = ({});
        return command;
    }

    function drainQueuedRefresh() {
        if (!refreshQueued)
            return;

        const force = queuedForceRefresh;
        const serial = queuedReadSerial;
        refreshQueued = false;
        queuedForceRefresh = false;
        queuedReadSerial = 0;
        refresh(force, serial);
    }

    function resetDefaults() {
        if (applyProcess.running || hasPendingApply()) {
            pendingApplyValues = ({});
            resetQueued = true;
            return;
        }

        if (configResetProcess.running || reloadProcess.running) {
            resetQueued = true;
            return;
        }

        pendingApplyValues = ({});
        configResetProcess.command = ["sh", "-c", "cat \"${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.lua\" 2>/dev/null || cat \"${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.conf\""];
        configResetProcess.running = true;
    }

    function loadConfigBaseline() {
        if (configBaselineProcess.running)
            return;

        configBaselineProcess.command = ["sh", "-c", "cat \"${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.lua\" 2>/dev/null || cat \"${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.conf\""];
        configBaselineProcess.running = true;
    }

    function parseConfiguredValues(text) {
        const configured = {};
        const stack = [];
        const tracked = {};

        for (let i = 0; i < optionKeys.length; i++)
            tracked[optionKeys[i]] = true;

        const lines = String(text).split("\n");
        for (let i = 0; i < lines.length; i++) {
            let line = lines[i].replace(/#.*/, "").replace(/--.*/, "").trim();
            if (line === "")
                continue;

            while (line.startsWith("}")) {
                stack.pop();
                line = line.slice(1).replace(/^,/, "").trim();
            }

            if (line === "")
                continue;

            if (line.match(/^hl\.[A-Za-z0-9_]+\(\{\s*$/))
                continue;

            if (line.startsWith("})") || line.startsWith(")"))
                continue;

            const luaTable = line.match(/^(?:\["([^"]+)"\]|([A-Za-z0-9_]+))\s*=\s*\{\s*,?$/);
            if (luaTable) {
                stack.push(luaTable[1] || luaTable[2]);
                continue;
            }

            if (line.endsWith("{")) {
                const name = line.slice(0, -1).replace(/=$/, "").trim();
                if (name !== "")
                    stack.push(name);
                continue;
            }

            const equals = line.indexOf("=");
            if (equals === -1)
                continue;

            let name = line.slice(0, equals).trim();
            const value = line.slice(equals + 1).replace(/,$/, "").trim();
            if (name === "" || value === "")
                continue;
            const quotedName = name.match(/^\["([^"]+)"\]$/);
            if (quotedName)
                name = quotedName[1];

            const fullKey = stack.concat([name]).join(":");
            if (tracked[fullKey])
                configured[fullKey] = normalizeConfigValue(fullKey, value);
        }

        return configured;
    }

    Process {
        id: readProcess
        command: []
        running: false
        stdout: StdioCollector {}
        stderr: StdioCollector {}

        onExited: function (exitCode) {
            if (exitCode === 0) {
                if (root.readGeneration === root.localGeneration)
                    root.parseValues(stdout.text);
                if (root.activeReadSerial !== 0)
                    root.readCompleted(root.activeReadSerial);
                if (root.activeReadSerial !== 0 && root.activeReadSerial === root.resetReadSerial)
                    root.resetReadSerial = 0;
            } else {
                Logger.e("hyprland-visuals", "Failed to read Hyprland visual settings:", stderr.text);
            }

            root.activeReadSerial = 0;
            root.drainQueuedRefresh();
        }
    }

    Process {
        id: applyProcess
        command: []
        running: false
        stdout: StdioCollector {}
        stderr: StdioCollector {}

        onExited: function (exitCode) {
            if (exitCode !== 0) {
                Logger.e("hyprland-visuals", "Failed to apply Hyprland visual settings:", stderr.text);
            } else if (root.hasPendingApply()) {
                const command = root.takePendingApplyCommand();
                applyProcess.command = ["sh", "-c", command];
                applyProcess.running = true;
                return;
            }

            if (root.resetQueued) {
                root.resetQueued = false;
                root.resetDefaults();
                return;
            }

            root.drainQueuedRefresh();
        }
    }

    Process {
        id: configResetProcess
        command: []
        running: false
        stdout: StdioCollector {}
        stderr: StdioCollector {}

        onExited: function (exitCode) {
            if (exitCode !== 0) {
                Logger.e("hyprland-visuals", "Failed to read Hyprland config for reset:", stderr.text);
            } else {
                const configured = root.parseConfiguredValues(stdout.text);
                root.baselineValues = root.copyValues(configured);
                root.hasBaseline = true;
                root.baselineChanged();
                root.loaded = false;
                reloadProcess.command = ["sh", "-c", "hyprctl reload"];
                reloadProcess.running = true;
            }

            if (root.resetQueued) {
                root.resetQueued = false;
                root.resetDefaults();
            }
        }
    }

    Process {
        id: reloadProcess
        command: []
        running: false
        stdout: StdioCollector {}
        stderr: StdioCollector {}

        onExited: function (exitCode) {
            if (exitCode !== 0) {
                Logger.e("hyprland-visuals", "Failed to reload Hyprland config:", stderr.text);
                return;
            }

            root.loaded = false;
            root.resetReadSerial = root.refreshRuntime();
        }
    }

    Process {
        id: configBaselineProcess
        command: []
        running: false
        stdout: StdioCollector {}
        stderr: StdioCollector {}

        onExited: function (exitCode) {
            if (exitCode !== 0) {
                Logger.e("hyprland-visuals", "Failed to read Hyprland config baseline:", stderr.text);
                return;
            }

            root.baselineValues = root.copyValues(root.parseConfiguredValues(stdout.text));
            root.hasBaseline = true;
            root.baselineChanged();
        }
    }
}
