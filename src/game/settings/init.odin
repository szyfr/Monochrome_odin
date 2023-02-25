package settings


//= Imports
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

import "../../game"

import "../../debug"


//= Constants
SETTINGS_FILENAME :: "data/settings.json"

SETTINGS_ORIGIN			:: "origin"
SETTINGS_KEY			:: "key"

SETTINGS_ERROR_LOADING :: "[ERROR]\t\t- Failed to locate settings file."
SETTINGS_ERROR_PARSE   :: "[ERROR]\t\t- Settings file invalid."


//= Procedures
init :: proc() {
	game.settings = new(game.Settings)
	
	rawFile,  rwResult := os.read_entire_file_from_filename(SETTINGS_FILENAME)
	jsonFile, jsResult := json.parse(rawFile)

	if jsResult != .None || !rwResult {
		if !rwResult do debug.add_to_log(SETTINGS_ERROR_LOADING)
		if jsResult != .None && rwResult do debug.add_to_log(SETTINGS_ERROR_PARSE)
		create_default()
		return
	}

	game.settings.screenWidth  = i32(jsonFile.(json.Object)["screenwidth"].(f64))
	game.settings.screenHeight = i32(jsonFile.(json.Object)["screenheight"].(f64))
	game.settings.textSpeed    = i32(jsonFile.(json.Object)["textspeed"].(f64))
	game.settings.fpsLimit     = i32(jsonFile.(json.Object)["fpslimit"].(f64))
	game.settings.language     = jsonFile.(json.Object)["language"].(string)

	kebindingJson := jsonFile.(json.Object)["keybindings"].(json.Array)
	for mem in kebindingJson {
		binding : game.Keybinding = {
			origin	= u8(mem.(json.Array)[1].(f64)),
			key		= u32(mem.(json.Array)[2].(f64)),
		}
		game.settings.keybindings[mem.(json.Array)[0].(string)] = binding
	}
	game.settings.keybindings["debug"] = {0,79}

	delete(rawFile)
}

create_default :: proc() {
	game.settings.screenWidth  = 1280
	game.settings.screenHeight =  720
	game.settings.textSpeed    =    1
	game.settings.fpsLimit     =   60
	game.settings.language     = "english"

	game.settings.keybindings["up"] = {0,87}
	game.settings.keybindings["down"] = {0,83}
	game.settings.keybindings["left"] = {0,65}
	game.settings.keybindings["right"] = {0,68}
	
	game.settings.keybindings["attack"] = {1,0}
	game.settings.keybindings["switch_attack_left"] = {0,81}
	game.settings.keybindings["switch_attack_right"] = {0,69}
	
	game.settings.keybindings["interact"] = {0,32}
	game.settings.keybindings["cancel"] = {0,256}

	save_settings()
}

//TODO Create a library for doing this
save_settings :: proc() {
	if os.exists(SETTINGS_FILENAME) do os.remove(SETTINGS_FILENAME)

	builder : strings.Builder

	strings.write_string(&builder, "{\n")

	strings.write_string(&builder, "\t\"screenwidth\":")
	strings.write_int(&builder, int(game.settings.screenWidth))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"screenheight\":")
	strings.write_int(&builder, int(game.settings.screenHeight))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"textspeed\":")
	strings.write_int(&builder, int(game.settings.textSpeed))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"fpslimit\":")
	strings.write_int(&builder, int(game.settings.fpsLimit))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"language\":\"")
	strings.write_string(&builder, game.settings.language)
	strings.write_string(&builder, "\",\n")

	strings.write_string(&builder, "\t\"keybindings\": [\n")
	for mem in game.settings.keybindings {
		strings.write_string(&builder, "\t\t[\"")
		strings.write_string(&builder, mem)
		strings.write_string(&builder, "\",")
		strings.write_int(&builder, int(game.settings.keybindings[mem].origin))
		strings.write_string(&builder, ",")
		strings.write_int(&builder, int(game.settings.keybindings[mem].key))
		strings.write_string(&builder, "],\n")
	}
	strings.write_string(&builder, "\t]\n")

	strings.write_string(&builder, "}")

	os.write_entire_file(SETTINGS_FILENAME, builder.buf[:])

	strings.builder_destroy(&builder)
}