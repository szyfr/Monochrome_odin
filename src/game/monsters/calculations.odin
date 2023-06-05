package monsters


//= Imports
import "core:math"
import "core:fmt"

import "../../game"
import "../audio"


//= Procedures
update_stats :: proc(  monster : ^game.Monster ) {
	calculate_level(100, monster.rate)
	#partial switch monster.species {
		case .starter_grass:
			monster.hpMax = calculate_hp(50, monster.level)
			monster.hpCur = monster.hpMax
			monster.stMax = calculate_st(35, monster.level)
			monster.stCur = monster.stMax
			monster.atk = calculate_stat(45, monster.level)
			monster.def = calculate_stat(65, monster.level)
			monster.spAtk = calculate_stat(45, monster.level)
			monster.spDef = calculate_stat(65, monster.level)
			monster.spd = calculate_stat(45, monster.level)
		case .starter_fire:
		case .starter_water:
	}
}

calculate_hp :: proc( stat, level : int, iv : int = 0, ev : int = 0 ) -> int {
	return int(f32((2 * stat + iv + int(f32(ev)/4)) * level) / 100) + level + 10
}

calculate_st :: proc( stat, level : int, iv : int = 0, ev : int = 0 ) -> int {
	return int(f32((2 * stat + iv + int(f32(ev)/4)) * level) / 100) + level + 10
}

calculate_stat :: proc( stat, level : int, iv : int = 0, ev : int = 0 ) -> int {
	nature := 1
	return (int(f32((2 * stat + iv + int(f32(ev)/4)) * level) / 100) + 5) * nature
}

// TODO Basically everything past this point is on thin fucking ice
// TODO I need a clear head to work on this
calculate_experience :: proc( level : int, rate : game.ExperienceRate ) -> int {}
check_level :: proc( monster : ^game.Monster ) {
	calc : int

	switch monster.rate {
		case .fast:
			calc = int(((math.pow(monster.level + 1, 3) * 4) / 5))
		case .medium:
			calc = int(math.pow(monster.level + 1, 3))
		case .slow:
			calc = int(((math.pow(monster.level + 1, 3) * 5) / 4))
	}

	if calc < monster.experience do level_up()
}

level_up :: proc( monster : ^game.Monster ) {
	audio.play_sound("level_up")

	monster.level += 1
	update_stats(monster)

	// TODO Learn moves
	// TODO Evolve
}

give_experience :: proc( monster : ^game.Monster , total : int ) -> bool {
	val := false
	monster.experience += total

	for {
		if monster.experience >= calculate_experience(monster.level,) {
			level_up(monster)
			val = true
		} else do break
	}

	return val
}