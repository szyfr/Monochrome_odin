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

difficulty		: Difficulty = .medium

homePosition	: raylib.Vector2 = {32, 41}

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
screenRatio		: f32
graphicsUI		: map[string]raylib.Texture
graphicsNPatch	: map[string]raylib.NPatchInfo

boxUI			: raylib.Texture
statusboxUI		: raylib.Texture
boxUI_npatch	: raylib.NPatchInfo

monsterBox		: raylib.Texture
monsterTextures	: map[MonsterSpecies]raylib.Texture
elementalTypes	: raylib.Texture

attackTackleTex	: [3]raylib.Texture
attackTackleMat	: [3]raylib.Material
attackGrowlTex	: raylib.Texture
attackGrowlMat	: raylib.Material
attackLeafageTex	: raylib.Texture
attackLeafageMat	: raylib.Material
attackScratchTex	: raylib.Texture
attackScratchMat	: raylib.Material
attackLeerTex	: raylib.Texture
attackLeerMat	: raylib.Material
attackEmberTex	: raylib.Texture
attackEmberMat	: raylib.Material
attackAquaJetTex	: [3]raylib.Texture
attackAquaJetMat	: [3]raylib.Material

font			: raylib.Font

pointer			: raylib.Texture

barImg			: raylib.Image
barExp			: raylib.Texture
barExpRat		: f32 = -20
barHp			: raylib.Texture
barHpRat		: f32 = -20
barSt			: raylib.Texture
barStRat		: f32 = -20

playerBarHP	: BarGraphic
playerBarST	: BarGraphic
playerBarXP	: BarGraphic

enemyBarHP		: BarGraphic
enemyBarST		: BarGraphic


overlayActive	: bool
overlayTexture	: raylib.Texture
overlayRectangle: raylib.Rectangle

levelUpDisplay : ^ShowLevelUp

emotes			: raylib.Image
emoteList		: [dynamic]EmoteStruct
emoteMaterials	: [8]raylib.Material
emoteMeshDef	: raylib.Mesh

standeeMesh		: raylib.Mesh
tiles			: map[string]raylib.Model

targeter		: raylib.Image
targeterMat		: raylib.Material

moveArrow		: [4]raylib.Material

//* Entities
camera			: ^Camera
player			: ^Player

//* Map
region			: ^Region

//* Combat
battleData		: ^BattleData