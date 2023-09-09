package battle


//= Imports
import "core:math"
import "core:strings"
import "core:fmt"

import "vendor:raylib"

import "../monsters"
import "../graphics/ui"
import "../entity/overworld"
import "../../game"


//= Procedures
use_attack :: proc( player : bool, value : int ) {
	//* Get the user and target info
	data : game.AttackData = {}
	if player {
		data.user			= &game.battleData.playerTeam[game.battleData.currentPlayer]
		data.userToken		= &game.battleData.field["player"]
		data.userPosition	= {data.userToken.entity.position.x-8, data.userToken.entity.position.z-55.75}

		data.target			= &game.battleData.enemyTeam[game.battleData.currentEnemy]
		data.targetToken	= &game.battleData.field["enemy"]
		data.targetPosition	= {data.targetToken.entity.position.x-8, data.targetToken.entity.position.z-55.75}
	} else {
		data.user			= &game.battleData.enemyTeam[game.battleData.currentEnemy]
		data.userToken		= &game.battleData.field["enemy"]
		data.userPosition	= {data.userToken.entity.position.x-8, data.userToken.entity.position.z-55.75}

		data.target			= &game.battleData.playerTeam[game.battleData.currentPlayer]
		data.targetToken	= &game.battleData.field["player"]
		data.targetPosition	= {data.targetToken.entity.position.x-8, data.targetToken.entity.position.z-55.75}
	}
	data.attack = data.user.attacks[value]

	#partial switch data.attack {
		case .tackle:	use_tackle(player, data)
		case .scratch:	use_scratch(player, data)

		case .growl:	use_growl(player, data)
		case .leer:		use_leer(player, data)
		
		case .leafage:	use_leafage(player, data)
		case .ember:	use_ember(player, data)
		case .aquajet:	use_aquajet(player, data)
	}
}

activate_hazard :: proc( player : bool, data : game.AttackData ) -> bool {

	#partial switch data.attack {
		case .leafage:
			hazard_leafage(player, data)
			return true
	}
	return false
}

use_tackle :: proc( player : bool, data : game.AttackData ) {
	if data.user.stCur >= 2 {
		//* Calculate offset
		offset : raylib.Vector2
		switch data.userToken.entity.direction {
			case .up:		offset = { 0,-1}
			case .down:		offset = { 0, 1}
			case .left:		offset = {-1, 0}
			case .right:	offset = { 1, 0}
		}
		//? Redo this in a way that ignores player/enemy but not walls or borders
		//if !spot_empty(data.userPosition + offset) do return
		//* Push enemy and deal damage
		if data.targetPosition == (data.userPosition + offset) {
			modAtk, modDef : f32
			//* Calculate Attack stat
			if data.user.statChanges[0] > 0 do modAtk = f32(data.user.atk) * ((2 + f32(data.user.statChanges[0])) / 2)
			else do modAtk = f32(data.user.atk) * (2 / (2 + f32(data.user.statChanges[0])))
			if modAtk <= 0 do modAtk = 1
			//* Calculate Defense stat
			if data.target.statChanges[1] > 0 do modDef = f32(data.target.def) * ((2 + f32(data.target.statChanges[1])) / 2)
			else do modDef = f32(data.target.def) * (2 / (2 - f32(data.target.statChanges[1])))
			if modDef <= 0 do modDef = 1

			//* Calculate effectiveness
			effectiveness := type_damage_multiplier(.normal, data.target)

			//* Check if enemy would hit wall or edge
			if spot_empty(data.targetPosition + offset) {
				move_monster(data.targetToken, data.userToken.entity.direction)
				move_monster(data.userToken, data.userToken.entity.direction)
			//	data.targetToken.entity.position += {offset.x, 0, offset.y}
			//	data.userToken.entity.position += {offset.x, 0, offset.y}

				damage_monster(data.target, monsters.calculate_damage(35, f32(data.user.level), modAtk, modDef, effectiveness))
				//data.target.hpCur -= monsters.calculate_damage(35, f32(data.user.level), modAtk, modDef, effectiveness)
			} else {
				damage_monster(data.target, monsters.calculate_damage(40, f32(data.user.level), modAtk, modDef, effectiveness))
				//data.target.hpCur -= int(f32(monsters.calculate_damage(40, f32(data.user.level), modAtk, modDef, effectiveness)) * 1.25)
			}
		} else {
			move_monster(data.userToken, data.userToken.entity.direction)
			//data.userToken.entity.position += {offset.x, 0, offset.y}
		}
		data.user.stCur -= 2
	}
}

