package camera


//= Imports
import "core:fmt"

import "../../game"


//= Procedures
update :: proc() {
	if game.camera.targetEntity != nil {
		game.camera.target   = game.camera.targetEntity.position + { 0.5, 0.5, 0.5 }
		game.camera.position = game.camera.targetEntity.position + { 0.5, 7.5, 3.0 }
	}
}