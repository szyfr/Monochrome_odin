package debug


//= Imports
import "core:strings"

import "vendor:raylib"


//= Structures
Error :: struct {
	text : string,
	timer : i32,
}


//= Global Variables
onscreenErrors : bool = false
errorList : [dynamic]Error


//= Procedures
create_onscreen :: proc(
	text : string,
) {
	append(&errorList, Error{text, 200})
}

update_onscreen :: proc( height : i32 ) {
	newList : [dynamic]Error
	for i in 0..<len(errorList) {
		errorList[i].timer -= 1
		if errorList[i].timer > 0 do append(&newList, errorList[i])
	}
	delete(errorList)
	errorList = newList

	for i in 0..<len(errorList) {
		raylib.DrawText(
			strings.clone_to_cstring(errorList[i].text),
			5,
			(height - 20) - (i32(i) * 25),
			20,
			raylib.RED,
		)
	}
}