use_scratch :: proc( player : bool, data : game.AttackData ) {
	if data.user.stCur >= 2 {
		//* Calculate offset
		offset : raylib.Vector2
		switch data.userToken.entity.direction {
			case .up:		offset = { 0,-1}
			case .down:		offset = { 0, 1}
			case .left:		offset = {-1, 0}
			case .right:	offset = { 1, 0}
		}
		//* Deal damage
		if data.targetPosition == (data.userPosition + offset) {
			modAtk, modDef : f32
			//* Calculate Attack stat
			if data.user.statChanges[0] > 0 do modAtk = f32(data.user.atk) * ((2 + f32(data.user.statChanges[0])) / 2)
			else do modAtk = f32(data.user.atk) * (2 / (2 + f32(data.user.statChanges[0])))
			if modAtk <= 0 do modAtk = 1
			//* Calculate Defense stat
			if data.target.statChanges[1] > 0 do modDef = f32(data.target.def) * ((2 + f32(data.target.statChanges[1])) / 2)
			else do modDef = f32(data.target.def) * (2 / (2 - f32(data.target.statChanges[1])))
			if modDef <= 0 do modDef = 1

			//* Calculate effectiveness
			effectiveness := type_damage_multiplier(.normal, data.target)

			data.target.hpCur -= monsters.calculate_damage(35, f32(data.user.level), modAtk, modDef, effectiveness)
		}
		data.user.stCur -= 2
	}
}

use_growl :: proc( player : bool, data : game.AttackData ) {
	if data.user.stCur >= 3 {
		difference := data.userPosition - data.targetPosition
		if (difference.x <= 2 && difference.x >= -2) &&
				(difference.y <= 2 && difference.y >= -2) &&
				!(math.abs(difference.x) == 2 && math.abs(difference.y) == 2) {
			if data.target.statChanges[0] > -6 {
				data.target.statChanges[0] -= 1
				ui.add_message("Attack lowered!")
			} else do ui.add_message("Attack can't go lower!")
		}
		data.user.stCur -= 3
	}
}

use_leer :: proc( player : bool, data : game.AttackData ) {
	if data.user.stCur >= 3 {
		//* Calculate offset
		offset : raylib.Vector2
		switch data.userToken.entity.direction {
			case .up:		offset = { 0,-1}
			case .down:		offset = { 0, 1}
			case .left:		offset = {-1, 0}
			case .right:	offset = { 1, 0}
		}
		hit : bool = false
		switch data.userToken.entity.direction {
			case .up:
				if		data.targetPosition == (data.userPosition + { 0,-1}) ||
						data.targetPosition == (data.userPosition + {-1,-1}) ||
						data.targetPosition == (data.userPosition + { 1,-1}) ||
						data.targetPosition == (data.userPosition + {-2,-2}) ||
						data.targetPosition == (data.userPosition + {-1,-2}) ||
						data.targetPosition == (data.userPosition + { 0,-2}) ||
						data.targetPosition == (data.userPosition + { 1,-2}) ||
						data.targetPosition == (data.userPosition + { 2,-2}) ||
						data.targetPosition == (data.userPosition + {-2,-3}) ||
						data.targetPosition == (data.userPosition + {-1,-3}) ||
						data.targetPosition == (data.userPosition + { 0,-3}) ||
						data.targetPosition == (data.userPosition + { 1,-3}) ||
						data.targetPosition == (data.userPosition + { 2,-3}) {
					hit = true
				}
			case .down:
				if		data.targetPosition == (data.userPosition + { 0, 1}) ||
						data.targetPosition == (data.userPosition + {-1, 1}) ||
						data.targetPosition == (data.userPosition + { 1, 1}) ||
						data.targetPosition == (data.userPosition + {-2, 2}) ||
						data.targetPosition == (data.userPosition + {-1, 2}) ||
						data.targetPosition == (data.userPosition + { 0, 2}) ||
						data.targetPosition == (data.userPosition + { 1, 2}) ||
						data.targetPosition == (data.userPosition + { 2, 2}) ||
						data.targetPosition == (data.userPosition + {-2, 3}) ||
						data.targetPosition == (data.userPosition + {-1, 3}) ||
						data.targetPosition == (data.userPosition + { 0, 3}) ||
						data.targetPosition == (data.userPosition + { 1, 3}) ||
						data.targetPosition == (data.userPosition + { 2, 3}) {
					hit = true
				}
			case .left:
				if		data.targetPosition == (data.userPosition + {-1,-1}) ||
						data.targetPosition == (data.userPosition + {-1, 0}) ||
						data.targetPosition == (data.userPosition + {-1, 1}) ||
						data.targetPosition == (data.userPosition + {-2,-2}) ||
						data.targetPosition == (data.userPosition + {-2,-1}) ||
						data.targetPosition == (data.userPosition + {-2, 0}) ||
						data.targetPosition == (data.userPosition + {-2, 1}) ||
						data.targetPosition == (data.userPosition + {-2, 2}) ||
						data.targetPosition == (data.userPosition + {-3,-2}) ||
						data.targetPosition == (data.userPosition + {-3,-1}) ||
						data.targetPosition == (data.userPosition + {-3, 0}) ||
						data.targetPosition == (data.userPosition + {-3, 1}) ||
						data.targetPosition == (data.userPosition + {-3, 2}) {
					hit = true
				}
			case .right:
				if		data.targetPosition == (data.userPosition + { 1,-1}) ||
						data.targetPosition == (data.userPosition + { 1, 0}) ||
						data.targetPosition == (data.userPosition + { 1, 1}) ||
						data.targetPosition == (data.userPosition + { 2,-2}) ||
						data.targetPosition == (data.userPosition + { 2,-1}) ||
						data.targetPosition == (data.userPosition + { 2, 0}) ||
						data.targetPosition == (data.userPosition + { 2, 1}) ||
						data.targetPosition == (data.userPosition + { 2, 2}) ||
						data.targetPosition == (data.userPosition + { 3,-2}) ||
						data.targetPosition == (data.userPosition + { 3,-1}) ||
						data.targetPosition == (data.userPosition + { 3, 0}) ||
						data.targetPosition == (data.userPosition + { 3, 1}) ||
						data.targetPosition == (data.userPosition + { 3, 2}) {
					hit = true
				}
		}

		if hit {
			if data.target.statChanges[1] > -6 {
				data.target.statChanges[1] -= 1
				ui.add_message("Defense lowered!")
			} else do ui.add_message("Defense can't go lower!")
		}
		data.user.stCur -= 3
	}
}

