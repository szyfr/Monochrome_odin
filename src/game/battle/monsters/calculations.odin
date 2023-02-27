package monsters


//= Imports
import "core:math"

import "../../../game"


//= Procedures
exp_needed :: proc(
	level : int,
) -> int {
	forLast	:= math.pow(f32(level-1), 3)
	forCur	:= math.pow(f32(level), 3)

	return int(forCur - forLast)
}

exp_ratio :: proc(
	total : int,
	level : int,
) -> f32 {
	forLast	:= math.pow(f32(level-1), 3)
	forCur	:= math.pow(f32(level), 3)

	needed	:= forCur - forLast
	curExp	:= f32(total) - forCur

	return f32(curExp) / f32(needed)
}

number_attacks :: proc(
	attackList : [4]game.Attack,
) -> int {
	res := 0
	for i in attackList {
		if i.type != .empty do res += 1
	}
	return res
}