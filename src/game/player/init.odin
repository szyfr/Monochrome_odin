package player


//= Imports
import "../../game"
import "../camera"
import "../entity/overworld"


//= Procedures
init :: proc() {
	game.player = new( game.Player )

	game.player.entity		= overworld.create( { 32, 0, 41 }, "player_1", "player" )
	game.player.moveTimer	= 0
	game.player.canMove		= true

	camera.focus( game.player.entity )
}

close :: proc() {
	free(game.player)
}