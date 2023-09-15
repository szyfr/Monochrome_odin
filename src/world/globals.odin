package world


//= Imports
import "vendor:raylib"

import "../data"


//= Globals
models : map[string]raylib.Model

currentMap : map[raylib.Vector3]data.Tile