package over_char


//= Imports
import "core:fmt"

import "vendor:raylib"


//= Procedures
move :: proc(
	direction : Direction,

	char : ^OverworldCharacter,
) {
	if !char.isMoving {
		char.isMoving  = true
		char.direction = direction
		fmt.printf("fuck\n")

		switch char.direction {
			case .up:    char.nextPosition = char.currentPosition + {0,0,1}
			case .down:  char.nextPosition = char.currentPosition - {0,0,1}
			case .left:  char.nextPosition = char.currentPosition + {1,0,0}
			case .right: char.nextPosition = char.currentPosition - {1,0,0}
		}
	}
}