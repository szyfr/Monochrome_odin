package world


//= Imports
import "core:fmt"
import "core:math"
import "vendor:raylib"

import "../data"
import "../unit"
import "../system"


//= Procedures
draw :: proc() {
	using data

	//* Change order of drawing based on the current direction of camera rotation
	switch {
		case (cameraData.rotation > -45 && cameraData.rotation <=  45) || (cameraData.rotation > 315 && cameraData.rotation <= 405):
			draw_line_000()
		case cameraData.rotation >  45 && cameraData.rotation <= 135:
			draw_line_090()
		case cameraData.rotation > 135 && cameraData.rotation <= 225:
			draw_line_180()
		case (cameraData.rotation > 225 && cameraData.rotation <= 315) || (cameraData.rotation > -135 && cameraData.rotation <= -45):
			draw_line_270()
	}
}

// TODO Add unit rendering into draw lines

draw_line_000 :: proc() {
	//* Initialize all variables
	playerPosition : raylib.Vector3
	playerPosition.x = math.round(data.playerData.unit.position.x)
	playerPosition.y = math.round(data.playerData.unit.position.y)
	playerPosition.z = math.round(data.playerData.unit.position.z)
	maxX, minX := playerPosition.x + WIDTH,  playerPosition.x - WIDTH
	maxY, minY := playerPosition.y + HEIGHT, playerPosition.y - HEIGHT
	maxZ, minZ := playerPosition.z + DEPTH,  playerPosition.z - DEPTH
	width  := maxX - minX
	height := maxY - minY
	depth  := maxZ - minZ

	for z:=minZ;z<maxZ;z+=1 {
		x := minX
		flip := false

		if math.round(data.playerData.unit.position.z) == z-1 do unit.draw(data.playerData.unit)

		for c:f32=0;c!=width;c+=1 {
			for y:=minY;y<maxY;y+=0.5 {
				//* Tiles
				tile, resTile := &data.worldData.currentMap[{x,y,z}]
				if resTile {
					model, resModel := &data.worldData.models[tile.model]
					if resModel do raylib.DrawModelEx( model^, {x,y,z}, {0,1,0}, -360, {1,1,1}, raylib.WHITE )
				}

				//* Units
				// TODO
			}
			if !flip do x += 1
			else     do x -= 1

			if x >= playerPosition.x && !flip {
				flip = true
				x = maxX-1
			}
		}

		//for x:=0;x<100;x+=1 {
			
		//}
	}
}

draw_line_090 :: proc() {
	//* Initialize all variables
	playerPosition := data.playerData.unit.trgPosition
	maxX, minX := playerPosition.x + WIDTH,  playerPosition.x - WIDTH
	maxY, minY := playerPosition.y + HEIGHT, playerPosition.y - HEIGHT
	maxZ, minZ := playerPosition.z + DEPTH,  playerPosition.z - DEPTH
	width  := maxX - minX
	height := maxY - minY
	depth  := maxZ - minZ

	for x:=maxX;x>minX;x-=1 {
		z := maxZ
		flip := false

		unit.draw(data.playerData.unit)

		for c:f32=0;c!=depth;c+=1 {
			for y:=minY;y<maxY;y+=0.5 {
				tile, resTile := &data.worldData.currentMap[{x,y,z}]
				if resTile {
					model, resModel := &data.worldData.models[tile.model]
					rotation : f32 = 0
					if tile.trnsp do rotation = -90
					if resModel do raylib.DrawModelEx( model^, {x,y,z}, {0,1,0}, rotation, {1,1,1}, raylib.WHITE )
				}
			}
			if !flip do z -= 1
			else     do z += 1

			if z <= playerPosition.z && !flip {
				flip = true
				z = minZ+1
			}
		}
	}
}

draw_line_180 :: proc() {
	//* Initialize all variables
	playerPosition : raylib.Vector3
	playerPosition.x = math.round(data.playerData.unit.position.x)
	playerPosition.y = math.round(data.playerData.unit.position.y)
	playerPosition.z = math.round(data.playerData.unit.position.z)
	maxX, minX := playerPosition.x + WIDTH,  playerPosition.x - WIDTH
	maxY, minY := playerPosition.y + HEIGHT, playerPosition.y - HEIGHT
	maxZ, minZ := playerPosition.z + DEPTH,  playerPosition.z - DEPTH
	width  := maxX - minX
	height := maxY - minY
	depth  := maxZ - minZ

	for z:=maxZ;z>minZ;z-=1 {
		x := maxX
		flip := false

		unit.draw(data.playerData.unit)

		for c:f32=0;c!=width;c+=1 {
			for y:=minY;y<maxY;y+=0.5 {
				tile, resTile := &data.worldData.currentMap[{x,y,z}]
				if resTile {
					model, resModel := &data.worldData.models[tile.model]
					rotation : f32 = 0
					if tile.trnsp do rotation = -180
					if resModel do raylib.DrawModelEx( model^, {x,y,z}, {0,1,0}, rotation, {1,1,1}, raylib.WHITE )
				}
			}
			if !flip do x -= 1
			else     do x += 1

			if x <= playerPosition.x && !flip {
				flip = true
				x = minX+1
			}
		}
		unit.draw(data.playerData.unit)
	}
}

draw_line_270 :: proc() {
	//* Initialize all variables
	playerPosition := data.playerData.unit.trgPosition
	maxX, minX := playerPosition.x + WIDTH,  playerPosition.x - WIDTH
	maxY, minY := playerPosition.y + HEIGHT, playerPosition.y - HEIGHT
	maxZ, minZ := playerPosition.z + DEPTH,  playerPosition.z - DEPTH
	width  := maxX - minX
	height := maxY - minY
	depth  := maxZ - minZ

	for x:=minX;x<maxX;x+=1 {
		z := minZ
		flip := false

		unit.draw(data.playerData.unit)

		for c:f32=0;c!=depth;c+=1 {
			for y:=minY;y<maxY;y+=0.5 {
				tile, resTile := &data.worldData.currentMap[{x,y,z}]
				if resTile {
					model, resModel := &data.worldData.models[tile.model]
					rotation : f32 = 0
					if tile.trnsp do rotation = -270
					if resModel do raylib.DrawModelEx( model^, {x,y,z}, {0,1,0}, rotation, {1,1,1}, raylib.WHITE )

				}
			}
			if !flip do z += 1
			else     do z -= 1

			if z >= playerPosition.z && !flip {
				flip = true
				z = maxZ-1
			}
		}
	}
}