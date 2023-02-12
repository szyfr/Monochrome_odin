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
		for y:=0;y<int(game.region.size.y);y+=1 {
			for x:=0;x<int(game.player.entity.position.x);x+=1 {
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

				ent, err := game.region.entities[{f32(x),f32(y)}]
				if err do if test_entity(x, y, &ent, true) do entity.draw(&ent)
			}
			for x:=int(game.region.size.x)-1;x>int(game.player.entity.position.x)-1;x-=1 {
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

				ent, err := game.region.entities[{f32(x),f32(y)}]
				if err do if test_entity(x, y, &ent, true) do entity.draw(&ent)
				
				ply := game.player.entity
				if test_entity(x, y, ply, false) do entity.draw(ply)
			}
		}
	}
}

test_entity :: proc(
	x, y	: int,
	entity	: ^game.Entity,
	offset	: bool,
) -> bool {
	if offset	do return ( int(math.ceil(entity.target.x)) == x || int(math.floor(entity.target.x)) == x ) && ( int(math.ceil(entity.target.z)) == y || int(math.floor(entity.target.z)) == y )
	else		do return ( int(math.ceil(entity.target.x)) == x || int(math.floor(entity.target.x)) == x ) && ( int(math.ceil(entity.target.z)) == y-1 || int(math.floor(entity.target.z)) == y-1 )
}