package player


//= Imports
import "core:fmt"
import "core:strings"
import "core:reflect"

import "vendor:raylib"

import "../data"
import "../unit"
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
		newPos := playerData.unit.position

		//* Gather inputs
		up    := settings.button_down("up")
		down  := settings.button_down("down")
		left  := settings.button_down("left")
		right := settings.button_down("right")

		//* Get movement vector based on camera rotation
		if up    do playerData.unit.direction = .north
		if down  do playerData.unit.direction = .south
		if left  do playerData.unit.direction = .east
		if right do playerData.unit.direction = .west

		switch cameraData.rotation {
			case   0:
				if up {
					playerData.unit.direction = .north
					newPos.z -= 1
				}
				if down {
					playerData.unit.direction = .south
					newPos.z += 1
				}
				if left {
					playerData.unit.direction = .east
					newPos.x -= 1
				}
				if right {
					playerData.unit.direction = .west
					newPos.x += 1
				}
			case  90:
				if up {
					playerData.unit.direction = .west
					newPos.x += 1
				}
				if down {
					playerData.unit.direction = .east
					newPos.x -= 1
				}
				if left {
					playerData.unit.direction = .north
					newPos.z -= 1
				}
				if right {
					playerData.unit.direction = .south
					newPos.z += 1
				}
			case 180:
				if up {
					playerData.unit.direction = .south
					newPos.z += 1
				}
				if down {
					playerData.unit.direction = .north
					newPos.z -= 1
				}
				if left {
					playerData.unit.direction = .west
					newPos.x += 1
				}
				if right {
					playerData.unit.direction = .east
					newPos.x -= 1
				}
			case 270:
				if up {
					playerData.unit.direction = .east
					newPos.x -= 1
				}
				if down {
					playerData.unit.direction = .west
					newPos.x += 1
				}
				if left {
					playerData.unit.direction = .south
					newPos.z += 1
				}
				if right {
					playerData.unit.direction = .north
					newPos.z -= 1
				}
		}

		//* If the player is moving
		if playerData.unit.trgPosition != newPos {
			unit.move(playerData.unit, playerData.unit.direction)
		} else {
			//* Change direction and animation
			if playerData.unit.direction != .null {
				unit.rotate(playerData.unit, system.get_relative_direction_dire(playerData.unit.direction), false)
			}
		}
	}
}