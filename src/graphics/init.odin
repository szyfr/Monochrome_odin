package graphics


//= Imports
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json"

import "vendor:raylib"

import "../debug"
import "../data"


//= Procedures
init_textures :: proc() {
	textures["overworld_player"] = raylib.LoadTexture("data/old/sprites/spr_player_1.png")
}

init_animations :: proc() {
	//* Check for file and load
	if !os.is_file("data/sprites/animations.json") {
		debug.logf("[WARNING] - Failed to find Animations file.")
		return
	}
	file, _ := os.read_entire_file("data/sprites/animations.json")
	fileJson, ok := json.parse(file)

	//* Parse json for animations
	for anim in fileJson.(json.Object) {
		animation : data.Animation = {}

		animation.delay = int(fileJson.(json.Object)[anim].(json.Array)[0].(f64))
		for i:=0;i<len(fileJson.(json.Object)[anim].(json.Array)[1].(json.Array));i+=1 {
			append(&animation.frames, int(fileJson.(json.Object)[anim].(json.Array)[1].(json.Array)[i].(f64)))
		}

		animations[strings.clone(anim)] = animation
	}

	//* Cleanup
	json.destroy_value(fileJson)
	delete(file)
}