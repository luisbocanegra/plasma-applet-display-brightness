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
	Layout.preferredWidth: PlasmaCore.Units.gridUnit * 12
	Layout.preferredHeight: PlasmaCore.Units.gridUnit * 6
	Layout.minimumWidth: Layout.preferredWidth
	Layout.minimumHeight: Layout.preferredHeight
	Layout.maximumWidth: Layout.preferredWidth
	

	ColumnLayout {
		id: layout
		anchors.left: parent.left
		anchors.right: parent.right
		//anchors.verticalCenter: (Layout.height != Layout.preferredHeight) ?  parent.verticalCenter : null
		anchors.fill: (parent.height == PlasmaCore.Units.gridUnit * 6) ? parent: undefined
		
		spacing: PlasmaCore.Units.smallSpacing
		
		Text {
			text: i18n("Select a display")
			Layout.leftMargin: PlasmaCore.Units.smallSpacing
			color: PlasmaCore.Theme.textColor
			textFormat: Text.RichText
		}

		ComboBox {
			editable: false
			model: items
			textRole: 'name'
			currentIndex: activeMon
			Layout.fillWidth: true
			//Layout.bottomMargin: PlasmaCore.Units.smallSpacing
			// onCurrentIndexChanged: { 
			onActivated: { 
				//console.log("COMBO ACTIVATED")
				monitor_name = items.get(currentIndex).name
				activeMon = currentIndex
			}
		}

		Text {
			text: i18n("Backend: <b>"+brightnessBackendsList[brightnessBackend]+"</b><br>"+"Open settings to configure")
			Layout.leftMargin: PlasmaCore.Units.smallSpacing
			color: PlasmaCore.Theme.textColor
			textFormat: Text.RichText
		}
		
	}
}
