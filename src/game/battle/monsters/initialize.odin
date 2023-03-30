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
	rawFile,  rwResult := os.read_entire_file_from_filename("data/pokemon.json")
	if !rwResult {
		debug.add_to_log("[ERROR]\t\t- Failed to locate Pokemon file.")
		return
	}

	//* Parsing JSON5
	jsonFile, jsResult := json.parse(rawFile)
	if jsResult != .None {
		debug.add_to_log("[ERROR]\t\t- Pokemon file invalid.")
		return
	}

	game.pokemonData = jsonFile.(json.Object)["list"].(json.Array)

	delete(rawFile)
}

get_exp_yield :: proc(
	species : game.MonsterSpecies,
) -> f32 {
	return f32(game.pokemonData[int(species)].(json.Array)[10].(f64))
}