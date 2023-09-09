package localization


//= Imports
import "core:strings"

import "../game"


//= Procedures
grab_pointer :: proc( key : string ) -> ^cstring {
	_, result := game.localization[key]

	if !result do return nil
	return &game.localization[key]
}
grab_cstring :: proc( key : string ) -> cstring {
	value, result := game.localization[key]

	if !result do return strings.clone_to_cstring(key)
	return value
}