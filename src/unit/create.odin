package unit


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../data"
import "../graphics"


//= Procedures
create :: proc( position : raylib.Vector3 = {0,0,0}, texture : string = "overworld_player" ) -> ^data.Unit {
	unit := new(data.Unit)

	unit.position = position
	unit.trgPosition = position

	model := &data.worldData.models["unit"]
	texture := &graphics.textures[texture]

	unit.animator.mesh		= model.meshes[0]
	unit.animator.material	= raylib.LoadMaterialDefault()

	img := raylib.LoadImageFromTexture(texture^)
	for i:=0;i<int(img.width/img.height);i+=1 {
		img_2 := raylib.ImageFromImage(img, {f32(i*int(img.height)),0,f32(img.height),f32(img.height)})
		append(&unit.animator.textures, raylib.LoadTextureFromImage(img_2))
		raylib.UnloadImage(img_2)
	}
	raylib.UnloadImage(img)

	set_animation("idle_south", unit)

	unit.animator.material.maps[0].texture = unit.animator.textures[0]
	
	return unit
}