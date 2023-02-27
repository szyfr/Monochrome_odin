package monsters


//= Imports
import "../../../game"


//= Procedures
add_to_team :: proc(
	pokemon : game.Pokemon,
) {
	//for pkmn in game.player.pokemon {
	for i:=0;i<4;i+=1 {
		if game.player.pokemon[i].species == .empty {
			game.player.pokemon[i] = pokemon
			return
		}
	}
	//TODO Boxes stuff
}