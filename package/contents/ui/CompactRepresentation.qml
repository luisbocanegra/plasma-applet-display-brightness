import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: compactRepresentation

    property double itemWidth:  parent === null ? 0 : vertical ? parent.width : parent.height
    property double itemHeight: itemWidth

    Layout.minimumWidth: itemWidth
    Layout.minimumHeight: itemHeight

    IconSVG {
        source: buttonImagePath
        color: iconColor
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        // hoverEnabled: true
        onClicked: {
            plasmoid.expanded = !plasmoid.expanded
            executable.exec(mon_list_Command(),"updateMonitors")
        }


        onWheel: {
            if (executable.connectedSources.length > 0) {
                return
            }
            if (wheel.angleDelta.y > 0) {
                // wheel up
                currentBrightness += brightnessIncrement
                if (currentBrightness > brightnessMax) {
                    currentBrightness = brightnessMax
                }
                
            } else {
                // wheel down
                currentBrightness -= brightnessIncrement
                if (currentBrightness < brightnessMin) {
                    currentBrightness = brightnessMin
                }
            }
            executable.exec(changeBrightnessCommand(monitor_name,currentBrightness),"setBrightness")
        }

        // onEntered: {
        //     //console.log("ENTERED", currentBrightnessCommand(monitor_name),"\n",changeBrightnessCommand(monitor_name,currentBrightnes""s))
        //     // console.log("ALL BACKENDS: ",brightnessBackendsList," is ",typeof(brightnessBackendsList)," \ndat: ",plasmoid.configuration.brightnessBackends,"type: ",typeof(plasmoid.configuration.brightnessBackends[0]))
        // }
    }
}
