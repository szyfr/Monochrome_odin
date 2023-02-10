package options


//= Imports
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

import "../../game"

import "../../debug"


//= Constants
OPTIONS_FILENAME :: "data/options.json"

OPTIONS_ERROR_LOADING :: "[ERROR]\t\t- Failed to locate settings file."
OPTIONS_ERROR_PARSE   :: "[ERROR]\t\t- Settings file invalid."


//= Procedures
init :: proc() {
	game.options = new(game.Options)
	
	rawFile,  rwResult := os.read_entire_file_from_filename(OPTIONS_FILENAME)
	jsonFile, jsResult := json.parse(rawFile)

	if jsResult != .None || !rwResult {
		if !rwResult do debug.add_to_log(OPTIONS_ERROR_LOADING)
		if jsResult != .None && rwResult do debug.add_to_log(OPTIONS_ERROR_PARSE)
		create_default()
		return
	}

	game.options.screenWidth  = i32(jsonFile.(json.Object)["screenwidth"].(f64))
	game.options.screenHeight = i32(jsonFile.(json.Object)["screenheight"].(f64))
	game.options.textSpeed    = i32(jsonFile.(json.Object)["textspeed"].(f64))
	game.options.fpsLimit     = i32(jsonFile.(json.Object)["fpslimit"].(f64))
	game.options.language     = jsonFile.(json.Object)["language"].(string)

	delete(rawFile)
}

create_default :: proc() {
	game.options.screenWidth  = 1280
	game.options.screenHeight =  720
	game.options.textSpeed    =    1
	game.options.fpsLimit     =   85
	game.options.language     = "english"
	save_options()
}

//TODO Create a library for doing this
save_options :: proc() {
	if os.exists(OPTIONS_FILENAME) do os.remove(OPTIONS_FILENAME)

	builder : strings.Builder

	strings.write_string(&builder, "{\n")

	strings.write_string(&builder, "\t\"screenwidth\":")
	strings.write_int(&builder, int(game.options.screenWidth))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"screenheight\":")
	strings.write_int(&builder, int(game.options.screenHeight))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"textspeed\":")
	strings.write_int(&builder, int(game.options.textSpeed))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"fpslimit\":")
	strings.write_int(&builder, int(game.options.fpsLimit))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"language\":\"")
	strings.write_string(&builder, game.options.language)
	strings.write_string(&builder, "\"\n")

	strings.write_string(&builder, "}")

	os.write_entire_file(OPTIONS_FILENAME, builder.buf[:])

	strings.builder_destroy(&builder)
}