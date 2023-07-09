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
	monster.movesMax = int(max_movement(monster^))
	monster.movesCur = monster.movesMax
	monster.stCur += (monster.stMax/2)
	if monster.stCur > monster.stMax do monster.stCur = monster.stMax
}

type_damage_multiplier :: proc( type : game.ElementalType, monster : ^game.Monster ) -> f32 {
	output : f32

	weakness : int

	#partial switch type {
		case .normal:
			// TODO Ghost's immunity, Rock + Steel resistance
			//* Resistance
		case .fire:
			// TODO Ice + Bug + Steel weakness, rock + Dragon resistance
			//* Weakness
			if monster.elementalType1 == .grass || monster.elementalType2 == .grass do weakness += 1
			//* Resistance
			if monster.elementalType1 == .fire || monster.elementalType2 == .fire do weakness -= 1
			if monster.elementalType1 == .water || monster.elementalType2 == .water do weakness -= 1
		case .water:
			// TODO Ground + Rock Weakness, Dragon resistance
			//* Weakness
			if monster.elementalType1 == .fire || monster.elementalType2 == .fire do weakness += 1
			//* Resistance
			if monster.elementalType1 == .grass || monster.elementalType2 == .grass do weakness -= 1
			if monster.elementalType1 == .water || monster.elementalType2 == .water do weakness -= 1
		case .grass:
			// TODO Ground + Rock Weakness, Poison + Flying + Bug + Dragon + Steel resistance
			//* Weakness
			if monster.elementalType1 == .water || monster.elementalType2 == .water do weakness += 1
			//* Resistance
			if monster.elementalType1 == .grass || monster.elementalType2 == .grass do weakness -= 1
			if monster.elementalType1 == .fire || monster.elementalType2 == .fire do weakness -= 1
	}

	switch {
		case weakness >=  3:
			output = 2.5
			fmt.printf("Hyper-Effective!\n")
		case weakness ==  2:
			output = 2
			fmt.printf("Doubly Super-Effective!\n")
		case weakness ==  1:
			output = 1.5
			fmt.printf("Super-Effective!\n")
		case weakness ==  0:
			output = 1
		case weakness == -1:
			output = 0.66
			fmt.printf("Not very effective!\n")
		case weakness == -2:
			output = 0.5
			fmt.printf("Horribly ineffective!\n")
		case weakness <= -3:
			output = 0
			fmt.printf("Immune!\n")
	}

	return output
}

calculate_damage :: proc( base, level, atk, def, effectiveness : f32 ) -> int {
	output : int = int(((((((2*level)/5)+2)*base*(atk/def))/100)+2) * effectiveness)
	if output <= 0 do output = 1

	return output
}