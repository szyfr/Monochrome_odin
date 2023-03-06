package standee


//= Imports
import "core:encoding/json"
import "core:strings"
import "core:os"
import "core:fmt"

import "vendor:raylib"

import "../../../game"
import "../../general/graphics/animations"


//= Constants
SPR_LOCATION :: "data/sprites/spr_"
SPR_FILETYPE :: ".png"
ANI_LOCATION :: "data/sprites/ani_"
ANI_FILETYPE :: ".json"


//= Procedures
create :: proc(
	filenameI	: string,
	filenameA	: string = "",
	size		: f32 = 1,
) -> ^game.Standee {
	standee := new(game.Standee)

	//* Mesh, Material, and Matrix
	standee.mesh     = raylib.GenMeshPlane(size,size,1,1)
	standee.material = raylib.LoadMaterialDefault();
	standee.position = {
		1.00,  0.00, 0.00, 0.00,
		0.00,  0.78, 0.80, 0.00,
		0.00, -0.80, 0.78, 0.00,
		0.00,  0.00, 0.00, 1.00,
	}

	//* Get filenames
	fullpath_animation : string
	fullpath_image     := strings.clone_to_cstring(strings.concatenate({SPR_LOCATION, filenameI, SPR_FILETYPE}))
	if filenameA != "" do fullpath_animation = strings.concatenate({ANI_LOCATION, filenameA, ANI_FILETYPE})
	else do fullpath_animation = strings.concatenate({ANI_LOCATION, filenameI, ANI_FILETYPE})

	//* Animatior
	standee.animator.rawImage = raylib.LoadImage(fullpath_image)
	standee.animator.currentAnimation = ""
	standee.animator.frame = 0
	standee.animator.timer = 0

	//* Parse aniamtion data
	raw, er := os.read_entire_file_from_filename(fullpath_animation)
	js, err := json.parse(raw)
	for animation in js.(json.Object) {
		standee.animator.animations[animation] = animations.create(js.(json.Object)[animation].(json.Array))
	}

	//* Initialize texture
	frame := raylib.ImageFromImage(
		standee.animator.rawImage,
		{
			f32(standee.animator.rawImage.height * i32(standee.animator.frame)),
			0,
			f32(standee.animator.rawImage.height),
			f32(standee.animator.rawImage.height),
		},
	)
	standee.material.maps[0].texture = raylib.LoadTextureFromImage(frame)

	return standee
}