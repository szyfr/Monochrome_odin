package game


//= Imports


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

	turnNumber	: int,
	playersTurn	: bool,

	squares : [8][16]Unit,
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