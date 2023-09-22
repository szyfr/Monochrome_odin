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
YDIST   ::   3.0
ZDIST   ::   2.5
MVSPEED ::   5.0
CMSPEED :: 500.0


//= Procedures
init :: proc() {
	data.cameraData = {}

	set_position({0.5,0,0.5})
	set_rotation(0)

	data.cameraData.rl.up = {0, 1, 0}
	data.cameraData.rl.fovy = 70
	data.cameraData.rl.projection = .PERSPECTIVE
	
	update()
}

update :: proc() {
	using data

	ft := raylib.GetFrameTime()
	
	//* Check if targetting a unit
	if cameraData.targetUnit != nil do cameraData.position = cameraData.targetUnit.position + {0,1,0}
	else {
		//* Update position
		if !system.close_enough(cameraData.position, cameraData.trgPosition) {
			dir := system.get_direction(cameraData.position, cameraData.trgPosition)

			cameraData.position += dir * (MVSPEED * ft)
		} else do cameraData.position = cameraData.trgPosition
	}
	//* Update rotation
	if !system.close_enough(cameraData.rotation, cameraData.trgRotation, 5) {
		dir := system.get_direction(cameraData.rotation, cameraData.trgRotation)

		cameraData.rotation += dir * (CMSPEED * ft)
	} else {
		cameraData.rotation = cameraData.trgRotation
		if cameraData.rotation <   0 do set_rotation(cameraData.rotation + 360)
		if cameraData.rotation >= 360 do set_rotation(cameraData.rotation - 360)
		if settings.button_down("rotate_right") do set_target_rotation(cameraData.rotation - 90)
		if settings.button_down("rotate_left") do set_target_rotation(cameraData.rotation + 90)
	}

	

	//* Calculate the rlposition of the Camera based on rotation
	cameraPosition := system.rotate(cameraData.position, cameraData.rotation)

	cameraData.rl.target = cameraData.position
	cameraData.rl.position = cameraPosition
}

//* Hard sets the current position and target positions
set_position :: proc( pos : raylib.Vector3 ) {
	data.cameraData.position = pos
	data.cameraData.trgPosition = pos
}
//* Sets the target position
set_target_position :: proc( pos : raylib.Vector3 ) {
	data.cameraData.trgPosition = pos
}

//* Hard sets the current rotation and target rotations
set_rotation :: proc( rot : f32 ) {
	data.cameraData.rotation = rot
	data.cameraData.trgRotation = rot
}
//* Sets the target rotation
set_target_rotation :: proc( rot : f32 ) {
	data.cameraData.trgRotation = rot
}