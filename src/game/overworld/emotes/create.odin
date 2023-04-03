package emotes


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../../game"


//= Procedures
create :: proc(
	position : raylib.Vector3,
	duration : int,
	emote	 : game.Emote,
) {
	mat : raylib.Matrix = {
		1.00,  0.00, 0.00, 0.00,
		0.00,  0.78, 0.80, 0.00,
		0.00, -0.80, 0.78, 0.00,
		0.00,  0.00, 0.00, 1.00,
	}
	mat[3,0] = position.x + 0.5
	mat[3,1] = position.y + 1.5
	mat[3,2] = position.z 

	emote : game.EmoteStruct = {
		transform	=  mat,
		mesh		= &game.emoteMeshDef,
		material	= &game.emoteMaterials[int(emote)],
		duration	=  duration,
	}

	append(&game.emoteList, emote)
}