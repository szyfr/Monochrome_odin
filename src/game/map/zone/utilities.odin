package zone


//= Imports
import "vendor:raylib"

import "../../../game"


//= Procedures
//entity_position :: proc(
//	entity	: ^game.Entity,
//	zone	: ^game.Zone,
//) -> raylib.Vector3 {
//	return entity.position + zone.position
//}
//
//get_tile :: proc(
//	x, y : f32,
//	zone : ^game.Zone,
//) -> ^game.Tile {
//	positionX := int(x + zone.position.x)
//	positionY := int(y + zone.position.z)
//
//	return zone.tiles[positionY][positionX]
//}