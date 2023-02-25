package settings


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures
is_key_down :: proc(
	keycode : string,
) -> bool {
	key, res := game.settings.keybindings[keycode]

	if !res do return false

	switch key.origin {
		case 0: //* Keyboard
			if raylib.IsKeyDown(raylib.KeyboardKey(key.key)) do return true
		case 1: //* Mouse
			if raylib.IsMouseButtonDown(raylib.MouseButton(key.key)) do return true
		case 2: //* Controller
			if raylib.IsGamepadButtonDown(0, raylib.GamepadButton(key.key)) do return true
	}
	return false
}

is_key_pressed :: proc(
	keycode : string,
) -> bool {
	key, res := game.settings.keybindings[keycode]

	if !res do return false

	switch key.origin {
		case 0: //* Keyboard
			if raylib.IsKeyPressed(raylib.KeyboardKey(key.key)) do return true
		case 1: //* Mouse
			if raylib.IsMouseButtonPressed(raylib.MouseButton(key.key)) do return true
		case 2: //* Controller
			if raylib.IsGamepadButtonPressed(0, raylib.GamepadButton(key.key)) do return true
	}
	return false
}

is_key_released :: proc(
	keycode : string,
) -> bool {
	key, res := game.settings.keybindings[keycode]

	if !res do return false

	switch key.origin {
		case 0: //* Keyboard
			if raylib.IsKeyReleased(raylib.KeyboardKey(key.key)) do return true
		case 1: //* Mouse
			if raylib.IsMouseButtonReleased(raylib.MouseButton(key.key)) do return true
		case 2: //* Controller
			if raylib.IsGamepadButtonReleased(0, raylib.GamepadButton(key.key)) do return true
	}
	return false
}

is_key_up :: proc(
	keycode : string,
) -> bool {
	key, res := game.settings.keybindings[keycode]

	if !res do return false

	switch key.origin {
		case 0: //* Keyboard
			if raylib.IsKeyUp(raylib.KeyboardKey(key.key)) do return true
		case 1: //* Mouse
			if raylib.IsMouseButtonUp(raylib.MouseButton(key.key)) do return true
		case 2: //* Controller
			if raylib.IsGamepadButtonUp(0, raylib.GamepadButton(key.key)) do return true
	}
	return false
}