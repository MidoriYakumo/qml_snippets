
import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Window {
	id: window
	title: "Sprite Generator"
	visible: true
	width: Math.max(800, recorder.width+16+sprite.width)
	height: Math.max(600, recorder.height+16)

	property int frameCounter: 0

	Rectangle {
		id: recorder
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.margins: 8
		border.color: "black"
		border.width: 1
		width: item.width*6
		height: item.height*5

		Canvas {
			id: canvas
			anchors.fill: parent

			property int counter

			onPaint: {
				if (!item.texture)
					return

				record(getContext("2d"))
			}

			onPainted: {
				if (counter == 30) {
					grabToImage(function(result){
						result.saveToFile("sprite.png")
					})
				}
			}

			function record(ctx){
				if (counter==0)
					ctx.clearRect(0, 0, width, height)
				var x = item.width * (counter % 6)
				var y = item.height * parseInt(counter / 6)
				ctx.drawImage(item.texture.url, x, y)
				counter++
			}
		}
	}

	Rectangle {
		id: player
		anchors.top: recorder.top
		anchors.left: recorder.right
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.leftMargin: 8
		anchors.rightMargin: 8
		anchors.bottomMargin: 8
		border.color: "black"
		border.width: 1

		AnimatedSprite {
			id: sprite
			width: frameWidth
			height: frameHeight
			anchors.centerIn: parent
			frameCount: 30
			frameWidth: item.width
			frameHeight: item.height
			loops: 1
			interpolate: true
			running: false

			onRunningChanged: {
				if (!running)
					sprite.source = ""
			}
		}
	}

	Rectangle {
		id: itemView
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
					text: canvas.counter
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
			text: "record"
			onClicked: {
				canvas.counter = 0
				window.draw()
			}
		}

		Button {
			text: "play"
			onClicked: {
				sprite.running = false
				sprite.frameRate = Math.random()>.5?3:30
				sprite.source = "sprite.png"
				sprite.start()
			}
		}
	}

	onFrameSwapped: {
		frameCounter++
		if ((frameCounter&1) && canvas.counter<30) {
			draw()
		}
	}

	function draw() {
		item.grabToImage(function(result){
			item.texture = result
			canvas.requestPaint()
		})
	}
}
