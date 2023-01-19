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
}