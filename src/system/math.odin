package system


//= Imports
import "vendor:raylib"


//= Procedures

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