use_leafage :: proc( player : bool, data : game.AttackData ) {
	if data.user.stCur >= 4 {
		modAtk, modDef : f32
		//* Calculate Attack stat
		if data.user.statChanges[0] > 0 do modAtk = f32(data.user.atk) * ((2 + f32(data.user.statChanges[0])) / 2)
		else do modAtk = f32(data.user.atk) * (2 / (2 + f32(data.user.statChanges[0])))
		if modAtk <= 0 do modAtk = 1
		//* Calculate Defense stat
		if data.target.statChanges[1] > 0 do modDef = f32(data.target.def) * ((2 + f32(data.target.statChanges[1])) / 2)
		else do modDef = f32(data.target.def) * (2 / (2 - f32(data.target.statChanges[1])))
		if modDef <= 0 do modDef = 1
		
		if game.battleData.target == data.targetPosition {
			effectiveness := type_damage_multiplier(.grass, data.target)
			
			data.target.hpCur -= monsters.calculate_damage(40, f32(data.user.level), modAtk, modDef, effectiveness)
		} else {
			position : raylib.Vector3 = {game.battleData.target.x+8, 0, game.battleData.target.y+55.75}
			format : string

			if player {
				game.battleData.playerHazardCount += 1
				format = "player_hazard_%v"
			} else {
				game.battleData.enemyHazardCount += 1
				format = "enemy_hazard_%v"
			}

			builder : strings.Builder
			str := fmt.sbprintf(&builder, format, game.battleData.playerHazardCount)

			game.battleData.field[str] = game.Token{
				overworld.create(position, "starter_fire", "monster")^,
				.hazard,
				data,
			}
		}

		data.user.stCur -= 4
	}
}

hazard_leafage :: proc( player : bool, data : game.AttackData ) {
	modAtk, modDef : f32
	//* Calculate Attack stat
	if data.user.statChanges[0] > 0 do modAtk = f32(data.user.atk) * ((2 + f32(data.user.statChanges[0])) / 2)
	else do modAtk = f32(data.user.atk) * (2 / (2 + f32(data.user.statChanges[0])))
	if modAtk <= 0 do modAtk = 1
	//* Calculate Defense stat
	if data.target.statChanges[1] > 0 do modDef = f32(data.target.def) * ((2 + f32(data.target.statChanges[1])) / 2)
	else do modDef = f32(data.target.def) * (2 / (2 - f32(data.target.statChanges[1])))
	if modDef <= 0 do modDef = 1

	effectiveness := type_damage_multiplier(.grass, data.target)
			
	data.target.hpCur -= monsters.calculate_damage(40, f32(data.user.level), modAtk, modDef, effectiveness)
	if data.target.stCur != 0 do data.target.stCur -= 1
	else do data.target.flinch = true
}

