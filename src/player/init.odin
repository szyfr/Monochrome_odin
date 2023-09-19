package player


//= Imports
import "../data"
import "../camera"


//= Procedure
init :: proc() {
	unit = new(data.Unit)
	unit.position = {0,0.5,0}
	unit.trgPosition = {0,0.5,0}
	camera.targetUnit = unit
}