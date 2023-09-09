package monsters


//= Imports
//import "core:c/libc"
import "core:math"
import "core:fmt"

import "../../game"
import "../audio"


//= Procedures
update_stats :: proc(  monster : ^game.Monster ) {
	#partial switch monster.species {
		case .starter_grass:
			monster.hpMax = calculate_hp(50, monster.level)
			monster.stMax = calculate_st(35, monster.level)
			monster.atk   = calculate_stat(45, monster.level)
			monster.def   = calculate_stat(65, monster.level)
			monster.spAtk = calculate_stat(45, monster.level)
			monster.spDef = calculate_stat(65, monster.level)
			monster.spd   = calculate_stat(45, monster.level)
			monster.hpCur = monster.hpMax
			monster.stCur = monster.stMax
		case .starter_fire:
			monster.hpMax = calculate_hp(35, monster.level)
			monster.stMax = calculate_st(55, monster.level)
			monster.atk   = calculate_stat(55, monster.level)
			monster.def   = calculate_stat(40, monster.level)
			monster.spAtk = calculate_stat(60, monster.level)
			monster.spDef = calculate_stat(40, monster.level)
			monster.spd   = calculate_stat(65, monster.level)
			monster.hpCur = monster.hpMax
			monster.stCur = monster.stMax
		case .starter_water:
			monster.hpMax = calculate_hp(50, monster.level)
			monster.stMax = calculate_st(45, monster.level)
			monster.atk   = calculate_stat(65, monster.level)
			monster.def   = calculate_stat(60, monster.level)
			monster.spAtk = calculate_stat(40, monster.level)
			monster.spDef = calculate_stat(45, monster.level)
			monster.spd   = calculate_stat(45, monster.level)
			monster.hpCur = monster.hpMax
			monster.stCur = monster.stMax
	}
}

calculate_hp :: proc( stat, level : int, iv : int = 0, ev : int = 0 ) -> int {
	return int(f32((2 * stat + iv + int(f32(ev)/4)) * level) / 50) + level + 10
}

calculate_st :: proc( stat, level : int, iv : int = 0, ev : int = 0 ) -> int {
	return (int(f32((2 * stat + iv + int(f32(ev)/4)) * level) / 100) + level + 10) / 2
}

calculate_stat :: proc( stat, level : int, iv : int = 0, ev : int = 0 ) -> int {
	nature := 1
	return (int(f32((2 * stat + iv + int(f32(ev)/4)) * level) / 100) + 5) * nature
}

calculate_experience :: proc( level : int, rate : game.ExperienceRate ) -> int {
	total : int

	switch rate {
		case .fast:		total = int((math.pow(f32(level), 3) * 4) / 5)
		case .medium:	total = int(math.pow(f32(level), 3))
		case .slow:		total = int((math.pow(f32(level), 3) * 5) / 4)
	}

	return total
}

calculate_experience_gain :: proc( monster : ^game.Monster ) -> int {
	baseYield	: f32 = 1
	wild		: f32 = 1
	expShare	: f32 = 1
	origOwner	: f32 = 1
	item		: f32 = 1
	canEvolve	: f32 = 1

	#partial switch monster.species {
		case .starter_grass:
			baseYield = 64
		case .starter_fire:
			baseYield = 64
		case .starter_water:
			baseYield = 64
	}

	if game.battleData.trainerName != "wild" do wild = 1.5

	return int(((baseYield * f32(monster.level)) / 7) * wild * (1 / expShare) * origOwner * item * canEvolve)
}

level_up :: proc( monster :^game.Monster ) {
	monster.level += 1

	update_stats(monster)
	audio.play_sound("level_up") //TODO experience gain noise
}

give_experience :: proc( monster :^game.Monster, amount : int ) -> bool {
	monster.experience += amount

	leveled := false
	neededNext := calculate_experience(monster.level+1, monster.rate)

	for neededNext < monster.experience {
		level_up(monster)
		neededNext = calculate_experience(monster.level+1, monster.rate)
		leveled = true
	}

	return leveled
}

max_movement :: proc( monster : game.Monster ) -> f32 {
	movement : f32 = 0

	if monster.spd < 20 {
		movement = math.ceil(f32(monster.spd) / 4)
	} else {
		movement += 5
		if monster.spd < 100 {
			movement += math.ceil((f32(monster.spd) - 20) / 20)
		} else {
			movement += 4 + math.ceil((f32(monster.spd) - 100) / 100)
		}
	}

	return movement
}

start_turn :: proc( monster : ^game.Monster ) {
	//* Calc movement
	if !monster.flinch {
		monster.movesMax = int(max_movement(monster^))
		monster.movesCur = monster.movesMax
	}

	//* Calc stamina
	if !monster.flinch {
		monster.stCur += (monster.stMax/2)
	} else {
		monster.stCur += (monster.stMax/4)
	}
	if monster.stCur > monster.stMax do monster.stCur = monster.stMax

	monster.flinch = false
}

calculate_damage :: proc( base, level, atk, def, effectiveness : f32 ) -> int {
	output : int = int(((((((2*level)/5)+2)*base*(atk/def))/100)+2) * effectiveness)
	if output <= 0 do output = 1

	return output
}