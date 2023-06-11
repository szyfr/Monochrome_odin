package battle


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"
import "../entity/overworld"


//= Procedures
draw :: proc() {
	//* Draw cursor
	transform : raylib.Matrix = {
		1.00, 0.00, 0.00, 0.00,
		0.00, 1.00, 0.00, 0.00,
		0.00, 0.00, 1.00, 0.00,
		0.00, 0.00, 0.00, 1.00,
	}
	transform[3,0] = game.battleData.target.x + 8.5
	transform[3,1] = 0.01
	transform[3,2] = game.battleData.target.y + 56.5
	raylib.DrawMesh(game.standeeMesh,game.emoteMaterials[0],transform)

	//* Entities
	for i:=0;i<len(game.battleData.entities);i+=1 {
		overworld.draw(&game.battleData.entities[i], 1.5)
	}
}