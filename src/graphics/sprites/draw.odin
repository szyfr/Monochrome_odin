package sprites


//= Imports
import "vendor:raylib"

import "animations"


//= Procedures
draw :: proc(
	camera : raylib.Camera3D,
	sprite : ^Sprite,
) {
//	DrawBillboardPro(
//		Camera camera,
//		Texture2D texture,
//		Rectangle source,
//		Vector3 position,
//		Vector3 up,
//		Vector2 size,
//		Vector2 origin,
//		float rotation,
//		Color tint,
//	);

	//* Low
	raylib.DrawBillboardPro(
		camera,
		sprite.low^,
		sprite_rect(sprite),
		sprite.position,
		{0, 1, 1},
		{1, 1},
		{0, 0},
		0,
		raylib.WHITE,
	)
}

sprite_rect :: proc(sprite : ^Sprite) -> raylib.Rectangle {
	rect : raylib.Rectangle = {0, 0, f32(sprite.width), f32(sprite.height)}
	rect.x = f32(sprite.animator.frame * sprite.width)

	return rect
}