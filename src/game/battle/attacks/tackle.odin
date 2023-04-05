package attacks


//= Imports
import "core:reflect"
import "core:strings"
import "core:math"

import "../../../game"
import "../../general/graphics/animations"


//= Procedures
use_tackle :: proc(
	player, enemy : ^game.BattleEntity,
	playerUsed : bool,
) {
	player.canMove = false
	player.timer = 15

	player.forcedMove		= true
	player.forcedMoveTarget	= player.target
	player.forcedMoveStart	= player.position + {0.5,0.02,1}

	angle : f32 = -math.atan2(
		(player.forcedMoveTarget.z - 1) - player.forcedMoveStart.z,
		(player.forcedMoveTarget.x - 0.5) - player.forcedMoveStart.x,
	) * (180 / math.PI)
	if angle <=  120 && angle >   60 do player.direction = .up
	if angle <=   60 && angle >  -60 do player.direction = .right
	if angle <=  -60 && angle > -120 do player.direction = .down
	if (angle <= -120 && angle > -180) || (angle <= 180 && angle > 120) do player.direction = .left
	dir := reflect.enum_string(player.direction)
	animations.set_animation(&player.standee.animator, strings.concatenate({"walk_", dir}))

	player.monsterInfo.attacks[player.selectedAtk].cooldown = 100

	ent : game.AttackFollow = {
		attackModel = "tackle",

		target = player,
		bounds = player.bounds,
		boundsSize = {1.5,1,1.5},
		sphere = false,

		attackType = .physical,
		elementalType = .normal,
		power = 40,

		life = 15,
		user = player.monsterInfo,
		player = playerUsed,
	}
	append(&game.battleStruct.attackEntities, ent)
}