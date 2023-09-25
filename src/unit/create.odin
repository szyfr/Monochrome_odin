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

	unit.display.mesh		= model.meshes[0]
	unit.display.material	= raylib.LoadMaterialDefault()
	unit.display.image		= raylib.LoadImageFromTexture(texture^)
	img					   := raylib.ImageFromImage(unit.display.image, {0,0,16,16})
	unit.display.texture	= raylib.LoadTextureFromImage(img)
	unit.display.material.maps[0].texture = unit.display.texture
	
	return unit
}