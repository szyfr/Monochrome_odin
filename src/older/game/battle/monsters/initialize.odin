package monsters


//= Imports
import "core:fmt"
import "core:encoding/json"
import "core:os"

import "../../../game"
import "../../../debug"


//= Procedures
init :: proc() {
	//* Loading file
	rawFile,  rwResult := os.read_entire_file_from_filename("data/monster.json")
	if !rwResult {
		debug.add_to_log("[ERROR]\t\t- Failed to locate Monster file.")
		return
	}

	//* Parsing JSON5
	jsonFile, jsResult := json.parse(rawFile)
	if jsResult != .None {
		debug.add_to_log("[ERROR]\t\t- Monster file invalid.")
		return
	}

	game.monsterData = jsonFile.(json.Object)["list"].(json.Array)

	delete(rawFile)
}

get_exp_yield :: proc(
	species : game.MonsterSpecies,
) -> f32 {
	return f32(game.monsterData[int(species)].(json.Array)[10].(f64))
}