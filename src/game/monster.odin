package game


//= Imports
import "vendor:raylib"


//= Structures
Monster :: struct {
	species : MonsterSpecies,
	elementalType1	: ElementalType,
	elementalType2	: ElementalType,

	nickname: cstring,

	iv		: [6]int,
	ev		: [6]int,

	hpMax	: int,
	hpCur	: int,

	atk		: int,
	def		: int,
	spAtk	: int,
	spDef	: int,
	spd		: int,
	
	statChanges : [6]int,

	size	: Size,

	experience	: int,
	level		: int,
	//TODO Nature

	attacks : [4]Attack,
}

Attack :: struct {
	type : MonsterAttack,
	cooldown : int,
}


//= Enumerations
MonsterSpecies :: enum {
	empty,

	chikorita,
	bayleef,
	meganium,

	cyndaquil,
	quilava,
	typhlosion,

	totodile,
	croconaw,
	feraligatr,
}

ElementalType :: enum {
	none,
	normal,
	water,
	fire,
	grass,
}

MonsterAttack :: enum {
	empty,

	tackle,
	scratch,

	growl,
	leer,

	leafage,
	ember,
	watergun,
}
AttackType :: enum {
	physical,
	special,
	other,
}

Size :: enum {
	small,
	medium,
	large,
}