package localization


//= Imports
import "core:bytes"
import "core:compress/gzip"
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:slice"

import "vendor:raylib"

import "../../../game"

import "../../../debug"


//= Constants
LOCALIZATION_FILENAME        :: "data/localization/"
LOCALIZATION_EXT             :: ".json"
LOCALIZATION_COMP_EXT        :: ".bin"

LOCALIZATION_ERROR_FILE      :: "[ERROR]\t\t- Failed to locate localization for selected language."
LOCALIZATION_ERROR_FILE_CRIT :: "[ERROR][CRITICAL]\t- Failed to locate localization for selected language."


//= Procedures
init :: proc() {
	game.localization = make(map[string]cstring, 1000)
	fileLocation := strings.concatenate({LOCALIZATION_FILENAME, game.language, LOCALIZATION_EXT})

	if !os.exists(fileLocation) {
		debug.add_to_log(LOCALIZATION_ERROR_FILE)

		fileLocation = strings.concatenate({LOCALIZATION_FILENAME, "english", LOCALIZATION_EXT})

		if !os.exists(fileLocation) {
			debug.add_to_log(LOCALIZATION_ERROR_FILE_CRIT)

			game.running = false
			return
		}
	}
	
	rawFile,  rwResult := os.read_entire_file_from_filename(fileLocation)
	jsonFile, jsResult := json.parse(rawFile)

	for obj in jsonFile.(json.Object) {
		game.localization[obj] = strings.clone_to_cstring(jsonFile.(json.Object)[obj].(string))
	}
}