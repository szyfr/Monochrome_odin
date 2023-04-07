package game


//= Imports


//= Structures
Keybinding :: struct {
	origin : u8,
		// 0 - Keyboard
		// 1 - Mouse
		// 2 - MouseWheel
		// 3 - Gamepad Button
		// 4 - Gamepad Axis
	key    : u32,
}


//= Enums
MenuState :: enum {
	none,
	pause,
	pokedex,
	monster,
	bag,
	player,
	options,
}