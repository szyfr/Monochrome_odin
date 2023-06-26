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

	field : [dynamic]Token,

	turnNumber	: int,
	playersTurn	: bool,
	playerFirst	: bool,

	playerAction : PlayerAction,
	target : raylib.Vector2,

	infoText : cstring,
}

Token :: struct {
	entity : Entity,
	type : TokenType,
	data : union {
		int,
	}
}

//BattleData :: struct {
//	trainerName : string,
//	arenaType : ArenaType,
//
//	enemyTeam		:  [8]Monster,
//	currentEnemy	:  int,
//	playerTeam		: ^[4]Monster,
//	currentPlayer	:  int,
//
//	entities		: [dynamic]Entity,
//
//	turnNumber	: int,
//	playersTurn	: bool,
//	playerFirst	: bool,
//
//	playerAction : PlayerAction,
//
//	squares : [8][16]Unit,
//	target	: raylib.Vector2,
//}
//
//Unit :: union {
//	bool,
//	^Monster,
//	int,
//}


//= Enum
ArenaType :: enum {
	grass,
	city,
	indoors,
}

TokenType :: enum {
	player,
	enemy,
	hazard,
	wall,
}

TurnOrder :: enum {
	player,
	enemy,
}

PlayerAction :: enum {
	info,
	move,
	attack1,
	attack2,
	attack3,
	attack4,
	item,
	switch_in,
}

ArrowType :: enum {
	middle,
	turn,
	end,
}

ARROW_RIGHT : f32 :   0
ARROW_DOWN	: f32 :  90
ARROW_LEFT	: f32 : 180
ARROW_UP	: f32 : 270