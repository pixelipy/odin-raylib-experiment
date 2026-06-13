package utils

import rl "vendor:raylib"
import config "../config"

draw_to_screen :: proc(target: rl.RenderTexture2D) {
	window_w := f32(rl.GetScreenWidth())
	window_h := f32(rl.GetScreenHeight())

	scale_x := window_w / f32(config.SCREEN_WIDTH)
	scale_y := window_h / f32(config.SCREEN_HEIGHT)

	scale := min(scale_x, scale_y)

	dest_w := f32(config.SCREEN_WIDTH) * scale
	dest_h := f32(config.SCREEN_HEIGHT) * scale

	dest_x := (window_w - dest_w) / 2
	dest_y := (window_h - dest_h) / 2

	source := rl.Rectangle {
		x      = 0,
		y      = 0,
		width  = f32(config.SCREEN_WIDTH),
		height = -f32(config.SCREEN_HEIGHT), // flip vertically
	}

	dest := rl.Rectangle {
		x      = dest_x,
		y      = dest_y,
		width  = dest_w,
		height = dest_h,
	}

	//draw to scaled canvas
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	rl.DrawTexturePro(target.texture, source, dest, rl.Vector2{0, 0}, 0, rl.WHITE)
	rl.EndDrawing()
}
