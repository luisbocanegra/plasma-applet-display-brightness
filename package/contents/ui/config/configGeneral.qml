/*
    SPDX-FileCopyrightText: 2022 author-name
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.15
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Controls 1.4 as QtControls1
import QtQuick.Layouts 1.15 as QtLayouts

import org.kde.kirigami 2.19 as Kirigami

Kirigami.FormLayout {
    id: generalPage
    anchors.left: parent.left
    anchors.right: parent.right

    signal configurationChanged

    // property alias cfg_text: textField.text

    property alias cfg_minimumBrightness: minimumBrightness.value
    property alias cfg_brightnessStep: brightnessStep.value
    property alias cfg_maximumBrightness: maximumBrightness.value
    property int cfg_backendMode: backendMode.value

    // QtControls.TextField {
    //     id: textField
    //     Kirigami.FormData.label: i18n("Text:")
    // }

    QtControls1.SpinBox {
        id: minimumBrightness
        minimumValue: 0
        maximumValue: 100
        Kirigami.FormData.label: i18n("Minimum allowed brightness:")
        suffix: i18n("%")
    }

    QtControls1.SpinBox {
        id: maximumBrightness
        minimumValue: minimumBrightness.value
        maximumValue: 100
        Kirigami.FormData.label: i18n("Maximum allowed brightness:")
        suffix: i18n("%")
    }

    QtControls1.SpinBox {
        id: brightnessStep
        minimumValue: 1
        maximumValue: 100
        Kirigami.FormData.label: i18n("Brightness step:")
        suffix: i18n("%")
    }

    Item {
        Kirigami.FormData.isSection: true
    }

    // based on https://github.com/ismailof/mediacontroller_plus/blob/master/plasmoid/contents/ui/configCompactView.qml
    QtControls.RadioButton {
        id: ddcutilMode
        Kirigami.FormData.label: i18n("Brightness backend:")
        text: "ddcutil"
        checked: cfg_backendMode === 0
        //checked:
        //visible: reverseMode.visible
        //QtControls.ButtonGroup.group: backendModeRadioButtonGroup
    }
    
    QtControls.Label {
        text: i18n("Control brightness using DDC/CI and USB")
        font: Kirigami.Theme.smallFont
    }

    QtControls.RadioButton {
        id: xrandrMode
        text: "xrandr"
        checked: cfg_backendMode === 1
    }

    QtControls.Label {
        text: i18n("Control brightness using xrandr for Xorg's Randr extension")
        font: Kirigami.Theme.smallFont
    }

    QtControls.RadioButton {
        id: acpiMode
        text: "ACPI"
        visible: false
        checked: cfg_backendMode === 2
    }

    QtControls.Label {
        visible: acpiMode.visible
        text: i18n("Control monitor using ...")
        font: Kirigami.Theme.smallFont
    }
    
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
