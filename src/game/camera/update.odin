package camera


//= Imports
import "core:fmt"


//= Procedures
update :: proc() {
	if data.follow != nil {
		data.target   = data.follow.position + {0.5, 0.5, 0.5}
		data.position = data.follow.position + {0.5, 7.5, 3}
	}
}