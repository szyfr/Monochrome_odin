package mathz


//= Imports
import "vendor:raylib"


//= Procedures

to_v2 :: proc{ to_v2_v3, to_v2_direction,  }
to_v2_v3 :: proc(
	vec3 : raylib.Vector3,
) -> raylib.Vector2 {
	return {vec3.x, vec3.z}
}
to_v2_direction :: proc(
	direction : int,
) -> raylib.Vector2 {
	switch direction {
		case 0:	return { 0,-1}
		case 1:	return { 0, 1}
		case 2:	return {-1, 0}
		case 3:	return { 1, 0}
	}
	return {0,0}
}