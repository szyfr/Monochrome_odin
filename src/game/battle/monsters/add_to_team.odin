package monsters


//= Imports
import "../../../game"


//= Procedures
add_to_team :: proc(
	monster : game.Monster,
) {
	//for pkmn in game.player.monster {
	for i:=0;i<4;i+=1 {
		if game.player.monster[i].species == .empty {
			game.player.monster[i] = monster
			return
		}
	}
	//TODO Boxes stuff
}