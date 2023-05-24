package game


//= Imports
import "vendor:raylib"


//= Global variables

running : bool = true

//* General
screenHeight	: i32
screenWidth		: i32
fpsLimit		: i32

keybindings		: map[string]Keybinding

eventmanager	: ^EventManager

//* Text
textSpeed		: i32
language		: string

localization	: map[string]cstring

//* Audio
masterVolume	: f32
musicVolume		: f32
soundVolume		: f32

//* Graphics
standeeMesh		: raylib.Mesh
tiles			: map[string]raylib.Model

//* Entities
camera			: ^Camera
player			: ^Player

//* Map
region			: ^Region