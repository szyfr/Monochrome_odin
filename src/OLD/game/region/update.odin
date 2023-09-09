package region


//= Imports
import "../../game"
import "../entity/overworld"
import "../events"


//= Procedures
update :: proc() {
	for ent in game.region.entities {
		overworld.update(&game.region.entities[ent])
	}
	events.update()
}