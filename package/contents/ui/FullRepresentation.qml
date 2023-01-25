import QtQuick 2.15
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtQuick.Controls 2.12 as Controls2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents
import org.kde.kirigami 2.19 as Kirigami

Item {
	id: full
	Layout.preferredWidth: PlasmaCore.Units.gridUnit * 14
	Layout.preferredHeight: PlasmaCore.Units.gridUnit * 8
	Layout.minimumWidth: Layout.preferredWidth
	Layout.minimumHeight: Layout.preferredHeight
	Layout.maximumWidth: Layout.preferredWidth
	

	ColumnLayout {
		id: layout
		anchors.left: full.left
		anchors.right: full.right
		//anchors.fill: (parent.height == PlasmaCore.Units.gridUnit * 10) ? parent: undefined
		
		spacing: PlasmaCore.Units.smallSpacing
		
		Text {
			text: i18n("Select a display")
			Layout.leftMargin: PlasmaCore.Units.smallSpacing
			color: PlasmaCore.Theme.textColor
			//textFormat: Text.RichText
		}

		ComboBox {
			editable: false
			model: items
			textRole: 'name'
			currentIndex: activeMon
			Layout.fillWidth: true
			// onCurrentIndexChanged: { 
			onActivated: { 
				//console.log("COMBO ACTIVATED")
				monitor_name = items.get(currentIndex).name
				activeMon = currentIndex
			}
		}

		RowLayout {
			Text {
				Layout.fillWidth: true
				text: i18n("Brightness")
				Layout.leftMargin: PlasmaCore.Units.smallSpacing
				color: PlasmaCore.Theme.textColor
				//textFormat: Text.RichText
				horizontalAlignment: Text.AlignLeft
			}
			Text {
				Layout.fillWidth: true
				text: brightnessSlider.value + i18n("%")
				Layout.rightMargin: PlasmaCore.Units.smallSpacing
				color: PlasmaCore.Theme.textColor
				//textFormat: Text.RichText
				horizontalAlignment: Text.AlignRight
				
			}
		}

		Controls2.Slider {
			id: brightnessSlider
			from: brightnessMin
			value: currentBrightness
			to: brightnessMax
			//stepSize: brightnessIncrement
			Layout.fillWidth: true
			//Fix brightness slider mouse wheel events https://invent.kde.org/multimedia/elisa/-/commit/611c0bf86ee3a2b1a0408c8fb7ec6caac2b8f3e1
			MouseArea {
				anchors.fill: parent
				acceptedButtons: Qt.NoButton
				onWheel: {
					// Can't use Slider's built-in increase() and decrease() functions here
					// since they go in increments of 0.1 when the slider's stepSize is not
					// defined, which is much too slow. And we don't define a stepSize for
					// the slider because if we do, it gets gets tickmarks which look ugly.
					if (wheel.angleDelta.y > 0) {
						// Increase brightness
						brightnessSlider.value = Math.min(brightnessSlider.to, brightnessSlider.value + brightnessIncrement);

					} else {
						// Decrease brightness
						brightnessSlider.value = Math.max(brightnessSlider.from, brightnessSlider.value - brightnessIncrement);
					}
				}
			}

			onValueChanged: {
				brightnessSlider.value = Math.round(brightnessSlider.value)
				currentBrightness = brightnessSlider.value
			}
		}

		Text {
			text: i18n("Backend: <b>"+brightnessBackendsList[brightnessBackend]+"</b><br>"+"Open widget settings to change")
			Layout.leftMargin: PlasmaCore.Units.smallSpacing
			color: PlasmaCore.Theme.textColor
			textFormat: Text.RichText
		}
		
	}
}
