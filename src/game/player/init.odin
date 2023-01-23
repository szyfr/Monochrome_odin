package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../over_char"
import "../../graphics/sprites"


//= Procedure
init :: proc() {
	data = new(Player)

	data.overworldCharacter.sprite = sprites.create("player_1")^

	data.moveTimer = 0
}