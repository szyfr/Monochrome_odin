package player


//= Imports
import "../../game"
import "../camera"
import "../entity"


//= Procedures
init :: proc() {
	game.player = new(game.Player)

	game.player.entity		= entity.create( { 32, 0, 41 }, "player_1", "player" )
	game.player.moveTimer	= 0
	game.player.canMove		= true

	camera.focus(game.player.entity)
}

close :: proc() {
	free(game.player)
}