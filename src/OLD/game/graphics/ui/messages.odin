package ui


//= Imports
import "vendor:raylib"

import "../../../game"


//= Procedures
draw_messages :: proc() {
	offset : raylib.Vector2 = {f32(game.screenWidth) - 400, f32(game.screenHeight) - 200}

	for i:=0;i<len(game.battleData.messages);i+=1 {
		draw_npatch({offset.x, offset.y, 400, 88}, "textbox_general")
		draw_text({offset.x, offset.y, 400, 88}, game.battleData.messages[i].str)

		offset -= {0, 100}
		game.battleData.messages[i].time -= 1
		if game.battleData.messages[i].time <= 0 do remove_message(i)
	}
}

add_message :: proc( str : cstring ) {
	append(&game.battleData.messages, game.Message{str, 200})
}

remove_message :: proc( index : int ) {
	temp : [dynamic]game.Message

	for i:=0;i<len(game.battleData.messages);i+=1 {
		if i != index do append(&temp, game.battleData.messages[i])
	}

	delete(game.battleData.messages)
	game.battleData.messages = temp
}