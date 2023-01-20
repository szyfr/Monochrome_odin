package over_char


//= Imports
import "vendor:raylib"


//= Procedures
update :: proc(
	char : ^OverworldCharacter,
) {
	if char.isMoving {
		//* Move
		switch char.direction {
			case .up:    char.currentPosition.z += 0.2
			case .down:  char.currentPosition.z -= 0.2
			case .left:  char.currentPosition.x += 0.2
			case .right: char.currentPosition.x -= 0.2
		}

		//* Check if reached location
		if char.currentPosition == char.nextPosition do char.isMoving = false
	}
}