package unit


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../data"
import "../graphics"


//= Procedures
draw :: proc( unit : ^data.Unit) {
	//texture := graphics.textures["overworld_player"]
	//position := data.playerData.unit.position + {0,0.5,0}
	//raylib.DrawBillboardPro(
	//	camera		= data.cameraData.rl,
	//	texture		= texture,
	//	source		= {0,0,16,16},
	//	position	= position,
	//	up			= {math.sin(data.cameraData.rotation / 57.3), 1, -math.cos(data.cameraData.rotation / 57.3)},
	//	size		= {1, 0.75},
	//	origin		= {0, 0},
	//	rotation	= 0,
	//	tint		= raylib.WHITE,
	//)
	//fmt.printf("fuck\n")
	//model := &data.worldData.models["unit"]
	//model.materials[0] = data.playerData.unit.material
	//raylib.SetModelMeshMaterial(model, 0, data.playerData.unit.material)
	//position := data.playerData.unit.position + {0,0.5,0}
	//raylib.DrawModel(
	//	model^,
	//	position,
	//	1,
	//	raylib.WHITE,
	//)
	//*(mesh: Mesh, material: Material, transform: Matrix)
	mat : raylib.Matrix = {
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		unit.position.x,unit.position.y,unit.position.z,1,
	}
	raylib.DrawMesh(
		unit.display.mesh,
		unit.display.material,
		mat,
	)
}