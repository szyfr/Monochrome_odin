package standee


//= Imports
import "core:encoding/json"
import "core:os"
import "core:strings"

import "vendor:raylib"

import "../sprites/animations"


//= Procedures
create :: proc(
	filename : string,
) -> ^Standee {
	standee := new(Standee)

	standee.mesh     = raylib.GenMeshPlane(1,1,1,1)
	standee.material = raylib.LoadMaterialDefault();
	standee.position = {
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		0,0,0,1,
	}

	fullpath_image     := strings.clone_to_cstring(strings.concatenate({"data/sprites/spr_", filename, ".png"}))
	fullpath_animation := strings.concatenate({"data/sprites/ani_", filename, ".json"})

	standee.animator.rawImage = raylib.LoadImage(fullpath_image)
	standee.animator.currentAnimation = ""
	standee.animator.frame = 0
	standee.animator.timer = 0

	raw, er := os.read_entire_file_from_filename(fullpath_animation)
	js, err := json.parse(raw)
	for animation in js.(json.Object) {
		standee.animator.animations[animation] = animations.create(js.(json.Object)[animation].(json.Array))
	}

	return standee
}

create_animation :: proc(
	array : json.Array,
) -> animations.Animation {
	ani : animations.Animation = { animationSpeed = u32(array[0].(f64)) }

	for i:=1;i<len(array);i+=1 do append(&ani.frames, u32(array[i].(f64)))

	return ani
}