package player


//= Imports
import "../data"
import "../camera"


//= Procedure
init :: proc() {
	unit = new(data.Unit)
	unit.position = {0.5,0,-0.5}
	unit.trgPosition = {0.5,0,-0.5}
	camera.targetUnit = unit
}