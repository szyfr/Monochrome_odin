package camera


//= Imports
import "../../game"


//= Procedures
focus :: proc( entity : ^game.Entity ) {
	game.camera.targetEntity = entity
	update()
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