package overworld


//= Imports
import "core:fmt"

import "../../../game"


//= Procedures
//check_visible :: proc(
//	entity : ^game.Entity,
//) -> bool {
//	result : bool = true
//	if len(entity.conditional) <= 0 do return true
//	for var in entity.conditional {
//		if game.eventmanager.eventVariables[var] != entity.conditional[var] do result = false
//	}
//	return result
//}

get_entity :: proc{ get_entity_id }
get_entity_id :: proc(
	id : string,
) -> ^game.Entity {
	if id == "player" do return game.player.entity

	for ent in game.region.entities {
		entity := &game.region.entities[ent]
		if entity.id == id do return entity
	}
	
	return nil
}