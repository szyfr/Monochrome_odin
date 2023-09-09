package localization


//= Imports
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

import "../game"
import "../debug"


//= Procedures
init :: proc() {
	game.localization = make(map[string]cstring, 1000)

	load_localization("data/core")
	load_localization("data/private")
}

close :: proc() {
	delete(game.localization)
}

load_localization :: proc(
	directory : string,
) {
	//* Check for directory
	if !os.exists(directory) {
		debug.logf("[ERROR] - %v missing.", directory)
		return
	}
	
	//* Check if language file exists in directory
	fileLocation := strings.concatenate({directory, "/localization/", game.language, ".json"})
	if !os.exists(fileLocation) {
		debug.logf("[ERROR] - Localization file %v missing.", fileLocation)
		return
	}

	//* Load data from file and check
	rawFile,  rwResult := os.read_entire_file_from_filename(fileLocation)
	jsonFile, jsResult := json.parse(rawFile)
	if jsResult != .None {
		debug.log("[ERROR] - Localization file invalid.")
		return
	}

	for obj in jsonFile.(json.Object) {
		str := jsonFile.(json.Object)[obj].(string)
		game.localization[obj] = strings.clone_to_cstring(str)
	}
}