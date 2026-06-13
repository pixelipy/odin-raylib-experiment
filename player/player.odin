package player

import physics_pkg "../physics"
import animation_pkg "../animation"
import config_pkg "../config"
import rl "vendor:raylib"

SPEED :: 100.0
JUMP_FORCE :: 200.0
WIDTH :: 8
HEIGHT :: 8

Player :: struct {
	body:             physics_pkg.Body,
	texture:          rl.Texture2D,
	currentAnimation: ^animation_pkg.Animation,
	runAnimation:     animation_pkg.Animation,
	idleAnimation:    animation_pkg.Animation,
}

init :: proc(player: ^Player, pos: rl.Vector2) {
	player.body.position = pos
	player.body.velocity = {0, 0}
	player.body.size = {f32(WIDTH), f32(HEIGHT)}
	player.body.grounded = false

	player.texture = rl.LoadTexture("player/player.png")

	animation_pkg.init(&player.runAnimation, player.texture, 2, 0, WIDTH, HEIGHT, 4, 0.1)
	animation_pkg.init(&player.idleAnimation, player.texture, 0, 0, WIDTH, HEIGHT, 2, 0.4)

	player.currentAnimation = &player.idleAnimation
}

update :: proc(player: ^Player) {
	dt := rl.GetFrameTime()

	if rl.IsKeyDown(.LEFT) {
		player.body.velocity.x = -SPEED
		player.currentAnimation.flipped = true
	} else if rl.IsKeyDown(.RIGHT) {
		player.body.velocity.x = SPEED
		player.currentAnimation.flipped = false
	} else {
		player.body.velocity.x = 0
	}

	if abs(player.body.velocity.x) > 0 && player.currentAnimation != &player.runAnimation {
		animation_pkg.reset(&player.runAnimation, player.currentAnimation.flipped)
		player.currentAnimation = &player.runAnimation
	} else if player.body.velocity.x == 0 && player.currentAnimation != &player.idleAnimation {
		animation_pkg.reset(&player.idleAnimation, player.currentAnimation.flipped)
		player.currentAnimation = &player.idleAnimation
	}

	player.body.velocity.y += config_pkg.GRAVITY * dt

	if rl.IsKeyPressed(.SPACE) && player.body.grounded {
		player.body.velocity.y = -JUMP_FORCE
		player.body.grounded = false
	}

	animation_pkg.update(player.currentAnimation)
}

draw :: proc(player: ^Player) {
	rl.DrawTextureRec(
		player.texture,
		player.currentAnimation.rectangle,
		player.body.position,
		rl.WHITE,
	)
}

rect :: proc(player: ^Player) -> rl.Rectangle {
	return physics_pkg.rect(&player.body)
}

center :: proc(player: ^Player) -> rl.Vector2 {
	return physics_pkg.center(&player.body)
}
