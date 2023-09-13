package player


//= Imports
import "../data"
import "../camera"


//= Procedure
init :: proc() {
	unit = new(data.Unit)
	camera.targetUnit = unit
}