package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../data"
import "../camera"
import "../settings"
import "../system"


//= Global
MVSPEED :: 3.0


//= Procedures
update :: proc() {
	using data

	//* Get deltaTime
	ft := raylib.GetFrameTime()
	
	//* Check if player is currently moving
	if !system.close_enough(playerData.unit.position, playerData.unit.trgPosition) {
		dir := system.get_direction(playerData.unit.position, playerData.unit.trgPosition)

		playerData.unit.position += dir * (MVSPEED * ft)
	} else if playerData.canMove {
		playerData.unit.position = playerData.unit.trgPosition
		//newPos := system.round(playerData.unit.position)
		newPos := playerData.unit.trgPosition

		//* Gather inputs
		up    := settings.button_down("up")
		down  := settings.button_down("down")
		left  := settings.button_down("left")
		right := settings.button_down("right")

		//* Get movement vector based on camera rotation
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

		//* If the player is moving,
		if playerData.unit.trgPosition != newPos {
			tile, ok := worldData.currentMap[newPos]

			//* Checking for ramps when on even terrain
			if !ok {
				for i:=newPos.y-0.5;i<newPos.y+1;i+=0.5 {
					tempTile, tempOk := worldData.currentMap[{newPos.x,i,newPos.z}]
					if tempOk {
						newPos = {newPos.x,i,newPos.z}
						tile = tempTile
						ok = tempOk
						break
					}
				}
			}

			//* Disallow movement over void
			if !ok do return

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
				// TODO Decide if being able to move through diagonals surrounded by solids is a glitch or not
			}

			//* Check for entity
			// TODO
		}
	}
}