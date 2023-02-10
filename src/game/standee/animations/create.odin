package animations


//= Imports
import "core:encoding/json"

import "../../../game"


//= Procedures
create :: proc{ create_array }

create_array :: proc(
	array : json.Array,
) -> game.Animation {
	ani : game.Animation = {
		animationSpeed = u32(array[0].(f64)),
	}

	for i:=1;i<len(array);i+=1 do append(&ani.frames, u32(array[i].(f64)))

	return ani
}