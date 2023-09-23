package data


//= Imports


//= Structures
Player :: struct {
	unit : ^Unit,

	canMove : bool,
}


//= Enumerations
PositionCheck :: enum {
	null,
	empty,
	entity,
	trigger,
	solid,
	step_up,
	step_down,
}

RampType :: enum {
	none,
	up_half,
	down_half,
	up_full,
	down_full,
}