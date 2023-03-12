package battle


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../../game"
import "../general/camera"
import "../general/graphics/ui"
import "../general/settings"
import "../overworld/standee"


//= Procedures
draw :: proc() {
	player	:= &game.battleStruct.playerPokemon
	enemy	:= &game.battleStruct.enemyPokemon

	//* Targeter
	ray := raylib.GetMouseRay(raylib.GetMousePosition(), game.camera)
	col := raylib.GetRayCollisionBox(ray, {{8,0,56}, {24,0,64}})
	game.battleStruct.playerTarget = col.point
	color := raylib.WHITE
	if !col.hit {
		color = {0,0,0,64}
	}
	raylib.DrawModel(
		game.targeter,
		col.point + {0,0.01,0},
		1,
		color,
	)

	//* Drawing attack overlay
	if settings.is_key_down("show_overlay") {
		overlay := &game.attackOverlays[player.pokemonInfo.attacks[player.selectedAtk].type]
		switch in overlay {
			case game.AttackOverlayGeneral:
				rot	:= -math.atan2(
					(game.battleStruct.playerTarget.z - 1) - player.position.z,
					(game.battleStruct.playerTarget.x - 0.5) - player.position.x,
				) * (180 / math.PI)
				raylib.DrawModelEx(
					overlay.(game.AttackOverlayGeneral).model,
					player.position + {0.5,0.03,1},
					{0,1,0},
					rot,
					{1,1,1},
					{255,255,255,100},
				)
		}
	}

	//* Drawing battlers
	if player.position.z >= enemy.position.z {
		enemy.standee.position[3,0] = enemy.position.x + 0.5
		enemy.standee.position[3,1] = enemy.position.y + 1.0
		enemy.standee.position[3,2] = enemy.position.z + 0.5
		raylib.DrawBoundingBox(enemy.bounds, raylib.PURPLE)
		standee.draw(enemy.standee)

		player.standee.position[3,0] = player.position.x + 0.5
		player.standee.position[3,1] = player.position.y + 1.0
		player.standee.position[3,2] = player.position.z + 0.5
		raylib.DrawBoundingBox(player.bounds, raylib.PURPLE)
		standee.draw(player.standee)
	}
	if player.position.z < enemy.position.z {
		player.standee.position[3,0] = player.position.x + 0.5
		player.standee.position[3,1] = player.position.y + 1.0
		player.standee.position[3,2] = player.position.z + 0.5
		raylib.DrawBoundingBox(player.bounds, raylib.PURPLE)
		standee.draw(player.standee)

		enemy.standee.position[3,0] = enemy.position.x + 0.5
		enemy.standee.position[3,1] = enemy.position.y + 1.0
		enemy.standee.position[3,2] = enemy.position.z + 0.5
		raylib.DrawBoundingBox(enemy.bounds, raylib.PURPLE)
		standee.draw(enemy.standee)
	}

	//* 
	for i in game.battleStruct.attackEntities {
		switch in i {
			case game.AttackFollow:
				raylib.DrawBoundingBox(i.(game.AttackFollow).bounds, raylib.RED)
				//game.attackModels[i.(game.AttackFollow).attackModel].transform = 
				position : raylib.Vector3
				rot : f32
				if i.(game.AttackFollow).player {
					position = player.position
					rot	= -math.atan2(
						(player.forcedMoveTarget.z - 1) - player.position.z,
						(player.forcedMoveTarget.x - 0.5) - player.position.x,
					) * (180 / math.PI)
					if rot < 0
				} else {
					position = enemy.position
				}
				fmt.printf("%v\n",game.attackModels[i.(game.AttackFollow).attackModel])
				raylib.DrawModelEx(
					game.attackModels[i.(game.AttackFollow).attackModel],
					position + {0.5,0.03,1},
					{0,1,0},
					rot,
					{1,1,1},
					raylib.WHITE,
				)
		}
	}
}