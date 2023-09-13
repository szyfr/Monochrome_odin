package settings


//= Imports
import "core:encoding/json"
import "core:os"
import "core:strings"

import "vendor:raylib"

import "../data"
import "../system"
import "../debug"


//= Procedures
load :: proc() {
	if !os.is_file("settings.json") {
		debug.log("[WARNING] - Failed to find settings.json. Creating new file.")
		save_settings_from_default()
	}
	load_settings_from_file()
}

load_settings_from_file :: proc() {
	file := system.load_json("settings.json")

	screen_width	= i32(file["screen_width"].(f64))
	screen_height	= i32(file["screen_height"].(f64))
	screen_fps		= i32(file["screen_fps"].(f64))
	language		= data.Language(file["language"].(f64))

	keybinds := file["keybindings"].(json.Object)
	for bind in keybinds {
		kb : data.Keybinding = {}
		kb.origin		= data.Origin(keybinds[bind].(json.Array)[0].(f64))
		kb.controller	= i32(keybinds[bind].(json.Array)[1].(f64))
		kb.code			= u32(keybinds[bind].(json.Array)[2].(f64))

		keybindings[bind] = kb
	}
}

save_settings_from_default :: proc() {
	start : json.Object

	start["screen_width"] = 1280
	start["screen_height"] = 720
	start["screen_fps"] = 80
	start["language"] = 0

	kb : json.Object
	kb["up"]			= json.Array{0,0,87}
	kb["down"]			= json.Array{0,0,83}
	kb["left"]			= json.Array{0,0,65}
	kb["right"]			= json.Array{0,0,68}
	kb["rotate_right"]	= json.Array{0,0,69}
	kb["rotate_left"]	= json.Array{0,0,81}
	kb["confirm"]		= json.Array{0,0,257}
	start["keybindings"] = kb
	
	system.save_json("settings.json", start)
}

close :: proc() {
	delete(keybindings)
}