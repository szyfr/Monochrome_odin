package animator


//= Imports
import "core:os"
import "core:strings"


//= Procedures
create :: proc(
	spriteName		: string,
	animationName	: string,
) -> game.Animator {
	data : game.Animator = {}

	//* Check private folder
	privateAnimationName	: cstring
	privateSpriteName		:= strings.clone_to_cstring(
		strings.concatenate({
			"data/private/overworld/",
			spriteName,
			".png",
		})
	)
	if animationName != "" {
		privateAnimationName := strings.clone_to_cstring(
			strings.concatenate({
				"data/private/overworld/",
				animationName,
				".json",
			})
		)
	} else do privateAnimationName := strings.clone_to_cstring("data/private/overworld/generic.json")
	
	if os.exists(privateSpriteName) {
		//LOAD
	}

	//* Check core folder
}