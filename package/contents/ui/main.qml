/*
 * Copyright 2018  Misagh Lotfi Bafandeh <misaghlb@live.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: main

    anchors.fill: parent
    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)

    property int initialBrightnessValue: 50 // fallback value
    property int newBrightness: initialBrightnessValue
    property int currentBrightness: initialBrightnessValue

    property int brightnessIncrement: plasmoid.configuration.brightnessStep
    property int brightnessMin: plasmoid.configuration.minimumBrightness
    property int brightnessMax: plasmoid.configuration.maximumBrightness
    property int brightnessBackend: plasmoid.configuration.backendMode

    property color iconColor: PlasmaCore.Theme.textColor
    property string buttonImagePath: Qt.resolvedUrl('../icons/video.svg')

    property string monitor_name: ''

    property string brightnessValue: currentBrightness
    
    // terminal commands
    property string changeBrightnessCommand: {
        switch (brightnessBackend) {
            case 0: return 'ddcutil --sn $(echo ' + monitor_name + '| awk \'{print $NF}\') setvcp 10 ' + brightnessValue;
            case 1: return 'xrandr --output ' + monitor_name + ' --brightness ' + brightnessValue;
            case 2: return "2";
        }
    }

    property string mon_list_Command: {
        switch (brightnessBackend) {
            case 0: return "ddcutil detect | sed -n -e '/Display/,/VCP version/ p' | grep -E \"Serial number|Model\" | cut -d':' -f2 |awk 'BEGIN {ORS=\" \"};{$1=$1;{print $N}; if (NR %2 == 0) {print \"\\n\"}}' | sed 's/^[ \\t]*//;s/[ \\t]*$//'";
            case 1: return "xrandr | grep \" connected \" | awk '{ print$1 }' ";
            case 2: return "2";
        }
    }

    property string currentBrightnessCommand: {
        switch (brightnessBackend) {
            case 0: return "ddcutil --sn $(echo " + monitor_name + " | awk '{print $NF}') getvcp 10 | awk '{printf \"%i\"\, $9}'";
            case 1: return "echo 50";
            case 2: return "2";
        }
    }

    //property string changeBrightnessCommand: 'ddcutil --sn $(echo ' + monitor_name + '| awk \'{print $NF}\') setvcp 10 ' + brightnessValue
    //property string mon_list_Command: "ddcutil detect | sed -n -e '/Display/,/VCP version/ p' | grep -E \"Serial number|Model\" | cut -d':' -f2 |awk 'BEGIN {ORS=\" \"};{$1=$1;{print $N}; if (NR %2 == 0) {print \"\\n\"}}' | sed 's/^[ \\t]*//;s/[ \\t]*$//'"
    //property string currentBrightnessCommand: "ddcutil --sn $(echo " + monitor_name + " | awk '{print $NF}') getvcp 10 | awk '{printf \"%i\"\, $9}'"

    property var mon_list
    property ListModel items: ListModel {}

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: CompactRepresentation { }
    Plasmoid.fullRepresentation: FullRepresentation {}

    PlasmaCore.DataSource {
        id: brightyDS
        engine: 'executable'

        onNewData: {
            connectedSources.length = 0
            // get list of monitors
            if (sourceName == mon_list_Command) {
                main.mon_list = data.stdout.split('\n')
                items.clear()
                if (main.mon_list.length > 0) {
                    for (var i = 0; i < main.mon_list.length; ++i) {
                        if ( main.mon_list[i] != "") {
                            items.append({"name": main.mon_list[i]})
                        }
                    }
                }
                // set default monitor
                if (monitor_name == '') {
                    monitor_name = main.mon_list[0]
                }
                executable.exec(currentBrightnessCommand)
            }
        }
    }

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        // https://github.com/Zren/plasma-applet-commandoutput/blob/master/package/contents/ui/main.qml
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName) // cmd finished
        }

        function exec(cmd) {
            executable.connectSource(cmd)
        }

        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }

    Connections {
        target: executable
        onExited: {
            console.log("Initial brightness -> "+monitor_name +" -> "+stdout)
            initialBrightnessValue = stdout
        }
    }

    Plasmoid.toolTipMainText: i18n('DDC/CI Brightness Control')
    Plasmoid.toolTipSubText: i18n('Scroll to change brightness<br><br><b>Selected Monitor</b><br>'+ monitor_name +'<br><br><b>Current Brightness</b><br>'+ brightnessValue+'%')
    Plasmoid.toolTipTextFormat: Text.RichText

    Component.onCompleted: {
        brightyDS.connectedSources.push(mon_list_Command)
        console.log("############## Backend mode: -> "+brightnessBackend)
        console.log("############## Monitors list cmd: -> "+mon_list_Command)
        console.log("############## Change brightness cmd: -> "+changeBrightnessCommand)
        console.log("############## Current brightness cmd: -> "+currentBrightnessCommand)
        //console.log("Current monitor: -> "+monitor_name)
    }

}
