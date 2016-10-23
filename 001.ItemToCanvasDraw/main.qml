/*
  grabToImage requires Window to be shown
*/

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Window {
	id: window
	title: "ItemToCanvasDraw"
	visible: true
	width: 800
	height: 600

	property int frameCounter: 0
	property int fStart

	Canvas {
		id: canvas
		anchors.fill: parent

		property var paintFunc: canvas.randomDraw

		onPaint: {
			if (!item.texture)
				return

			paintFunc(getContext("2d"))
		}

		onPainted: {
			console.log("Frame delay:", frameCounter - fStart)
		}

		function randomDraw(ctx){
			var x = Math.random()*(width-item.width)
			var y = Math.random()*(height-item.height)
			ctx.drawImage(item.texture.url, x, y)
		}
	}

	Rectangle {
		id: itemView
//		visible: !toggleOffscreen.checked
		opacity: toggleOffscreen.checked?0:1 // fake offscreen for quickcontrols2
		anchors.margins: 8
		anchors.top: parent.top
		anchors.left: parent.left
		width: item.width + 8
		height: item.height + 8

		Item {
			id: item
			anchors.centerIn: parent
			width: 120
			height: width

			property var texture: null

			Column {
				anchors.centerIn: parent

				Text {
					text: "Controls:"
				}

				Button {
					text: "Button"
					checkable: true
				}

				ProgressBar {
					id: progress
					width: parent.width
					value: frameCounter % 60 / 60
				}

				BusyIndicator {
					running: true
				}
			}
		}

		layer.enabled: true
		layer.effect: Glow {
			color: Qt.rgba(0, 0, 0, .4)
			radius: 8
			samples: 15
			transparentBorder: true
		}
	}

	Row {
		id: controls
		anchors.margins: 8
		anchors.top: parent.top
		anchors.right: parent.right
		spacing: 8

		Button {
			id: toggleOffscreen
			text: "offscreen"
			checkable: true
		}

		Button {
			text: "draw"
			onClicked: {
				text.text = Math.random()
				window.draw()
			}
		}
	}

	onFrameSwapped: {
		frameCounter++
	}

	function draw() {
		item.grabToImage(function(result){
			item.texture = result
			canvas.requestPaint()
		})
		fStart = frameCounter
	}
}
