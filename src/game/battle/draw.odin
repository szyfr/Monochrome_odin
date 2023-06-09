package battle


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures
draw :: proc() {

	for y:=0;y<8;y+=1 {
		for x:=0;x<16;x+=1 {
			switch in game.battleData.squares[y][x] {
				case (^game.Monster):
					transform : raylib.Matrix = {
						1.00,  0.00, 0.00, 0.00,
						0.00,  0.78, 0.80, 0.00,
						0.00, -0.80, 0.78, 0.00,
						0.00,  0.00, 0.00, 1.00,
					}
					transform[3,0] = f32(x) + 8.5
					transform[3,1] = 0.5
					transform[3,2] = f32(y) + 56.5
					raylib.DrawMesh(game.standeeMesh,game.emoteMaterials[0],transform)
				case bool:
				case int:
			}
		}
	}
}