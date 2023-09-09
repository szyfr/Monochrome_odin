package ui


//= Imports
import "core:strings"
import "core:fmt"

import "vendor:raylib"

import "../../../game"


//= Procedures
show_levelup :: proc() {
	if game.levelUpDisplay != nil {
		screenWidth_2 := (f32(game.screenWidth) / 2)
		screenWidth_6 := (f32(game.screenWidth) / 6)
		screenHeight_2 := (f32(game.screenHeight) / 2)
		screenHeight_4 := (f32(game.screenHeight) / 4)
		screenRatio := f32(game.screenHeight) / 720
		posX := f32(game.screenWidth) / 4
		posY := f32(game.screenHeight) - (f32(game.screenHeight) / 2)

		//* Draw bg
		raylib.DrawTextureNPatch(
			game.boxUI,
			game.boxUI_npatch,
			{ posX + screenWidth_6, posY - screenHeight_4, screenWidth_2 - screenWidth_6, screenHeight_2 },
			{0,0},
			0,
			raylib.WHITE,
		)

		//* Generate text
		builder : strings.Builder
		str := fmt.sbprintf(
			&builder,
			" Level %v-%v\n\nHP:    %v-%v\nAtk:   %v-%v\nDef:   %v-%v\nSpAtk: %v-%v\nSpDef: %v-%v\nSpd:   %v-%v",
			game.levelUpDisplay.level, game.player.monsters[0].level,
			game.levelUpDisplay.hp, game.player.monsters[0].hpMax,
			game.levelUpDisplay.atk, game.player.monsters[0].atk,
			game.levelUpDisplay.def, game.player.monsters[0].def,
			game.levelUpDisplay.spatk, game.player.monsters[0].spAtk,
			game.levelUpDisplay.spdef, game.player.monsters[0].spDef,
			game.levelUpDisplay.spd, game.player.monsters[0].spd,
		)
		defer delete(str)
		cstr := strings.clone_to_cstring(str)
		defer delete(cstr)

		//* Draw Text
		raylib.DrawTextEx(
			game.font,
			cstr,
			{ posX + screenWidth_6 + (40 * screenRatio), posY - screenHeight_4 + (60 * screenRatio) },
			32,
			5,
			{56,56,56,255},
		)
	}
}