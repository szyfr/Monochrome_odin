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
		draw_arrow_complete()

		//* Draw player's current action
		#partial switch game.battleData.playerAction {
			case .interaction:
			case .attack1:
				draw_attack(0)
			case .attack2:
				draw_attack(1)
			case .attack3:
				draw_attack(2)
			case .attack4:
				draw_attack(3)
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

draw_arrow_complete :: proc() {
	lastPosition : raylib.Vector2 = {game.battleData.field["player"].entity.position.x - 8, game.battleData.field["player"].entity.position.z - 55.75}
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
			player := &game.battleData.field["player"]
			overworld.draw(&player.entity, 1.5, 127, {game.battleData.moveArrowList[i].x+8, 0, game.battleData.moveArrowList[i].y+55.75})
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
	transform[3,1] = 0.03
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

//TODO These don't work. I don't get matrixes
mat_mult :: proc(
	left  : linalg.Matrix4x4f32,
	right : linalg.Matrix4x4f32,
) -> linalg.Matrix4x4f32 {
	result : linalg.Matrix4x4f32 = {}

	result[0,0] = left[0,0]*right[0,0] + left[0,1]*right[1,0] + left[0,2]*right[2,0] + left[0,3]*right[3,0]
	result[0,1] = left[0,0]*right[0,1] + left[0,1]*right[1,1] + left[0,2]*right[2,1] + left[0,3]*right[3,1]
	result[0,2] = left[0,0]*right[0,2] + left[0,1]*right[1,2] + left[0,2]*right[2,2] + left[0,3]*right[3,2]
	result[0,3] = left[0,0]*right[0,3] + left[0,1]*right[1,3] + left[0,2]*right[2,3] + left[0,3]*right[3,3]
	
	result[1,0] = left[1,0]*right[0,0] + left[1,1]*right[1,0] + left[1,2]*right[2,0] + left[1,3]*right[3,0]
	result[1,1] = left[1,0]*right[0,1] + left[1,1]*right[1,1] + left[1,2]*right[2,1] + left[1,3]*right[3,1]
	result[1,2] = left[1,0]*right[0,2] + left[1,1]*right[1,2] + left[1,2]*right[2,2] + left[1,3]*right[3,2]
	result[1,3] = left[1,0]*right[0,3] + left[1,1]*right[1,3] + left[1,2]*right[2,3] + left[1,3]*right[3,3]
	
	result[2,0] = left[2,0]*right[0,0] + left[2,1]*right[1,0] + left[2,2]*right[2,0] + left[2,3]*right[3,0]
	result[2,1] = left[2,0]*right[0,1] + left[2,1]*right[1,1] + left[2,2]*right[2,1] + left[2,3]*right[3,1]
	result[2,2] = left[2,0]*right[0,2] + left[2,1]*right[1,2] + left[2,2]*right[2,2] + left[2,3]*right[3,2]
	result[2,3] = left[2,0]*right[0,3] + left[2,1]*right[1,3] + left[2,2]*right[2,3] + left[2,3]*right[3,3]
	
	result[3,0] = left[3,0]*right[0,0] + left[3,1]*right[1,0] + left[3,2]*right[2,0] + left[3,3]*right[3,0]
	result[3,1] = left[3,0]*right[0,1] + left[3,1]*right[1,1] + left[3,2]*right[2,1] + left[3,3]*right[3,1]
	result[3,2] = left[3,0]*right[0,2] + left[3,1]*right[1,2] + left[3,2]*right[2,2] + left[3,3]*right[3,2]
	result[3,3] = left[3,0]*right[0,3] + left[3,1]*right[1,3] + left[3,2]*right[2,3] + left[3,3]*right[3,3]

	return result
}
mat_rotate_y :: proc( mat : raylib.Matrix, rotation : f32 ) -> raylib.Matrix {
	transform : raylib.Matrix = create_matrix_rotation_y(rotation)
	//output : raylib.Matrix = mat_mult(mat, transform)
	output : raylib.Matrix = mat_mult(transform,mat)

	return output
}


draw_attack :: proc( value : int ) {
	attack : game.MonsterAttack = game.battleData.playerTeam[game.battleData.currentPlayer].attacks[value]
	player := &game.battleData.field["player"]

	position : raylib.Vector2
	if len(game.battleData.moveArrowList) > 0 do position = game.battleData.moveArrowList[len(game.battleData.moveArrowList)-1]
	else do position = {player.entity.position.x - 8, player.entity.position.z - 55.75}
	offset : raylib.Vector2
	switch  player.entity.direction {
		case .up:		offset += { 0,-1}
		case .down:		offset += { 0, 1}
		case .left:		offset += {-1, 0}
		case .right:	offset += { 1, 0}
	}

	#partial switch attack {
		case .tackle:
			if game.battleData.field["enemy"].entity.position == {position.x + offset.x + 8, 0, position.y + offset.y + 55.75} {
				draw_tile(game.attackTackleMat[1], position + offset, f32(player.entity.direction) * 90)
				draw_tile(game.attackTackleMat[2], position + (offset * 2), f32(player.entity.direction) * 90)
			} else {
				draw_tile(game.attackTackleMat[0], position + offset, f32(player.entity.direction) * 90)
			}
		case .growl:
			draw_tile(game.attackGrowlMat, position, 0, {5,5})
		case .leafage:
			// TODO Maybe have a limited range?
			draw_tile(game.attackLeafageMat, game.battleData.target, 0)
		case .scratch:
			draw_tile(game.attackScratchMat, position + offset, 0)
		case .leer:
			draw_tile(game.attackLeerMat, position + offset*1.5, f32(player.entity.direction) * 90, {4,5})
		case .ember:
			draw_tile(game.attackEmberMat, position + offset*3, f32(player.entity.direction) * 90, {5,1})
		case .aquajet:
			if game.battleData.field["enemy"].entity.position == {position.x + (offset.x * 2) + 8, 0, position.y + (offset.y * 2) + 55.75} {
				draw_tile(game.attackAquaJetMat[1], position + offset, f32(player.entity.direction) * 90)
			} else {
				draw_tile(game.attackAquaJetMat[0], position + offset, f32(player.entity.direction) * 90)
				draw_tile(game.attackAquaJetMat[1], position + (offset*2), f32(player.entity.direction) * 90)
			}
	}
}

draw_tile :: proc( material : raylib.Material, position : raylib.Vector2, rotation : f32, scale : raylib.Vector2 = {1,1} ) {
	alter : f32 = rotation * (math.PI / 180)

	transform : raylib.Matrix = {
		scale.x*math.cos(alter),	0.00, scale.x*math.sin(alter),	0.00,
		0.00,						0.00, 1.00,						0.00,
		scale.y*-math.sin(alter),	0.00, scale.y*math.cos(alter),	0.00,
		position.x + 8.5,			0.02, position.y + 56.5,		1.00,
	}

	raylib.DrawMesh(game.standeeMesh, material, transform)
}
