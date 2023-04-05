package game


//= Imports
import "vendor:raylib"


//= Globals


//= Structures
BattleData :: struct {
	id				: string,
	trainerName		: string,
	arena			: Arena,
	monsterNormal	: [4]Monster,
	monsterHard		: [4]Monster,
}

Keybinding :: struct {
	origin : u8,
		// 0 - Keyboard
		// 1 - Mouse
		// 2 - MouseWheel
		// 3 - Gamepad Button
		// 4 - Gamepad Axis
	key    : u32,
}

BattleStructure :: struct {
	arena		: Arena,

	playerMonster	: BattleEntity,
	enemyMonster	: BattleEntity,
	enemyMonsterList: [4]^Monster,
	enemyName		: string,

	experience		: int,

	playerHPBar		: raylib.Texture,
	playerEXPBar	: raylib.Texture,
	enemyHPBar		: raylib.Texture,
	playerAttackRot	: f32,
	rotationDirect	: bool,

	attackEntities	: [dynamic]AttackEntity,
}
BattleEntity :: struct {
	position	: raylib.Vector3,
	isMoving	: bool,
	canMove		: bool,
	timer		: int,
	direction	: Direction,
	bounds		: raylib.BoundingBox,
	selectedAtk	: int,

	enemyAi		: AIType,

	wild		: bool,

	forcedMove			: bool,
	forcedMoveTarget	: raylib.Vector3,
	forcedMoveStart		: raylib.Vector3,

	standee		: ^Standee,

	monsterInfo	: ^Monster,

	target	: raylib.Vector3,
}

AttackEntity :: union {
	AttackFollow,
}
AttackFollow :: struct {
	attackModel : string,
	target	: ^BattleEntity,
	bounds	: raylib.BoundingBox,
	boundsSize : raylib.Vector3,
	sphere: bool,

	attackType		: AttackType,
	elementalType	: ElementalType,
	power			: f32,
	effects			: [dynamic]AttackEffect,

	life	: int,
	user	: ^Monster,
	player	: bool,
}

AttackOverlay :: union {
	AttackOverlayGeneral,
}
AttackOverlayGeneral :: struct {
	origin	: raylib.Vector3,
	mesh	: raylib.Mesh,
	model	: raylib.Model,
	texture	: raylib.Texture,
}


//= Enumerations





AttackEffect :: enum {
	atkDown_enemy,
	atkDown_self,
	defDown_enemy,
	defDown_self,
	spatkDown_enemy,
	spatkDown_self,
	spdefDown_enemy,
	spdefDown_self,
	spdDown_enemy,
	spdDown_self,
	
	atkUp_enemy,
	atkUp_self,
	defUp_enemy,
	defUp_self,
	spatkUp_enemy,
	spatkUp_self,
	spdefUp_enemy,
	spdefUp_self,
	spdUp_enemy,
	spdUp_self,
}

AIType :: enum {
	physical_close_range,
}

Arena :: enum {
	empty,
	grass,
	forest,
	building,
	city,
	beach,
	water,
}

MenuState :: enum {
	none,
	pause,
	pokedex,
	monster,
	bag,
	player,
	options,
}