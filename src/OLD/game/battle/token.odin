package battle


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures

// TODO Create a creation function

token_position :: proc( token : game.Token ) -> raylib.Vector2 {
	return {token.entity.position.x - 8, token.entity.position.z - 55.75}
}

spot_empty :: proc( position : raylib.Vector2 ) -> bool {
	output : bool = true

	//* Check for token
	for ent in game.battleData.field {
		if token_position(game.battleData.field[ent]) == position && game.battleData.field[ent].type != .hazard {
			output = false
		}
	}
	//* Check for edge
	if position.x < 0 || position.x > 15 || position.y < 0 || position.y > 7 do output = false


	return output
}