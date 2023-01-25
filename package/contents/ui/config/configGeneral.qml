/*
    SPDX-FileCopyrightText: 2022 author-name
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.15
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Controls 1.4 as QtControls1
import QtQuick.Layouts 1.15 as QtLayouts
import org.kde.kirigami 2.19 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

QtLayouts.ColumnLayout {

    id: root
    property alias cfg_minimumBrightness: minimumBrightness.value
    property alias cfg_brightnessStep: brightnessStep.value
    property alias cfg_maximumBrightness: maximumBrightness.value
    property int cfg_backendMode: backendMode.value
    signal configurationChanged

    Kirigami.FormLayout {
        id: generalPage
        QtLayouts.Layout.alignment: Qt.AlignTop
        wideMode: false

        Kirigami.Separator {
            Kirigami.FormData.label: i18n("Behavior")
            Kirigami.FormData.isSection: true
        }

        QtLayouts.GridLayout {
            columns: 2
            
            QtControls.Label {
                text: i18n("Minimum allowed brightness:")
            }
            QtControls1.SpinBox {
                id: minimumBrightness
                minimumValue: 0
                maximumValue: 100
                suffix: i18n("%")
            }

            QtControls.Label {
                    text: i18n("Maximum allowed brightness:")
            }
            QtControls1.SpinBox {
                id: maximumBrightness
                minimumValue: minimumBrightness.value
                maximumValue: 100
                suffix: i18n("%")
            }

            QtControls.Label {
                    text: i18n("Brightness step:")
            }
            QtControls1.SpinBox {
                id: brightnessStep
                minimumValue: 1
                maximumValue: 100
                Kirigami.FormData.label: i18n("Brightness step:")
                suffix: i18n("%")
            }
        }


        Kirigami.Separator {
            Kirigami.FormData.label: i18n("Backend configuration")
            Kirigami.FormData.isSection: true
        }

        QtControls.RadioButton {
            id: ddcutilMode
            checked: cfg_backendMode === 0
            text: i18n("<b>ddcutil</b> for DDC/CI and USB protocols")
        }

        QtControls.RadioButton {
            id: xrandrMode
            checked: cfg_backendMode === 1
            text: i18n("<b>xrandr</b> for Xorg's Randr extension")
        }

        QtControls.RadioButton {
            id: acpiMode
            checked: cfg_backendMode === 2
            text: i18n("<b>light</b> for ACPI backlight controllers")
        }

        // based on https://github.com/ismailof/mediacontroller_plus/blob/master/plasmoid/contents/ui/configCompactView.qml
        QtControls.ButtonGroup {
            id: backendModeRadioButtonGroup
            buttons: [ddcutilMode, xrandrMode, acpiMode]
            readonly property int value: {
                switch (checkedButton) {
                    case ddcutilMode: return 0;
                    case xrandrMode: return 1;
                    case acpiMode: return 2;
                }
            }
            onClicked: { cfg_backendMode = value }
        }
    }
}
