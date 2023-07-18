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
	flinch	: bool,

	size	: Size,

	ai : AIType,

	movesMax : int,
	movesCur : int,

	experience	: int,
	level		: int,
	rate		: ExperienceRate,
	//TODO Nature

	attacks : [4]MonsterAttack,
}


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
	fire,
	water,
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
	aquajet,
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

ExperienceRate :: enum {
	fast,
	medium,
	slow,
}

AIType :: enum {
	tank_setup,
	ranged_special,
	brawler_physical,
}