.pragma library

var konsole = console

function generateInfo() {
	var r = Math.random() * 4
	r = parseInt(r)
	var action = [konsole.debug, konsole.info, konsole.log, konsole.warn]
	var message = ["It's 42", "Looks pretty good", "At 2001-01-01", "Kernel is melting"]
	action = action[r]
	message = message[r]

	action(message)
}
