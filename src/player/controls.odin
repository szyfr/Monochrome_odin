package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../data"
import "../camera"
import "../settings"
import "../system"


//= Global
MVSPEED :: 5.0


//= Procedures
update :: proc() {
	using data

	//* Update position
	ft := raylib.GetFrameTime()
	
	if !system.close_enough(playerData.unit.position, playerData.unit.trgPosition) {
		dir := system.get_direction(playerData.unit.position, playerData.unit.trgPosition)

		playerData.unit.position += dir * (MVSPEED * ft)
	} else {
		playerData.unit.position = playerData.unit.trgPosition

		up    := settings.button_down("up")
		down  := settings.button_down("down")
		left  := settings.button_down("left")
		right := settings.button_down("right")

		newPos := playerData.unit.trgPosition

		switch cameraData.rotation {
			case   0:
				if up    do newPos.z -= 1
				if down  do newPos.z += 1
				if left  do newPos.x -= 1
				if right do newPos.x += 1
			case  90:
				if up    do newPos.x += 1
				if down  do newPos.x -= 1
				if left  do newPos.z -= 1
				if right do newPos.z += 1
			case 180:
				if up    do newPos.z += 1
				if down  do newPos.z -= 1
				if left  do newPos.x += 1
				if right do newPos.x -= 1
			case 270:
				if up    do newPos.x -= 1
				if down  do newPos.x += 1
				if left  do newPos.z += 1
				if right do newPos.z -= 1
		}
		if playerData.unit.trgPosition != newPos {
			tile, ok := worldData.currentMap[newPos]
			fmt.printf("%v:%v - %v\n",newPos,tile,ok)

			//* Allow movement over void
			if !ok {
				playerData.unit.trgPosition = newPos
				return
			}

			//* Check for ramp
			

			//* Check if solid
			val := newPos - playerData.unit.trgPosition
			switch val {
				//* Cardinals
				case { 0,val.y,-1}: if !tile.solid[0] do playerData.unit.trgPosition = newPos
				case {-1,val.y, 0}: if !tile.solid[1] do playerData.unit.trgPosition = newPos
				case { 0,val.y, 1}: if !tile.solid[2] do playerData.unit.trgPosition = newPos
				case { 1,val.y, 0}: if !tile.solid[3] do playerData.unit.trgPosition = newPos
				//* Diagonals
				case {-1,val.y,-1}: if !tile.solid[1] && !tile.solid[0] do playerData.unit.trgPosition = newPos
				case {-1,val.y, 1}: if !tile.solid[2] && !tile.solid[1] do playerData.unit.trgPosition = newPos
				case { 1,val.y, 1}: if !tile.solid[3] && !tile.solid[2] do playerData.unit.trgPosition = newPos
				case { 1,val.y,-1}: if !tile.solid[0] && !tile.solid[3] do playerData.unit.trgPosition = newPos
			}
			//if !tile.solid do playerData.unit.trgPosition = newPos

			//* Check for entity
			// TODO
		}
	}
}