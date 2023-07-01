package battle


//= Imports
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:reflect"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../entity/overworld"


//= Procedures
draw :: proc() {
	if game.battleData != nil {
		//* Draw cursor
		draw_cursor()

		//* Draw player's current action
		#partial switch game.battleData.playerAction {
			case .interaction:
				//* Draw Arrow
				lastPosition : raylib.Vector2 = {-1,-1}
				for i:=0;i<len(game.battleData.moveArrowList);i+=1 {
					startDirection : f32
					nextDirection : f32
					direction : f32

					lastDifference : raylib.Vector2 = {game.battleData.moveArrowList[i].x - lastPosition.x, game.battleData.moveArrowList[i].y - lastPosition.y}
					switch lastDifference {
						case {1,0} : startDirection = game.ARROW_RIGHT
						case {0,1} : startDirection = game.ARROW_DOWN
						case {-1,0}: startDirection = game.ARROW_LEFT
						case {0,-1}: startDirection = game.ARROW_UP
					}
					if i == len(game.battleData.moveArrowList)-1 {
						draw_arrow_tile(.end, game.battleData.moveArrowList[i], startDirection)
						break
					}

					difference : raylib.Vector2
					difference.x = game.battleData.moveArrowList[i+1].x - game.battleData.moveArrowList[i].x
					difference.y = game.battleData.moveArrowList[i+1].y - game.battleData.moveArrowList[i].y
					switch difference {
						case {1,0} : nextDirection = game.ARROW_RIGHT
						case {0,1} : nextDirection = game.ARROW_DOWN
						case {-1,0}: nextDirection = game.ARROW_LEFT
						case {0,-1}: nextDirection = game.ARROW_UP
					}

					type : game.ArrowType = .middle
					if lastPosition != {-1,-1} && lastDifference != difference {
						type = .turn
						if (startDirection == game.ARROW_RIGHT && nextDirection == game.ARROW_DOWN) || (startDirection == game.ARROW_UP && nextDirection == game.ARROW_LEFT) do direction = 0
						if (startDirection == game.ARROW_DOWN && nextDirection == game.ARROW_LEFT) || (startDirection == game.ARROW_RIGHT && nextDirection == game.ARROW_UP) do direction = 90
						if (startDirection == game.ARROW_DOWN && nextDirection == game.ARROW_RIGHT) || (startDirection == game.ARROW_LEFT && nextDirection == game.ARROW_UP) do direction = 180
						if (startDirection == game.ARROW_UP && nextDirection == game.ARROW_RIGHT) || (startDirection == game.ARROW_LEFT && nextDirection == game.ARROW_DOWN) do direction = 270
					} else {
						if startDirection == game.ARROW_RIGHT || startDirection == game.ARROW_LEFT do direction = 0
						if startDirection == game.ARROW_UP || startDirection == game.ARROW_DOWN do direction = 90
					}

					draw_arrow_tile(type, game.battleData.moveArrowList[i], direction)
					lastPosition = game.battleData.moveArrowList[i]
				}
			case .attack1:
			case .attack2:
			case .attack3:
			case .attack4:
			case .item:
			case .switch_in:
		}

		//* Entities
		for ent in game.battleData.field {
			entity := &game.battleData.field[ent]
			overworld.draw(&entity.entity, 1.5)
		}
	}
}

draw_cursor :: proc() {
	transform : raylib.Matrix = {
		1.00, 0.00, 0.00, 0.00,
		0.00, 1.00, 0.00, 0.00,
		0.00, 0.00, 1.00, 0.00,
		0.00, 0.00, 0.00, 1.00,
	}
	transform[3,0] = game.battleData.target.x + 8.5
	transform[3,1] = 0.01
	transform[3,2] = game.battleData.target.y + 56.5
	raylib.DrawMesh(game.standeeMesh, game.targeterMat, transform)
}

draw_arrow_tile :: proc( type : game.ArrowType, position : raylib.Vector2, rotation : f32 ) {
	transform : raylib.Matrix = create_matrix_rotation_y(rotation)
	transform[3,0] = position.x + 8.5
	transform[3,1] = 0.02
	transform[3,2] = position.y + 56.5

	mat : raylib.Material
	switch type {
		case .middle:
			mat = game.moveArrow[1]
		case .turn:
			mat = game.moveArrow[2]
		case .end:
			mat = game.moveArrow[3]
	}

	raylib.DrawMesh(game.standeeMesh, mat, transform)
}

create_matrix_rotation_x :: proc( rotation : f32 ) -> raylib.Matrix {
	alter : f32 = rotation * (math.PI / 180)
	transform : raylib.Matrix = {
		1.00, 0.00, 0.00, 0.00,
		math.cos(-alter), 1.00, math.sin(-alter), 0.00,
		math.sin(-alter), 0.00, math.cos(-alter), 0.00,
		0.00, 0.00, 0.00, 1.00,
	}
	return transform
}

create_matrix_rotation_y :: proc( rotation : f32 ) -> raylib.Matrix {
	alter : f32 = rotation * (math.PI / 180)
	transform : raylib.Matrix = {
		math.cos(alter), 0.00, math.sin(alter), 0.00,
		0.00, 1.00, 0.00, 0.00,
		math.sin(-alter), 0.00, math.cos(alter), 0.00,
		0.00, 0.00, 0.00, 1.00,
	}
	return transform
}

create_matrix_rotation_z :: proc( rotation : f32 ) -> raylib.Matrix {
	alter : f32 = rotation * (math.PI / 180)
	transform : raylib.Matrix = {
		math.cos(-alter), 0.00, math.sin(-alter), 0.00,
		math.sin(-alter), 1.00, math.cos(-alter), 0.00,
		0.00, 0.00, 1.00, 0.00,
		0.00, 0.00, 0.00, 1.00,
	}
	return transform
}