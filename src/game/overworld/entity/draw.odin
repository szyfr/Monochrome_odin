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

draw_emotes :: proc() {
	for i:=0;i<len(game.emoteList);i+=1 {
		xDist := game.player.entity.position.x - game.emoteList[i].charPos.x
		yDist := game.player.entity.position.z - game.emoteList[i].charPos.y
		rect : raylib.Rectangle = {
			game.emoteList[i].dest.x + (50   * xDist),
			game.emoteList[i].dest.y + (12.5 * yDist),
			game.emoteList[i].dest.width,
			game.emoteList[i].dest.height,
		}
		rev : int = game.emoteList[i].maxDuration - EMOTE_ANIM_LEN
		if game.emoteList[i].duration > rev {
			rect.y += ((f32(game.emoteList[i].duration - rev) / f32(rev)) * 60)
		}
		if game.emoteList[i].player do rect.x += 32
		if xDist == 1  do rect.x -= 50
		if xDist == -1 do rect.x += 50
		raylib.DrawTexturePro(
			game.emotes,
			game.emoteList[i].src,
			rect,
			{0,0}, 0,
			raylib.WHITE,
		)
		game.emoteList[i].duration -= 1
	}
	temp : [dynamic]game.EmoteStruct = make([dynamic]game.EmoteStruct)
	for i:=0;i<len(game.emoteList);i+=1 {
		if game.emoteList[i].duration > 0 {
			append(&temp, game.emoteList[i])
		}
	}
	delete(game.emoteList)
	game.emoteList = temp
}