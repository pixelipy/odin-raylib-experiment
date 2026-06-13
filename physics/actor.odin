package physics

import rl "vendor:raylib"

Body :: struct {
	position: rl.Vector2,
	velocity: rl.Vector2,
	size:     rl.Vector2,
	grounded: bool,
}

rect :: proc(body: ^Body) -> rl.Rectangle {
	return {x = body.position.x, y = body.position.y, width = body.size.x, height = body.size.y}
}

center :: proc(body: ^Body) -> rl.Vector2 {
	return {body.position.x + body.size.x / 2, body.position.y + body.size.y / 2}
}

move_and_collide :: proc(body: ^Body, solids: []rl.Rectangle, dt: f32) {
	result := move_rect(rect(body), body.velocity, solids, dt)

	body.position = result.position
	body.velocity = result.velocity
	body.grounded = result.hit_bottom
}
