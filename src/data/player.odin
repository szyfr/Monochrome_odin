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