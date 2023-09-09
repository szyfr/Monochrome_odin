package data


//= Imports


//= Structures
Keybinding :: struct {
	origin	: Origin,
	controller : i32,
	code	: u32,
}

//= Enumerations
Origin :: enum {
	keyboard,
	mouse,
	controller,
}
Language :: enum {
	english,
	french,
	german,
}