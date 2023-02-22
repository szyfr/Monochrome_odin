package player


//= Imports
import "core:fmt"
import "vendor:raylib"

import "../../game"
import "../../game/entity"


//= Procedures
init :: proc() {
	game.player = new(game.Player)

	game.player.entity		= entity.create( "player_1", { 27, 0, 12 } )
	game.player.moveTimer	= 0
	game.player.canMove		= true

	game.camera.targetEntity = game.player.entity
}

close :: proc() {
	free(game.player)
}