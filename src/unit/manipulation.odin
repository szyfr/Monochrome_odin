package unit


//= Imports
import "core:fmt"
import "core:strings"
import "core:reflect"

import "../data"
import "../system"
import unit_ "../unit"


//= Procedures
move :: proc( unit : ^data.Unit, direction : data.Direction ) -> bool {
	if !system.close_enough(unit.position, unit.trgPosition) do return false
	if direction == .null do return false
	
	newPos := unit.position

	//* Change direction and animation
	unit.direction = system.get_relative_direction_dire(direction)
	dirStr := reflect.enum_string(unit.direction)
	builder : strings.Builder
	anim := fmt.sbprintf(&builder, "idle_%v",dirStr)
	//unit_.set_animation(anim, unit)

	#partial switch direction {
		case .north: newPos += { 0,0,-1}
		case .south: newPos += { 0,0, 1}
		case .east:  newPos += {-1,0, 0}
		case .west:  newPos += { 1,0, 0}
	}

	tile, ok := &data.worldData.currentMap[newPos]

	//* Checking for ramps when on even terrain
	if !ok {
		for i:=unit.position.y-0.5;i<unit.position.y+1;i+=0.5 {
			tempTile, tempOk := &data.worldData.currentMap[{newPos.x,i,newPos.z}]
			if tempOk {
				// TODO Figure out jumping
				//if unit.position.y < i {
					newPos = {newPos.x,i,newPos.z}
					tile = tempTile
					ok = tempOk
				//} else do jump(unit, direction)
				break
			}
		}
	}

	//* Disallow movement over void
	if !ok do return false

	//* Check if solid
	val := newPos - unit.trgPosition
	switch val {
		//* Cardinals
		case { 0,val.y,-1}: if tile.solid[0] do return false
		case {-1,val.y, 0}: if tile.solid[1] do return false
		case { 0,val.y, 1}: if tile.solid[2] do return false
		case { 1,val.y, 0}: if tile.solid[3] do return false
		//* Diagonals
		case {-1,val.y,-1}: if tile.solid[1] && tile.solid[0] do return false
		case {-1,val.y, 1}: if tile.solid[2] && tile.solid[1] do return false
		case { 1,val.y, 1}: if tile.solid[3] && tile.solid[2] do return false
		case { 1,val.y,-1}: if tile.solid[0] && tile.solid[3] do return false
		// TODO Decide if being able to move through diagonals surrounded by solids is a glitch or not
	}

	//* Check for entity
	// TODO

	//* Change animation
	strings.builder_reset(&builder)
	anim = fmt.sbprintf(&builder, "walk_%v",dirStr)
	unit_.set_animation(anim, unit)

	unit.trgPosition = newPos
	return true
}

rotate :: proc( unit : ^data.Unit, direction : data.Direction, moving : bool ) -> bool {
	if moving {
		dirStr := reflect.enum_string(direction)
		builder : strings.Builder
		anim := fmt.sbprintf(&builder, "walk_%v",dirStr)
		unit_.set_animation(anim, unit)
		return true
	} else {
		dirStr := reflect.enum_string(direction)
		builder : strings.Builder
		anim := fmt.sbprintf(&builder, "idle_%v",dirStr)
		unit_.set_animation(anim, unit)
		return true
	}
	return true
}

jump :: proc( unit : ^data.Unit, direction : data.Direction ) -> bool {
	fmt.printf("JUMP!\n")
	return false
}