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

	field : map[string]Token,
	playerHazardCount	: int,
	enemyHazardCount	: int,

	turnNumber	: int,
	playersTurn	: bool,
	playerFirst	: bool,

	movementTimer : int,
	movementOffset : int,

	playerAction	: PlayerAction,
	target			: raylib.Vector2,
	moveArrowList	: [dynamic]raylib.Vector2,
	moveArrowComp	: bool,
	moveArrowDraw	: bool,

	infoText : cstring,
}

Token :: struct {
	entity : Entity,
	type : TokenType,
	data : union {
		int,
		f32,
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
	interaction,
	item,
	switch_in,
	
	attack1,
	attack2,
	attack3,
	attack4,
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