package entity


//= Imports
import "core:fmt"

import "../../../game"


//= Procedures
check_visible :: proc(
	entity : ^game.Entity,
) -> bool {
	result : bool = true
	if len(entity.conditional) <= 0 do return true
	for var in entity.conditional {
		if game.eventmanager.eventVariables[var] != entity.conditional[var] do result = false
	}
	return result
}