import QtQuick 2.0
import Ubuntu.Components 1.1

Item {
    id: container
    property Component childComponent
    property Component parentComponent: childComponent
    property real size
    property list<Action> actions

    property real animationTime: 200
    property color textColor: "white"
    property real rotation: 0

    property int selectedIndex: -1
    property bool expanded: false

    width: size
    height: size

    property real __rotationRads: rotation * Math.PI * 0.5
    property bool __isHorizontal: rotation % 2 === 0
    property bool __isInverted: __isHorizontal
                                    ? Math.cos(__rotationRads) < 0
                                    : Math.sin(__rotationRads) < 0

    // Emit haptic feedback
    onSelectedIndexChanged: pressFeedbackEffect.start();
    onExpandedChanged: pressFeedbackEffect.start();

    Loader {
        sourceComponent: parentComponent
        width: size
        height: size
    }

    PressFeedback {
        id: pressFeedbackEffect
    }

    Component {
        id: repeaterDelegate
        Loader {
            id: delegateContainer
            sourceComponent: childComponent
            width: size
            height: size

            Behavior on x {
                NumberAnimation { duration: animationTime }
            }

            Behavior on y {
                NumberAnimation { duration: animationTime }
            }

            Behavior on opacity {
                NumberAnimation { duration: animationTime }
            }

            Rectangle {
                color: UbuntuColors.orange;
                anchors.fill: parent
                z: parent.z + 0.01
                opacity: index == selectedIndex ? 0.5 : 0.0

                Behavior on opacity {
                    UbuntuNumberAnimation { }
                }
            }

            Loader {
                z: parent.z + 0.01
                anchors.centerIn: parent
                active: actions[index].text
                sourceComponent: Text {
                    color: textColor
                    text: actions[index].text
                }
            }

            Loader {
                anchors.fill: parent
                scale: 0.5
                active: actions[index].iconName
                sourceComponent: Icon {
                    name: actions[index].iconName
                }
            }

            states: [
                State {
                    name: "expanded"
                    when: expanded
                    PropertyChanges {
                        target: delegateContainer
                        opacity: 1.0
                        x: (index + 1) * size * Math.cos(__rotationRads);
                        y: (index + 1) * size * Math.sin(__rotationRads);
                    }
                },
                State {
                    name: "collapsed"
                    when: !expanded
                    PropertyChanges {
                        target: delegateContainer
                        opacity: 0.0
                        x: 0
                        y: 0
                    }
                }
            ]
        }
    }

    MouseArea {
        id: mainMouseArea
        property real __expandedWidth: size * (1 + Math.abs(Math.cos(__rotationRads)) * actions.length)
        property real __expandedHeight: size * (1 + Math.abs(Math.sin(__rotationRads)) * actions.length)
        width: (expanded ? __expandedWidth : size)
        height: (expanded ? __expandedHeight : size)
        z: parent.z + 0.1
        x: (__isHorizontal  && __isInverted ? -width + size  : 0)
        y: (!__isHorizontal && __isInverted ? -height + size : 0)

        propagateComposedEvents: true

        onPressed: {
            expanded = true;
        }

        onPositionChanged: {
            if (containsMouse) {
                var index = __isHorizontal
                                ? Math.floor(mouse.x / parent.width)
                                : Math.floor(mouse.y / parent.height);

                if (__isInverted)
                    index = actions.length - index;

                selectedIndex = index - 1;
            }
        }

        onReleased: {
            if (selectedIndex >= 0 && mainMouseArea.containsMouse)
                actions[selectedIndex].trigger();
            expanded = false;
        }
    }

    Repeater {
        id: repeater
        model: actions
        delegate: repeaterDelegate
    }
}