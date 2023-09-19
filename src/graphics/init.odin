package graphics


//= Imports
import "vendor:raylib"


//= Procedures
init_textures :: proc() {
	textures["overworld_player"] = raylib.LoadTexture("data/old/sprites/spr_player_1.png")
}