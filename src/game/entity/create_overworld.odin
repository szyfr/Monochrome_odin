package entity


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures
create :: proc(
	spriteName		: string,
	animationName	: string = "",
	position		: raylib.Vector3,
	id				: string = "",
) -> ^game.Entity {
	data := new(game.Entity)

	//* Position
	data.previous	= position
	data.position	= position
	data.target		= position

	//* NPC data
	data.id	= id

	//* Standee
	data.direction	= .down
	data.isMoving	= false
	data.isSurfing	= false

	data.mesh = &game.standeeMesh
	data.animator = animator.create(spriteName, animationName)

	return nil
}