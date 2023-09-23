package player


//= Imports
import "core:fmt"

import "../data"
import "../camera"


//= Procedure
init :: proc() {
	data.playerData = {}

	data.playerData.unit = new(data.Unit)
	data.playerData.unit.position = {2,0,2}
	data.playerData.unit.trgPosition = {2,0,2}
	data.playerData.canMove = true
	data.cameraData.targetUnit = data.playerData.unit
}