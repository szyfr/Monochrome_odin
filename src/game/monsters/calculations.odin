package monsters


//= Imports
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
	return int(f32((2 * stat + iv + int(f32(ev)/4)) * level) / 100) + level + 10
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

level_up :: proc( monster :^game.Monster ) {
	monster.level += 1

	update_stats(monster)
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