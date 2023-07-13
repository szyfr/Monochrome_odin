package ui


//= Imports
import "vendor:raylib"

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