package player


//= Imports
import "core:fmt"

import "../data"
import "../camera"


//= Procedure
init :: proc() {
	data.playerData = {}
	data.playerData.unit = new(data.Unit)
	data.playerData.unit.position = {0,0,0}
	data.playerData.unit.trgPosition = {0,0,0}
	data.cameraData.targetUnit = data.playerData.unit
}