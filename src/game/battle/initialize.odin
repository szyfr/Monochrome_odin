package battle


//= Imports
import "core:fmt"
import "core:reflect"

import "vendor:raylib"

import "../../game"
import "../general/camera"
import "../general/audio"
import "../overworld/standee"
import "monsters"


//= Procedures
init :: proc(
	event	: ^game.BattleData,
	wild	: bool = false,
) {
	game.battleStruct = new(game.BattleStructure)
	game.battleStruct.arena		= event.arena

	#partial switch event.arena {
		case .grass:
			camera.move({16,0,61}, 1.25)
	}
	

	configure_player_battle_entity()
	configure_enemy_battle_entity(event, wild)
}

close :: proc() {
	for i in game.battleStruct.enemyMonsterList {
		if i != nil do monsters.reset(i)
	}
	if !game.lastBattleOutcome {
		for i:=0;i<4;i+=1 {
			monsters.reset(&game.player.monster[i])
		}
	}

	camera.attach_to_player()
	free(game.battleStruct)
	game.battleStruct = nil
	
	//* Audio
	audio.play_music("new_bark_town")
}

configure_player_battle_entity :: proc() {
	game.battleStruct.playerMonster.position	= {14,0,60}
	game.battleStruct.playerMonster.standee		= standee.create(reflect.enum_string(game.player.monster[0].species), "monster", 2)
	game.battleStruct.playerMonster.monsterInfo	= &game.player.monster[0]
	game.battleStruct.playerMonster.canMove		= true
}
configure_enemy_battle_entity :: proc(
	event	: ^game.BattleData,
	wild	: bool,
) {
	game.battleStruct.enemyMonster.position	= {18,0,60}
	game.battleStruct.enemyMonster.standee		= standee.create("starter_grass", "monster", 2)
	game.battleStruct.enemyMonster.canMove		= true
	game.battleStruct.enemyMonster.wild			= wild

	game.battleStruct.enemyMonsterList[0] = &event.monsterNormal[0]
	game.battleStruct.enemyMonsterList[1] = &event.monsterNormal[1]
	game.battleStruct.enemyMonsterList[2] = &event.monsterNormal[2]
	game.battleStruct.enemyMonsterList[3] = &event.monsterNormal[3]
	game.battleStruct.enemyMonster.monsterInfo	= &event.monsterNormal[0]

	game.battleStruct.enemyName = event.trainerName
}