package region


//= Imports
import "../../../game"
import "../../../game/entity"
import "../../../game/events"


//= Procedures
update :: proc() {
	for ent in game.region.entities {
		entity.update(&game.region.entities[ent])
	}
	events.update()
}