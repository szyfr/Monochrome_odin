package game


//= Imports
import "core:encoding/json"

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

audio			: ^AudioSystem

//* Graphics
boxUI			: raylib.Texture
boxUI_npatch	: raylib.NPatchInfo

monsterBox		: raylib.Texture
monsterTextures	: map[string]raylib.Texture

font			: raylib.Font

pointer			: raylib.Texture

overlayActive	: bool
overlayTexture	: raylib.Texture
overlayRectangle: raylib.Rectangle

emotes			: raylib.Image
emoteList		: [dynamic]EmoteStruct
emoteMaterials	: [8]raylib.Material
emoteMeshDef	: raylib.Mesh

standeeMesh		: raylib.Mesh
tiles			: map[string]raylib.Model

//* Entities
camera			: ^Camera
player			: ^Player

//* Map
region			: ^Region

//* Monsters