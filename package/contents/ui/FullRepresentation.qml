import QtQuick 2.15
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtQuick.Controls 2.12 as Controls2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents

Item {
	id: full
	Layout.preferredWidth: PlasmaCore.Units.gridUnit * 12
	Layout.preferredHeight: PlasmaCore.Units.gridUnit * 3
	Layout.minimumWidth: Layout.preferredWidth
	Layout.minimumHeight: Layout.preferredHeight
	Layout.maximumWidth: Layout.preferredWidth
	

	ColumnLayout {
		id: layout
		//implicitHeight: column.implicitHeight
		// implicitWidth: column.implicitWidth
		anchors.fill: parent
		
		spacing: PlasmaCore.Units.smallSpacing
		
		Label {
			text: i18n("Select a Monitor")
			//Layout.alignment: Qt.AlignCenter
			//Layout.leftMargin: PlasmaCore.Units.gridUnit
			Layout.leftMargin: PlasmaCore.Units.smallSpacing
		}

		ComboBox {
			editable: false
			model: items
			textRole: 'name'
			//anchors.right: parent
			//width: parent.width
			Layout.fillWidth: true
			onCurrentIndexChanged: monitor_name = items.get(currentIndex).name
		}
	}
}
