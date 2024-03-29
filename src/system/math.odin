package system


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../data"


//= Constants
XDIST   ::   0.0
YDIST   ::   5.0
ZDIST   ::   5.0


//= Procedures
normalize :: proc( v3 : raylib.Vector3 ) -> raylib.Vector3 {
	max, min : f32 = 1,1

	if v3.x > max do max = v3.x
	if v3.y > max do max = v3.y
	if v3.z > max do max = v3.z

	if v3.x < min do min = v3.x
	if v3.y < min do min = v3.y
	if v3.z < min do min = v3.z

	if max > min do return {v3.x/max, v3.y/max, v3.z/max}
	else do return {v3.x/min, v3.y/min, v3.z/min}
}
rotate :: proc( pos : raylib.Vector3, rot : f32 ) -> raylib.Vector3 {
	position : raylib.Vector3 = {}

	position.x = XDIST * math.cos(rot / 57.3) - ZDIST * math.sin(rot / 57.3)
	position.z = XDIST * math.sin(rot / 57.3) + ZDIST * math.cos(rot / 57.3)
	
	position.x += pos.x
	position.y = (pos.y + YDIST)
	position.z += pos.z

	return position
}

close_enough :: proc{ close_enough_v3, close_enough_v2, close_enough_f32 }
close_enough_v3 :: proc( v1,v2 : raylib.Vector3, offset : f32 = 0.05 ) -> bool {
	if v1.x < v2.x - offset do return false
	if v1.x > v2.x + offset do return false

	if v1.y < v2.y - offset do return false
	if v1.y > v2.y + offset do return false

	if v1.z < v2.z - offset do return false
	if v1.z > v2.z + offset do return false

	return true
}
close_enough_v2 :: proc( v1,v2 : raylib.Vector2, offset : f32 = 0.05 ) -> bool {
	if v1.x < v2.x - offset do return false
	if v1.x > v2.x + offset do return false

	if v1.y < v2.y - offset do return false
	if v1.y > v2.y + offset do return false

	return true
}
close_enough_f32 :: proc( f1,f2 : f32, offset : f32 = 0.05 ) -> bool {
	if f1 < f2 - offset do return false
	if f1 > f2 + offset do return false

	return true
}

get_direction :: proc{ get_direction_v3, get_direction_f32 }
get_direction_v3 :: proc( v1,v2 : raylib.Vector3 ) -> raylib.Vector3 {
	difference := v2 - v1
	output : raylib.Vector3

	if difference.x  > 0 do output.x =  1
	if difference.x == 0 do output.x =  0
	if difference.x  < 0 do output.x = -1

	if difference.y  > 0 do output.y =  1
	if difference.y == 0 do output.y =  0
	if difference.y  < 0 do output.y = -1

	if difference.z  > 0 do output.z =  1
	if difference.z == 0 do output.z =  0
	if difference.z  < 0 do output.z = -1

	return output
}
get_direction_f32 :: proc( v1,v2 : f32 ) -> f32 {
	difference := v2 - v1

	if difference  > 0 do return  1
	if difference  < 0 do return -1

	return 0
}

round :: proc{ round_v3 }
round_v3 :: proc( v3 : raylib.Vector3 ) -> raylib.Vector3 {
	return {math.round(v3.x), math.round(v3.y), math.round(v3.z)}
}

//get_relative_direction :: proc{ get_relative_direction_dire, get_relative_direction_vec3 }
get_relative_direction_dire :: proc( direction : data.Direction ) -> data.Direction {
	switch data.cameraData.rotation {
		case   0:
			if direction == .north do return .north
			if direction == .south do return .south
			if direction == .east  do return .east 
			if direction == .west  do return .west 
		case  90:
			if direction == .north do return .east
			if direction == .south do return .west
			if direction == .east  do return .south 
			if direction == .west  do return .north 
		case 180:
			if direction == .north do return .south
			if direction == .south do return .north
			if direction == .east  do return .west 
			if direction == .west  do return .east 
		case 270:
			if direction == .north do return .west
			if direction == .south do return .east
			if direction == .east  do return .north 
			if direction == .west  do return .south 
	}
	return .south
}
get_relative_direction_vec3 :: proc( direction : data.Direction ) -> raylib.Vector3 {
	output : raylib.Vector3 = {}
	switch data.cameraData.rotation {
		case   0:
			if direction == .north do output.z = -1
			if direction == .south do output.z =  1
			if direction == .east  do output.x = -1
			if direction == .west  do output.x =  1
		case  90:
			if direction == .north do output.x =  1
			if direction == .south do output.x = -1
			if direction == .east  do output.z = -1
			if direction == .west  do output.z =  1
		case 180:
			if direction == .north do output.z =  1
			if direction == .south do output.z = -1
			if direction == .east  do output.x =  1
			if direction == .west  do output.x = -1
		case 270:
			if direction == .north do output.x = -1
			if direction == .south do output.x =  1
			if direction == .east  do output.z =  1
			if direction == .west  do output.z = -1
	}
	return output
}