import QtQuick 2.7
import QtTest 1.0

Item {
	height: 600
	width: 600

	MouseArea {
		id: plum
		objectName: "plum"
		height: parent.height
		width: parent.width / 2

		Rectangle {
			anchors.fill: parent
			color: parent.objectName
		}

		property Text text: Text {
			parent: plum
			anchors.centerIn: parent
			text: "I am " + parent.objectName
		}

		onClicked: {
			text.text = objectName + " clicked"
		}

		Keys.onPressed: {
			if (event.text)
				text.text = objectName + " pressed " + event.text
		}
	}

	MouseArea {
		id: turquoise
		objectName: "turquoise"
		x: parent.width/2
		height: parent.height
		width: parent.width / 2

		Rectangle {
			anchors.fill: parent
			color: parent.objectName
		}

		property Text text: Text {
			parent: turquoise
			anchors.centerIn: parent
			text: "I am " + parent.objectName
		}

		onClicked: {
			text.text = objectName + " clicked"
			defer.start()
		}

		focus: true
		Keys.onPressed: {
			plum.focus = true
			eventSource.keyPress(event.key, Qt.NoModifier, -1)
			turquoise.focus = true
			if (event.text) {
				text.text = objectName + " pressed " + event.text
				plum.text.text += " by turquoise"
			}
		}
	}

	TestEvent {
		id: eventSource
	}

	Timer {
		id: defer
		interval: 0

		onTriggered: {
			eventSource.mouseClick(plum, 0, 0, Qt.LeftButton, Qt.NoModifier, -1)
			plum.text.text += " by turquoise"
		}
	}
}
