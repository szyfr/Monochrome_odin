package graphics


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures
init :: proc() {
	game.standeeMesh = raylib.GenMeshPlane(1,1,1,1)
}