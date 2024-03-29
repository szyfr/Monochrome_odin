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

//	events : [dynamic]BattleEvent,
	event : BattleEvent,
	counter : int,

	enemyTeam		:  [8]Monster,
	currentEnemy	:  int,
	enemyBrain		:  AIBrain,

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
	messages : [dynamic]Message,

	experience : int,
}

Message :: struct {
	str : cstring,
	time : int,
}

Token :: struct {
	entity : Entity,
	type : TokenType,
	data : union {
		int,
		f32,
		AttackData,
	}
}

AttackData :: struct {
	attack							: MonsterAttack,
	user, target					: ^Monster,
	userToken, targetToken			: ^Token,
	userPosition, targetPosition	:  raylib.Vector2,
}

BattleEvent :: union {
	DamageMonster,
	MoveMonster,
	UseAttack,
}

DamageMonster :: struct {
	monster : ^Monster,
	remainder : int,
}
MoveMonster :: struct {
	monster		: ^Token,
	direction	: Direction,
	target		: raylib.Vector3,
}
UseAttack :: struct {
	attack : MonsterAttack,
	position : raylib.Vector3,
	direction : Direction,
}


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