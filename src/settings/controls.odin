package settings


//= Imports
import "vendor:raylib"

import "../debug"


//= Procedures

//* Key is pressed once
button_pressed :: proc( key : string ) -> bool {
	keybind, ok := keybindings[key]

	if !ok {
		debug.logf("[ERROR] - Attempted to use an unset keybinding [%v].", key)
		return false
	}

	switch keybind.origin {
		case .keyboard:
			return raylib.IsKeyPressed(raylib.KeyboardKey(keybind.code))
		case .mouse:
			return raylib.IsMouseButtonPressed(raylib.MouseButton(keybind.code))
		case .controller:
			if raylib.IsGamepadAvailable(keybind.controller) do return raylib.IsGamepadButtonPressed(keybind.controller, raylib.GamepadButton(keybind.code))
			else do debug.log("[ERROR] - Attemted to use controller that isn't plugged in.")
	}
	return false
}

//* Key is held down
button_down :: proc( key : string ) -> bool {
	keybind, ok := keybindings[key]

	if !ok {
		debug.logf("[ERROR] - Attempted to use an unset keybinding [%v].", key)
		return false
	}

	switch keybind.origin {
		case .keyboard:
			return raylib.IsKeyDown(raylib.KeyboardKey(keybind.code))
		case .mouse:
			return raylib.IsMouseButtonDown(raylib.MouseButton(keybind.code))
		case .controller:
			if raylib.IsGamepadAvailable(keybind.controller) do return raylib.IsGamepadButtonDown(keybind.controller, raylib.GamepadButton(keybind.code))
			else do debug.log("[ERROR] - Attemted to use controller that isn't plugged in.")
	}
	return false
}

//* Key is released once
button_released :: proc( key : string ) -> bool {
	keybind, ok := keybindings[key]

	if !ok {
		debug.logf("[ERROR] - Attempted to use an unset keybinding [%v].", key)
		return false
	}

	switch keybind.origin {
		case .keyboard:
			return raylib.IsKeyReleased(raylib.KeyboardKey(keybind.code))
		case .mouse:
			return raylib.IsMouseButtonReleased(raylib.MouseButton(keybind.code))
		case .controller:
			if raylib.IsGamepadAvailable(keybind.controller) do return raylib.IsGamepadButtonReleased(keybind.controller, raylib.GamepadButton(keybind.code))
			else do debug.log("[ERROR] - Attemted to use controller that isn't plugged in.")
	}
	return false
}

//* Key is not held down
button_up :: proc( key : string ) -> bool {
	keybind, ok := keybindings[key]

	if !ok {
		debug.logf("[ERROR] - Attempted to use an unset keybinding [%v].", key)
		return false
	}

	switch keybind.origin {
		case .keyboard:
			return raylib.IsKeyUp(raylib.KeyboardKey(keybind.code))
		case .mouse:
			return raylib.IsMouseButtonUp(raylib.MouseButton(keybind.code))
		case .controller:
			if raylib.IsGamepadAvailable(keybind.controller) do return raylib.IsGamepadButtonUp(keybind.controller, raylib.GamepadButton(keybind.code))
			else do debug.log("[ERROR] - Attemted to use controller that isn't plugged in.")
	}
	return false
}