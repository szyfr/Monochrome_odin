package attacks


//= Imports
import "core:reflect"
import "core:strings"
import "core:math"

import "../../../game"
import "../../general/graphics/animations"


//= Procedures
use_growl :: proc(
	user, enemy : ^game.BattleEntity,
	playerUsed : bool,
) {
	user.canMove = false
	user.timer = 40

	animations.set_animation(&user.standee.animator, "walk_down")
	user.pokemonInfo.attacks[user.selectedAtk].cooldown = 100

	effects := make([dynamic]game.AttackEffect)
	append(&effects, game.AttackEffect.atkDown_enemy)

	ent : game.AttackFollow = {
		attackModel = "growl",

		target = user,
		bounds = {},
		boundsSize = {4,1,4},
		sphere = true,

		attackType = .other,
		elementalType = .normal,
		power = 40,
		effects = effects,

		life = 40,
		user = user.pokemonInfo,
		player = playerUsed,
	}
	append(&game.battleStruct.attackEntities, ent)
}