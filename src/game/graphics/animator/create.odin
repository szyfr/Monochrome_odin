package animator


//= Imports
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

import "vendor:raylib"

import "../../../game"
import "../../../debug"


//= Procedures
create :: proc(
	spriteName		: string,
	animationName	: string,
) -> game.Animator {
	data : game.Animator = {}

	//* Defaults
	data.currentAnimation = "walk_down"
	data.frame = 0
	data.timer = 0

	//* Create sprite filepath
	img : raylib.Image
	privateSpriteName := strings.concatenate({
		"data/private/sprites/overworld/spr_",
		spriteName,
		".png",
	})
	coreSpriteName := strings.concatenate({
		"data/core/sprites/overworld/spr_",
		spriteName,
		".png",
	})

	//* Load sprite from file
	if os.exists(privateSpriteName) {
		img = raylib.LoadImage(strings.clone_to_cstring(privateSpriteName))
	} else if os.exists(coreSpriteName) {
		img = raylib.LoadImage(strings.clone_to_cstring(coreSpriteName))
	} else {
		debug.logf("[ERROR] - Failed to find %v in either Private or Core.", spriteName)
		game.running = false
		return {}
	}

	//* Load textures
	dim := img.height
	numOfSprites := img.width / dim
	for i:i32=0;i<numOfSprites;i+=1 {
		spr := raylib.ImageFromImage(img, {f32(i)*f32(dim), 0, f32(dim), f32(dim)})
		append(&data.textures, raylib.LoadTextureFromImage(spr))
		raylib.UnloadImage(spr)
	}
	raylib.UnloadImage(img)
	
	data.material = raylib.LoadMaterialDefault()
	data.material.maps[0].texture = data.textures[0]

	//* Create Animation path
	rawData : []u8
	privateAnimationName := strings.concatenate({
		"data/private/animations/ani_",
		animationName,
		".json",
	})
	coreAnimationName := strings.concatenate({
		"data/core/animations/ani_",
		animationName,
		".json",
	})

	//* Load animation data
	if os.exists(privateAnimationName) {
		rawData, _ = os.read_entire_file_from_filename(privateAnimationName)
	} else if os.exists(coreAnimationName) {
		rawData, _ = os.read_entire_file_from_filename(coreAnimationName)
	} else {
		debug.logf("[ERROR] - Failed to find %v in either Private or Core.", animationName)
		game.running = false
		return {}
	}

	//* Parse data
	js, err := json.parse(rawData)
	for animation in js.(json.Object) {
		array := js.(json.Object)[animation].(json.Array)
		ani : game.Animation = {
			animationSpeed = u32(array[0].(f64)),
		}
		for i:=1;i<len(array);i+=1 do append(&ani.frames, u32(array[i].(f64)))
		data.animations[animation] = ani
	}

	return data
}