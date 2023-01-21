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
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.fullRepresentation: FullRepresentation {}

    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)

    property var brightnessBackendsList: ["ddcutil","xrandr","light"]

    property int initialBrightnessValue: 50 // fallback value?
    property int currentBrightness: initialBrightnessValue

    property int brightnessIncrement: plasmoid.configuration.brightnessStep
    property int brightnessMin: plasmoid.configuration.minimumBrightness
    property int brightnessMax: plasmoid.configuration.maximumBrightness
    property int brightnessBackend: plasmoid.configuration.backendMode

    property color iconColor: PlasmaCore.Theme.textColor
    property string buttonImagePath: Qt.resolvedUrl('../icons/video.svg')

    property string monitor_name: ''

    property string brightnessValue: currentBrightness

    property var mon_list
    property ListModel items: ListModel {}

    property string cmd_type: ''
    property int activeMon: 0
    
    // terminal commands
    function changeBrightnessCommand(monitor_name,currentBrightness) {
        switch (brightnessBackend) {
            case 0: return 'ddcutil --sn $(echo ' + monitor_name + '| awk \'{print $NF}\') setvcp 10 ' + currentBrightness;
            case 1: return 'xrandr --output ' + monitor_name + ' --brightness ' + currentBrightness/100;
            case 2: return "light -s "+monitor_name+" -S "+currentBrightness;
        }
    }

    function mon_list_Command() {
        switch (brightnessBackend) {
            case 0: return "ddcutil detect | sed -n -e '/Display/,/VCP version/ p' | grep -E \"Serial number|Model\" | cut -d':' -f2 |awk 'BEGIN {ORS=\" \"};{$1=$1;{print $N}; if (NR %2 == 0) {print \"\\n\"}}' | sed 's/^[ \\t]*//;s/[ \\t]*$//'";
            case 1: return "xrandr | grep \" connected \" | awk '{ print$1 }' ";
            case 2: return "light -L | grep '_backlight' | awk '{print $1}'";
        }
    }

    function currentBrightnessCommand(monitor_name) {
        switch (brightnessBackend) {
            case 0: return "ddcutil --sn $(echo " + monitor_name + " | awk '{print $NF}') getvcp 10 | awk '{printf \"%i\"\, $9}'";
            case 1: return "xrandr --verbose --current | grep ^"+monitor_name+" -A5 | tail -n1 | awk '{print $2}'";
            case 2: return "light -s "+monitor_name+" -G";
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

            function exec(cmd,type) {
                cmd_type = type
                executable.connectSource(cmd)
        }

        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }

    Connections {
        target: executable
        function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
            console.log("EXECUTABLE of type -> ",cmd_type)
            // update current brightness
            if (cmd_type == "updateCurrentBrightness") {
                //executable.exec(currentBrightnessCommand(monitor_name),"")
                console.log("Initial brightness -> "+monitor_name +" -> "+stdout)
                currentBrightness = (brightnessBackend == 1) ? stdout*100 : stdout
            }

            // update monitors list
            if (cmd_type == "updateMonitors") {
                main.mon_list = stdout.split('\n')
                items.clear()
                if (main.mon_list.length > 0) {
                    for (var i = 0; i < main.mon_list.length; ++i) {
                        if ( main.mon_list[i] != "") {
                            items.append({"name": main.mon_list[i]})
                        }
                    }
                }
                // set default monitor
                if (monitor_name === '') {
                    monitor_name = main.mon_list[0]
                    executable.exec(currentBrightnessCommand(monitor_name),"updateCurrentBrightness")
                }
            }
        }
    }

    Plasmoid.toolTipMainText: i18n('Display Brightness Control')
    Plasmoid.toolTipSubText: i18n('Scroll to change brightness<br><br><b>Selected Display</b><br>'+ monitor_name +'<br><br><b>Current Brightness</b><br>'+ brightnessValue+'%')
    Plasmoid.toolTipTextFormat: Text.RichText

    Component.onCompleted: {
        executable.exec(mon_list_Command(),"updateMonitors")
        console.log("############## Backend mode: -> "+brightnessBackend)
        console.log("############## Monitors list cmd: -> "+mon_list_Command(monitor_name))
        console.log("############## Change brightness cmd: -> "+changeBrightnessCommand(monitor_name,currentBrightness))
        console.log("############## Current brightness cmd: -> "+currentBrightnessCommand(monitor_name))
    }


    onMonitor_nameChanged: {
        console.log("############## Monitor changed: ->", monitor_name,"\n cur_cmd:",currentBrightnessCommand(monitor_name))
        if (monitor_name !== '') { // ignore if new monitor is empty
            executable.exec(currentBrightnessCommand(monitor_name),"updateCurrentBrightness")
        }
    }

    onBrightnessBackendChanged: {
        console.log("############## Backend Changed: -> "+brightnessBackendsList[brightnessBackend])
        // force a rescan of monitors after backend changes
        monitor_name = ''
        // reset to first monitor
        activeMon = 0
        executable.exec(mon_list_Command(),"updateMonitors")
    }

}
