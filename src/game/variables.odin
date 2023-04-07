package game


//= Imports
import "vendor:raylib"


//= Constants


//= Globals
running : bool = true

//* Settings
screenWidth		: i32
screenHeight	: i32
fpsLimit		: i32

localization	: map[string]cstring
language		: string

textSpeed		: i32

keybindings		: map[string]Keybinding

masterVolume	: f32
musicVolume		: f32
soundVolume		: f32


//* Core data
camera : ^Camera
player : ^Player


//* Graphics
standeeMesh		: raylib.Mesh

boxUI			: raylib.Texture
boxUI_npatch	: raylib.NPatchInfo
monsterInfoUI	: raylib.Texture
typeTexture		: raylib.Texture
pointer			: raylib.Texture
barHP			: raylib.Texture
barEXP			: raylib.Texture
barImg			: raylib.Image

font			: raylib.Font

//monsterSprites	: map[MonsterSpecies]raylib.Texture