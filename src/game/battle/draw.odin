package battle


//= Imports
import "core:fmt"
import "core:reflect"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../entity/overworld"


//= Procedures
draw :: proc() {
	if game.battleData != nil {
		#partial switch game.battleData.playerAction {
			case .info:
				//* Draw cursor
				transform : raylib.Matrix = {
					1.00, 0.00, 0.00, 0.00,
					0.00, 1.00, 0.00, 0.00,
					0.00, 0.00, 1.00, 0.00,
					0.00, 0.00, 0.00, 1.00,
				}
				transform[3,0] = game.battleData.target.x + 8.5
				transform[3,1] = 0.01
				transform[3,2] = game.battleData.target.y + 56.5
				raylib.DrawMesh(game.standeeMesh, game.targeterMat, transform)

				//* Draw info
				token : ^game.Token
				pos : raylib.Vector3 = {game.battleData.target.x + 8, 0, game.battleData.target.y + 55.75}
				for i:=0;i<len(game.battleData.field);i+=1 {
					if game.battleData.field[i].entity.position == pos {
						token = &game.battleData.field[i]
						break
					}
				}
				if token != nil {
					str : string = ""
					defer delete(str)
					builder : strings.Builder

					switch token.type {
						case .player:
							//monsterName := game.localization[reflect.enum_string(game.battleData.playerTeam[token.data.(int)].species)]
							//str = fmt.sbprintf(
							//	&builder,
							//	"%v\nLv%v",
							//	monsterName,
							//	game.battleData.playerTeam[token.data.(int)].level,
							//)
						case .enemy:
							//monsterName := game.localization[reflect.enum_string(game.battleData.enemyTeam[token.data.(int)].species)]
							//str = fmt.sbprintf(
							//	&builder,
							//	"%v\nLv%v",
							//	monsterName,
							//	game.battleData.enemyTeam[token.data.(int)].level,
							//)
						case .hazard:
						case .wall:
					}
					game.battleData.infoText = strings.clone_to_cstring(str)
				} else {
					game.battleData.infoText = ""
				}
			case .move:
			case .attack1:
			case .attack2:
			case .attack3:
			case .attack4:
			case .item:
			case .switch_in:
		}


		//* Entities
		for i:=0;i<len(game.battleData.field);i+=1 {
			overworld.draw(&game.battleData.field[i].entity, 1.5)
		}
	}
}