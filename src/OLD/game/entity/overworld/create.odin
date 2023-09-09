package overworld


//= Imports
import "vendor:raylib"

import "../../../game"
import "../../graphics/animator"


//= Procedures
create :: proc(
	position		: raylib.Vector3	= {0,0,0},
	spriteName		: string			= "player_1",
	animationName	: string			= "general",
	id				: string			= "",
) -> ^game.Entity {
	data := new( game.Entity )

	//* Position
	data.previous	= position
	data.position	= position
	data.target		= position

	//* Entity data
	data.id	= id

	//* Standee
	data.direction	= .down
	data.isMoving	= false
	data.isSurfing	= false

	data.mesh = &game.standeeMesh
	data.animator = animator.create(spriteName, animationName)

	return data
}