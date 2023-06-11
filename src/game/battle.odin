package game


//= Imports
import "vendor:raylib"


//= Structures
BattleInfo :: struct {
	trainerName : string,
	arenaType : ArenaType,

	teamEasy	: [8]Monster,
	teamMedium	: [8]Monster,
	teamHard	: [8]Monster,
}

BattleData :: struct {
	trainerName : string,
	arenaType : ArenaType,

	enemyTeam		:  [8]Monster,
	currentEnemy	:  int,
	playerTeam		: ^[4]Monster,
	currentPlayer	:  int,

	entities		: [dynamic]Entity,

	turnNumber	: int,
	playersTurn	: bool,
	playerFirst	: bool,

	squares : [8][16]Unit,
	target	: raylib.Vector2,
}

Unit :: union {
	bool,
	^Monster,
	int,
}


//= Enum
ArenaType :: enum {
	grass,
	city,
	indoors,
}

TurnOrder :: enum {
	player,
	enemy,
}