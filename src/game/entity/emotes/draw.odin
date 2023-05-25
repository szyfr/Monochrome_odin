package emotes


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../../game"


//= Procedures
draw :: proc() {
	temp : [dynamic]game.EmoteStruct = make([dynamic]game.EmoteStruct)

	for i:=0;i<len(game.emoteList);i+=1 {
		raylib.DrawMesh(
			game.emoteList[i].mesh^,
			game.emoteList[i].material^,
			game.emoteList[i].transform,
		)
		game.emoteList[i].duration -= 1

		if game.emoteList[i].duration > 0 do append(&temp, game.emoteList[i])
	}
	delete(game.emoteList)
	game.emoteList = temp
}