package region


//= Imports
import "../../../../game"
import "../../entity"
import "../../events"


//= Procedures
update :: proc() {
	for ent in game.region.entities {
		entity.update(&game.region.entities[ent])
	}
	events.update()
}