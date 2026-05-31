import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    required property var controller

    IpcHandler {
        target: "plugin:companions"

        function toggle() {
            root.controller.toggleCompanions();
        }

        function show() {
            root.controller.showCompanions();
        }

        function hide() {
            root.controller.hideCompanions();
        }
    }
}
