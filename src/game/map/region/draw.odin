package region


//= Imports
import "core:fmt"
import "core:math"
import "core:slice"

import "vendor:raylib"

import "../../../game"
import "../../../game/entity"


//= Procedures
draw :: proc() {
	if game.DRAW_MAP {
	//	maxY, minY : int = int(game.region.size.y), 0
	//	maxX, minX : int = int(game.region.size.x), 0
		maxY, minY : int = int(game.player.entity.position.z) + 8, int(game.player.entity.position.z) - 8
		maxX, minX : int = int(game.player.entity.position.x) + 14, int(game.player.entity.position.x) - 14
		width      : int = maxX - minX
		for y:=minY;y<maxY;y+=1 {
			count := 0
			x     := minX
			flip  := false
			for count != width {
				position : raylib.Vector2 = {
					f32(x),
					f32(y),
				}
				raylib.DrawModelEx(
					game.tiles[game.region.tiles[position].model],
					game.region.tiles[position].pos,
					{0, 1, 0},
					0,
					{1, 1, 1},
					raylib.WHITE,
				)
				if !flip do x += 1
				else     do x -= 1

				if x >= int(game.player.entity.position.x) && !flip {
					flip = true
					x = maxX-1
				}

				count += 1
			}

			x = 0
			for x:=0;x<int(game.region.size.x);x+=1 {
				ent, err := game.region.entities[{f32(x),f32(y)}]
				if err do if test_entity(f32(x), f32(y), &ent, true) do entity.draw(&ent)

				/* //? NOTE:
					This code is fucked up, but it works.
					Basically; It renders the tile thats +1 z from the player as long as its not solid.

					This exists because otherwise the player's transparency overrides the texture of the tile as they walk northward.
					If i can figure out a better way of doing this, i'll implement it. but otherwise i'm just happy it looks fine now.
				*/
				ply := game.player.entity
				position : raylib.Vector2 = {
					ply.target.x-1,
					ply.target.z+1,
				}
				southTile := game.region.tiles[position]
				if !southTile.solid do raylib.DrawModelEx(
					game.tiles[southTile.model],
					southTile.pos,
					{0, 1, 0},
					0,
					{1, 1, 1},
					raylib.WHITE,
				)
				position.x += 2
				southTile = game.region.tiles[position]
				if !southTile.solid do raylib.DrawModelEx(
					game.tiles[southTile.model],
					southTile.pos,
					{0, 1, 0},
					0,
					{1, 1, 1},
					raylib.WHITE,
				)
				position.x -= 1
				southTile = game.region.tiles[position]
				if !southTile.solid do raylib.DrawModelEx(
					game.tiles[southTile.model],
					southTile.pos,
					{0, 1, 0},
					0,
					{1, 1, 1},
					raylib.WHITE,
				)
				if test_entity(f32(x), f32(y), ply, true) do entity.draw(ply)
			}

		}

		//for y:=0;y<int(game.region.size.y);y+=1 {
		//	for x:=0;x<int(game.player.entity.position.x);x+=1 {
		//		position : raylib.Vector2 = {
		//			f32(x),
		//			f32(y),
		//		}
		//		raylib.DrawModelEx(
		//			game.tiles[game.region.tiles[position].model],
		//			game.region.tiles[position].pos,
		//			{0, 1, 0},
		//			0,
		//			{1, 1, 1},
		//			raylib.WHITE,
		//		)
//
		//		ent, err := game.region.entities[{f32(x),f32(y)}]
		//		if err do if test_entity(x, y, &ent, true) do entity.draw(&ent)
		//	}
		//	for x:=int(game.region.size.x)-1;x>int(game.player.entity.position.x)-1;x-=1 {
		//		position : raylib.Vector2 = {
		//			f32(x),
		//			f32(y),
		//		}
		//		
		//		raylib.DrawModelEx(
		//			game.tiles[game.region.tiles[position].model],
		//			game.region.tiles[position].pos,
		//			{0, 1, 0},
		//			0,
		//			{1, 1, 1},
		//			raylib.WHITE,
		//		)
//
		//		ent, err := game.region.entities[{f32(x),f32(y)}]
		//		if err do if test_entity(x, y, &ent, true) do entity.draw(&ent)
		//		
		//		ply := game.player.entity
		//		if test_entity(x, y, ply, false) do entity.draw(ply)
		//	}
		//}
	}
}

test_entity :: proc(
	x, y	: f32,
	entity	: ^game.Entity,
	offset	: bool,
) -> bool {
	return entity.target.x == x && entity.target.z == y
	//if offset	do return ( int(math.ceil(entity.target.x)) == x || int(math.floor(entity.target.x)) == x ) && ( int(math.ceil(entity.target.z)) == y || int(math.floor(entity.target.z)) == y )
	//if offset	do return entity.target.x == x && entity.target.z == y
	//else		do return ( int(math.ceil(entity.position.x)) == x || int(math.floor(entity.position.x)) == x ) && ( int(math.ceil(entity.position.z)) == y-1 || int(math.floor(entity.position.z)) == y-1 )
	//else		do return ( int(entity.position.x) <= x || int(entity.position.x) > x-1 ) && ( int(entity.position.z) <= y || int(entity.position.z) > y-1 )
	//else		do return ( math.ceil(entity.position.x) == f32(x) || math.floor(entity.position.x) == f32(x) ) && ( math.ceil(entity.position.z) == f32(y-1) || math.floor(entity.position.z) == f32(y-1) )
	//else {
	//	//return entity.target.x == f32(x) && (entity.target.z >= f32(y)-1 && entity.target.z < f32(y))
	//	test := false
	//	if (entity.previous.z > entity.target.z) && (entity.target.z == entity.position.z) do test = true
	//	return entity.target.x == f32(x) && (entity.target.z == f32(y) || test)
	//}
}