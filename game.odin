package game

import camera_pkg "camera"
import config_pkg "config"
import level_pkg "level"
import physics_pkg "physics"
import player_pkg "player"
import utils_pkg "utils"

import rl "vendor:raylib"

player: player_pkg.Player
camera: rl.Camera2D
level: level_pkg.Level
debug_rects: [dynamic]rl.Rectangle

main :: proc() {
	rl.InitWindow(config_pkg.SCREEN_WIDTH * 4, config_pkg.SCREEN_HEIGHT * 4, "My First Game")
	defer rl.CloseWindow()

	target := rl.LoadRenderTexture(config_pkg.SCREEN_WIDTH, config_pkg.SCREEN_HEIGHT)
	defer rl.UnloadRenderTexture(target)

	rl.SetTextureFilter(target.texture, rl.TextureFilter.POINT)
	rl.SetWindowState({.WINDOW_RESIZABLE})
	rl.SetTargetFPS(500)

	level = level_pkg.load_level("assets/levels/level1.png")
	defer level_pkg.destroy(&level)

	debug_rects = make([dynamic]rl.Rectangle)
	defer delete(debug_rects)

	init()

	for !rl.WindowShouldClose() {
		update()

		rl.BeginTextureMode(target)
		rl.ClearBackground({41, 173, 255, 255})

		rl.BeginMode2D(camera)
		draw()
		rl.EndMode2D()

		rl.EndTextureMode()

		utils_pkg.draw_to_screen(target)
	}
}

init :: proc() {

	player_pkg.init(&player, level.player_spawn)
	camera_pkg.init(&camera, player_pkg.center(&player))
}

update :: proc() {
	dt := rl.GetFrameTime()

	player_pkg.update(&player)
	update_body(&player.body, dt)

	camera_pkg.update(&camera, player_pkg.center(&player))

	free_all(context.temp_allocator)
}

draw :: proc() {
	level_pkg.draw(level)
	player_pkg.draw(&player)
	for rect in debug_rects {
		rl.DrawRectangleLinesEx(rect, 1, rl.RED)
	}
}

update_body :: proc(body: ^physics_pkg.Body, dt: f32) {
	body_rect := physics_pkg.rect(body)
	search_area := physics_pkg.expand_rect(body_rect, 10)

	nearby_rects := level_pkg.get_rects_in_area(&level, search_area)

	clear(&debug_rects)
	append(&debug_rects, ..nearby_rects[:])

	physics_pkg.move_and_collide(body, nearby_rects[:], dt)
}
