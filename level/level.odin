package level

import rl "vendor:raylib"

Level :: struct {
	tiles:        [dynamic]Tile,
	rects:        [dynamic]rl.Rectangle,
	player_spawn: rl.Vector2,
}

load_level :: proc(src: cstring) -> Level {
	image := rl.LoadImage(src)
	defer rl.UnloadImage(image)

	pixels := rl.LoadImageColors(image)
	defer rl.UnloadImageColors(pixels)

	level: Level
	level.tiles = make([dynamic]Tile)
	level.rects = make([dynamic]rl.Rectangle)

	for y in 0..<image.height {
		for x in 0..<image.width {
			index := y * image.width + x
			color := pixels[index]

			tile_kind := color_to_tile(color)

			switch tile_kind {
			case .Ground:
				tile := make_tile(x, y)

				append(&level.tiles, tile)
				append(&level.rects, tile_rect(tile))

			case .Spawn:
				level.player_spawn = {
					f32(x * TILE_SIZE),
					f32(y * TILE_SIZE),
				}

			case .Empty:
			}
		}
	}

	return level
}

destroy :: proc(level: ^Level) {
	delete(level.tiles)
	delete(level.rects)
}

get_rects_in_area :: proc(level: ^Level, area: rl.Rectangle) -> [dynamic]rl.Rectangle {
	result := make([dynamic]rl.Rectangle, context.temp_allocator)

	for rect in level.rects {
		if rl.CheckCollisionRecs(area, rect) {
			append(&result, rect)
		}
	}

	return result
}

draw :: proc(level: Level) {
	draw_tiles(level.tiles[:])
}