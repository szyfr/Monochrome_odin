package mathz


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"


//= Procedures
approximately :: proc{ approximately_Vector3 }

approximately_Vector3 :: proc(
	v1 : raylib.Vector3,
	v2 : raylib.Vector3,
) -> bool {
	builder1 : strings.Builder
	builder2 : strings.Builder
	strings.builder_reset(&builder1)
	strings.builder_reset(&builder2)

	str1 := fmt.sbprintf(&builder1, "%.3f", v1.x)
	str2 := fmt.sbprintf(&builder2, "%.3f", v2.x)
	if str1 != str2 do return false
	
	strings.builder_reset(&builder1)
	strings.builder_reset(&builder2)

	str1 = fmt.sbprintf(&builder1, "%.3f", v1.y)
	str2 = fmt.sbprintf(&builder2, "%.3f", v2.y)
	if str1 != str2 do return false
	
	strings.builder_reset(&builder1)
	strings.builder_reset(&builder2)

	str1 = fmt.sbprintf(&builder1, "%.3f", v1.z)
	str2 = fmt.sbprintf(&builder2, "%.3f", v2.z)
	if str1 != str2 do return false


	return true
}