use_ember :: proc( player : bool, data : game.AttackData ) {
	if data.user.stCur >= 3 {
		//* Calculate offset
		hit : bool = false
		switch data.userToken.entity.direction {
			case .up:
				if  data.targetPosition.y > data.userPosition.y - 6 &&
					data.targetPosition.y < data.userPosition.y {
						hit = true
				}
			case .down:
				if  data.targetPosition.y < data.userPosition.y + 6 &&
					data.targetPosition.y > data.userPosition.y {
						hit = true
				}
			case .left:
				if  data.targetPosition.x > data.userPosition.x - 6 &&
					data.targetPosition.x < data.userPosition.x {
						hit = true
				}
			case .right:
				if  data.targetPosition.x < data.userPosition.x + 6 &&
					data.targetPosition.x > data.userPosition.x {
						hit = true
				}
		}

		if hit {
			modAtk, modDef : f32
			//* Calculate Attack stat
			if data.user.statChanges[2] > 0 do modAtk = f32(data.user.spAtk) * ((2 + f32(data.user.statChanges[2])) / 2)
			else do modAtk = f32(data.user.spAtk) * (2 / (2 + f32(data.user.statChanges[2])))
			if modAtk <= 0 do modAtk = 1
			//* Calculate Defense stat
			if data.target.statChanges[3] > 0 do modDef = f32(data.target.spDef) * ((2 + f32(data.target.statChanges[3])) / 2)
			else do modDef = f32(data.target.spDef) * (2 / (2 - f32(data.target.statChanges[3])))
			if modDef <= 0 do modDef = 1

			//* Calculate effectiveness
			effectiveness := type_damage_multiplier(.fire, data.target)

			data.target.hpCur -= monsters.calculate_damage(35, f32(data.user.level), modAtk, modDef, effectiveness)
		}
		data.user.stCur -= 3
	}
}

use_aquajet :: proc( player : bool, data : game.AttackData ) {
	if data.user.stCur >= 3 {
		modAtk, modDef : f32
		//* Calculate Attack stat
		if data.user.statChanges[0] > 0 do modAtk = f32(data.user.atk) * ((2 + f32(data.user.statChanges[0])) / 2)
		else do modAtk = f32(data.user.atk) * (2 / (2 + f32(data.user.statChanges[0])))
		if modAtk <= 0 do modAtk = 1
		//* Calculate Defense stat
		if data.target.statChanges[1] > 0 do modDef = f32(data.target.def) * ((2 + f32(data.target.statChanges[1])) / 2)
		else do modDef = f32(data.target.def) * (2 / (2 - f32(data.target.statChanges[1])))
		if modDef <= 0 do modDef = 1
		
		//* Calculate offset
		offset, fartherOffset : raylib.Vector2
		switch data.userToken.entity.direction {
			case .up:
				offset = { 0,-1}
				fartherOffset = { 0,-2}
			case .down:
				offset = { 0, 1}
				fartherOffset = { 0, 2}
			case .left:
				offset = {-1, 0}
				fartherOffset = {-2, 0}
			case .right:
				offset = { 1, 0}
				fartherOffset = { 2, 0}
		}
		
		if data.targetPosition == data.userPosition + offset {					//* If adjacent
			//* Calculate effectiveness
			effectiveness := type_damage_multiplier(.water, data.target)

			data.target.hpCur -= monsters.calculate_damage(35, f32(data.user.level), modAtk, modDef, effectiveness)
			if data.target.stCur != 0 do data.target.stCur -= 1
			else do data.target.flinch = true
		} else if data.targetPosition == data.userPosition + fartherOffset {	//* If one tile away
			//* Calculate effectiveness
			effectiveness := type_damage_multiplier(.water, data.target)
			
			data.target.hpCur -= monsters.calculate_damage(35, f32(data.user.level), modAtk, modDef, effectiveness)
		}
		//* Move if spot empty
		if spot_empty(data.userPosition + fartherOffset) do data.userToken.entity.position += {fartherOffset.x, 0, fartherOffset.y}
		else if spot_empty(data.userPosition + offset) do data.userToken.entity.position += {offset.x, 0, offset.y}
		
		data.user.stCur -= 3
	}
}