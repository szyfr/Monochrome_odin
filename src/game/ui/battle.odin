package ui


//= Imports
import "core:fmt"
import "core:reflect"
import "core:strings"
import "core:math"

import "vendor:raylib"

import "../../game"
import "../../game/monsters"


//= Constants
STATUS_WIDTH  :: 400
STATUS_HEIGHT :: 200


//= Procedures
draw_battle :: proc() {
	player	:= &game.battleStruct.playerPokemon
	enemy	:= &game.battleStruct.enemyPokemon
	builder : strings.Builder

	//* Player
	raylib.DrawTextureNPatch(
		game.box_ui,
		game.box_ui_npatch,
		{0, 0, STATUS_WIDTH, STATUS_HEIGHT},
		{0,0},
		0,
		raylib.WHITE,
	)
	str		:= strings.to_pascal_case(reflect.enum_string(player.pokemonInfo.species))
	cstr	:= strings.clone_to_cstring(str)
	raylib.DrawTextEx(
		game.font,
		cstr,
		{STATUS_WIDTH / 2 - (f32(len(str)) * 20) / 2, 45},
		20,
		1,
		raylib.BLACK,
	)

	img		:= raylib.GenImageColor(100, 1, raylib.WHITE)
	percent	:= (f32(player.pokemonInfo.hpCur) / f32(player.pokemonInfo.hpMax)) * 100
	raylib.ImageDrawLineV(&img, {0,0}, {percent,0}, raylib.GREEN)
	raylib.UnloadTexture(game.battleStruct.playerHPBar)
	game.battleStruct.playerHPBar = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)
	raylib.DrawTexturePro(
		game.battleStruct.playerHPBar,
		{1,0,f32(game.battleStruct.playerHPBar.width)-1, f32(game.battleStruct.playerHPBar.height)},
		{50,75,300,10},
		{0,0},
		0,
		raylib.WHITE,
	)

	fmt.sbprintf(&builder, "%v/%v", player.pokemonInfo.hpCur, player.pokemonInfo.hpMax)
	delete(cstr)
	str		= strings.to_string(builder)
	cstr	= strings.clone_to_cstring(str)
	raylib.DrawTextEx(
		game.font,
		cstr,
		{STATUS_WIDTH / 2 - (f32(len(builder.buf)) * 20) / 2, 105},
		20,
		1,
		raylib.BLACK,
	)
	strings.builder_reset(&builder)

	img		= raylib.GenImageColor(100, 1, raylib.WHITE)
	percent	= math.floor(monsters.exp_ratio(player.pokemonInfo.experience, player.pokemonInfo.level) * 100)
	raylib.ImageDrawLineV(&img, {0,0}, {percent,0}, raylib.BLUE)
	raylib.UnloadTexture(game.battleStruct.playerEXPBar)
	game.battleStruct.playerEXPBar = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)
	raylib.DrawTexturePro(
		game.battleStruct.playerEXPBar,
		{1,0,f32(game.battleStruct.playerEXPBar.width)-1, f32(game.battleStruct.playerEXPBar.height)},
		{50,165,300,10},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Enemy
	screenWidth := f32(game.settings.screenWidth)
	raylib.DrawTextureNPatch(
		game.box_ui,
		game.box_ui_npatch,
		{
			screenWidth - STATUS_WIDTH, 0,
			STATUS_WIDTH, STATUS_HEIGHT,
		},
		{0,0},
		0,
		raylib.WHITE,
	)
	delete(cstr)
	str		= strings.to_pascal_case(reflect.enum_string(enemy.pokemonInfo.species))
	cstr	= strings.clone_to_cstring(str)
	raylib.DrawTextEx(
		game.font,
		cstr,
		{
			screenWidth - (20 * f32(len(str))) / 2 - STATUS_WIDTH / 2,
			45,
		},
		20,
		1,
		raylib.BLACK,
	)

	img		= raylib.GenImageColor(100, 1, raylib.WHITE)
	percent	= (f32(enemy.pokemonInfo.hpCur) / f32(enemy.pokemonInfo.hpMax)) * 100
	raylib.ImageDrawLineV(&img, {0,0}, {percent,0}, raylib.GREEN)
	raylib.UnloadTexture(game.battleStruct.enemyHPBar)
	game.battleStruct.enemyHPBar = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)
	raylib.DrawTexturePro(
		game.battleStruct.enemyHPBar,
		{1,0,f32(game.battleStruct.enemyHPBar.width)-1, f32(game.battleStruct.enemyHPBar.height)},
		{
			screenWidth - 350,
			75,
			300,10},
		{0,0},
		0,
		raylib.WHITE,
	)

	fmt.sbprintf(&builder, "%v/%v", enemy.pokemonInfo.hpCur, enemy.pokemonInfo.hpMax)
	delete(cstr)
	str		= strings.to_string(builder)
	cstr	= strings.clone_to_cstring(str)
	raylib.DrawTextEx(
		game.font,
		cstr,
		{
			screenWidth - (20 * f32(len(builder.buf))) / 2 - STATUS_WIDTH / 2,
			105,
		},
		20,
		1,
		raylib.BLACK,
	)
	strings.builder_reset(&builder)

	//* Attack UI
	count := monsters.number_attacks(player.pokemonInfo.attacks)
	switch count {
		case 1:
			raylib.DrawTextureNPatch(
				game.box_ui,
				game.box_ui_npatch,
				{
					0, f32(game.settings.screenHeight),
					400, 100,
				},
				{-50, 120},
				game.battleStruct.playerAttackRot,
				raylib.WHITE,
			)
			delete(cstr)
			str		= strings.concatenate({reflect.enum_string(player.pokemonInfo.attacks[0].type),"_name"})
			//cstr	= strings.clone_to_cstring(str)
			raylib.DrawTextPro(
				game.font,
				//cstr,
				game.localization[str],
				{0, f32(game.settings.screenHeight)},
				{-80, 75},
				game.battleStruct.playerAttackRot,
				20, 1,
				raylib.BLACK,
			)
		case 2:
			for atk in 0..<count {
				raylib.DrawTextureNPatch(
					game.box_ui,
					game.box_ui_npatch,
					{
						0, f32(game.settings.screenHeight),
						400, 100,
					},
					{-50, 120},
					game.battleStruct.playerAttackRot + f32(atk * 180),
					raylib.WHITE,
				)
				delete(cstr)
				str		= strings.concatenate({reflect.enum_string(player.pokemonInfo.attacks[atk].type),"_name"})
				//cstr	= strings.clone_to_cstring(str)
				raylib.DrawTextPro(
					game.font,
					//cstr,
					game.localization[str],
					{0, f32(game.settings.screenHeight)},
					{-80, 75},
					game.battleStruct.playerAttackRot + f32(atk * 180),
					20, 1,
					raylib.BLACK,
				)
			}
		case 3:
			for atk in 0..<count {
				raylib.DrawTextureNPatch(
					game.box_ui,
					game.box_ui_npatch,
					{
						0, f32(game.settings.screenHeight),
						400, 100,
					},
					{-50, 120},
					game.battleStruct.playerAttackRot + f32(atk * 120),
					//game.battleStruct.playerAttackRot + f32(atk * -120),
					raylib.WHITE,
				)
				delete(cstr)
				str		= strings.concatenate({reflect.enum_string(player.pokemonInfo.attacks[atk].type),"_name"})
				//cstr	= strings.clone_to_cstring(str)
				raylib.DrawTextPro(
					game.font,
					//cstr,
					game.localization[str],
					{0, f32(game.settings.screenHeight)},
					{-80, 75},
					game.battleStruct.playerAttackRot + f32(atk * 120),
					20, 1,
					raylib.BLACK,
				)
			}
		case 4:
			for atk in 0..<count {
				raylib.DrawTextureNPatch(
					game.box_ui,
					game.box_ui_npatch,
					{
						0, f32(game.settings.screenHeight),
						400, 100,
					},
					{-50, 120},
					game.battleStruct.playerAttackRot + f32(atk * 90),
					raylib.WHITE,
				)
				delete(cstr)
				str		= strings.concatenate({reflect.enum_string(player.pokemonInfo.attacks[atk].type),"_name"})
				//cstr	= strings.clone_to_cstring(str)
				raylib.DrawTextPro(
					game.font,
					//cstr,
					game.localization[str],
					{0, f32(game.settings.screenHeight)},
					{-80, 75},
					game.battleStruct.playerAttackRot + f32(atk * 90),
					20, 1,
					raylib.BLACK,
				)
			}
	}
}