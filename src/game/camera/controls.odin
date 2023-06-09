package camera


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures
focus :: proc( entity : ^game.Entity ) {
	game.camera.targetEntity = entity
	update()
}
defocus :: proc() {
	game.camera.targetEntity = nil
	update()
}

set_position :: proc( position : raylib.Vector3 ) {
	game.camera.position = {position.x, position.y + 7, position.z + 2.5}
	game.camera.target = position
}

update :: proc() {
	if game.camera.targetEntity != nil {
		game.camera.position     = {
			game.camera.targetEntity.position.x + 0.5,
			game.camera.targetEntity.position.y + 7.5,
			game.camera.targetEntity.position.z + 3.0,
		}
		game.camera.target       = {
			game.camera.targetEntity.position.x + 0.5,
			game.camera.targetEntity.position.y + 0.5,
			game.camera.targetEntity.position.z + 0.5,
		}
	}
}