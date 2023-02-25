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
	str := strings.to_pascal_case(reflect.enum_string(game.battleStruct.playerPokemon.pokemonInfo.species))
	raylib.DrawTextEx(
		game.font,
		strings.clone_to_cstring(str),
		{STATUS_WIDTH / 2 - (f32(len(str)) * 20) / 2, 45},
		20,
		1,
		raylib.BLACK,
	)

	img		:= raylib.GenImageColor(100, 1, raylib.WHITE)
	percent	:= (f32(game.battleStruct.playerPokemon.pokemonInfo.hpCur) / f32(game.battleStruct.playerPokemon.pokemonInfo.hpMax)) * 100
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

	fmt.sbprintf(&builder, "%v/%v",game.battleStruct.playerPokemon.pokemonInfo.hpCur, game.battleStruct.playerPokemon.pokemonInfo.hpMax)
	raylib.DrawTextEx(
		game.font,
		strings.clone_to_cstring(strings.to_string(builder)),
		{STATUS_WIDTH / 2 - (f32(len(builder.buf)) * 20) / 2, 105},
		20,
		1,
		raylib.BLACK,
	)
	strings.builder_reset(&builder)

	img		= raylib.GenImageColor(100, 1, raylib.WHITE)
	percent	= math.floor(monsters.exp_ratio(game.battleStruct.playerPokemon.pokemonInfo.experience, game.battleStruct.playerPokemon.pokemonInfo.level) * 100)
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
	str = strings.to_pascal_case(reflect.enum_string(game.battleStruct.enemyPokemon.pokemonInfo.species))
	raylib.DrawTextEx(
		game.font,
		strings.clone_to_cstring(str),
		{
			screenWidth - (20 * f32(len(str))) / 2 - STATUS_WIDTH / 2,
			45,
		},
		20,
		1,
		raylib.BLACK,
	)

	img		= raylib.GenImageColor(100, 1, raylib.WHITE)
	percent	= (f32(game.battleStruct.enemyPokemon.pokemonInfo.hpCur) / f32(game.battleStruct.enemyPokemon.pokemonInfo.hpMax)) * 100
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

	fmt.sbprintf(&builder, "%v/%v",game.battleStruct.enemyPokemon.pokemonInfo.hpCur, game.battleStruct.enemyPokemon.pokemonInfo.hpMax)
	raylib.DrawTextEx(
		game.font,
		strings.clone_to_cstring(strings.to_string(builder)),
		{
			screenWidth - (20 * f32(len(builder.buf))) / 2 - STATUS_WIDTH / 2,
			105,
		},
		20,
		1,
		raylib.BLACK,
	)
	strings.builder_reset(&builder)
}