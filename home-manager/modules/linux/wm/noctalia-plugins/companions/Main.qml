import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Services.System

Scope {
    id: root

    property var pluginApi: null

    property int settingsVersion: 0

    readonly property var pluginSettings: pluginApi?.pluginSettings
    readonly property var defaultSettings: pluginApi?.manifest?.metadata?.defaultSettings
    readonly property real scaleFactor: root.boundedNumber(settingsVersion, pluginSettings?.scaleFactor ?? defaultSettings?.scaleFactor, 1.0, 0.6, 2.0)
    readonly property string companionLanguage: root.settingValue(settingsVersion, pluginSettings?.language, defaultSettings?.language, "en")
    readonly property string corner: root.validCorner(settingsVersion, pluginSettings?.corner ?? defaultSettings?.corner, "bottomLeft")
    readonly property bool showOnAllDisplays: root.settingValue(settingsVersion, pluginSettings?.showOnAllDisplays, defaultSettings?.showOnAllDisplays, false)
    readonly property bool useSystemFont: root.settingValue(settingsVersion, pluginSettings?.useSystemFont, defaultSettings?.useSystemFont, false)
    readonly property int spriteSize: Math.round(128 * scaleFactor)
    readonly property int screenMargin: 20
    property bool companionsVisible: true
    property int lastPopupCount: 0

    signal notificationLine(string text)

    Connections {
        target: NotificationService.popupModel

        function onCountChanged() {
            var count = NotificationService.popupModel.count;
            if (count > root.lastPopupCount && count > 0) {
                var notification = NotificationService.popupModel.get(0);
                var app = notification.appName || "Notification";
                var summary = notification.summary || "";
                var body = notification.body || "";
                var text = app + ": " + summary;
                if (body !== "")
                    text += " - " + body;
                root.notificationLine(text);
            }
            root.lastPopupCount = count;
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            anchors.top: root.corner === "topLeft" || root.corner === "topRight"
            anchors.bottom: root.corner === "bottomLeft" || root.corner === "bottomRight"
            anchors.left: root.corner === "topLeft" || root.corner === "bottomLeft"
            anchors.right: root.corner === "topRight" || root.corner === "bottomRight"
            margins.top: root.screenMargin
            margins.bottom: root.screenMargin
            margins.left: root.screenMargin
            margins.right: root.screenMargin
            exclusionMode: ExclusionMode.Ignore
            color: "transparent"
            implicitWidth: root.spriteSize + 58
            implicitHeight: companion.implicitHeight
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            WlrLayershell.namespace: "noctalia-plugin-companions-" + (screen?.name || "unknown")
            visible: root.companionsVisible && (root.showOnAllDisplays || modelData.name === Quickshell.screens[0]?.name)

            Companions {
                id: companion
                anchors.fill: parent
                spriteSize: root.spriteSize
                language: root.companionLanguage
                useSystemFont: root.useSystemFont
            }

            Connections {
                target: root
                function onNotificationLine(text) {
                    companion.showExternalLine(text);
                }
            }
        }
    }

    CompanionIPC {
        controller: root
    }

    function toggleCompanions() {
        root.companionsVisible = !root.companionsVisible;
        return root.companionsVisible;
    }

    function showCompanions() {
        root.companionsVisible = true;
        return true;
    }

    function hideCompanions() {
        root.companionsVisible = false;
        return false;
    }

    function settingValue(version, value, defaultValue, fallback) {
        return value ?? defaultValue ?? fallback;
    }

    function boundedNumber(version, value, fallback, min, max) {
        const parsed = Number(value);
        if (!Number.isFinite(parsed))
            return fallback;
        return Math.max(min, Math.min(max, parsed));
    }

    function validCorner(version, value, fallback) {
        const corners = ["topLeft", "topRight", "bottomLeft", "bottomRight"];
        return corners.indexOf(value) >= 0 ? value : fallback;
    }
}
