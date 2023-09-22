package player


//= Imports
import "vendor:raylib"

import "../camera"
import "../settings"
import "../system"


//= Global
MVSPEED :: 5.0


//= Procedures
update :: proc() {
	//* Update position
	ft := raylib.GetFrameTime()
	if !system.close_enough(unit.position, unit.trgPosition) {
		dir := system.get_direction(unit.position, unit.trgPosition)

		unit.position += dir * (MVSPEED * ft)
	} else {
		unit.position = unit.trgPosition

		up    := settings.button_down("up")
		down  := settings.button_down("down")
		left  := settings.button_down("left")
		right := settings.button_down("right")

		newPos := unit.trgPosition

		switch camera.rotation {
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

		//tile, ok := world.currentMap[newPos]
		//fmt.printf("%v\n",tile)
		//switch system.check_position(newPos) {
		//	case null: fallthrough
		//	case empty:
		//		unit.trgPosition = newPos
		//	case entity:
		//	case trigger:
		//	case solid:
		//	case step_up:
		//		newPos.y += 0.5
		//		unit.trgPosition = newPos
		//	case step_down:
		//		newPos.y -= 0.5
		//		unit.trgPosition = newPos
		//}
	}
}