package camera


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../data"
import "../system"
import "../settings"


//= Constants
XDIST   ::   0.0
YDIST   ::   7.0
ZDIST   ::   2.5
MVSPEED ::   5.0
CMSPEED :: 200.0


//= Procedures
init :: proc() {
	set_position({0.5,0,0.5})
	set_rotation(0)

	rl.up = {0, 1, 0}
	rl.fovy = 70
	rl.projection = .PERSPECTIVE
	
	update()
}

update :: proc() {
	ft := raylib.GetFrameTime()
	
	//* Check if targetting a unit
	if targetUnit != nil do position = targetUnit.position
	else {
		//* Update position
		if !system.close_enough(position, trgPosition) {
			dir := system.get_direction(position, trgPosition)

			position += dir * (MVSPEED * ft)
		} else do position = trgPosition
	}
	//* Update rotation
	if !system.close_enough(rotation, trgRotation, 0.5) {
		dir := system.get_direction(rotation, trgRotation)

		rotation += dir * (CMSPEED * ft)
	} else {
		rotation = trgRotation
		if rotation <   0 do set_rotation(rotation + 360)
		if rotation > 360 do set_rotation(rotation - 360)
		if settings.button_down("rotate_right") do set_target_rotation(rotation + 90)
		if settings.button_down("rotate_left") do set_target_rotation(rotation - 90)
	}

	

	//* Calculate the rlposition of the Camera based on rotation
	cameraPosition := system.rotate(position, rotation)

	rl.target = position
	rl.position = cameraPosition
}

//* Hard sets the current position and target positions
set_position :: proc( pos : raylib.Vector3 ) {
	position = pos
	trgPosition = pos
}
//* Sets the target position
set_target_position :: proc( pos : raylib.Vector3 ) {
	trgPosition = pos
}

//* Hard sets the current rotation and target rotations
set_rotation :: proc( rot : f32 ) {
	rotation = rot
	trgRotation = rot
}
//* Sets the target rotation
set_target_rotation :: proc( rot : f32 ) {
	trgRotation = rot
}