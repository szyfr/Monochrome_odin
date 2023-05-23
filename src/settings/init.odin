package settings


//= Imports
import "core:encoding/json"
import "core:os"
import "core:strings"

import "../game"
import "../debug"


//= Procedures
init :: proc() {
	//* Load File
	rawFile, rwResult := os.read_entire_file_from_filename("settings.json")
	if !rwResult {
		debug.log("[ERROR] - Failed to locate settings file.")
		create_default()
		return
	}

	//* Parse JSON5
	jsonFile, jsResult := json.parse(rawFile)
	if jsResult != .None {
		debug.log("[ERROR] - Settings file invalid.")
		create_default()
		return
	}

	//* Setting variables
	game.screenWidth	= i32(jsonFile.(json.Object)["screenwidth"].(f64))
	game.screenHeight	= i32(jsonFile.(json.Object)["screenheight"].(f64))
	game.textSpeed		= i32(jsonFile.(json.Object)["textspeed"].(f64))
	game.fpsLimit		= i32(jsonFile.(json.Object)["fpslimit"].(f64))
	game.language		= jsonFile.(json.Object)["language"].(string)
	game.masterVolume	= f32(jsonFile.(json.Object)["mastervolume"].(f64)) / 100
	game.musicVolume	= f32(jsonFile.(json.Object)["musicvolume"].(f64)) / 100
	game.soundVolume	= f32(jsonFile.(json.Object)["soundvolume"].(f64)) / 100

	kebindingJson := jsonFile.(json.Object)["keybindings"].(json.Array)
	for mem in kebindingJson {
		binding : game.Keybinding = {
			origin	= u8(mem.(json.Array)[1].(f64)),
			key		= u32(mem.(json.Array)[2].(f64)),
		}
		game.keybindings[mem.(json.Array)[0].(string)] = binding
	}

	delete(rawFile)
}

create_default :: proc() {
	game.screenWidth  = 1280
	game.screenHeight =  720
	game.textSpeed    =    1
	game.fpsLimit     =   80
	game.language     = "english"

	game.keybindings["up"] = {0,87}
	game.keybindings["down"] = {0,83}
	game.keybindings["left"] = {0,65}
	game.keybindings["right"] = {0,68}
	
	game.keybindings["attack"] = {1,0}
	game.keybindings["switch_attack_left"] = {0,81}
	game.keybindings["switch_attack_right"] = {0,69}
	
	game.keybindings["interact"] = {0,32}
	game.keybindings["cancel"] = {0,256}
	game.keybindings["pause"] = {0,257}

	save_settings()
}

//TODO Create a library for doing this
save_settings :: proc() {
	if os.exists("settings.json") do os.remove("settings.json")

	builder : strings.Builder

	strings.write_string(&builder, "{\n")

	strings.write_string(&builder, "\t\"screenwidth\":")
	strings.write_int(&builder, int(game.screenWidth))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"screenheight\":")
	strings.write_int(&builder, int(game.screenHeight))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"textspeed\":")
	strings.write_int(&builder, int(game.textSpeed))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"fpslimit\":")
	strings.write_int(&builder, int(game.fpsLimit))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"mastervolume\":")
	strings.write_int(&builder, int(game.masterVolume))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"musicvolume\":")
	strings.write_int(&builder, int(game.musicVolume))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"soundvolume\":")
	strings.write_int(&builder, int(game.soundVolume))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"language\":\"")
	strings.write_string(&builder, game.language)
	strings.write_string(&builder, "\",\n")

	strings.write_string(&builder, "\t\"keybindings\": [\n")
	for mem in game.keybindings {
		strings.write_string(&builder, "\t\t[\"")
		strings.write_string(&builder, mem)
		strings.write_string(&builder, "\",")
		strings.write_int(&builder, int(game.keybindings[mem].origin))
		strings.write_string(&builder, ",")
		strings.write_int(&builder, int(game.keybindings[mem].key))
		strings.write_string(&builder, "],\n")
	}
	strings.write_string(&builder, "\t]\n")

	strings.write_string(&builder, "}")

	os.write_entire_file("settings.json", builder.buf[:])

	strings.builder_destroy(&builder)
}