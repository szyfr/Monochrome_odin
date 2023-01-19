package sprites


//= Imports
import "core:encoding/json"
import "core:fmt"
import "core:strings"
import "core:os"

import "vendor:raylib"

import "animations"


//= Procedures
create :: proc{ create_texture, create_string }
create_string :: proc(
	filename : string,
) -> ^Sprite {
	spr := new(Sprite)

	fullpath_texture   := strings.clone_to_cstring(strings.concatenate({"data/sprites/spr_", filename, ".png"}))
	fullpath_animation := strings.concatenate({"data/sprites/ani_", filename, ".json"})
	
	spr.texture = raylib.LoadTexture(fullpath_texture)
	spr.size    = {
		f32(spr.texture.height),
		f32(spr.texture.height),
	}

	raw, er := os.read_entire_file_from_filename(fullpath_animation)
	js, err := json.parse(raw)
	spr.animator = {
		currentAnimation = "walk_down",
		frame = 0,
		timer = 0,
	}
	for animation in js.(json.Object) {
		spr.animator.animations[animation] = animations.create(js.(json.Object)[animation].(json.Array))
	}

	return spr
}
create_texture :: proc(
	texture : raylib.Texture2D,
) -> ^Sprite {
	spr := new(Sprite)

	spr.texture = texture
	spr.size    = {
		f32(spr.texture.height),
		f32(spr.texture.height),
	}
	spr.animator = {}

	return spr
}