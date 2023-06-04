package game


//= Imports
import "vendor:raylib"


//= Structures
Monster :: struct {
	species : MonsterSpecies,
	elementalType1	: ElementalType,
	elementalType2	: ElementalType,

	nickname: cstring,

	hpMax, hpCur	: int,
	stMax, stCur	: int,

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

	attacks : [4]MonsterAttack,
}

//Attack :: struct {
//	type : MonsterAttack,
//}


//= Enumerations
MonsterSpecies :: enum {
	empty,

	starter_grass,
	starter_grass_1,
	starter_grass_2,

	starter_fire,
	starter_fire_1,
	starter_fire_2,

	starter_water,
	starter_water_1,
	starter_water_2,
}

ElementalType :: enum {
	none,
	normal,
	water,
	fire,
	grass,
}

MonsterAttack :: enum {
	none,

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