package entity


//= Imports
import "core:fmt"
import "core:math/linalg"

import "vendor:raylib"

import "../../../game"
import "../../overworld/standee"
import "../../../utilities/mathz"


//= Constants
EMOTE_ANIM_LEN :: 5


//= Procedures
draw :: proc(
	entity : ^game.Entity,
) {
	entity.standee.position[3,0] = entity.position.x + 0.5
	entity.standee.position[3,1] = entity.position.y + 0.5
	entity.standee.position[3,2] = entity.position.z + 0.5
	standee.draw(entity.standee)
}