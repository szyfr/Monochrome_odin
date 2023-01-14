package areas


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../tiles"


//= Procedures
draw :: proc(camera : raylib.Camera3D) {
	for area in areas {
		//TODO: Potentially draw them 0 up to player location then end down?
		for i:=0;i<len(areas[area].tiles);i+=1 {
			tilePos : raylib.Vector3 = {
				f32(int(i) % int(areas[area].width)),
				areas[area].tiles[i].level,
				f32(int(i) / int(areas[area].width)),
			}
			raylib.DrawModelEx(
				tiles.data[areas[area].tiles[i].model],
				tilePos,
				{0, 1, 0},
				0,
				{1, 1, 1},
				raylib.WHITE,
			)
		}
	}
}