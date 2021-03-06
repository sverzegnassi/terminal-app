import QtQuick 2.4
import Ubuntu.Components 1.3

import ".."

Item {
    property alias text: mainLabel.text
    property alias mainAction: expandableButton.mainAction
    property alias actions: expandableButton.actions
    property alias expandable: expandableButton.expandable
    property alias expandRight: expandableButton.expandRight

    Rectangle {
        width: parent.width
        anchors.top: parent.top
        height: units.dp(3)
        color: UbuntuColors.orange;
        z: parent.z + 1
    }

    Label {
        id: mainLabel
        anchors.centerIn: parent
        z: parent.z + 0.02
        color: UbuntuColors.orange;
    }

    ExpandableButton {
        id: expandableButton
        anchors.fill: parent
        parentComponent: Rectangle {
            color: "black"
        }

        z: parent.z + 0.01
    }
}
