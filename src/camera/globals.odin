package camera


//= Imports
import "vendor:raylib"

import "../data"


//= Globals
rl : raylib.Camera3D

position, trgPosition : raylib.Vector3
rotation, trgRotation : f32

targetUnit : ^data.Unit