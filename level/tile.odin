package level

import rl "vendor:raylib"

TILE_SIZE :: 8

TILE_KIND :: enum {
	Empty,
	Spawn,
	Ground,
}

Tile :: struct {
	x: f32,
	y: f32,
}

tile_rect :: proc(tile: Tile) -> rl.Rectangle {
	return rl.Rectangle{x = tile.x, y = tile.y, width = f32(TILE_SIZE), height = f32(TILE_SIZE)}
}

make_tile :: proc(x: i32, y: i32) -> Tile {
	return Tile{x = f32(x * TILE_SIZE), y = f32(y * TILE_SIZE)}
}

is_color :: proc(c: rl.Color, r, g, b: u8) -> bool {
	return c.r == r && c.g == g && c.b == b && c.a == 255
}

color_to_tile :: proc(c: rl.Color) -> TILE_KIND {
	if is_color(c, 0, 0, 0) do return .Ground
	if is_color(c, 0, 255, 0) do return .Spawn

	return .Empty
}

draw_tiles :: proc(tiles: []Tile) {
	for tile in tiles {
		r := tile_rect(tile)
		rl.DrawRectangleRec(r, rl.DARKGRAY)
	}
}
