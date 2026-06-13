package physics

import rl "vendor:raylib"

Collision_Result :: struct {
	position:   rl.Vector2,
	velocity:   rl.Vector2,
	hit_left:   bool,
	hit_right:  bool,
	hit_top:    bool,
	hit_bottom: bool,
}

expand_rect :: proc(rect: rl.Rectangle, amount: f32) -> rl.Rectangle {
	return {
		x = rect.x - amount,
		y = rect.y - amount,
		width = rect.width + amount * 2,
		height = rect.height + amount * 2,
	}
}

move_rect :: proc(
	rect: rl.Rectangle,
	velocity: rl.Vector2,
	solids: []rl.Rectangle,
	dt: f32,
) -> Collision_Result {
	result := Collision_Result {
		position = {rect.x, rect.y},
		velocity = velocity,
	}

	moving_rect := rect

	// X movement
	moving_rect.x += velocity.x * dt

	for solid in solids {
		if rl.CheckCollisionRecs(moving_rect, solid) {
			if velocity.x > 0 {
				moving_rect.x = solid.x - moving_rect.width
				result.hit_right = true
			} else if velocity.x < 0 {
				moving_rect.x = solid.x + solid.width
				result.hit_left = true
			}

			result.velocity.x = 0
		}
	}

	result.position.x = moving_rect.x

	// Y movement
	moving_rect.y += velocity.y * dt

	for solid in solids {
		if rl.CheckCollisionRecs(moving_rect, solid) {
			if velocity.y > 0 {
				moving_rect.y = solid.y - moving_rect.height
				result.hit_bottom = true
			} else if velocity.y < 0 {
				moving_rect.y = solid.y + solid.height
				result.hit_top = true
			}

			result.velocity.y = 0
		}
	}

	result.position.y = moving_rect.y

	return result
}
