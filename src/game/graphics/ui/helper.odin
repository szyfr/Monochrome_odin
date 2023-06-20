package ui


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../../game"
import "../../monsters"


//= Constants
SHOW_STAT	:: 0b00000001
SHOW_AMOUNT	:: 0b00000010
CLEAR_COLOR	:: 0b00000100


//= Procedures
draw_bar :: proc(
	bar : u8,
	position : raylib.Vector2,
	size : raylib.Vector2,
	monster : ^game.Monster,
	style : u8,
) {
	barText		:  cstring
	barTexture	: ^raylib.Texture
	barColor	:  raylib.Color

	builder : strings.Builder
	str : string
	defer delete(str)
	cstr : cstring
	defer delete(cstr)

	screenRatio := f32(game.screenHeight) / 720
	ratio, prevRatio : f32
	offset : f32

	//* Retrieve data
	switch bar {
		case 0: // Health
			barText = game.localization["hp"]
			ratio = f32(monster.hpCur) / f32(monster.hpMax)
			str = fmt.sbprintf(&builder, "%v/%v", monster.hpCur, monster.hpMax)
			prevRatio = game.barHpRat
			barTexture = &game.barHp
			barColor = {247,82,49,255}
		case 1: // Stamina
			barText = game.localization["st"]
			ratio = f32(monster.stCur) / f32(monster.stMax)
			str = fmt.sbprintf(&builder, "%v/%v", monster.stCur, monster.stMax)
			prevRatio = game.barStRat
			barTexture = &game.barSt
			barColor = {255,232,61,255}
		case 2: // Experience
			barText = game.localization["exp"]
			lv := f32(monsters.calculate_experience(monster.level, monster.rate))
			currentExp	:= f32(monster.experience)
			nextExp		:= f32(monsters.calculate_experience(monster.level+1, monster.rate))
			ratio = (currentExp - lv) / (nextExp - lv)
			str = fmt.sbprintf(&builder, "%v", monster.experience)
			prevRatio = game.barExpRat
			barTexture = &game.barExp
			barColor = {99,206,8,255}
	}

	//* Bar text
	if style & 0b0001 != 0 {
		raylib.DrawTextPro(
			game.font,
			barText,
			{(position.x + 4) * screenRatio, (position.y + 4) * screenRatio},
			{0, 0},
			0,
			(16 * screenRatio),
			5,
			{56,56,56,255},
		)
		offset = 60
	}

	//* Bar
	if prevRatio != ratio {
		raylib.UnloadTexture(barTexture^)
		img := raylib.ImageCopy(game.barImg)
		defer raylib.UnloadImage(img)

		if style & 0b0100 != 0 do raylib.ImageColorReplace(&img,{173,173,173,255},{222,255,222,255})

		for i:=0;i<int(ratio * 200);i+=1 do raylib.ImageDrawPixel(&img, i32(i), 0, barColor)

		barTexture^ = raylib.LoadTextureFromImage(img)

		switch bar {
			case 0:  game.barHpRat = ratio
			case 1:  game.barStRat = ratio
			case 2:  game.barExpRat = ratio
		}
	}
	barX := position.x + offset
	raylib.DrawTexturePro(
		barTexture^,
		{0,0,f32(barTexture.width),f32(barTexture.height)},
		{barX * screenRatio, position.y * screenRatio, size.x * screenRatio, size.y * screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)

	if style & 0b0010 != 0 {
		cstr = strings.clone_to_cstring(str)
		raylib.DrawTextPro(
			game.font,
			cstr,
			{(barX + (size.x / 2)) * screenRatio, (position.y + 2) * screenRatio},
			{((f32(len(str)) * 1.25) * (size.y * screenRatio)) / 2, 0},
			0,
			(16 * screenRatio),
			5,
			{56,56,56,255},
		)
	}
}