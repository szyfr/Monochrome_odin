package ui


//= Imports
import "core:strings"
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../../monsters"
import "../../../game"


//= Procedures

//* Custom N_Patch function to account for scaling the textures
draw_npatch :: proc( rect : raylib.Rectangle, texture : string ) {
	//* Row 1
	raylib.DrawTexturePro(
		game.graphicsUI[texture],
		{0,0,16,16},
		{rect.x * game.screenRatio, rect.y * game.screenRatio, 64 * game.screenRatio, 64 * game.screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)
	raylib.DrawTexturePro(
		game.graphicsUI[texture],
		{16,0,16,16},
		{(rect.x + 64) * game.screenRatio, rect.y * game.screenRatio, (rect.width - 128) * game.screenRatio, 64 * game.screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)
	raylib.DrawTexturePro(
		game.graphicsUI[texture],
		{32,0,16,16},
		{(rect.x + rect.width - 64) * game.screenRatio, rect.y * game.screenRatio, 64 * game.screenRatio, 64 * game.screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Row 2
	raylib.DrawTexturePro(
		game.graphicsUI[texture],
		{0,16,16,16},
		{rect.x * game.screenRatio, (rect.y + 64) * game.screenRatio, 64 * game.screenRatio, (rect.height - 128) * game.screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)
	raylib.DrawTexturePro(
		game.graphicsUI[texture],
		{16,16,16,16},
		{(rect.x + 64) * game.screenRatio, (rect.y + 64) * game.screenRatio, (rect.width - 128) * game.screenRatio, (rect.height - 128) * game.screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)
	raylib.DrawTexturePro(
		game.graphicsUI[texture],
		{32,16,16,16},
		{(rect.x + rect.width - 64) * game.screenRatio, (rect.y + 64) * game.screenRatio, 64 * game.screenRatio, (rect.height - 128) * game.screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Row 3
	raylib.DrawTexturePro(
		game.graphicsUI[texture],
		{0,32,16,16},
		{rect.x * game.screenRatio, (rect.y + rect.height - 64) * game.screenRatio, 64 * game.screenRatio, 64 * game.screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)
	raylib.DrawTexturePro(
		game.graphicsUI[texture],
		{16,32,16,16},
		{(rect.x + 64) * game.screenRatio, (rect.y + rect.height - 64) * game.screenRatio, (rect.width - 128) * game.screenRatio, 64 * game.screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)
	raylib.DrawTexturePro(
		game.graphicsUI[texture],
		{32,32,16,16},
		{(rect.x + rect.width - 64) * game.screenRatio, (rect.y + rect.height - 64) * game.screenRatio, 64 * game.screenRatio, 64 * game.screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)
}

draw_sprite :: proc( rect : raylib.Rectangle, sprite : raylib.Vector2, color : raylib.Color, texture : string ) {
	raylib.DrawTexturePro(
		game.graphicsUI[texture],
		{sprite.x * 16, sprite.y * 16, 16, 16},
		{rect.x * game.screenRatio, rect.y * game.screenRatio, rect.width * game.screenRatio, rect.height * game.screenRatio},
		{0,0},
		0,
		color,
	)
}

draw_text :: proc( rect : raylib.Rectangle, input : cstring, plain : bool = false ) {
	position : raylib.Vector2
	if !plain do position = {
		rect.x + ((rect.width / 2) - ((f32(len(input)) * 16) / 2)),
		rect.y + ((rect.height / 2) - 6), // TODO Temp
	}
	else do position = {rect.x, rect.y}
	raylib.DrawTextPro(
		game.font,
		input,
		position * game.screenRatio,
		{0,0},
		0,
		16 * game.screenRatio,
		0,
		{56, 56, 56, 255},
	)
}

draw_bar_battle :: proc( rect : raylib.Rectangle, monster : ^game.Monster, stat : u8, player : bool ) {
	graphic	: ^game.BarGraphic
	builder : strings.Builder
	title	: cstring
	cstr	: cstring
	ratio	: f32
	color	: raylib.Color
	offset	: f32
	
	if player {
		switch stat {
			case 0: //* HP
				graphic = &game.playerBarHP
				ratio	= f32(monster.hpCur) / f32(monster.hpMax)
				color	= {247, 82, 49, 255}
				title	= "HP:"
				offset	= 60

				str := fmt.sbprintf(&builder, "%v / %v", monster.hpCur, monster.hpMax)
				cstr = strings.clone_to_cstring(str)
				delete(str)
			case 1: //* Stamina
				graphic = &game.playerBarST
				ratio	= f32(monster.stCur) / f32(monster.stMax)
				color	= {255, 255, 58, 255}
				title	= "ST:"
				offset	= 60

				str := fmt.sbprintf(&builder, "%v / %v", monster.stCur, monster.stMax)
				cstr = strings.clone_to_cstring(str)
				delete(str)
			case 2: //* EXP
				graphic = &game.playerBarXP
				lv			:= f32(monsters.calculate_experience(monster.level, monster.rate))
				currentExp	:= f32(monster.experience)
				nextExp		:= f32(monsters.calculate_experience(monster.level+1, monster.rate))
				ratio	= (currentExp - lv) / (nextExp - lv)
				color	= {99, 206, 8, 255}

				str := fmt.sbprintf(&builder, "%v", int(currentExp - lv))
				cstr = strings.clone_to_cstring(str)
				delete(str)
		}
	} else {
		switch stat {
			case 0: //* HP
				graphic = &game.enemyBarHP
				ratio	= f32(monster.hpCur) / f32(monster.hpMax)
				color	= {247, 82, 49, 255}
				title	= "HP:"
				offset	= 60

				str := fmt.sbprintf(&builder, "%v / %v", monster.hpCur, monster.hpMax)
				cstr = strings.clone_to_cstring(str)
				delete(str)
			case 1: //* Stamina
				graphic = &game.enemyBarST
				ratio	= f32(monster.stCur) / f32(monster.stMax)
				color	= {255, 255, 58, 255}
				title	= "ST:"
				offset	= 60

				str := fmt.sbprintf(&builder, "%v / %v", monster.stCur, monster.stMax)
				cstr = strings.clone_to_cstring(str)
				delete(str)
		}
	}

	//* Create bar
	if graphic.ratio != ratio {
		raylib.UnloadImage(graphic.image)
		graphic.image = raylib.GenImageColor(200, 1, {173,173,173,255})
		for i:i32=0;i<i32(ratio*200);i+=1 do raylib.ImageDrawPixel(&graphic.image, i, 0, color)
	}
	graphic.texture = raylib.LoadTextureFromImage(graphic.image)
	graphic.ratio	= ratio

	//* Draw bar
	raylib.DrawTexturePro(
		graphic.texture,
		{0, 0, 200, 1},
		{(rect.x + offset) * game.screenRatio, rect.y * game.screenRatio, (rect.width + (60 - offset)) * game.screenRatio, rect.height * game.screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Draw Text
	draw_text({rect.x, rect.y, 60, rect.height}, title, true)
	if player || game.difficulty == .easy {
		draw_text({rect.x + offset, rect.y, rect.width + (60 - offset), rect.height}, cstr)
	}

}

draw_stat_changes :: proc( monster : ^game.Monster, stat : int, position : raylib.Vector2 ) {
	if monster.statChanges[stat] != 0 {
		draw_sprite({position.x, position.y, 32, 32}, {0,2}, {247,82,49,255}, "status_icons")
		if monster.statChanges[stat] > 0 do draw_sprite({position.x, position.y, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({position.x, position.y, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({position.x, position.y, 32, 32}, {math.abs(f32(monster.statChanges[stat]))-1,0}, {56,56,56,255}, "status_icons")
	}
}