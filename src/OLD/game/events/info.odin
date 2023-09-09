package events


//= Imports
import "core:fmt"

import "../../game"


//= Procedures
// TODO: Figure this out
check_visible :: proc(
	event : ^game.Event,
) -> bool {
	result : bool = true
//	if len(event.conditional) <= 0 do return true
//	for var in event.conditional {
//		if game.eventmanager.eventVariables[var] != event.conditional[var] do result = false
//	}
	return result
}