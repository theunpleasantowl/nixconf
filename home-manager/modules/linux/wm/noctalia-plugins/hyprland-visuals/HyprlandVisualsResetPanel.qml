import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

Item {
    id: root

    property var pluginApi: null
    readonly property var mainInstance: pluginApi?.mainInstance
    readonly property var geometryPlaceholder: panelContainer
    readonly property bool allowAttach: true

    property real contentPreferredWidth: 460 * Style.uiScaleRatio
    property real contentPreferredHeight: 720 * Style.uiScaleRatio
    property int initialReadSerial: 0
    property bool initialReadComplete: false

    onMainInstanceChanged: {
        if (!initialReadComplete && initialReadSerial === 0)
            requestInitialState();
    }

    Component.onCompleted: requestInitialState()

    Connections {
        target: root.mainInstance

        function onReadCompleted(serial) {
            if (serial === root.initialReadSerial)
                root.initialReadComplete = true;
        }
    }

    function requestInitialState() {
        if (!mainInstance)
            return;

        initialReadComplete = false;

        if (mainInstance.refreshForPanelOpen) {
            initialReadSerial = mainInstance.refreshForPanelOpen();
            return;
        }

        initialReadSerial = 0;
        mainInstance.refresh();
        initialReadComplete = true;
    }

    function setOption(key, value) {
        if (mainInstance)
            mainInstance.applyOption(key, value);
    }

    function setBool(key, value) {
        setOption(key, value ? 1 : 0);
    }

    function rawOptionValue(key) {
        return mainInstance?.optionValue(key);
    }

    function baselineValue(key) {
        return mainInstance?.baselineValue(key);
    }

    Rectangle {
        id: panelContainer
        anchors.fill: parent
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.marginM
            spacing: Style.marginM

            NBox {
                Layout.fillWidth: true
                Layout.preferredHeight: headerRow.implicitHeight + Style.marginM * 2

                RowLayout {
                    id: headerRow
                    anchors.fill: parent
                    anchors.margins: Style.marginM
                    spacing: Style.marginS

                    NIcon {
                        icon: "sparkles"
                        color: Color.mPrimary
                        pointSize: Style.fontSizeL
                    }

                    NText {
                        Layout.fillWidth: true
                        text: "Hyprland Visuals"
                        font.weight: Style.fontWeightBold
                        pointSize: Style.fontSizeL
                        color: Color.mOnSurface
                    }

                    NIconButton {
                        icon: "refresh"
                        tooltipText: "Refresh"
                        baseSize: Style.baseWidgetSize * 0.8
                        onClicked: mainInstance?.refresh(true)
                    }

                    NIconButton {
                        icon: "restore"
                        tooltipText: "Reset"
                        baseSize: Style.baseWidgetSize * 0.8
                        onClicked: mainInstance?.resetDefaults()
                    }

                    NIconButton {
                        icon: "x"
                        tooltipText: "Close"
                        baseSize: Style.baseWidgetSize * 0.8
                        onClicked: pluginApi?.closePanel(pluginApi.panelOpenScreen)
                    }
                }
            }

            NScrollView {
                id: scrollView
                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalPolicy: ScrollBar.AlwaysOff
                verticalPolicy: ScrollBar.AsNeeded

                ColumnLayout {
                    width: scrollView.availableWidth
                    spacing: Style.marginM

                    SettingsBox {
                        title: "Blur"
                        icon: "sparkles"

                        ToggleControl {
                            optionKey: "decoration:blur:enabled"
                            label: "Enabled"
                            description: "Enable Hyprland window blur."
                        }

                        IntSlider {
                            optionKey: "decoration:blur:passes"
                            label: "Passes"
                            description: "More passes increase blur depth and GPU cost."
                            from: 0
                            to: 8
                        }

                        IntSlider {
                            optionKey: "decoration:blur:size"
                            label: "Intensity"
                            description: "Hyprland blur size."
                            from: 0
                            to: 24
                        }

                        ToggleControl {
                            optionKey: "decoration:blur:xray"
                            label: "X-ray"
                            description: "Blur through floating and tiled windows."
                        }

                        ToggleControl {
                            optionKey: "decoration:blur:ignore_opacity"
                            label: "Ignore opacity"
                            description: "Blur ignores window opacity when compositing."
                        }

                        RealSlider {
                            optionKey: "decoration:blur:noise"
                            label: "Noise"
                            description: "Adds grain to blur to reduce banding."
                            to: 0.1
                            stepSize: 0.005
                            decimals: 3
                        }

                        RealSlider {
                            optionKey: "decoration:blur:contrast"
                            label: "Contrast"
                            description: "Adjusts blurred background contrast."
                            from: 0.5
                            to: 2.0
                            stepSize: 0.05
                        }

                        RealSlider {
                            optionKey: "decoration:blur:brightness"
                            label: "Brightness"
                            description: "Adjusts blurred background brightness."
                            from: 0.2
                            to: 1.5
                            stepSize: 0.05
                        }

                        RealSlider {
                            optionKey: "decoration:blur:vibrancy"
                            label: "Vibrancy"
                            description: "Saturates blurred backgrounds."
                            from: 0.0
                            to: 1.0
                            stepSize: 0.05
                        }
                    }

                    SettingsBox {
                        title: "Shadows"
                        icon: "moon"

                        ToggleControl {
                            optionKey: "decoration:shadow:enabled"
                            label: "Enabled"
                            description: "Enable drop shadows around windows."
                        }

                        IntSlider {
                            optionKey: "decoration:shadow:range"
                            label: "Range"
                            description: "Shadow spread in pixels."
                            from: 0
                            to: 30
                        }

                        IntSlider {
                            optionKey: "decoration:shadow:render_power"
                            label: "Render power"
                            description: "Higher values make shadows softer."
                            from: 1
                            to: 8
                        }

                        RealSlider {
                            optionKey: "decoration:shadow:scale"
                            label: "Scale"
                            description: "Scales the rendered shadow."
                            from: 0.5
                            to: 2.0
                            stepSize: 0.05
                        }
                    }

                    SettingsBox {
                        title: "Windows"
                        icon: "settings"

                        IntSlider {
                            optionKey: "decoration:rounding"
                            label: "Corner radius"
                            description: "Window rounding."
                            from: 0
                            to: 24
                        }

                        RealSlider {
                            optionKey: "decoration:active_opacity"
                            label: "Active opacity"
                            description: "Opacity for the focused window."
                            from: 0.2
                            to: 1.0
                            stepSize: 0.05
                        }

                        RealSlider {
                            optionKey: "decoration:inactive_opacity"
                            label: "Inactive opacity"
                            description: "Opacity for unfocused windows."
                            from: 0.2
                            to: 1.0
                            stepSize: 0.05
                        }

                        RealSlider {
                            optionKey: "decoration:fullscreen_opacity"
                            label: "Fullscreen opacity"
                            description: "Opacity for fullscreen windows."
                            from: 0.2
                            to: 1.0
                            stepSize: 0.05
                        }
                    }

                    SettingsBox {
                        title: "Gaps"
                        icon: "layout-2"

                        IntSlider {
                            optionKey: "general:gaps_in"
                            label: "Inner gaps"
                            description: "Spacing between tiled windows."
                            from: 0
                            to: 64
                        }

                        IntSlider {
                            optionKey: "general:gaps_out"
                            label: "Outer gaps"
                            description: "Spacing between windows and monitor edges."
                            from: 0
                            to: 96
                        }
                    }

                    SettingsBox {
                        title: "Dimming"
                        icon: "moon"

                        ToggleControl {
                            optionKey: "decoration:dim_inactive"
                            label: "Dim inactive"
                            description: "Darken windows that are not focused."
                        }

                        RealSlider {
                            optionKey: "decoration:dim_strength"
                            label: "Inactive strength"
                            description: "Amount of dimming for inactive windows."
                            from: 0.0
                            to: 1.0
                            stepSize: 0.05
                        }

                        RealSlider {
                            optionKey: "decoration:dim_special"
                            label: "Special workspace"
                            description: "Dimming for special workspaces."
                            from: 0.0
                            to: 1.0
                            stepSize: 0.05
                        }

                        RealSlider {
                            optionKey: "decoration:dim_around"
                            label: "Around floating"
                            description: "Dimming around floating windows."
                            from: 0.0
                            to: 1.0
                            stepSize: 0.05
                        }
                    }
                }
            }
        }
    }

    component SettingsBox: NBox {
        id: box
        property string title: ""
        property string icon: ""
        default property alias content: contentColumn.data

        Layout.fillWidth: true
        Layout.preferredHeight: contentColumn.implicitHeight + Style.marginM * 2

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: Style.marginM
            spacing: Style.marginM

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.marginS

                NIcon {
                    icon: box.icon
                    color: Color.mPrimary
                    pointSize: Style.fontSizeM
                }

                NText {
                    text: box.title
                    pointSize: Style.fontSizeM
                    font.weight: Style.fontWeightBold
                    color: Color.mOnSurface
                    Layout.fillWidth: true
                }
            }
        }
    }

    component ToggleControl: NToggle {
        id: toggleControl
        property string optionKey: ""
        property bool initialized: false

        enabled: initialized
        checked: false
        defaultValue: root.baselineValue(optionKey)

        onToggled: nextValue => applyLocalValue(nextValue)

        Component.onCompleted: {
            if (root.initialReadComplete)
                syncFromModel();
        }

        Connections {
            target: root

            function onInitialReadCompleteChanged() {
                if (root.initialReadComplete && !toggleControl.initialized)
                    toggleControl.syncFromModel();
            }
        }

        Connections {
            target: root.mainInstance

            function onOptionChanged(key, value) {
                if (root.initialReadComplete && key === toggleControl.optionKey)
                    toggleControl.syncFromValue(value);
            }

            function onBaselineChanged() {
                toggleControl.defaultValue = root.baselineValue(toggleControl.optionKey);
                if (root.initialReadComplete && !toggleControl.initialized)
                    toggleControl.syncFromValue(root.baselineValue(toggleControl.optionKey));
            }
        }

        function syncFromModel() {
            syncFromValue(root.rawOptionValue(optionKey));
            defaultValue = root.baselineValue(optionKey);
        }

        function syncFromValue(value) {
            if (value !== undefined && value !== null) {
                checked = value === true;
                initialized = true;
            }
        }

        function applyLocalValue(nextValue) {
            checked = nextValue === true;
            initialized = true;
            root.setBool(optionKey, checked);
        }
    }

    component IntSlider: NValueSlider {
        id: intSlider
        property string optionKey: ""
        property bool initialized: false

        enabled: initialized
        value: from
        stepSize: 1
        defaultValue: root.baselineValue(optionKey)
        showReset: true
        text: String(Math.round(intSlider.value))

        onMoved: nextValue => applyLocalValue(nextValue)

        Component.onCompleted: {
            if (root.initialReadComplete)
                syncFromModel();
        }

        Connections {
            target: root

            function onInitialReadCompleteChanged() {
                if (root.initialReadComplete && !intSlider.initialized)
                    intSlider.syncFromModel();
            }
        }

        Connections {
            target: root.mainInstance

            function onOptionChanged(key, value) {
                if (root.initialReadComplete && key === intSlider.optionKey)
                    intSlider.syncFromValue(value);
            }

            function onBaselineChanged() {
                intSlider.defaultValue = root.baselineValue(intSlider.optionKey);
                if (root.initialReadComplete && !intSlider.initialized)
                    intSlider.syncFromValue(root.baselineValue(intSlider.optionKey));
            }
        }

        function syncFromModel() {
            syncFromValue(root.rawOptionValue(optionKey));
            defaultValue = root.baselineValue(optionKey);
        }

        function syncFromValue(value) {
            if (value !== undefined && value !== null) {
                intSlider.value = Math.round(value);
                initialized = true;
            }
        }

        function applyLocalValue(nextValue) {
            if (nextValue === undefined || nextValue === null)
                return;
            const rounded = Math.round(nextValue);
            intSlider.value = rounded;
            initialized = true;
            root.setOption(optionKey, rounded);
        }
    }

    component RealSlider: NValueSlider {
        id: realSlider
        property string optionKey: ""
        property int decimals: 2
        property bool initialized: false

        enabled: initialized
        value: from
        defaultValue: root.baselineValue(optionKey)
        showReset: true
        text: Number(realSlider.value).toFixed(decimals)

        onMoved: nextValue => applyLocalValue(nextValue)

        Component.onCompleted: {
            if (root.initialReadComplete)
                syncFromModel();
        }

        Connections {
            target: root

            function onInitialReadCompleteChanged() {
                if (root.initialReadComplete && !realSlider.initialized)
                    realSlider.syncFromModel();
            }
        }

        Connections {
            target: root.mainInstance

            function onOptionChanged(key, value) {
                if (root.initialReadComplete && key === realSlider.optionKey)
                    realSlider.syncFromValue(value);
            }

            function onBaselineChanged() {
                realSlider.defaultValue = root.baselineValue(realSlider.optionKey);
                if (root.initialReadComplete && !realSlider.initialized)
                    realSlider.syncFromValue(root.baselineValue(realSlider.optionKey));
            }
        }

        function syncFromModel() {
            syncFromValue(root.rawOptionValue(optionKey));
            defaultValue = root.baselineValue(optionKey);
        }

        function syncFromValue(value) {
            if (value !== undefined && value !== null) {
                realSlider.value = Number(value);
                initialized = true;
            }
        }

        function applyLocalValue(nextValue) {
            if (nextValue === undefined || nextValue === null)
                return;
            const fixed = Number(Number(nextValue).toFixed(decimals));
            realSlider.value = fixed;
            initialized = true;
            root.setOption(optionKey, fixed.toFixed(decimals));
        }
    }
}
