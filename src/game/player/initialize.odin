package player


//= Imports
import "../../game"
import "../camera"
import "../entity"


//= Procedures
init :: proc() {
	game.player = new(game.Player)

	game.player.entity		= entity.create( "player_1", { 32, 0, 41 } )
	game.player.moveTimer	= 0
	game.player.canMove		= true

	camera.focus(game.player.entity)
}

close :: proc() {
	free(game.player)
}