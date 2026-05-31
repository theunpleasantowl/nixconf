import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
    id: root

    property var pluginApi: null
    property real editScaleFactor: 1.0
    property string editLanguage: "en"
    property string editCorner: "bottomLeft"
    property bool editShowOnAllDisplays: false
    property bool editUseSystemFont: false

    spacing: Style.marginM

    readonly property var languageModel: [
        {
            key: "en",
            name: "English"
        },
        {
            key: "pt",
            name: "Portuguese"
        },
        {
            key: "ja",
            name: "Japanese"
        }
    ]

    readonly property var cornerModel: [
        {
            key: "topLeft",
            name: "Top left"
        },
        {
            key: "topRight",
            name: "Top right"
        },
        {
            key: "bottomLeft",
            name: "Bottom left"
        },
        {
            key: "bottomRight",
            name: "Bottom right"
        }
    ]

    onPluginApiChanged: loadSettings()
    Component.onCompleted: loadSettings()

    function defaults() {
        return pluginApi?.manifest?.metadata?.defaultSettings;
    }

    function settings() {
        return pluginApi?.pluginSettings;
    }

    function loadSettings() {
        if (!pluginApi)
            return;
        const s = settings();
        const d = defaults();
        editScaleFactor = boundedNumber(s?.scaleFactor ?? d?.scaleFactor, 1.0, 0.6, 2.0);
        editLanguage = s?.language ?? d?.language ?? "en";
        editCorner = validCorner(s?.corner ?? d?.corner, "bottomLeft");
        editShowOnAllDisplays = s?.showOnAllDisplays ?? d?.showOnAllDisplays ?? false;
        editUseSystemFont = s?.useSystemFont ?? d?.useSystemFont ?? false;
    }

    NValueSlider {
        Layout.fillWidth: true
        label: "Scale factor"
        description: "Adjust the companion sprite and layout size"
        from: 0.6
        to: 2.0
        stepSize: 0.1
        value: root.editScaleFactor
        text: root.editScaleFactor.toFixed(1) + "x"
        defaultValue: root.defaults()?.scaleFactor ?? 1.0
        showReset: true
        onMoved: value => root.editScaleFactor = Number(value.toFixed(1))
    }

    NComboBox {
        Layout.fillWidth: true
        label: "Language"
        description: "Choose the companion dialogue language"
        model: root.languageModel
        currentKey: root.editLanguage
        defaultValue: root.defaults()?.language ?? "en"
        onSelected: key => root.editLanguage = key
    }

    NComboBox {
        Layout.fillWidth: true
        label: "Screen corner"
        description: "Choose where the companions appear"
        model: root.cornerModel
        currentKey: root.editCorner
        defaultValue: root.defaults()?.corner ?? "bottomLeft"
        onSelected: key => root.editCorner = key
    }

    NToggle {
        Layout.fillWidth: true
        label: "Show on all displays"
        description: "Show companions on every monitor instead of only the primary display"
        checked: root.editShowOnAllDisplays
        defaultValue: root.defaults()?.showOnAllDisplays ?? false
        onToggled: checked => root.editShowOnAllDisplays = checked
    }

    NCheckbox {
        Layout.fillWidth: true
        label: "Use System Font"
        description: "Use Noctalia shell's configured font family and scale"
        checked: root.editUseSystemFont
        onToggled: checked => root.editUseSystemFont = checked
    }

    function saveSettings() {
        if (!pluginApi) {
            Logger.e("Companions", "Cannot save settings: pluginApi is null");
            return;
        }

        pluginApi.pluginSettings.scaleFactor = root.editScaleFactor;
        pluginApi.pluginSettings.language = root.editLanguage;
        pluginApi.pluginSettings.corner = root.editCorner;
        pluginApi.pluginSettings.showOnAllDisplays = root.editShowOnAllDisplays;
        pluginApi.pluginSettings.useSystemFont = root.editUseSystemFont;
        pluginApi.saveSettings();

        if (pluginApi.mainInstance)
            pluginApi.mainInstance.settingsVersion++;
    }

    function boundedNumber(value, fallback, min, max) {
        const parsed = Number(value);
        if (!Number.isFinite(parsed))
            return fallback;
        return Math.max(min, Math.min(max, parsed));
    }

    function validCorner(value, fallback) {
        for (let i = 0; i < cornerModel.length; i++) {
            if (cornerModel[i].key === value)
                return value;
        }
        return fallback;
    }
}
