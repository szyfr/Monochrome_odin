package settings


//= Imports
import "vendor:raylib"

import "../game"
import "../debug"


//= Procedures
is_key_down :: proc(
	keycode : string,
) -> bool {
	key, result := game.keybindings[keycode]
	if !result {
		debug.log("[ERROR] - Attempted to use a keybinding that wasn't bound.")
		return false
	}

	switch key.origin {
		case 0: // Keyboard
			return raylib.IsKeyDown(raylib.KeyboardKey(key.key))
		case 1: // Mouse
			return raylib.IsMouseButtonDown(raylib.MouseButton(key.key))
		case 2: // Controller
			return raylib.IsGamepadButtonDown(0, raylib.GamepadButton(key.key))
		case: return false
	}
}

is_key_pressed :: proc(
	keycode : string,
) -> bool {
	key, result := game.keybindings[keycode]
	if !result {
		debug.log("[ERROR] - Attempted to use a keybinding that wasn't bound.")
		return false
	}

	switch key.origin {
		case 0: // Keyboard
			return raylib.IsKeyPressed(raylib.KeyboardKey(key.key))
		case 1: // Mouse
			return raylib.IsMouseButtonPressed(raylib.MouseButton(key.key))
		case 2: // Controller
			return raylib.IsGamepadButtonPressed(0, raylib.GamepadButton(key.key))
		case: return false
	}
}

is_key_released :: proc(
	keycode : string,
) -> bool {
	key, result := game.keybindings[keycode]
	if !result {
		debug.log("[ERROR] - Attempted to use a keybinding that wasn't bound.")
		return false
	}

	switch key.origin {
		case 0: // Keyboard
			return raylib.IsKeyReleased(raylib.KeyboardKey(key.key))
		case 1: // Mouse
			return raylib.IsMouseButtonReleased(raylib.MouseButton(key.key))
		case 2: // Controller
			return raylib.IsGamepadButtonReleased(0, raylib.GamepadButton(key.key))
		case: return false
	}
}

is_key_up :: proc(
	keycode : string,
) -> bool {
	key, result := game.keybindings[keycode]
	if !result {
		debug.log("[ERROR] - Attempted to use a keybinding that wasn't bound.")
		return false
	}

	switch key.origin {
		case 0: // Keyboard
			return raylib.IsKeyUp(raylib.KeyboardKey(key.key))
		case 1: // Mouse
			return raylib.IsMouseButtonUp(raylib.MouseButton(key.key))
		case 2: // Controller
			return raylib.IsGamepadButtonUp(0, raylib.GamepadButton(key.key))
		case: return false
	}
}

get_axis :: proc(
	axis : string,
) -> int {
	output := 0

	switch axis {
		case "vertical":
			if is_key_down("up") do output += 1
			if is_key_down("down") do output -= 1
		case "horizontal":
			if is_key_down("left") do output += 1
			if is_key_down("right") do output -= 1
	}

	return output
}