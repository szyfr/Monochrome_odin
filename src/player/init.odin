package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../data"
import "../unit"


//= Procedure
init :: proc() {
	data.playerData = {}

	data.playerData.unit = unit.create({2,0,2})

	data.playerData.canMove = true
	data.cameraData.targetUnit = data.playerData.unit
}